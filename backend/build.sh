#!/usr/bin/env bash
#
# Transpile the Mi Lectura V backend to a single, host-portable Linux C bundle,
# compiled on the server with gcc (no V toolchain needed there). Mirrors the
# realstate/electroprice deploy.
#
#   -d cgi    : exclude net.http (mbedtls) — the CGI deploy needs no SSL stack
#   -os linux : cross-target Linux from Windows
#   -gc none  : no Boehm GC dependency (safe for short-lived per-request CGI)
#
# Output (dist/): milectura.c + v_recover.h + sqlite3.c + sqlite3.h
# On the server:  gcc -w -O2 milectura.c sqlite3.c -o milectura -lpthread -lm -ldl
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
V_BIN="${V_BIN:-/c/git/v/v.exe}"
V_ROOT="$(dirname "$V_BIN")"
DIST="$DIR/dist"
OUT="$DIST/milectura.c"

rm -rf "$DIST"; mkdir -p "$DIST"

"$V_BIN" -d cgi -os linux -gc none -o "$OUT" "$DIR"

# Vendor v_recover.h (the V fork emits an ABSOLUTE Windows include path that does
# not exist on the host) and rewrite the include to a bare relative path.
RECOVER_H="$V_ROOT/vlib/builtin/v_recover.h"
if grep -q 'v_recover\.h' "$OUT"; then
	[ -f "$RECOVER_H" ] && cp "$RECOVER_H" "$DIST/v_recover.h"
	sed -i 's#"[^"]*v_recover\.h"#"v_recover.h"#g' "$OUT"
fi

# Vendor the thirdparty C the generated code #includes, so the host needs no
# -devel headers: SQLite amalgamation, cJSON (V's json module), atomics header.
cp "$V_ROOT/thirdparty/sqlite/sqlite3.c" "$DIST/sqlite3.c"
cp "$V_ROOT/thirdparty/sqlite/sqlite3.h" "$DIST/sqlite3.h"
cp "$V_ROOT/thirdparty/cJSON/cJSON.c" "$DIST/cJSON.c" 2>/dev/null || true
cp "$V_ROOT/thirdparty/cJSON/cJSON.h" "$DIST/cJSON.h" 2>/dev/null || true
cp "$V_ROOT/thirdparty/stdatomic/nix/atomic_cpp.h" "$DIST/atomic_cpp.h" 2>/dev/null || true
sed -i 's#"[^"]*sqlite3\.h"#"sqlite3.h"#g; s#"[^"]*cJSON\.h"#"cJSON.h"#g; s#"[^"]*atomic_cpp\.h"#"atomic_cpp.h"#g' "$OUT"

echo "[build] dist/ -> $(ls "$DIST" | tr '\n' ' ')"
echo "[build] milectura.c $(wc -l < "$OUT") lines"
echo "[build] server compile: gcc -w -O2 milectura.c sqlite3.c cJSON.c -o milectura -lpthread -lm -ldl"
