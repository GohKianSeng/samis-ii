$(document).ready(function () {
    $("#" + getFormID()).attr("action", unescape(getSubmitURL()));
    $('#submitFormButton').click(function () {
        var msg = checkForm();
        if (msg.length > 0)
            alert(msg);
        else
            $("#" + getFormID()).submit();
    });


});

function checkForm() {
    var errormsg = "";

    if (jQuery.trim($("#cellgroupname").val()).length == 0) {
        errormsg += "- Cellgroup name is mandatory.\n";
    }
    if ($("#incharge").val().length == 0) {
        errormsg += "- In charge is mandatory\n";
    }
    if (jQuery.trim($('#candidate_street_address').val()).length == 0)
        errormsg += "- Street Address is mandatory\n";

    if (jQuery.trim($('#candidate_blk_house').val()).length == 0)
        errormsg += "- Blk/House no. is mandatory\n";

    if (jQuery.trim($('#candidate_postal_code').val()).length == 0)
        errormsg += "- Postal Code is mandatory\n";


    return errormsg;
}
