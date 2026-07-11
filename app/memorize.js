/* Mi Lectura Diaria — motor de memorización.
   Reproduce (y amplía) las estrategias del sitio legacy: al hacer clic el texto
   del versículo se reemplaza por etapas para forzar el recuerdo activo
   ("desirable difficulty"). Opera SOLO sobre el texto fuera de las etiquetas
   HTML, preservando <e>/<i>/<t>/<J>, números de versículo y puntuación (la
   puntuación y los espacios dejan ver la ESTRUCTURA de la frase). */
(function () {
	// Letras (incluye acentuadas y ñ/ü) — clase Unicode básica latina.
	const LETTERS = /[A-Za-zÀ-ÿ]+/g;
	const LETTER = /[A-Za-zÀ-ÿ]/g;

	// Aplica fn a cada fragmento de texto que NO esté dentro de una etiqueta.
	function outsideTags(html, fn) {
		return String(html).replace(/(<[^>]+>)|([^<]+)/g, (m, tag, text) =>
			tag != null ? tag : fn(text));
	}

	// Etapa 1 — Iniciales: primera letra de cada palabra, el resto '_'.
	//   "Jehová es mi pastor" -> "J_____ e_ m_ p_____"
	function initials(html) {
		return outsideTags(html, (t) =>
			t.replace(LETTERS, (w) => w[0] + '·'.repeat(w.length - 1)));
	}

	// Etapa 2 — Oculto: todas las letras a '_'; queda solo la estructura.
	//   "Jehová es mi pastor" -> "······ ·· ·· ······"
	function hidden(html) {
		return outsideTags(html, (t) => t.replace(LETTER, '·'));
	}

	// Etapas de memorización, en orden de dificultad creciente.
	const STAGES = [
		{ key: 'normal', label: 'Texto completo', hint: 'Toca para memorizar' },
		{ key: 'initials', label: 'Iniciales', hint: 'Solo la primera letra' },
		{ key: 'hidden', label: 'Oculto', hint: 'Solo la estructura' },
		{ key: 'blur', label: 'Difuminado', hint: 'Recuerda de memoria' },
	];

	function apply(html, stageKey) {
		switch (stageKey) {
			case 'initials': return initials(html);
			case 'hidden': return hidden(html);
			default: return html; // 'normal' y 'blur' conservan el texto (blur es CSS)
		}
	}

	// nextStage cycles normal -> [enabled forms in canonical order] -> normal.
	// `enabled` is the user's chosen set (store.memStages); when omitted, all.
	function nextStage(key, enabled) {
		const forms = (enabled && enabled.length ? enabled : ['initials', 'hidden', 'blur']);
		const cycle = ['normal', ...STAGES.filter((s) => forms.includes(s.key)).map((s) => s.key)];
		const i = cycle.indexOf(key);
		return cycle[(i + 1) % cycle.length];
	}

	function stageInfo(key) {
		return STAGES.find((s) => s.key === key) || STAGES[0];
	}

	window.mlMem = { STAGES, apply, nextStage, stageInfo, initials, hidden };
})();
