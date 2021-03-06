$(document).ready(function () {

    if (getSubmitControllerName() == "Register") {
        setSelectedDropDownlist(getStyleID(), setStyleValue())
    }
    else if (getSubmitControllerName() == "SaveUserInformation") {
        var xmlstring = unescape(getUserInformation());
        var userXML = jQuery.parseXML(xmlstring);
        $("#name").val(userXML.getElementsByTagName("Name")[0].childNodes[0].nodeValue);
        $("#nric").val(userXML.getElementsByTagName("NRIC")[0].childNodes[0].nodeValue);
        $("#email").val(userXML.getElementsByTagName("Email")[0].childNodes[0].nodeValue);
        $("#phone").val(userXML.getElementsByTagName("Phone")[0].childNodes[0].nodeValue);
        $("#mobile").val(userXML.getElementsByTagName("Mobile")[0].childNodes[0].nodeValue);
        $("#userid").val(userXML.getElementsByTagName("UserID")[0].childNodes[0].nodeValue);
        $("#department").val(userXML.getElementsByTagName("Department")[0].childNodes[0].nodeValue);

        setSelectedDropDownlist(getStyleID(), userXML.getElementsByTagName("Style")[0].childNodes[0].nodeValue);

        $("#nric").attr('disabled', true);
        $("#userid").attr('disabled', true);

    }

    $('#submitFormButton').click(function () {
        var errormsg = checkForm();

        if (validateNRIC(jQuery.trim($("#nric").val().toUpperCase())) == false) {
            if (!confirm("NRIC, " + $("#nric").val() + ", entered seem to be invalid. Are you sure it is correct?")) {
                return;
            }
        }

        if (errormsg.length > 0) {
            alert(errormsg);
            return;
        }
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "Name", jQuery.trim($("#name").val()));
        createNewFormElement(submitForm, "NRIC", jQuery.trim($("#nric").val()).toUpperCase());
        createNewFormElement(submitForm, "Email", jQuery.trim($("#email").val()));
        createNewFormElement(submitForm, "Phone", jQuery.trim($("#phone").val()));
        createNewFormElement(submitForm, "Mobile", jQuery.trim($("#mobile").val()));
        createNewFormElement(submitForm, "UserID", jQuery.trim($("#userid").val()));
        createNewFormElement(submitForm, "Department", jQuery.trim($("#department").val()));
        createNewFormElement(submitForm, "Style", $('#' + getStyleID() + ' > option:selected').val());
        createNewFormElement(submitForm, "StyleName", $('#' + getStyleID() + ' > option:selected').text());

        submitForm.action = "/Account.mvc/" + getSubmitControllerName();
        submitForm.Method = "POST";
        submitForm.submit();

    });

    function checkForm() {
        var errormsg = "";
        if (jQuery.trim($("#name").val()).length == 0) {
            errormsg += "- Name is Mandatory\n";
        }
        if (jQuery.trim($("#nric").val()).length == 0) {
            errormsg += "- NRIC is Mandatory\n";
        }
        
        if (jQuery.trim($("#email").val()).length == 0) {
            errormsg += "- Email address is Mandatory\n";
        }
        else if (isValidEmailAddress(jQuery.trim($("#email").val())) == false) {
            errormsg += "- Email address is invalid";
        }
        return errormsg;
    }
});