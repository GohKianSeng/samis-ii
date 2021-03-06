﻿$(document).ready(function () {
    //Default Action
    $(".tab_content").hide(); //Hide all content

    setActiveTab(getViewTab());

    //On Click Event
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

    setActiveTab(getViewTab());
    //changeModuleFunctionRoleAuto($("#" + getModuleFunctionRoles()).val());
    RoleOptionHTML = $("#" + getModuleFunctionRoles()).html();
    changeModuleFunctionRole($("#" + getModuleFunctionRoles()));
});

function setActiveTab(tabname) {
    if (tabname == "Roles") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(1).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(1).show(); //show the first tab
    }
    else {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }    
    window.focus();
}

function SubmitUserID() {
    var userids = "";
    $('select#' + getselected_name_userid()).find('option').each(function () {
        userids = userids + $(this).val() + ",";
    });
    var roleid = "";
    if (userids.length == 0)
        return;
    roleid = $('#' + getRoleID() + ' > option:selected').val();

    $.post('/settings.mvc/UpdateRolesUserID',
        { userids: userids, roleid: roleid },
            function (data) {
                $("#resultmsg").html("Message From Server:<br>" + data);                
            }
    );
}

function RemoveNameUserID() {


    var value = $('option:selected', $("#" + getselected_name_userid())).val();
    var name = $('option:selected', $("#" + getselected_name_userid())).text();
    if (value.length > 0) {
        $("#" + getStaffListBox()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getselected_name_userid())).remove();
    } 
}

function AddNameUserID() {
    var value = $('option:selected', $("#" + getStaffListBox())).val();
    var name = $('option:selected', $("#" + getStaffListBox())).text();
    if (value.length > 0) {
        $("#" + getselected_name_userid()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getStaffListBox())).remove();
    }    
}

function AddRole() {
    if (jQuery.trim($("#roleName").val()).length > 0) {
        $("#" + getRoleListBoxID()).append('<option value="new">' + $("#roleName").val() + '</option>');
        $("#roleName").val("");
    }
}

function RemoveRole() {
    if ($('option:selected', $("#" + getRoleListBoxID())).val() == "-1") {
        alert("Cannot delete 'Others' role");
    }
    else {
        $('option:selected', $("#" + getRoleListBoxID())).remove();
    }
}

function submitUpdateRoles() {
    var xml = "";
    $('select#' + getRoleListBoxID()).find('option').each(function () {
        xml += "<Role><RoleID>" + $(this).val() + "</RoleID><RoleName>" + $(this).text() + "</RoleName></Role>"
    });
    xml = escape("<AllRoles>" + xml + "</AllRoles>");

    var submitForm = getNewSubmitForm();
    createNewFormElement(submitForm, "xml", xml);
    submitForm.action = "/settings.mvc/AddRemoveRoles";
    submitForm.Method = "POST";
    submitForm.submit();
}

function changeModuleFunctionRole(obj){
    $.post('/settings.mvc/getAssignedModuleFunction',
        { roleid: $(obj).val() },
            function (data) {
                parseAssignedModulesFunctions(data);
                $.post('/settings.mvc/getUserInRole',
                    { roleid: $(obj).val() },
                        function (users) {
                            parseAllUsersInRoles(users);
                        }
                );
            }
    );
}

function changeModuleFunctionRoleAuto(obj) {
    $.post('/settings.mvc/getAssignedModuleFunction',
        { roleid: obj },
            function (data) {
                parseAssignedModulesFunctions(data);
                $.post('/' + getwebapplicationname() + 'settings.mvc/getUserInRole',
                    { roleid: obj },
                        function (users) {
                            parseAllUsersInRoles(users);
                        }
                );
            }
    );    
}

function parseAllUsersInRoles(data) {
    $("#" + getUserListBox()).html("");
    if (jQuery.trim(data).length == 0)
        return;
    var users = stringToXML(data);
    for (var x = 0; x < users.getElementsByTagName("Name").length; x++) {
        $("#" + getUserListBox()).append('<option value="' + users.getElementsByTagName("Name")[x].childNodes[0].nodeValue + '">' + users.getElementsByTagName("Name")[x].childNodes[0].nodeValue + '</option>');
    }
}

function parseAssignedModulesFunctions(data) {
    var assigned = stringToXML(data);
    var allmodules = stringToXML(unescape($("#modulesXML").val()));
    var allfunction = stringToXML(unescape($("#functionsXML").val()));
    $('#' + getAssignedModulesListBox())[0].options.length = 0;
    $('#' + getAvailableModulesListBox())[0].options.length = 0;
    $('#' + getAssignedFunctionsListBox())[0].options.length = 0;
    $('#' + getAvailableFunctionsListBox())[0].options.length = 0;
    $('#' + getUserListBox())[0].options.length = 0;

    for (var x = 0; x < allmodules.getElementsByTagName("Module").length; x++) {
        var currentModuleID = allmodules.getElementsByTagName("Module")[x].getElementsByTagName("AppModFuncID")[0].childNodes[0].nodeValue;
        var currentModuleName = allmodules.getElementsByTagName("Module")[x].getElementsByTagName("AppModFuncName")[0].childNodes[0].nodeValue;
        var isAssigned = false;

        for (var y = 0; y < assigned.getElementsByTagName("AllModules")[0].getElementsByTagName("Module").length; y++) {
            var assignedModuleID = assigned.getElementsByTagName("AllModules")[0].getElementsByTagName("Module")[y].getElementsByTagName("AppModFuncID")[0].childNodes[0].nodeValue;
            if (assignedModuleID == currentModuleID)
                isAssigned = true;
        }
        if (isAssigned) {
            $("#" + getAssignedModulesListBox()).append('<option value="' + currentModuleID + '">' + currentModuleName + '</option>');
        }
        else {
            $("#" + getAvailableModulesListBox()).append('<option value="' + currentModuleID + '">' + currentModuleName + '</option>');
        }
    }

    for (var x = 0; x < allfunction.getElementsByTagName("Function").length; x++) {
        var currentFunctionID = allfunction.getElementsByTagName("Function")[x].getElementsByTagName("functionID")[0].childNodes[0].nodeValue;
        var currentFunctionName = allfunction.getElementsByTagName("Function")[x].getElementsByTagName("FunctionName")[0].childNodes[0].nodeValue;
        var isAssigned = false;

        for (var y = 0; y < assigned.getElementsByTagName("AllFunctions")[0].getElementsByTagName("Function").length; y++) {
            var assignedFunctionID = assigned.getElementsByTagName("AllFunctions")[0].getElementsByTagName("Function")[y].getElementsByTagName("functionID")[0].childNodes[0].nodeValue;
            if (assignedFunctionID == currentFunctionID)
                isAssigned = true;
        }
        if (isAssigned) {
            $("#" + getAssignedFunctionsListBox()).append('<option value="' + currentFunctionID + '">' + currentFunctionName + '</option>');
        }
        else {
            $("#" + getAvailableFunctionsListBox()).append('<option value="' + currentFunctionID + '">' + currentFunctionName + '</option>');
        }
    }
}

function AddModule() {
    var value = $('option:selected', $("#" + getAvailableModulesListBox())).val();
    var name = $('option:selected', $("#" + getAvailableModulesListBox())).text();
    if (value.length > 0) {
        $("#" + getAssignedModulesListBox()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getAvailableModulesListBox())).remove();
    }
}

function RemoveModule() {
    var value = $('option:selected', $("#" + getAssignedModulesListBox())).val();
    var name = $('option:selected', $("#" + getAssignedModulesListBox())).text();
    if (value.length > 0) {
        $("#" + getAvailableModulesListBox()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getAssignedModulesListBox())).remove();
    }
}

function AddFunction() {
    var value = $('option:selected', $("#" + getAvailableFunctionsListBox())).val();
    var name = $('option:selected', $("#" + getAvailableFunctionsListBox())).text();
    if (value.length > 0) {
        $("#" + getAssignedFunctionsListBox()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getAvailableFunctionsListBox())).remove();
    }
}

function RemoveFunction() {
    var value = $('option:selected', $("#" + getAssignedFunctionsListBox())).val();
    var name = $('option:selected', $("#" + getAssignedFunctionsListBox())).text();
    if (value.length > 0) {
        $("#" + getAvailableFunctionsListBox()).append('<option value="' + value + '">' + name + '</option>');
        $('option:selected', $("#" + getAssignedFunctionsListBox())).remove();
    }
}

function ResetUpdateModulesFunctions() {
    changeModuleFunctionRoleAuto($("#" + getModuleFunctionRoles()).val());
}

function submitUpdateModulesFunctions() {
    var xml1 = "";
    $('select#' + getAssignedModulesListBox()).find('option').each(function () {
        xml1 += "<Module><ModuleID>" + $(this).val() + "</ModuleID></Module>"
    });
    xml1 = "<AllModules>" + xml1 + "</AllModules>";

    var xml2 = "";
    $('select#' + getAssignedFunctionsListBox()).find('option').each(function () {
        xml2 += "<Function><FunctionID>" + $(this).val() + "</FunctionID></Function>"
    });
    xml2 = "<AllFunctions>" + xml2 + "</AllFunctions>";

    var xml = escape("<All>" + xml1 + xml2 + "</All>");

    $.post('/settings.mvc/updateAssignedModuleFunction',
        { xml: xml, roleid: $("#" + getModuleFunctionRoles()).val() },
            function (data) {
                $("#modulefunctionresult").text(data);
            }
    );
}























//////////new one
var RoleOptionHTML = "";
var RoleArray = new Array();
var ModuleFunctionArrayXML = new Array();
var RoleIsModified = new Array();
var RoleModuleFunctionOriginal = new Array();
var RoleModuleFunctionModified = new Array();
var RoleMarkDeleted = new Array();
function addModuleFunctionToArray(id, text, xmlString) {
    var RoleInfo = new Array();
    RoleInfo.push(id);
    RoleInfo.push(text);
    RoleArray.push(RoleInfo);
    ModuleFunctionArrayXML.push(xmlString);
    RoleIsModified.push(false);
    RoleMarkDeleted.push(false);
    var Origmfarray = initialiseModuleFunctionArray(xmlString);
    var mfarray = initialiseModuleFunctionArray(xmlString);
    RoleModuleFunctionOriginal.push(Origmfarray);
    RoleModuleFunctionModified.push(mfarray);
    return RoleArrayIndex(id);
}

function initialiseModuleFunctionArray(data) {
    var assigned = stringToXML(data);
    var modulefunctions = new Array();

    for (var y = 0; y < assigned.getElementsByTagName("AllModules")[0].getElementsByTagName("Module").length; y++) {
        var moduleinfo = new Array();
        moduleinfo.push("m_" + assigned.getElementsByTagName("AllModules")[0].getElementsByTagName("Module")[y].getElementsByTagName("AppModFuncID")[0].childNodes[0].nodeValue);
        moduleinfo.push(assigned.getElementsByTagName("AllModules")[0].getElementsByTagName("Module")[y].getElementsByTagName("AppModFuncName")[0].childNodes[0].nodeValue);
        modulefunctions.push(moduleinfo);
    }
    for (var y = 0; y < assigned.getElementsByTagName("AllFunctions")[0].getElementsByTagName("Function").length; y++) {
        var functioninfo = new Array();
        functioninfo.push("f_" + assigned.getElementsByTagName("AllFunctions")[0].getElementsByTagName("Function")[y].getElementsByTagName("functionID")[0].childNodes[0].nodeValue);
        functioninfo.push(assigned.getElementsByTagName("AllFunctions")[0].getElementsByTagName("Function")[y].getElementsByTagName("functionName")[0].childNodes[0].nodeValue);
        modulefunctions.push(functioninfo);
    }

    return modulefunctions;
}

function MFOriginalArray(index, id) {
    for (var x = 0; x < RoleModuleFunctionOriginal[index].length; x++) {
        if (RoleModuleFunctionOriginal[index][x].indexOf(id) != -1) {
            return x;
        }
    }
    return -1;
}

function MFModifiedArray(index, id) {
    for (var x = 0; x < RoleModuleFunctionModified[index].length; x++) {
        if (RoleModuleFunctionModified[index][x].indexOf(id) != -1) {
            return x;
        }
    }
    return -1;
}

function RoleArrayIndex(id) {
    for (var x = 0; x < RoleArray.length; x++) {
        if (RoleArray[x].indexOf(id) != -1) {
            return x;
        }
    }
    return -1;
}

function changeModuleFunctionRole(obj) {
    if ($(obj).val().match(/^new/)) {
        var newindex = RoleArrayIndex($(obj).val());
        if (newindex == -1) {
            var index = addModuleFunctionToArray($(obj).val(), $("#" + $(obj).attr("ID") + " option:selected").text(), "<All><AllModules /><AllModules /><AllFunctions /></All>");
            parseAssignedModulesFunctions(index);
            $("#" + getUserListBox()).html('');
        } else {
            parseAssignedModulesFunctions(newindex);
            $("#" + getUserListBox()).html('');
        }
    }
    else if ($(obj).val().length > 0) {
        if (RoleArrayIndex($(obj).val()) == -1) {
            $.post('/' + getwebapplicationname() + 'settings.mvc/getAssignedModuleFunction',
                { roleid: $(obj).val() },
                    function (data) {
                        var index = addModuleFunctionToArray($(obj).val(), $("#" + $(obj).attr("ID") + " option:selected").text(), data);
                        parseAssignedModulesFunctions(index);
                        $.post('/' + getwebapplicationname() + 'settings.mvc/getUserInRole',
                            { roleid: $(obj).val() },
                                function (users) {
                                    parseAllUsersInRoles(users);
                                }
                        );
                    }
            );
        }
        else {
            var index = RoleArrayIndex($(obj).val());
            parseAssignedModulesFunctions(index);
            $.post('/' + getwebapplicationname() + 'settings.mvc/getUserInRole',
                { roleid: $(obj).val() },
                    function (users) {
                        parseAllUsersInRoles(users);
                    }
            );
        }
    }
}

var once = false;

function parseAssignedModulesFunctions(index) {
    var OriginalAssigned = RoleModuleFunctionOriginal[index];
    var ModifiedAssigned = RoleModuleFunctionModified[index];
    var allmodules = stringToXML(unescape($("#modulesXML").val()));
    var allfunction = stringToXML(unescape($("#functionsXML").val()));

    $('#AvailableModuleFunctionListBox')[0].options.length = 0;

    var htmlstring = "";
    var tooltiphtmlstring = "";
    if (RoleIsModified[index])
        $("#ModuleFunctionMsg").html("Role modified. Yet to save.");
    else
        $("#ModuleFunctionMsg").html("");

    for (var x = 0; x < allmodules.getElementsByTagName("Module").length; x++) {
        var currentModuleID = allmodules.getElementsByTagName("Module")[x].getElementsByTagName("AppModFuncID")[0].childNodes[0].nodeValue;
        var currentModuleName = allmodules.getElementsByTagName("Module")[x].getElementsByTagName("AppModFuncName")[0].childNodes[0].nodeValue;
        var attribute = "";

        if (MFOriginalArray(index, "m_" + currentModuleID) > -1)
            attribute += " originalSelected='1'";
        else
            attribute += " originalSelected='0'";
        if (MFModifiedArray(index, "m_" + currentModuleID) > -1)
            attribute += " selected='selected'";

        htmlstring += '<option ' + attribute + ' id="module_' + currentModuleID.replace(/\./g, '_') + '" optType=\'module\' value="module_' + currentModuleID + '">' + currentModuleName + '</option>';

    }

    for (var x = 0; x < allfunction.getElementsByTagName("Function").length; x++) {
        var currentFunctionID = allfunction.getElementsByTagName("Function")[x].getElementsByTagName("functionID")[0].childNodes[0].nodeValue;
        var currentFunctionName = allfunction.getElementsByTagName("Function")[x].getElementsByTagName("FunctionName")[0].childNodes[0].nodeValue;
        var isAssigned = false;
        var attribute = "";

        if (MFOriginalArray(index, "f_" + currentFunctionID) > -1)
            attribute += " originalSelected='1'";
        else
            attribute += " originalSelected='0'";
        if (MFModifiedArray(index, "f_" + currentFunctionID) > -1)
            attribute += " selected='selected'";

        htmlstring += '<option ' + attribute + ' id="function_' + currentFunctionID.replace(/\./g, '_') + '" optType=\'function\' value="function_' + currentFunctionID + '">' + currentFunctionName + '</option>';

    }

    $("#AvailableModuleFunctionListBox").html(htmlstring);
    if (!once) {
        $('#AvailableModuleFunctionListBox').multiSelect({
            selectableHeader: "<div class='custom-header'>Available Functions</div>",
            selectedHeader: "<div class='custom-header'>Selected Functions</div>",
            afterSelect: function (value, text) {
                var index = RoleArrayIndex($("#" + getModuleFunctionRoles()).val());
                modified = RoleModuleFunctionModified[index];

                var mfinfo = new Array();
                mfinfo.push(value[0] + "_" + value.split('_')[1]);
                mfinfo.push(text);
                modified.push(mfinfo);

                RoleModuleFunctionModified[index] = modified;
                RoleIsModified[index] = true;
            },
            afterDeselect: function (value, text) {
                var index = RoleArrayIndex($("#" + getModuleFunctionRoles()).val());
                modified = RoleModuleFunctionModified[index];
                var mfIndex = MFModifiedArray(index, value[0] + "_" + value.split('_')[1]);
                modified.splice(mfIndex, 1);
                RoleModuleFunctionModified[index] = modified;
                RoleIsModified[index] = true;
            }
        });

        once = true;
    }
    $('#AvailableModuleFunctionListBox').multiSelect('refresh');
}

function setHoverEvent(obj) {
    var optID = $(obj).attr("value");
    optID = optID.split('.').join('_');


    obj.hover(function (e) {
        $("div#pop_" + optID).css('display', 'block').css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);
        document.getElementById('pop_' + optID).style.display = "block";
        document.getElementById('pop_' + optID).style.top = e.pageY + moveDown + 999;
        document.getElementById('pop_' + optID).style.left = e.pageX + moveLeft;
    }, function () {
        //
        $("div#pop_" + optID).css('display', 'none');
        document.getElementById('pop_' + optID).style.display = "none";
    });

    obj.mousemove(function (e) {
        $("div#pop_" + optID).css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);
        document.getElementById('pop_' + optID).style.top = e.pageY + moveDown;
        document.getElementById('pop_' + optID).style.left = e.pageX + moveLeft;

    });
}

var moveLeft = 20;
var moveDown = 10;

function ResetUpdateModulesFunctions() {
    $("#" + getModuleFunctionRoles()).html(RoleOptionHTML);

    RoleArray = new Array();
    ModuleFunctionArrayXML = new Array();
    RoleIsModified = new Array();
    RoleModuleFunctionOriginal = new Array();
    RoleModuleFunctionModified = new Array();
    RoleMarkDeleted = new Array();

    changeModuleFunctionRole($("#" + getModuleFunctionRoles()));
}

function submitUpdateModulesFunctions() {
    var xml = "";
    for (var x = 0; x < RoleIsModified.length; x++) {
        if (RoleIsModified[x]) {
            var modulexml = "";
            var functionxml = "";
            var rolexml = "";
            var roleID = RoleArray[x][0];
            var roleName = RoleArray[x][1];
            var deleteRow = RoleMarkDeleted[x].toString();

            if (!RoleMarkDeleted[x]) {
                for (var y = 0; y < RoleModuleFunctionModified[x].length; y++) {
                    var mf = RoleModuleFunctionModified[x][y][0].split('_')[0];
                    var id = RoleModuleFunctionModified[x][y][0].split('_')[1];
                    var name = RoleModuleFunctionModified[x][y][1];
                    if (mf == "m") {
                        modulexml += "<Module><ModuleID>" + id + "</ModuleID><ModuleName>" + name + "</ModuleName></Module>";
                    }
                    else if (mf == "f") {
                        functionxml += "<Function><FunctionID>" + id + "</FunctionID><FunctionName>" + name + "</FunctionName></Function>";
                    }
                }
            }

            xml += "<Role><RoleID>" + roleID + "</RoleID><RoleName>" + roleName + "</RoleName><RoleDeleted>" + deleteRow + "</RoleDeleted><AllModules>" + modulexml + "</AllModules><AllFunctions>" + functionxml + "</AllFunctions></Role>";
        }
    }
    xml = escape("<All>" + xml + "</All>");

    $.post('/' + getwebapplicationname() + 'admin.mvc/updateAssignedModuleFunction',
        { xml: xml },
            function (data) {
                $("#modulefunctionresult").text(data);
            }
    );

}

function displayContent(id, e) {
    $('#popup_' + id).show();
    $("#view_" + id).hide();
    $("#hideview_" + id).show();
}

function closeContent(id) {
    $('#popup_' + id).hide();
    $("#view_" + id).show();
    $("#hideview_" + id).hide();
}

function addNewRow() {
    var random = Math.random() * 11;
    domwindow = dhtmlmodal.open("ViewPDF", 'ajax', "/settings.mvc/displayNewRole?random=" + random.toString(), 'Create a new role', 'width=300px,height=200px,center=1,resize=1,scrolling=1');
    domwindow.onclose = function () { //Define custom code to run when window is closed
        for (var x = 0; x < window.frames.length; x++) {
            if (window.frames[0].name == "iframe" + random.toString()) {
                $("#" + getModuleFunctionRoles()).append("<option value=\"new" + random.toString() + "\">" + window.frames[x].document.getElementById('rolename').value + "</option>");
            }

        }        
        $("#" + getModuleFunctionRoles()).val("new" + random.toString());
        changeModuleFunctionRole($("#" + getModuleFunctionRoles()));
        var index = RoleArrayIndex($("#" + getModuleFunctionRoles()).val());
        RoleIsModified[index] = true;
        return true;
    }
}
function renameExistingRole() {
    var rolename = $("#" + getModuleFunctionRoles() + " option:selected").text();
    var random = Math.random() * 11;
    domwindow = dhtmlmodal.open("ViewPDF", 'ajax', "/settings.mvc/renameRole?rolename=" + rolename + "&random=" + random.toString(), 'Rename a role', 'width=300px,height=200px,center=1,resize=1,scrolling=1');
    domwindow.onclose = function () { //Define custom code to run when window is closed
        $("#" + getModuleFunctionRoles() + " option:selected").text(window.frames['iframe' + random.toString()].document.getElementById('rolename').value);
        var index = RoleArrayIndex($("#" + getModuleFunctionRoles()).val());
        rolearr = RoleArray[index];
        for (var x = 0; x < window.frames.length; x++) {
            if (window.frames[0].name == "iframe"+random.toString()) {
                rolearr[1] = window.frames[x].document.getElementById('rolename').value;
            }
        }
        
        RoleArray[index] = rolearr;
        RoleIsModified[index] = true;
        return true;
    }
}

function DeleteRow() {
    if ($("#" + getModuleFunctionRoles()).val() == -1) {
        alert("Cannot delete 'Others' role");
        return;
    }
    else if ($("#" + getUserListBox() + " option").length > 0) {
        alert("Error! User exist. Cannot delete.")
        return;
    }
    var index = RoleArrayIndex($("#" + getModuleFunctionRoles()).val());
    RoleIsModified[index] = true;
    RoleMarkDeleted[index] = true;
    $("#" + getModuleFunctionRoles() + " option:selected").remove();
    changeModuleFunctionRole($("#" + getModuleFunctionRoles()));

}

function ResetUpdateModulesFunctions() {
    $("#" + getModuleFunctionRoles()).html(RoleOptionHTML);

    RoleArray = new Array();
    ModuleFunctionArrayXML = new Array();
    RoleIsModified = new Array();
    RoleModuleFunctionOriginal = new Array();
    RoleModuleFunctionModified = new Array();
    RoleMarkDeleted = new Array();

    changeModuleFunctionRole($("#" + getModuleFunctionRoles()));
}

function submitUpdateModulesFunctions() {
    var xml = "";
    for (var x = 0; x < RoleIsModified.length; x++) {
        if (RoleIsModified[x]) {
            var modulexml = "";
            var functionxml = "";
            var rolexml = "";
            var roleID = RoleArray[x][0];
            var roleName = RoleArray[x][1];
            var deleteRow = RoleMarkDeleted[x].toString();

            if (!RoleMarkDeleted[x]) {
                for (var y = 0; y < RoleModuleFunctionModified[x].length; y++) {
                    var mf = RoleModuleFunctionModified[x][y][0].split('_')[0];
                    var id = RoleModuleFunctionModified[x][y][0].split('_')[1];
                    var name = RoleModuleFunctionModified[x][y][1];
                    if (mf == "m") {
                        modulexml += "<Module><ModuleID>" + id + "</ModuleID><ModuleName>" + name + "</ModuleName></Module>";
                    }
                    else if (mf == "f") {
                        functionxml += "<Function><FunctionID>" + id + "</FunctionID><FunctionName>" + name + "</FunctionName></Function>";
                    }
                }
            }

            xml += "<Role><RoleID>" + roleID + "</RoleID><RoleName>" + roleName + "</RoleName><RoleDeleted>" + deleteRow + "</RoleDeleted><AllModules>" + modulexml + "</AllModules><AllFunctions>" + functionxml + "</AllFunctions></Role>";
        }
    }
    xml = escape("<All>" + xml + "</All>");

    $.post('/' + getwebapplicationname() + 'settings.mvc/updateAssignedModuleFunction',
        { xml: xml },
            function (data) {
                $("#modulefunctionresult").text(data);
            }
    );

}