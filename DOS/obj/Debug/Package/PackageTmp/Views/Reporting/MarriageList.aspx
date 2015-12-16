<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getMembersReportingResult> res = (IEnumerable<usp_getMembersReportingResult>)ViewData["reportinglist"];
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
        parent.document.getElementById("displayloading").style.display = "none";
    });

    function loadMember(nric) {
        parent.loadMember(nric);
    }

   function reloadCase(type) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "type", type);
        submitForm.action = "/Reporting.mvc/marriagelist";
        submitForm.Method = "POST";
        submitForm.submit();
    }

</script>

    <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%= res.Count()%></p>
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
				<th width=2% nowrap="nowrap">NRIC</th>
				<th width=8% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Date of Birth</th>
				<th width=2% nowrap="nowrap">Gender</th>
				<th width=5% nowrap="nowrap">Congregation</th>
				<th width=3% nowrap="nowrap">Marital Status</th>
				<th width=6% nowrap="nowrap">Email</th>
				<th width=3% nowrap="nowrap">Contact No:</th>
				<th width=3% nowrap="nowrap">Marital Status</th>
                <th width=2% nowrap="nowrap">Marriage Duration</th>
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
                                
				                <td><a href="#" onclick="parent.loadMember('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td>
				                <td><%= res.ElementAt(x).EnglishName%></td>
				                <td><%= res.ElementAt(x).DOB.ToString("dd/MM/yyyy")%></td>
				                <td><%= res.ElementAt(x).Gender%></td>
				                <td><%= res.ElementAt(x).CongregationName%></td>
				                <td><%= res.ElementAt(x).MaritalStatus%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).HomeTel%>,<br \><%= res.ElementAt(x).MobileTel%></td>
				                <td><%= res.ElementAt(x).MaritalStatus%></td>
                                <td><%= res.ElementAt(x).MarriageDurationYears%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        