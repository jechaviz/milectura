module main

import db.sqlite
import rand

// ---------------------------------------------------------------------------
// JSON API. All read-only; every handler resolves the requested module id
// against the scanned registry (find_module), never against raw paths.
// ---------------------------------------------------------------------------

fn register_routes(mut r Router) {
	r.get('/api/health', h_health)
	r.get('/api/modules', h_modules)
	r.get('/api/books', h_books)
	r.get('/api/chapter', h_chapter)
	r.get('/api/passage', h_passage)
	r.get('/api/votd', h_votd)
	r.get('/api/plan', h_plan)
	r.get('/api/search', h_search)
	r.get('/api/commentary', h_commentary)
	r.get('/api/dict', h_dict)
	r.get('/api/dictsearch', h_dict_search)
	r.get('/api/devotion', h_devotion)
	r.get('/api/random', h_random)
}

fn h_health(mut app App, mut req Request) Response {
	mut bibles := 0
	for m in app.modules {
		if m.kind == .bible {
			bibles++
		}
	}
	return ok_json('{"ok":true,"modules":${app.modules.len},"bibles":${bibles}}')
}

// GET /api/modules — the whole registry grouped by kind
fn h_modules(mut app App, mut req Request) Response {
	mut parts := []string{}
	for m in app.modules {
		parts << '{"id":${json_quote(m.id)},"kind":${json_quote(kind_str(m.kind))},"description":${json_quote(m.description)},"language":${json_quote(m.language)}}'
	}
	return ok_json('{"default":${json_quote(app.default_bible())},"modules":[${parts.join(',')}]}')
}

fn bible_param(app &App, req &Request) string {
	v := req.query['v']
	if v != '' {
		return v
	}
	return app.default_bible()
}

// GET /api/books?v=RVR60
fn h_books(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	books := get_books(mut db)
	mut parts := []string{}
	for b in books {
		mc := max_chapter(mut db, b.number)
		parts << '{"n":${b.number},"short":${json_quote(b.short)},"name":${json_quote(b.name)},"color":${json_quote(b.color)},"chapters":${mc}}'
	}
	return ok_json('{"version":${json_quote(vid)},"books":[${parts.join(',')}]}')
}

fn verses_json(verses []VerseRow) string {
	mut parts := []string{}
	for v in verses {
		parts << '{"v":${v.verse},"t":${json_quote(v.text)}}'
	}
	return '[${parts.join(',')}]'
}

fn subheadings_json(subs map[int]string) string {
	mut parts := []string{}
	for k, v in subs {
		parts << '"${k}":${json_quote(v)}'
	}
	return '{${parts.join(',')}}'
}

// GET /api/chapter?v=RVR60&b=500&c=3[&sub=RV60-s.subheadings]
fn h_chapter(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	b := req.query['b'].int()
	c := req.query['c'].int()
	if b == 0 || c == 0 {
		return err_json(422, 'parámetros b y c requeridos')
	}
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	verses := get_verses(mut db, b, c)
	if verses.len == 0 {
		return err_json(404, 'capítulo no encontrado')
	}
	mut subs := get_subheadings(mut db, b, c)
	if sub_id := getq(req, 'sub') {
		if mut sdb := app.open_module(sub_id) {
			ext := get_subheadings(mut sdb, b, c)
			for k, v in ext {
				subs[k] = v
			}
			sdb.close() or {}
		}
	}
	mc := max_chapter(mut db, b)
	books := get_books(mut db)
	mut bname := ''
	mut bshort := ''
	for bk in books {
		if bk.number == b {
			bname = bk.name
			bshort = bk.short
			break
		}
	}
	return guarded_json('{"version":${json_quote(vid)},"book":${b},"bookName":${json_quote(bname)},"bookShort":${json_quote(bshort)},"chapter":${c},"maxChapter":${mc},"verses":${verses_json(verses)},"subheadings":${subheadings_json(subs)}}')
}

fn getq(req &Request, key string) ?string {
	v := req.query[key]
	return if v == '' { none } else { v }
}

// GET /api/passage?v=RVR60&ref=Juan 3:16-18;Salmos 23
fn h_passage(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	refs := req.query['ref']
	if refs == '' {
		return err_json(422, 'parámetro ref requerido')
	}
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	bm := book_map(mut db)
	parsed := parse_refs(bm, refs)
	if parsed.len == 0 {
		return err_json(404, 'referencia no reconocida: ${refs}')
	}
	books := get_books(mut db)
	mut parts := []string{}
	for r in parsed {
		verses := if r.v1 > 0 {
			get_verse_range(mut db, r.book, r.chapter, r.v1, r.v2)
		} else {
			get_verses(mut db, r.book, r.chapter)
		}
		mut bname := ''
		for bk in books {
			if bk.number == r.book {
				bname = bk.name
				break
			}
		}
		mut label := '${bname} ${r.chapter}'
		if r.v1 > 0 {
			label += ':${r.v1}'
			if r.v2 > r.v1 {
				label += '-${r.v2}'
			}
		}
		parts << '{"ref":${json_quote(label)},"book":${r.book},"chapter":${r.chapter},"verses":${verses_json(verses)}}'
	}
	return guarded_json('{"version":${json_quote(vid)},"passages":[${parts.join(',')}]}')
}

// GET /api/votd?v=RVR60&date=2026-07-11
fn h_votd(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	doy := day_of_year(req.query['date'])
	if doy == 0 {
		return err_json(422, 'parámetro date=YYYY-MM-DD requerido')
	}
	r := votd_for_day(doy)
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	verses := get_verse_range(mut db, r.b, r.c, r.v1, r.v2)
	books := get_books(mut db)
	mut bname := ''
	for bk in books {
		if bk.number == r.b {
			bname = bk.name
			break
		}
	}
	mut label := '${bname} ${r.c}:${r.v1}'
	if r.v2 > r.v1 {
		label += '-${r.v2}'
	}
	mut desc := ''
	if mi := app.find_module(vid) {
		desc = mi.description
	}
	return ok_json('{"version":${json_quote(vid)},"versionName":${json_quote(desc)},"ref":${json_quote(label)},"book":${r.b},"chapter":${r.c},"verses":${verses_json(verses)}}')
}

// GET /api/plan?v=RVR60&date=2026-07-11 — the day's OT + NT reading, full text
fn h_plan(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	doy := day_of_year(req.query['date'])
	if doy == 0 {
		return err_json(422, 'parámetro date=YYYY-MM-DD requerido')
	}
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	ot, nt := plan_for_day(mut db, doy)
	books := get_books(mut db)
	mut bnames := map[int]string{}
	for bk in books {
		bnames[bk.number] = bk.name
	}
	mut ot_parts := []string{}
	for ch in ot {
		verses := get_verses(mut db, ch.book, ch.chapter)
		subs := get_subheadings(mut db, ch.book, ch.chapter)
		label := '${bnames[ch.book]} ${ch.chapter}'
		ot_parts << '{"ref":${json_quote(label)},"book":${ch.book},"chapter":${ch.chapter},"verses":${verses_json(verses)},"subheadings":${subheadings_json(subs)}}'
	}
	mut nt_parts := []string{}
	for ch in nt {
		verses := get_verses(mut db, ch.book, ch.chapter)
		subs := get_subheadings(mut db, ch.book, ch.chapter)
		label := '${bnames[ch.book]} ${ch.chapter}'
		nt_parts << '{"ref":${json_quote(label)},"book":${ch.book},"chapter":${ch.chapter},"verses":${verses_json(verses)},"subheadings":${subheadings_json(subs)}}'
	}
	return guarded_json('{"version":${json_quote(vid)},"day":${doy},"ot":[${ot_parts.join(',')}],"nt":[${nt_parts.join(',')}]}')
}

// GET /api/search?v=RVR60&q=corazon&limit=50&book=230
// Accent-insensitive: accented letters in the query (and their unaccented
// forms) are folded to the single-char LIKE wildcard '_'.
fn h_search(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	q := req.query['q'].trim_space()
	if q.len < 3 {
		return err_json(422, 'la búsqueda requiere al menos 3 caracteres')
	}
	mut limit := req.query['limit'].int()
	if limit < 1 || limit > 100 {
		limit = 50
	}
	book_filter := req.query['book'].int()
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	// fold: any letter that could carry an accent becomes '_'
	folded := fold_accents(q)
	mut pattern := ''
	for c in folded {
		pattern += match c {
			`a`, `e`, `i`, `o`, `u`, `n` { '_' }
			else { c.ascii_str() }
		}
	}
	where_book := if book_filter > 0 { ' AND book_number=${book_filter}' } else { '' }
	rows := db.exec("SELECT book_number, chapter, verse, text FROM verses WHERE text LIKE '%${sql_escape(pattern)}%'${where_book} LIMIT ${limit + 1}") or {
		return err_json(500, 'error de búsqueda')
	}
	books := get_books(mut db)
	mut bnames := map[int]string{}
	for bk in books {
		bnames[bk.number] = bk.name
	}
	mut parts := []string{}
	mut n := 0
	for r in rows {
		if n >= limit {
			break
		}
		if r.vals.len < 4 {
			continue
		}
		b := r.vals[0].int()
		c := r.vals[1].int()
		v := r.vals[2].int()
		t := clean_verse(r.vals[3])
		label := '${bnames[b]} ${c}:${v}'
		parts << '{"ref":${json_quote(label)},"book":${b},"chapter":${c},"verse":${v},"t":${json_quote(t)}}'
		n++
	}
	more := rows.len > limit
	return guarded_json('{"version":${json_quote(vid)},"q":${json_quote(q)},"more":${more},"results":[${parts.join(',')}]}')
}

// GET /api/commentary?m=RVR60.commentaries&b=500&c=3
fn h_commentary(mut app App, mut req Request) Response {
	mid := req.query['m']
	b := req.query['b'].int()
	c := req.query['c'].int()
	if mid == '' || b == 0 || c == 0 {
		return err_json(422, 'parámetros m, b y c requeridos')
	}
	mut db := app.open_module(mid) or { return err_json(404, 'módulo no encontrado: ${mid}') }
	defer {
		db.close() or {}
	}
	rows := db.exec('SELECT verse_number_from, verse_number_to, marker, text FROM commentaries WHERE book_number=${b} AND chapter_number_from=${c} ORDER BY verse_number_from') or {
		return err_json(500, 'error al leer comentarios')
	}
	mut parts := []string{}
	for r in rows {
		if r.vals.len < 4 {
			continue
		}
		parts << '{"from":${r.vals[0].int()},"to":${r.vals[1].int()},"marker":${json_quote(r.vals[2])},"text":${json_quote(r.vals[3])}}'
	}
	return guarded_json('{"module":${json_quote(mid)},"book":${b},"chapter":${c},"entries":[${parts.join(',')}]}')
}

// GET /api/dict?m=DicRV.dictionary&topic=AARÓN
fn h_dict(mut app App, mut req Request) Response {
	mid := req.query['m']
	topic := req.query['topic'].trim_space()
	if mid == '' || topic == '' {
		return err_json(422, 'parámetros m y topic requeridos')
	}
	mut db := app.open_module(mid) or { return err_json(404, 'módulo no encontrado: ${mid}') }
	defer {
		db.close() or {}
	}
	rows := db.exec("SELECT topic, definition FROM dictionary WHERE topic='${sql_escape(topic)}' COLLATE NOCASE LIMIT 1") or {
		return err_json(500, 'error al leer diccionario')
	}
	if rows.len == 0 || rows[0].vals.len < 2 {
		return err_json(404, 'tema no encontrado')
	}
	return ok_json('{"topic":${json_quote(rows[0].vals[0])},"definition":${json_quote(rows[0].vals[1])}}')
}

// GET /api/dictsearch?m=DicRV.dictionary&q=amor
fn h_dict_search(mut app App, mut req Request) Response {
	mid := req.query['m']
	q := req.query['q'].trim_space()
	if mid == '' || q.len < 2 {
		return err_json(422, 'parámetros m y q (≥2) requeridos')
	}
	mut db := app.open_module(mid) or { return err_json(404, 'módulo no encontrado: ${mid}') }
	defer {
		db.close() or {}
	}
	folded := fold_accents(q)
	mut pattern := ''
	for c in folded {
		pattern += match c {
			`a`, `e`, `i`, `o`, `u`, `n` { '_' }
			else { c.ascii_str() }
		}
	}
	rows := db.exec("SELECT topic FROM dictionary WHERE topic LIKE '${sql_escape(pattern)}%' LIMIT 40") or {
		return err_json(500, 'error de búsqueda')
	}
	mut parts := []string{}
	for r in rows {
		if r.vals.len > 0 {
			parts << json_quote(r.vals[0])
		}
	}
	return ok_json('{"topics":[${parts.join(',')}]}')
}

// GET /api/devotion?m=WC-es.devotions&date=2026-07-11
fn h_devotion(mut app App, mut req Request) Response {
	mut mid := req.query['m']
	if mid == '' {
		for m in app.modules {
			if m.kind == .devotions {
				mid = m.id
				break
			}
		}
	}
	if mid == '' {
		return err_json(404, 'no hay módulo de devocionales')
	}
	doy := day_of_year(req.query['date'])
	if doy == 0 {
		return err_json(422, 'parámetro date=YYYY-MM-DD requerido')
	}
	mut db := app.open_module(mid) or { return err_json(404, 'módulo no encontrado: ${mid}') }
	defer {
		db.close() or {}
	}
	rows := db.exec('SELECT devotion FROM devotions WHERE day=${doy} LIMIT 1') or {
		return err_json(500, 'error al leer devocional')
	}
	if rows.len == 0 || rows[0].vals.len == 0 {
		return err_json(404, 'sin devocional para el día ${doy}')
	}
	mut text := rows[0].vals[0]
	text = expand_fragments(mut db, text)
	text = strip_scripts(text)
	mut desc := ''
	if mi := app.find_module(mid) {
		desc = mi.description
	}
	return guarded_json('{"module":${json_quote(mid)},"name":${json_quote(desc)},"day":${doy},"html":${json_quote(text)}}')
}

// expand_fragments replaces <!-- INCLUDE(ID) --> with content_fragments rows.
fn expand_fragments(mut db sqlite.DB, text string) string {
	mut out := text
	for _ in 0 .. 10 { // no runaway recursion
		i := out.index('<!-- INCLUDE(') or { break }
		j := out.index_after(') -->', i) or { break }
		id := out[i + '<!-- INCLUDE('.len..j]
		rows := db.exec("SELECT fragment FROM content_fragments WHERE id='${sql_escape(id)}' LIMIT 1") or {
			[]sqlite.Row{}
		}
		frag := if rows.len > 0 && rows[0].vals.len > 0 { rows[0].vals[0] } else { '' }
		out = out[..i] + frag + out[j + ') -->'.len..]
	}
	return out
}

// strip_scripts removes <script>..</script> blocks from module HTML (defense
// in depth; modules are trusted-ish but rendered with v-html).
fn strip_scripts(s string) string {
	mut out := s
	for {
		low := out.to_lower()
		i := low.index('<script') or { break }
		j := low.index_after('</script>', i) or { break }
		out = out[..i] + out[j + '</script>'.len..]
	}
	return out
}

// GET /api/random?v=RVR60 — a random verse (excluding genealogy-heavy books is
// overkill; any verse is fine for the "sorpréndeme" feature)
fn h_random(mut app App, mut req Request) Response {
	vid := bible_param(app, req)
	mut db := app.open_module(vid) or { return err_json(404, 'módulo no encontrado: ${vid}') }
	defer {
		db.close() or {}
	}
	crows := db.exec('SELECT count(*) FROM verses') or { return err_json(500, 'error') }
	total := if crows.len > 0 { crows[0].vals[0].int() } else { 0 }
	if total == 0 {
		return err_json(404, 'módulo vacío')
	}
	off := rand.intn(total) or { 0 }
	rows := db.exec('SELECT book_number, chapter, verse, text FROM verses LIMIT 1 OFFSET ${off}') or {
		return err_json(500, 'error')
	}
	if rows.len == 0 || rows[0].vals.len < 4 {
		return err_json(500, 'error')
	}
	b := rows[0].vals[0].int()
	c := rows[0].vals[1].int()
	v := rows[0].vals[2].int()
	t := clean_verse(rows[0].vals[3])
	books := get_books(mut db)
	mut bname := ''
	for bk in books {
		if bk.number == b {
			bname = bk.name
			break
		}
	}
	label := '${bname} ${c}:${v}'
	return ok_json('{"version":${json_quote(vid)},"ref":${json_quote(label)},"book":${b},"chapter":${c},"verse":${v},"t":${json_quote(t)}}')
}
