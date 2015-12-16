<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<html>
    <body onload="parent.agreeordisagree='agree';parent.domwindow.hide();">
        <input type="hidden" id="agreementxml" value="<%= (string)ViewData["result"]%>" />
    </body>
</html>