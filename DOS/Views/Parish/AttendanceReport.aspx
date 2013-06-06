<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getCourseReportResult> res = (IEnumerable<usp_getCourseReportResult>)ViewData["report"];
    int totalday = (int)ViewData["totalday"];
  %>

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
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of participants <%= res.Count()/totalday%></p>
                
            </td>           
        </tr>
    </table>
    
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <th width=3% nowrap="nowrap">NRIC</th>
				<th width=8% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Gender&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                <th width=3% nowrap="nowrap">Church</th>
                <th width=3% nowrap="nowrap">Congregation</th>
                <th width=3% nowrap="nowrap">Contact</th>
                <th width=3% nowrap="nowrap">Email</th>
                <% 
                    if (res.Count() > 0)
                    {
                        for (int x = 0; x < totalday; x++)
                        {
                        %><th width=5% nowrap="nowrap"><%=((DateTime)res.ElementAt(x).Schedule).ToString("dd/MM/yyyy")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><%
                        }
                    }
                %>
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
                            <% 
                                if (res.Count() > 0)
                                {
                                    for (int x = 0; x < totalday; x++)
                                    {
                                    %><td></td><%
                                    }
                                }
                            %>				            
			            </tr>      
                    <%
                        }
                        else
                        {
                            int total = (res.Count() / totalday)+1;
                            for (int x = 0; x < total-1; x++)
                            {
                                int index = x * totalday;
                        %>      <tr>  
                                <td nowrap="nowrap"><%= res.ElementAt(index).NRIC%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Name%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Gender%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Church%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Congregation%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Contact%></td>
                                <td nowrap="nowrap"><%= res.ElementAt(index).Email%></td>
                                
                        <%
                                for (int z = 0; z < totalday; z++)
                                {
                                    %>
                                        <td><%
                                                if(res.ElementAt(index + z).Attendance == 1){
                                                    %><img src="/Content/images/cancel.png" alt="0"/><%    
                                                }
                                                else{
                                                    %><img src="/Content/images/tick-icon.png" alt="1"/><%    
                                                }
                                             %>
                                        
                                        </td>
                                    <%
                                }
                                %></tr><%
                            
                            }
                        }
            %>
		</tbody>
		</table>
        
</html>












        