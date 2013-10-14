<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
Course Related
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>    
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>    
<%}%>


<script language="C#" runat="server">
    
    void LoadYear(Object Sender, EventArgs e)
    {
        List<usp_getAllCourseYearsResult> res = (List<usp_getAllCourseYearsResult>)ViewData["Years"];
        ListItem item = new ListItem("", "");

       for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).Year.ToString(), res.ElementAt(x).Year.ToString());
            FromYear.Items.Add(item);            
        }
    }    
</script>

<script type="text/javascript">
    function Reload() {
        var FromYear = document.getElementById('<%=FromYear.ClientID%>').value;
        var numberOfCourse = document.getElementById('numberOfCourse').value;

        document.getElementById('Iframe').src = "/parish.mvc/CourseIndivudialAttendanceReportResult?FromYear=" + FromYear + "&numberOfCourse=" + numberOfCourse;
    }
</script>

<form id="registration_form" runat="server">
    <div class="container" style="width:90%;">
        <ul class="tabs">
            <li><a href="#tab3">Course Individual Attendance Report</a></li>            
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0" style="height:80%">
                    <tr style=" height:10%">
                        <td>
		                    <table width="100%">
                                <tr>
                                    <td style=" padding: 0 0 0 0;width:20%"></td>
                                    <td style=" padding: 0 0 0 0;width:80%"><b>Select Period</b></td>                                   
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Year</td>
                                    <td style=" padding: 0 0 0 0;"><asp:DropDownList style=" width:60px" OnLoad="LoadYear" name="FromYear" ID="FromYear" runat="server">
                                        </asp:DropDownList>
                                    </td>                                    
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Number of Courses attended</td>
                                    <td style=" padding: 0 0 0 0;">
                                        <select id="numberOfCourse">
                                            <option value="1"> at least 1</option>
                                            <option value="2"> more than 2</option>
                                            <option value="3"> more than 3</option>
                                            <option value="4"> more than 4</option>
                                            <option value="5"> more than 5</option>
                                            <option value="6"> more than 6</option>
                                            <option value="7"> more than 7</option>
                                            <option value="8"> more than 8</option>
                                            <option value="9"> more than 9</option>
                                            <option value="10"> more than 10</option>
                                            <option value="11"> more than 11</option>
                                            <option value="12"> more than 12</option>
                                            <option value="13"> more than 13</option>
                                            <option value="14"> more than 14</option>
                                            <option value="15"> more than 15</option>
                                            <option value="16"> more than 16</option>
                                            <option value="17"> more than 17</option>
                                            <option value="18"> more than 18</option>
                                            <option value="19"> more than 19</option>
                                            <option value="20"> more than 20</option>
                                        </select>
                                        

                                    </td>
                                </tr>                                        
                                <tr>
                                    <td></td>
                                    <td  style=" padding: 0 0 0 0;">
                                        <input type="button" value="Reload" onclick="Reload();"/>
                                    </td>
                                </tr>
                            </table>
                           
                        </td>                        
                    </tr>
                    <tr>
                        <td  style=" height:550px">
		                    <iframe id="Iframe" frameborder="0" src="" style="width: 100%; height:100%">
                            <p>Your browser does not support iframes.</p></iframe>
                        </td>
                        
                    </tr>
                    </table>
            </div>                                   
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>       
    </form>

</asp:Content>