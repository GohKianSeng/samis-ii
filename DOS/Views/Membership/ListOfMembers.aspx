<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_searchMembersForUpdateResult> res = (IEnumerable<usp_searchMembersForUpdateResult>)ViewData["listofmembers"];
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

        <% if(res != null){%>
            if ("100" == "<%= res.Count() %>") {
                alert("Only top 100 records are displayed. You may narrow down your search criteria to see fewer records");
            }
        <%}%>
    });

    function loadMember(nric){
        parent.loadMember(nric);
    }

    function reloadCase(NRIC, name) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "NRIC", NRIC);
        createNewFormElement(submitForm, "Name", name);
        submitForm.action = "/Membership.mvc/SearchMemberForUpdate";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function deleteMember(NRIC, name, obj) {
        
        var answer = confirm("Remove Member: " + name + "?")
        if (answer) {
            $.post("/Membership.mvc/deleteMember",
                { NRIC: NRIC, Name: name, Type: "Actual" },
                function (data) {
                    if (jQuery.trim(data) == "1"){
                        alert(name + " member deleted");                    
                        removeSelectedRow(obj);
                    }
                    else
                        alert("Unable to remove " + name);
                }
            );
        }
    }
</script>

    <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%= res.Count()%></p>
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <td class="nosorting" width="1%" nowrap="nowrap"></td>
				<th width=2% nowrap="nowrap">NRIC</th>
				<th width=10% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Date of Birth</th>
				<th width=2% nowrap="nowrap">Gender</th>
				<th width=10% nowrap="nowrap">Nationality</th>
				<th width=3% nowrap="nowrap">Marital Status</th>
				<th width=8% nowrap="nowrap">Email</th>
				<th width=3% nowrap="nowrap">Home Tel:</th>
				<th width=3% nowrap="nowrap">Mobile No:</th>
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
                                <td><img onclick="deleteMember('<%=res.ElementAt(x).NRIC%>', '<%= res.ElementAt(x).Name%>', this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
				                <td><a href="#" onclick="loadMember('<%= res.ElementAt(x).NRIC %>');"><%= res.ElementAt(x).NRIC%></a></td>
				                <td><%= res.ElementAt(x).Name%></td>
				                <td><%= res.ElementAt(x).DOB.ToString("dd/MM/yyyy")%></td>
				                <td><%= res.ElementAt(x).Gender%></td>
				                <td><%= res.ElementAt(x).Nationality%></td>
				                <td><%= res.ElementAt(x).MaritalStatus%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).HomeTel%></td>
				                <td><%= res.ElementAt(x).MobileTel%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        