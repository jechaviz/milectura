<template>
	<div class="min-h-screen font-sans text-white/90" :class="{ forgetica: store.forgetica }" :style="{ fontSize: (store.fontScale) + 'rem' }">
		<!-- Top bar -->
		<header class="sticky top-0 z-50 glass border-x-0 border-t-0">
			<div class="max-w-5xl mx-auto px-4 py-3 flex items-center gap-3">
				<a href="#/hoy" class="flex items-center gap-2 no-underline">
					<img src="img/logo.png" alt="" class="w-9 h-9 rounded-xl" />
					<span class="font-serif text-lg text-gold-soft leading-none">Mi Lectura<br /><span class="text-xs text-white/50 font-sans tracking-wide">DIARIA</span></span>
				</a>
				<div class="flex-1"></div>
				<select :value="store.version" @change="store.setVersion($event.target.value)"
					class="glass-soft rounded-full px-3 py-1.5 text-sm text-white/90 outline-none cursor-pointer">
					<option v-for="b in store.bibles" :key="b.id" :value="b.id" class="text-ink">{{ b.id }}</option>
				</select>
				<button @click="store.toggleForgetica()" :title="store.forgetica ? 'Fuente normal' : 'Sans Forgetica (ayuda a memorizar)'"
					class="w-9 h-9 rounded-full glass-soft leading-none transition"
					:class="store.forgetica ? 'text-gold-soft bg-white/15' : 'text-white/60 hover:text-white'">🧠</button>
				<div class="hidden sm:flex items-center gap-1 glass-soft rounded-full px-1.5 py-1">
					<button @click="store.setFont(store.fontScale - 0.1)" class="w-7 h-7 rounded-full hover:bg-white/15 leading-none">A-</button>
					<button @click="store.setFont(store.fontScale + 0.1)" class="w-7 h-7 rounded-full hover:bg-white/15 text-lg leading-none">A+</button>
				</div>
			</div>
		</header>

		<!-- Routed view -->
		<main class="max-w-5xl mx-auto px-4 pb-28 pt-6">
			<transition name="fade" mode="out-in">
				<component :is="view" :key="route" />
			</transition>
		</main>

		<!-- Bottom tab nav -->
		<nav class="fixed bottom-0 inset-x-0 z-50 glass border-x-0 border-b-0">
			<div class="max-w-5xl mx-auto px-1 grid grid-cols-6 gap-0.5 py-1.5">
				<a v-for="t in tabs" :key="t.hash" :href="'#' + t.hash"
					class="flex flex-col items-center gap-0.5 py-1.5 rounded-2xl no-underline transition"
					:class="isActive(t.hash) ? 'text-gold-soft bg-white/10' : 'text-white/55 hover:text-white/85'">
					<span class="text-xl leading-none">{{ t.icon }}</span>
					<span class="text-[0.68rem] tracking-wide">{{ t.label }}</span>
				</a>
			</div>
		</nav>
	</div>
</template>

<script>
module.exports = {
	inject: ['store', 'comp'],
	data() {
		return {
			route: location.hash || '#/hoy',
			tabs: [
				{ hash: '/hoy', label: 'Hoy', icon: '✦' },
				{ hash: '/leer', label: 'Leer', icon: '📖' },
				{ hash: '/buscar', label: 'Buscar', icon: '🔍' },
				{ hash: '/memorizar', label: 'Memorizar', icon: '🧠' },
				{ hash: '/devocional', label: 'Devoción', icon: '🕊️' },
				{ hash: '/guardados', label: 'Guardado', icon: '❤' },
			],
		};
	},
	computed: {
		base() { return (this.route.split('?')[0] || '#/hoy').replace('#', ''); },
		view() {
			const map = {
				'/hoy': 'Today',
				'/leer': 'Reader',
				'/buscar': 'Search',
				'/memorizar': 'Memorize',
				'/devocional': 'Devotional',
				'/guardados': 'Favorites',
			};
			return this.comp(map[this.base] || 'Today');
		},
	},
	methods: {
		isActive(hash) { return this.base === hash; },
		onHash() { this.route = location.hash || '#/hoy'; window.scrollTo({ top: 0, behavior: 'smooth' }); },
	},
	mounted() {
		window.addEventListener('hashchange', this.onHash);
		if (!location.hash) location.hash = '#/hoy';
	},
	unmounted() { window.removeEventListener('hashchange', this.onHash); },
};
</script>
