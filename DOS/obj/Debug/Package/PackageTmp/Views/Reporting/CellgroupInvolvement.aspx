<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Search By Cellgroup
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

    void loadCellgroup(Object Sender, EventArgs e)
    {
        List<usp_getListofCellgroupResult> res = (List<usp_getListofCellgroupResult>)ViewData["cellgrouplist"];
        ListItem item = new ListItem("", "");
        cellgroup.Items.Add(item);
        if (res == null)
            return;
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CellgroupName, res.ElementAt(x).CellgroupID.ToString());
            cellgroup.Items.Add(item);
        }
    }
    
</script>

<script type="text/javascript">
    function reloadList() {
        document.getElementById("displayloading").style.display = "block";
        $("#MemberlistIframe").get(0).contentWindow.reloadCase($("#" + getDropdownlistID()).val());
    }

    function getDropdownlistID() {
        return "<%= cellgroup.ClientID%>";
    }
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Cellgroup Involvement</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width: 160px">
                            Cellgroup<br>
                            <asp:DropDownList style=" width:150px" onchange="reloadList()" OnLoad="loadCellgroup" name="cellgroup" ID="cellgroup" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td id="displayloading" style="width: 160px; display:none">
                            <img src="/Content/images/loading.gif" /> Loading... Please wait.
                        </td>
                    </tr>
                </table>
                <br>
                <iframe id="MemberlistIframe" frameborder="0" src="/Reporting.mvc/cellgrouplist" style="width: 100%; height: 450px;">
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