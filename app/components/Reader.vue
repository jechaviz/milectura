<template>
	<div class="space-y-5">
		<!-- Book / chapter picker -->
		<section class="glass rounded-3xl p-4 sm:p-5">
			<div class="flex flex-wrap items-center gap-3">
				<select :value="book" @change="selectBook(+$event.target.value)"
					class="glass-soft rounded-full px-4 py-2 outline-none cursor-pointer flex-1 min-w-[10rem]">
					<option v-for="b in books" :key="b.n" :value="b.n" class="text-ink">{{ b.name }}</option>
				</select>
				<div class="flex items-center gap-1 glass-soft rounded-full px-2 py-1">
					<button class="w-8 h-8 rounded-full hover:bg-white/15" @click="go(-1)">‹</button>
					<span class="px-2 text-sm">Cap. {{ chapter }} / {{ maxChapter || '…' }}</span>
					<button class="w-8 h-8 rounded-full hover:bg-white/15" @click="go(1)">›</button>
				</div>
			</div>
			<div v-if="books.length" class="mt-3 flex gap-1 flex-wrap max-h-24 overflow-y-auto">
				<button v-for="c in maxChapter" :key="c" @click="loadChapter(book, c)"
					class="w-8 h-8 rounded-lg text-sm transition"
					:class="c === chapter ? 'bg-gold text-ink-900 font-semibold' : 'glass-soft hover:bg-white/15'">{{ c }}</button>
			</div>
		</section>

		<!-- Chapter text -->
		<section class="glass rounded-3xl p-6 sm:p-9">
			<div v-if="err" class="text-white/60">{{ err }}</div>
			<div v-else-if="!data" class="space-y-2">
				<div class="h-4 bg-white/5 rounded animate-pulse" v-for="i in 8" :key="i" :style="{ width: (60 + (i*4)%38) + '%' }"></div>
			</div>
			<div v-else>
				<div class="flex items-baseline gap-3 mb-4">
					<h1 class="font-serif text-3xl text-gold-soft">{{ data.bookName }} {{ data.chapter }}</h1>
					<div class="flex-1"></div>
					<button class="chip" @click="toggleCommentary">{{ showComm ? 'Ocultar notas' : '✦ Notas' }}</button>
				</div>
				<VerseBlock :verses="data.verses" :subheadings="data.subheadings" class="font-serif text-[1.15em] text-white/90" />

				<!-- Commentary -->
				<div v-if="showComm" class="mt-8 pt-6 border-t border-white/10">
					<h3 class="font-serif text-lg text-gold-soft mb-3">Comentarios y referencias</h3>
					<div v-if="commLoading" class="text-white/50 text-sm">Cargando…</div>
					<div v-else-if="!commentary.length" class="text-white/40 text-sm">Sin notas para este capítulo.</div>
					<div v-else class="space-y-3">
						<div v-for="(c,i) in commentary" :key="i" class="glass-soft rounded-2xl p-3 text-sm">
							<span class="text-gold-soft font-medium mr-2">v. {{ c.from }}<template v-if="c.to>c.from">–{{ c.to }}</template></span>
							<span v-html="c.text" class="text-white/80"></span>
						</div>
					</div>
				</div>

				<div class="mt-8 flex justify-between">
					<button class="btn-ghost" @click="go(-1)">‹ Anterior</button>
					<button class="btn-ghost" @click="go(1)">Siguiente ›</button>
				</div>
			</div>
		</section>
	</div>
</template>

<script>
module.exports = {
	inject: ['api', 'store'],
	components: { VerseBlock: window.mlComp('VerseBlock') },
	data() {
		return { books: [], book: 500, chapter: 1, maxChapter: 0, data: null, err: '',
			showComm: false, commentary: [], commLoading: false };
	},
	watch: {
		'store.version'() { this.loadBooks(true); },
	},
	methods: {
		async loadBooks(keep) {
			try {
				const r = await this.api.get(`/books?v=${this.store.version}`);
				this.books = r.books;
				if (!keep || !this.books.some(b => b.n === this.book)) this.book = this.books[0]?.n || 500;
				const cur = this.books.find(b => b.n === this.book);
				this.maxChapter = cur ? cur.chapters : 0;
				await this.loadChapter(this.book, keep ? this.chapter : 1);
			} catch (e) { this.err = e.message; }
		},
		selectBook(n) {
			this.book = n;
			const cur = this.books.find(b => b.n === n);
			this.maxChapter = cur ? cur.chapters : 0;
			this.loadChapter(n, 1);
		},
		async loadChapter(b, c) {
			this.err = ''; this.data = null; this.showComm = false; this.commentary = [];
			try {
				const sub = this.subMod();
				const q = `/chapter?v=${this.store.version}&b=${b}&c=${c}` + (sub ? `&sub=${sub}` : '');
				this.data = await this.api.get(q);
				this.book = b; this.chapter = c; this.maxChapter = this.data.maxChapter;
				window.scrollTo({ top: 0, behavior: 'smooth' });
			} catch (e) { this.err = e.message; }
		},
		go(d) {
			let c = this.chapter + d, b = this.book;
			if (c < 1) { const i = this.books.findIndex(x => x.n === b); if (i > 0) { b = this.books[i-1].n; c = this.books[i-1].chapters; } else return; }
			else if (c > this.maxChapter) { const i = this.books.findIndex(x => x.n === b); if (i < this.books.length-1) { b = this.books[i+1].n; c = 1; } else return; }
			this.loadChapter(b, c);
		},
		subMod() { const s = this.store.modules.find(m => m.kind === 'subheadings'); return s ? s.id : ''; },
		commMod() { const s = this.store.modules.find(m => m.kind === 'commentaries'); return s ? s.id : ''; },
		async toggleCommentary() {
			this.showComm = !this.showComm;
			if (this.showComm && !this.commentary.length) {
				const m = this.commMod();
				if (!m) return;
				this.commLoading = true;
				try { const r = await this.api.get(`/commentary?m=${m}&b=${this.book}&c=${this.chapter}`); this.commentary = r.entries; }
				catch { this.commentary = []; }
				this.commLoading = false;
			}
		},
	},
	mounted() {
		// deep-link support: #/leer?b=500&c=3
		const qs = new URLSearchParams((location.hash.split('?')[1]) || '');
		if (qs.get('b')) this.book = +qs.get('b');
		if (qs.get('c')) this.chapter = +qs.get('c');
		this.loadBooks(true);
	},
};
</script>
