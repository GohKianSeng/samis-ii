<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getListofCourseParticipantsResult> res = (IEnumerable<usp_getListofCourseParticipantsResult>)ViewData["listofparticipants"];
  %>

<script language="C#" runat="server">
    
    string partialBlankIC(string nric)
    {
        Regex rgx = new Regex("[A-Za-z0-9._%+-]");
        if (nric.Length == 9)
        {
            return "S" + rgx.Replace(nric.Substring(0, 4), "x") + nric.Substring(6);
        }
        else
        {
            return rgx.Replace(nric, "x");                      
        }
        
    }
</script>

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->
  
<script type="text/javascript">
    
    $(document).ready(function () {
        $("table").tablesorter({ dateFormat: "uk" });
        $(".tablesorter tr:even").addClass("alt");
    });

    function deleteParticipant(courseid, nric, name) {
        var answer = confirm("Delete participant: " + name + "?")
        if (answer) {
            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "courseid", courseid);
            createNewFormElement(submitForm, "nric", nric);
            createNewFormElement(submitForm, "name", name);
            submitForm.action = "/Parish.mvc/removeCourseParticipant";
            submitForm.Method = "POST";
            submitForm.submit();
        }
    }

    function loadCourseParticipant(courseid, nric, name) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "courseid", courseid);
        createNewFormElement(submitForm, "nric", nric);
        createNewFormElement(submitForm, "name", name);
        submitForm.action = "/Parish.mvc/loadCourseParticipant";
        submitForm.Method = "POST";
        submitForm.submit();
        
    }

</script>

    
    <p style="color:red;"><%= (string)ViewData["errormsg"]%></p>
    <table width="100%">
        <tr>
            <td width=50%">
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of participants <%= res.Count()%></p>
                
            </td>           
        </tr>
    </table>
    
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <td class="nosorting" width=1% nowrap="nowrap"></td>
				<th width=3% nowrap="nowrap">NRIC</th>
				<th width=8% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Fee Paid</th>
                <th width=3% nowrap="nowrap">Material Collected</th>
                <th width=3% nowrap="nowrap">Attendance</th>
                <th width=3% nowrap="nowrap">Attendance %</th>
		</thead>
		<tbody>
			    <% 
                if (res == null || res.Count() == 0)
                {
                    %>
                        <tr>
                            <td></td>
                            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>
                            <td></td>
                            <td></td>				            
			            </tr>      
                    <%
                }
                else
                {
                    for (int x = 0; x < res.Count(); x++)
                    {
                        %>
                            <tr>
                                <td><img onclick="deleteParticipant('<%=res.ElementAt(x).courseID%>', '<%= res.ElementAt(x).NRIC%>', '<%= res.ElementAt(x).EnglishName%>');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
                                <td><a href="#" onclick="loadCourseParticipant('<%= res.ElementAt(x).courseID %>', '<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td>
				                <td><%= res.ElementAt(x).EnglishName%></td>
                                <td><%= res.ElementAt(x).feePaid%></td>
                                <td><%= res.ElementAt(x).materialReceived%></td>
                                <td><%= res.ElementAt(x).Attendance%></td>
                                <td><%= res.ElementAt(x).Percentage%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        