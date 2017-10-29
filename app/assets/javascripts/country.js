

function updateSelect(id, data) {
  $("#"+id).empty();
  $("#"+id).append($('<option>').text("").attr('value', ""));
  $.each(data, function(i, value) {
    $("#"+id).append($('<option>').text(value[0]).attr('value', value[1]));
  });
  $("#"+id).prop("disabled", false);
}

$(document).ready(function(){
  $('#detail_country').change(function() {
    var country = encodeURIComponent($('#detail_country').val())
    $('#detail_city').empty();

    $.getJSON("/api/v1/location/" + country, function(data) {
      updateSelect('detail_state', data);
    });
  });

  $('#detail_state').change(function() {
    var country = encodeURIComponent($('#detail_country').val())
    var state = encodeURIComponent($('#detail_state').val())

    $.getJSON("/api/v1/location/" + country + "/" + state, function(data) {
      updateSelect('detail_city', data);
    });
  });
});