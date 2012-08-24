
function setTextAreaLengthLimit(id) {
    $('#' + id).keyup(function () {
        //get the limit from maxlength attribute  
        var limit = parseInt($('#' + id).attr("maxlength"));
        //get the current text inside the textarea  
        var text = $(this).val();
        //count the number of characters in the text  
        var chars = text.length;

        //check if there are more characters then allowed  
        if (chars > limit) {
            //and if there are use substr to get the text before the limit  
            var new_text = text.substr(0, limit);

            //and change the current text with the new text  
            $(this).val(new_text);
        }
    });
}


function getNewSubmitForm() {
    var submitForm = document.createElement("FORM");
    document.body.appendChild(submitForm);
    submitForm.method = "POST";
    return submitForm;
}

function AddMember() {
    var submitForm = getNewSubmitForm();
    submitForm.action = "/Membership.mvc/NewMember";
    submitForm.Method = "POST";
    submitForm.submit();
}

function CourseRegistration() {
    var submitForm = getNewSubmitForm();
    submitForm.action = "/Membership.mvc/courseregistration";
    submitForm.Method = "POST";
    submitForm.submit();
}

function logout() {
    var submitForm = getNewSubmitForm();
    submitForm.action = "/Account.mvc/LogOff";
    submitForm.Method = "POST";
    submitForm.submit();
}

function Login() {
    var submitForm = getNewSubmitForm();
    submitForm.action = "/Account.mvc/LogOn";
    submitForm.Method = "POST";
    submitForm.submit();
}

function createNewFormElement(inputForm, elementName, elementValue) {
    var newElement = document.createElement("input");
    newElement.setAttribute("name", elementName);
    newElement.setAttribute("value", elementValue);
    newElement.setAttribute("type", "hidden");
    inputForm.appendChild(newElement);
    return inputForm;
}

function getCookie(c_name) {
    var i, x, y, ARRcookies = document.cookie.split(";");
    for (i = 0; i < ARRcookies.length; i++) {
        x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
        y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
        x = x.replace(/^\s+|\s+$/g, "");
        if (x == c_name) {
            return unescape(y);
        }
    }
}

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^(("[\w-+\s]+")|([\w-+]+(?:\.[\w-+]+)*)|("[\w-+\s]+")([\w-+]+(?:\.[\w-+]+)*))(@((?:[\w-+]+\.)*\w[\w-+]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][\d]\.|1[\d]{2}\.|[\d]{1,2}\.))((25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\.){2}(25[0-5]|2[0-4][\d]|1[\d]{2}|[\d]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}

function isValidNumbericWithoutDecimal(value) {
    return new RegExp(/^[0-9]{8,15}?$/).test(value);
}

function validateNRIC(ic) {

    var icArray = new Array(9);
    for (i = 0; i < 9; i++) {
        icArray[i] = ic.charAt(i);
    }

    icArray[1] *= 2;
    icArray[2] *= 7;
    icArray[3] *= 6;
    icArray[4] *= 5;
    icArray[5] *= 4;
    icArray[6] *= 3;
    icArray[7] *= 2;

    var weight = 0;
    for (i = 1; i < 8; i++) {
        weight += parseInt(icArray[i]);
    }

    var offset = (icArray[0] == "T" || icArray[0] == "G") ? 4 : 0;
    var temp = (offset + weight) % 11;

    var st = Array("J", "Z", "I", "H", "G", "F", "E", "D", "C", "B", "A");
    var fg = Array("X", "W", "U", "T", "R", "Q", "P", "N", "M", "L", "K");

    var theAlpha;
    if (icArray[0] == "S" || icArray[0] == "T") { theAlpha = st[temp]; }
    else if (icArray[0] == "F" || icArray[0] == "G") { theAlpha = fg[temp]; }

    return (icArray[8] == theAlpha); 
}

function setSelectedDropDownlist(id, value) {
    $('#' + id + ' option[value="' + value + '"]').attr("selected", "selected");
}

function stringToXML(stringdata) {
    return jQuery.parseXML(stringdata);
}


var typingTimer_usersearch;
var textinputid;
var searchsuggestid;
var hiddenid;
function searchSuggest(delay, textinput, searchsuggest, hidden) {
    if (getSystemMode() != "FULL") {
        return;
    }

    textinputid = textinput;
    searchsuggestid = searchsuggest;
    hiddenid = hidden;

    $("#" + hiddenid).val("");
    $("#" + searchsuggestid).hide();
    var doneTypingInterval = delay;  //time in ms, 5 second for example

    clearTimeout(typingTimer_usersearch);
    typingTimer_usersearch = setTimeout(doneTyping, doneTypingInterval);

    //user is "finished typing," do something
    function doneTyping() {
        var str = unescape(jQuery.trim($("#" + textinputid).val()));
        if (/[^A-Za-z0-9 ]/.test(str)) {
            return;
        }

        if (str.length > 1) {
            $.post('/parish.mvc/searchforInCharge',
                { name: $("#" + textinputid).val() },
                function (data) {
                    searchSuggestCallback(data);
                }
            );
        }
        else if (str.length == 0) {
            document.getElementById(searchsuggestid).innerHTML = '';
            document.getElementById(searchsuggestid).style.display = "none";
        }
    }

}

function searchSuggestCallback(data) {
    var xmlDoc = stringToXML(data);

    var dom = document.getElementById(searchsuggestid);
    dom.style.display = "block";
    dom.innerHTML = '';

    if (xmlDoc.getElementsByTagName("found").length == 0) {
        $(searchsuggestid).hide();
    }
    for (i = 0; i < xmlDoc.getElementsByTagName("found").length; i++) {

        var photo = "";
        if (xmlDoc.getElementsByTagName("found")[i].getElementsByTagName("ICPhoto")[0].childNodes.length > 0)
            photo = xmlDoc.getElementsByTagName("found")[i].getElementsByTagName("ICPhoto")[0].childNodes[0].nodeValue;
        var name = xmlDoc.getElementsByTagName("found")[i].getElementsByTagName("Name")[0].childNodes[0].nodeValue;
        var nric = xmlDoc.getElementsByTagName("found")[i].getElementsByTagName("NRIC")[0].childNodes[0].nodeValue;
        var email = xmlDoc.getElementsByTagName("found")[i].getElementsByTagName("Email")[0].childNodes[0].nodeValue;
        
        var url = "/Content/images/empty_profile_pix.gif";
        if (photo.length > 0) {

            url = '/uploadfile.mvc/downloadPhotoWithoutGUID?filename=' + escape(photo) + '&random=' + Math.random()

        }

        var suggest = '<div onmouseover="javascript:suggestOver(this);" ';
        suggest += 'onmouseout="javascript:suggestOut(this);" ';
        suggest += 'onclick="javascript:setSearchSuggest(\'' + nric + '\',\'' + name + '\');" ';
        suggest += 'class="suggest_link"><table style="width:100%"><tr><td style="width:70px;text-align:center"><img style="width:auto;height:50px" src="' + url + '"></td><td>' + name + '<br/>' + email + '</td></tr></table></div>';
        dom.innerHTML += suggest;
    }
}

function suggestOver(div_value) {
    div_value.className = 'suggest_link_over';
}
//Mouse out function
function suggestOut(div_value) {
    div_value.className = 'suggest_link';
}

function fillCell(row, cellNumber, text) {
    var cell = row.insertCell(cellNumber);
    cell.innerHTML = text;
}
function fillCellAlignLeft(row, cellNumber, text) {
    var cell = row.insertCell(cellNumber);
    cell.align = "left";
    cell.innerHTML = text;
}

function setSearchSuggest(nric, name) {
    $("#" + textinputid).val(name);
    $("#" + hiddenid).val(nric);
    $("#" + searchsuggestid).hide();
}

function printGreenForm(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "nric", nric);
    submitForm.action = "/membership.mvc/printgreenform";
    submitForm.Method = "POST";
    submitForm.submit();
}

function printElectoralRoll(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "nric", nric);
    submitForm.action = "/membership.mvc/printelectoralroll";
    submitForm.Method = "POST";
    submitForm.submit();
}

function printTransferForm(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "nric", nric);
    submitForm.action = "/membership.mvc/printtransferform";
    submitForm.Method = "POST";
    submitForm.submit();
}

function loadMember(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "NRIC", nric);
    submitForm.action = "/Membership.mvc/UpdateMemberForStaff";
    submitForm.Method = "POST";
    submitForm.submit();
}

function loadKid(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "NRIC", nric);
    submitForm.action = "/CityKids.mvc/UpdateKidForStaff";
    submitForm.Method = "POST";
    submitForm.submit();
}

function loadTempMember(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "NRIC", nric);
    submitForm.action = "/Membership.mvc/UpdateTempMemberForStaff";
    submitForm.Method = "POST";
    submitForm.submit();
}

function loadVisitor(nric) {
    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "NRIC", nric);
    submitForm.action = "/Membership.mvc/UpdateVisitorForStaff";
    submitForm.Method = "POST";
    submitForm.submit();
}

function checkBoxIndividualApprove(obj) {
    var totalrecord = parseInt($("#totalrecord").val());
    for (var x = 0; x < totalrecord; x++) {
        if ($("#approveCheckBox" + x.toString()).is(':checked')) { yesno = true; } else { $("#check_uncheck_all").prop("checked", false); return; }
    }

    $("#check_uncheck_all").prop("checked", true);
}

function for_check_uncheck_all() {
    var yesno = false;
    if ($('#check_uncheck_all').is(':checked')) { yesno = true; } else { yesno = false; }
    var totalrecord = parseInt($("#totalrecord").val());
    for (var x = 0; x < totalrecord; x++) {
        $("#approveCheckBox" + x.toString()).prop("checked", yesno);
    }
}

function ApproveSelectedMembers() {
    var nric = "";
     var totalrecord = parseInt($("#totalrecord").val());
    for (var x = 0; x < totalrecord; x++) {
        if ($("#approveCheckBox" + x.toString()).is(':checked')) {
            nric += $("#approveCheckBox" + x.toString()).val() + ",";
        }
    }
    if (nric.length > 0) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "NRIC", nric);
        submitForm.action = "/Membership.mvc/submitApproveMembers";
        submitForm.Method = "POST";
        submitForm.submit();
    }
    else {
        alert("No member selected.")
        return;
    }
}

function PostalCodeKeyup(e) {
    if (getAutoPostalCode() == "Off"){
        if(isNaN(jQuery.trim($("#candidate_postal_code").val()))){
            alert("Only Numeric allow.");
            $("#candidate_postal_code").val($("#candidate_postal_code").val().substring(0, $("#candidate_postal_code").val().length - 1));
        }
        return;
    }
    $("#candidate_street_address").val("");
    $("#candidate_blk_house").val("");
    $("#candidate_unit").val("");

    if (jQuery.trim($("#candidate_postal_code").val()).length != 6) {
        return;
    }
    else if (isNaN(jQuery.trim($("#candidate_postal_code").val()))) {
        alert("Only Numeric allow.");
        $("#candidate_postal_code").val($("#candidate_postal_code").val().substring(0, $("#candidate_postal_code").val().length - 1));
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
    if (getPostalCodeRetrival() == "CLIENT") {
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


function CreateAndAddElement(xmlDoc, tag, elementName, elementValue) {
    element = xmlDoc.createElement(elementName);
    value = xmlDoc.createTextNode(elementValue);
    element.appendChild(value);
    x = xmlDoc.getElementsByTagName(tag)[0];
    x.appendChild(element);
    return xmlDoc;
}

function XMLtoString(elem) {

    var serialized;

    try {
        serializer = new XMLSerializer();
        serialized = serializer.serializeToString(elem);
    }
    catch (e) {
        serialized = elem.xml;
    }

    return serialized;
}

function removeSelectedRow(obj) {
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
}