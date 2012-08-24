<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Staff Related
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/parish_staff.debug.js"></script>
    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/parish_staff.min.js"></script>
<%}%>


<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>

<!-- multi Select script   -->
<link rel="stylesheet" type="text/css" href="/Content/css/jquery.multiselect.css" />
<link rel="stylesheet" type="text/css" href="/Content/css/jquery.multiselect.filter.css" />
<link rel="stylesheet" type="text/css" href="/Content/css/jquery-ui.css" />    
<script type="text/javascript" src="/Content/scripts/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.multiselect.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.multiselect.filter.min.js"></script>
<!-- multi Select script   -->

<!-- uploadify scripts   -->
<script type="text/javascript" src="/Content/scripts/swfobject.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.uploadify.v2.1.4.min.js"></script>
<!-- uploadify scripts   -->

<script language="C#" runat="server">
    
      

</script>

<script type="text/javascript">
    

</script>

<form id="registration_form" runat="server">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">List of Staff</a></li>
            <li><a href="#tab2">Add New Staff</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
		                    <iframe id="StafflistIframe" frameborder="0" src="/parish.mvc/listallStaff" style="width: 100%; height: 450px;">
                            <p>Your browser does not support iframes.</p></iframe>
                        </td>
                        
                    </tr>
                    </table>
            </div>
            <div id="tab2" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
		                    <iframe id="Iframe1" frameborder="0" src="/account.mvc/adduser" style="width: 100%; height: 450px;">
                            <p>Your browser does not support iframes.</p></iframe>
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