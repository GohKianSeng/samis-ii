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
        <table class="tablesorter" style="width:50%;padding:0; margin-left:0%; margin-right:0%">
            <thead>
			<tr class="header">
                <th style="width:50%">Course Name</th>
                <th  style="width:10%">Total Registered</th>                
            </tr>
            </thead>
            <tbody>
        <%
            IEnumerable<usp_getCourseRegistrationStatResult> res = (IEnumerable<usp_getCourseRegistrationStatResult>)ViewData["res"];
            for (int x = 0; x < res.Count(); x++)
            {
                %><tr><td><%=res.ElementAt(x).CourseName%></td><%
                %><td><%=res.ElementAt(x).Registered%></td><%                
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
</body>
</html>