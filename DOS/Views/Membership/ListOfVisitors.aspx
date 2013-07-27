<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_searchVisitorsForUpdateResult> res = (IEnumerable<usp_searchVisitorsForUpdateResult>)ViewData["listofvisitor"];
  %>

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

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

    function loadVisitor(nric){
        parent.loadVisitor(nric);
    }

    function reloadCase(NRIC, name) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "NRIC", NRIC);
        createNewFormElement(submitForm, "Name", name);
        submitForm.action = "/Membership.mvc/SearchVisitorForUpdate";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function deleteVisitor(NRIC, name, obj) {
        
        var answer = confirm("Remove Participant: " + name + "?")
        if (answer) {
            $.post("/Membership.mvc/deleteMember",
                { NRIC: NRIC, Name: name, Type: "Visitor" },
                function (data) {
                    if (jQuery.trim(data) == "1"){
                        alert(name + " participant deleted");                    
                        removeSelectedRow(obj);
                    }
                    else
                        alert("Unable to remove " + name);
                }
            );
        }
    }
</script>

    <p style="font-size:12px; text-align:left; margin-right:1%;"># of Visitor found <%= res.Count()%></p>
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <td class="nosorting" width="1%" nowrap="nowrap"></td>
				<th width=2% nowrap="nowrap">NRIC</th>
				<th width=10% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Date of Birth</th>
				<th width=2% nowrap="nowrap">Gender</th>
				<th width=8% nowrap="nowrap">Nationality</th>
				<th width=10% nowrap="nowrap">Email</th>
				<th width=5% nowrap="nowrap">Contact</th>				
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
			            </tr>      
                    <%
                }
                else
                {
                    for (int x = 0; x < res.Count(); x++)
                    {
                        %>
                            <tr>
                                <td><img onclick="deleteVisitor('<%=res.ElementAt(x).NRIC%>', '<%= res.ElementAt(x).Name%>', this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
				                <td><a href="#" onclick="loadVisitor('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td>
				                <td><%= res.ElementAt(x).Name%></td>
				                <td><%= res.ElementAt(x).DOB%></td>
				                <td><%= res.ElementAt(x).Gender%></td>
				                <td><%= res.ElementAt(x).Nationality%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).Contact%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        