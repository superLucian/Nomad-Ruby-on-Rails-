function registration(){

  if ($(".alert").text().trim() == '') {
    $(".alert").hide(); 
  } else {
    $(".alert").show(); 
  }

  if ($("#error_explanation").text() != "" && $("#error_explanation").text().indexOf("Email") == -1) {
    $("#new-user-step-1").toggleClass("active-section")
    $("#new-user-step-1").hide()
    $("#new-user-step-2").show()
    $("#new-user-step-2").toggleClass("active-section")      
  }

  $("#new-user-continue").on("click", function(){
    if(fieldsOnPageValid()){
      sendLead($("#user_email").val(), $("#user_referral_source").val())
      $("#new-user-step-1").toggleClass("active-section")
      $("#new-user-step-1").hide()
      $("#new-user-step-2").show()
      $("#new-user-step-2").toggleClass("active-section")
    }
  })

  $("#sign-up-btn").on("click", function(){
    if(fieldsOnPageValid()){
      $("form").submit();
    }
  })

}

function sendLead(email, referral_source) {
  $.post("/leads", {email: email, referral_source: referral_source})
}