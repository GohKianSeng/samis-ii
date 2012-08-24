<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Offline Registration
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
    function submitNewOfflineForm() {
        if (jQuery.trim($("#xml").val()).length > 0) {
            var val = escape(unescape($("#xml").val()));
            $("#xmldoc").val(val);
            $("#xml").val("");
            $("#<%=form1.ClientID%>").submit();
        }
             
    }
</script>    

<form id="form1" runat="server" method="post" action="/membership.mvc/submitofflineregistration">
    <input type="hidden" id="xmldoc" name="xmldoc" />
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Offline Membership Registration</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td colspan="3">
                            <label><span style="color:red;"><%=(string)ViewData["errormsg"]%></span></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            Paste the content below<br />
                            <textarea id="xml" cols="100" rows="20"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <input type="button" value="Submit" onclick="submitNewOfflineForm();" />
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