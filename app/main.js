/* Mi Lectura Diaria — Vue3 (CDN) + vue3-sfc-loader, no build step.
   Compiles .vue single-file components in the browser. */
const { loadModule } = window['vue3-sfc-loader'];
const APP_BASE = 'app/';

const sfcOptions = {
	moduleCache: { vue: Vue },
	async getFile(url) {
		const res = await fetch(url, { cache: 'no-cache' });
		if (!res.ok) throw Object.assign(new Error(`${res.status} ${url}`), { res });
		return { getContentData: (bin) => (bin ? res.arrayBuffer() : res.text()) };
	},
	addStyle(text) {
		const s = document.createElement('style');
		s.textContent = text;
		document.head.appendChild(s);
	},
	log(type, ...args) { (console[type] || console.log)(...args); },
};

// Async component helper, memoised. Exposed globally so SFCs can register
// nested components (e.g. VerseBlock) inside their own `components` option.
const _cache = {};
function comp(name) {
	if (!_cache[name]) {
		_cache[name] = Vue.defineAsyncComponent(() =>
			loadModule(`${APP_BASE}components/${name}.vue`, sfcOptions));
	}
	return _cache[name];
}
window.mlComp = comp;

// Spiritual reading status (WhatsApp-style ticks) + highlight palette, shared by
// VerseBlock and VerseTools. Progression: leído -> comprendido -> memorizado ->
// aplicado (en oración / vida práctica).
window.mlStatus = [
	null,
	{ s: 1, label: 'Leído', tick: '✓', color: '#c9d3e6', icon: '👁' },
	{ s: 2, label: 'Comprendido', tick: '✓✓', color: '#7fb0e8', icon: '💡' },
	{ s: 3, label: 'Memorizado', tick: '✓✓', color: '#e8c37e', icon: '🧠' },
	{ s: 4, label: 'Aplicado', tick: '✓✓', color: '#8fd39a', icon: '🌱' },
];
window.mlHl = [
	{ key: 'gold', bg: 'rgba(232,195,126,.30)' },
	{ key: 'sky', bg: 'rgba(127,176,232,.30)' },
	{ key: 'green', bg: 'rgba(143,211,154,.26)' },
	{ key: 'rose', bg: 'rgba(232,150,150,.28)' },
	{ key: 'violet', bg: 'rgba(184,150,232,.28)' },
];
window.mlHlBg = (key) => (window.mlHl.find((h) => h.key === key) || {}).bg || '';

// ---- API client -----------------------------------------------------------
// In dev the V server serves both API and static on :8091 → base ''.
// On Spaceship the SPA lives at /milectura and the API at /milectura/api.
const API_BASE = (() => {
	const p = location.pathname;
	const i = p.indexOf('/milectura');
	if (i >= 0) return p.slice(0, i) + '/milectura';
	return '';
})();

const api = {
	async get(path) {
		const r = await fetch(API_BASE + '/api' + path, { headers: { Accept: 'application/json' } });
		const data = await r.json().catch(() => ({ error: 'respuesta inválida' }));
		if (!r.ok) throw new Error(data.error || `HTTP ${r.status}`);
		return data;
	},
};

// today as YYYY-MM-DD in local time
function todayISO(d) {
	const t = d || new Date();
	return `${t.getFullYear()}-${String(t.getMonth() + 1).padStart(2, '0')}-${String(t.getDate()).padStart(2, '0')}`;
}

const store = Vue.reactive({
	version: localStorage.getItem('ml_version') || 'RVR60',
	modules: [],
	bibles: [],
	fontScale: Number(localStorage.getItem('ml_font') || 1),
	forgetica: localStorage.getItem('ml_forgetica') === '1',
	// Memorization method (form), always selectable; default 'blur'.
	//   'initials' | 'hidden' | 'blur'
	memMode: (function () { const m = localStorage.getItem('ml_memmode'); return (m === 'initials' || m === 'hidden' || m === 'blur') ? m : 'blur'; })(),
	// Global "memorize all" toggle. A passage is hidden when memAll XOR (it was
	// tapped). So reading is the default, tapping a passage memorizes just that
	// set, and 🧠 hides/reveals everything at once.
	memAll: localStorage.getItem('ml_memall') === '1',
	favorites: JSON.parse(localStorage.getItem('ml_favs') || '[]'),
	// Per-verse annotations: { "<version>:<book>:<chapter>:<verse>": {s, hl, note} }
	//   s  = spiritual status 1..4 (leído/comprendido/memorizado/aplicado)
	//   hl = highlight color key
	//   note = free text
	vdata: JSON.parse(localStorage.getItem('ml_vdata') || '{}'),
	// currently open verse-tools target (drives the tools drawer in AppShell)
	toolsKey: '',
	toolsRef: '',
	date: todayISO(),
	setVersion(v) { this.version = v; localStorage.setItem('ml_version', v); },
	setFont(v) { this.fontScale = Math.min(1.8, Math.max(0.8, v)); localStorage.setItem('ml_font', this.fontScale); },
	toggleForgetica() { this.forgetica = !this.forgetica; localStorage.setItem('ml_forgetica', this.forgetica ? '1' : '0'); },
	setMemMode(m) { this.memMode = m; localStorage.setItem('ml_memmode', m); },
	// 🧠 quick toggle: memorize ALL passages <-> reveal all (reading).
	toggleMemAll() { this.memAll = !this.memAll; localStorage.setItem('ml_memall', this.memAll ? '1' : '0'); },
	toggleFav(item) {
		const key = item.ref;
		const i = this.favorites.findIndex((f) => f.ref === key);
		if (i >= 0) this.favorites.splice(i, 1);
		else this.favorites.unshift({ ...item, savedAt: Date.now() });
		localStorage.setItem('ml_favs', JSON.stringify(this.favorites.slice(0, 200)));
	},
	isFav(ref) { return this.favorites.some((f) => f.ref === ref); },
	// ---- per-verse annotations -------------------------------------------
	vKey(book, chapter, verse) { return `${this.version}:${book}:${chapter}:${verse}`; },
	getV(key) { return this.vdata[key] || {}; },
	setV(key, patch) {
		const cur = this.vdata[key] || {};
		const next = { ...cur, ...patch };
		if (!next.s && !next.hl && !next.note) delete this.vdata[key];
		else this.vdata[key] = next;
		this.vdata = { ...this.vdata };
		localStorage.setItem('ml_vdata', JSON.stringify(this.vdata));
	},
	openTools(key, ref) { this.toolsKey = key; this.toolsRef = ref; },
	closeTools() { this.toolsKey = ''; this.toolsRef = ''; },
});

const app = Vue.createApp({
	components: {
		AppShell: comp('AppShell'),
	},
	provide() {
		return { api, store, comp, todayISO };
	},
	data() { return { ready: false, error: '' }; },
	async mounted() {
		try {
			const m = await api.get('/modules');
			store.modules = m.modules || [];
			store.bibles = store.modules.filter((x) => x.kind === 'bible');
			if (!store.bibles.some((b) => b.id === store.version) && m.default) {
				store.setVersion(m.default);
			}
			this.ready = true;
			const boot = document.getElementById('boot');
			if (boot) boot.remove();
		} catch (e) {
			this.error = e.message || String(e);
		}
	},
	template: `
		<AppShell v-if="ready" />
		<div v-else-if="error" style="min-height:100vh;display:grid;place-items:center;color:#f3dcae;font-family:Inter,sans-serif;padding:2rem;text-align:center">
			<div>
				<p style="font-size:1.1rem;margin-bottom:.5rem">No se pudo cargar la biblioteca.</p>
				<p style="opacity:.7;font-size:.9rem">{{ error }}</p>
			</div>
		</div>
	`,
});

app.mount('#app');
