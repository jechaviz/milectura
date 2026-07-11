<template>
	<div class="space-y-6">
		<!-- Hero: verse of the day -->
		<section class="glass rounded-3xl overflow-hidden relative">
			<div class="absolute inset-0 -z-10 opacity-40 bg-cover bg-center" :style="heroBg"></div>
			<div class="p-7 sm:p-10 lg:p-14 lg:max-w-4xl">
				<p class="text-xs tracking-[0.25em] text-gold-soft/80 uppercase mb-3">Versículo de hoy · {{ prettyDate }}</p>
				<div v-if="votd" class="font-serif text-2xl sm:text-3xl lg:text-4xl leading-snug text-white">
					<VerseBlock :verses="votd.verses" memorizable />
				</div>
				<div v-else-if="err" class="text-white/60">{{ err }}</div>
				<div v-else class="h-16 animate-pulse bg-white/5 rounded-xl"></div>
				<div v-if="votd" class="mt-5 flex items-center gap-3 flex-wrap">
					<span class="font-medium text-gold-soft">{{ votd.ref }}</span>
					<span class="text-white/40 text-sm">{{ store.version }}</span>
					<div class="flex-1"></div>
					<button class="chip" @click="fav">{{ isFav ? '❤ Guardado' : '♡ Guardar' }}</button>
					<button class="chip" @click="share">↗ Compartir</button>
					<button class="chip" @click="surprise">🎲 Otro</button>
				</div>
			</div>
		</section>

		<!-- Reading plan of the day -->
		<section class="glass rounded-3xl p-6 sm:p-8">
			<div class="flex items-center gap-3 mb-4">
				<h2 class="font-serif text-xl text-gold-soft whitespace-nowrap">Lectura del día</h2>
				<span class="text-white/40 text-sm whitespace-nowrap">plan de un año</span>
				<input type="date" :value="store.date" @change="setDate($event.target.value)"
					class="glass-soft rounded-full px-3 py-1 text-sm outline-none shrink-0 ml-auto self-center" />
			</div>

			<div v-if="planErr" class="text-white/60">{{ planErr }}</div>
			<div v-else-if="!plan" class="space-y-2">
				<div class="h-4 bg-white/5 rounded animate-pulse" v-for="i in 4" :key="i"></div>
			</div>
			<div v-else class="space-y-6 lg:space-y-0 lg:grid lg:grid-cols-2 lg:gap-x-10 lg:gap-y-6">
				<div v-for="grp in planGroups" :key="grp.key">
					<div class="flex items-center gap-2 mb-2 sticky top-16 md:top-20 py-1 -mx-1 px-1 backdrop-blur-sm">
						<span class="text-xs px-2 py-0.5 rounded-full glass-soft text-gold-soft">{{ grp.tag }}</span>
						<span class="text-white/50 text-sm truncate">{{ grp.items.map(i => i.ref).join(' · ') }}</span>
					</div>
					<div v-for="p in grp.items" :key="p.ref" class="mb-4">
						<h3 class="font-serif text-lg text-white/90 mb-1">{{ p.ref }}</h3>
						<VerseBlock :verses="p.verses" :subheadings="p.subheadings" class="text-white/85 max-w-prose" />
					</div>
				</div>
			</div>
		</section>
	</div>
</template>

<script>
module.exports = {
	inject: ['api', 'store', 'comp'],
	components: { VerseBlock: window.mlComp('VerseBlock') },
	data() {
		return { votd: null, err: '', plan: null, planErr: '', heroImgs: [
			'AyutthayaTemple.jpg', 'BathCircus.jpg', 'BourgesMarsh.jpg', 'CreteHarbor.jpg',
			'ManhattanAerial.jpg', 'MountSegla.jpg', 'ParisLouvre.jpg', 'SanBlasIslands.jpg',
		] };
	},
	computed: {
		prettyDate() { return this.fmt(this.store.date); },
		heroBg() {
			const day = new Date(this.store.date).getDate() || 1;
			return { backgroundImage: `linear-gradient(160deg, rgba(11,16,32,.72), rgba(7,11,24,.88)), url(img/${this.heroImgs[day % this.heroImgs.length]})` };
		},
		isFav() { return this.votd && this.store.isFav(this.votd.ref); },
		planGroups() {
			if (!this.plan) return [];
			const g = [];
			if (this.plan.ot?.length) g.push({ key: 'ot', tag: 'Antiguo Testamento', items: this.plan.ot });
			if (this.plan.nt?.length) g.push({ key: 'nt', tag: 'Nuevo Testamento', items: this.plan.nt });
			return g;
		},
	},
	watch: {
		'store.version'() { this.load(); },
		'store.date'() { this.load(); },
	},
	methods: {
		fmt(iso) {
			try {
				return new Date(iso + 'T00:00:00').toLocaleDateString('es', { weekday: 'long', day: 'numeric', month: 'long' });
			} catch { return iso; }
		},
		setDate(v) { this.store.date = v; },
		async load() {
			this.votd = null; this.err = ''; this.plan = null; this.planErr = '';
			const v = this.store.version, d = this.store.date;
			try { this.votd = await this.api.get(`/votd?v=${v}&date=${d}`); }
			catch (e) { this.err = e.message; }
			try { this.plan = await this.api.get(`/plan?v=${v}&date=${d}`); }
			catch (e) { this.planErr = e.message; }
		},
		fav() { if (this.votd) this.store.toggleFav({ ref: this.votd.ref, verses: this.votd.verses, version: this.store.version }); },
		async surprise() {
			try {
				const r = await this.api.get(`/random?v=${this.store.version}`);
				this.votd = { ref: r.ref, verses: [{ v: r.verse, t: r.t }], book: r.book, chapter: r.chapter };
			} catch (e) { this.err = e.message; }
		},
		share() {
			const text = this.votd.verses.map(x => x.t.replace(/<[^>]+>/g, '')).join(' ');
			const payload = `"${text}" — ${this.votd.ref} (${this.store.version})`;
			if (navigator.share) navigator.share({ text: payload }).catch(() => {});
			else { navigator.clipboard?.writeText(payload); alert('Copiado al portapapeles'); }
		},
	},
	mounted() { this.load(); },
};
</script>
