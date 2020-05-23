$(function() {
  var xs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 90];
  var tens = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89]
  var fives = [90]

  $('#score_round_id').change(function(){
    var newRound = parseInt($(this).val());
    if (xs.includes(newRound)) { 
      $('#xs').show();
    } else {
      $('#xs').hide();
    }
    if (tens.includes(newRound)){
      document.getElementById("golds").textContent = "Tens";
    } else if (fives.includes(newRound)){
      document.getElementById("golds").textContent = "Fives";
    } else {
      document.getElementById("golds").textContent = "Golds";
    }
  });
});