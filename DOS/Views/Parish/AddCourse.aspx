<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>

    <link rel="stylesheet" href="/Content/css/jquery-ui.css" type="text/css" />
    <link rel="stylesheet" href="/Content/css/jquery.ui.timepicker.css?v=0.2.9" type="text/css" />
    <script type="text/javascript" src="/Content/scripts/jquery.ui.core.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/jquery.ui.timepicker.js?v=0.2.9"></script>

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/addmodifycourse.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/addmodifycourse.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    void loadarea(Object Sender, EventArgs e)
    {
        string selected = "";
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult sel = (usp_getCourseInfoResult)ViewData["courseinformation"];
            selected = sel.courseLocation;
        }

        List<usp_getAllChurchAreaResult> res = (List<usp_getAllChurchAreaResult>)ViewData["listofchurcharea"];
        ListItem item = new ListItem("", "");
        coursearea.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).AreaName, res.ElementAt(x).AreaID.ToString());
            if (res.ElementAt(x).AreaName == selected)
                item.Selected = true;
            coursearea.Items.Add(item);
        }
    }

    string getCourseName()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.CourseName;
        }
        return "";
    }

    string getCourseStartDate()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.CourseStartDate;
        }
        return "";
    }

    string getCourseStartTime()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return ((TimeSpan)res.CourseStartTime).ToString();
        }
        return "";
    }

    string getCourseEndTime()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return ((TimeSpan)res.CourseEndTime).ToString();
        }
        return "";
    }

    string getInchargeName()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.Name;
        }
        return "";
    }

    string getInchargeNRIC()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.CourseInCharge;
        }
        return "";
    }

    string getInchargeID()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.courseID.ToString();
        }
        return "";
    }

    string getFee()
    {
        if (((string)ViewData["type"]) == "update")
        {
            usp_getCourseInfoResult res = (usp_getCourseInfoResult)ViewData["courseinformation"];
            return res.Fee.ToString();
        }
        return "0.00";
    }

    string getSubmitURL()
    {
        if (((string)ViewData["type"]) == "update")
        {
            return "/parish.mvc/updateAcourse";
        }
        return "/parish.mvc/addnewcourse";
    }

    string getTextfieldLength(string tablename, string columnname)
    {
        XElement xml = XElement.Parse((string)Session["TextfieldLength"]);
        for (int x = 0; x < xml.Elements("Column").Count(); x++)
        {
            if (xml.Elements("Column").ElementAt(x).Element("TableName").Value.ToUpper() == tablename.ToUpper() && xml.Elements("Column").ElementAt(x).Element("ColumnName").Value.ToUpper() == columnname.ToUpper())
            {
                return "maxlength=\"" + xml.Elements("Column").ElementAt(x).Element("Length").Value + "\"";
            }
        }
        return "maxlength=\"255\"";
    }
</script>

<script type="text/javascript">
    function getLocationID() {
        return "<%= coursearea.ClientID%>"
    }

    function getFormID() {
        return "<%=form.ClientID %>";
    }

    function getSubmitURL() {
        return "<%= Microsoft.JScript.GlobalObject.escape(getSubmitURL())%>"
    }

    function getSystemMode(){
        <%if(Page.User.Identity.IsAuthenticated){ %>
            return "FULL";
        <%}else{ %>
            return "<%=((string)Session["SystemMode"]).ToUpper() %>";
        <%} %>
    }
</script>


        <span style="color:red;"><%= (string) ViewData["errormsg"]%></span>
		<form id="form" runat="server" method="post" action="">
        <input type="hidden" id="courseid" name="courseid" value="<%= getInchargeID()%>" />
		    <table class="dottedview">
            <tr>
                <td>
                    Course Name<br />
                    <input id="coursename" name="coursename" class="element text medium" type="text" <%=getTextfieldLength("tb_course","CourseName")%> value="<%= getCourseName()%>"/> 
                </td>
                <td colspan="2">
                    Date Schedules<br />
                    <input readonly="readonly" style=" width:250px" id="startdate" name="startdate" type="text" value="<%= getCourseStartDate()%>"/> 
                </td>
            </tr>
            <tr>
                <td>
                    Venue<br />
                    <asp:DropDownList style=" width:150px;" class="element select medium" OnLoad="loadarea" name="courseArea" ID="coursearea" runat="server">
                    </asp:DropDownList>
                </td>
                <td>
                    From Time<br />
                    <input readonly="readonly" id="timestart" name="timestart" class="element text medium" type="text" maxlength="10" value="<%= getCourseStartTime()%>"/> 
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $('#timestart').timepicker();
                        });
                    </script>
                </td>
                <td>
                    To Time<br />
                    <input readonly="readonly" id="timeend" name="timeend" class="element text medium" type="text" maxlength="10" value="<%= getCourseEndTime()%>"/> 
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $('#timeend').timepicker();
                        });
                    </script>
                </td>
                
            </tr>
            <tr>
                <td>
                    Cost Fee $<br />
                    <input id="fee" name="fee" type="text" maxlength="10" value="<%= getFee()%>"/>
                </td>
                <td>
                    In Charge<br />
                    <input type="hidden" id="incharge" name="incharge" value="<%= getInchargeNRIC()%>" />
                    <input AUTOCOMPLETE = "off" style=" width:200px" id="inchargeinput" type="text" onkeyup="searchSuggest(1000, 'inchargeinput', 'search_suggest_incharge', 'incharge');" <%=getTextfieldLength("tb_members","EnglishName")%> value="<%= getInchargeName()%>"/> 
                    <div id="search_suggest_incharge" style="border:1px solid black; position:absolute; z-index:99999; display:none; height:200px; overflow:auto; width:370px"></div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <span style="color:red;"><%= (string) ViewData["error"]%></span>
                    <br />
                    <input id="submitFormButton" type="button" value="Submit"/> 
                </td>
            </tr>
        </table>
        </form>	
</asp:Content>