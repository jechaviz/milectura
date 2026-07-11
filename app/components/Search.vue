<template>
	<div class="space-y-5">
		<section class="glass rounded-3xl p-5 sm:p-7">
			<h1 class="font-serif text-2xl text-gold-soft mb-1">Buscar en la Palabra</h1>
			<p class="text-white/50 text-sm mb-4">Búsqueda sin acentos · {{ store.version }}</p>
			<div class="flex gap-2">
				<input v-model="q" @keyup.enter="run" ref="inp" type="search" placeholder="p. ej. amor, corazón, fe…"
					class="flex-1 glass-soft rounded-full px-5 py-3 outline-none text-lg placeholder-white/30" />
				<button class="btn-gold" @click="run">Buscar</button>
			</div>
			<div class="mt-3 flex gap-2 flex-wrap">
				<button v-for="s in suggestions" :key="s" class="chip" @click="q=s; run()">{{ s }}</button>
			</div>
		</section>

		<section v-if="loading" class="glass rounded-3xl p-6 text-white/60">Buscando…</section>
		<section v-else-if="err" class="glass rounded-3xl p-6 text-white/60">{{ err }}</section>
		<section v-else-if="results" class="glass rounded-3xl p-5 sm:p-7">
			<p class="text-white/50 text-sm mb-4">
				{{ results.length }} resultado(s){{ more ? '+' : '' }} para “{{ lastQ }}”
			</p>
			<div class="space-y-3 lg:space-y-0 lg:grid lg:grid-cols-2 lg:gap-3">
				<div v-for="(r,i) in results" :key="i" class="glass-soft rounded-2xl p-4 hover:bg-white/12 transition group">
					<div class="flex items-center gap-2 mb-1">
						<a :href="'#/biblia?b='+r.book+'&c='+r.chapter" class="text-gold-soft font-medium no-underline hover:underline">{{ r.ref }}</a>
						<div class="flex-1"></div>
						<button class="opacity-0 group-hover:opacity-100 chip !py-0.5 transition" @click="store.toggleFav({ ref: r.ref, verses: [{v:r.verse,t:r.t}], version: store.version })">
							{{ store.isFav(r.ref) ? '❤' : '♡' }}
						</button>
					</div>
					<p class="text-white/85 verse mem-on" :class="{ blurred: isHidden(i) && store.memMode === 'blur' }"
						v-html="displayT(r.t, i)" @click="toggleRes(i)"
						@pointerdown="onDown" @pointermove="onPointer"
						@pointerup="clearDwell" @pointercancel="clearDwell" @pointerleave="clearDwell"></p>
				</div>
			</div>
		</section>
		<section v-else class="text-center text-white/30 py-16 font-serif text-lg">
			“Lámpara es a mis pies tu palabra”
		</section>
	</div>
</template>

<script>
module.exports = {
	inject: ['api', 'store'],
	data() {
		return { q: '', lastQ: '', results: null, more: false, loading: false, err: '', act: {},
			suggestions: ['amor', 'fe', 'esperanza', 'perdón', 'gozo', 'paz', 'gracia'] };
	},
	methods: {
		async run() {
			const q = this.q.trim();
			if (q.length < 3) { this.err = 'Escribe al menos 3 caracteres.'; this.results = null; return; }
			this.loading = true; this.err = ''; this.results = null; this.act = {};
			try {
				const r = await this.api.get(`/search?v=${this.store.version}&q=${encodeURIComponent(q)}&limit=60`);
				this.results = r.results; this.more = r.more; this.lastQ = q;
			} catch (e) { this.err = e.message; }
			this.loading = false;
		},
		// When a memorization form is active globally, apply it; otherwise keep the
		// search highlight. (Memorization works in every view, search included.)
		// A result is memorized when the global toggle XOR its own tap.
		isHidden(i) { return this.store.memAll !== !!this.act[i]; },
		displayT(t, i) {
			const m = this.store.memMode;
			if (!this.isHidden(i) || !window.mlMem) return this.highlight(t);
			if (m === 'blur') return window.mlMem.blurWords(t);
			return window.mlMem.apply(t, m);
		},
		onDown(e) {
			this._downAt = (typeof performance !== 'undefined') ? performance.now() : 0;
			this.onPointer(e);
		},
		toggleRes(i) {
			const held = ((typeof performance !== 'undefined') ? performance.now() : 0) - (this._downAt || 0);
			if (this.isHidden(i) && this.store.memMode === 'blur' && held >= 220) return; // hold = reveal words
			this.act = { ...this.act, [i]: !this.act[i] };
		},
		onPointer(e) {
			if (this.store.memMode !== 'blur') return;
			const el = document.elementFromPoint(e.clientX, e.clientY);
			const w = el && el.closest ? el.closest('.mw') : null;
			if (w === this._dwellMw) return;
			if (this._dwellMw) this._dwellMw.classList.remove('dwell');
			if (w) w.classList.add('dwell');
			this._dwellMw = w || null;
		},
		clearDwell() {
			if (this._dwellMw) { this._dwellMw.classList.remove('dwell'); this._dwellMw = null; }
		},
		highlight(t) {
			if (!this.lastQ) return t;
			const fold = (s) => s.normalize('NFD').replace(/[̀-ͯ]/g, '');
			const needle = fold(this.lastQ.toLowerCase());
			// walk plain text, wrap matches while preserving existing tags loosely
			return t.replace(/([A-Za-zÀ-ÿ]+)/g, (w) => fold(w.toLowerCase()).includes(needle)
				? `<mark style="background:rgba(232,195,126,.3);color:inherit;border-radius:3px">${w}</mark>` : w);
		},
	},
	mounted() { this.$refs.inp?.focus(); },
};
</script>
