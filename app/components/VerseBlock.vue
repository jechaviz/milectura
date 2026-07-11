<template>
	<div class="verse leading-relaxed" :class="{ 'mem-on': interactive, blurred: activeStage === 'blur' }"
		@click="onClick" @pointerdown="onDown" @pointermove="onPointer"
		@pointerup="clearDwell" @pointercancel="clearDwell" @pointerleave="clearDwell">
		<div v-if="showBadge" class="mem-badge select-none flex items-center gap-2 mb-2 text-xs" @click.stop>
			<span v-if="gmode === 'libre'" class="px-2 py-0.5 rounded-full glass-soft text-gold-soft">{{ badge.label }}</span>
			<select v-else :value="gmode" @change="store && store.setMemMode($event.target.value)"
				@click.stop @pointerdown.stop
				class="glass-soft rounded-full px-2.5 py-0.5 text-gold-soft outline-none cursor-pointer">
				<option value="initials" class="text-ink">Iniciales</option>
				<option value="hidden" class="text-ink">Oculto</option>
				<option value="blur" class="text-ink">Difuminado</option>
			</select>
			<span class="text-white/40">{{ badge.hint }}</span>
		</div>
		<template v-for="v in display" :key="v.v">
			<div v-if="subheadings && subheadings[v.v]"
				class="font-serif text-gold-soft/90 text-[1.05em] mt-4 mb-1">{{ subheadings[v.v] }}</div>
			<span class="align-super text-[0.6em] text-gold/70 mr-1 select-none">{{ v.v }}</span><span v-html="v.t"></span>{{ ' ' }}
		</template>
	</div>
</template>

<script>
module.exports = {
	inject: { store: { default: null } },
	props: {
		verses: { type: Array, default: () => [] },
		subheadings: { type: Object, default: () => ({}) },
		// externally-controlled stage (the Memorizar deck forces its card hidden)
		forceStage: { type: String, default: '' },
		// never memorize (plain display) regardless of the global mode
		plain: { type: Boolean, default: false },
	},
	data() { return { stage: 'normal', active: false }; },
	computed: {
		gmode() { return this.plain ? 'off' : (this.store ? this.store.memMode : 'off'); },
		isForm() { return this.gmode === 'initials' || this.gmode === 'hidden' || this.gmode === 'blur'; },
		// resolved stage to render for THIS verse block:
		activeStage() {
			if (this.forceStage) return this.forceStage;
			if (this.gmode === 'off') return 'normal';
			if (this.gmode === 'libre') return this.stage;
			// form mode: normal until this verse is tapped to memorize it
			return this.active ? this.gmode : 'normal';
		},
		interactive() { return !this.forceStage && this.gmode !== 'off'; },
		showBadge() { return this.interactive; },
		badge() {
			if (this.gmode === 'libre') {
				const s = window.mlMem ? window.mlMem.stageInfo(this.stage) : { label: '', hint: '' };
				return { label: s.label, hint: this.stage === 'normal' ? 'Toca para esconder' : 'Toca para la siguiente forma' };
			}
			const one = this.verses.length <= 1;
			if (!this.active) return { label: 'Lectura', hint: one ? 'Toca para memorizar' : 'Toca para memorizar este pasaje' };
			if (this.gmode === 'blur') return { label: 'Difuminado', hint: 'Mantén sobre una palabra para revelarla · toca para leer' };
			const s = window.mlMem ? window.mlMem.stageInfo(this.gmode) : { label: '', hint: '' };
			return { label: s.label, hint: 'Toca para leer' };
		},
		display() {
			const mem = window.mlMem;
			const st = this.activeStage;
			if (!mem || st === 'normal') return this.verses;
			if (st === 'blur') return this.verses.map((v) => ({ v: v.v, t: mem.blurWords(v.t) }));
			return this.verses.map((v) => ({ v: v.v, t: mem.apply(v.t, st) }));
		},
	},
	watch: {
		gmode() { this.stage = 'normal'; this.active = false; },
	},
	methods: {
		onDown(e) {
			this._downAt = (typeof performance !== 'undefined') ? performance.now() : 0;
			this.onPointer(e);
		},
		onClick() {
			if (this.forceStage || this.gmode === 'off') return;
			if (this.gmode === 'libre') {
				const enabled = this.store ? this.store.memStages : null;
				this.stage = window.mlMem ? window.mlMem.nextStage(this.stage, enabled) : 'normal';
				return;
			}
			// form mode: a quick tap toggles THIS verse. A hold (used to reveal words
			// in blur) must not toggle — distinguish by press duration.
			const held = ((typeof performance !== 'undefined') ? performance.now() : 0) - (this._downAt || 0);
			if (this.gmode === 'blur' && this.active && held >= 220) return;
			this.active = !this.active;
		},
		// GRADUAL per-word reveal while the pointer dwells (blur, active verse only).
		onPointer(e) {
			if (this.activeStage !== 'blur') return;
			const el = document.elementFromPoint(e.clientX, e.clientY);
			const w = el && el.closest ? el.closest('.mw') : null;
			if (w === this._dwellMw) return;
			if (this._dwellMw) this._dwellMw.classList.remove('dwell');
			if (w) w.classList.add('dwell');
			this._dwellMw = w || null;
		},
		clearDwell() {
			if (this._dwellMw) { this._dwellMw.classList.remove('dwell'); this._dwellMw = null; }
		},
	},
};
</script>

<style>
.mem-on { cursor: pointer; }
/* per-word blur + gradual reveal live in the global stylesheet (.verse.blurred .mw) */
</style>
