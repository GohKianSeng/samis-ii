<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
Access Control
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/UserAdmin.debug.js"></script>
<%}
else{%>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/<%= (string)Session["webapplicationname"] %>Content/scripts/UserAdmin.min.js"></script>
<%}%>



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

    function getAvailableModulesListBox(){
        return "<%=AvailableModulesListBox.ClientID %>";
    }

    function getStaffListBox(){
        return "<%=staffList.ClientID %>";
    }

    function getAssignedModulesListBox(){
        return "<%=AssignedModulesListBox.ClientID %>";
    }

    function getAvailableFunctionsListBox(){
        return "<%=AvailableFunctionsListBox.ClientID %>";
    }

    function getAssignedFunctionsListBox(){
        return "<%=AssignedFunctionsListBox.ClientID %>";
    }

    function getModuleFunctionRoles(){
        return "<%=ModuleFunctionRoles.ClientID %>";
    }

    function getUserListBox(){
        return "<%=usersListBox.ClientID %>";
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
</script>



    <!-- ajaxsearch caller & workgroup script   -->
    <link rel="stylesheet" type="text/css" href="/<%= (string)Session["webapplicationname"] %>Content/css/CallerSearch_Listsearchextender.css" />
    <!-- ajaxsearch caller & workgroup script   -->

<input type="hidden" id="name_userID_XML" name="name_userID_XML" value="" />
<input type="hidden" id="TicketNumber" name="TicketNumber" value="" />
<input type="hidden" id="modulesXML" name="modulesXML" value="<%=Microsoft.JScript.GlobalObject.escape((string)ViewData["AllModules"]) %>" />
<input type="hidden" id="functionsXML" name="functionsXML" value="<%=Microsoft.JScript.GlobalObject.escape((string)ViewData["AllFunctions"]) %>" />
<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Add/Update User(s)</a></li>
            <li><a href="#tab2">Add/Remove Roles(s)</a></li>
            <li><a href="#tab3">Add/Remove Modules(s)</a></li>
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
            <div id="tab3" class="tab_content">
                <table id="ITSCTable" cellspacing="0" width="100%" border=0>
                    <tr style="height:1px">
                        <td colspan="5">
                            Role<br>
                            <asp:DropDownList id="ModuleFunctionRoles" onchange="changeModuleFunctionRole(this);" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr style="height:150px">
				        <td style="width:300px;">
					        Available Modules<br>
                            <asp:ListBox id="AvailableModulesListBox" rows="3" runat="server" Width="300px" Height="150px">
                            </asp:ListBox>					        
				        </td>
                        <td style="width:10px">
                            <br><br>
                            <input type=button value="->" onclick="AddModule()">
                            <br>
                            <input type=button value="<-" onclick="RemoveModule()">
                        </td>
                        <td style="width:300px">
                            Assigned Modules<br>
                            <asp:ListBox id="AssignedModulesListBox" rows="3" runat="server" Width="300px" Height="150px">
                            </asp:ListBox>
                        </td>
                        <td rowspan="3" style="width:300px">
                            <label id="modulefunctionresult"></label>
                        </td>
                        <td rowspan="3">
                            List of users (Display Only)<br />
                            <asp:ListBox id="usersListBox" rows="20" runat="server" Width="100%" Height="90%">
                            </asp:ListBox>
                        </td>                         
                    <tr>
                    <tr style="height:150px">
				        <td style="width:300px;">
					        Available Functions<br>
                            <asp:ListBox id="AvailableFunctionsListBox" rows="3" runat="server" Width="300px" Height="150px">
                            </asp:ListBox>					        
				        </td>
                        <td style="width:10px">
                            <br><br>
                            <input type=button value="->" onclick="AddFunction()">
                            <br>
                            <input type=button value="<-" onclick="RemoveFunction()">
                        </td>
                        <td style="width:300px">
                            Assigned Functions<br>
                            <asp:ListBox id="AssignedFunctionsListBox" rows="3" runat="server" Width="300px" Height="150px">
                            </asp:ListBox>
                        </td>                                                
                    <tr>
                    <tr>
                        <td colspan="5">
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