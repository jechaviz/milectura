module main

import os

@[heap]
pub struct App {
pub mut:
	cfg     Config
	modules []ModInfo
}

fn main() {
	mut cfg := load_config()
	args := os.args
	for i, a in args {
		match a {
			'--port' {
				if i + 1 < args.len {
					cfg.port = args[i + 1].int()
				}
			}
			'--modules' {
				if i + 1 < args.len {
					cfg.modules_dir = args[i + 1]
				}
			}
			else {}
		}
	}

	mut app := &App{
		cfg:     cfg
		modules: scan_modules(cfg.modules_dir)
	}

	mut router := &Router{}
	register_routes(mut router)

	// CGI mode (shared cPanel / Spaceship): handle one request and exit.
	if os.getenv('GATEWAY_INTERFACE') != '' {
		handle_cgi(mut app, router)
		return
	}

	// Standalone mode (local dev): long-running server, also serves the SPA.
	serve(mut app, router, cfg.port) or { panic(err) }
}
