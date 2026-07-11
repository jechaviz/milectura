module main

// ---------------------------------------------------------------------------
// HTTP core for Mi Lectura: Request/Response, the tiny router, and dispatch().
// The net.http.Server adapter + serve() live in net_notd_cgi.v (only compiled
// WITHOUT -d cgi), so the CGI deploy build (-d cgi) pulls no net.http (hence
// no mbedtls) and transpiles to a single sqlite-only C for gcc on the host.
// cgi.v provides the per-request stdin/stdout path that uses dispatch().
// ---------------------------------------------------------------------------

pub struct Request {
pub mut:
	method  string
	path    string
	raw_url string
	query   map[string]string
	headers map[string]string
	params  map[string]string
	body    string
}

pub struct Response {
pub mut:
	status       int    = 200
	content_type string = 'application/json; charset=utf-8'
	body         string
	headers      map[string]string
}

pub type Handler = fn (mut app App, mut req Request) Response

struct Route {
	method   string
	segments []string
	handler  Handler
}

@[heap]
pub struct Router {
pub mut:
	routes []Route
}

pub fn (mut r Router) add(method string, pattern string, handler Handler) {
	r.routes << Route{
		method:   method.to_upper()
		segments: split_path(pattern)
		handler:  handler
	}
}

pub fn (mut r Router) get(p string, h Handler) {
	r.add('GET', p, h)
}

pub fn (mut r Router) post(p string, h Handler) {
	r.add('POST', p, h)
}

fn split_path(p string) []string {
	s := p.trim('/').split('/')
	if s.len == 1 && s[0] == '' {
		return []
	}
	return s
}

fn (r &Router) match_route(method string, path string) ?(Handler, map[string]string) {
	segs := split_path(path)
	for route in r.routes {
		if route.method != method {
			continue
		}
		mut params := map[string]string{}
		mut ok := true
		mut tail := false
		for i, pat in route.segments {
			if pat == '*' {
				tail = true
				break
			}
			if i >= segs.len {
				ok = false
				break
			}
			if pat.starts_with(':') {
				params[pat[1..]] = segs[i]
			} else if pat != segs[i] {
				ok = false
				break
			}
		}
		if ok && !tail && segs.len != route.segments.len {
			ok = false
		}
		if ok {
			return route.handler, params
		}
	}
	return none
}

// ---- response helpers -----------------------------------------------------

pub fn ok_json(body string) Response {
	return Response{
		status: 200
		body:   body
	}
}

pub fn err_json(status int, message string) Response {
	return Response{
		status: status
		body:   '{"error":${json_quote(message)}}'
	}
}

// ---- query parsing --------------------------------------------------------

fn parse_query(qs string) map[string]string {
	mut m := map[string]string{}
	if qs == '' {
		return m
	}
	for pair in qs.split('&') {
		if pair == '' {
			continue
		}
		kv := pair.split_nth('=', 2)
		k := url_decode(kv[0])
		v := if kv.len > 1 { url_decode(kv[1]) } else { '' }
		m[k] = v
	}
	return m
}

fn url_decode(s string) string {
	mut out := []u8{}
	mut i := 0
	for i < s.len {
		c := s[i]
		if c == `+` {
			out << ` `
			i++
		} else if c == `%` && i + 2 < s.len {
			hi := hex_val(s[i + 1])
			lo := hex_val(s[i + 2])
			if hi >= 0 && lo >= 0 {
				out << u8(hi * 16 + lo)
				i += 3
			} else {
				out << c
				i++
			}
		} else {
			out << c
			i++
		}
	}
	return out.bytestr()
}

fn hex_val(c u8) int {
	if c >= `0` && c <= `9` {
		return int(c - `0`)
	}
	if c >= `a` && c <= `f` {
		return int(c - `a` + 10)
	}
	if c >= `A` && c <= `F` {
		return int(c - `A` + 10)
	}
	return -1
}

fn dispatch(mut app App, router &Router, mut req Request) Response {
	handler, params := router.match_route(req.method, req.path) or {
		if !req.path.starts_with('/api') {
			if sr := serve_static(req.path) {
				return sr
			}
		}
		return err_json(404, 'not found: ${req.method} ${req.path}')
	}
	req.params = params.clone()
	return handler(mut app, mut req)
}
