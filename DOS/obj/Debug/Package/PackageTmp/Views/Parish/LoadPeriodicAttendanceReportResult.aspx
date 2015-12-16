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
    <canvas id="cvs" height="500">[No canvas support]</canvas>
    <div>
        <table class="tablesorter" style="padding:0; margin-left:0%; margin-right:0%">
            <thead>
			<tr class="header">
                <th style="width:50%">Course Name</th>
                <th>Total Attended</th>
                <th>Total Completed</th>
            </tr>
            </thead>
            <tbody>
        <%
            IEnumerable<usp_getPeriodicAttendanceReportResult> res = (IEnumerable<usp_getPeriodicAttendanceReportResult>)ViewData["res"];
            for (int x = 0; x < res.Count(); x++)
            {
                %><tr><td><%=res.ElementAt(x).CourseName%></td><%
                %><td><%=res.ElementAt(x).AttendanceAttended%></td><%
                %><td><%=res.ElementAt(x).AttendanceCompleted%></td></tr><%
            }    
            
        %>
        </tbody>
        </table>
    </div>
    <script>
        var width = window.innerWidth * 98 / 100;
        document.getElementById("cvs").setAttribute("width", width.toString()); 
        window.onload = function () {
            $("table").tablesorter({ dateFormat: "uk" });
            $(".tablesorter tr:even").addClass("alt");
            
            var data = [<%=(string)ViewData["CourseAttendance"]%>];
            var bar = new RGraph.Bar('cvs', data)
            .Set('colors', ['#2A17B1', '#98ED00'])
            .Set('chart.labels', [<%=(string)ViewData["CourseName"]%>])
            .Set('chart.gutter.left', 45)
            .Set('chart.background.grid', true)
            .Set('chart.text.angle', 30)
            .Set('chart.gutter.top', 10)
            .Set('chart.gutter.bottom', 300)
            .Set('chart.gutter.left', 150)            
            .Draw();
        }       
    </script>
</body>
</html>