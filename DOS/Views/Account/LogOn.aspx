<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css" media="all">
<script type="text/javascript" src="/Content/scripts/sha1.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.cookie.js"></script>

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/logon.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/logon.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    string getTextfieldLength(string tablename, string columnname)
    {
        XElement xml = XElement.Parse((string)Session["TextfieldLength"]);
        for (int x = 0; x < xml.Elements("Column").Count(); x++)
        {
            if (xml.Elements("Column").ElementAt(x).Element("TableName").Value.ToUpper() == tablename.ToUpper() && xml.Elements("Column").ElementAt(x).Element("ColumnName").Value.ToUpper() == columnname.ToUpper())
            {
                return "maxlength=\"" + xml.Elements("Column").ElementAt(x).Element("Length").Value + "\"";
            }
        }
        return "maxlength=\"255\"";            
    }
</script>

</head>
<div id="bodycss" >
	
	<img id="top" src="/Content/images/top.png" alt="" />
	<div id="form_container">
	
		<form id="form_313370" class="appnitro"  method="GET" action="">
        <input type="hidden" id="ReturnURL" name="" value="<%=(string)ViewData["ReturnUrl"] %>" />
					<div class="form_description">
			<h2>Login</h2>
			<p></p>
		</div>						
			<ul >
			
					<li id="li_1" >
		<label class="description" for="element_1">UserID </label>
		<div>
			<input id="UserName" name="UserName" class="element text medium" type="text" <%=getTextfieldLength("tb_Users","UserID")%> value=""/> 
		</div> 
		</li>		<li id="li_2" >
		<label class="description" for="element_2">Password </label>
		<div>
			<input id="Password" name="Password" class="element text medium" type="password" maxlength="255" value=""/> 
		</div> 
		</li>
        <li id="li1" >
		<span>
			<input id="RememberMe" name="RememberMe" class="element checkbox" type="checkbox" value="" />
            <label class="choice" for="element_2_1">Remember Me?</label>

		</span> 
		</li>	
					<li class="buttons">
			    
			    <label class="description" style="color:red;"><%= (string)ViewData["error"]%></label>
                <br />
				<input id="submitFormButton" class="button_text" type="button" name="submit" value="Submit" />
		</li>
			</ul>
		</form>	
		<div id="footer">
			St Andrew's Cathedral
		</div>
	</div>
	<img id="bottom" src="/Content/images/bottom.png" alt="" />
	</div>
</html>
