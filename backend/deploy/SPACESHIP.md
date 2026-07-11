# Deploy Mi Lectura Diaria to Spaceship (appniverse.com/milectura)

Nodeless Vue3 SPA (static) + one native V binary (CGI) + read-only MyBible
SQLite modules. Same pattern as `realstate`/`electroprice`: Apache serves the
static SPA and forwards `/api/*` to a thin PHP shim that `proc_open()`s the
binary. PHP is always available on cPanel; the binary and the modules live
OUTSIDE the docroot.

## 1. Build the single Linux C bundle (on Windows)

```bash
cd backend
V_BIN=/c/git/v/v.exe bash build.sh
# -> backend/dist/milectura.c + sqlite3.c + cJSON.c + headers
```

`build.sh` uses `-d cgi -os linux -gc none`, so the transpiled C has NO SSL
stack (no net.http/mbedtls) and compiles on the host with only SQLite.

## 2. Layout on Spaceship

Docroot (web-served), e.g. `~/appniverse.com/milectura/`:

```
index.html            # SPA shell
app/                  # main.js + components/*.vue (fetched at runtime)
img/                  # logo + hero backgrounds
.htaccess             # from backend/deploy/.htaccess
shim.php              # from backend/deploy/shim.php
```

Outside docroot, e.g. `~/apps/milectura/shared/`:

```
bin/milectura         # the native binary (chmod 755)
modules/*.SQLite3     # the MyBible modules (read-only)
```

## 3. Compile the binary on the server

```bash
scp backend/dist/*.c backend/dist/*.h server:/tmp/mlbuild/
ssh server 'cd /tmp/mlbuild && gcc -w -O2 milectura.c sqlite3.c cJSON.c \
    -o milectura -lpthread -lm -ldl && \
    mkdir -p ~/apps/milectura/shared/bin && \
    mv milectura ~/apps/milectura/shared/bin/ && \
    chmod 755 ~/apps/milectura/shared/bin/milectura'
```

Alternatively, if V is installed on the server:
`cd backend && v -prod -o ~/apps/milectura/shared/bin/milectura .`

## 4. Upload modules + static SPA

```bash
scp modules/*.SQLite3 server:~/apps/milectura/shared/modules/
# static site:
scp -r index.html app img backend/deploy/.htaccess backend/deploy/shim.php \
    server:~/appniverse.com/milectura/
```

## 5. Point the shim at the host paths

In `shim.php` (already set for account `agingriouh`):

```php
const ML_BIN     = '/home/agingriouh/apps/milectura/shared/bin/milectura';
const ML_MODULES = '/home/agingriouh/apps/milectura/shared/modules';
const ML_BASE    = '/milectura';
```

## 6. Verify

```
https://appniverse.com/milectura/            # the SPA
https://appniverse.com/milectura/api/health  # {"ok":true,"modules":6,...}
```

## Adding more versions / modules

Drop any MyBible module from https://www.ph4.org/b4_1.php?l=es into the
`modules/` dir (bible `<ID>.SQLite3`, commentary `<ID>.commentaries.SQLite3`,
dictionary `<ID>.dictionary.SQLite3`, devotional `<ID>.devotions.SQLite3`,
subheadings `<ID>.subheadings.SQLite3`). The backend auto-discovers them via
`scan_modules()` and they appear in `/api/modules` — no code change.

## RAM safety

The backend applies `vperf_core` concepts (see `backend/budget.v`): every
response has a hard byte budget and per-response item caps, so a pathological
query fails fast with `413` instead of growing an unbounded string. This is
what turned the original O(n²) `json_quote` memory blow-up into a clean guard.
