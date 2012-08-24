﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Search & Update Visitor
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script type="text/javascript">
    function searchVisitors() {
        if ($("#visitornric").val().length == 0 && $("#visitorname").val().length == 0) {
            alert("Name or NRIC cannot be blank.\nSearch either by Name or NRIC.");
            return;
        }

        $("#VisitorlistIframe").get(0).contentWindow.reloadCase($("#visitornric").val(), $("#visitorname").val());
    }
</script>    

<script language="C#" runat="server">
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

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Search & Update</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 160px">
                            NRIC<br>
                            <input type="text" name="visitornric" id="visitornric" value="" <%=getTextfieldLength("tb_visitors","NRIC")%> style="width: 150px" size="20">
                        </td>
                        <td style="width: 155px">
                            Name<br>
                            <input type="text" name="visitorname" id="visitorname" value="" <%=getTextfieldLength("tb_visitors","EnglishName")%> style="width: 150px" size="20">
                        </td>
                        <td style="width: 996px">
                            <br>
                            <input type="button" name="button" id="button" onclick="searchVisitors()" value="Search">
                            
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <label><span style="color:red;"><%=(string)ViewData["errormsg"]%></span></label>
                        </td>
                    </tr>
                </table>
                <br>
                <iframe id="VisitorlistIframe" frameborder="0" src="/Membership.mvc/SearchVisitorForUpdate" style="width: 100%; height: 450px;">
                    <p>
                        Your browser does not support iframes.</p></iframe>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>
    </form>





</asp:Content>