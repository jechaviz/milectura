<template>
	<div class="verse leading-relaxed">
		<template v-for="v in verses" :key="v.v">
			<div v-if="subheadings && subheadings[v.v]"
				class="font-serif text-gold-soft/90 text-[1.05em] mt-4 mb-1">{{ subheadings[v.v] }}</div>
			<span class="align-super text-[0.6em] text-gold/70 mr-1 select-none">{{ v.v }}</span><span v-html="v.t"></span>{{ ' ' }}
		</template>
	</div>
</template>

<script>
module.exports = {
	props: {
		verses: { type: Array, default: () => [] },
		subheadings: { type: Object, default: () => ({}) },
	},
};
</script>
