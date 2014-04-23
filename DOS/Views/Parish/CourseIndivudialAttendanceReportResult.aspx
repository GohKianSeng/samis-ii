<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>

<!DOCTYPE html >
<html>
<head>
    
    
    <script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->
    
    <link rel="stylesheet" href="/Content/css/RGraph/demos.css" type="text/css" media="screen" />
    <script src="/Content/scripts/RGraph/RGraph.common.dynamic.js" type="text/javascript"></script>
    <script type="text/javascript" src="/Content/scripts/RGraph/RGraph.common.core.js" ></script>
    <script type="text/javascript" src="/Content/scripts/RGraph/RGraph.bar.js" ></script>
    <!--[if lt IE 9]><script src="/Content/scripts/RGraph/excanvas.js"></script><![endif]-->       
</head>
<body>
    <div>
        <%
            IEnumerable<usp_getCourseIndividualAttendanceReportResult> res = (IEnumerable<usp_getCourseIndividualAttendanceReportResult>)ViewData["res"];
        %>
        <span style=" text-align:right">Total Count: <%=res.Count() %></span>

        <table class="tablesorter" style="width:100%;padding:0; margin-left:0%; margin-right:0%">
            <thead>
			<tr class="header">
                <th style="width:5%">NRIC</th>
                <th style="width:16%">Name</th>
                <th  style="width:7%"># Attended</th>
                <th  style="width:25%">Course Attended</th>
                <th  style="width:7%"># Completed</th>
                <th  style="width:25%">Course Completed</th>
                <th  style="width:20%">Church</th>
            </tr>
            </thead>
            <tbody>
        <%
            
            for (int x = 0; x < res.Count(); x++)
            {
                %><tr><%
                if(res.ElementAt(x).Member.Length > 0){
                    %><td><a href="#" onclick="parent.loadMember('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td><%
                }
                else if (res.ElementAt(x).TempMember.Length > 0)
                {
                    %><td><a href="#" onclick="parent.loadTempMember('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td><%
                }
                else if (res.ElementAt(x).Visitor.Length > 0)
                {
                    %><td><a href="#" onclick="parent.loadVisitor('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td><%
                }
                else
                {
                    %><td></td><%
                }                                                                                          
                                                                                                                                                                                                                                                                                                                
                %><td><%=res.ElementAt(x).Name%></td><%
                %><td><%=res.ElementAt(x).AttendedNumberOfCourse%></td><%
                %><td><%=res.ElementAt(x).AttendedCourseName.Replace("||","<br />")%></td><%
                %><td><%=res.ElementAt(x).CompletedNumberOfCourse%></td><%
                %><td><%=res.ElementAt(x).CompletedCourseName.Replace("||","<br />")%></td><%
                string churchName = res.ElementAt(x).Parish;
                %><td><%=churchName%></td></tr><%
            }    
            
        %>
        </tbody>
        </table>
    </div>
    <script>
        window.onload = function () {
            $("table").tablesorter({ dateFormat: "uk" });
            $(".tablesorter tr:even").addClass("alt");                    
        }
    </script>

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
</body>
</html>