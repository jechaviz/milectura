module main

import db.sqlite
import os

// ---------------------------------------------------------------------------
// MyBible (ph4.org) module support. Every module is a standalone SQLite file:
//   <ID>.SQLite3                — bible text     (books/verses/stories/info)
//   <ID>.commentaries.SQLite3   — commentaries   (commentaries/info)
//   <ID>.dictionary.SQLite3     — dictionary     (dictionary/info)
//   <ID>.devotions.SQLite3      — daily devotion (devotions/content_fragments)
//   <ID>.subheadings.SQLite3    — section titles (subheadings/info)
// Drop modules into modules_dir and they appear in /api/modules.
// ---------------------------------------------------------------------------

pub enum ModKind {
	bible
	commentaries
	dictionary
	devotions
	subheadings
	crossreferences
	other
}

pub struct ModInfo {
pub mut:
	id          string // file name without .SQLite3 (e.g. RVR60, WC-es.devotions)
	kind        ModKind
	path        string
	description string
	language    string
}

fn kind_str(k ModKind) string {
	return match k {
		.bible { 'bible' }
		.commentaries { 'commentaries' }
		.dictionary { 'dictionary' }
		.devotions { 'devotions' }
		.subheadings { 'subheadings' }
		.crossreferences { 'crossreferences' }
		.other { 'other' }
	}
}

fn classify_module(base string) ModKind {
	b := base.to_lower()
	if b.ends_with('.commentaries') {
		return .commentaries
	}
	if b.ends_with('.dictionary') {
		return .dictionary
	}
	if b.ends_with('.devotions') {
		return .devotions
	}
	if b.ends_with('.subheadings') {
		return .subheadings
	}
	if b.ends_with('.crossreferences') {
		return .crossreferences
	}
	if b.contains('.plan') {
		return .other
	}
	return .bible
}

// scan_modules lists *.SQLite3 in dir and reads each module's info table.
pub fn scan_modules(dir string) []ModInfo {
	mut mods := []ModInfo{}
	files := os.ls(dir) or { return mods }
	for f in files {
		lf := f.to_lower()
		if !lf.ends_with('.sqlite3') {
			continue
		}
		base := f[..f.len - '.SQLite3'.len]
		path := os.join_path(dir, f)
		mut mi := ModInfo{
			id:   base
			kind: classify_module(base)
			path: path
		}
		if db := sqlite.connect(path) {
			mut d := db
			rows := d.exec("SELECT name, value FROM info WHERE name IN ('description','language')") or {
				[]sqlite.Row{}
			}
			for r in rows {
				if r.vals.len >= 2 {
					if r.vals[0] == 'description' {
						mi.description = r.vals[1]
					} else if r.vals[0] == 'language' {
						mi.language = r.vals[1]
					}
				}
			}
			d.close() or {}
		}
		mods << mi
	}
	return mods
}

// find_module resolves a client-supplied id against the scanned registry —
// this is the only path from a request parameter to the filesystem.
pub fn (app &App) find_module(id string) ?ModInfo {
	for m in app.modules {
		if m.id == id {
			return m
		}
	}
	return none
}

pub fn (app &App) open_module(id string) ?sqlite.DB {
	mi := app.find_module(id) or { return none }
	db := sqlite.connect(mi.path) or { return none }
	return db
}

// default_bible picks the first bible module (RVR60 preferred).
pub fn (app &App) default_bible() string {
	for m in app.modules {
		if m.kind == .bible && m.id == 'RVR60' {
			return m.id
		}
	}
	for m in app.modules {
		if m.kind == .bible {
			return m.id
		}
	}
	return ''
}

// ---- book / verse queries ---------------------------------------------------

pub struct Book {
pub mut:
	number int
	short  string
	name   string
	color  string
}

pub fn get_books(mut db sqlite.DB) []Book {
	mut out := []Book{}
	mut rows := db.exec('SELECT book_number, short_name, long_name, book_color FROM books ORDER BY book_number') or {
		[]sqlite.Row{}
	}
	if rows.len == 0 {
		rows = db.exec('SELECT book_number, short_name, long_name, book_color FROM books_all WHERE is_present=1 ORDER BY book_number') or {
			[]sqlite.Row{}
		}
	}
	for r in rows {
		if r.vals.len >= 3 {
			out << Book{
				number: r.vals[0].int()
				short:  r.vals[1]
				name:   r.vals[2]
				color:  if r.vals.len > 3 { r.vals[3] } else { '' }
			}
		}
	}
	return out
}

pub struct VerseRow {
pub mut:
	verse int
	text  string
}

pub fn get_verses(mut db sqlite.DB, book int, chapter int) []VerseRow {
	rows := db.exec('SELECT verse, text FROM verses WHERE book_number=${book} AND chapter=${chapter} ORDER BY verse') or {
		[]sqlite.Row{}
	}
	mut out := []VerseRow{}
	for r in rows {
		if out.len >= max_verses_per_response {
			break
		}
		if r.vals.len >= 2 {
			out << VerseRow{
				verse: r.vals[0].int()
				text:  clean_verse(r.vals[1])
			}
		}
	}
	return out
}

pub fn get_verse_range(mut db sqlite.DB, book int, chapter int, v1 int, v2 int) []VerseRow {
	rows := db.exec('SELECT verse, text FROM verses WHERE book_number=${book} AND chapter=${chapter} AND verse>=${v1} AND verse<=${v2} ORDER BY verse') or {
		[]sqlite.Row{}
	}
	mut out := []VerseRow{}
	for r in rows {
		if out.len >= max_verses_per_response {
			break
		}
		if r.vals.len >= 2 {
			out << VerseRow{
				verse: r.vals[0].int()
				text:  clean_verse(r.vals[1])
			}
		}
	}
	return out
}

pub fn max_chapter(mut db sqlite.DB, book int) int {
	// max(chapter) over the PK prefix (book_number,chapter,verse) — SQLite serves
	// it from the index (one seek to the last matching row), O(log n), no scan.
	rows := db.exec('SELECT max(chapter) FROM verses WHERE book_number=${book}') or {
		[]sqlite.Row{}
	}
	if rows.len > 0 && rows[0].vals.len > 0 {
		return rows[0].vals[0].int()
	}
	return 0
}

// chapter_counts returns book_number -> last chapter in ONE query. `max(chapter)
// GROUP BY book_number` is an index max-per-group over the PK, i.e. ~66 index
// seeks — NOT a full 31k-row scan. Replaces both the per-book max_chapter loop
// (h_books) and the whole-bible `GROUP BY book,chapter` enumeration (plan).
pub fn chapter_counts(mut db sqlite.DB) map[int]int {
	rows := db.exec('SELECT book_number, max(chapter) FROM verses GROUP BY book_number') or {
		[]sqlite.Row{}
	}
	mut m := map[int]int{}
	for r in rows {
		if r.vals.len >= 2 {
			m[r.vals[0].int()] = r.vals[1].int()
		}
	}
	return m
}

// max_verse: last verse of a chapter via the PK prefix — one index seek.
pub fn max_verse(mut db sqlite.DB, book int, chapter int) int {
	rows := db.exec('SELECT max(verse) FROM verses WHERE book_number=${book} AND chapter=${chapter}') or {
		[]sqlite.Row{}
	}
	if rows.len > 0 && rows[0].vals.len > 0 {
		return rows[0].vals[0].int()
	}
	return 0
}

// book_short_long fetches one book's names by PK — one index seek, instead of
// loading all 66 books and scanning them linearly for a single name.
pub fn book_short_long(mut db sqlite.DB, num int) (string, string) {
	rows := db.exec('SELECT short_name, long_name FROM books WHERE book_number=${num} LIMIT 1') or {
		return '', ''
	}
	if rows.len > 0 && rows[0].vals.len >= 2 {
		return rows[0].vals[0], rows[0].vals[1]
	}
	return '', ''
}

pub fn book_name(mut db sqlite.DB, num int) string {
	_, long := book_short_long(mut db, num)
	return long
}

// get_subheadings reads section titles for a chapter. Works both against a
// bible module's own `stories` table and a *.subheadings module's table.
pub fn get_subheadings(mut db sqlite.DB, book int, chapter int) map[int]string {
	mut out := map[int]string{}
	mut rows := db.exec('SELECT verse, title FROM stories WHERE book_number=${book} AND chapter=${chapter} ORDER BY verse, order_if_several') or {
		[]sqlite.Row{}
	}
	if rows.len == 0 {
		rows = db.exec('SELECT verse, subheading FROM subheadings WHERE book_number=${book} AND chapter=${chapter} ORDER BY verse, order_if_several') or {
			[]sqlite.Row{}
		}
	}
	for r in rows {
		if r.vals.len >= 2 {
			v := r.vals[0].int()
			t := strip_all_tags(r.vals[1]).trim_space()
			if t == '' {
				continue
			}
			if v in out {
				out[v] = out[v] + ' · ' + t
			} else {
				out[v] = t
			}
		}
	}
	return out
}

// ---- MyBible text markup cleanup ---------------------------------------------
// Verse text carries markup like <S>1234</S> (Strong), <m>..</m> (morphology),
// <f>[1]</f> (footnote markers), <pb/> (paragraph break), <br/>, <J>..</J>
// (words of Jesus), <i>/<e> (emphasis), <t>..</t> (poetry indent).
// We strip Strong/morphology/footnotes server-side and keep the presentational
// tags for the frontend to style.

pub fn clean_verse(text string) string {
	mut s := text
	s = remove_tag_with_content(s, 'S') // Strong numbers
	s = remove_tag_with_content(s, 'm') // morphology
	s = remove_tag_with_content(s, 'f') // footnote body
	s = remove_tag_with_content(s, 'n') // footnote marker e.g. <n>[1]</n>
	s = s.replace('<pb/>', '')
	s = s.replace('<br/>', ' ')
	// keep presentational tags (<e> translator words, <i> italics, <t> poetry
	// indent, <J> words of Jesus) for the frontend to style.
	s = s.replace('  ', ' ')
	return s.trim_space()
}

fn remove_tag_with_content(s string, tag string) string {
	open := '<${tag}>'
	close := '</${tag}>'
	mut out := s
	for {
		i := out.index(open) or { break }
		j := out.index_after(close, i) or { break }
		out = out[..i] + out[j + close.len..]
	}
	return out
}

pub fn strip_all_tags(s string) string {
	mut out := []u8{}
	mut inside := false
	for c in s {
		if c == `<` {
			inside = true
		} else if c == `>` {
			inside = false
		} else if !inside {
			out << c
		}
	}
	return out.bytestr()
}
