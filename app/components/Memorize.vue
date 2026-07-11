<template>
	<div class="space-y-5">
		<!-- Header + source -->
		<section class="glass rounded-3xl p-5 sm:p-7">
			<div class="flex items-center gap-3 flex-wrap">
				<h1 class="font-serif text-2xl text-gold-soft">Memorizar</h1>
				<span class="text-white/50 text-sm">esconde el texto por etapas y recítalo</span>
				<div class="flex-1"></div>
				<button @click="store.toggleForgetica()" class="chip">{{ store.forgetica ? '🧠 Fuente normal' : '🧠 Sans Forgetica' }}</button>
			</div>
			<div class="mt-4 flex gap-2 flex-wrap">
				<button v-for="s in sources" :key="s.key" class="chip"
					:class="source === s.key ? '!bg-white/20 text-gold-soft' : ''" @click="setSource(s.key)">{{ s.label }}</button>
			</div>
		</section>

		<!-- Stage control -->
		<section class="glass-soft rounded-2xl p-3 flex items-center gap-2 flex-wrap text-sm">
			<span class="text-white/50 px-1">Modo:</span>
			<button class="chip" :class="mode === 'libre' ? '!bg-white/20 text-gold-soft' : ''" @click="mode='libre'">👆 Libre (toca el texto)</button>
			<button v-for="st in stages" :key="st.key" class="chip"
				:class="mode === st.key ? '!bg-white/20 text-gold-soft' : ''" @click="mode = st.key">{{ st.label }}</button>
		</section>

		<!-- Card -->
		<section v-if="err" class="glass rounded-3xl p-6 text-white/60">{{ err }}</section>
		<section v-else-if="!deck.length" class="glass rounded-3xl p-10 text-center text-white/40 font-serif">
			{{ loading ? 'Cargando…' : (source === 'favoritos' ? 'No tienes versículos guardados aún.' : 'Sin versículos.') }}
		</section>
		<section v-else class="glass rounded-3xl p-7 sm:p-10 min-h-[16rem] flex flex-col">
			<div class="flex items-center gap-3 mb-4">
				<span class="text-gold-soft font-medium">{{ current.ref }}</span>
				<span class="text-white/30 text-sm">{{ store.version }}</span>
				<div class="flex-1"></div>
				<span class="text-white/40 text-sm">{{ idx + 1 }} / {{ deck.length }}</span>
			</div>

			<div class="flex-1 flex items-center">
				<VerseBlock :key="current.ref + mode" :verses="current.verses"
					:memorizable="mode === 'libre'" :forceStage="mode === 'libre' ? '' : mode"
					class="font-serif text-2xl sm:text-3xl leading-relaxed text-white w-full" />
			</div>

			<!-- Controls -->
			<div class="mt-8 flex items-center gap-2 flex-wrap">
				<button class="btn-ghost" @click="prev" :disabled="idx===0" :class="idx===0 ? 'opacity-40' : ''">‹ Anterior</button>
				<button class="btn-gold" @click="reveal">👁 Revelar</button>
				<button class="btn-ghost" @click="fav(current)">{{ store.isFav(current.ref) ? '❤ Guardado' : '♡ Guardar' }}</button>
				<div class="flex-1"></div>
				<button class="btn-ghost" @click="next" :disabled="idx>=deck.length-1" :class="idx>=deck.length-1 ? 'opacity-40' : ''">Siguiente ›</button>
			</div>
		</section>

		<!-- Strategy explainer -->
		<section class="glass-soft rounded-2xl p-5 text-sm text-white/70 space-y-2">
			<p class="text-gold-soft font-medium">Las estrategias</p>
			<p><b class="text-white/90">Iniciales</b> — cada palabra deja solo su primera letra. Tu mente completa el resto.</p>
			<p><b class="text-white/90">Oculto</b> — desaparecen todas las letras; queda la estructura (puntuación y espacios) como andamiaje.</p>
			<p><b class="text-white/90">Difuminado</b> — el texto sigue ahí pero borroso: recítalo de memoria y pasa el cursor para confirmar.</p>
			<p><b class="text-white/90">Sans Forgetica</b> — una tipografía con “dificultad deseable” que mejora la retención (botón 🧠).</p>
			<p class="text-white/40">En modo Libre, toca el versículo para avanzar de etapa: completo → iniciales → oculto → difuminado.</p>
		</section>
	</div>
</template>

<script>
// Mazo curado de promesas clásicas (incluye el set de Juan 14–16 del sitio previo).
const PROMESAS = [
	'Juan 3:16', 'Salmos 23:1-4', 'Proverbios 3:5-6', 'Filipenses 4:13', 'Isaías 41:10',
	'Josué 1:9', 'Romanos 8:28', 'Mateo 6:33', 'Filipenses 4:6-7', 'Salmos 119:105',
	'Juan 14:6', 'Juan 15:7', 'Juan 16:33', 'Romanos 12:2', 'Gálatas 5:22-23',
	'Hebreos 11:1', '1 Corintios 13:4-7', 'Jeremías 29:11', '2 Timoteo 1:7', 'Salmos 46:1',
];

module.exports = {
	inject: ['api', 'store'],
	components: { VerseBlock: window.mlComp('VerseBlock') },
	data() {
		return {
			source: 'promesas',
			mode: 'libre',
			deck: [],
			idx: 0,
			err: '',
			loading: false,
			sources: [
				{ key: 'promesas', label: '✦ Promesas' },
				{ key: 'favoritos', label: '❤ Mis guardados' },
				{ key: 'hoy', label: '📅 Versículo de hoy' },
			],
			stages: (window.mlMem && window.mlMem.STAGES ? window.mlMem.STAGES.filter((s) => s.key !== 'normal') : []),
		};
	},
	computed: {
		current() { return this.deck[this.idx] || { ref: '', verses: [] }; },
	},
	watch: {
		'store.version'() { this.load(); },
	},
	methods: {
		setSource(k) { this.source = k; this.idx = 0; this.load(); },
		async load() {
			this.err = ''; this.idx = 0; this.deck = []; this.loading = true;
			try {
				if (this.source === 'favoritos') {
					this.deck = this.store.favorites.map((f) => ({ ref: f.ref, verses: f.verses }));
				} else if (this.source === 'hoy') {
					const v = await this.api.get(`/votd?v=${this.store.version}&date=${this.store.date}`);
					this.deck = [{ ref: v.ref, verses: v.verses }];
				} else {
					const r = await this.api.get(`/passage?v=${this.store.version}&ref=${encodeURIComponent(PROMESAS.join(';'))}`);
					this.deck = (r.passages || []).map((p) => ({ ref: p.ref, verses: p.verses }));
				}
			} catch (e) { this.err = e.message; }
			this.loading = false;
		},
		next() { if (this.idx < this.deck.length - 1) this.idx++; },
		prev() { if (this.idx > 0) this.idx--; },
		reveal() { this.mode = 'libre'; }, // libre + normal reveals full text
		fav(c) { if (c.ref) this.store.toggleFav({ ref: c.ref, verses: c.verses, version: this.store.version }); },
	},
	mounted() { this.load(); },
};
</script>
