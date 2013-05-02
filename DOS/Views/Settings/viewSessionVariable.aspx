<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Session Variable
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">

<div id="maindiv" class="bodycss">
	<img style=" width:85%" id="top" src="/Content/images/top.png" alt="">
	<div style=" width:85%; height:87%; overflow:auto" id="form_container">
	    <table border="1">
        <%
            for (int x = 0; x < Session.Keys.Count; x++)
            {

                string name = Session.Keys[x];
                if (Session[name] != null)
                {
                    %><tr><td style="width:100px"><%=name%></td><td><pre style="font-size:medium"><%:Session[name].ToString()%></pre></td></tr><%
                }
                else
                {
                    %><tr><td style="width:100px"><%=name%></td><td></td></tr><%
                }
            }
            %><tr><td style="width:100px">PhysicalApplicationPath</td><td><%= this.Request.PhysicalApplicationPath %></td></tr><%
         %>
         </table>        
	</div>
	<img style=" width:85%" id="bottom" src="/Content/images/bottom.png" alt="">
	</div>
</asp:Content>