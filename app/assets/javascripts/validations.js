function validEmail(input) {
  var email = $(input).val();
  var reg = /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i
  var valid;
  if (email) {
    valid = reg.test(email);
  } else {
    valid = false;
  }
  if (!valid) $(input).parent().addClass("has-error");
  return {valid: valid, message: "Invalid email address."}
}

function validMoney(input) {
  var number = $(input).val();
  if (number) number = number.replace(/\$|\,| /g,"");
  var reg = /^\d+(\.\d+)?$/
  var valid;
  if (number && (($(input).attr("validate") == "true") || (number != undefined) || (number != ""))) {
    valid = reg.test(number);
  } else if ($(input).attr("validate") != "true") {
    valid = true
  } else {
    valid = false;
  }
  if (!valid) $(input).parent().addClass("has-error");
  return {valid: valid, message: "Invalid dollar amount. Please correct."}  
}

function validPhoneNumber(input) {
  var number = $(input).val();
  // var reg = /^\+?(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1){1}\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*\d\W*(\d{0,2})$/
  var reg = /^\+?\d{7,}/
  var valid;
  if (number) {
    valid = reg.test(number);
  } else {
    valid = false;
  }
  if (!valid) $(input).parent().addClass("has-error");
  return {valid: valid, message: "Invalid phone number. If international, please include dial code."}
}

function validDate(input) {
  var date = $(input).val();
  var reg = /^(1[210]|0[987654321]|[987654321])\/(3[10]|[0-2][0-9]|[987654321])\/(\d{2}|\d{4})$/
  var valid;
  if (date) {
    valid = reg.test(date);
  } else {
    valid = false;
  }
  if (!valid) $(input).parent().addClass("has-error");
  return {valid: valid, message: "Invalid date. Please enter in the formate MM/DD/YYYY."}  
}

function validPassword(input) {
  var password = $(input).val()
  var valid;
  if (password.length < 6 && $(input).attr("class").indexOf("confirm")==-1) {
    return {valid: false, message: "Password must be at least 6 characters."}
  } else {
    valid = $("[type=password]").length == 1 || $($("[type=password]")[0]).val()==$($("[type=password]")[1]).val()
    return {valid: valid, message: "Passwords do not match."}
  }
}

function validTerms(input) {
  var checked = $("[name='" + $(input).attr('name') + "']:checked").val()
  
  var valid = false;
  if (checked) {
    valid = true;
  }
  return {valid: valid, message: "You must agree to Nomad Credit's Terms of Service and Privacy Policy."}
}


function validNumberField(input){
  var number = $(input).val();
  var reg = /^(\$)?(\d|\,)+(\.?\d+)?$/
  var valid = reg.test(number);
  if (!valid) $(input).parent().addClass("has-error");
  return {valid: valid, message: "Invalid number entered."};
}

function fileAttached(input){
  var valid = !!$(input).parent().parent().parent().children(".fileinput-preview").children("img")[0]
  return { valid: valid, message: "You must upload an image."}
}


function markRequired() {
  $("[validate='true']").each(function(){
    findLabel(this).children().remove();
    span = $("<span style='color:red;padding-left:0.6em'/>")
    span.html("*")
    findLabel(this).append(span);
  });
  $("[validate='false']").each(function(){
    findLabel(this).children().remove();
  })
}

function validFields(validatePassword) {
  removeErrors();
  $(".alert-success").css("display", "none");
  var valid = true;
  var message = "Error. Fields in red are required."

  $("[validate='true']").each(function(){
    if ($(this).val() == "") {
      $(this).parent().addClass("has-error");
      valid = false;
    }
  })

  if (valid) {
    message = "";
  } 

  if (!validEmail($("input[name*='email']")).valid) {
    if (!(message == "")) message += "<br/>";
    message += "Invalid email address.";
    valid = false
  }

  if (validatePassword == "true" && !validPassword()) {
    if (!(message == "")) message += "<br/>";
    message += "Passwords do not match.";
    valid = false
  }

  if ($("input[name='accept-terms']")[0] && !$("input[name='accept-terms']").prop("checked")) {
    if (!(message == "")) message += "<br/>";
    message += "You must agree to Nomad Credit's <a href='/terms' style='text-decoration:underline' target='_blank'>Terms and Conditions</a>.";
    valid = false      
  }


  if (valid == false) {
    $(".error-message").html(message);
    $(".user-form-error").css("display", "block");
    $("html, body").animate({ scrollTop: 0 }, 100);
  }

  return valid;
}

function removeErrors() {
  $("input").each(function(){
    $(this).parent().removeClass("has-error");
    $(".user-form-error").css("display", "none");
  })
}

//check that all fields on displayed section are valid
function fieldsOnPageValid() {
  hideErrorMessage();
  var valid = true;
  var errorMessages = [];
  var sectionsToCheck = $(".active-section").find("[validate='true']");
  $.merge(sectionsToCheck, $(".active-section").find("[dollar='true']"));
  if ($(".active-section").find("[type='radio']:checked").val() == "other") sectionsToCheck.push($(".active-section").find("[type='radio']:checked"))
  sectionsToCheck.each(function(){
    if (!validField(this).valid){
      if($(this).attr('type') == 'radio' || $(this).attr('type') == 'checkbox') {
        $(this).closest(".radio-div").addClass("radio-error");
      } else if ($(this).attr('type') == 'file') {
        $(this).parent().parent().parent().children(".fileinput-preview").addClass("file-error");
      } else {
        //text error
        $(this).addClass("input-error");
      }
      var errorMessage = validField(this).message || "Fields marked with &nbsp; * &nbsp; are required."
      if (errorMessages.indexOf(errorMessage) == -1) errorMessages.push(errorMessage);
      valid = false;
    }
  })
  valid ? hideErrorMessage() : displayErrorMessage(errorMessages)
  return valid;
}

function validField(input) {
  var $input = $(input);
  if ($input.attr("validate_number")){
    return validNumberField($input);
  } else if ($input.attr('type') == 'radio' || $input.attr('type') == 'checkbox')
    //require user to fill out text box if other selected
    if ($("[name='" + $input.attr('name') + "']:checked").val() == 'other') {
      var field = $input.attr('name').replace("project[","").replace("]","").split("_");
      var otherInput = $("[name='project[" + 'other_' + field[0] + '_input_' + field[1] + "]']");
      return {valid: otherInput.val().length>0, message: "You selected 'Other', please describe in the text box below." };
    } else if ($input.attr('name').indexOf('terms') != -1) {
      return validTerms($input);
    } else {
      // if no radio checked
      return {valid: !!$("[name='" + $input.attr('name') + "']:checked")[0] };
  } else if ($input.attr("name").indexOf("email") != -1){
    return validEmail($input);
  } else if ($input.attr("name").indexOf("password") != -1){
    return validPassword($input);    
  } else if ($input.attr("name").indexOf("phone") != -1){
    return validPhoneNumber($input);
  } else if ($input.attr("type") == "file" ) {
    return fileAttached($input);
  } else if ($input.attr("date") == "true") {
    return validDate($input);
  } else if ($input.attr("dollar") == "true") {
    return validMoney($input);
  } else {
    console.log($input)
    console.log($input.val() == null)
    //if text input blank
    return {valid: ($input.val() && $input.val().length>0)};
  }
  return true;
}


function displayErrorMessage(errorMessages) {
  $('.alert').html(errorMessages.join("<br>"))
  $('.alert').show();
}

function hideErrorMessage() {
  $('.alert').hide();
  $(".radio-div").removeClass("radio-error");
  $("input").removeClass("input-error");
  $(".input-group").removeClass("input-error");
  $(".input-group").removeClass("has-error");
  $("textarea").removeClass("input-error");
  $(".form-control").removeClass("input-error");
  $(".fileinput-preview").removeClass("file-error");
}

function findLabel(input) {
  var name = $(input).attr("name").replace("[", "_").replace("]", "").replace("[]","_");
  return $("label[for='" + name + "']")
}
