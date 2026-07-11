<template>
	<div class="space-y-6 text-sm">
		<!-- Scout-style journey: how far this verse has come in your life -->
		<div>
			<div class="flex items-baseline gap-2 mb-3">
				<p class="text-gold-soft">Recorrido en tu vida</p>
				<span class="text-white/40 text-xs">revelación → práctica</span>
			</div>
			<div class="flex items-center">
				<template v-for="(st, i) in statuses" :key="st.s">
					<button @click="setStatus(st.s)" class="flex flex-col items-center gap-1 flex-1 min-w-0 group">
						<span class="badge-node" :class="{ on: earned(st.s), now: cur.s === st.s }"
							:style="earned(st.s) ? { borderColor: st.color, background: st.color + '22', boxShadow: '0 0 14px ' + st.color + '55' } : {}">{{ st.icon }}</span>
						<span class="text-[0.68rem] leading-tight text-center transition"
							:style="earned(st.s) ? { color: st.color } : {}"
							:class="earned(st.s) ? '' : 'text-white/35'">{{ st.label }}</span>
					</button>
					<span v-if="i < statuses.length - 1" class="trail-line"
						:style="cur.s > st.s ? { background: st.color } : {}"></span>
				</template>
			</div>
			<p class="text-center mt-3 text-xs">
				<template v-if="cur.s">Insignia actual: <b :style="{ color: rank.color }">{{ rank.icon }} {{ rank.label }}</b></template>
				<span v-else class="text-white/40">Toca una etapa para marcar tu avance.</span>
			</p>
		</div>

		<!-- Highlight -->
		<div class="border-t border-white/10 pt-4">
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
		rank() { return window.mlStatus[this.cur.s] || {}; },
	},
	methods: {
		earned(s) { return (this.cur.s || 0) >= s; },
		setStatus(s) { this.store.setV(this.store.toolsKey, { s: this.cur.s === s ? 0 : s }); },
		setHl(key) { this.store.setV(this.store.toolsKey, { hl: this.cur.hl === key ? '' : key }); },
		setNote(v) { this.store.setV(this.store.toolsKey, { note: v.trim() }); },
	},
};
</script>

<style>
.badge-node {
	width: 2.6rem; height: 2.6rem; border-radius: 50%;
	display: grid; place-items: center; font-size: 1.15rem;
	border: 2px solid rgba(255,255,255,0.15); background: rgba(255,255,255,0.05);
	filter: grayscale(0.7) opacity(0.6); transition: all .25s ease;
}
.badge-node.on { filter: none; }
.badge-node.now { transform: scale(1.12); }
.trail-line { height: 3px; flex: 1; border-radius: 3px; background: rgba(255,255,255,0.12); margin: 0 -2px 1.1rem; transition: background .25s ease; }
</style>
