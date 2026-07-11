<template>
	<div class="space-y-5 text-sm">
		<p class="text-white/60 leading-relaxed">
			Elige cómo se esconde el texto. Lees normal y <b class="text-white/85">tocas un pasaje
			para memorizarlo</b> (solo ese conjunto de versículos). Toca de nuevo para leerlo.
			Atajo: toca 🧠 para alternar memorizar / solo lectura.
		</p>

		<!-- Global mode -->
		<div>
			<p class="text-gold-soft mb-2">Modo</p>
			<div class="grid grid-cols-2 gap-2">
				<button v-for="m in modes" :key="m.key" @click="store.setMemMode(m.key)"
					class="btn glass-soft justify-start !px-3 !py-2.5 text-left transition"
					:class="store.memMode === m.key ? '!bg-white/20 text-gold-soft ring-1 ring-gold/40' : 'text-white/80 hover:bg-white/12'">
					<span class="text-lg mr-1">{{ m.icon }}</span>
					<span class="leading-tight">{{ m.label }}<br /><span class="text-[0.7rem] text-white/40">{{ m.hint }}</span></span>
				</button>
			</div>
		</div>

		<!-- Which forms the "Libre" cycle steps through -->
		<div v-show="store.memMode === 'libre'">
			<p class="text-gold-soft mb-2">Formas en el ciclo</p>
			<div class="flex gap-2 flex-wrap">
				<button v-for="st in forms" :key="st.key" class="chip"
					:class="store.memStages.includes(st.key) ? '!bg-white/20 text-gold-soft' : 'opacity-50'"
					@click="store.toggleMemStage(st.key)">
					<span>{{ store.memStages.includes(st.key) ? '✓' : '' }}</span> {{ st.label }}
				</button>
			</div>
			<p class="text-white/40 text-xs mt-2">Al tocar un versículo avanza: completo → {{ enabledLabels }} → completo.</p>
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

		<!-- Practice deck link -->
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
			modes: [
				{ key: 'off', icon: '📖', label: 'Completo', hint: 'lectura normal' },
				{ key: 'libre', icon: '👆', label: 'Libre', hint: 'toca para esconder' },
				{ key: 'initials', icon: 'Aᐧ', label: 'Iniciales', hint: '1ª letra' },
				{ key: 'hidden', icon: '⋯', label: 'Oculto', hint: 'solo estructura' },
				{ key: 'blur', icon: '🌫', label: 'Difuminado', hint: 'borroso' },
			],
			forms: (window.mlMem && window.mlMem.STAGES ? window.mlMem.STAGES.filter((s) => s.key !== 'normal') : []),
		};
	},
	computed: {
		enabledLabels() {
			return this.forms.filter((s) => this.store.memStages.includes(s.key)).map((s) => s.label.toLowerCase()).join(' → ');
		},
	},
};
</script>
