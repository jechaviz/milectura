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

// all_chapters enumerates every (book, chapter) WITHOUT scanning all 31k verses.
// The old `GROUP BY book_number, chapter` touched every row group; instead we
// read one max-chapter-per-book (chapter_counts: ~66 index seeks) and expand the
// contiguous chapter range in memory (1189 tiny structs). Canonical bibles have
// no chapter gaps, so 1..max is exact.
fn all_chapters(mut db sqlite.DB) []ChapterId {
	counts := chapter_counts(mut db)
	mut books := counts.keys()
	books.sort()
	mut out := []ChapterId{}
	for b in books {
		for c := 1; c <= counts[b]; c++ {
			out << ChapterId{
				book:    b
				chapter: c
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
	// New Testament: one chapter EVERY day, cycling through the NT (~1.4×/year) so
	// each daily reading always includes the NT (shown pinned, first).
	mut nt_sel := []ChapterId{}
	if nt.len > 0 {
		nt_sel << nt[(d - 1) % nt.len]
	}
	// Old Testament: proportional slice across the year, but always ≥1 chapter.
	ot_from := (d - 1) * ot.len / 365
	mut ot_to := d * ot.len / 365
	if ot_to <= ot_from {
		ot_to = ot_from + 1
	}
	mut ot_sel := []ChapterId{}
	for i := ot_from; i < ot_to && i < ot.len && ot_sel.len < max_plan_chapters; i++ {
		ot_sel << ot[i]
	}
	return ot_sel, nt_sel
}
