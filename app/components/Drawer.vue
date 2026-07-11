<template>
	<teleport to="body">
		<transition name="drawer">
			<div v-if="open" class="fixed inset-0 z-[70]" @click.self="$emit('close')">
				<div class="drawer-backdrop absolute inset-0 bg-black/50" @click="$emit('close')"></div>
				<aside class="drawer-panel glass absolute overflow-y-auto" :class="panelClass">
					<div class="sticky top-0 flex items-center gap-2 px-5 py-4 border-b border-white/10 bg-white/5 backdrop-blur-xl z-10">
						<h2 class="font-serif text-lg text-gold-soft">{{ title }}</h2>
						<div class="flex-1"></div>
						<button @click="$emit('close')" class="w-8 h-8 rounded-full glass-soft hover:bg-white/15 leading-none">✕</button>
					</div>
					<div class="p-5">
						<slot />
					</div>
				</aside>
			</div>
		</transition>
	</teleport>
</template>

<script>
module.exports = {
	props: {
		open: { type: Boolean, default: false },
		title: { type: String, default: '' },
		side: { type: String, default: 'right' }, // 'right' | 'bottom'
	},
	emits: ['close'],
	computed: {
		panelClass() {
			return this.side === 'bottom'
				? 'inset-x-0 bottom-0 max-h-[85vh] rounded-t-3xl border-x-0 border-b-0 pb-[env(safe-area-inset-bottom)]'
				: 'top-0 right-0 h-full w-[min(26rem,92vw)] border-y-0 border-r-0 rounded-l-3xl';
		},
	},
	watch: {
		open(v) {
			// lock body scroll while the drawer is open
			document.documentElement.style.overflow = v ? 'hidden' : '';
		},
	},
	unmounted() { document.documentElement.style.overflow = ''; },
};
</script>

<style>
.drawer-enter-active, .drawer-leave-active { transition: opacity .28s ease; }
.drawer-enter-active .drawer-panel, .drawer-leave-active .drawer-panel { transition: transform .28s cubic-bezier(.22,.61,.36,1); }
.drawer-enter-from, .drawer-leave-to { opacity: 0; }
/* right panel slides in from the right; bottom sheet slides up */
.drawer-enter-from .drawer-panel.rounded-l-3xl,
.drawer-leave-to .drawer-panel.rounded-l-3xl { transform: translateX(100%); }
.drawer-enter-from .drawer-panel.rounded-t-3xl,
.drawer-leave-to .drawer-panel.rounded-t-3xl { transform: translateY(100%); }
</style>
