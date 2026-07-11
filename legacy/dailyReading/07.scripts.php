<script async id="slcLiveChat" src="https://widget.sonetel.com/SonetelWidget.min.js" data-account-id="207743274"></script>
<script src="../../../assets/web/assets/jquery/jquery.min.js"></script>
<script src="../../../assets/bootstrap/js/bootstrap.min.js"></script>
<script src="../../../assets/smooth-scroll/SmoothScroll.js"></script>
<script src="../../../../assets/bootstrap-carousel-swipe/bootstrap-carousel-swipe.js"></script>
<script src="../../../../assets/jarallax/jarallax.js"></script>
<script src="../../../../assets/mobirise/js/script.js"></script>
<script src="../../../../assets/mobirise/js/custom.js"></script>
<script src="../../../../assets/dropdown-menu-plugin/script.js"></script>
<script type="application/json" class="js-hypothesis-config">
	{"showHighlights": "always"}
</script>
<script src="https://cdn.jsdelivr.net/npm/tooltipster@4.2.7/dist/js/tooltipster.bundle.min.js"></script>
<script src="https://rawcdn.githack.com/louisameline/tooltipster-scrollableTip/7ffe94dbbd42b33e742e47ac865ee79b9ed6988b/tooltipster-scrollableTip.min.js"></script>
<!--<script src="https://hypothes.is/embed.js" async></script>-->
<!--<script src="https://rawgit.com/mntn-dev/t.js/master/t.js"></script>-->
<script>
//inicial en un tag:
function swapClass(selector,classToReplace,classReplacement){
	$(selector).removeClass(classToReplace);
	$(selector).addClass(classReplacement);
}
function memorize(selector){
	$(selector).addClass('normal')
	const initials=/\B[A-Za-züáéíóúñ]/g;
	const initial=/[A-Za-züáéíóúñ]/g;
	const regexInitials = /(?<=<[^>]+>[^&<>]*(&nbsp;)*[^&<>]*[\wáéíóúñ])[^\d\W]|[üáéíóúñ]/g;
	const regexInitial = /(?<=<[^>]+>[^&<>]*(&nbsp;)*[^&<>]*)[^\d\W]|[üáéíóúñ]/g;
	let selectorHtml = []; //Create an array to store each elements content
	$(selector).each(function(index) {
	   $(this).attr('data-id',index);  // Store the initial content in a data attribute
	   selectorHtml.push($(this).html());
	});

	$(selector).click(function() {
	  var index = $(this).attr('data-id');
	  if($(this).hasClass('normal')){
		$(this).html(selectorHtml[index].replace(initials, '_'));
		swapClass(this,'normal','initials');
	  }else if($(this).hasClass('initials')){
		$(this).html(selectorHtml[index].replace(initial,'_'));
		swapClass(this,'initials','initial');
	  }else if($(this).hasClass('initial')){
		$(this).html(selectorHtml[index]);
		swapClass(this,'initial','normal');
	  }
	});
}
$(document).ready(function(){
	memorize('.text');
	memorize('#votd');
	 var width = $(window).width();
	 if( width > 767) {
          $('.withCrossRef').tooltipster({
			contentAsHTML: true,
			theme: 'tooltipster-punk',
			plugins: ['sideTip', 'scrollableTip'],
            trigger: 'hover',
            position: 'right',
            maxWidth: 240,
          });
      }
      else{
          $('.withCrossRef').tooltipster({
			  contentAsHTML: true,
			theme: 'tooltipster-punk',
			plugins: ['sideTip', 'scrollableTip'],
            position: 'bottom',
            maxWidth: 280,
          })
      }
});
</script>