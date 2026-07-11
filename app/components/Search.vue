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
					<p class="text-white/85 verse" :class="{ blurred: store.memMode === 'blur' }" v-html="displayT(r.t)"
						@click="revealWord" @pointerdown="onPointer" @pointermove="onPointer"
						@pointerup="clearReveal" @pointercancel="clearReveal" @pointerleave="clearReveal"></p>
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
		return { q: '', lastQ: '', results: null, more: false, loading: false, err: '',
			suggestions: ['amor', 'fe', 'esperanza', 'perdón', 'gozo', 'paz', 'gracia'] };
	},
	methods: {
		async run() {
			const q = this.q.trim();
			if (q.length < 3) { this.err = 'Escribe al menos 3 caracteres.'; this.results = null; return; }
			this.loading = true; this.err = ''; this.results = null;
			try {
				const r = await this.api.get(`/search?v=${this.store.version}&q=${encodeURIComponent(q)}&limit=60`);
				this.results = r.results; this.more = r.more; this.lastQ = q;
			} catch (e) { this.err = e.message; }
			this.loading = false;
		},
		// When a memorization form is active globally, apply it; otherwise keep the
		// search highlight. (Memorization works in every view, search included.)
		displayT(t) {
			const m = this.store.memMode;
			if ((m === 'initials' || m === 'hidden') && window.mlMem) return window.mlMem.apply(t, m);
			if (m === 'blur' && window.mlMem) return window.mlMem.blurWords(t); // per-word blur
			return this.highlight(t);
		},
		revealWord(e) {
			if (this.store.memMode !== 'blur') return;
			const w = e.target && e.target.closest && e.target.closest('.mw');
			if (w) w.classList.toggle('reveal');
		},
		onPointer(e) {
			if (this.store.memMode !== 'blur' || e.pointerType === 'mouse') return;
			const el = document.elementFromPoint(e.clientX, e.clientY);
			const w = el && el.closest && el.closest('.mw');
			if (this._lastMw && this._lastMw !== w) this._lastMw.classList.remove('reveal');
			if (w) { w.classList.add('reveal'); this._lastMw = w; }
		},
		clearReveal(e) {
			if (e && e.pointerType === 'mouse') return;
			if (this._lastMw) { this._lastMw.classList.remove('reveal'); this._lastMw = null; }
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
