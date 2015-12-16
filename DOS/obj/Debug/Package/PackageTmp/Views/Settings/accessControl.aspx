<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Access Control
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript" src="/Content/scripts/jquery-1.7.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

    <!-- multiselect list box scripts   -->
    <script src="/Content/scripts/jquery.multiselectListBox.js" type="text/javascript"></script>
    <link href="/Content/css/multiselectListBox.css" media="screen" rel="stylesheet" type="text/css">
    <!-- multiselect list box scripts   -->

    <!-- modal windows scripts   -->
    <link rel="stylesheet" href="/Content/css/dhtmlwindow.css" type="text/css" />
    <script type="text/javascript" src="/Content/scripts/dhtmlwindow.min.js"></script>
    <link rel="stylesheet" href="/Content/css/modal.css" type="text/css" />
    <script type="text/javascript" src="/Content/scripts/modal.min.js"></script>
    <!-- modal windows scripts   -->

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/UserAdmin.debug.js"></script>
<%}
else{%>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/UserAdmin.min.js"></script>
<%}%>

    <style>
        div.popuptooltip {
            display: none;
            position: absolute;
            width: 280px;
            padding: 10px;
            background: #eeeeee;
            color: #000000;
            border: 1px solid #1a1a1a;
            font-size: 90%;
          }
    </style>

<script type="text/javascript">
    function getselected_name_userid() {
        return "<%= selected_name_userid.ClientID%>";
    }

    function getwebapplicationname() {
        return "<%= (string)Session["webapplicationname"] %>";
    }

    function getRoleID(){
        return "<%= RoleSelectID.ClientID %>";
    }

    function getRoleListBoxID(){
        return "<%= RoleListBox.ClientID %>";
    }

    function getViewTab(){
        return "<%=(string) ViewData["tab"] %>";
    }

    function getStaffListBox(){
        return "<%=staffList.ClientID %>";
    }

    function getModuleFunctionRoles(){
        return "<%=ModuleFunctionRoles.ClientID %>";
    }

    function getUserListBox(){
        return "<%=usersListBox.ClientID %>";
    }
    
    function getHelpIconSrc(){
        return "/Content/images/help-icon.png"
    }
</script>

<script language="C#" runat="server">
    void loadRoles(Object Sender, EventArgs e)
    {
        IEnumerable<usp_listOfRolesResult> res = (IEnumerable<usp_listOfRolesResult>)ViewData["listofroles"];

        for (int x = 0; x < res.Count(); x++)
        {
            RoleSelectID.Items.Add(new ListItem(res.ElementAt(x).RoleName, res.ElementAt(x).RoleID.ToString()));
            RoleListBox.Items.Add(new ListItem(res.ElementAt(x).RoleName, res.ElementAt(x).RoleID.ToString()));
            ModuleFunctionRoles.Items.Add(new ListItem(res.ElementAt(x).RoleName, res.ElementAt(x).RoleID.ToString()));
        }
    }

    void loadStaff(Object Sender, EventArgs e)
    {
        IEnumerable<usp_getAllStaffResult> res = (IEnumerable<usp_getAllStaffResult>)ViewData["listofstaff"];

        for (int x = 0; x < res.Count(); x++)
        {
            staffList.Items.Add(new ListItem(res.ElementAt(x).Name + " - " + res.ElementAt(x).RoleName, res.ElementAt(x).USERID.ToString()));
            
        }
    }

    void loadRolesForModules(Object Sender, EventArgs e)
    {
        IEnumerable<usp_listOfRolesResult> res = (IEnumerable<usp_listOfRolesResult>)ViewData["listofroles"];

        for (int x = 0; x < res.Count(); x++)
        {
            ModuleFunctionRoles.Items.Add(new ListItem(res.ElementAt(x).RoleName, res.ElementAt(x).RoleID.ToString()));
        }
    }
</script>

<input type="hidden" id="name_userID_XML" name="name_userID_XML" value="" />
<input type="hidden" id="TicketNumber" name="TicketNumber" value="" />
<input type="hidden" id="modulesXML" name="modulesXML" value="<%=Microsoft.JScript.GlobalObject.escape((string)ViewData["AllModules"]) %>" />
<input type="hidden" id="functionsXML" name="functionsXML" value="<%=Microsoft.JScript.GlobalObject.escape((string)ViewData["AllFunctions"]) %>" />
<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Add/Update User(s)</a></li>
            <li><a href="#tab2">Add/Remove Roles(s)</a></li>
            <li><a href="#tab5">Function(s) Maintenance</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table id="ITSCTable" cellspacing="0" border=0>
                    <tr style="height:150px">
				        <td style="width:450px;">
					        Available Name / UserID<br>
                            <asp:ListBox id="staffList" OnLoad="loadStaff" rows="10" runat="server" Width="100%" Height="100%" >
                            </asp:ListBox>
				        </td>
                        <td style="width:10px">
                            <br><br>
                            <input type=button value="->" onclick="AddNameUserID()">
                            <br>
                            <input type=button value="<-" onclick="RemoveNameUserID()">
                        </td>
                        <td style="width:450px">
                            List Of Users to be updated<br>
                            <asp:ListBox id="selected_name_userid" rows="10" runat="server" Width="100%" Height="100%" >
                            </asp:ListBox>
                        </td>
                        <td>
                            Assign to Role<br>
                             <asp:DropDownList id="RoleSelectID" runat="server" OnLoad="loadRoles">
                            </asp:DropDownList>                            
                            <br><br>
                            <div style=" height:100%" id="resultmsg" style=" border:1px">
                            
                            </div>
                        </td>
                    <tr>
                    <tr>
                        <td>
                            <br />
					        <input type=button value="Submit" onclick="SubmitUserID()">
				        </td>
                    </tr>
                </table>
            </div>
            <div id="tab2" class="tab_content">
                <table id="ITSCTable" cellspacing="0" border=0>
                    <tr style="height:150px">
				        <td style="width:300px;">
					        Role Name<br>
                            <input type="text" name="roleName" id="roleName" value="" autocomplete="off" style="width:300px" maxlength="50"/>
                            <div style=" height:100%"></div>					        
				        </td>
                        <td style="width:10px">
                            <br><br>
                            <input type=button value="->" onclick="AddRole()">
                            <br>
                            <input type=button value="<-" onclick="RemoveRole()">
                        </td>
                        <td style="width:300px">
                            List Of Roles<br>
                            <asp:ListBox id="RoleListBox" rows="3" runat="server" Width="300px" Height="150px" >
                            </asp:ListBox>
                        </td>
                        <td>
                            <%
                                string result = "";
                                usp_UpdateRolesResult roleresult = (usp_UpdateRolesResult)ViewData["updateRolesResult"];
                                if (roleresult != null)
                                {    
                                    XElement added = XElement.Parse(roleresult.AddedUsers);
                                    XElement remove = XElement.Parse(roleresult.DeletedUsers);
                                    XElement fail = XElement.Parse(roleresult.FailedRole);
                                    if (added.Elements("RoleName").Count() > 0)
                                        result += "Roles added: ";
                                    for (int x = 0; x < added.Elements("RoleName").Count(); x++)
                                    {
                                        result += added.Elements("RoleName").ElementAt(x).Value + "; ";
                                    }

                                    if (remove.Elements("RoleName").Count() > 0)
                                        result += "<br />Roles removed: ";
                                    for (int x = 0; x < remove.Elements("RoleName").Count(); x++)
                                    {
                                        result += remove.Elements("RoleName").ElementAt(x).Value + "; ";
                                    }

                                    if (fail.Elements("RoleName").Count() > 0)
                                        result += "<br /><br />Roles remove fail(in use): ";
                                    for (int x = 0; x < fail.Elements("RoleName").Count(); x++)
                                    {
                                        result += fail.Elements("RoleName").ElementAt(x).Value + "; ";
                                    }
                                }
                            %>

                            <label><%= result%></label>
                        </td>
                    <tr>
                    <tr>
                        <td>
					        <input type=button value="Submit" onclick="submitUpdateRoles();">
				        </td>
                    </tr>
                </table>
            </div>            
            <div id="tab5" class="tab_content">
                <table id="ITSCTable" cellspacing="0">
                    <tr style="height:1px">
                        <td>
                            Role<br>
                            <asp:DropDownList id="ModuleFunctionRoles" OnLoad="loadRolesForModules" onchange="changeModuleFunctionRole(this);" runat="server">
                            </asp:DropDownList>&nbsp;&nbsp;&nbsp;&nbsp;
                            <label id="ModuleFunctionMsg" style=" color:Red" />
                        </td>
                        <td>
                            <img src="/Content/images/add.png" onclick="addNewRow();" style=" cursor:pointer" title="Add a new Role" />
                            <img src="/Content/images/remove.png" onclick="DeleteRow();" style=" cursor:pointer" title="Remove this Role" />
                            <img src="/Content/images/edit-icon.png" onclick="renameExistingRole();" style=" cursor:pointer" title="Rename this role" />
                        </td>
                    </tr>
                    <tr style="height:150px">
                        <td style="width:70%;">
                            <select multiple="multiple" id="AvailableModuleFunctionListBox">                                
                            </select>

                            <div id="AllToolTip">
                                <%
                                    XElement modules = XElement.Parse((string)ViewData["AllModules"]);
                                    XElement functions = XElement.Parse((string)ViewData["AllFunctions"]);
                                    for (int x = 0; x < functions.Elements("Function").Count(); x++)
                                    {

                                        string currentFunctionID = functions.Elements("Function").ElementAt(x).Element("functionID").Value;
                                        string currentFunctionName = functions.Elements("Function").ElementAt(x).Element("FunctionName").Value;
                                        string currentFunctionDescription = functions.Elements("Function").ElementAt(x).Element("Description").Value;
                                        
                                        %><div class="popuptooltip" id="pop_function_<%=currentFunctionID%>">
                                            <h3><%=currentFunctionName%></h3>
                                            <hr />
                                            <%=currentFunctionDescription%>
                                          </div><%
                                    }
                                    for (int x = 0; x < modules.Elements("Module").Count(); x++)
                                    {

                                        string currentModuleID = modules.Elements("Module").ElementAt(x).Element("AppModFuncID").Value.Replace('.','_');
                                        string currentModuleName = modules.Elements("Module").ElementAt(x).Element("AppModFuncName").Value;
                                        string currentModuleDescription = modules.Elements("Module").ElementAt(x).Element("Description").Value;
                                        
                                        %><div class="popuptooltip" id="pop_module_<%=currentModuleID%>">
                                            <h3><%=currentModuleName%></h3>
                                            <hr />
                                            <%=currentModuleDescription%>
                                          </div><%
                                    }
                                    
                                %>
                            </div>
                        </td>
                        <td style="width:30%">
                            List of users (Display Only)<br />
                            <asp:ListBox id="usersListBox" rows="20" runat="server" Width="100%" Height="70%">
                            </asp:ListBox>
                            <br />
                            <div style=" height:30%">
                                <label id="modulefunctionresult"></label>                            
                            </div>
                        </td>  
                    </tr>                    
                    <tr>
                        <td colspan="2">
					        <input type=button value="Submit" onclick="submitUpdateModulesFunctions();"><input type=button value="Reset" onclick="ResetUpdateModulesFunctions();">
				        </td>                        
                    </tr>
                </table>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>
    
</form>

</asp:Content>