﻿$(document).ready(function () {
    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(this).addClass("active"); //Add "active" class to selected tab
        $(".tab_content").hide(); //Hide all tab content
        var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
        $(activeTab).fadeIn(); //Fade in the active content
        //$(activeTab).show(); 
        window.focus();
        return false;
    });

    $(".tab_content").hide(); //Hide all content
    setActiveTab("Church Area");

    parseXML('ChurchArea', 'ChurchAreaXML', 'ChurchAreaTable', 'ChurchArealist', 'ChurchAreaID', 'ChurchAreaName');
    parseXML('BusGroupCluster', 'BusGroupClusterXML', 'BusGroupClusterTable', 'BusGroupClusterlist', 'BusGroupClusterID', 'BusGroupClusterName');
    parseXML('ClubGroup', 'ClubGroupXML', 'ClubGroupTable', 'ClubGrouplist', 'ClubGroupID', 'ClubGroupName');
    parseXML('Race', 'RaceXML', 'RaceTable', 'Racelist', 'RaceID', 'RaceName');
    parseXML('Religion', 'ReligionXML', 'ReligionTable', 'Religionlist', 'ReligionID', 'ReligionName');
    parseXML('FileType', 'FileTypeXML', 'FileTypeTable', 'FileTypelist', 'FileTypeID', 'FileTypeName');
    parseXML('FamilyType', 'FamilyTypeXML', 'FamilyTypeTable', 'FamilyTypelist', 'FamilyTypeID', 'FamilyTypeName');
    parseXML('School', 'SchoolXML', 'SchoolTable', 'Schoollist', 'SchoolID', 'SchoolName');
    parseXML('Congregation', 'CongregationXML', 'CongregationTable', 'Congregationlist', 'CongregationID', 'CongregationName');
    parseXML('Country', 'CountryXML', 'CountryTable', 'Countrylist', 'CountryID', 'CountryName');
    parseXML('Dialect', 'DialectXML', 'DialectTable', 'Dialectlist', 'DialectID', 'DialectName');
    parseXML('Education', 'EducationXML', 'EducationTable', 'Educationlist', 'EducationID', 'EducationName');
    parseXML('Language', 'LanguageXML', 'LanguageTable', 'Languagelist', 'LanguageID', 'LanguageName');
    parseXML('MaritalStatus', 'MaritalStatusXML', 'MaritalStatusTable', 'MaritalStatuslist', 'MaritalStatusID', 'MaritalStatusName');
    parseXML('Occupation', 'OccupationXML', 'OccupationTable', 'Occupationlist', 'OccupationID', 'OccupationName');
    parseXML('Parish', 'ParishXML', 'ParishTable', 'Parishlist', 'ParishID', 'ParishName');
    parseXML('Salutation', 'SalutationXML', 'SalutationTable', 'Salutationlist', 'SalutationID', 'SalutationName');
    parseXML('Style', 'StyleXML', 'StyleTable', 'Stylelist', 'StyleID', 'StyleName');

    parseExternalDBXML();
    parseConfigXML();
    parseEmailXML();
    parsePostalXML();
    parseAdditionalInfoXML();

    myProgressBar = new ProgressBar("my_progress_bar_1", {
        borderRadius: 10,
        width: 300,
        height: 20,
        maxValue: 100,
        labelText: "{value,0} % completed",
        orientation: ProgressBar.Orientation.Horizontal,
        direction: ProgressBar.Direction.LeftToRight,
        animationStyle: ProgressBar.AnimationStyle.LeftToRight1,
        animationSpeed: 1.5,
        imageUrl: '/Content/images/v_fg12.png',
        backgroundUrl: '/Content/images/h_bg2.png',
        markerUrl: '/Content/images/marker2.png'
    });
    myProgressBar.setValue(0);   
});

var myProgressBar;

function setActiveTab(tabname) {
    if (tabname == "Church Area") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    
    window.focus();
}

///////////////////////////////////
//// External DB //////////////////
///////////////////////////////////

function SyncAllSettings() {
    $("#progressDIV").show();
    $("#syncimg").show("slow");
    $("#syncMessage").html("Synchronizing. Please wait......");
    $("#syncMessageDiv").show("slow");
    $.post('/settings.mvc/SyncAllSettings',
        function (result) {
            checkSyncAllSettings();
        }
    );
}

var checkSyncTimer = null;

function checkSyncAllSettings() {
    $.post('/settings.mvc/checkSyncAllSettings',
        function (result) {
            if (jQuery.trim(result) == "Updated") {
                $("#syncimg").hide("slow");
                $("#syncMessage").html("Data Synchronized. &nbsp;");
                clearTimeout(checkSyncTimer);
            }
            else if (jQuery.trim(result) == "Error") {
                $("#syncimg").hide("slow");
                $("#syncMessage").html("Error Synchronizing. &nbsp;");
                clearTimeout(checkSyncTimer);
            }
            else {
                if (jQuery.trim(result).length > 0) {
                    myProgressBar.setValue(parseInt(jQuery.trim(result)));
                }
                checkSyncTimer = setTimeout("checkSyncAllSettings()", 1000);
            }
        }
    );
}

function parseExternalDBXML() {
    var externalxml = stringToXML(unescape($("#ExternalDBXML").val()));
    var external = externalxml.getElementsByTagName("Site");
    for (x = 0; x < external.length; x++) {
        if (x == 0) {
            $("#ExternalDBTable").find("tr:gt(0)").remove();
            totalExternalDB = 0;
            ExternalDBarray = new Array();
        }
        var id = external[x].getElementsByTagName("ExternalDBID")[0].childNodes[0].nodeValue;
        var name = external[x].getElementsByTagName("ExternalSiteName")[0].childNodes[0].nodeValue;
        var ip = external[x].getElementsByTagName("ExternalDBIP")[0].childNodes[0].nodeValue;
        addNewExternalDB(id, name, ip);
    }

    var result = externalxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(externalxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalExternalDB = 0;
var ExternalDBarray = new Array();

function addNewExternalDB(id_input, name_input, ip_input) {
    totalExternalDB++;
    ExternalDBarray.push(totalExternalDB.toString());
    $('#ExternalDBlist').val(ExternalDBarray.toString());

    var table = document.getElementById("ExternalDBTable");
    var row = table.insertRow(table.rows.length);
    var ExternalDBno = totalExternalDB;

    var id = '<input style=" width:40px;" readonly="readonly" id="ExternalDBID_' + ExternalDBno.toString() + '" name="ExternalDBID_' + ExternalDBno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="ExternalDBName_' + ExternalDBno.toString() + '" name="ExternalDBName_' + ExternalDBno.toString() + '" type="text" maxlength="200" value=""/></div>';
    var ip = '<input style=" width:100%;" id="ExternalDBIP_' + ExternalDBno.toString() + '" name="ExternalDBIP_' + ExternalDBno.toString() + '" type="text" maxlength="200" value=""/></div>';
    
    fillCell(row, 0, '<img onclick="removeSelectedExternalDB(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);
    fillCell(row, 3, ip);
    
    $("#ExternalDBID_" + ExternalDBno.toString()).val(id_input);
    $("#ExternalDBName_" + ExternalDBno.toString()).val(name_input);
    $("#ExternalDBIP_" + ExternalDBno.toString()).val(ip_input);    
}

function removeSelectedExternalDB(obj) {
    var r = confirm("Are you sure to delete this?")
    if (r == false) {
        return;
    }

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
    ExternalDBarray.splice(rIndex - 1, 1);
    $('#ExternalDBlist').val(Stylearray.toString());
}

function addExternalDB(obj){
    addNewExternalDB('New', '', '', '', '');
    var objDiv = obj.parentNode.parentNode.parentNode.parentNode.parentNode;
    objDiv.scrollTop = objDiv.scrollHeight;
}

function checkAndSubmitExternalDB() {
    var xmlstring = "";
    for (var x = 0; x < ExternalDBarray.length; x++) {
        if (jQuery.trim($("#ExternalDBName_" + ExternalDBarray[x]).val()).length <= 0 || jQuery.trim($("#ExternalDBIP_" + ExternalDBarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ",all value cannot be blank");
            return;
        }

        xmlstring += "<ExternalDB><ExternalDBID>" + $("#ExternalDBID_" + ExternalDBarray[x]).val() + "</ExternalDBID><ExternalDBIP>" + encodeURIComponent($("#ExternalDBIP_" + ExternalDBarray[x]).val()) + "</ExternalDBIP><ExternalDBName>" + encodeURIComponent($("#ExternalDBName_" + ExternalDBarray[x]).val()) + "</ExternalDBName></ExternalDB>";
    }

    xmlstring = "<ChurchExternalDB>" + xmlstring + "</ChurchExternalDB>"

    $.post('/settings.mvc/updateExternalDB',
        { xml: escape(xmlstring) },
        function (data) {
            $("#ExternalDBXML").val(unescape(data));
            parseExternalDBXML();
        }
    );
}

///////////////////////////////////
//// Config ///////////////////////
///////////////////////////////////

function parseConfigXML() {
    var configxml = stringToXML(unescape($("#ConfigXML").val()));
    var conf = configxml.getElementsByTagName("Config");
    for (x = 0; x < conf.length; x++) {
        if (x == 0) {
            $("#ConfigTable").find("tr:gt(0)").remove();
            totalConfig = 0;
            Configarray = new Array();
        }
        var id = conf[x].getElementsByTagName("ConfigID")[0].childNodes[0].nodeValue;
        var name = conf[x].getElementsByTagName("ConfigName")[0].childNodes[0].nodeValue;
        var value = conf[x].getElementsByTagName("value")[0].childNodes[0].nodeValue;
        addNewConfig(id, name, value);
    }

    var result = configxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(configxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalConfig = 0;
var Configarray = new Array();

function addNewConfig(id_input, name_input, value_input) {
    totalConfig++;
    Configarray.push(totalConfig.toString());
    $('#Configlist').val(Configarray.toString());

    var table = document.getElementById("ConfigTable");
    var row = table.insertRow(1);
    var Configno = totalConfig;

    var id = '<input style=" width:40px;" readonly="readonly" id="ConfigID_' + Configno.toString() + '" name="ConfigID_' + Configno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" readonly="readonly" id="ConfigName_' + Configno.toString() + '" name="ConfigName_' + Configno.toString() + '" type="text" maxlength="100" value=""/></div>';
    var value = '<input style=" width:100%;" id="value_' + Configno.toString() + '" name="value_' + Configno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, id);
    fillCell(row, 1, name);
    fillCell(row, 2, value);

    $("#ConfigID_" + Configno.toString()).val(id_input);
    $("#ConfigName_" + Configno.toString()).val(name_input);
    $("#value_" + Configno.toString()).val(value_input);
}

function checkAndSubmitConfig() {
    var xmlstring = "";
    for (var x = 0; x < Configarray.length; x++) {
        if (jQuery.trim($("#value_" + Configarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", value cannot be blank");
            return;
        }

        xmlstring += "<Config><ConfigID>" + $("#ConfigID_" + Configarray[x]).val() + "</ConfigID><value>" + encodeURIComponent($("#value_" + Configarray[x]).val()) + "</value></Config>";
    }

    xmlstring = "<ChurchConfig>" + xmlstring + "</ChurchConfig>"

    $.post('/settings.mvc/updateConfig',
        { xml: escape(xmlstring) },
        function (data) {
            $("#ConfigXML").val(unescape(data));
            parseConfigXML();
        }
    );
}



///////////////////////////////////
//// Additional Info///////////////
///////////////////////////////////

function parseAdditionalInfoXML() {
    var additionalinfoxml = stringToXML(unescape($("#AdditionalInfoXML").val()));
    var additionalinfo = additionalinfoxml.getElementsByTagName("AdditionalInfo");
    for (x = 0; x < additionalinfo.length; x++) {
        if (x == 0) {
            $("#AdditionalInfoTable").find("tr:gt(0)").remove();
            totalAdditionalInfo = 0;
            AdditionalInfoarray = new Array();
        }
        var value = $(additionalinfo[x]).find("AgreementHTML").text();
        var id = additionalinfo[x].getElementsByTagName("AgreementID")[0].childNodes[0].nodeValue;
        var name = additionalinfo[x].getElementsByTagName("AgreementType")[0].childNodes[0].nodeValue;
        addNewAdditionalInfo(id, name, value);
    }

    var result = additionalinfoxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(additionalinfoxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalAdditionalInfo = 0;
var AdditionalInfoarray = new Array();

function addNewAdditionalInfo(id_input, name_input, value_input) {
    totalAdditionalInfo++;
    AdditionalInfoarray.push(totalAdditionalInfo.toString());
    $('#AdditionalInfolist').val(AdditionalInfoarray.toString());

    var table = document.getElementById("AdditionalInfoTable");
    var row = table.insertRow(1);
    var AdditionalInfono = totalAdditionalInfo;

    var id = '<input style=" width:40px;" readonly="readonly" id="AgreementID_' + AdditionalInfono.toString() + '" name="AgreementID_' + AdditionalInfono.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="AgreementType_' + AdditionalInfono.toString() + '" name="AgreementType_' + AdditionalInfono.toString() + '" type="text" maxlength="100" value=""/></div>';
    var value = '<textarea cols="80" rows="6" id="AgreementHTML_' + AdditionalInfono.toString() + '" name="AgreementHTML_' + AdditionalInfono.toString() + '"></textarea></div>';
    
    fillCell(row, 0, id);
    fillCell(row, 1, name);
    fillCell(row, 2, value);

    $("#AgreementID_" + AdditionalInfono.toString()).val(id_input);
    $("#AgreementType_" + AdditionalInfono.toString()).val(name_input);
    $("#AgreementHTML_" + AdditionalInfono.toString()).val(unescape(value_input));
}

function checkAndSubmitAdditionalInfo() {
    var xmlstring = "";
    for (var x = 0; x < AdditionalInfoarray.length; x++) {
        if (jQuery.trim($("#AgreementHTML_" + AdditionalInfoarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", HTML Content cannot be blank");
            return;
        }

        xmlstring += "<AdditionalInfo><AgreementType>" + $("#AgreementType_" + AdditionalInfoarray[x]).val() + "</AgreementType><AgreementID>" + $("#AgreementID_" + AdditionalInfoarray[x]).val() + "</AgreementID><AgreementHTML>" + encodeURIComponent($("#AgreementHTML_" + AdditionalInfoarray[x]).val()) + "</AgreementHTML></AdditionalInfo>";
    }

    xmlstring = "<ChurchAdditionalInfo>" + xmlstring + "</ChurchAdditionalInfo>"

    $.post('/settings.mvc/updateAdditionalInfo',
        { xml: escape(xmlstring) },
        function (data) {
            $("#AdditionalInfoXML").val(unescape(data));
            parseAdditionalInfoXML();
        }
    );
}

///////////////////////////////////
//// Email ////////////////////////
///////////////////////////////////

function parseEmailXML() {
    var emailxml = stringToXML(unescape($("#EmailXML").val()));
    var email = emailxml.getElementsByTagName("Email");
    for (x = 0; x < email.length; x++) {
        if (x == 0) {
            $("#EmailTable").find("tr:gt(0)").remove();
            totalEmail = 0;
            Emailarray = new Array();
        }
        var value = $(email[x]).find("EmailContent").text();
        var id = email[x].getElementsByTagName("EmailID")[0].childNodes[0].nodeValue;
        var name = email[x].getElementsByTagName("EmailType")[0].childNodes[0].nodeValue;
        addNewEmail(id, name, value);
    }

    var result = emailxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(emailxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalEmail = 0;
var Emailarray = new Array();

function addNewEmail(id_input, name_input, value_input) {
    totalEmail++;
    Emailarray.push(totalEmail.toString());
    $('#Emaillist').val(Emailarray.toString());

    var table = document.getElementById("EmailTable");
    var row = table.insertRow(1);
    var Emailno = totalEmail;

    var id = '<input style=" width:40px;" readonly="readonly" id="EmailID_' + Emailno.toString() + '" name="EmailID_' + Emailno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" readonly="readonly" id="EmailType_' + Emailno.toString() + '" name="EmailType_' + Emailno.toString() + '" type="text" maxlength="100" value=""/></div>';
    var value = '<textarea cols="80" rows="6" id="EmailContent_' + Emailno.toString() + '" name="EmailContent_' + Emailno.toString() + '"></textarea></div>';

    fillCell(row, 0, id);
    fillCell(row, 1, name);
    fillCell(row, 2, value);

    $("#EmailID_" + Emailno.toString()).val(id_input);
    $("#EmailType_" + Emailno.toString()).val(name_input);
    $("#EmailContent_" + Emailno.toString()).val(unescape(value_input));
}

function checkAndSubmitEmail() {
    var xmlstring = "";
    for (var x = 0; x < Emailarray.length; x++) {
        if (jQuery.trim($("#EmailContent_" + Emailarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Email Content cannot be blank");
            return;
        }

        xmlstring += "<Email><EmailID>" + $("#EmailID_" + Emailarray[x]).val() + "</EmailID><EmailContent>" + encodeURIComponent($("#EmailContent_" + Configarray[x]).val()) + "</EmailContent></Email>";
    }

    xmlstring = "<ChurchEmail>" + xmlstring + "</ChurchEmail>"

    $.post('/settings.mvc/updateEmail',
        { xml: escape(xmlstring) },
        function (data) {
            $("#EmailXML").val(unescape(data));
            parseEmailXML();
        }
    );
}

///////////////////////////////////
//// Postal ///////////////////////
///////////////////////////////////

function parsePostalXML() {
    var postalxml = stringToXML(unescape($("#PostalXML").val()));
    var post = postalxml.getElementsByTagName("Postal");
    for (x = 0; x < post.length; x++) {
        if (x == 0) {
            $("#PostalTable").find("tr:gt(0)").remove();
            totalPostal = 0;
            Postalarray = new Array();
        }
        var id = post[x].getElementsByTagName("District")[0].childNodes[0].nodeValue;
        var name = post[x].getElementsByTagName("PostalAreaName")[0].childNodes[0].nodeValue;
        var value = post[x].getElementsByTagName("PostalDigit")[0].childNodes[0].nodeValue;
        addNewPostal(id, name, value);
    }

    var result = postalxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(postalxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalPostal = 0;
var Postalarray = new Array();

function addPostal(obj) {
    addNewPostal('New', '', '');
    var objDiv = obj.parentNode.parentNode.parentNode.parentNode.parentNode;
    objDiv.scrollTop = objDiv.scrollHeight;
}

function addNewPostal(id_input, name_input, value_input) {
    totalPostal++;
    Postalarray.push(totalPostal.toString());
    $('#Postallist').val(Postalarray.toString());

    var table = document.getElementById("PostalTable");
    var row = table.insertRow(table.rows.length);
    var Postalno = totalPostal;

    var id = '<input style=" width:40px;" readonly="readonly" id="PostalID_' + Postalno.toString() + '" name="PostalID_' + Postalno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="PostalName_' + Postalno.toString() + '" name="PostalName_' + Postalno.toString() + '" type="text" maxlength="200" value=""/></div>';
    var value = '<input style=" width:100%;" id="Postalvalue_' + Postalno.toString() + '" name="Postalvalue_' + Postalno.toString() + '" type="text" maxlength="200" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedPostal(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);
    fillCell(row, 3, value);

    $("#PostalID_" + Postalno.toString()).val(id_input);
    $("#PostalName_" + Postalno.toString()).val(name_input);
    $("#Postalvalue_" + Postalno.toString()).val(value_input);
}

function removeSelectedPostal(obj) {
    var r = confirm("Are you sure to delete this?")
    if (r == false) {
        return;
    }

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
    Postalarray.splice(rIndex - 1, 1);
    $('#Postallist').val(Postalarray.toString());
}

function checkAndSubmitPostal() {
    var xmlstring = "";
    for (var x = 0; x < Postalarray.length; x++) {
        if (jQuery.trim($("#Postalvalue_" + Postalarray[x]).val()).length <= 0 || jQuery.trim($("#PostalName_" + Postalarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", value cannot be blank");
            return;
        }

        xmlstring += "<Postal><PostalID>" + $("#PostalID_" + Postalarray[x]).val() + "</PostalID><PostalName>" + encodeURIComponent($("#PostalName_" + Postalarray[x]).val()) + "</PostalName><Postalvalue>" + encodeURIComponent($("#Postalvalue_" + Postalarray[x]).val()) + "</Postalvalue></Postal>";
    }

    xmlstring = "<PostalConfig>" + xmlstring + "</PostalConfig>"

    $.post('/settings.mvc/updatePostal',
        { xml: escape(xmlstring) },
        function (data) {
            $("#PostalXML").val(unescape(data));
            parsePostalXML();
        }
    );
}




























    var totalCongregation = 0;
    var Congregationarray = new Array();

    var totalChurchArea = 0;
    var ChurchAreaarray = new Array();

    var totalFileType = 0;
    var FileTypearray = new Array();

    var totalBusGroupCluster = 0;
    var BusGroupClusterarray = new Array();

    var totalClubGroup = 0;
    var ClubGrouparray = new Array();

    var totalRace = 0;
    var Racearray = new Array();

    var totalReligion = 0;
    var Religionarray = new Array();

    var totalSchool = 0;
    var Schoolarray = new Array();

    var totalFamilyType = 0;
    var FamilyTypearray = new Array();

    var totalCountry = 0;
    var Countryarray = new Array();

    var totalDialect = 0;
    var Dialectarray = new Array();

    var totalEducation = 0;
    var Educationarray = new Array();

    var totalLanguage = 0;
    var Languagearray = new Array();

    var totalMaritalStatus = 0;
    var MaritalStatusarray = new Array();

    var totalOccupation = 0;
    var Occupationarray = new Array();

    var totalParish = 0;
    var Parisharray = new Array();

    var totalSalutation = 0;
    var Salutationarray = new Array();

    var totalStyle = 0;
    var Stylearray = new Array();

    ///////////////////////////////////////////////////////////////////////////

    function resetVariable(type) {
        if (type == "Country") {
            totalCountry = 0;
            Countryarray = new Array();
        }
        else if (type == "Style") {
            totalStyle = 0;
            Stylearray = new Array();
        }
        else if (type == "Salutation") {
            totalSalutation = 0;
            Salutationarray = new Array();
        }
        else if (type == "Parish") {
            totalParish = 0;
            Parisharray = new Array();
        }
        else if (type == "Occupation") {
            totalOccupation = 0;
            Occupationarray = new Array();
        }
        else if (type == "MaritalStatus") {
            totalMaritalStatus = 0;
            MaritalStatusarray = new Array();
        }
        else if (type == "Language") {
            totalLanguage = 0;
            Languagearray = new Array();
        }
        else if (type == "Education") {
            totalEducation = 0;
            Educationarray = new Array();
        }
        else if (type == "Dialect") {
            totalDialect = 0;
            Dialectarray = new Array();
        }
        else if (type == "BusGroupCluster") {
            totalBusGroupCluster = 0;
            BusGroupClusterarray = new Array();
        }
        else if (type == "Congregation") {
            totalCongregation = 0;
            Congregationarray = new Array();
        }
        else if (type == "ChurchArea") {
            totalChurchArea = 0;
            ChurchAreaarray = new Array();
        }
        else if (type == "FileType") {
            totalFileType = 0;
            FileTypearray = new Array();
        }
        else if (type == "ClubGroup") {
            totalClubGroup = 0;
            ClubGrouparray = new Array();
        }
        else if (type == "Race") {
            totalRace = 0;
            Racearray = new Array();
        }
        else if (type == "Religion") {
            totalReligion = 0;
            Religionarray = new Array();
        }
        else if (type == "School") {
            totalSchool = 0;
            Schoolarray = new Array();
        }
        else if (type == "FamilyType") {
            totalFamilyType = 0;
            FamilyTypearray = new Array();
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function pushValue(type, listID) {
        if (type == "Country") {
            totalCountry++;
            Countryarray.push(totalCountry.toString());
            $('#' + listID).val(totalCountry.toString());
        }
        else if (type == "Style") {
            totalStyle++;
            Stylearray.push(totalStyle.toString());
            $('#' + listID).val(totalStyle.toString());
        }
        else if (type == "Salutation") {
            totalSalutation++;
            Salutationarray.push(totalSalutation.toString());
            $('#' + listID).val(totalSalutation.toString());
        }
        else if (type == "Parish") {
            totalParish++;
            Parisharray.push(totalParish.toString());
            $('#' + listID).val(totalParish.toString());
        }
        else if (type == "Occupation") {
            totalOccupation++;
            Occupationarray.push(totalOccupation.toString());
            $('#' + listID).val(totalOccupation.toString());
        }
        else if (type == "MaritalStatus") {
            totalMaritalStatus++;
            MaritalStatusarray.push(totalMaritalStatus.toString());
            $('#' + listID).val(totalMaritalStatus.toString());
        }
        else if (type == "Language") {
            totalLanguage++;
            Languagearray.push(totalLanguage.toString());
            $('#' + listID).val(totalLanguage.toString());
        }
        else if (type == "Education") {
            totalEducation++;
            Educationarray.push(totalEducation.toString());
            $('#' + listID).val(totalEducation.toString());
        }
        else if (type == "Dialect") {
            totalDialect++;
            Dialectarray.push(totalDialect.toString());
            $('#' + listID).val(totalDialect.toString());
        }
        else if (type == "BusGroupCluster") {
            totalBusGroupCluster++;
            BusGroupClusterarray.push(totalBusGroupCluster.toString());
            $('#' + listID).val(totalBusGroupCluster.toString());
        }
        else if (type == "Congregation") {
            totalCongregation++;
            Congregationarray.push(totalCongregation.toString());
            $('#' + listID).val(totalCongregation.toString());
        }
        else if (type == "ChurchArea") {
            totalChurchArea++;
            ChurchAreaarray.push(totalChurchArea.toString());
            $('#' + listID).val(totalChurchArea.toString());
        }
        else if (type == "FileType") {
            totalFileType++;
            FileTypearray.push(totalFileType.toString());
            $('#' + listID).val(totalFileType.toString());
        }
        else if (type == "ClubGroup") {
            totalClubGroup++;
            ClubGrouparray.push(totalClubGroup.toString());
            $('#' + listID).val(totalClubGroup.toString());
        }
        else if (type == "Race") {
            totalRace++;
            Racearray.push(totalRace.toString());
            $('#' + listID).val(totalRace.toString());
        }
        else if (type == "Religion") {
            totalReligion++;
            Religionarray.push(totalReligion.toString());
            $('#' + listID).val(totalReligion.toString());
        }
        else if (type == "School") {
            totalSchool++;
            Schoolarray.push(totalSchool.toString());
            $('#' + listID).val(totalSchool.toString());
        }
        else if (type == "FamilyType") {
            totalFamilyType++;
            FamilyTypearray.push(totalFamilyType.toString());
            $('#' + listID).val(totalFamilyType.toString());
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function getCurrentTotal(type) {
        if (type == "BusGroupCluster") {
            return totalBusGroupCluster;
        }
        else if (type == "Style") {
            return totalStyle;
        }
        else if (type == "Salutation") {
            return totalSalutation;
        }
        else if (type == "Parish") {
            return totalParish;
        }
        else if (type == "Occupation") {
            return totalOccupation;
        }
        else if (type == "MaritalStatus") {
            return totalMaritalStatus;
        }
        else if (type == "Language") {
            return totalLanguage;
        }
        else if (type == "Education") {
            return totalEducation;
        }
        else if (type == "Dialect") {
            return totalDialect;
        }
        else if (type == "Country") {
            return totalCountry;
        }
        else if (type == "Congregation") {
            return totalCongregation;
        }
        else if (type == "ChurchArea") {
            return totalChurchArea;
        }
        else if (type == "FileType") {
            return totalFileType;
        }
        else if (type == "ClubGroup") {
            return totalClubGroup;
        }
        else if (type == "Race") {
            return totalRace;
        }
        else if (type == "Religion") {
            return totalReligion;
        }
        else if (type == "School") {
            return totalSchool;
        }
        else if (type == "FamilyType") {
            return totalFamilyType;
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function removeArray(type, rIndex) {
        if (type == "BusGroupCluster") {
            BusGroupClusterarray.splice(rIndex - 1, 1);
        }
        else if (type == "Style") {
            Stylearray.splice(rIndex - 1, 1);
        }
        else if (type == "Salutation") {
            Salutationarray.splice(rIndex - 1, 1);
        }
        else if (type == "Parish") {
            Parisharray.splice(rIndex - 1, 1);
        }
        else if (type == "Occupation") {
            Occupationarray.splice(rIndex - 1, 1);
        }
        else if (type == "MaritalStatus") {
            MaritalStatusarray.splice(rIndex - 1, 1);
        }
        else if (type == "Language") {
            Languagearray.splice(rIndex - 1, 1);
        }
        else if (type == "Education") {
            Educationarray.splice(rIndex - 1, 1);
        }
        else if (type == "Country") {
            Countryarray.splice(rIndex - 1, 1);
        }
        else if (type == "Dialect") {
            Dialectarray.splice(rIndex - 1, 1);
        }
        else if (type == "Congregation") {
            Congregationarray.splice(rIndex - 1, 1);
        }
        else if (type == "ChurchArea") {
            ChurchAreaarray.splice(rIndex - 1, 1);
        }
        else if (type == "FileType") {
            FileTypearray.splice(rIndex - 1, 1);
        }
        else if (type == "ClubGroup") {
            ClubGrouparray.splice(rIndex - 1, 1);
        }
        else if (type == "Race") {
            Racearray.splice(rIndex - 1, 1);
        }
        else if (type == "Religion") {
            Religionarray.splice(rIndex - 1, 1);
        }
        else if (type == "School") {
            Schoolarray.splice(rIndex - 1, 1);
        }
        else if (type == "FamilyType") {
            FamilyTypearray.splice(rIndex - 1, 1);
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function getArrayToString(type) {
        if (type == "BusGroupCluster") {
            return BusGroupClusterarray.toString();
        }

        else if (type == "Style") {
            return Stylearray.toString();
        }
        else if (type == "Salutation") {
            return Salutationarray.toString();
        }
        else if (type == "Parish") {
            return Parisharray.toString();
        }
        else if (type == "Occupation") {
            return Occupationarray.toString();
        }
        else if (type == "MaritalStatus") {
            return MaritalStatusarray.toString();
        }
        else if (type == "Language") {
            return Languagearray.toString();
        }
        else if (type == "Education") {
            return Educationarray.toString();
        }
        else if (type == "Dialect") {
            return Dialectarray.toString();
        }
        else if (type == "Country") {
            return Countryarray.toString();
        }
        else if (type == "Congregation") {
            return Congregationarray.toString();
        }
        else if (type == "ChurchArea") {
            return ChurchAreaarray.toString();
        }
        else if (type == "FileType") {
            return FileTypearray.toString();
        }
        else if (type == "ClubGroup") {
            return ClubGrouparray.toString();
        }
        else if (type == "Race") {
            return Racearray.toString();
        }
        else if (type == "Religion") {
            return Religionarray.toString();
        }
        else if (type == "School") {
            return Schoolarray.toString();
        }
        else if (type == "FamilyType") {
            return FamilyTypearray.toString();
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function getArrayLength(type) {
        if (type == "BusGroupCluster") {
            return BusGroupClusterarray.length;
        }
        else if (type == "Style") {
            return Stylearray.length;
        }
        else if (type == "Salutation") {
            return Salutationarray.length;
        }
        else if (type == "Parish") {
            return Parisharray.length;
        }
        else if (type == "Occupation") {
            return Occupationarray.length;
        }
        else if (type == "MaritalStatus") {
            return MaritalStatusarray.length;
        }
        else if (type == "Language") {
            return Languagearray.length;
        }
        else if (type == "Education") {
            return Educationarray.length;
        }
        else if (type == "Country") {
            return Countryarray.length;
        }
        else if (type == "Dialect") {
            return Dialectarray.length;
        }
        else if (type == "Congregation") {
            return Congregationarray.length;
        }
        else if (type == "ChurchArea") {
            return ChurchAreaarray.length;
        }
        else if (type == "FileType") {
            return FileTypearray.length;
        }
        else if (type == "ClubGroup") {
            return ClubGrouparray.length;
        }
        else if (type == "Race") {
            return Racearray.length;
        }
        else if (type == "Religion") {
            return Religionarray.length;
        }
        else if (type == "School") {
            return Schoolarray.length;
        }
        else if (type == "FamilyType") {
            return FamilyTypearray.length;
        }
    }

    ////////////////////////////////////////////////////////////////////////

    function getArrayIndexOf(type, index) {
        if (type == "BusGroupCluster") {
            return BusGroupClusterarray[index];
        }
        else if (type == "Style") {
            return Stylearray[index];
        }
        else if (type == "Salutation") {
            return Salutationarray[index];
        }
        else if (type == "Parish") {
            return Parisharray[index];
        }
        else if (type == "Occupation") {
            return Occupationarray[index];
        }
        else if (type == "MaritalStatus") {
            return MaritalStatusarray[index];
        }
        else if (type == "Language") {
            return Languagearray[index];
        }
        else if (type == "Education") {
            return Educationarray[index];
        }
        else if (type == "Dialect") {
            return Dialectarray[index];
        }
        else if (type == "Country") {
            return Countryarray[index];
        }
        else if (type == "Congregation") {
            return Congregationarray[index];
        }
        else if (type == "ChurchArea") {
            return ChurchAreaarray[index];
        }
        else if (type == "FileType") {
            return FileTypearray[index];
        }
        else if (type == "ClubGroup") {
            return ClubGrouparray[index];
        }
        else if (type == "Race") {
            return Racearray[index];
        }
        else if (type == "Religion") {
            return Religionarray[index];
        }
        else if (type == "School") {
            return Schoolarray[index];
        }
        else if (type == "FamilyType") {
            return FamilyTypearray[index];
        }
    }


    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    function parseXML(type, xmlID, tableID, listID, textfieldID, textfieldName) {
        var xml = stringToXML(unescape($("#" + xmlID).val()));
        var typeXML = xml.getElementsByTagName("Type");
        for (x = 0; x < typeXML.length; x++) {
            if (x == 0) {
                $("#" + tableID).find("tr:gt(0)").remove();
                resetVariable(type);
            }
            var id = typeXML[x].getElementsByTagName("ID")[0].childNodes[0].nodeValue;
            var name = typeXML[x].getElementsByTagName("Name")[0].childNodes[0].nodeValue;
            addNewType(type, id, name, listID, tableID, textfieldID, textfieldName);
        }

        var result = xml.getElementsByTagName("Result")[0];
        if (result != null) {
            alert(xml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
        }
    }

    function addNewType(type, IDvalue, Namevalue, listID, tableID, textfieldID, textfieldName) {
        pushValue(type, listID);

        var table = document.getElementById(tableID);
        var row = table.insertRow(table.rows.length);
        var no = getCurrentTotal(type);

        var id = '<input style=" width:40px;" readonly="readonly" id="' + textfieldID + '_' + no.toString() + '" name="' + textfieldID + '_' + no.toString() + '" type="text" maxlength="10" value=""/>';
        var name = '<input style=" width:100%;" id="' + textfieldName + '_' + no.toString() + '" name="' + textfieldName + '_' + no.toString() + '" type="text" maxlength="100" value=""/></div>';

        fillCell(row, 0, '<img onclick="removeSelectedRow(this, \'' + type + '\', \'' + listID + '\');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
        fillCell(row, 1, id);
        fillCell(row, 2, name);

        $("#" + textfieldID + "_" + no.toString()).val(IDvalue);
        $("#" + textfieldName + "_" + no.toString()).val(Namevalue);
    }

    function addType(obj, type, listID, tableID, textfieldID, textfieldName) {
        addNewType(type, 'New', '', listID, tableID, textfieldID, textfieldName);
        var objDiv = obj.parentNode.parentNode.parentNode.parentNode.parentNode;
        objDiv.scrollTop = objDiv.scrollHeight;
    }

    function removeSelectedRow(obj, type, listID) {
        var r = confirm("Are you sure to delete this?")
        if (r == false) {
            return;
        }

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
        removeArray(type, rIndex);
        $('#' + listID).val(getArrayToString(type));
    }

    function checkAndSubmit(type, xmlID, tableID, listID, textfieldID, textfieldName, SuperRootElement, RootElement, RootIDName, RootNameName) {
        var xmlstring = "";
        for (var x = 0; x < getArrayLength(type); x++) {
            if (jQuery.trim($("#" + textfieldName + "_" + getArrayIndexOf(type, x)).val()).length <= 0) {
                alert("#" + (x + 1).toString() + ", Name cannot be blank");
                return;
            }

            xmlstring += "<" + RootElement + "><" + RootIDName + ">" + $("#" + textfieldID + "_" + getArrayIndexOf(type, x)).val() + "</" + RootIDName + "><" + RootNameName + ">" + $("#" + textfieldName + "_" + getArrayIndexOf(type, x)).val() + "</" + RootNameName + "></" + RootElement + ">";
        }

        xmlstring = "<" + SuperRootElement + ">" + xmlstring + "</" + SuperRootElement + ">"

        $.post('/settings.mvc/update' + type,
        { xml: escape(xmlstring) },
        function (data) {
            $("#" + xmlID).val(unescape(data));
            parseXML(type, xmlID, tableID, listID, textfieldID, textfieldName);
        }
    );
    }