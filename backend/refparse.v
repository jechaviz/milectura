module main

import db.sqlite

// ---------------------------------------------------------------------------
// Spanish bible reference parser: "Juan 3:16-18", "1 Corintios 13", "Sal 23",
// "Gn 1:1". Book names come from the module's own books table (short + long),
// matched accent- and case-insensitively.
// ---------------------------------------------------------------------------

pub struct Ref {
pub mut:
	book    int
	chapter int
	v1      int // 0 = whole chapter
	v2      int
}

// fold_accents lowercases and strips Spanish diacritics (UTF-8 aware for the
// characters that actually occur in book names).
pub fn fold_accents(s string) string {
	mut out := s.to_lower()
	pairs := {
		'á': 'a'
		'é': 'e'
		'í': 'i'
		'ó': 'o'
		'ú': 'u'
		'ü': 'u'
		'ñ': 'n'
		'Á': 'a'
		'É': 'e'
		'Í': 'i'
		'Ó': 'o'
		'Ú': 'u'
		'Ñ': 'n'
	}
	for k, v in pairs {
		out = out.replace(k, v)
	}
	return out
}

fn norm_book_key(s string) string {
	mut n := fold_accents(s)
	n = n.replace('.', '')
	n = n.replace(' ', '')
	return n
}

// book_map builds normalized-name -> book_number from the module's books.
pub fn book_map(mut db sqlite.DB) map[string]int {
	mut m := map[string]int{}
	for b in get_books(mut db) {
		m[norm_book_key(b.short)] = b.number
		m[norm_book_key(b.name)] = b.number
	}
	return m
}

// parse_ref parses ONE reference. Returns none when the book is unknown.
pub fn parse_ref(bm map[string]int, ref string) ?Ref {
	mut s := ref.trim_space()
	if s == '' {
		return none
	}
	// find the split between book name and chapter spec: the first digit that
	// is not part of a leading ordinal ("1 Juan", "2 Reyes", "3 Jn")
	mut start := 0
	if s.len > 1 && s[0] >= `1` && s[0] <= `3` {
		// leading ordinal: "1 Juan", "2. Reyes", or compact "1Co"
		start = if s[1] == ` ` || s[1] == `.` { 2 } else { 1 }
	}
	mut split := -1
	for i := start; i < s.len; i++ {
		if s[i] >= `0` && s[i] <= `9` {
			split = i
			break
		}
	}
	mut book_part := s
	mut num_part := ''
	if split > 0 {
		book_part = s[..split].trim_space()
		num_part = s[split..].trim_space()
	}
	book := bm[norm_book_key(book_part)]
	if book == 0 {
		return none
	}
	mut r := Ref{
		book: book
	}
	if num_part == '' {
		r.chapter = 1
		return r
	}
	// chapter[:v1[-v2]]
	cv := num_part.split(':')
	r.chapter = cv[0].trim_space().int()
	if r.chapter < 1 {
		r.chapter = 1
	}
	if cv.len > 1 {
		vr := cv[1].split('-')
		r.v1 = vr[0].trim_space().int()
		r.v2 = if vr.len > 1 { vr[1].trim_space().int() } else { r.v1 }
		if r.v2 < r.v1 {
			r.v2 = r.v1
		}
	}
	return r
}

// parse_refs splits "Juan 3:16; Salmos 23" on ';' and parses each part.
pub fn parse_refs(bm map[string]int, refs string) []Ref {
	mut out := []Ref{}
	for part in refs.split(';') {
		if r := parse_ref(bm, part) {
			out << r
		}
	}
	return out
}

// day_of_year converts YYYY-MM-DD (1..366). Bad input returns 0.
pub fn day_of_year(date string) int {
	p := date.split('-')
	if p.len != 3 {
		return 0
	}
	y := p[0].int()
	mo := p[1].int()
	d := p[2].int()
	if y < 1 || mo < 1 || mo > 12 || d < 1 || d > 31 {
		return 0
	}
	mut days_in := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 {
		days_in[1] = 29
	}
	mut doy := d
	for i := 0; i < mo - 1; i++ {
		doy += days_in[i]
	}
	return doy
}
