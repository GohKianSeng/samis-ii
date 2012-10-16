<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getMembersReportingManualSearchResult> res = (IEnumerable<usp_getMembersReportingManualSearchResult>)ViewData["reportinglist"];
    IEnumerable<usp_getMembersTempReportingManualSearchResult> tres = (IEnumerable<usp_getMembersTempReportingManualSearchResult>)ViewData["reportinglisttemp"];
    
    int totalfound = 0;
    if (res!=null)
        totalfound += res.Count();
    if(tres!=null)
        totalfound += tres.Count(); 
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
        parent.document.getElementById("displayloading").style.display = "none";
    });

    function loadMember(nric) {
        parent.loadMember(nric);
    }

    function reloadCase(gender, marriage, nationality, dialect, education, occupation, congregation, language, cellgroup, ministry, batismchurch, confirmchurch, previouschurch, baptismby, confirmby, residentalarea) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "gender", gender);
        createNewFormElement(submitForm, "marriage", marriage);
        createNewFormElement(submitForm, "nationality", nationality);
        createNewFormElement(submitForm, "dialect", dialect);
        createNewFormElement(submitForm, "education", education);
        createNewFormElement(submitForm, "occupation", occupation);
        createNewFormElement(submitForm, "congregation", congregation);
        createNewFormElement(submitForm, "language", language);
        createNewFormElement(submitForm, "cellgroup", cellgroup);
        createNewFormElement(submitForm, "ministry", ministry);
        createNewFormElement(submitForm, "batismchurch", batismchurch);
        createNewFormElement(submitForm, "confirmchurch", confirmchurch);
        createNewFormElement(submitForm, "previouschurch", previouschurch);
        createNewFormElement(submitForm, "baptismby", baptismby);
        createNewFormElement(submitForm, "confirmby", confirmby);
        createNewFormElement(submitForm, "residentalarea", residentalarea);
        submitForm.action = "/Reporting.mvc/manualSearchlist";
        submitForm.Method = "POST";
        submitForm.submit();
    }

</script>

    <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%=totalfound %></p>
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
                if (totalfound == 0)
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
                    for (int x = 0; x < tres.Count(); x++)
                    {
                        %>
                            <tr>
                                
				                <td><a href="#" onclick="parent.loadTempMember('<%= tres.ElementAt(x).NRIC %>');"><%= tres.ElementAt(x).NRIC%></a></td>
				                <td nowrap="nowrap"><div style=" width:95%;float:left"> <%= tres.ElementAt(x).EnglishName%></div><div style=" width:5%;float:right"><img border="0" src="/Content/images/T-icon.png" title="Awaiting Approval" /></div></td>				                
				                <td><%= tres.ElementAt(x).Gender%></td>
				                <td><%= tres.ElementAt(x).CongregationName%></td>
				                <td><%= tres.ElementAt(x).MaritalStatus%></td>
				                <td><%= tres.ElementAt(x).Email%></td>
				                <td><%= tres.ElementAt(x).HomeTel%>,<br \><%= tres.ElementAt(x).MobileTel%></td>
				                <td><%if (tres.ElementAt(x).BaptismDate != null) %><%= ((DateTime)tres.ElementAt(x).BaptismDate).ToString("dd/MM/yyyy")%></td>
                                <td><%if (tres.ElementAt(x).MemberDate != null) %><%= ((DateTime)tres.ElementAt(x).MemberDate).ToString("dd/MM/yyyy")%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        