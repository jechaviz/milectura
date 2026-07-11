// When + or - buttons are clicked the font size of the h1 is increased/decreased by 2
// The max is set to 50px for this demo, the min is set by min font in the user's style sheet

function getSize() {
    size=$('#font-size').text()
    if(size==""){
        size = $('#ldd p').css('font-size');
        size = parseInt(size, 10);
        $('#font-size').text(size);
    }else{
        size=parseInt(size, 10);
    }
  }
  
  //get inital font size
  //getSize();
  
  $("#up").on( "click", function() {
    getSize();
    // parse font size, if less than 50 increase font size
    if ((size + 2) <= 50) {
      $('#ldd').attr('style', 'font-size:'+(size+2)+'px !important');
      $('#font-size').text(size += 2);
    }
  });
  $("#dn").on( "click", function() {
    getSize();
    if ((size - 2) >= 17) {
      $('#ldd').attr('style', 'font-size:'+(size-2)+'px !important');
      //$('#ldd p').css('font-size','-=2');
      $('#font-size').text(size -= 2);
    }
  });