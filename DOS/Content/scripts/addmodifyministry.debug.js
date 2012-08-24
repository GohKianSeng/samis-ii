$(document).ready(function () {
    $("#" + getFormID()).attr("action", unescape(getSubmitURL()));
    $('#submitFormButton').click(function () {
        var msg = checkForm();
        if (msg.length > 0)
            alert(msg);
        else
            $("#" + getFormID()).submit();
    });

    setTextAreaLengthLimit("ministrydescription");
});

function checkForm() {
    var errormsg = "";

    if (jQuery.trim($("#ministryname").val()).length == 0) {
        errormsg += "- Ministry name is mandatory.\n";
    }
    if (jQuery.trim($("#ministrydescription").val()).length == 0) {
        errormsg += "- Ministry description is mandatory.\n";
    }
    if ($("#incharge").val().length == 0) {
        errormsg += "- In charge is mandatory\n";
    }


    return errormsg;
}
