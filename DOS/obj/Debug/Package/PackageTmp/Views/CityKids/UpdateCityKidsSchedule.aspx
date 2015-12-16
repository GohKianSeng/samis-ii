<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Update Schedule C3
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/cityKidSchedule.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/cityKidSchedule.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    
    
</script>
    
<script type="text/javascript">    
</script>    

<form id="form1" runat="server" accept="post" action="/citykids.mvc/submitUpdateSchedule">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Update Schedule</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 160px">
                            Schedule<br>
                            <input type="text" name="kidschedule" id="kidschedule" value="<%=ViewData["schedule"] %>" style=" width:20%" size="20">
                        </td>                        
                    </tr>
                    <tr>
                        <td colspan="3">
                            <label><span style="color:red;"><%=(string)ViewData["errormsg"]%></span></label>
                        </td>
                    </tr>
                </table>
                <br>
                <button type="submit" >Update</button>                
            </div>
        </div>
        
    </div>
    </form>





</asp:Content>