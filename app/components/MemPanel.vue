<template>
	<div class="space-y-5 text-sm">
		<p class="text-white/60 leading-relaxed">
			Lees normal y <b class="text-white/85">tocas un pasaje para memorizarlo</b>
			(solo ese conjunto de versículos). Toca de nuevo para leerlo.
		</p>

		<!-- Memorize-all toggle -->
		<div class="flex items-center gap-3">
			<button @click="store.toggleMemAll()"
				class="btn glass-soft !px-3 !py-2 transition"
				:class="store.memAll ? '!bg-white/20 text-gold-soft ring-1 ring-gold/40' : 'text-white/80 hover:bg-white/12'">
				{{ store.memAll ? '🧠 Memorizando todo' : '📖 Solo lectura' }}
			</button>
			<span class="text-white/40 text-xs">Atajo: toca 🧠 en la barra.</span>
		</div>

		<!-- Method -->
		<div>
			<p class="text-gold-soft mb-2">Método</p>
			<div class="grid grid-cols-3 gap-2">
				<button v-for="m in forms" :key="m.key" @click="store.setMemMode(m.key)"
					class="btn glass-soft !px-2 !py-2.5 transition flex-col !gap-0.5"
					:class="store.memMode === m.key ? '!bg-white/20 text-gold-soft ring-1 ring-gold/40' : 'text-white/80 hover:bg-white/12'">
					<span class="text-lg">{{ m.icon }}</span>
					<span class="text-xs">{{ m.label }}</span>
				</button>
			</div>
		</div>

		<!-- Sans Forgetica -->
		<div class="border-t border-white/10 pt-4 flex items-center gap-3">
			<button @click="store.toggleForgetica()"
				class="btn glass-soft !px-3 !py-2 transition"
				:class="store.forgetica ? '!bg-white/20 text-gold-soft' : 'text-white/80 hover:bg-white/12'">
				🧠 Sans Forgetica {{ store.forgetica ? '✓' : '' }}
			</button>
			<span class="text-white/40 text-xs">Tipografía que ayuda a recordar.</span>
		</div>

		<a href="#/memorizar" @click="$emit('close')"
			class="btn-gold w-full justify-center no-underline">Practicar con el mazo →</a>
	</div>
</template>

<script>
module.exports = {
	inject: ['store'],
	emits: ['close'],
	data() {
		return {
			forms: [
				{ key: 'initials', icon: 'Aᐧ', label: 'Iniciales' },
				{ key: 'hidden', icon: '⋯', label: 'Oculto' },
				{ key: 'blur', icon: '🌫', label: 'Difuminado' },
			],
		};
	},
};
</script>
