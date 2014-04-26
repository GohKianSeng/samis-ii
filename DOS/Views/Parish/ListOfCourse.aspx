<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<form id="Form1" runat="server">  
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getListofCourseResult> res = (IEnumerable<usp_getListofCourseResult>)ViewData["listofcourse"];
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

    function reloadCourse(obj) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "Year", $(obj).val());
        submitForm.action = "/parish.mvc/ListOfCourse";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function deleteCourse(courseid, name, year) {
        var answer = confirm("Delete course: " + name + "?")
        if (answer) {
            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "courseid", courseid);
            createNewFormElement(submitForm, "name", name);
            createNewFormElement(submitForm, "Year", year);
            submitForm.action = "/Parish.mvc/removeCourse";
            submitForm.Method = "POST";
            submitForm.submit();
        }
    }

    function loadCourse(courseid) {
        parent.loadCourse(courseid);
    }

</script>
<script language="C#" runat="server">
    
    void loadYear(Object Sender, EventArgs e)
    {
        ListItem item = new ListItem("", "-1");
        List<usp_getAllCourseYearsResult> res1 = (List<usp_getAllCourseYearsResult>)ViewData["Years"];

        if (res1 != null)
        {
            for (int x = 0; x < res1.Count; x++)
            {
                item = new ListItem(res1.ElementAt(x).Year.ToString(), res1.ElementAt(x).Year.ToString());
                if (res1.ElementAt(x).Year == int.Parse((string)ViewData["Year"]))
                    item.Selected = true;
                Year.Items.Add(item);
            }
        }
    }    
</script>
  
    <p style="color:red;"><%= (string)ViewData["errormsg"]%></p>
    <table width="100%">
        <tr>
            <td width=50%">
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of course <%= res.Count()%></p>
                
            </td>
            <td width=50%; align="right">
                
                Year: <asp:DropDownList style=" width:150px" onchange="reloadCourse(this);" OnLoad="loadYear" name="Year" ID="Year" runat="server">
                </asp:DropDownList>
            </td>
        </tr>
    </table>
    
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
                <td class="nosorting" width=1% nowrap="nowrap"></td>
				<th width=8% nowrap="nowrap">Course Name</th>
				<th width=3% nowrap="nowrap">Start Date</th>
				<th width=3% nowrap="nowrap">Time From</th>
                <th width=3% nowrap="nowrap">Time To</th>
                <th width=5% nowrap="nowrap">Location</th>
                <th width=7% nowrap="nowrap">In Charge</th>
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
                                <td><img onclick="deleteCourse('<%=res.ElementAt(x).courseID%>', '<%= res.ElementAt(x).CourseName%>', $('#<%=Year.ClientID %>').val());" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
                                <td><a href="#" onclick="loadCourse('<%= res.ElementAt(x).courseID %>');"><%= res.ElementAt(x).CourseName%></a></td>
				                <td><%= res.ElementAt(x).CourseStartDate%></td>				                <td><%= res.ElementAt(x).CourseStartTime%></td>
                                <td><%= res.ElementAt(x).CourseEndTime%></td>
                                <td><%= res.ElementAt(x).courseLocation%></td>
                                <td><%= res.ElementAt(x).Name%></td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
</form>        
</html>












        