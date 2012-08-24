﻿var selectedlanguges = "";
$(document).ready(function () {

    $("#" + getFormID()).attr("action", unescape(getSubmitURL()));

    $('#candidate_dob').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    setSelectedDropDownlist("candidate_gender", getGenderValue());
    $("#candidate_nric").focus()


    $("#existingmember").click(function () {
        if ($("#existingmember").is(':checked')) {
            $("#visitor").hide("slow");
        }
        else {
            $("#visitor").show("slow");

        }
    });
    changeChurch();

    if (getCookie('RememberMeCE') == "On") {
        $("#candidate_nric").val($.cookie('candidate_nric'));
        $("#" + getSalutationID()).val($.cookie(getSalutationID()));
        $("#candidate_english_name").val($.cookie('candidate_english_name'));
        $("#candidate_dob").val($.cookie('candidate_dob'));
        $("#candidate_gender").val($.cookie('candidate_gender'));
        $("#" + getNationalityID()).val($.cookie(getNationalityID()));
        $("#" + getEducationID()).val($.cookie(getEducationID()));
        $("#" + getCandidateOccupationID()).val($.cookie(getCandidateOccupationID()));
        $("#" + getChurchByID()).val($.cookie(getChurchByID()));
        $("#candidate_postal_code").val($.cookie('candidate_postal_code'));
        $("#candidate_blk_house").val($.cookie('candidate_blk_house'));
        $("#candidate_unit").val($.cookie('candidate_unit'));
        $("#candidate_street_address").val($.cookie('candidate_street_address'));
        $("#candidate_contact").val($.cookie('candidate_contact'));
        $("#candidate_email").val($.cookie('candidate_email'));
        $('#RememberMe').attr('checked', 'checked');
    }

});

function PostalCodeKeyup(e) {
    if (jQuery.trim($("#candidate_postal_code").val()).length != 6) {
        return;
    }
    else if (!isNaN(jQuery.trim($("#candidate_postal_code").val()))) {
        if ($("#candidate_postal_code").val().indexOf(".") > -1)
            return;
        else
            loadAddressFromPostalCode(jQuery.trim($("#candidate_postal_code").val()));
    }
    else
        return;
}

function loadAddressFromPostalCode(postalcode) {
    if (getAutoPostalCode() == "Off")
        return;
    if (getPostalCodeRetrival() == "Client") {
        var url = getPostalCodeRetrivalURL();
        url = url + postalcode;
        $.getJSON(url + "&callback=?", function (parsedJSON) {
            $("#candidate_blk_house").val(parsedJSON.GeocodeInfo[0].BLOCK);
            $("#candidate_street_address").val(parsedJSON.GeocodeInfo[0].ROAD);
            $("#hidden_candidate_blk_house").val(parsedJSON.GeocodeInfo[0].BLOCK);
            $("#hidden_candidate_street_address").val(parsedJSON.GeocodeInfo[0].ROAD);
        });
    }
    else {
        $.post("/membership.mvc/PostalCodeToAddress",
        { postalCode: postalcode },
            function (data) {
                var parsedJSON = jQuery.parseJSON(data);
                $("#candidate_blk_house").val(parsedJSON.GeocodeInfo[0].BLOCK);
                $("#candidate_street_address").val(parsedJSON.GeocodeInfo[0].ROAD);
                $("#hidden_candidate_blk_house").val(parsedJSON.GeocodeInfo[0].BLOCK);
                $("#hidden_candidate_street_address").val(parsedJSON.GeocodeInfo[0].ROAD);
            }
        );
    }
}

function changeChurch() {
    if ($("#" + getChurchByID()).val() == "28") {
        $("#church_others").show();
        $("#church_others").watermark("Name of church");
    }
    else {
        $("#church_others").val('');
        $("#church_others").hide();
    }
}

function checkForm(){
    var errormsg = "";

    if ($("#existingmember").is(':checked')) {
        if($("#" + getCourseID() + " > option:selected").val() == '')
            errormsg += "- Course is mandatory\n";
        if (jQuery.trim($('#candidate_nric').val()).length == 0)
            errormsg += "- NRIC is mandatory\n";        
    }
    else {

        if ($("#" + getCourseID() + " > option:selected").val() == '')
            errormsg += "- Course is mandatory\n";

        if (jQuery.trim($('#candidate_english_name').val()).length == 0)
            errormsg += "- Name in English is mandatory\n";

        if (jQuery.trim($('#candidate_nric').val()).length == 0)
            errormsg += "- NRIC is mandatory\n";        

        if (isValidEmailAddress(jQuery.trim($("#candidate_email").val())) == false && jQuery.trim($("#candidate_email").val()).length != 0) {
            errormsg += "- Email address is invalid\n";
        }
        else if (jQuery.trim($("#candidate_email").val()).length <= 0) {
            errormsg += "- Email address is mandatory\n";
        }

        if (jQuery.trim($('#candidate_contact').val()).length == 0)
            errormsg += "- Contact is mandatory\n";
        else if (isValidNumbericWithoutDecimal(jQuery.trim($("#candidate_contact").val())) == false && jQuery.trim($("#candidate_contact").val()).length != 0) {
            errormsg += "- Contact invalid\n";
        }

        if (jQuery.trim($("#candidate_postal_code").val()).length > 0 && isNaN(jQuery.trim($("#candidate_postal_code").val())))
            errormsg += "- Postal Code is invalid\n";       

    }

    if (errormsg.length > 0) {
	    alert(errormsg);
	    return;
	}
    
    if (validateNRIC(jQuery.trim($("#candidate_nric").val().toUpperCase())) == false) {
        if (!confirm("NRIC, " + $("#candidate_nric").val() + ", entered seem to be invalid. Are you sure it is correct?")) {
            return;
        }
    }

    if ($("#RememberMe").is(':checked')) {
        $.cookie('candidate_nric', $("#candidate_nric").val(), { expires: 365 });
        $.cookie(getSalutationID(), $("#" + getSalutationID()).val(), { expires: 365 });
        $.cookie('candidate_english_name', $("#candidate_english_name").val(), { expires: 365 });
        $.cookie('candidate_dob', $("#candidate_dob").val(), { expires: 365 });
        $.cookie('candidate_gender', $("#candidate_gender").val(), { expires: 365 });
        $.cookie(getNationalityID(), $("#" + getNationalityID()).val(), { expires: 365 });
        $.cookie(getEducationID(), $("#" + getEducationID()).val(), { expires: 365 });
        $.cookie(getCandidateOccupationID(), $("#" + getCandidateOccupationID()).val(), { expires: 365 });
        $.cookie(getChurchByID(), $("#" + getChurchByID()).val(), { expires: 365 });
        $.cookie('candidate_postal_code', $("#candidate_postal_code").val(), { expires: 365 });
        $.cookie('candidate_blk_house', $("#candidate_blk_house").val(), { expires: 365 });
        $.cookie('candidate_unit', $("#candidate_unit").val(), { expires: 365 });
        $.cookie('candidate_street_address', $("#candidate_street_address").val(), { expires: 365 });
        $.cookie('candidate_contact', $("#candidate_contact").val(), { expires: 365 });
        $.cookie('candidate_email', $("#candidate_email").val(), { expires: 365 });
        $.cookie('RememberMeCE', "On", { expires: 365 });

        
    }
    else {
        $.cookie('candidate_nric', null, { expires: 365 });
        $.cookie(getSalutationID(), null, { expires: 365 });
        $.cookie('candidate_english_name', null, { expires: 365 });
        $.cookie('candidate_dob', null, { expires: 365 });
        $.cookie('candidate_gender', null, { expires: 365 });
        $.cookie(getNationalityID(), null, { expires: 365 });
        $.cookie(getEducationID(), null, { expires: 365 });
        $.cookie(getCandidateOccupationID(), null, { expires: 365 });
        $.cookie(getChurchByID(), null, { expires: 365 });
        $.cookie('candidate_postal_code', null, { expires: 365 });
        $.cookie('candidate_blk_house', null, { expires: 365 });
        $.cookie('candidate_unit', null, { expires: 365 });
        $.cookie('candidate_street_address', null, { expires: 365 });
        $.cookie('candidate_contact', null, { expires: 365 });
        $.cookie('candidate_email', null, { expires: 365 });
        $.cookie('RememberMeCE', null, { expires: 365 });
    }

    $("#candidate_course_name").val($("#" + getCourseID() + " > option:selected").text());
    document.getElementById("maindiv").style.display = "none";
    document.getElementById("loadingdiv").style.display = "block";    
	$("#" + getFormID()).submit();
}