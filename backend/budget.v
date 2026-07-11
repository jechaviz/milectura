module main

import strings

// ---------------------------------------------------------------------------
// RAM-safety, ported from v_projects/lib/vperf_core (bounded_bytes.v +
// ram_guard.v). The full vperf_core module pulls a heavy dep chain
// (vcli/vnum/vslug/livevit_telemetry) that would break the requirement of a
// single sqlite-only C for the Spaceship CGI build, so the two primitives this
// backend needs are ported inline:
//
//   • RespBuilder — a byte-budgeted string builder (bounded_bytes concept):
//     grows an O(n) strings.Builder but refuses to exceed cap_bytes, flipping
//     an `overflow` flag instead of allocating without bound.
//   • ram_guard decision — a response exceeding the budget FAILS FAST with 413
//     (ram_guard's "artifact-exceeds-budget -> fail"), so a pathological query
//     can never grow a multi-MB string and exhaust RAM / hang the process.
//
// This is what let the earlier O(n²) json_quote blow past RAM; the guard makes
// that class of failure a clean 413 rather than a memory-allocation panic.
// ---------------------------------------------------------------------------

// Hard ceiling for any single API response body. Real responses (one chapter,
// one day's plan, ≤100 search hits, one devotion) are tens of KB; 8 MB is far
// above legitimate traffic and well under what would stress a shared host.
pub const max_response_bytes = 8 * 1024 * 1024

// Per-response item ceilings (bounded_items concept) — belt-and-suspenders so a
// single response can't assemble an unbounded number of rows even if a module
// is malformed.
pub const max_verses_per_response = 400
pub const max_plan_chapters = 12

@[heap]
pub struct RespBuilder {
mut:
	b         strings.Builder
	cap_bytes int
pub mut:
	overflow bool
}

pub fn new_resp() RespBuilder {
	return RespBuilder{
		b:         strings.new_builder(8192)
		cap_bytes: max_response_bytes
	}
}

// write appends s unless doing so would exceed the byte budget; once the budget
// is hit `overflow` latches true and further writes are dropped.
pub fn (mut r RespBuilder) write(s string) {
	if r.overflow {
		return
	}
	if r.b.len + s.len > r.cap_bytes {
		r.overflow = true
		return
	}
	r.b.write_string(s)
}

pub fn (mut r RespBuilder) finish() string {
	return r.b.str()
}

// guarded_json returns body as a 200 unless it exceeds the budget, in which
// case it fails fast with 413 (ram_guard's fail decision) rather than shipping
// a response big enough to strain the host.
fn guarded_json(body string) Response {
	if body.len > max_response_bytes {
		return err_json(413, 'respuesta demasiado grande')
	}
	return ok_json(body)
}
