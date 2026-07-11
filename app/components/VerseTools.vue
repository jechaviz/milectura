<template>
	<div class="space-y-5 text-sm">
		<!-- Spiritual status -->
		<div>
			<p class="text-gold-soft mb-2">Estado</p>
			<div class="grid grid-cols-2 sm:grid-cols-4 gap-2">
				<button v-for="st in statuses" :key="st.s" @click="setStatus(st.s)"
					class="btn glass-soft !px-2 !py-2.5 transition flex-col !gap-1"
					:class="cur.s === st.s ? '!bg-white/20 ring-1 ring-gold/40' : 'text-white/80 hover:bg-white/12'">
					<span class="text-lg">{{ st.icon }}</span>
					<span class="text-xs">{{ st.label }}</span>
					<span class="text-xs font-bold" :style="{ color: st.color }">{{ st.tick }}</span>
				</button>
			</div>
			<p class="text-white/40 text-xs mt-2">Leído → Comprendido → Memorizado → Aplicado (en oración / vida práctica).</p>
		</div>

		<!-- Highlight -->
		<div>
			<p class="text-gold-soft mb-2">Resaltar</p>
			<div class="flex items-center gap-2 flex-wrap">
				<button v-for="h in hls" :key="h.key" @click="setHl(h.key)"
					class="w-8 h-8 rounded-full border transition"
					:style="{ background: h.bg, borderColor: cur.hl === h.key ? '#e8c37e' : 'rgba(255,255,255,0.15)' }"></button>
				<button @click="setHl('')" class="chip">Quitar</button>
			</div>
		</div>

		<!-- Note -->
		<div>
			<p class="text-gold-soft mb-2">Nota</p>
			<textarea :value="cur.note || ''" @input="setNote($event.target.value)"
				rows="4" placeholder="Escribe una reflexión, oración o aplicación…"
				class="w-full glass-soft rounded-2xl px-4 py-3 outline-none text-white/90 placeholder-white/30 resize-none"></textarea>
		</div>
	</div>
</template>

<script>
module.exports = {
	inject: ['store'],
	computed: {
		statuses() { return window.mlStatus.filter(Boolean); },
		hls() { return window.mlHl; },
		cur() { return this.store.getV(this.store.toolsKey); },
	},
	methods: {
		setStatus(s) { this.store.setV(this.store.toolsKey, { s: this.cur.s === s ? 0 : s }); },
		setHl(key) { this.store.setV(this.store.toolsKey, { hl: this.cur.hl === key ? '' : key }); },
		setNote(v) { this.store.setV(this.store.toolsKey, { note: v.trim() }); },
	},
};
</script>
