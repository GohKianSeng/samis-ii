<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Search & Update C3
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    
    void loadBusGroup(Object Sender, EventArgs e)
    {
        List<usp_getAllBusGroupClusterResult> res = (List<usp_getAllBusGroupClusterResult>)ViewData["busgroupclusterlist"];
        ListItem item = new ListItem("", "");
        busgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).BusGroupClusterName, res.ElementAt(x).BusGroupClusterID.ToString());
            if (((string)ViewData["kid_nationality"]) == res.ElementAt(x).BusGroupClusterID.ToString())
                item.Selected = true;
            busgroup.Items.Add(item);
        }
    }

    void loadClubGroup(Object Sender, EventArgs e)
    {
        List<usp_getAllClubgroupResult> res = (List<usp_getAllClubgroupResult>)ViewData["clubgrouplist"];
        ListItem item = new ListItem("", "");
        clubgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).ClubGroupName, res.ElementAt(x).ClubGroupID.ToString());
            if (((string)ViewData["kid_school"]) == res.ElementAt(x).ClubGroupID.ToString())
                item.Selected = true;
            clubgroup.Items.Add(item);
        }
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

    function getBusGroupID(){
        return "<%= busgroup.ClientID%>";
    }
    function getClubGroupID(){
        return "<%= clubgroup.ClientID%>";
    }

    function searchKids() {

        $("#KidslistIframe").get(0).contentWindow.reloadCase($("#kidnric").val(), $("#kidname").val(), $("#" + getBusGroupID()).val(), $("#" + getClubGroupID()).val());
    }
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Search & Update</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 160px">
                            NRIC<br>
                            <input type="text" name="kidnric" id="kidnric" value="" <%=getTextfieldLength("tb_ccc_kids","NRIC")%> style=" width:90%" size="20">
                        </td>
                        <td style="width: 155px">
                            Name<br>
                            <input type="text" name="kidname" id="kidname" value="" <%=getTextfieldLength("tb_ccc_kids","Name")%> style=" width:90%" size="20">
                        </td>
                        <td style="width: 155px">
                            Bus Group<br>
                            <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadBusGroup" name="busgroup" ID="busgroup" runat="server">
                            </asp:DropDownList> 
                        </td>
                        <td style="width: 155px">
                            Club Group<br>
                            <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadClubGroup" name="clubgroup" ID="clubgroup" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td style="width: 996px">
                            <br>
                            <input type="button" name="button" id="button" onclick="searchKids()" value="Search">
                            
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <label><span style="color:red;"><%=(string)ViewData["errormsg"]%></span></label>
                        </td>
                    </tr>
                </table>
                <br>
                <iframe id="KidslistIframe" frameborder="0" src="/CityKids.mvc/ListOfCityKids" style="width: 100%; height: 450px;">
                    <p>
                        Your browser does not support iframes.</p></iframe>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>
    </form>





</asp:Content>