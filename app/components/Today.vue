<template>
	<div class="space-y-6">
		<!-- Hero: verse of the day -->
		<section class="glass rounded-3xl overflow-hidden relative">
			<div class="absolute inset-0 -z-10 opacity-40 bg-cover bg-center" :style="heroBg"></div>
			<div class="p-7 sm:p-10 lg:p-14 lg:max-w-4xl">
				<p class="text-xs tracking-[0.25em] text-gold-soft/80 uppercase mb-3">Versículo de hoy · {{ prettyDate }}</p>
				<div v-if="votd" class="font-serif text-2xl sm:text-3xl lg:text-4xl leading-snug text-white">
					<VerseBlock :verses="votd.verses" :book="votd.book" :chapter="votd.chapter" :refLabel="(votd.ref||'').split(':')[0]" />
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
			<div class="flex items-center gap-x-3 gap-y-2 flex-wrap justify-between mb-4">
				<div class="flex items-baseline gap-2 min-w-0">
					<h2 class="font-serif text-xl text-gold-soft whitespace-nowrap">Lectura del día</h2>
					<span class="text-white/40 text-sm whitespace-nowrap">plan de un año</span>
				</div>
				<div class="flex items-center gap-1 shrink-0">
					<button @click="stepDate(-1)" title="Lectura anterior" class="w-8 h-8 rounded-full glass-soft hover:bg-white/15 leading-none">‹</button>
					<input type="date" :value="store.date" @change="setDate($event.target.value)"
						class="glass-soft rounded-full px-3 py-1 text-sm outline-none" />
					<button @click="stepDate(1)" title="Lectura siguiente" class="w-8 h-8 rounded-full glass-soft hover:bg-white/15 leading-none">›</button>
					<button v-if="store.date !== todayISO()" @click="store.date = todayISO()" title="Hoy"
						class="ml-1 chip !py-1">Hoy</button>
				</div>
			</div>

			<div v-if="planErr" class="text-white/60">{{ planErr }}</div>
			<div v-else-if="!plan" class="space-y-2">
				<div class="h-4 bg-white/5 rounded animate-pulse" v-for="i in 4" :key="i"></div>
			</div>
			<div v-else class="space-y-4">
				<!-- New Testament pinned first, then the Old (each pinnable/collapsible) -->
				<div v-for="grp in orderedGroups" :key="grp.key" class="glass-soft rounded-2xl overflow-hidden">
					<button @click="togglePin(grp.key)" class="w-full flex items-center gap-2 px-4 py-3 text-left transition hover:bg-white/5">
						<span class="text-xs px-2 py-0.5 rounded-full bg-white/10 text-gold-soft whitespace-nowrap">{{ grp.tag }}</span>
						<span class="text-white/50 text-sm truncate flex-1 min-w-0">{{ grp.items.map(i => i.ref).join(' · ') }}</span>
						<span class="text-base shrink-0" :title="pinned(grp.key) ? 'Fijado' : 'Fijar'"
							:class="pinned(grp.key) ? '' : 'opacity-35 grayscale'">📌</span>
					</button>
					<div v-show="pinned(grp.key)" class="px-4 pb-4 pt-1">
						<div v-for="p in grp.items" :key="p.ref" class="mb-4">
							<h3 class="font-serif text-lg text-white/90 mb-1">{{ p.ref }}</h3>
							<VerseBlock :verses="p.verses" :subheadings="p.subheadings" :book="p.book" :chapter="p.chapter" :refLabel="p.ref" class="text-white/85 max-w-prose" />
						</div>
					</div>
				</div>
			</div>
		</section>

		<!-- Devotional of the day (pinnable/collapsible) -->
		<section v-if="devoHtml || devoErr" class="glass rounded-3xl overflow-hidden">
			<button @click="togglePin('devo')" class="w-full flex items-center gap-3 px-6 py-4 text-left transition hover:bg-white/5">
				<h2 class="font-serif text-xl text-gold-soft shrink-0">Devocional</h2>
				<span v-if="devoName" class="text-white/40 text-sm truncate flex-1 min-w-0">{{ devoName }}</span>
				<span class="text-base shrink-0" :title="pinned('devo') ? 'Fijado' : 'Fijar'"
					:class="pinned('devo') ? '' : 'opacity-35 grayscale'">📌</span>
			</button>
			<div v-show="pinned('devo')" class="px-6 pb-8 sm:px-8 lg:px-10">
				<div v-if="devoErr" class="text-white/50 text-sm">{{ devoErr }}</div>
				<div v-else class="devo mx-auto max-w-3xl" v-html="devoHtml"></div>
			</div>
		</section>
	</div>
</template>

<script>
module.exports = {
	inject: ['api', 'store', 'comp', 'todayISO'],
	components: { VerseBlock: window.mlComp('VerseBlock') },
	data() {
		return { votd: null, err: '', plan: null, planErr: '', devoHtml: '', devoName: '', devoErr: '',
			pins: JSON.parse(localStorage.getItem('ml_pins') || '{"nt":true,"ot":false,"devo":false}'), heroImgs: [
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
		orderedGroups() {
			if (!this.plan) return [];
			const g = [];
			// New Testament first (pinned), then the Old.
			if (this.plan.nt?.length) g.push({ key: 'nt', tag: 'Nuevo Testamento', items: this.plan.nt });
			if (this.plan.ot?.length) g.push({ key: 'ot', tag: 'Antiguo Testamento', items: this.plan.ot });
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
		setDate(v) { if (v) this.store.date = v; },
		pinned(k) { return !!this.pins[k]; },
		togglePin(k) { this.pins = { ...this.pins, [k]: !this.pins[k] }; localStorage.setItem('ml_pins', JSON.stringify(this.pins)); },
		stepDate(delta) {
			const d = new Date(this.store.date + 'T00:00:00');
			d.setDate(d.getDate() + delta);
			this.store.date = this.todayISO(d);
		},
		async load() {
			this.votd = null; this.err = ''; this.plan = null; this.planErr = '';
			const v = this.store.version, d = this.store.date;
			try { this.votd = await this.api.get(`/votd?v=${v}&date=${d}`); }
			catch (e) { this.err = e.message; }
			try { this.plan = await this.api.get(`/plan?v=${v}&date=${d}`); }
			catch (e) { this.planErr = e.message; }
			this.devoHtml = ''; this.devoName = ''; this.devoErr = '';
			try { const dv = await this.api.get(`/devotion?date=${d}`); this.devoHtml = dv.html; this.devoName = dv.name; }
			catch (e) { this.devoErr = 'Sin devocional para hoy.'; }
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
