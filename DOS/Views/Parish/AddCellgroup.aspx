<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Add Cellgroup
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/addmodifycellgroup.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/addmodifycellgroup.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>



<script language="C#" runat="server">
    string getSubmitURL()
    {
        if (((string)ViewData["type"]) == "update")
        {
            return "/parish.mvc/updateACellgroup";
        }
        return "/parish.mvc/addnewCellgroup";
    }

    string getCellgroupName()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCellgroupInfoResult res = (usp_getCellgroupInfoResult)ViewData["cellgroupinformation"];
            return res.CellgroupName;
        }
        return "";
    }

    string getCellgroupInchargename()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCellgroupInfoResult res = (usp_getCellgroupInfoResult)ViewData["cellgroupinformation"];
            return res.Name;
        }
        return "";
    }

    string getCellgroupInchargeNRIC()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCellgroupInfoResult res = (usp_getCellgroupInfoResult)ViewData["cellgroupinformation"];
            return res.CellgroupLeader;
        }
        return "";
    }

    string getCellgroupID()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCellgroupInfoResult res = (usp_getCellgroupInfoResult)ViewData["cellgroupinformation"];
            return res.CellgroupID;
        }
        return "";
    }
    
    string getAutoPostalCode(){
        if (((string)Session["AutoPostalCode"]) != "On")
        {
            return "";
        } 
        else{
            return "disabled=\"disabled\"";
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
    function getFormID() {
        return "<%=form.ClientID %>";
    }

    function getSubmitURL() {
        return "<%= Microsoft.JScript.GlobalObject.escape(getSubmitURL())%>"
    }
    function getAutoPostalCode(){
        return "<%=(string)Session["AutoPostalCode"] %>"
    }

    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>"
    }

    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
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
        <input type="hidden" id="cellgroupid" name="cellgroupid" value="<%= getCellgroupID()%>" />
		    <table class="dottedview" border="0">
            <tr>
                <td>
                    Cellgroup Name<br />
                    <input id="cellgroupname" name="cellgroupname" class="element text medium" type="text" <%=getTextfieldLength("tb_cellgroup","CellgroupName")%> value="<%= getCellgroupName()%>"/> 
                </td>
                <td>
                    In Charge<br />
                    <input type="hidden" id="incharge" name="incharge" value="<%= getCellgroupInchargeNRIC()%>" />
                    <input style=" width:200px" id="inchargeinput" type="text" onkeyup="searchSuggest(1000, 'inchargeinput', 'search_suggest_incharge', 'incharge');" AUTOCOMPLETE="off" <%=getTextfieldLength("tb_members","EnglishName")%> value="<%= getCellgroupInchargename()%>"/> 
                    <div id="search_suggest_incharge" style="border:1px solid black; position:absolute; z-index:99999; display:none; height:200px; overflow:auto; width:370px"></div>
                </td>
            </tr>
            <tr>
                <td colspan="9">
                Address
                <li style=" width:280px">
                    <div style=" width:100px" >
			            <input style=" width:100px" id="candidate_postal_code" name="candidate_postal_code" class="element text medium" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["candidate_postal_code"] %>" type="text" size="20" >
			            <label class="makesmall" for="element_5_5">Postal Code</label>
		            </div>
                    <div class="left">
			            <input style=" width:100px"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_cellgroup","BLKHouse")%> value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
		                <label class="makesmall" for="element_5_6">BLK / House</label>
                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>"/>
		            </div>
		            <div class="right">
                        <input style=" width:100px" id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_cellgroup","Unit")%> value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
			            <label class="makesmall" for="element_5_5">Unit #</label>
	                </div>
                    <div>
			            <input style=" width:350px" id="candidate_street_address" name="candidate_street_address" class="element text medium" <%=getTextfieldLength("tb_cellgroup","StreetAddress")%> value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
			            <label class="makesmall" for="element_5_1">Street Address</label>
                        <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["candidate_street_address"] %>" />
		            </div>
                    </li> 
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