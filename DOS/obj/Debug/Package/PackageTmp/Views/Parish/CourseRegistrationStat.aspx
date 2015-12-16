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
        var month = "";
        if (document.getElementById("month1").checked)
            month += "1" + ",";
        if (document.getElementById("month2").checked)
            month += "2" + ",";
        if (document.getElementById("month3").checked)
            month += "3" + ",";
        if (document.getElementById("month4").checked)
            month += "4" + ",";
        if (document.getElementById("month5").checked)
            month += "5" + ",";
        if (document.getElementById("month6").checked)
            month += "6" + ",";
        if (document.getElementById("month7").checked)
            month += "7" + ",";
        if (document.getElementById("month8").checked)
            month += "8" + ",";
        if (document.getElementById("month9").checked)
            month += "9" + ",";
        if (document.getElementById("month10").checked)
            month += "10" + ",";
        if (document.getElementById("month11").checked)
            month += "11" + ",";
        if (document.getElementById("month12").checked)
            month += "12" + ",";

        document.getElementById('Iframe').src = "/parish.mvc/CourseRegistrationStatResult?FromYear=" + FromYear + "&FromMonth=" + month;
    }
</script>

<form id="registration_form" runat="server">
    <div class="container" style="width:90%;">
        <ul class="tabs">
            <li><a href="#tab3">Course Registration Stats</a></li>            
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0" style="height:80%">
                    <tr style=" height:10%">
                        <td>
		                    <table width="100%">
                                <tr>
                                    <td style=" padding: 0 0 0 0;width:5%"></td>
                                    <td style=" padding: 0 0 0 0;width:90%"><b>Select Period</b></td>                                   
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Year</td>
                                    <td style=" padding: 0 0 0 0;"><asp:DropDownList style=" width:60px" OnLoad="LoadYear" name="FromYear" ID="FromYear" runat="server">
                                        </asp:DropDownList>
                                    </td>                                    
                                </tr>
                                <tr>
                                    <td style=" padding: 0 0 0 0;">Month</td>
                                    <td style=" padding: 0 0 0 0;">
                                        <table>
                                            <tr>                                                
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month1" value="1" >January</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month2" value="2" >February</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month3" value="3" >March</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month4" value="4" >April</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month5" value="5" >May</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month6" value="6" >June</input></td>                                                
                                            </tr>                                                
                                            <tr><td style=" padding: 0 0 0 0;"><input type="checkbox" id="month7" value="7" >July</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month8" value="8" >August</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month9" value="9" >September</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month10" value="10" >October</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month11" value="11" >November</input></td>
                                                <td style=" padding: 0 0 0 0;"><input type="checkbox" id="month12" value="12" >December</input></td>
                                            </tr>
                                        </table>
                                        

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