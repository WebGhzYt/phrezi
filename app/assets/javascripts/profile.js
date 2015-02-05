$(document).ready(function() {
  var preview;
  preview = $(".upload_preview img");
  $("#user_avatar").change(function(event) {
    var file, input, reader;
    input = $(event.currentTarget);
    file = input[0].files[0];
    reader = new FileReader();
    reader.onload = function(e) {
      var image_base64;
      image_base64 = e.target.result;
      preview.attr("src", image_base64);
    };
    reader.readAsDataURL(file);
  });
});
$("#upload_btn").click(function() {
  $("#user_avatar").click();
});
