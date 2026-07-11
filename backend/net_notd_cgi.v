module main

// net.http.Server adapter — compiled ONLY in the standalone/dev build (NOT
// with -d cgi). The -d cgi deploy build uses the stub in net_d_cgi.v instead,
// so its single transpiled C needs no SSL stack — only sqlite.

import net.http
import sync

struct ApiHandler {
mut:
	app    &App
	router &Router
	mu     &sync.Mutex
}

fn (mut h ApiHandler) handle(hreq http.Request) http.Response {
	mut req := to_request(hreq)
	if req.method == 'OPTIONS' {
		return cors_response(204, 'application/json; charset=utf-8', '')
	}
	h.mu.@lock()
	resp := dispatch(mut h.app, h.router, mut req)
	h.mu.unlock()
	return cors_response(resp.status, resp.content_type, resp.body)
}

fn to_request(hreq http.Request) Request {
	raw := hreq.url
	mut path := raw
	mut qs := ''
	if idx := raw.index('?') {
		path = raw[..idx]
		qs = raw[idx + 1..]
	}
	mut headers := map[string]string{}
	for k in hreq.header.keys() {
		headers[k.to_lower()] = hreq.header.get_custom(k) or { '' }
	}
	return Request{
		method:  hreq.method.str().to_upper()
		path:    url_decode(path)
		raw_url: raw
		query:   parse_query(qs)
		headers: headers
		body:    hreq.data
	}
}

fn cors_response(status int, content_type string, body string) http.Response {
	mut header := http.new_header_from_map({
		http.CommonHeader.content_type: content_type
	})
	header.add_custom('Access-Control-Allow-Origin', cors_origin()) or {}
	header.add_custom('Vary', 'Origin') or {}
	header.add_custom('Access-Control-Allow-Methods', 'GET, OPTIONS') or {}
	header.add_custom('Access-Control-Allow-Headers', 'Content-Type') or {}
	header.add_custom('Cache-Control', 'no-cache') or {}
	mut resp := http.Response{
		status_code: status
		header:      header
		body:        body
	}
	resp.set_version(.v1_1)
	return resp
}

pub fn serve(mut app App, router &Router, port int) ! {
	mut mu := sync.new_mutex()
	mut handler := &ApiHandler{
		app:    app
		router: router
		mu:     mu
	}
	mut server := &http.Server{
		addr:    ':${port}'
		handler: handler
	}
	println('[MiLectura] V backend on http://localhost:${port}  (serves API + static site)')
	server.listen_and_serve()
}
