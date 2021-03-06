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

    if (getSystemMode() != "FULL") {
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
        $("#hidden_candidate_blk_house").val($.cookie('candidate_blk_house'));
        $("#candidate_unit").val($.cookie('candidate_unit'));
        $("#candidate_street_address").val($.cookie('candidate_street_address'));
        $("#hidden_candidate_street_address").val($.cookie('candidate_street_address'));
        $("#candidate_contact").val($.cookie('candidate_contact'));
        $("#candidate_email").val($.cookie('candidate_email'));
        $('#RememberMe').attr('checked', 'checked');
        $("#church_others").val($.cookie('candidate_churchOthers'));
        $("#" + getCongregationID()).val($.cookie('candidate_congregation'));
        if ($.cookie('mailingList') == 'true') {
            $('#mailingList').prop('checked', true);
        }

    }

    if (getIfAD() == "_ad") {
        $('#WalkInDate').datepick({ yearRange: 'c-100:c+0', maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
            renderer: $.extend({}, $.datepick.defaultRenderer,
            { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
            })
        });
    }
    $("#nric").focus();

    changeChurch();
    changeCongregation()
});

function changeCongregation() {
    $("#CongregationName").val($("#" + getCongregationID() + " option:selected").text());
}

function reloadCourse(obj) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "Year", $(obj).val());
    submitForm.action = "/membership.mvc/courseregistration_ad";
    submitForm.Method = "POST";
    submitForm.submit();
}

function onChangeCourse(obj) {
    $("#courseDisplayDate").html("Course schedule: <br />" + $("#courseInfo_" + $(obj).val()).html());
}

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
    if ($("#" + getChurchByID()).val().split('~')[0] == getOtherParish()) {
        $("#church_others").show();
        $("#church_others").watermark("Name of church");
    }
    else {
        $("#church_others").val('');
        $("#church_others").hide();
    }

    if ($("#" + getChurchByID()).val().split('~')[0] == getCurrentParish()) {
        $("#congregationDiv").show();
    }
    else {
        $("#congregationDiv").hide();
        $("#" + getCongregationID()).val("");
    }
}

function checkForm() {

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
        else if (validateNRIC(jQuery.trim($("#candidate_nric").val().toUpperCase())) == false) {
                errormsg += "- NRIC is not valid. example, S1234567G\n";            
        }

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

        if (jQuery.trim($('#' + getChurchByID()).val()).length == 0)
            errormsg += "- Church is mandatory\n";

        if ($("#" + getChurchByID()).val().split('~')[0] == getOtherParish() && $("#church_others").val() == "") {
            errormsg += "- Name of church is mandatory\n";
        }

        if ($("#" + getChurchByID()).val().split('~')[0] == getCurrentParish() && $("#" + getCongregationID()).val() == "") {
            errormsg += "- Congregation is mandatory\n";
        }
    }

    if (errormsg.length > 0) {
	    alert(errormsg);
	    return;
	}	

   if (getSystemMode() != "FULL") {
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
        $.cookie('candidate_churchOthers', $("#church_others").val(), { expires: 365 });
        $.cookie('candidate_congregation', $("#" + getCongregationID()).val(), { expires: 365 });
        $.cookie('mailingList', $("#mailingList").is(":checked"), { expires: 365 });
        
    }
//    else {
//        $.cookie('candidate_nric', null, { expires: 365 });
//        $.cookie(getSalutationID(), null, { expires: 365 });
//        $.cookie('candidate_english_name', null, { expires: 365 });
//        $.cookie('candidate_dob', null, { expires: 365 });
//        $.cookie('candidate_gender', null, { expires: 365 });
//        $.cookie(getNationalityID(), null, { expires: 365 });
//        $.cookie(getEducationID(), null, { expires: 365 });
//        $.cookie(getCandidateOccupationID(), null, { expires: 365 });
//        $.cookie(getChurchByID(), null, { expires: 365 });
//        $.cookie('candidate_postal_code', null, { expires: 365 });
//        $.cookie('candidate_blk_house', null, { expires: 365 });
//        $.cookie('candidate_unit', null, { expires: 365 });
//        $.cookie('candidate_street_address', null, { expires: 365 });
//        $.cookie('candidate_contact', null, { expires: 365 });
//        $.cookie('candidate_email', null, { expires: 365 });
//        $.cookie('RememberMeCE', null, { expires: 365 });
//        $.cookie('candidate_churchOthers', null, { expires: 365 });
//        $.cookie('candidate_congregation', null, { expires: 365 });
//    }

    var random = Math.random() * 11;
    domwindow = dhtmlmodal.open("Agreement", 'ajax', "/membership.mvc/displayCourseAgreementFrame?random=" + random.toString() + "&id=" + $("#" + getCourseID() + " > option:selected").val(), "Agreement", 'width=800px,height=300px,center=1,resize=1,scrolling=1');
    domwindow.onclose = function () { //Define custom code to run when window is closed
        if (agreeordisagree == 'agree') {
            $("#candidate_course_name").val($("#" + getCourseID() + " > option:selected").text());
            document.getElementById("maindiv").style.display = "none";
            document.getElementById("loadingdiv").style.display = "block";
            for (var x = 0; x < window.frames.length; x++) {
                try {
                    if (window.frames[x].name == random.toString()) {
                        $("#EncodedAdditionalInformation").val(window.frames[x].document.getElementById('agreementxml').value);
                        break;
                    }
                }
                catch (err) { }
            }
            $("#" + getFormID()).submit();
        }
        return true;
    }

        
}

var agreeordisagree = "disagree";