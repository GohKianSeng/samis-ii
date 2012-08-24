<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Update Information
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/adduser.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/adduser.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    void loadstyle(Object Sender, EventArgs e)
    {
        List<usp_getAllStyleResult> res = (List<usp_getAllStyleResult>)ViewData["stylelist"];
        ListItem item = new ListItem("", "0");
        style.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).StyleName, res.ElementAt(x).StyleID.ToString());
            style.Items.Add(item);
            
        }
    }

    string getTextfieldLength(string tablename, string columnname)
    {
        XElement xml = XElement.Parse((string)Session["TextfieldLength"]);
        for (int x = 0; x < xml.Elements("Column").Count(); x++)
        {
            if (xml.Elements("Column").ElementAt(x).Element("TableName").Value.ToUpper() == tablename.ToUpper() && xml.Elements("Column").ElementAt(x).Element("ColumnName").Value.ToUpper() == columnname.ToUpper())
            {
                return "maxlength=\"" + xml.Elements("Column").ElementAt(x).Element("Length").Value + "\"";
            }
        }
        return "maxlength=\"255\"";            
    }
</script>

<script type="text/javascript">
    function getSubmitControllerName() {
        return "<%= (string)ViewData["Type"]%>";
    }

    function getUserInformation(){
        return "<%= System.Uri.EscapeDataString((string)Session["UserInformation"])%>";
    }

    function getStyleID(){
        return "<%= style.ClientID%>";
    }

    function setStyleValue(){
        return "<%= ViewData["Style"]%>";
    }

</script>



		<form runat="server" id="form_314032" class="appnitro"  method="post" action="">
		<div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">User Infomation</a></li>            
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview">
            <tr>
                <td>
                    Style<br />
                    <asp:DropDownList class="element select medium" OnLoad="loadstyle" name="style" ID="style" runat="server">
                    </asp:DropDownList>
                </td>
                <td>
                    Name<br />
                    <input id="name" name="name" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","Name")%> value="<%= (string)ViewData["Name"]%>"/> 
                </td>
                <td>
                    NRIC<br />
                    <input id="nric" name="nric" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","NRIC")%> value="<%= (string)ViewData["NRIC"]%>"/> 
                </td>
            </tr>
            <tr>
                <td>
                    UserID<br />
                    <input id="userid" name="userid" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","UserID")%> value="<%= (string)ViewData["UserID"]%>"/> 
                </td>
                <td>
                    Email<br />
                    <input id="email" name="email" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","Email")%> value="<%= (string)ViewData["Email"]%>"/> 
                </td>
                <td>
                    Department<br />
                    <input id="department" name="department" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","Department")%> value="<%= (string)ViewData["Department"]%>"/> 
                </td>
            </tr>
            <tr>
                <td>
                    Phone<br />
                    <input id="phone" name="phone" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","Phone")%> value="<%= (string)ViewData["Phone"]%>"/> 
                </td>
                <td>
                    Mobile<br />
                    <input id="mobile" name="mobile" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","Mobile")%> value="<%= (string)ViewData["Mobile"]%>"/> 
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <span style="color:red;"><%= (string) ViewData["error"]%></span>
                    <br />
                    <input id="submitFormButton" type="button" value="Submit"/> 
                </td>
            </tr>
        </table>
            </div>
        </div>
        </form>	
</asp:Content>