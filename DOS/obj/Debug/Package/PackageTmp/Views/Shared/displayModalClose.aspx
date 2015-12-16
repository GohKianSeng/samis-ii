<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<html>
<iframe id="<%=(string)ViewData["iframename"] %>" name="<%=(string)ViewData["iframename"] %>" src="<%= (string)ViewData["siteURL"] %>" frameborder="0" width="100%" height="100%">
  <p>Your browser does not support iframes.</p>
</iframe>
<!--input type="button" value="Close" name="B1" onClick="parent.domwindow.hide()" /-->
</html>
