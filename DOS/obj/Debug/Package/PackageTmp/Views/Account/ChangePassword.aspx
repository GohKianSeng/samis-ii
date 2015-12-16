<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<DOS.Models.RegisterModel>" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Change Password
</asp:Content>

<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.cookie.js"></script>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/changepassword.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/changepassword.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>
<script type="text/javascript" src="/Content/scripts/sha1.min.js"></script>

<div class="bodycss" >	
	<img id="top" src="/Content/images/top.png" alt="">
	<div id="form_container">

		<form id="form_314032" class="appnitro"  method="post" action="/formbuilder/view.php">
					<div class="form_description">
			<h2>Change Password</h2>
			<p></p>
		</div>						
			<ul >
			
					<li id="li_1" >

		<label class="description" for="element_1">Old password </label>
		<div>
			<input id="oldPassword" name="oldPassword" class="element text medium" type="password" maxlength="255" value="<%= (string)ViewData["Name"]%>"/> 
		</div> 
		</li>		<li id="li_6" >
		<label class="description" for="element_6">New password </label>
		<div>
			<input id="newPassword1" name="newPassword1" class="element text medium" type="password" maxlength="255" value="<%= (string)ViewData["NRIC"]%>"/> 
		</div> 
		</li>		<li id="li_2" >

		<label class="description" for="element_2">Type new password again </label>
		<div>
			<input id="newPassword2" name="newPassword2" class="element text medium" type="password" maxlength="255" value="<%= (string)ViewData["Email"]%>"/> 
		</div> 
		</li>		

                <br />
			    <label id="errormsg" class="description" style="color:red;"><%= (string)ViewData["error"]%></label>
                <br />
					<li class="buttons">
			    <input type="hidden" name="form_id" value="314032" />
			    
				<input id="submitFormButton" class="button_text" type="button" name="submit" value="Submit" />
		</li>

			</ul>
		</form>	
		<div id="footer">
			St Andrew's Cathedral
		</div>
	</div>
	<img id="bottom" src="/Content/images/bottom.png" alt="">
</div>
</asp:Content>
