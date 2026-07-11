module main

import db.sqlite

// ---------------------------------------------------------------------------
// Yearly "old-new-testament" reading plan (same spirit as the plan the legacy
// site scraped from BibleGateway): every day one Old Testament portion and one
// New Testament portion; the whole Bible in a year. Computed from the module's
// own chapter list, so it works for any bible module.
// ---------------------------------------------------------------------------

pub struct ChapterId {
pub mut:
	book    int
	chapter int
}

fn all_chapters(mut db sqlite.DB) []ChapterId {
	rows := db.exec('SELECT book_number, chapter FROM verses GROUP BY book_number, chapter ORDER BY book_number, chapter') or {
		[]sqlite.Row{}
	}
	mut out := []ChapterId{}
	for r in rows {
		if r.vals.len >= 2 {
			out << ChapterId{
				book:    r.vals[0].int()
				chapter: r.vals[1].int()
			}
		}
	}
	return out
}

// plan_for_day slices OT and NT chapter sequences proportionally across 365
// days (day 366 = day 365). Deterministic: same date -> same reading.
pub fn plan_for_day(mut db sqlite.DB, day int) ([]ChapterId, []ChapterId) {
	mut d := day
	if d < 1 {
		d = 1
	}
	if d > 365 {
		d = 365
	}
	chapters := all_chapters(mut db)
	mut ot := []ChapterId{}
	mut nt := []ChapterId{}
	for c in chapters {
		if c.book < 470 {
			ot << c
		} else {
			nt << c
		}
	}
	ot_from := (d - 1) * ot.len / 365
	ot_to := d * ot.len / 365
	nt_from := (d - 1) * nt.len / 365
	nt_to := d * nt.len / 365
	mut ot_sel := []ChapterId{}
	mut nt_sel := []ChapterId{}
	for i := ot_from; i < ot_to && i < ot.len && ot_sel.len < max_plan_chapters; i++ {
		ot_sel << ot[i]
	}
	for i := nt_from; i < nt_to && i < nt.len && nt_sel.len < max_plan_chapters; i++ {
		nt_sel << nt[i]
	}
	return ot_sel, nt_sel
}
