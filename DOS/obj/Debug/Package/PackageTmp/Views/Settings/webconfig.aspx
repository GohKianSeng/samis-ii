<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Web.Config
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">

<div id="maindiv" class="bodycss">
	<img style=" width:85%" id="top" src="/Content/images/top.png" alt="">
	<div style=" width:85%; height:87%; overflow:auto" id="form_container">
	    <pre style=" font-size:medium">
            <%: ViewData["xml"] %>
        </pre>
	</div>
	<img style=" width:85%" id="bottom" src="/Content/images/bottom.png" alt="">
	</div>
</asp:Content>