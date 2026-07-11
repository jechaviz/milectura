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

	function nextStage(key) {
		const i = STAGES.findIndex((s) => s.key === key);
		return STAGES[(i + 1) % STAGES.length].key;
	}

	window.mlMem = { STAGES, apply, nextStage, initials, hidden };
})();
