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
                    int minAttendance = int.Parse((ViewData["minAttendance"]).ToString());
                    int attendedAtLeastOnce = int.Parse((ViewData["attendedAtLeastOnce"]).ToString());
                    int allCompletedCourse = int.Parse((ViewData["allCompletedCourse"]).ToString());
                    int SACCompletedCourse = int.Parse((ViewData["SACCompletedCourse"]).ToString());
                    int NonSACCompletedCourse = int.Parse((ViewData["NonSACCompletedCourse"]).ToString());
                    int anglicanCompleted = int.Parse((ViewData["anglicanCompleted"]).ToString());
                    int nonAnglicanCompleted = int.Parse((ViewData["nonAnglicanCompleted"]).ToString());
                    
                    
                    if (res.Count() > 0)
                    {
                        for (int x = 0; x < totalday; x++)
                        {
                        %><th width=5% nowrap="nowrap"><%=((DateTime)res.ElementAt(x).Schedule).ToString("dd/MM/yyyy")%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><%
                        }                        
                    }
                %>
                <th width=3% nowrap="nowrap">Attendance %&nbsp;&nbsp;&nbsp;&nbsp;</th>
                </tr>
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
                            int individualAttended = 0;
                            for (int x = 0; x < total-1; x++)
                            {   individualAttended = 0;
                                int index = x * totalday;
                        %>      <tr>  
                                <td nowrap="nowrap"><%= partialBlankIC(res.ElementAt(index).NRIC)%></td>
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
                                                    individualAttended++;
                                                    %><img src="/Content/images/tick-icon.png" alt="1"/><%    
                                                }
                                             %>
                                        
                                        </td>
                                    <%
                                }
                                string color = "";
                                float individualPercent = ((float)individualAttended / (float)totalday * (float)100);
                                if (individualPercent <= 0 || individualAttended == null)
                                    individualPercent = 0.0f;
                                if ((int)individualPercent == 100)
                                    color = "green";
                                else if (individualAttended >= minAttendance)
                                    color = "yellow";
                                else
                                    color = "red";
                                    
                                    
                                %><td style=" background-color:<%=color%>"><%= (int)individualPercent%>%</td><%
                                %></tr><%
                            
                            }
                            %><tr><td colspan="6"></td><td style=" background-color: #CCCCCC">Average Daily Attendance</td><%
                            XElement xml = (XElement)ViewData["xml"];
                            float dailyaverage = 0.0f;
                            for (int g = 0; g < xml.Elements("Attendance").Count(); g++)
                            {
                                string dailytotal = xml.Elements("Attendance").ElementAt(g).Element("DailyTotal").Value;
                                dailyaverage += float.Parse(xml.Elements("Attendance").ElementAt(g).Element("DailyTotal").Value);
                                
                                 %><td style=" background-color: #CCCCCC"><%=dailytotal%></td><%
                                
                            }
                            %><td style=" background-color: #CCCCCC"><%=(dailyaverage / xml.Elements("Attendance").Count()).ToString("0.##")%></td><%
                        }
            %>
		</tbody>
		</table>
    <br /><br />
    <table class="tablesorter" id="Table1" style=" width:30%; padding:0; margin-left:0%; margin-right:0%" align="right">
			<thead>
			<tr class="header">
                <td class="nosorting" colspan="2" width=3% nowrap="nowrap">Total Registration</td>                
            </tr>
            </thead>                
                <tr>
                    <td>Total Registered</td>
                    <td align="center" style=" width:30%"><%= res.Count()/totalday%></td>
                </tr>
                <tr>
                    <td>Attended > 0%</td>
                    <td align="center" style=" width:30%"><%=attendedAtLeastOnce%></td>
                </tr>
                <tr>
                    <td>Completed</td>
                    <td align="center"><%=allCompletedCourse%></td>
                </tr>
                <tr>
                    <td>Completed - SAC</td>
                    <td align="center"><%=SACCompletedCourse%></td>
                </tr>
                <tr>
                    <td>Completed - Non SAC</td>
                    <td align="center"><%=NonSACCompletedCourse%></td>
                </tr>
                <tr>
                    <td>Completed - Anglican</td>
                    <td align="center"><%=anglicanCompleted%></td>
                </tr>
                <tr>
                    <td>Completed - Non Anglican</td>
                    <td align="center"><%=nonAnglicanCompleted%></td>
                </tr>
            <tbody>
            
            </tbody>
     </table>        
</html>












        