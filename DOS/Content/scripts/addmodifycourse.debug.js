$(document).ready(function () {

    $('#startdate').datepick({ monthsToShow: 2, multiSelect: 999, minDate: '-3y', maxDate: '+3y', dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

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

    if (jQuery.trim($("#coursename").val()).length == 0) {
        errormsg += "- Course name is mandatory.\n";
    }
    if (jQuery.trim($("#startdate").val()).length == 0) {
        errormsg += "- Start date is mandatory.\n";
    }
    if (jQuery.trim($("#timestart").val()).length == 0) {
        errormsg += "- Start time is mandatory.\n";
    }
    if (jQuery.trim($("#timeend").val()).length == 0) {
        errormsg += "- End time is mandatory.\n";
    }
    if ($("#" + getLocationID() + "> option:selected").val() == '') {
        errormsg += "- Venue is mandatory\n";
    }
    if ($("#incharge").val().length == 0) {
        errormsg += "- In charge is mandatory\n";
    }
    if (jQuery.trim($("#fee").val()).length == 0) {
        errormsg += "- Fee cannot be blank, mininum 0.00";
    }
    else if (isNaN(jQuery.trim($("#fee").val()))) {
        errormsg += "- Fee is invalid.";
    }


    return errormsg;
}