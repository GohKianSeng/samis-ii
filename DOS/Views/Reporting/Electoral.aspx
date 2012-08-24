<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
   Search By Electoral Roll
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script type="text/javascript">
    
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Electoral Roll</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                    <iframe id="MemberlistIframe" frameborder="0" src="/Reporting.mvc/electorallist" style="width: 100%; height: 450px;">
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