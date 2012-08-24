<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Search By Baptism / Confirmation
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">        
</script>

<script type="text/javascript">
    function reloadList() {
        $("#MemberlistIframe").get(0).contentWindow.reloadCase($("#bapconid").val());
    }
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Baptised/Confirmed</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 160px">
                            Baptised/Confirmed<br>
                            <select onchange="reloadList()" id="bapconid">
                                <option value=""></option>
	                            <option value="NotBap">Not Baptised</option>
                                <option value="BapNotCon">Baptised, Not Confirm</option>
                                <option value="BapAndCon">Baptised & Confirmed</option>                                
                            </select>
                        </td>
                    </tr>
                </table>
                <br>
                <iframe id="MemberlistIframe" frameborder="0" src="/Reporting.mvc/baptisedconfirmedlist" style="width: 100%; height: 450px;">
                    <p>Your browser does not support iframes.</p></iframe>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>
    </form>





</asp:Content>