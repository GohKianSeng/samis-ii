<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
   Search By Age
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
    function reloadAgeList() {
        if (jQuery.trim($("#agefrom").val()).length <= 0 || jQuery.trim($("#ageto").val()).length <= 0) {
            return;
        }
        else if (!isNaN(jQuery.trim($("#agefrom").val())) && !isNaN(jQuery.trim($("#ageto").val()))) {
            if ($("#agefrom").val().indexOf(".") > -1 || $("#ageto").val().indexOf(".") > -1) {
                alert("Age cannot contain decimal!");
            }
            else {
                if (parseInt($("#agefrom").val()) <= parseInt($("#ageto").val()))
                    $("#MemberlistIframe").get(0).contentWindow.reloadCase($("#agefrom").val(), $("#ageto").val());
                else
                    alert("From cannot be greater than To!");
            }
        }
        else
            alert("Only numberic character allowed!");      
    }
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Age</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 1%">
                            From<br>
                            <input type="text" id="agefrom" style=" width:40px"/>
                        </td>
                        <td style="width: 1%">
                            To<br>
                            <input type="text" id="ageto" style=" width:40px"/>
                        </td>
                        <td style="width: 98%">
                            <br>
                            <input type="button" onclick="reloadAgeList();" value="Reload"/>
                        </td>
                    </tr>
                </table>
                <br>
                    <iframe id="MemberlistIframe" frameborder="0" src="/Reporting.mvc/agelist" style="width: 100%; height: 450px;">
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