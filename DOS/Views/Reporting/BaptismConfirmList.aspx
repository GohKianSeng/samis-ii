<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getMembersReportingResult> res = (IEnumerable<usp_getMembersReportingResult>)ViewData["reportinglist"];
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

    function loadMember(nric) {
        parent.loadMember(nric);
    }

    function reloadCase(type) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "type", type);
        submitForm.action = "/Reporting.mvc/baptisedconfirmedlist";
        submitForm.Method = "POST";
        submitForm.submit();
    }

</script>

    <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%= res.Count()%></p>
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
				<th width=2% nowrap="nowrap">NRIC</th>
				<th width=10% nowrap="nowrap">Name</th>				
				<th width=2% nowrap="nowrap">Gender</th>
				<th width=5% nowrap="nowrap">Congregation</th>
				<th width=3% nowrap="nowrap">Marital Status</th>
				<th width=6% nowrap="nowrap">Email</th>
				<th width=3% nowrap="nowrap">Contact No:</th>
				<th width=3% nowrap="nowrap">Baptism Date</th>
                <th width=3% nowrap="nowrap">Confirm Date</th>
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
                                
				                <td><a href="#" onclick="parent.loadMember('<%= res.ElementAt(x).NRIC %>');"><%= res.ElementAt(x).NRIC%></a></td>
				                <td><%= res.ElementAt(x).EnglishName%></td>				                
				                <td><%= res.ElementAt(x).Gender%></td>
				                <td><%= res.ElementAt(x).CongregationName%></td>
				                <td><%= res.ElementAt(x).MaritalStatus%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).HomeTel%>,<br \><%= res.ElementAt(x).MobileTel%></td>
				                <td><%if (res.ElementAt(x).BaptismDate != null) %><%= ((DateTime)res.ElementAt(x).BaptismDate).ToString("dd/MM/yyyy")%></td>
                                <td><%if (res.ElementAt(x).MemberDate != null) %><%= ((DateTime)res.ElementAt(x).MemberDate).ToString("dd/MM/yyyy")%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        