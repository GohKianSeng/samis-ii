<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Add Ministry
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/addmodifyministry.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/addmodifyministry.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    string getSubmitURL()
    {
        if (((string)ViewData["type"]) == "update")
        {
            return "/parish.mvc/updateAMinistry";
        }
        return "/parish.mvc/addnewMinistry";
    }

    string getMinistryName()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getMinistryInfoResult res = (usp_getMinistryInfoResult)ViewData["ministryinformation"];
            return res.MinistryName;
        }
        return "";
    }

    string getMinistryDescription()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getMinistryInfoResult res = (usp_getMinistryInfoResult)ViewData["ministryinformation"];
            return res.MinistryDescription;
        }
        return "";
    }
    string getMinistryInchargename()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getMinistryInfoResult res = (usp_getMinistryInfoResult)ViewData["ministryinformation"];
            return res.Name;
        }
        return "";
    }

    string getMinistryInchargeNRIC()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getMinistryInfoResult res = (usp_getMinistryInfoResult)ViewData["ministryinformation"];
            return res.MinistryInCharge;
        }
        return "";
    }

    string getMinistryID()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getMinistryInfoResult res = (usp_getMinistryInfoResult)ViewData["ministryinformation"];
            return res.MinistryID;
        }
        return "";
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
    function getFormID() {
        return "<%=form.ClientID %>";
    }
    
    function getSubmitURL() {
        return "<%= Microsoft.JScript.GlobalObject.escape(getSubmitURL())%>"
    }

    function getSystemMode(){
        <%if(Page.User.Identity.IsAuthenticated){ %>
            return "FULL";
        <%}else{ %>
            return "<%=((string)Session["SystemMode"]).ToUpper() %>";
        <%} %>
    }
</script>


        <span style="color:red;"><%= (string) ViewData["errormsg"]%></span>
		<form id="form" runat="server" method="post" action="">
        <input type="hidden" id="ministryid" name="ministryid" value="<%= getMinistryID()%>" />
        
        <table class="dottedview">
            <tr>
                <td>
                    Ministry Name<br />
                    <input id="ministryname" name="ministryname" class="element text medium" type="text" <%=getTextfieldLength("tb_ministry","MinistryName")%> value="<%= getMinistryName()%>"/> 
                </td>
                <td colspan="1">
                    Ministry Description<br />
                    <textarea id="ministrydescription" name="ministrydescription" cols="50" <%=getTextfieldLength("tb_ministry","MinistryDescription")%> rows="5"><%= getMinistryDescription()%></textarea>
                </td>
                
            </tr>
            <tr>
                <td colspan="2">
                    In Charge<br />
                    <input type="hidden" id="incharge" name="incharge" value="<%= getMinistryInchargeNRIC()%>" />
                    <input style=" width:200px" id="inchargeinput" type="text" onkeyup="searchSuggest(1000, 'inchargeinput', 'search_suggest_incharge', 'incharge');" AUTOCOMPLETE="off" value="<%= getMinistryInchargename()%>"/> 
                    <div id="search_suggest_incharge" style="border:1px solid black; position:absolute; z-index:99999; display:none; height:200px; overflow:auto; width:370px"></div>
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
        </form>	
</asp:Content>