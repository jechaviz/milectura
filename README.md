# Mi Lectura Diaria

La Palabra de Dios cada día — versículo del día, plan de lectura de un año,
devocionales, comentarios, diccionario bíblico y búsqueda. Recreación moderna
del sitio PHP original como **SPA Vue3 (sin build) + backend V nativo**, con un
shim PHP para desplegar en Spaceship (`appniverse.com/milectura`).

## Qué es

| Antes (legacy/) | Ahora |
|---|---|
| PHP que raspaba BibleGateway en vivo | Backend V que sirve **módulos MyBible** locales (SQLite de ph4.org) |
| Plantillas Mobirise/jQuery | Vue3 CDN + SFC (`vue3-sfc-loader`), UnoCSS runtime, glassmorphism |
| Dependía de red por request | Offline-first, determinista, sin llamadas externas |

## Arquitectura

```
index.html            shell + UnoCSS + aurora/glass theme
app/main.js           bootstrap Vue3, cliente API, store (localStorage)
app/components/*.vue   AppShell · Today · Reader · Search · Devotional · Favorites · VerseBlock
backend/*.v           servidor V (CGI en prod, standalone en dev; sirve API + estáticos)
backend/deploy/       shim.php · .htaccess · build.sh · SPACESHIP.md
modules/*.SQLite3     módulos MyBible (RVR60, NTV, comentarios, subtítulos, devocional, diccionario)
```

Los módulos son bases SQLite estándar de MyBible descargadas de
[ph4.org](https://www.ph4.org/b4_1.php?l=es). Suelta cualquier módulo nuevo en
`modules/` y el backend lo autodescubre (`/api/modules`).

## Correr en local

```bash
cd backend
v -o milectura.exe .
./milectura.exe --port 8091     # sirve API + SPA en http://localhost:8091
```

## API (solo lectura, JSON)

| Endpoint | Descripción |
|---|---|
| `GET /api/modules` | módulos disponibles + versión por defecto |
| `GET /api/books?v=RVR60` | libros + nº de capítulos |
| `GET /api/chapter?v&b&c[&sub]` | capítulo con subtítulos |
| `GET /api/passage?v&ref=Juan 3:16-18;Salmos 23` | pasajes por referencia (parser español) |
| `GET /api/votd?v&date=YYYY-MM-DD` | versículo del día (145 promesas, cíclico) |
| `GET /api/plan?v&date` | lectura AT+NT del día (plan de un año) |
| `GET /api/search?v&q&limit&book` | búsqueda de texto (acento-insensible) |
| `GET /api/commentary?m&b&c` | comentarios de un capítulo |
| `GET /api/dict?m&topic` · `GET /api/dictsearch?m&q` | diccionario bíblico |
| `GET /api/devotion?m&date` | devocional del día |
| `GET /api/random?v` | versículo aleatorio |

## Rendimiento / seguridad de RAM

`backend/budget.v` porta conceptos de `v_projects/lib/vperf_core`
(`bounded_bytes` + `ram_guard`): presupuesto de bytes por respuesta + topes de
ítems, con fallo rápido `413`. `json_quote` usa `strings.Builder` (O(n)) — la
versión ingenua char-a-char agotaba la RAM en el primer devocional grande.

## Deploy

Ver [`backend/deploy/SPACESHIP.md`](backend/deploy/SPACESHIP.md).
