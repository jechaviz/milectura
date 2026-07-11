<template>
	<div class="verse leading-relaxed" :class="{ 'mem-on': clickable, blurred: activeStage === 'blur' }"
		@click="onClick">
		<div v-if="showBadge" class="mem-badge select-none flex items-center gap-2 mb-2 text-xs">
			<span class="px-2 py-0.5 rounded-full glass-soft text-gold-soft">{{ stageInfo.label }}</span>
			<span class="text-white/40">{{ clickable ? stageInfo.hint : '' }}</span>
			<span v-if="clickable && activeStage !== 'normal'" class="text-white/30">· toca para siguiente</span>
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
		// externally-controlled stage (the Memorizar deck drives its card directly)
		forceStage: { type: String, default: '' },
		// when true, ignore the global mode and never memorize (plain display)
		plain: { type: Boolean, default: false },
	},
	data() { return { stage: 'normal' }; },
	computed: {
		gmode() { return this.plain ? 'off' : (this.store ? this.store.memMode : 'off'); },
		// resolved stage to render: forceStage wins, else the global mode drives it;
		// in 'libre' the per-block internal stage cycles on click.
		activeStage() {
			if (this.forceStage) return this.forceStage;
			const m = this.gmode;
			if (m === 'off') return 'normal';
			if (m === 'libre') return this.stage;
			return m; // 'initials' | 'hidden' | 'blur'
		},
		clickable() { return !this.forceStage && this.gmode === 'libre'; },
		showBadge() { return !this.forceStage && this.gmode !== 'off'; },
		stageInfo() {
			const S = (window.mlMem && window.mlMem.STAGES) || [];
			return S.find((s) => s.key === this.activeStage) || { label: '', hint: '' };
		},
		display() {
			const mem = window.mlMem;
			if (!mem || this.activeStage === 'normal' || this.activeStage === 'blur') return this.verses;
			return this.verses.map((v) => ({ v: v.v, t: mem.apply(v.t, this.activeStage) }));
		},
	},
	watch: {
		// when the global mode leaves 'libre', reset the per-block cursor
		gmode(m) { if (m !== 'libre') this.stage = 'normal'; },
	},
	methods: {
		onClick() {
			if (!this.clickable) return;
			const enabled = this.store ? this.store.memStages : null;
			this.stage = window.mlMem ? window.mlMem.nextStage(this.stage, enabled) : 'normal';
		},
	},
};
</script>

<style>
.mem-on { cursor: pointer; transition: filter .25s ease; }
.verse.blurred > span { filter: blur(4px); transition: filter .25s ease; }
.verse.blurred:hover > span { filter: blur(1.5px); }
</style>
