$(document).ready(function () {
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
    changeModuleFunctionRoleAuto($("#" + getModuleFunctionRoles()).val());
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