<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Hokkien Service Attendance
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>    
<script language="C#" runat="server">
    
    string getDate()
    {
        if (ViewData["date"] == null)
            return DateTime.Now.ToString("dd/MM/yyyy");
        else
            return (string)ViewData["date"];
    }

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
        $('#date').datepick({ yearRange: 'c-100:c+0', maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
            renderer: $.extend({}, $.datepick.defaultRenderer,
            { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
            })
        });

        $("#nric").focus();
    });

    function getFormID() {
        return "<%= registration_form.ClientID%>"
    }

    function checkNRICandSubmit(e) {
        var unicode = e.keyCode ? e.keyCode : e.charCode
        if (unicode == '13') {
            $("#" + getFormID()).submit();
        }
    }
</script>

<div class="bodycss">
	<img style=" width:650px" id="top" src="/Content/images/top.png" alt="">
	<div style=" width:650px" id="form_container">
	
		<form AUTOCOMPLETE="off" runat="server" name="registration_form" id="registration_form" class="appnitro"  method="post" action="/hws.mvc/updateMemberAttendance">
		<div class="form_description">
			<h3>Hokkien Service Attendance</h3>
		</div>						
			<ul >
                <h2><span style="color:red;"><%= (string)ViewData["errormsg"] %></span></h2><br /><br />			
			    <table width="800" border="0">
                    <tr>
                        <td>
                            <li style="width:110px" id="li_1" >
		                        <label class="description" for="element_1">
                                    Date</label>
		                        <div>
			                        <input readonly="readonly" style=" width:150px" id="date" name="date" class="element text medium" type="text" maxlength="10" value="<%= getDate() %>" size="20"/> 
		                        </div> 
		                    </li>	
                        </td>
                        <td colspan="2" width="400">
                            <li style="width:200px" id="li_2" >
		                        <label class="description" for="element_2">
                                ID</label>
		                        <div>
			                        <input style=" width:150px" id="ID" name="ID" onkeydown="checkNRICandSubmit(event);" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","NRIC")%> value="" size="20"/> 
		                        </div> 
		                    </li>
                        </td>
                    </tr>
                </table>
                <br />
	        </ul>
            <input type="submit" value="Submit" />
		</form>
        <div style="width=100%" id="footer">
			St Andrew's Cathedral
		</div>	
	</div>
	<img style=" width:650px" id="bottom" src="/Content/images/bottom.png" alt="">
	</div>
</asp:Content>