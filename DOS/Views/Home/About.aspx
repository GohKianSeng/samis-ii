<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var errormsg = "<%=((string)ViewData["errormsg"]).Replace('\\', '/') %>";
        if(errormsg.length > 0){
            alert(errormsg);
        }
    });
</script>
        
        <table style=" height:95%"  width="100%">
            <tr>
                <td style=" vertical-align:bottom; text-align:center">
                    <img border="0" src="/Content/images/sacbigtitle.PNG" />
                </td>
            </tr>
            <tr>
                <td style=" vertical-align:top; text-align:center">
                    <img border="0" src="/Content/images/bar.PNG" />
                </td>
            </tr>
        </table>
    
</asp:Content>
