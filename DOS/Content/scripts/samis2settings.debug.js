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

    parseCongregationXML();
    parseCountryXML();
    parseDialectXML();
    parseEducationXML();
    parseLanguageXML();
    parseMaritalStatusXML();
    parseOccupationXML();
    parseParishXML();
    parseSalutationXML();
    parseStyleXML();
    parseConfigXML();
    parseEmailXML();
    parsePostalXML();
});

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
//// Congregation /////////////////
///////////////////////////////////

function parseCongregationXML() {
    var congregationxml = stringToXML(unescape($("#CongregationXML").val()));
    var con = congregationxml.getElementsByTagName("Congregation");
    for (x = 0; x < con.length; x++) {
        if (x == 0) {
            $("#CongregationTable").find("tr:gt(0)").remove();
            totalCongregation = 0;
            Congregationarray = new Array();
        }
        var id = con[x].getElementsByTagName("CongregationID")[0].childNodes[0].nodeValue;
        var name = con[x].getElementsByTagName("CongregationName")[0].childNodes[0].nodeValue;
        addNewCongregation(id, name);
    }

    var result = congregationxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(congregationxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalCongregation = 0;
var Congregationarray = new Array();

function addNewCongregation(id_input, name_input) {
    totalCongregation++;
    Congregationarray.push(totalCongregation.toString());
    $('#Congregationlist').val(Congregationarray.toString());

    var table = document.getElementById("CongregationTable");
    var row = table.insertRow(1);
    var Congregationno = totalCongregation;

    var id = '<input style=" width:40px;" readonly="readonly" id="CongregationID_' + Congregationno.toString() + '" name="CongregationID_' + Congregationno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="CongregationName_' + Congregationno.toString() + '" name="CongregationName_' + Congregationno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedCongregation(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#CongregationID_" + Congregationno.toString()).val(id_input);
    $("#CongregationName_" + Congregationno.toString()).val(name_input);
}

function addCongregation() {
    addNewCongregation('New', '');
}

function removeSelectedCongregation(obj) {
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
    Congregationarray.splice(rIndex - 1, 1);
    $('#Congregationlist').val(Congregationarray.toString());
}

function checkAndSubmitCongregation() {
    var xmlstring = "";
    for (var x = 0; x < Congregationarray.length; x++) {
        if (jQuery.trim($("#CongregationName_" + Congregationarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Congregation Name cannot be blank");
            return;
        }

        xmlstring += "<Congregation><CongregationID>" + $("#CongregationID_" + Congregationarray[x]).val() + "</CongregationID><CongregationName>" + $("#CongregationName_" + Congregationarray[x]).val() + "</CongregationName></Congregation>";
    }

    xmlstring = "<ChurchCongregation>" + xmlstring + "</ChurchCongregation>"

    $.post('/settings.mvc/updateCongregation',
        { xml: escape(xmlstring) },
        function (data) {
            $("#CongregationXML").val(unescape(data));
            parseCongregationXML();
        }
    );
}


///////////////////////////////////
//// Country      /////////////////
///////////////////////////////////

function parseCountryXML() {
    var countryxml = stringToXML(unescape($("#CountryXML").val()));
    var cou = countryxml.getElementsByTagName("Country");
    for (x = 0; x < cou.length; x++) {
        if (x == 0) {
            $("#CountryTable").find("tr:gt(0)").remove();
            totalCountry = 0;
            Countryarray = new Array();
        }
        var id = cou[x].getElementsByTagName("CountryID")[0].childNodes[0].nodeValue;
        var name = cou[x].getElementsByTagName("CountryName")[0].childNodes[0].nodeValue;
        addNewCountry(id, name);
    }

    var result = countryxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(countryxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalCountry = 0;
var Countryarray = new Array();

function addNewCountry(id_input, name_input) {
    totalCountry++;
    Countryarray.push(totalCountry.toString());
    $('#Congregationlist').val(Countryarray.toString());

    var table = document.getElementById("CountryTable");
    var row = table.insertRow(1);
    var Countryno = totalCountry;

    var id = '<input style=" width:40px;" readonly="readonly" id="CountryID_' + Countryno.toString() + '" name="CountryID_' + Countryno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="CountryName_' + Countryno.toString() + '" name="CountryName_' + Countryno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedCountry(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#CountryID_" + Countryno.toString()).val(id_input);
    $("#CountryName_" + Countryno.toString()).val(name_input);
}

function addCountry() {
    addNewCountry('New', '');
}

function removeSelectedCountry(obj) {
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
    Countryarray.splice(rIndex - 1, 1);
    $('#Countrylist').val(Countryarray.toString());
}

function checkAndSubmitCountry() {
    var xmlstring = "";
    for (var x = 0; x < Countryarray.length; x++) {
        if (jQuery.trim($("#CountryName_" + Countryarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Country Name cannot be blank");
            return;
        }

        xmlstring += "<Country><CountryID>" + $("#CountryID_" + Countryarray[x]).val() + "</CountryID><CountryName>" + $("#CountryName_" + Countryarray[x]).val() + "</CountryName></Country>";
    }

    xmlstring = "<ChurchCountry>" + xmlstring + "</ChurchCountry>"

    $.post('/settings.mvc/updateCountry',
        { xml: escape(xmlstring) },
        function (data) {
            $("#CountryXML").val(unescape(data));
            parseCountryXML();
        }
    );
}


///////////////////////////////////
//// Dialect      /////////////////
///////////////////////////////////

function parseDialectXML() {
    var dialectxml = stringToXML(unescape($("#DialectXML").val()));
    var dia = dialectxml.getElementsByTagName("Dialect");
    for (x = 0; x < dia.length; x++) {
        if (x == 0) {
            $("#DialectTable").find("tr:gt(0)").remove();
            totalDialect = 0;
            Dialectarray = new Array();
        }
        var id = dia[x].getElementsByTagName("DialectID")[0].childNodes[0].nodeValue;
        var name = dia[x].getElementsByTagName("DialectName")[0].childNodes[0].nodeValue;
        addNewDialect(id, name);
    }

    var result = dialectxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(dialectxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalDialect = 0;
var Dialectarray = new Array();

function addNewDialect(id_input, name_input) {
    totalDialect++;
    Dialectarray.push(totalDialect.toString());
    $('#Dialectlist').val(Dialectarray.toString());

    var table = document.getElementById("DialectTable");
    var row = table.insertRow(1);
    var Dialectno = totalDialect;

    var id = '<input style=" width:40px;" readonly="readonly" id="DialectID_' + Dialectno.toString() + '" name="DialectID_' + Dialectno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="DialectName_' + Dialectno.toString() + '" name="DialectName_' + Dialectno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedDialect(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#DialectID_" + Dialectno.toString()).val(id_input);
    $("#DialectName_" + Dialectno.toString()).val(name_input);
}

function addDialect() {
    addNewDialect('New', '');
}

function removeSelectedDialect(obj) {
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
    Dialectarray.splice(rIndex - 1, 1);
    $('#Dialectlist').val(Dialectarray.toString());
}

function checkAndSubmitDialect() {
    var xmlstring = "";
    for (var x = 0; x < Dialectarray.length; x++) {
        if (jQuery.trim($("#DialectName_" + Countryarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Dialect Name cannot be blank");
            return;
        }

        xmlstring += "<Dialect><DialectID>" + $("#DialectID_" + Dialectarray[x]).val() + "</DialectID><DialectName>" + $("#DialectName_" + Dialectarray[x]).val() + "</DialectName></Dialect>";
    }

    xmlstring = "<ChurchDialect>" + xmlstring + "</ChurchDialect>"

    $.post('/settings.mvc/updateDialect',
        { xml: escape(xmlstring) },
        function (data) {
            $("#DialectXML").val(unescape(data));
            parseDialectXML();
        }
    );
}


///////////////////////////////////
//// Education    /////////////////
///////////////////////////////////

function parseEducationXML() {
    var educationxml = stringToXML(unescape($("#EducationXML").val()));
    var edu = educationxml.getElementsByTagName("Education");
    for (x = 0; x < edu.length; x++) {
        if (x == 0) {
            $("#EducationTable").find("tr:gt(0)").remove();
            totalEducation = 0;
            Educationarray = new Array();
        }
        var id = edu[x].getElementsByTagName("EducationID")[0].childNodes[0].nodeValue;
        var name = edu[x].getElementsByTagName("EducationName")[0].childNodes[0].nodeValue;
        addNewEducation(id, name);
    }

    var result = educationxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(educationxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalEducation = 0;
var Educationarray = new Array();

function addNewEducation(id_input, name_input) {
    totalEducation++;
    Educationarray.push(totalEducation.toString());
    $('#Educationlist').val(Educationarray.toString());

    var table = document.getElementById("EducationTable");
    var row = table.insertRow(1);
    var Educationno = totalEducation;

    var id = '<input style=" width:40px;" readonly="readonly" id="EducationID_' + Educationno.toString() + '" name="EducationID_' + Educationno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="EducationName_' + Educationno.toString() + '" name="EducationName_' + Educationno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedEducation(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#EducationID_" + Educationno.toString()).val(id_input);
    $("#EducationName_" + Educationno.toString()).val(name_input);
}

function addEducation() {
    addNewEducation('New', '');
}

function removeSelectedEducation(obj) {
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
    Educationarray.splice(rIndex - 1, 1);
    $('#Educationlist').val(Educationarray.toString());
}

function checkAndSubmitEducation() {
    var xmlstring = "";
    for (var x = 0; x < Educationarray.length; x++) {
        if (jQuery.trim($("#EducationName_" + Educationarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Education Name cannot be blank");
            return;
        }

        xmlstring += "<Education><EducationID>" + $("#EducationID_" + Educationarray[x]).val() + "</EducationID><EducationName>" + $("#EducationName_" + Educationarray[x]).val() + "</EducationName></Education>";
    }

    xmlstring = "<ChurchEducation>" + xmlstring + "</ChurchEducation>"

    $.post('/settings.mvc/updateEducation',
        { xml: escape(xmlstring) },
        function (data) {
            $("#EducationXML").val(unescape(data));
            parseEducationXML();
        }
    );
}


///////////////////////////////////
//// Language    //////////////////
///////////////////////////////////

function parseLanguageXML() {
    var languagexml = stringToXML(unescape($("#LanguageXML").val()));
    var lang = languagexml.getElementsByTagName("Language");
    for (x = 0; x < lang.length; x++) {
        if (x == 0) {
            $("#LanguageTable").find("tr:gt(0)").remove();
            totalLanguage = 0;
            Languagearray = new Array();
        }
        var id = lang[x].getElementsByTagName("LanguageID")[0].childNodes[0].nodeValue;
        var name = lang[x].getElementsByTagName("LanguageName")[0].childNodes[0].nodeValue;
        addNewLanguage(id, name);
    }

    var result = languagexml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(languagexml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalLanguage = 0;
var Languagearray = new Array();

function addNewLanguage(id_input, name_input) {
    totalLanguage++;
    Languagearray.push(totalLanguage.toString());
    $('#Languagelist').val(Languagearray.toString());

    var table = document.getElementById("LanguageTable");
    var row = table.insertRow(1);
    var Languageno = totalLanguage;

    var id = '<input style=" width:40px;" readonly="readonly" id="LanguageID_' + Languageno.toString() + '" name="LanguageID_' + Languageno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="LanguageName_' + Languageno.toString() + '" name="LanguageName_' + Languageno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedLanguage(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#LanguageID_" + Languageno.toString()).val(id_input);
    $("#LanguageName_" + Languageno.toString()).val(name_input);
}

function addLanguage() {
    addNewLanguage('New', '');
}

function removeSelectedLanguage(obj) {
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
    Languagearray.splice(rIndex - 1, 1);
    $('#Languagelist').val(Languagearray.toString());
}

function checkAndSubmitLanguage() {
    var xmlstring = "";
    for (var x = 0; x < Languagearray.length; x++) {
        if (jQuery.trim($("#LanguageName_" + Languagearray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Language Name cannot be blank");
            return;
        }

        xmlstring += "<Language><LanguageID>" + $("#LanguageID_" + Languagearray[x]).val() + "</LanguageID><LanguageName>" + $("#LanguageName_" + Languagearray[x]).val() + "</LanguageName></Language>";
    }

    xmlstring = "<ChurchLanguage>" + xmlstring + "</ChurchLanguage>"

    $.post('/settings.mvc/updateLanguage',
        { xml: escape(xmlstring) },
        function (data) {
            $("#LanguageXML").val(unescape(data));
            parseLanguageXML();
        }
    );
}


///////////////////////////////////
//// Marital Status////////////////
///////////////////////////////////

function parseMaritalStatusXML() {
    var maritalstatusxml = stringToXML(unescape($("#MaritalStatusXML").val()));
    var mar = maritalstatusxml.getElementsByTagName("MaritalStatus");
    for (x = 0; x < mar.length; x++) {
        if (x == 0) {
            $("#MaritalStatusTable").find("tr:gt(0)").remove();
            totalMaritalStatus = 0;
            MaritalStatusarray = new Array();
        }
        var id = mar[x].getElementsByTagName("MaritalStatusID")[0].childNodes[0].nodeValue;
        var name = mar[x].getElementsByTagName("MaritalStatusName")[0].childNodes[0].nodeValue;
        addNewMaritalStatus(id, name);
    }

    var result = maritalstatusxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(maritalstatusxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalMaritalStatus = 0;
var MaritalStatusarray = new Array();

function addNewMaritalStatus(id_input, name_input) {
    totalMaritalStatus++;
    MaritalStatusarray.push(totalMaritalStatus.toString());
    $('#MaritalStatuslist').val(MaritalStatusarray.toString());

    var table = document.getElementById("MaritalStatusTable");
    var row = table.insertRow(1);
    var MaritalStatusno = totalMaritalStatus;

    var id = '<input style=" width:40px;" readonly="readonly" id="MaritalStatusID_' + MaritalStatusno.toString() + '" name="MaritalStatusID_' + MaritalStatusno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="MaritalStatusName_' + MaritalStatusno.toString() + '" name="MaritalStatusName_' + MaritalStatusno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedMaritalStatus(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#MaritalStatusID_" + MaritalStatusno.toString()).val(id_input);
    $("#MaritalStatusName_" + MaritalStatusno.toString()).val(name_input);
}

function addMaritalStatus() {
    addNewMaritalStatus('New', '');
}

function removeSelectedMaritalStatus(obj) {
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
    MaritalStatusarray.splice(rIndex - 1, 1);
    $('#MaritalStatuslist').val(Languagearray.toString());
}

function checkAndSubmitMaritalStatus() {
    var xmlstring = "";
    for (var x = 0; x < MaritalStatusarray.length; x++) {
        if (jQuery.trim($("#MaritalStatusName_" + MaritalStatusarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Marital Status Name cannot be blank");
            return;
        }

        xmlstring += "<MaritalStatus><MaritalStatusID>" + $("#MaritalStatusID_" + MaritalStatusarray[x]).val() + "</MaritalStatusID><MaritalStatusName>" + $("#MaritalStatusName_" + MaritalStatusarray[x]).val() + "</MaritalStatusName></MaritalStatus>";
    }

    xmlstring = "<ChurchMaritalStatus>" + xmlstring + "</ChurchMaritalStatus>"

    $.post('/settings.mvc/updateMaritalStatus',
        { xml: escape(xmlstring) },
        function (data) {
            $("#MaritalStatusXML").val(unescape(data));
            parseMaritalStatusXML();
        }
    );
}


///////////////////////////////////
//// Occupation ///////////////////
///////////////////////////////////

function parseOccupationXML() {
    var occupationxml = stringToXML(unescape($("#OccupationXML").val()));
    var occ = occupationxml.getElementsByTagName("Occupation");
    for (x = 0; x < occ.length; x++) {
        if (x == 0) {
            $("#OccupationTable").find("tr:gt(0)").remove();
            totalOccupation = 0;
            Occupationarray = new Array();
        }
        var id = occ[x].getElementsByTagName("OccupationID")[0].childNodes[0].nodeValue;
        var name = occ[x].getElementsByTagName("OccupationName")[0].childNodes[0].nodeValue;
        addNewOccupation(id, name);
    }

    var result = occupationxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(occupationxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalOccupation = 0;
var Occupationarray = new Array();

function addNewOccupation(id_input, name_input) {
    totalOccupation++;
    Occupationarray.push(totalOccupation.toString());
    $('#Occupationlist').val(Occupationarray.toString());

    var table = document.getElementById("OccupationTable");
    var row = table.insertRow(1);
    var Occupationno = totalOccupation;

    var id = '<input style=" width:40px;" readonly="readonly" id="OccupationID_' + Occupationno.toString() + '" name="OccupationID_' + Occupationno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="OccupationName_' + Occupationno.toString() + '" name="OccupationName_' + Occupationno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedOccupation(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#OccupationID_" + Occupationno.toString()).val(id_input);
    $("#OccupationName_" + Occupationno.toString()).val(name_input);
}

function addOccupation() {
    addNewOccupation('New', '');
}

function removeSelectedOccupation(obj) {
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
    Occupationarray.splice(rIndex - 1, 1);
    $('#Occupationlist').val(Occupationarray.toString());
}

function checkAndSubmitOccupation() {
    var xmlstring = "";
    for (var x = 0; x < Occupationarray.length; x++) {
        if (jQuery.trim($("#OccupationName_" + Occupationarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Occupation Name cannot be blank");
            return;
        }

        xmlstring += "<Occupation><OccupationID>" + $("#OccupationID_" + Occupationarray[x]).val() + "</OccupationID><OccupationName>" + $("#OccupationName_" + Occupationarray[x]).val() + "</OccupationName></Occupation>";
    }

    xmlstring = "<ChurchOccupation>" + xmlstring + "</ChurchOccupation>"

    $.post('/settings.mvc/updateOccupation',
        { xml: escape(xmlstring) },
        function (data) {
            $("#OccupationXML").val(unescape(data));
            parseOccupationXML();
        }
    );
}


///////////////////////////////////
//// Parish ///////////////////////
///////////////////////////////////

function parseParishXML() {
    var parishxml = stringToXML(unescape($("#ParishXML").val()));
    var par = parishxml.getElementsByTagName("Parish");
    for (x = 0; x < par.length; x++) {
        if (x == 0) {
            $("#ParishTable").find("tr:gt(0)").remove();
            totalParish = 0;
            Parisharray = new Array();
        }
        var id = par[x].getElementsByTagName("ParishID")[0].childNodes[0].nodeValue;
        var name = par[x].getElementsByTagName("ParishName")[0].childNodes[0].nodeValue;
        addNewParish(id, name);
    }

    var result = parishxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(parishxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalParish = 0;
var Parisharray = new Array();

function addNewParish(id_input, name_input) {
    totalParish++;
    Parisharray.push(totalParish.toString());
    $('#Parishlist').val(Parisharray.toString());

    var table = document.getElementById("ParishTable");
    var row = table.insertRow(1);
    var Parishno = totalParish;

    var id = '<input style=" width:40px;" readonly="readonly" id="ParishID_' + Parishno.toString() + '" name="ParishID_' + Parishno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="ParishName_' + Parishno.toString() + '" name="ParishName_' + Parishno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedParish(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#ParishID_" + Parishno.toString()).val(id_input);
    $("#ParishName_" + Parishno.toString()).val(name_input);
}

function addParish() {
    addNewParish('New', '');
}

function removeSelectedParish(obj) {
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
    Parisharray.splice(rIndex - 1, 1);
    $('#Parishlist').val(Parisharray.toString());
}

function checkAndSubmitParish() {
    var xmlstring = "";
    for (var x = 0; x < Parisharray.length; x++) {
        if (jQuery.trim($("#ParishName_" + Parisharray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Parish Name cannot be blank");
            return;
        }

        xmlstring += "<Parish><ParishID>" + $("#ParishID_" + Parisharray[x]).val() + "</ParishID><ParishName>" + $("#ParishName_" + Parisharray[x]).val() + "</ParishName></Parish>";
    }

    xmlstring = "<ChurchParish>" + xmlstring + "</ChurchParish>"

    $.post('/settings.mvc/updateParish',
        { xml: escape(xmlstring) },
        function (data) {
            $("#ParishXML").val(unescape(data));
            parseParishXML();
        }
    );
}

///////////////////////////////////
//// Salutation ///////////////////
///////////////////////////////////

function parseSalutationXML() {
    var salutationxml = stringToXML(unescape($("#SalutationXML").val()));
    var sal = salutationxml.getElementsByTagName("Salutation");
    for (x = 0; x < sal.length; x++) {
        if (x == 0) {
            $("#SalutationTable").find("tr:gt(0)").remove();
            totalSalutation = 0;
            Salutationarray = new Array();
        }
        var id = sal[x].getElementsByTagName("SalutationID")[0].childNodes[0].nodeValue;
        var name = sal[x].getElementsByTagName("SalutationName")[0].childNodes[0].nodeValue;
        addNewSalutation(id, name);
    }

    var result = salutationxml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(salutationxml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalSalutation = 0;
var Salutationarray = new Array();

function addNewSalutation(id_input, name_input) {
    totalSalutation++;
    Salutationarray.push(totalSalutation.toString());
    $('#Salutationlist').val(Salutationarray.toString());

    var table = document.getElementById("SalutationTable");
    var row = table.insertRow(1);
    var Salutationo = totalSalutation;

    var id = '<input style=" width:40px;" readonly="readonly" id="SalutationID_' + Salutationo.toString() + '" name="SalutationID_' + Salutationo.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="SalutationName_' + Salutationo.toString() + '" name="SalutationName_' + Salutationo.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedSalutation(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#SalutationID_" + Salutationo.toString()).val(id_input);
    $("#SalutationName_" + Salutationo.toString()).val(name_input);
}

function addSalutation() {
    addNewSalutation('New', '');
}

function removeSelectedSalutation(obj) {
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
    Salutationarray.splice(rIndex - 1, 1);
    $('#Salutationlist').val(Salutationarray.toString());
}

function checkAndSubmitSalutation() {
    var xmlstring = "";
    for (var x = 0; x < Salutationarray.length; x++) {
        if (jQuery.trim($("#SalutationName_" + Salutationarray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Salutation Name cannot be blank");
            return;
        }

        xmlstring += "<Salutation><SalutationID>" + $("#SalutationID_" + Salutationarray[x]).val() + "</SalutationID><SalutationName>" + $("#SalutationName_" + Salutationarray[x]).val() + "</SalutationName></Salutation>";
    }

    xmlstring = "<ChurchSalutation>" + xmlstring + "</ChurchSalutation>"

    $.post('/settings.mvc/updateSalutation',
        { xml: escape(xmlstring) },
        function (data) {
            $("#SalutationXML").val(unescape(data));
            parseSalutationXML();
        }
    );
}


///////////////////////////////////
//// Style ////////////////////////
///////////////////////////////////

function parseStyleXML() {
    var stylexml = stringToXML(unescape($("#StyleXML").val()));
    var sty = stylexml.getElementsByTagName("Style");
    for (x = 0; x < sty.length; x++) {
        if (x == 0) {
            $("#StyleTable").find("tr:gt(0)").remove();
            totalStyle = 0;
            Stylearray = new Array();
        }
        var id = sty[x].getElementsByTagName("StyleID")[0].childNodes[0].nodeValue;
        var name = sty[x].getElementsByTagName("StyleName")[0].childNodes[0].nodeValue;
        addNewStyle(id, name);
    }

    var result = stylexml.getElementsByTagName("Result")[0];
    if (result != null) {
        alert(stylexml.getElementsByTagName("Result")[0].childNodes[0].nodeValue);
    }
}

var totalStyle = 0;
var Stylearray = new Array();

function addNewStyle(id_input, name_input) {
    totalStyle++;
    Stylearray.push(totalStyle.toString());
    $('#Salutationlist').val(Stylearray.toString());

    var table = document.getElementById("StyleTable");
    var row = table.insertRow(1);
    var Styleno = totalStyle;

    var id = '<input style=" width:40px;" readonly="readonly" id="StyleID_' + Styleno.toString() + '" name="StyleID_' + Styleno.toString() + '" type="text" maxlength="10" value=""/>';
    var name = '<input style=" width:100%;" id="StyleName_' + Styleno.toString() + '" name="StyleName_' + Styleno.toString() + '" type="text" maxlength="100" value=""/></div>';

    fillCell(row, 0, '<img onclick="removeSelectedStyle(this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
    fillCell(row, 1, id);
    fillCell(row, 2, name);

    $("#StyleID_" + Styleno.toString()).val(id_input);
    $("#StyleName_" + Styleno.toString()).val(name_input);
}

function addStyle() {
    addNewStyle('New', '');
}

function removeSelectedStyle(obj) {
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
    Stylearray.splice(rIndex - 1, 1);
    $('#Stylelist').val(Stylearray.toString());
}

function checkAndSubmitStyle() {
    var xmlstring = "";
    for (var x = 0; x < Stylearray.length; x++) {
        if (jQuery.trim($("#StyleName_" + Stylearray[x]).val()).length <= 0) {
            alert("#" + (x + 1).toString() + ", Style Name cannot be blank");
            return;
        }

        xmlstring += "<Style><StyleID>" + $("#StyleID_" + Stylearray[x]).val() + "</StyleID><StyleName>" + $("#StyleName_" + Stylearray[x]).val() + "</StyleName></Style>";
    }

    xmlstring = "<ChurchStyle>" + xmlstring + "</ChurchStyle>"

    $.post('/settings.mvc/updateStyle',
        { xml: escape(xmlstring) },
        function (data) {
            $("#StyleXML").val(unescape(data));
            parseStyleXML();
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

function addPostal() {
    addNewPostal('New', '', '');
}

function addNewPostal(id_input, name_input, value_input) {
    totalPostal++;
    Postalarray.push(totalPostal.toString());
    $('#Postallist').val(Postalarray.toString());

    var table = document.getElementById("PostalTable");
    var row = table.insertRow(1);
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
    $('#Postallist').val(Stylearray.toString());
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

    ///////////////////////////////////////////////////////////////////////////

    function resetVariable(type) {
        if (type == "BusGroupCluster") {
            totalBusGroupCluster = 0;
            BusGroupClusterarray = new Array();
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
        if (type == "BusGroupCluster") {
            totalBusGroupCluster++;
            BusGroupClusterarray.push(totalBusGroupCluster.toString());
            $('#' + listID).val(totalBusGroupCluster.toString());
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
        var row = table.insertRow(1);
        var no = getCurrentTotal(type);

        var id = '<input style=" width:40px;" readonly="readonly" id="' + textfieldID + '_' + no.toString() + '" name="' + textfieldID + '_' + no.toString() + '" type="text" maxlength="10" value=""/>';
        var name = '<input style=" width:100%;" id="' + textfieldName + '_' + no.toString() + '" name="' + textfieldName + '_' + no.toString() + '" type="text" maxlength="100" value=""/></div>';

        fillCell(row, 0, '<img onclick="removeSelectedRow(this, \'' + type + '\', \'' + listID + '\');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/>');
        fillCell(row, 1, id);
        fillCell(row, 2, name);

        $("#" + textfieldID + "_" + no.toString()).val(IDvalue);
        $("#" + textfieldName + "_" + no.toString()).val(Namevalue);
    }

    function addType(type, listID, tableID, textfieldID, textfieldName) {
        addNewType(type, 'New', '', listID, tableID, textfieldID, textfieldName);
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