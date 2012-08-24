var selectedlanguges = "";
$(document).ready(function () {

    setTextAreaLengthLimit("kid_special_needs");

    uploader = new qq.FileUploader({
        element: document.getElementById('kid_photofile'),
        action: '/uploadfile.mvc/SaveFile',
        allowedExtensions: ['jpg', 'jpeg', 'jpe', 'png', 'gif'],
        sizeLimit: 100000,
        params: {
            guid: getGUID()
        },
        onComplete: function (id, fileName, responseJSON) {
            if (jQuery.trim(responseJSON) == "1") {
                reloadPhoto(fileName, getGUID());
                $("#kid_photo").val(getGUID() + "_" + fileName);
            }
        }
    });

//    $('#kid_photofile').uploadify({
//        'uploader': '../Content/images/uploadify.swf',
//        'script': '/uploadfile.mvc/SaveFile',
//        'cancelImg': '../Content/images/cancel.png',
//        'fileExt': '*.jpg;*.jpeg',
//        'fileDesc': 'JPEG files only',
//        'sizeLimit': '100000',
//        'wmode': 'transparent',
//        'scriptData': { 'guid': getGUID() },
//        'buttonText': 'Click to select file',
//        'onError': function (event, ID, fileObj, errorObj) {
//            if (errorObj.type == "File Size")
//                alert('File must not be more than 100KBytes');
//            $('#kid_photofile').uploadifyClearQueue();
//        },
//        'onComplete': function (event, ID, fileObj, response, data) {
//            if (jQuery.trim(response) == "1") {
//                reloadPhoto(fileObj.name, getGUID());
//                $("#kid_photo").val(getGUID() + "_" + fileObj.name);
//            }
//        },
//        'onSelect': function (event, ID, fileObj) {
//            if (fileObj.name.indexOf("+") > -1) {
//                alert("File name cannot any contain '+' character.");
//                setTimeout("$('#kid_photofile').uploadifyClearQueue()", 100);
//            }
//        },
//        'auto': true
//    });

    $('#kid_dob').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    setSelectedDropDownlist("kid_gender", getGenderValue());
    reloadPhotoUploaded(getPhotoFilename());
});

function reloadPhoto(filename, guid) {
    $('#icphoto').attr('src', '/uploadfile.mvc/downloadCityKidsPhoto?guid=' + guid + '&filename=' + escape(filename) + '&random=' + Math.random());
}

function reloadPhotoUploaded(filename) {
    if(filename.length > 0)
        $('#icphoto').attr('src', '/uploadfile.mvc/downloadCityKidsPhoto?filename=' + filename + '&random=' + Math.random());
}

function basicCheck() {
    var errormsg = "";

    if (jQuery.trim($('#kid_name').val()).length == 0)
        errormsg += "- Name is mandatory\n";

    if (jQuery.trim($('#kid_nric').val()).length == 0)
        errormsg += "- NRIC is mandatory\n";

    if (jQuery.trim($('#kid_dob').val()).length == 0)
        errormsg += "- Date Of Birth is mandatory\n";

    if ($("#kid_gender > option:selected").val() == '')
        errormsg += "- Gender is mandatory\n";

    if ($("#" + getNationalityID() + " > option:selected").val() == '')
        errormsg += "- Nationality is mandatory\n";

    if ($("#" + getRaceID() + " > option:selected").val() == '')
        errormsg += "- Race is mandatory\n";

    if (jQuery.trim($('#candidate_street_address').val()).length == 0)
        errormsg += "- Street Address is mandatory\n";

    if (jQuery.trim($('#candidate_blk_house').val()).length == 0)
        errormsg += "- Blk/House no. is mandatory\n";

    if (jQuery.trim($('#candidate_postal_code').val()).length == 0)
        errormsg += "- Postal Code is mandatory\n";
    else if (isNaN(jQuery.trim($("#candidate_postal_code").val())))
        errormsg += "- Postal Code is invalid\n";

    if ($("#" + getSchoolID() + " > option:selected").val() == '')
        errormsg += "- School is mandatory\n";

    if (jQuery.trim($('#kid_NOK_contact').val()).length == 0)
        errormsg += "- Next Of Kin Contact is mandatory\n";
    else if (isValidNumbericWithoutDecimal(jQuery.trim($("#kid_NOK_contact").val())) == false && jQuery.trim($("#kid_NOK_contact").val()).length != 0) {
        errormsg += "- Next Of Kin Contact is invalid\n";
    }

    if (jQuery.trim($('#kid_NOK_relationship').val()).length == 0)
        errormsg += "- Next Of Kin Name is mandatory\n";    

    if (isValidEmailAddress(jQuery.trim($("#kid_email").val())) == false && jQuery.trim($("#kid_email").val()).length != 0) {
        errormsg += "- Email address is invalid\n";
    }

    if (isValidNumbericWithoutDecimal(jQuery.trim($("#kid_home_tel").val())) == false && jQuery.trim($("#kid_home_tel").val()).length != 0) {
        errormsg += "- Home Tel is invalid\n";
    }

    if (isValidNumbericWithoutDecimal(jQuery.trim($("#kid_mobile_tel").val())) == false && jQuery.trim($("#kid_mobile_tel").val()).length != 0) {
        errormsg += "- Mobile Tel  is invalid\n";
    }

    return errormsg;
}

function checkForm() {
    var errormsg = basicCheck();

    if (errormsg.length > 0) {
        alert(errormsg);
        return;
    }

    if (validateNRIC(jQuery.trim($("#kid_nric").val().toUpperCase())) == false) {
        if (!confirm("NRIC, " + $("#kid_nric").val() + ", entered seem to be invalid. Are you sure it is correct?")) {
            return;
        }
    }
    document.getElementById("maindiv").style.display = "none";
    document.getElementById("loadingdiv").style.display = "block";   
    $("#" + getFormID()).submit();
    

}