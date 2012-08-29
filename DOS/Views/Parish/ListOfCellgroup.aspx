<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getListofCellgroupResult> res = (IEnumerable<usp_getListofCellgroupResult>)ViewData["listofcellgroup"];
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

    function reloadCase() {
        var submitForm = getNewSubmitForm();
        submitForm.action = "/parish.mvc/ListOfCellgroup";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function deleteCellgroup(cellgroupid, name) {
        var answer = confirm("Delete cellgroup: " + name + "?")
        if (answer) {
            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "CellgroupID", cellgroupid);
            createNewFormElement(submitForm, "CellgroupName", name);
            submitForm.action = "/Parish.mvc/RemoveCellgroup";
            submitForm.Method = "POST";
            submitForm.submit();
        }
    }

    function loadCellgroup(ministryid) {
        parent.loadCellgroup(ministryid);
    }

</script>

    
    <p style="color:red;"><%= (string)ViewData["errormsg"]%></p>
    <table width="100%">
        <tr>
            <td width=50%">
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of cellgroup <%= res.Count()%></p>
                
            </td>
            <td width=50%; align="right">
                <input id="showrepbut" type=button value="Reload" onclick="reloadCase();" align="right">
            </td>
        </tr>
    </table>
    
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <td class="nosorting" width=1% nowrap="nowrap"></td>
				<th width=10% nowrap="nowrap">Cellgroup Name</th>
                <th width=10% nowrap="nowrap">In Charge</th>
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
			            </tr>      
                    <%
                }
                else
                {
                    for (int x = 0; x < res.Count(); x++)
                    {
                        %>
                            <tr>
                                <td><img onclick="deleteCellgroup('<%=res.ElementAt(x).CellgroupID%>', '<%= res.ElementAt(x).CellgroupName%>');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
                                <td><a href="#" onclick="loadCellgroup('<%= res.ElementAt(x).CellgroupID %>');"><%= res.ElementAt(x).CellgroupName%></a></td>
				                <td><%= res.ElementAt(x).Name%></td>

			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        