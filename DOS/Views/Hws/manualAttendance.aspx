<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getAllHWSMemberResult> res = (IEnumerable<usp_getAllHWSMemberResult>)ViewData["listofmembers"];
%>

<script language="C#" runat="server">
    
    string getEnglishName(usp_getAllHWSMemberResult mem)
    {
        return mem.EnglishSurname + " " + mem.EnglishGivenName + " / " + mem.ChineseSurname + " " + mem.ChineseGivenName; 
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

        <% if(res != null){%>
            if ("100" == "<%= res.Count() %>") {
                alert("Only top 100 records are displayed. You may narrow down your search criteria to see fewer records");
            }
        <%}%>
    });

    function updateAttendance(id){
        $.post("/hws.mvc/UpdateAttendance",
                { ID: id },
                function (data) {
                    if(jQuery.trim(data) == "OK"){
                        $("#"+id).css('color', 'green');
                    }
                }
            );
    }

</script>

<br />
<table class="tablesorter" width="98%" id="MemberCaseTable" style=" width:98%; padding:0; margin-left:1%; margin-right:1%">
<thead><tr class="header">
                <td align="center" style="align:center" colspan="5" class="nosorting" width="1%" nowrap="nowrap">Click on the link for attendance</td></tr></thead>
<tbody>
<%
    int totalRow = res.Count() / 5;
    int remainder = res.Count() % 5;
    for(int x=0; x < totalRow; x++){%>
    <tr>
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt(x+0).ID%>')"><label id="<%=res.ElementAt(x+0).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt(x+0))%></label></a><br />&nbsp;</td>
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt(x+1).ID%>')"><label id="<%=res.ElementAt(x+1).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt(x+1))%></label></a><br />&nbsp;</td>
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt(x+2).ID%>')"><label id="<%=res.ElementAt(x+2).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt(x+2))%></label></a><br />&nbsp;</td>
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt(x+3).ID%>')"><label id="<%=res.ElementAt(x+3).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt(x+3))%></label></a><br />&nbsp;</td>
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt(x+4).ID%>')"><label id="<%=res.ElementAt(x+4).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt(x+4))%></label></a><br />&nbsp;</td>        
    </tr>
<%}
    if (remainder > 0)
    {
        %><tr><%
        for (int x = 0; x < remainder; x++)
        {%>    
        <td align="center"><br /><a style="text-decoration: none" href="#" onclick="updateAttendance('<%=res.ElementAt((totalRow * 5) + x).ID%>')"><label id="<%=res.ElementAt((totalRow * 5) + x).ID%>" style=" font-size:medium; font-weight:bold; color:red"><%=getEnglishName(res.ElementAt((totalRow * 5) + x))%></label></a><br />&nbsp;</td>             
<%      }
        %><tr><%
  }%>
</tbody>
</table>

        
</asp:Content>