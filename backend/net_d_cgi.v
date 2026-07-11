module main

// Stub for the -d cgi deploy build: no net.http (so the transpiled C has no
// SSL stack and gcc-compiles on the shared host with only sqlite). In CGI mode
// the binary runs per-request via shim.php (stdin/stdout); it never opens a
// socket, so serve() is unused.

pub fn serve(mut app App, router &Router, port int) ! {
	eprintln('[MiLectura] serve() unavailable in CGI build (-d cgi). Use shim.php.')
}
