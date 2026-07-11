<template>
	<div class="verse leading-relaxed" :class="{ 'mem-on': interactive, blurred: activeStage === 'blur' }"
		@click="onClick" @pointerdown="onDown" @pointermove="onPointer"
		@pointerup="clearDwell" @pointercancel="clearDwell" @pointerleave="clearDwell">
		<div v-if="showBadge" class="mem-badge select-none flex items-center gap-2 mb-2 text-xs" @click.stop>
			<select :value="form" @change="store && store.setMemMode($event.target.value)"
				@click.stop @pointerdown.stop
				class="glass-soft rounded-full px-2.5 py-0.5 text-gold-soft outline-none cursor-pointer">
				<option value="initials" class="text-ink">Iniciales</option>
				<option value="hidden" class="text-ink">Oculto</option>
				<option value="blur" class="text-ink">Difuminado</option>
			</select>
			<span class="text-white/40">{{ hint }}</span>
		</div>
		<template v-for="v in display" :key="v.v">
			<div v-if="subheadings && subheadings[v.v]"
				class="font-serif text-gold-soft/90 text-[1.05em] mt-4 mb-1">{{ subheadings[v.v] }}</div><span
				v-if="canAnnotate" class="vnum-wrap" @click.stop="openTools(v.v)" @pointerdown.stop @pointerup.stop
				:title="'Marcar / resaltar / nota'"><span class="vnum">{{ v.v }}</span><span
				v-if="statusOf(v.v)" class="vbadge" :style="{ borderColor: statusOf(v.v).color, background: statusOf(v.v).color + '26' }" :title="statusOf(v.v).label">{{ statusOf(v.v).icon }}</span></span><span
				v-else class="align-super text-[0.6em] text-gold/70 mr-1 select-none">{{ v.v }}</span> <span
				v-html="v.t" :class="{ vhl: !!hlOf(v.v) }" :style="hlOf(v.v) ? { background: hlOf(v.v) } : {}"></span><span
				v-if="hasNote(v.v)" class="vnote-flag" @click.stop="openTools(v.v)" @pointerdown.stop title="Nota">🗒</span>{{ ' ' }}
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
		// never memorize (plain display) regardless of the global state
		plain: { type: Boolean, default: false },
		// verse-annotation context (status / highlight / notes). Disabled if absent.
		book: { type: Number, default: 0 },
		chapter: { type: Number, default: 0 },
		refLabel: { type: String, default: '' },
	},
	data() { return { active: false }; },
	computed: {
		form() { return this.store ? this.store.memMode : 'blur'; },
		memAll() { return this.store ? this.store.memAll : false; },
		// A passage is memorized when the global toggle XOR its own tap. So reading
		// is default; tapping memorizes just this set; 🧠 flips everything at once.
		hidden() {
			if (this.plain) return false;
			if (this.forceStage) return true;
			return this.memAll !== this.active;
		},
		activeStage() { return this.forceStage ? this.forceStage : (this.hidden ? this.form : 'normal'); },
		interactive() { return !this.forceStage && !this.plain; },
		canAnnotate() { return !!this.store && this.book > 0 && this.chapter > 0; },
		// The form select shows only once a passage is memorized (clean reading).
		showBadge() { return this.interactive && this.hidden; },
		hint() {
			if (this.form === 'blur') return 'Mantén sobre una palabra para revelarla · toca para leer';
			return 'Toca para leer';
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
		memAll() { this.active = false; }, // reset local taps when the global flips
	},
	methods: {
		// ---- per-verse annotations -------------------------------------------
		vkey(v) { return this.store ? this.store.vKey(this.book, this.chapter, v) : ''; },
		statusOf(v) { const d = this.store ? this.store.getV(this.vkey(v)) : {}; return d.s ? window.mlStatus[d.s] : null; },
		hlOf(v) { const d = this.store ? this.store.getV(this.vkey(v)) : {}; return d.hl ? window.mlHlBg(d.hl) : ''; },
		hasNote(v) { const d = this.store ? this.store.getV(this.vkey(v)) : {}; return !!d.note; },
		openTools(v) {
			if (!this.canAnnotate || !this.store) return;
			const label = this.refLabel ? `${this.refLabel}:${v}` : `v. ${v}`;
			this.store.openTools(this.vkey(v), label);
		},
		onDown(e) {
			this._downAt = (typeof performance !== 'undefined') ? performance.now() : 0;
			this.onPointer(e);
		},
		onClick() {
			if (!this.interactive) return;
			// A quick tap toggles this passage's memorized state. A hold (used to
			// reveal words in blur) must not toggle — distinguish by press duration.
			const held = ((typeof performance !== 'undefined') ? performance.now() : 0) - (this._downAt || 0);
			if (this.activeStage === 'blur' && held >= 220) return;
			this.active = !this.active;
		},
		// GRADUAL per-word reveal while the pointer dwells (blurred passage only).
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
