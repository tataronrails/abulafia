!function () {
  
  var init = function() {
    if (!document.getElementById('flip') || document.getElementById('card')) return;
    var card = document.getElementById('card');

    document.getElementById('flip').addEventListener( 'click', function(){
      card.toggleClassName('flipped');
    }, false);
  };

  window.addEventListener('DOMContentLoaded', init, false);

}();
