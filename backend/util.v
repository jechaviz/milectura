module main

import os
import strings

// repo root = parent of backend/ (so the V server can also host the static site in dev)
const site_root = os.dir(os.dir(os.real_path(os.args[0])))

pub struct Config {
pub mut:
	port        int    = 8091
	modules_dir string // where the MyBible .SQLite3 modules live
	base_path   string // e.g. /milectura when hosted under appniverse.com/milectura
	site_url    string = 'https://appniverse.com/milectura'
}

// load_config reads backend/.env (KEY=VALUE) then the environment.
fn load_config() Config {
	load_dotenv('.env')
	mut c := Config{}
	c.modules_dir = os.join_path(site_root, 'modules')
	if v := getenv_opt('ML_PORT') {
		c.port = v.int()
	}
	if v := getenv_opt('ML_MODULES') {
		c.modules_dir = v
	}
	if v := getenv_opt('ML_BASE_PATH') {
		c.base_path = v
	}
	if v := getenv_opt('ML_SITE_URL') {
		c.site_url = v
	}
	return c
}

fn getenv_opt(key string) ?string {
	v := os.getenv(key)
	return if v == '' { none } else { v }
}

fn load_dotenv(path string) {
	if !os.exists(path) {
		return
	}
	content := os.read_file(path) or { return }
	for line in content.split_into_lines() {
		l := line.trim_space()
		if l == '' || l.starts_with('#') {
			continue
		}
		if eq := l.index('=') {
			k := l[..eq].trim_space()
			mut val := l[eq + 1..].trim_space()
			if val.len >= 2 && (val.starts_with('"') || val.starts_with("'")) {
				val = val[1..val.len - 1]
			}
			if os.getenv(k) == '' {
				os.setenv(k, val, true)
			}
		}
	}
}

// json_quote escapes s into a JSON string literal. Uses a Builder (not `+=`)
// so a multi-KB devotion/chapter is O(n), not O(n²) allocations — the naive
// char-by-char concat exhausted RAM on the first big response.
fn json_quote(s string) string {
	mut b := strings.new_builder(s.len + 16)
	b.write_u8(`"`)
	for c in s {
		match c {
			`"` { b.write_string('\\"') }
			`\\` { b.write_string('\\\\') }
			`\n` { b.write_string('\\n') }
			`\r` { b.write_string('\\r') }
			`\t` { b.write_string('\\t') }
			else {
				if c < 0x20 {
					b.write_string('\\u00')
					b.write_u8(hex_digit(c >> 4))
					b.write_u8(hex_digit(c & 0xF))
				} else {
					b.write_u8(c)
				}
			}
		}
	}
	b.write_u8(`"`)
	return b.str()
}

fn hex_digit(n u8) u8 {
	return if n < 10 { `0` + n } else { `a` + (n - 10) }
}

// sql_escape doubles single quotes so user text can be embedded in a literal.
// All module DBs are opened read-only data sources; this guards the LIKE/lookup
// queries built from ?q= and ?topic=.
fn sql_escape(s string) string {
	return s.replace("'", "''")
}

// ---- static file serving (dev standalone mode) ------------------------------

fn serve_static(path string) ?Response {
	mut rel := path.trim_left('/')
	if rel == '' {
		rel = 'index.html'
	}
	if rel.contains('..') {
		return none
	}
	full := os.join_path(site_root, rel)
	if !os.exists(full) || os.is_dir(full) {
		return none
	}
	bytes := os.read_bytes(full) or { return none }
	return Response{
		status:       200
		content_type: mime_of(full)
		body:         bytes.bytestr()
		headers:      {
			'Cache-Control': 'no-cache'
		}
	}
}

fn mime_of(p string) string {
	ext := os.file_ext(p).to_lower()
	return match ext {
		'.html' { 'text/html; charset=utf-8' }
		'.js' { 'text/javascript; charset=utf-8' }
		'.mjs' { 'text/javascript; charset=utf-8' }
		'.vue' { 'text/plain; charset=utf-8' }
		'.json' { 'application/json; charset=utf-8' }
		'.css' { 'text/css; charset=utf-8' }
		'.svg' { 'image/svg+xml' }
		'.jpg', '.jpeg' { 'image/jpeg' }
		'.png' { 'image/png' }
		'.webp' { 'image/webp' }
		'.gif' { 'image/gif' }
		'.ico' { 'image/x-icon' }
		'.pdf' { 'application/pdf' }
		'.otf' { 'font/otf' }
		'.woff' { 'font/woff' }
		'.woff2' { 'font/woff2' }
		else { 'application/octet-stream' }
	}
}
