<template>
	<div class="space-y-5">
		<section class="glass rounded-3xl p-5 sm:p-7">
			<div class="flex items-center gap-3 flex-wrap">
				<h1 class="font-serif text-2xl text-gold-soft">Devocional</h1>
				<div class="flex-1"></div>
				<input type="date" :value="store.date" @change="store.date=$event.target.value; load()"
					class="glass-soft rounded-full px-3 py-1.5 text-sm outline-none" />
			</div>
			<p v-if="name" class="text-white/50 text-sm mt-1">{{ name }}</p>
		</section>

		<section class="glass rounded-3xl p-6 sm:p-9">
			<div v-if="err" class="text-white/60">{{ err }}</div>
			<div v-else-if="!html" class="space-y-2">
				<div class="h-5 bg-white/5 rounded animate-pulse w-1/2"></div>
				<div class="h-4 bg-white/5 rounded animate-pulse" v-for="i in 6" :key="i"></div>
			</div>
			<div v-else class="devo" v-html="html"></div>
		</section>
	</div>
</template>

<script>
module.exports = {
	inject: ['api', 'store'],
	data() { return { html: '', name: '', err: '' }; },
	methods: {
		async load() {
			this.html = ''; this.err = '';
			try {
				const r = await this.api.get(`/devotion?date=${this.store.date}`);
				this.name = r.name; this.html = r.html;
			} catch (e) { this.err = e.message; }
		},
	},
	mounted() { this.load(); },
};
</script>

<style>
.devo { color: rgba(255,255,255,0.85); line-height: 1.7; }
.devo h1, .devo .page-header { font-family: Fraunces, serif; color: #f3dcae; font-size: 1.5rem; margin: 0 0 1rem; }
.devo h2, .devo h3 { font-family: Fraunces, serif; color: #e8c37e; margin: 1.4rem 0 .5rem; }
.devo p { margin: 0 0 1rem; }
.devo a { color: #7fb0e8; text-decoration: none; }
.devo blockquote { border-left: 3px solid rgba(232,195,126,.4); padding-left: 1rem; margin: 1rem 0; font-style: italic; color: #cbd6ea; }
.devo img { max-width: 100%; border-radius: 12px; }
</style>
