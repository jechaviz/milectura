(function () {
  var myPlugin = function (hook, vm) {
    hook.doneEach(function () {
	  const selector = 'blockquote';
		// Expression for replacing initial characters to '_'
		const regexInitials = /(?<=<[^>]+>[^&<>]*(&nbsp;)*[^&<>]*[\wáéíóúñ])[^\d\W]|[üáéíóúñ]/g;
		const regexInitial = /(?<=<[^>]+>[^&<>]*(&nbsp;)*[^&<>]*)[^\d\W]|[üáéíóúñ]/g;
		// Function to toggle class
		const swapClass = (el, initialClass, toggledClass) => {
			el.classList.remove(initialClass);
			el.classList.add(toggledClass);
		}
		// Store selector elements initial content
		const selectorHtml = []; 
		document.querySelectorAll(selector).forEach(el => {
			// Set a data attribute to access the selector element
			el.setAttribute('data-id', selectorHtml.length);
			// Set a data attribute to set state in element
			el.setAttribute('data-state',0);
			// Store each selector elements content
			selectorHtml.push(el.innerHTML);
		});
		// Click Event handler
		document.querySelectorAll(selector).forEach(el => el.addEventListener('click', function() {
			const index = this.getAttribute('data-id');
			let state = this.getAttribute('data-state');
			if(state==0){
				this.innerHTML = selectorHtml[index].replace(regexInitials, '_');
				this.setAttribute('data-state',1);
			//} else if(state==1){
			//	this.innerHTML = selectorHtml[index].replace(regexInitial,'_');
			//	this.setAttribute('data-state',2);
			//} else if(state==2){
			//	this.innerHTML = selectorHtml[index];
			//	this.setAttribute('data-state',3);
			//	this.style.filter = 'blur(2px)';
			//	this.style.WebkitFilter = 'blur(2px)';
			//} else if(state==3){
			//	this.setAttribute('data-state',4);
			//	this.style.filter = 'blur(3px)';
			//	this.style.WebkitFilter = 'blur(3px)';
			} else if(state==1){
				this.innerHTML = selectorHtml[index];
				this.setAttribute('data-state',2);
				this.style.filter = 'blur(4px)';
				this.style.WebkitFilter = 'blur(4px)';
			}else {
				this.setAttribute('data-state',0);
				this.style.filter = '';
				this.style.WebkitFilter = '';
			}
		}));
    });
  };

  // Add plugin to docsify's plugin array
  $docsify = $docsify || {};
  $docsify.plugins = [].concat($docsify.plugins || [], myPlugin);
})();