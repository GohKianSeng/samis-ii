<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
Load Record
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<!-- datepicker script   -->
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>
<!-- datepicker script   -->
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css" media="all" />

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
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
<script type="text/javascript">
    $(document).ready(function () {
        $('#DOB').datepick({ yearRange: 'c-100:c+0', maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
            renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
        });


    });

    function check() {
        if ($("#NRIC").val().length > 0 && $("#DOB").val().length > 0) {
            $("#form_313370").submit();
        }
        
    }
</script>

</head>
<div id="bodycss" >
	
	<img id="top" src="/Content/images/top.png" alt="" />
	<div id="form_container">
	
		<form id="form_313370" class="appnitro" AUTOCOMPLETE="off"  method="post" action="/Membership.mvc/SearchTempMember">
					<div class="form_description">
			<h2>Search Record</h2>
			<p></p>
		</div>						
			<ul >
			<table width="100%">
                <tr>
                    <td style=" width:40%">
                    </td>
                    <td style=" width:60%">
                        <li id="li_1" >
		                <label class="description" for="element_1">NRIC </label>
		                <div>
			                <input id="NRIC" name="NRIC" class="element text medium" type="text" <%=getTextfieldLength("tb_members_temp","NRIC")%> style=" width:100px" value=""/> 
		                </div> 
		                </li>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <li id="li_2" >
		                <label class="description" for="element_2">Date of Birth </label>
		                <div>
			                <input id="DOB" name="DOB" class="element text medium" type="text" maxlength="10" style=" width:100px" value=""/> 
		                </div> 
		                </li>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td><span style="color:red;"><%= (string)ViewData["message"]%></span>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <li class="buttons">
			    
			                    <label class="description" style="color:red;"><%= (string)ViewData["error"]%></label>
                                <br />
				                <input id="submitFormButton" class="button_text" type="button" onclick="check();" value="Search" />
		                </li>
                    </td>
                </tr>
            </table>							                                    						
			</ul>
		</form>	
		<div id="footer">
			St Andrew's Cathedral
		</div>
	</div>
	<img id="bottom" src="/Content/images/bottom.png" alt="" />
	</div>
</html>
</asp:Content>