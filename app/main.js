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
	favorites: JSON.parse(localStorage.getItem('ml_favs') || '[]'),
	date: todayISO(),
	setVersion(v) { this.version = v; localStorage.setItem('ml_version', v); },
	setFont(v) { this.fontScale = Math.min(1.8, Math.max(0.8, v)); localStorage.setItem('ml_font', this.fontScale); },
	toggleFav(item) {
		const key = item.ref;
		const i = this.favorites.findIndex((f) => f.ref === key);
		if (i >= 0) this.favorites.splice(i, 1);
		else this.favorites.unshift({ ...item, savedAt: Date.now() });
		localStorage.setItem('ml_favs', JSON.stringify(this.favorites.slice(0, 200)));
	},
	isFav(ref) { return this.favorites.some((f) => f.ref === ref); },
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
