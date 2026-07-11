<template>
	<div :class="embedded ? 'space-y-4' : 'space-y-5'">
		<section v-if="!embedded" class="glass rounded-3xl p-5 sm:p-7 flex items-center gap-3">
			<h1 class="font-serif text-2xl text-gold-soft">Guardado en mi corazón</h1>
			<div class="flex-1"></div>
			<span class="text-white/40 text-sm">{{ store.favorites.length }} versículo(s)</span>
		</section>

		<div v-if="!store.favorites.length" class="text-center text-white/40 py-12 font-serif">
			Aún no has guardado versículos.<br />
			<span class="text-sm font-sans text-white/40">Toca ♡ en cualquier versículo para atesorarlo aquí.</span>
		</div>

		<div v-else :class="embedded ? 'space-y-4' : 'grid sm:grid-cols-2 lg:grid-cols-3 gap-4'">
			<div v-for="f in store.favorites" :key="f.ref + f.savedAt" class="glass rounded-3xl p-5 flex flex-col">
				<div class="flex items-center gap-2 mb-2">
					<a :href="'#/biblia?b='+(f.book||'')+'&c='+(f.chapter||'')" @click="$emit('open')"
						class="text-gold-soft font-medium no-underline hover:underline">{{ f.ref }}</a>
					<span class="text-white/30 text-xs">{{ f.version }}</span>
					<div class="flex-1"></div>
					<button class="text-white/40 hover:text-red-300 transition" @click="store.toggleFav(f)">✕</button>
				</div>
				<VerseBlock :verses="f.verses" :book="f.book||0" :chapter="f.chapter||0" :refLabel="(f.ref||'').split(':')[0]" class="font-serif text-white/85 flex-1" />
				<button class="chip mt-3 self-start" @click="copy(f)">↗ Copiar</button>
			</div>
		</div>
	</div>
</template>

<script>
module.exports = {
	inject: ['store'],
	components: { VerseBlock: window.mlComp('VerseBlock') },
	props: { embedded: { type: Boolean, default: false } },
	emits: ['open'],
	methods: {
		copy(f) {
			const text = f.verses.map(x => x.t.replace(/<[^>]+>/g, '')).join(' ');
			const payload = `"${text}" — ${f.ref} (${f.version})`;
			navigator.clipboard?.writeText(payload);
			alert('Copiado');
		},
	},
};
</script>
