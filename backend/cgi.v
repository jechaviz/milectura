module main

import os

// CGI adapter so the SAME router runs on shared cPanel/Spaceship hosting (no
// persistent process), the way realstate/electroprice deploy. Apache serves
// the static SPA; /milectura/api/* is routed to this binary via shim.php.

fn handle_cgi(mut app App, router &Router) {
	method := os.getenv('REQUEST_METHOD')
	raw := if u := getenv_opt('REQUEST_URI') {
		u
	} else {
		p := os.getenv('PATH_INFO')
		qs := os.getenv('QUERY_STRING')
		if qs != '' { '${p}?${qs}' } else { p }
	}
	mut path := raw
	mut qs := ''
	if idx := raw.index('?') {
		path = raw[..idx]
		qs = raw[idx + 1..]
	}
	path = url_decode(path)
	// strip the deployment base path (e.g. /milectura) so routes match
	bp := app.cfg.base_path.trim_right('/')
	if bp != '' && path.starts_with(bp) {
		path = path[bp.len..]
		if path == '' {
			path = '/'
		}
	}

	mut headers := map[string]string{}
	if ct := getenv_opt('CONTENT_TYPE') {
		headers['content-type'] = ct
	}

	mut body := ''
	clen := os.getenv('CONTENT_LENGTH').int()
	// Global request-size cap: this API is read-only; no handler needs a body.
	if clen > 100_000 {
		write_cgi(err_json(413, 'request body too large'))
		return
	}
	if clen > 0 {
		all := os.get_raw_stdin()
		body = all[..int_min2(clen, all.len)].bytestr()
	}

	if method.to_upper() == 'OPTIONS' {
		write_cgi(Response{ status: 204 })
		return
	}

	mut req := Request{
		method:  method.to_upper()
		path:    path
		raw_url: raw
		query:   parse_query(qs)
		headers: headers
		body:    body
	}
	resp := dispatch(mut app, router, mut req)
	write_cgi(resp)
}

fn int_min2(a int, b int) int {
	return if a < b { a } else { b }
}

fn cors_origin() string {
	o := os.getenv('ML_CORS_ORIGIN')
	return if o != '' { o } else { 'https://appniverse.com' }
}

fn write_cgi(resp Response) {
	mut out := 'Status: ${resp.status} ${status_text_cgi(resp.status)}\r\n'
	out += 'Content-Type: ${resp.content_type}\r\n'
	out += 'Access-Control-Allow-Origin: ${cors_origin()}\r\n'
	out += 'Vary: Origin\r\n'
	out += 'Access-Control-Allow-Methods: GET, OPTIONS\r\n'
	out += 'Access-Control-Allow-Headers: Content-Type\r\n'
	for k, v in resp.headers {
		out += '${k}: ${v}\r\n'
	}
	out += '\r\n'
	out += resp.body
	print(out)
	os.flush()
}

fn status_text_cgi(code int) string {
	return match code {
		200 { 'OK' }
		204 { 'No Content' }
		400 { 'Bad Request' }
		404 { 'Not Found' }
		413 { 'Payload Too Large' }
		422 { 'Unprocessable Entity' }
		500 { 'Internal Server Error' }
		else { 'OK' }
	}
}
