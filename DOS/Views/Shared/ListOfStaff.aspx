<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getAllStaffResult> res = (IEnumerable<usp_getAllStaffResult>)ViewData["lisfofstaff"];
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

    function loadcase(nric){
        parent.loadcase(nric);
    }

    function reloadCase() {
        var submitForm = getNewSubmitForm();
        submitForm.action = "/parish.mvc/listallStaff";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function resetPassword(userid, name) {
        var answer = confirm("Reset user, " + name + ", password?")
        if (answer) {
            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "UserID", userid);
            createNewFormElement(submitForm, "Name", name);
            submitForm.action = "/Account.mvc/resetStaffPassword";
            submitForm.Method = "POST";
            submitForm.submit();
        }
    }

    function deleteUser(userid, name) {
        var answer = confirm("Delete user, " + name + "?")
        if (answer) {
            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "UserID", userid);
            createNewFormElement(submitForm, "Name", name);
            submitForm.action = "/Account.mvc/removeStaff";
            submitForm.Method = "POST";
            submitForm.submit();
        }
    }

</script>

    
    <p style="color:red;"><%= (string)ViewData["errormsg"]%></p>
    <table width="100%">
        <tr>
            <td width=50%">
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of staff <%= res.Count()%></p>
                
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
                <td class="nosorting" width=1% nowrap="nowrap"></td>
				<th width=10% nowrap="nowrap">Name</th>
                <th width=3% nowrap="nowrap">UserID</th>
				<th width=8% nowrap="nowrap">Email</th>
				<th width=3% nowrap="nowrap">Home Tel:</th>
				<th width=3% nowrap="nowrap">Mobile No:</th>
                <th width=10% nowrap="nowrap">Department</th>
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
                                <td><img onclick="deleteUser('<%=res.ElementAt(x).USERID%>', '<%= res.ElementAt(x).Name%>');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
                                <td><a onclick="resetPassword('<%=res.ElementAt(x).USERID%>', '<%= res.ElementAt(x).Name%>');"  href="#">Reset Password</a></td>
                                <td><%= res.ElementAt(x).Name%></td>
                                <td><%= res.ElementAt(x).USERID%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).Phone%></td>
				                <td><%= res.ElementAt(x).Mobile%></td>
                                <td><%= res.ElementAt(x).Department%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        
</html>












        