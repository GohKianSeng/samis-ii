﻿var selectedlanguges = "";
var uploader;
$(document).ready(function () {
    
    setTextAreaLengthLimit("candidate_transfer_reason");
    $("#" + getFormID()).attr("action", getSubmitURL());

    $(".multiple_select").multiselect({ minWidth: 'auto', selectedList: 3, HideCheckAll: true, multiple: true, selectedText: "# of # selected" }).multiselectfilter();
    if (getLanguageValue().length == 0)
        $(".multiple_select").multiselect("uncheckAll");
    else
        selectedlanguges = getLanguageValue();

    $(".multiple_select").bind("multiselectclose", function (event, ui) {
        selectedlanguges = $.map($(this).multiselect("getChecked"), function (input) {
            return input.value;
        });
        $("#candidate_language").val(selectedlanguges);
        $("#LanguageText").val("");
        for (var x = 0; x < selectedlanguges.length; x++) {
            $("#LanguageText").val(this.options[selectedlanguges[x]].text + ", " + $("#LanguageText").val());
        }
    });

    $('#candidate_marriage_date').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });
    $('#candidate_dob').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });
    $('#candidate_baptism_date').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });
    $('#candidate_confirmation_date').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    if (getChristianYesNo() == "on") {
        $("#candidate_christian_yes_no").attr('checked', true);
        $("#christian_yes_no").show("slow");
    }

    if (getJoinCellgroupYesNo() == "on") {
        $("#candidate_join_cellgroup").attr('checked', true);
    }

    if (getServeCongregationYesNo() == "on") {
        $("#candidate_serve_congregation").attr('checked', true);
    }

    if (getTithingYesNo() == "on") {
        $("#candidate_tithing").attr('checked', true);
    }

    if (getPhotoFilename().length > 0) {
        var nameguid = getPhotoFilename().split('_');
        reloadICPhoto(nameguid[1], nameguid[0]);
        $("#candidate_photo").val(getPhotoFilename());
    }

    $("#candidate_christian_yes_no").click(function () {
        if ($("#candidate_christian_yes_no").is(':checked')) {
            $("#christian_yes_no").show("slow");
        }
        else {
            $("#christian_yes_no").hide();

        }
    });

    $('#' + getMaritalStatusID()).change(function () {
        if ($("#" + getMaritalStatusID() + " > option:selected").text() == 'Married') {
            $("#marriagedatediv").show();
        }
        else {
            $("#candidate_marriage_date").val("");
            $("#marriagedatediv").hide();
        }
    });

    if (getMailingList() == "TRUE") {
        $('#mailingList').prop('checked', true);
    }

    setSelectedDropDownlist(getSalutationID(), getSalutationValue());
    setSelectedDropDownlist("candidate_gender", getGenderValue());
    setSelectedDropDownlist(getDialectID(), getDialectValue());
    setSelectedDropDownlist(getMaritalStatusID(), getMaritalStatusValue());
    if (getMaritalStatusValue() == "2") {
        $("#marriagedatediv").show();
    }

    setSelectedDropDownlist(getEducationID(), getEducationValue());
    setSelectedDropDownlist(getBaptistByID(), getBaptizedBy());
    setSelectedDropDownlist(getBaptismChurchID(), getBaptizedChurch());
    setSelectedDropDownlist(getConfirmByID(), getConfirmationBy());
    setSelectedDropDownlist(getConfirmChurchID(), getConfirmationChurch());
    setSelectedDropDownlist(getPreviousChurchID(), getPreviousChurch());
    setSelectedDropDownlist(getCongregationID(), getCongregation());

    parseFamilyChild();

    changeBaptisedBy();
    changeBaptismChurch();
    changeConfirmBy();
    changeConfirmChurch();
    changePreviousChurch();

    if (!isOffline()) {

                uploader = new qq.FileUploader({
                    element: document.getElementById('candidate_photofile'),
                    action: '/uploadfile.mvc/SaveFile',
                    allowedExtensions: ['jpg', 'jpeg', 'jpe', 'png', 'gif'],
                    sizeLimit: 100000,
                    params: {
                        guid: getGUID()
                    },
                    onComplete: function (id, fileName, responseJSON) {
                        if (jQuery.trim(responseJSON) == "1") {
                            reloadICPhoto(fileName, getGUID());
                            $("#candidate_photo").val(getGUID() + "_" + fileName);
                        }
                    }
                });



        //        $('#candidate_photofile').uploadify({
        //            'uploader': '../Content/images/uploadify.swf',
        //            'script': '/uploadfile.mvc/SaveFile',
        //            'cancelImg': '../Content/images/cancel.png',
        //            'fileExt': '*.jpg;*.jpeg',
        //            'fileDesc': 'JPEG files only',
        //            'sizeLimit': '100000',
        //            'wmode': 'transparent',
        //            'scriptData': { 'guid': getGUID() },
        //            'buttonText': 'Click to select file',
        //            'onError': function (event, ID, fileObj, errorObj) {
        //                if (errorObj.type == "File Size")
        //                    alert('File must not be more than 100KBytes');
        //                $('#candidate_photofile').uploadifyClearQueue();
        //            },
        //            'onComplete': function (event, ID, fileObj, response, data) {
        //                if (jQuery.trim(response) == "1") {
        //                    reloadICPhoto(fileObj.name, getGUID());
        //                    $("#candidate_photo").val(getGUID() + "_" + fileObj.name);
        //                }
        //            },
        //            'onSelect': function (event, ID, fileObj) {
        //                if (fileObj.name.indexOf("+") > -1) {
        //                    alert("File name cannot any contain '+' character.");
        //                    setTimeout("$('#candidate_photofile').uploadifyClearQueue()", 100);
        //                }
        //            },
        //            'auto': true
        //        });
    }
});

function parseFamilyChild() {
    var familylistXMLstring = unescape(getFamilyList())
    if (familylistXMLstring.length != 0) {
        var familylistXML = stringToXML(familylistXMLstring);
        var family = familylistXML.getElementsByTagName("Family");
        for (x = 0; x < family.length; x++) {
            var FamilyType = "";
            if (family[x].getElementsByTagName("FamilyType")[0].childNodes.length > 0)
                FamilyType = family[x].getElementsByTagName("FamilyType")[0].childNodes[0].nodeValue;

            var FamilyEnglishName = "";
            if (family[x].getElementsByTagName("FamilyEnglishName")[0].childNodes.length > 0)
                FamilyEnglishName = family[x].getElementsByTagName("FamilyEnglishName")[0].childNodes[0].nodeValue;

            var FamilyChineseName = "";
            if (family[x].getElementsByTagName("FamilyChineseName")[0].childNodes.length > 0)
                FamilyChineseName = family[x].getElementsByTagName("FamilyChineseName")[0].childNodes[0].nodeValue;

            var FamilyOccupation = "";
            if (family[x].getElementsByTagName("FamilyOccupation")[0].childNodes.length > 0)
                FamilyOccupation = family[x].getElementsByTagName("FamilyOccupation")[0].childNodes[0].nodeValue;

            var FamilyReligion = "";
            if (family[x].getElementsByTagName("FamilyReligion")[0].childNodes.length > 0)
                FamilyReligion = family[x].getElementsByTagName("FamilyReligion")[0].childNodes[0].nodeValue;

            addNewFamily(FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion);
        }
    }

    var childlistXMLstring = unescape(getChildList())
    if (childlistXMLstring.length != 0) {
        var childlistXML = stringToXML(childlistXMLstring);
        var child = childlistXML.getElementsByTagName("Child");
        for (x = 0; x < child.length; x++) {
            var ChildEnglishName = "";
            if (child[x].getElementsByTagName("ChildEnglishName")[0].childNodes.length > 0)
                ChildEnglishName = child[x].getElementsByTagName("ChildEnglishName")[0].childNodes[0].nodeValue;

            var ChildChineseName = "";
            if (child[x].getElementsByTagName("ChildChineseName")[0].childNodes.length > 0)
                ChildChineseName = child[x].getElementsByTagName("ChildChineseName")[0].childNodes[0].nodeValue;

            var ChildBaptismDate = "";
            if (child[x].getElementsByTagName("ChildBaptismDate")[0].childNodes.length > 0)
                ChildBaptismDate = child[x].getElementsByTagName("ChildBaptismDate")[0].childNodes[0].nodeValue;

            var ChildBaptismBy = "";
            if (child[x].getElementsByTagName("ChildBaptismBy")[0].childNodes.length > 0)
                ChildBaptismBy = child[x].getElementsByTagName("ChildBaptismBy")[0].childNodes[0].nodeValue;

            var ChildChurch = "";
            if (child[x].getElementsByTagName("ChildChurch")[0].childNodes.length > 0)
                ChildChurch = child[x].getElementsByTagName("ChildChurch")[0].childNodes[0].nodeValue;

            addNewChild(ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch);
        }
    }

}



function reloadICPhoto(filename, guid) {
    $('#icphoto').attr('src', '/uploadfile.mvc/downloadPhoto?guid=' + guid + '&filename=' + escape(filename) + '&random=' + Math.random());
}

function removeSelectedFamily(obj) {
    var delRow = obj.parentNode.parentNode;
    var tbl = delRow.parentNode.parentNode;
	var rIndex = delRow.sectionRowIndex;
    var rowArray = new Array(delRow);
    for (var i = 0; i < rowArray.length; i++) {
        var rIndex = rowArray[i].sectionRowIndex;
        var currentTime = new Date();
        var time = currentTime.getMilliseconds();
        rowArray[i].parentNode.deleteRow(rIndex);
    }
	familyarray.splice(rIndex-2, 1);
	$('#familylist').val(familyarray.toString());
}

function removeSelectedChild(obj) {
    var delRow = obj.parentNode.parentNode;
    var tbl = delRow.parentNode.parentNode;
	var rIndex = delRow.sectionRowIndex;
    var rowArray = new Array(delRow);
    for (var i = 0; i < rowArray.length; i++) {
        var rIndex = rowArray[i].sectionRowIndex;
        var currentTime = new Date();
        var time = currentTime.getMilliseconds();
        rowArray[i].parentNode.deleteRow(rIndex);
    }
	childarray.splice(rIndex-2, 1);
	$('#childlist').val(childarray.toString());
}

var totalChild = 0;
var totalFamily = 0;
var totalAttachment = 0;
var childarray = new Array();
var familyarray = new Array();
var attachmentarray = new Array();

function addNewAttachment(attachmentType, filename) {
    totalAttachment++;
    attachmentarray.push(totalAttachment.toString());
    $('#attachmentlist').val(attachmentarray.toString());
    var table = document.getElementById("attachmenttable");
    var row = table.insertRow(document.getElementById("attachmenttable").rows.length);
    var attachmentno = totalAttachment;

    var attachmenttype = '<div><select style="width:100%" name="attachmenttype_' + attachmentno.toString() + '"" id="attachmenttype_' + attachmentno.toString() + '" >' + getAttachmentType() + '</select></div>';
    var attachmentfile = '<div><input type="file" style="width:100%" name="attachmentfile_' + attachmentno.toString() + '" id="attachmentfile_' + attachmentno.toString() + '"/></div>';

    fillCell(row, 0, attachmenttype);
    fillCell(row, 1, attachmentfile);

    if (!isOffline())
        fillCell(row, 2, '<img onclick="removeSelectedChild(this);" border="0" src="/Content/images/remove.png" width="20" height="20" title="Remove Child" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    else
        fillCell(row, 2, '<input type="button" onclick="removeSelectedChild(this);" value="-"/>');

    setSelectedDropDownlist('attachmenttype_' + attachmentno.toString(), attachmentType);
}

function addNewChild(ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) {
    totalChild++;
	childarray.push(totalChild.toString());
	$('#childlist').val(childarray.toString());
    var table = document.getElementById("childtable");
    var row = table.insertRow(document.getElementById("childtable").rows.length);
    var childno = totalChild;

    var childnum = '<div><label style="width:100%" class="description" for="element_21b">' + childno.toString() + '.</label></div>';
    var childchinesename = '<div><input style="width:100%" id="child_chinese_name_' + childno.toString() + '" name="child_chinese_name_' + childno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var childname = '<div><input style="width:100%" id="child_english_name_' + childno.toString() + '" name="child_english_name_' + childno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var childbaptismdate = '<div><input style="width:100%" id="child_baptism_date_' + childno.toString() + '" name="child_baptism_date_' + childno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var childbaptismby = '<div><input style="width:100%" id="child_baptism_by_' + childno.toString() + '" name="child_baptism_by_' + childno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    //var childchurch = '<div><input style="width:100%" id="child_church_' + childno.toString() + '" name="child_church_' + childno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var childchurch = '<div><input type="hidden" id="child_church_text_' + childno.toString() + '" name="child_church_text_' + childno.toString() + '" /><select style="width:100%" onchange="changeHiddenText(this, \'child_church_text_'+ childno.toString()+'\');" class="element select medium" id="child_church_' + childno.toString() + '" name="child_church_' + childno.toString() + '">' + ParishOptionString() + '</select></div>';

    fillCell(row, 0, childnum);
    fillCell(row, 1, childname);
    fillCell(row, 2, childchinesename);
    fillCell(row, 3, childbaptismdate);
    fillCell(row, 4, childbaptismby);
    fillCell(row, 5, childchurch);
    if (!isOffline())
        fillCell(row, 6, '<img onclick="removeSelectedChild(this);" border="0" src="/Content/images/remove.png" width="20" height="20" title="Remove Child" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    else
        fillCell(row, 6, '<input type="button" onclick="removeSelectedChild(this);" value="-"/>');

    $('#child_baptism_date_' + childno.toString()).datepick({ dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    $("#child_chinese_name_" + childno.toString()).val(ChildChineseName);
    $("#child_english_name_" + childno.toString()).val(ChildEnglishName);
    $("#child_baptism_date_" + childno.toString()).val(ChildBaptismDate);
    $("#child_baptism_by_" + childno.toString()).val(ChildBaptismBy);
    $("#child_church_" + childno.toString()).val(ChildChurch);
}

function addNewFamily(familyType, englishName, chineseName, occupation, churchReligion) {
    totalFamily++;
	familyarray.push(totalFamily.toString());
	$('#familylist').val(familyarray.toString());
	
    var table = document.getElementById("familytable");
    var row = table.insertRow(document.getElementById("familytable").rows.length);
    var familyno = totalFamily;

    var familytype = '<div><input type="hidden" id="family_type_text_' + familyno.toString() + '" name="family_type_text_' + familyno.toString() + '" /><select style="width:100%" class="element select medium" onchange="changeHiddenText(this, \'family_type_text_' + familyno.toString() + '\');" id="family_type_' + familyno.toString() + '" name="family_type_' + familyno.toString() + '"> ' + FamilyTypeOptionString() + ' </select></div>';
    var familynameenglish = '<div><input style="width:100%" id="family_english_name_' + familyno.toString() + '" name="family_english_name_' + familyno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var familynamechinese = '<div><input style="width:100%" id="family_chinese_name_' + familyno.toString() + '" name="family_chinese_name_' + familyno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    //var familyoccupation = '<div><input style="width:100%" id="family_occupation_' + familyno.toString() + '" name="family_occupation_' + familyno.toString() + '" class="element text medium" type="text" maxlength="255" value=""/></div>';
    var familyoccupation = '<div><input type="hidden" id="family_occupation_text_' + familyno.toString() + '" name="family_occupation_text_' + familyno.toString() + '" /><select style="width:100%" class="element select medium" onchange="changeHiddenText(this, \'family_occupation_text_' + familyno.toString() + '\');" id="family_occupation_' + familyno.toString() + '" name="family_occupation_' + familyno.toString() + '">' + OccupationOptionString() + '</select></div>';
    var familyreligion = '<div><input type="hidden" id="family_religion_text_' + familyno.toString() + '" name="family_religion_text_' + familyno.toString() + '" /><select style="width:100%" class="element select medium" onchange="changeHiddenText(this, \'family_religion_text_' + familyno.toString() + '\');" id="family_religion_' + familyno.toString() + '" name="family_religion_' + familyno.toString() + '">' + ReligionOptionString() + '</select></div>';

    fillCell(row, 0, familytype);
    fillCell(row, 1, familynameenglish);
    fillCell(row, 2, familynamechinese);
    fillCell(row, 3, familyoccupation);
    fillCell(row, 4, familyreligion);
    if (!isOffline())
        fillCell(row, 5, '<img onclick="removeSelectedFamily(this);" border="0" src="/Content/images/remove.png" width="20" height="20" title="Remove Family" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    else
        fillCell(row, 5, '<input type="button" onclick="removeSelectedFamily(this);" value="-"/>');
    
    setSelectedDropDownlist('family_type_' + familyno.toString(), familyType);
    $("#family_english_name_"+familyno.toString()).val(englishName);
    $("#family_chinese_name_"+familyno.toString()).val(chineseName);
    $("#family_occupation_"+familyno.toString()).val(occupation);
    setSelectedDropDownlist('family_religion_' + familyno.toString(), churchReligion);
}

function fillCell(row, cellNumber, text) {
    var cell = row.insertCell(cellNumber);
    cell.innerHTML = text;
}

function basicCheck() {
    var errormsg = "";

    if (jQuery.trim($('#candidate_english_name').val()).length == 0)
        errormsg += "- Name in English is mandatory\n";

    if (jQuery.trim($('#candidate_nric').val()).length == 0){
        errormsg += "- NRIC is mandatory\n";
    }
    else if (validateNRIC(jQuery.trim($("#candidate_nric").val().toUpperCase())) == false) {
        errormsg += "- NRIC is invalid, Example S1234567A\n";        
    }


    if ($("#" + getCongregationID() + "> option:selected").val() == '') {
        errormsg += "- Congregation is mandatory\n";
    }

    if ((getSystemMode() != "FULL") || (getSystemMode() == "FULL" && getFullCheck() == "ON")) {

        if ($("#" + getSalutationID() + " > option:selected").val() == '')
            errormsg += "- Salutation is mandatory\n";

        if (jQuery.trim($('#candidate_dob').val()).length == 0)
            errormsg += "- Date Of Birth is mandatory\n";

        if ($("#candidate_gender > option:selected").val() == '')
            errormsg += "- Gender is mandatory\n";

        if ($("#" + getMaritalStatusID() + " > option:selected").val() == '')
            errormsg += "- Marital Status is mandatory\n";
        else if ($("#" + getMaritalStatusID() + " > option:selected").text() == 'Married' && jQuery.trim($('#candidate_marriage_date').val()).length == 0)
            errormsg += "- Marriage Date is mandatory\n";

        if (jQuery.trim($('#candidate_street_address').val()).length == 0)
            errormsg += "- Street Address is mandatory\n";

        if (jQuery.trim($('#candidate_blk_house').val()).length == 0)
            errormsg += "- Blk/House no. is mandatory\n";

        if (jQuery.trim($('#candidate_postal_code').val()).length == 0)
            errormsg += "- Postal Code is mandatory\n";
        else if (isNaN(jQuery.trim($("#candidate_postal_code").val())))
            errormsg += "- Postal Code is invalid\n";

        if ($("#" + getCandidateCountryID() + "> option:selected").val() == '')
            errormsg += "- Nationality is mandatory\n";

        if ($("#candidate_education > option:selected").val() == '')
            errormsg += "- Education is mandatory\n";

        if (selectedlanguges == '')
            errormsg += "- Language(s) is mandatory\n";

        if ($("#" + getCandidateOccupationID() + "> option:selected").val() == '')
            errormsg += "- Occupation is mandatory\n";

        if (isValidNumbericWithoutDecimal(jQuery.trim($("#candidate_home_tel").val())) == false && jQuery.trim($("#candidate_home_tel").val()).length != 0) {
            errormsg += "- Home Tel is invalid\n";
        }

        if (isValidNumbericWithoutDecimal(jQuery.trim($("#candidate_mobile_tel").val())) == false && jQuery.trim($("#candidate_mobile_tel").val()).length != 0) {
            errormsg += "- Mobile Tel is invalid\n";
        }

        if (isValidEmailAddress(jQuery.trim($("#candidate_email").val())) == false && jQuery.trim($("#candidate_email").val()).length != 0) {
            errormsg += "- Email address is invalid\n";
        }

        if (($("#" + getBaptistByID()).val() == "Others" && jQuery.trim($("#baptized_by_others").val()) == "Name of pastor") || ($("#" + getBaptistByID()).val() == "Others" && jQuery.trim($("#baptized_by_others").val()).length == 0)) {
            errormsg += "- Please enter the pastor who baptise you.\n";
        }

        if (($("#" + changeConfirmBy()).val() == "Others" && jQuery.trim($("#confirm_by_others").val()) == "Name of pastor") || ($("#" + changeConfirmBy()).val() == "Others" && jQuery.trim($("#confirm_by_others").val()).length == 0)) {
            errormsg += "- Please enter the pastor who confirm you.\n";
        }

        if (($("#" + getBaptismChurchID()).val() == "28" && jQuery.trim($("#baptism_church_others").val()) == "Name of church") || ($("#" + getBaptismChurchID()).val() == "28" && jQuery.trim($("#baptism_church_others").val()).length == 0)) {
            errormsg += "- Please enter the church baptise you in.\n";
        }

        if (($("#" + getConfirmChurchID()).val() == "28" && jQuery.trim($("#confirmation_church_others").val()) == "Name of church") || ($("#" + getConfirmChurchID()).val() == "28" && jQuery.trim($("#confirmation_church_others").val()).length == 0)) {
            errormsg += "- Please enter the church confirm you in.\n";
        }

        if (($("#" + getPreviousChurchID()).val() == "28" && jQuery.trim($("#previous_church_membership_others").val()) == "Name of church") || ($("#" + getPreviousChurchID()).val() == "28" && jQuery.trim($("#previous_church_membership_others").val()).length == 0)) {
            errormsg += "- Please enter the church you are from.\n";
        }

        if ($("#candidate_sponsor2").val().length == 0) {
            errormsg += "- Sponsor 2 is mandatory\n";
        }
    }    

    if (getSystemMode() != "FULL") {
        if ($("#candidate_sponsor1_text").val().length == 0) {
            errormsg += "- Sponsor 1 is mandatory\n";
        }
    }
    else {
        if (getFullCheck() == "ON" && $("#candidate_sponsor1").val().length == 0) {
            errormsg += "- Sponsor 1 is mandatory\n";
        }        
    }

    

    return errormsg;
}

var agreeordisagree = "";
function checkForm(){
    var errormsg = basicCheck();
    
	if (!isOffline()) {
	    if ($("#candidate_Filename").val().length > 0) {
	        if ($("#" + getFileTypeID() + "> option:selected").val() == '') {
	            alert("File Type is mandatory when uploading an attachment.\n")
	        }
	    }
	}

	if (errormsg.length > 0) {
	    alert(errormsg);
	    return;
	}	

	if (!isOffline()) {
	    domwindow = dhtmlmodal.open("Agreement", 'ajax', "/membership.mvc/displayAgreement", "Agreement", 'width=800px,height=600px,center=1,resize=1,scrolling=1');
	    domwindow.onclose = function () { //Define custom code to run when window is closed
	        if (agreeordisagree == 'agree') {
	            document.getElementById("maindiv").style.display = "none";
	            document.getElementById("loadingdiv").style.display = "block";    
                $("#" + getFormID()).submit();
	        }
	        return true;
	    }
	}
	else {
	    toXML();
	}

}

function setwatermark() {
    $("#previous_church_membership_others").watermark("Name of church");
    $("#confirmation_church_others").watermark("Name of church");
    $("#baptism_church_others").watermark("Name of church");
    $("#confirm_by_others").watermark("Name of pastor");
    $("#baptized_by_others").watermark("Name of pastor");
}

function changeBaptisedBy(){
    if ($("#" + getBaptistByID()).val() == "Others") {
        $("#baptized_by_others").show();
        setwatermark();
    }
    else {
        $("#baptized_by_others").val('');
        $("#baptized_by_others").hide();
    }
}

function changeBaptismChurch() {
    if ($("#" + getBaptismChurchID()).val() == "28") {
        $("#baptism_church_others").show();
        setwatermark();
    }
    else {
        $("#baptism_church_others").val('');
        $("#baptism_church_others").hide();
    }
}

function changeConfirmBy() {
    if ($("#" + getConfirmByID()).val() == "Others") {
        $("#confirm_by_others").show();
        setwatermark();
    }
    else {
        $("#confirm_by_others").val('');
        $("#confirm_by_others").hide();
    }
}

function changeConfirmChurch() {
    if ($("#" + getConfirmChurchID()).val() == "28") {
        $("#confirmation_church_others").show();
        setwatermark();
    }
    else {
        $("#confirmation_church_others").val('');
        $("#confirmation_church_others").hide();
    }
}

function changePreviousChurch() {
    if ($("#" + getPreviousChurchID()).val() == "28") {
        $("#previous_church_membership_others").show();
        setwatermark();
    }
    else {
        $("#previous_church_membership_others").val('');
        $("#previous_church_membership_others").hide();
    }

}




function toXML() {
    var convertxml = "<New></New>";
    xmlDoc = stringToXML(convertxml);

    xmlDoc = CreateAndAddElement(xmlDoc, "New", "NRIC", $("#candidate_nric").val());

    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Salutation", $("#" + getSalutationID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "EnglishName", $("#candidate_english_name").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ChineseName", $("#candidate_chinese_name").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Gender", $("#candidate_gender").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "DOB", $("#candidate_dob").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "MaritalStatus", $("#" + getMaritalStatusID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "MarriageDate", $("#candidate_marriage_date").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Nationality", $("#" + getCandidateCountryID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Dialect", $("#" + getDialectID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "AddressStreetName", $("#candidate_street_address").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "AddressPostalCode", $("#candidate_postal_code").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "AddressBlkHouse", $("#candidate_blk_house").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "AddressUnit", $("#candidate_unit").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "HomeTel", $("#candidate_home_tel").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "MobileTel", $("#candidate_mobile_tel").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Email", $("#candidate_email").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Education", $("#" + getEducationID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Language", $("#candidate_language").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Occupation", $("#" + getCandidateOccupationID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Congregation", $("#" + getCongregationID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "BaptismBy", $("#" + getBaptistByID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "BaptismDate", $("#candidate_baptism_date").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "BaptismChurch", $("#" + getBaptismChurchID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ConfirmationBy", $("#" + getConfirmByID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ConfirmationChurch", $("#" + getConfirmChurchID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ConfirmationDate", $("#candidate_confirmation_date").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "PreviousChurchMembership", $("#" + getPreviousChurchID()).val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Photo", "");
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Sponsor1", "");
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "Sponsor2", "");

    if ($("#candidate_serve_congregation").val() == "on")
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedServeCongregation", "1");
    else
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedServeCongregation", "0");

    if ($("#candidate_join_cellgroup").val() == "on")
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedCellgroup", "1");
    else
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedCellgroup", "0");

    if ($("#candidate_tithing").val() == "on")
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedTithing", "1");
    else
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "InterestedTithing", "0");

    xmlDoc = CreateAndAddElement(xmlDoc, "New", "TransferReason", $("#candidate_transfer_reason").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "BaptismByOthers", $("#baptized_by_others").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "BaptismChurchOthers", $("#baptism_church_others").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ConfirmByOthers", $("#confirm_by_others").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "ConfirmChurchOthers", $("#confirmation_church_others").val());
    xmlDoc = CreateAndAddElement(xmlDoc, "New", "PreviousChurchOthers", $("#previous_church_membership_others").val());

    if ($("#familylist").val() == "0" || $("#familylist").val().length == 0) {
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "FamilyList", "");
    }
    else {
        var familylist = $("#familylist").val().split(",");
        var allfamilymembers = "";
        for (var x = 0; x < familylist.length; x++) {
            var familymember = "";
            familymember += "<FamilyType>" + $("#family_type_" + familylist[x]).val() + "</FamilyType>";
            familymember += "<FamilyEnglishName>" + $("#family_english_name_" + familylist[x]).val() + "</FamilyEnglishName>";
            familymember += "<FamilyChineseName>" + $("#family_chinese_name_" + familylist[x]).val() + "</FamilyChineseName>";
            familymember += "<FamilyOccupation>" + $("#family_occupation_" + familylist[x]).val() + "</FamilyOccupation>";
            familymember += "<FamilyReligion>" + $("#family_religion_" + familylist[x]).val() + "</FamilyReligion>";
            allfamilymembers += "<Family>" + familymember + "</Family>";
        }
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "FamilyList", escape(allfamilymembers));
    }

    if ($("#childlist").val() == "0" || $("#childlist").val().length == 0) {
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "ChildList", "");
    }
    else {
        var childlist = $("#childlist").val().split(",");
        var allchild = "";
        for (var x = 0; x < childlist.length; x++) {
            var child = "";
            child += "<ChildEnglishName>" + $("#child_english_name_" + childlist[x]).val() + "</ChildEnglishName>";
            child += "<ChildChineseName>" + $("#child_chinese_name_" + childlist[x]).val() + "</ChildChineseName>";
            child += "<ChildBaptismDate>" + $("#child_baptism_date_" + childlist[x]).val() + "</ChildBaptismDate>";
            child += "<ChildBaptismBy>" + $("#child_baptism_by_" + childlist[x]).val() + "</ChildBaptismBy>";
            child += "<ChildChurch>" + $("#child_church_" + childlist[x]).val() + "</ChildChurch>";
            allchild += "<Child>" + child + "</Child>";
        }
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "ChildList", escape(allchild));
    }

    if ($("#" + getInterestedMinistryID()).val() != null) {
        var list = $("#" + getInterestedMinistryID()).val().toString().split(",");
        var allmini = "";
        for (var x = 0; x < list.length; x++) {
            allmini += "<MinistryID>" + list[x] + "</MinistryID>";
        }
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "Ministry", escape(allmini));
    }
    else {
        xmlDoc = CreateAndAddElement(xmlDoc, "New", "Ministry", "");
    }

    document.body.innerHTML = "Copy the below content and email back to St Andrew's Cathedral <br /> <textarea rows='20' cols='100'>" + XMLtoString(xmlDoc) + "</textarea>";
}

//function changeBaptisedBy() {
//    if ($("#" + getBaptistByID()).val() == "Others") {
//        $("#baptized_by_others").show();
//    }
//    else {
//        $("#baptized_by_others").val('');
//        $("#baptized_by_others").hide();
//    }
//}

//function changeBaptismChurch() {
//    if ($("#" + getBaptismChurchID()).val() == "28") {
//        $("#baptism_church_others").show();
//    }
//    else {
//        $("#baptism_church_others").val('');
//        $("#baptism_church_others").hide();
//    }
//}

//function changeConfirmBy() {
//    if ($("#" + getConfirmByID()).val() == "Others") {
//        $("#confirm_by_others").show();
//    }
//    else {
//        $("#confirm_by_others").val('');
//        $("#confirm_by_others").hide();
//    }
//}

//function changeConfirmChurch() {
//    if ($("#" + getConfirmChurchID()).val() == "28") {
//        $("#confirmation_church_others").show();
//    }
//    else {
//        $("#confirmation_church_others").val('');
//        $("#confirmation_church_others").hide();
//    }
//}

//function changePreviousChurch() {
//    if ($("#" + getPreviousChurchID()).val() == "28") {
//        $("#previous_church_membership_others").show();
//    }
//    else {
//        $("#previous_church_membership_others").val('');
//        $("#previous_church_membership_others").hide();
//    }

//}