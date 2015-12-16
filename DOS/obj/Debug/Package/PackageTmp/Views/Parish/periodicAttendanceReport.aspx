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
            ToYear.Items.Add(item);
        }
    }

    void LoadMonth(Object Sender, EventArgs e)
    {
        FromMonth.Items.Add(new ListItem("January", "1"));
        FromMonth.Items.Add(new ListItem("February", "2"));
        FromMonth.Items.Add(new ListItem("March", "3"));
        FromMonth.Items.Add(new ListItem("April", "4"));
        FromMonth.Items.Add(new ListItem("May", "5"));
        FromMonth.Items.Add(new ListItem("June", "6"));
        FromMonth.Items.Add(new ListItem("July", "7"));
        FromMonth.Items.Add(new ListItem("August", "8"));
        FromMonth.Items.Add(new ListItem("September", "9"));
        FromMonth.Items.Add(new ListItem("October", "10"));
        FromMonth.Items.Add(new ListItem("November", "11"));
        FromMonth.Items.Add(new ListItem("December", "12"));

        ToMonth.Items.Add(new ListItem("January", "1"));
        ToMonth.Items.Add(new ListItem("February", "2"));
        ToMonth.Items.Add(new ListItem("March", "3"));
        ToMonth.Items.Add(new ListItem("April", "4"));
        ToMonth.Items.Add(new ListItem("May", "5"));
        ToMonth.Items.Add(new ListItem("June", "6"));
        ToMonth.Items.Add(new ListItem("July", "7"));
        ToMonth.Items.Add(new ListItem("August", "8"));
        ToMonth.Items.Add(new ListItem("September", "9"));
        ToMonth.Items.Add(new ListItem("October", "10"));
        ToMonth.Items.Add(new ListItem("November", "11"));
        ToMonth.Items.Add(new ListItem("December", "12"));
    }
</script>

<script type="text/javascript">
    function Reload() {
        var FromYear = document.getElementById('<%=FromYear.ClientID%>').value;
        var ToYear = document.getElementById('<%=ToYear.ClientID%>').value;

        var FromMonth = document.getElementById('<%=FromMonth.ClientID%>').value;
        var ToMonth = document.getElementById('<%=ToMonth.ClientID%>').value;

        document.getElementById('Iframe').src = "/parish.mvc/LoadPeriodicAttendanceReportResult?FromYear=" + FromYear + "&ToYear=" + ToYear + "&FromMonth=" + FromMonth + "&ToMonth=" + ToMonth;
    }
</script>

<form id="registration_form" runat="server">
    <div class="container" style="width:90%;">
        <ul class="tabs">
            <li><a href="#tab3">Periodic Attendance Report</a></li>            
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0" style="height:80%">
                    <tr style=" height:10%">
                        <td>
		                    <table width="400px">
                                <tr>
                                    <td style=" padding: 0 0 0 0;width:1%"></td>
                                    <td style=" padding: 0 0 0 0;width:50%"><b>From Period</b></td>
                                    <td style=" padding: 0 0 0 0;width:49%"><b>To Period</b></td>                                   
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Year</td>
                                    <td style=" padding: 0 0 0 0;"><asp:DropDownList style=" width:60px" OnLoad="LoadYear" name="FromYear" ID="FromYear" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                    <td style=" padding: 0 0 0 0;"><asp:DropDownList style=" width:60px" name="ToYear" ID="ToYear" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Month</td>
                                    <td style=" padding: 0 0 0 0;">
                                        <asp:DropDownList style=" width:100px" OnLoad="LoadMonth" name="FromMonth" ID="FromMonth" runat="server">
                                        </asp:DropDownList>
                                    </td>
                                    <td style=" padding: 0 0 0 0;">
                                        <asp:DropDownList style=" width:100px" name="ToMonth" ID="ToMonth" runat="server">
                                        </asp:DropDownList>
                                    </td>
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