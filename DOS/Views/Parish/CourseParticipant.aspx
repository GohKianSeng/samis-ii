<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>

<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (HttpContext.Current.IsDebuggingEnabled)
  {%>    
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}
  else
  {%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

    <script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

<script type="text/javascript">
    function loadCourse(courseid) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "courseid", courseid);
        submitForm.action = "/Parish.mvc/modifyACourse";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function manualUpdate(object, nric, courseid, date, attendance) {
        $.post('/parish.mvc/manualUpdateAttendance',
            { nric: nric, courseid: courseid, date: date, attendance: attendance },
            function (data) {
                alert(data);
            }
        );
        
        object.disabled = true;
    }

    $(document).ready(function () {
        $("table").tablesorter({ dateFormat: "uk" });
        $(".tablesorter tr:even").addClass("alt");
    });
</script>

<script language="C#" runat="server">
    
    void loadFeepaid(Object Sender, EventArgs e)
    {
        bool paid = ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).feePaid;
        ListItem item;
        item = new ListItem("Fee Paid", "1");
        if (paid)
            item.Selected = true;                
        feepaid.Items.Add(item);

        item = new ListItem("Fee Not Paid ", "0");
        if (!paid)
            item.Selected = true;
        feepaid.Items.Add(item);
    }

    void loadMaterialCollected(Object Sender, EventArgs e)
    {
        bool collected = ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).materialReceived;
        ListItem item;
        item = new ListItem("Material Collected", "1");
        if (collected)
            item.Selected = true;
        materialcollected.Items.Add(item);

        item = new ListItem("Material Not Collected ", "0");
        if (!collected)
            item.Selected = true;
        materialcollected.Items.Add(item);
    }
</script>

<form id="registration_form" runat="server" action="/parish.mvc/updateParticipantInformation">
    <table class="dottedview" cellspacing="0">
        <tr>
            <td>
		        Name<br />
                <input type="text" readonly="readonly" disabled="disabled" value="<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).EnglishName %>"/>
            </td>
            <td>
		        NRIC<br />
                <input type="text" readonly="readonly" disabled="disabled" value="<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).NRIC %>"/>
                <input type="hidden" name="nric" value="<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).NRIC %>"/>
                <input type="hidden" name="courseid" value="<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).courseID %>"/>
                <input type="hidden" name="name" value="<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).EnglishName %>"/>
            </td>  
            <td>
		        Fee Paid<br />
                <asp:DropDownList OnLoad="loadFeepaid" name="feepaid" ID="feepaid" runat="server">
                </asp:DropDownList>
            </td>
            <td>
		        Fee Paid<br />
                <asp:DropDownList OnLoad="loadMaterialCollected" name="materialcollected" ID="materialcollected" runat="server">
                </asp:DropDownList>
            </td>                     
        </tr>
        <tr>
            <td colspan="2">
                Attendance<br />
                <table class="tablesorter" width="70%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%;">
			    <thead>
			        <tr class="header">
                        <th width=8% nowrap="nowrap" style="font-size:12px">Date</th>
				        <th width=3% nowrap="nowrap" style="font-size:12px">Attended</th>
                        <th width=3% nowrap="nowrap" style="font-size:12px">Attended (Manual Update)</th>				        
                    </tr>
		        </thead>
		        <tbody>
			            <%
                        XElement tb = ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).Attendance;
                        int res = 0;
                        if (tb == null)
                            res = 0;
                        else
                            res = tb.Elements("ATT").Count();
                        if (res == null || res == 0)
                        {
                            %>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
			                    </tr>      
                            <%
                        }
                        else
                        {
                            for (int x = 0; x < tb.Elements("ATT").Count(); x++)
                            {
                                %>
                                    <tr>
                                        <td style="font-size:11px"><%= DateTime.Parse(tb.Elements("ATT").ElementAt(x).Element("Date").Value).ToString("dd/MM/yyyy")%></td>
                                        <td style="font-size:11px"><%= tb.Elements("ATT").ElementAt(x).Element("Attended").Value%></td>
                                        <td style="font-size:11px">
                                            <%
                                                if (tb.Elements("ATT").ElementAt(x).Element("Attended").Value == "Yes")
                                                {
                                                    %><input type="button" value="No" onclick="manualUpdate(this, '<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).NRIC %>', '<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).courseID %>', '<%= DateTime.Parse(tb.Elements("ATT").ElementAt(x).Element("Date").Value).ToString("dd/MM/yyyy")%>', 'no');" /><%
                                                                                                                                                                                                                                                                                                                                                                                                                                  }
                                                else if (tb.Elements("ATT").ElementAt(x).Element("Attended").Value == "-")
                                                {
                                                    %><input type="button" value="yes" onclick="manualUpdate(this, '<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).NRIC %>', '<%= ((usp_getCourseParticipantInformationResult)ViewData["participantinformation"]).courseID %>', '<%= DateTime.Parse(tb.Elements("ATT").ElementAt(x).Element("Date").Value).ToString("dd/MM/yyyy")%>', 'yes');" /><%
                                                                                                                                                                                                                                                                                                                                                                                                                                  }
                                            %>
                                        </td>
			                        </tr>      
                                <%
                                                                                                                                                                                                                                                                                                                                                                                                                                  }
                        }
                    %>
		        </tbody>
		        </table>
            </td>
        </tr>        
        <tr>
            <td>
		        <input type="submit" value="Update"/>
            </td>            
        </tr>
    </table> 
      
</form>