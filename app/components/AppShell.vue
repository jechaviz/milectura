<template>
	<div class="min-h-screen font-sans text-white/90" :class="{ forgetica: store.forgetica }" :style="{ fontSize: (store.fontScale) + 'rem' }">
		<!-- Top bar -->
		<header class="sticky top-0 z-50 glass border-x-0 border-t-0">
			<div class="max-w-6xl mx-auto px-4 py-3 flex items-center gap-2 sm:gap-3">
				<a href="#/hoy" class="flex items-center gap-2 no-underline shrink-0">
					<img src="img/logo.png" alt="" class="w-9 h-9 rounded-xl" />
					<span class="hidden min-[420px]:block md:block font-serif text-lg text-gold-soft leading-none">Mi Lectura<br /><span class="text-xs text-white/50 font-sans tracking-wide">DIARIA</span></span>
				</a>

				<!-- Desktop inline nav -->
				<nav class="hidden md:flex items-center gap-1 mx-2 flex-1 justify-center">
					<a v-for="t in tabs" :key="t.hash" :href="'#' + t.hash"
						class="px-3 py-1.5 rounded-full no-underline text-sm transition flex items-center gap-1.5"
						:class="isActive(t.hash) ? 'text-gold-soft bg-white/12' : 'text-white/60 hover:text-white/90 hover:bg-white/5'">
						<span>{{ t.icon }}</span><span>{{ t.label }}</span>
					</a>
				</nav>

				<div class="flex-1 md:hidden"></div>
				<select :value="store.version" @change="store.setVersion($event.target.value)"
					class="glass-soft rounded-full px-2.5 py-1.5 text-sm text-white/90 outline-none cursor-pointer shrink-0">
					<option v-for="b in store.bibles" :key="b.id" :value="b.id" class="text-ink">{{ b.id }}</option>
				</select>
				<div class="flex items-center gap-1 glass-soft rounded-full px-1.5 py-1 shrink-0">
					<button @click="store.setFont(store.fontScale - 0.1)" title="Reducir texto" class="w-7 h-7 rounded-full hover:bg-white/15 leading-none">A-</button>
					<button @click="store.setFont(store.fontScale + 0.1)" title="Aumentar texto" class="w-7 h-7 rounded-full hover:bg-white/15 text-lg leading-none">A+</button>
				</div>
				<button @click="fav = true" title="Guardados"
					class="relative w-9 h-9 rounded-full glass-soft leading-none text-white/70 hover:text-white transition shrink-0">
					❤<span v-if="store.favorites.length" class="absolute -top-1 -right-1 text-[0.6rem] bg-gold text-ink-900 rounded-full min-w-[1rem] h-4 px-1 grid place-items-center font-semibold">{{ store.favorites.length }}</span>
				</button>
				<button @pointerdown="brainDown" @pointerup="brainUp" @pointerleave="brainUp" @click="brainClick"
					title="Tap: memorizar todo / revelar todo · Mantén: opciones"
					class="w-9 h-9 rounded-full glass-soft leading-none transition shrink-0"
					:class="store.memAll ? 'text-gold-soft bg-white/15 ring-1 ring-gold/40' : 'text-white/70 hover:text-white'">🧠</button>
			</div>
		</header>

		<!-- Routed view -->
		<main class="max-w-6xl mx-auto px-4 sm:px-6 pb-28 md:pb-16 pt-6 md:pt-8">
			<transition name="fade" mode="out-in">
				<component :is="view" :key="route" />
			</transition>
		</main>

		<!-- Bottom tab nav (mobile only) -->
		<nav class="fixed bottom-0 inset-x-0 z-50 glass border-x-0 border-b-0 md:hidden">
			<div class="px-1 grid gap-0.5 py-1.5" :style="{ gridTemplateColumns: 'repeat(' + tabs.length + ',minmax(0,1fr))' }">
				<a v-for="t in tabs" :key="t.hash" :href="'#' + t.hash"
					class="flex flex-col items-center gap-0.5 py-1.5 rounded-2xl no-underline transition"
					:class="isActive(t.hash) ? 'text-gold-soft bg-white/10' : 'text-white/55 hover:text-white/85'">
					<span class="text-xl leading-none">{{ t.icon }}</span>
					<span class="text-[0.68rem] tracking-wide">{{ t.label }}</span>
				</a>
			</div>
		</nav>

		<!-- Global drawers (available from every view) -->
		<Drawer :open="mem" title="Memorización" side="bottom" @close="mem = false">
			<MemPanel @close="mem = false" />
		</Drawer>
		<Drawer :open="fav" title="Guardado en mi corazón" side="right" @close="fav = false">
			<Favorites embedded @open="fav = false" />
		</Drawer>
	</div>
</template>

<script>
module.exports = {
	inject: ['store', 'comp'],
	components: {
		Drawer: window.mlComp('Drawer'),
		MemPanel: window.mlComp('MemPanel'),
		Favorites: window.mlComp('Favorites'),
	},
	data() {
		return {
			route: location.hash || '#/hoy',
			mem: false,
			fav: false,
			tabs: [
				{ hash: '/hoy', label: 'Hoy', icon: '✦' },
				{ hash: '/biblia', label: 'Biblia', icon: '📖' },
				{ hash: '/buscar', label: 'Buscar', icon: '🔍' },
				{ hash: '/memorizar', label: 'Memorizar', icon: '🧠' },
			],
		};
	},
	computed: {
		base() { return (this.route.split('?')[0] || '#/hoy').replace('#', ''); },
		view() {
			const map = {
				'/hoy': 'Today',
				'/biblia': 'Reader',
				'/leer': 'Reader', // legacy alias
				'/buscar': 'Search',
				'/memorizar': 'Memorize',
			};
			return this.comp(map[this.base] || 'Today');
		},
	},
	methods: {
		isActive(hash) { return this.base === hash || (hash === '/biblia' && this.base === '/leer'); },
		onHash() { this.route = location.hash || '#/hoy'; this.mem = false; this.fav = false; window.scrollTo({ top: 0, behavior: 'smooth' }); },
		// 🧠: short tap toggles memorize-all/reveal-all; long-press opens options.
		brainDown() { this._long = false; this._t = setTimeout(() => { this._long = true; this.mem = true; }, 420); },
		brainUp() { clearTimeout(this._t); },
		brainClick() { if (this._long) { this._long = false; return; } this.store.toggleMemAll(); },
	},
	mounted() {
		window.addEventListener('hashchange', this.onHash);
		if (!location.hash) location.hash = '#/hoy';
	},
	unmounted() { window.removeEventListener('hashchange', this.onHash); },
};
</script>
