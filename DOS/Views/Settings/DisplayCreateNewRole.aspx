<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>

<html>
    <head>
        <script type="text/javascript">
            function checkAndClose() {
                if (document.getElementById("rolename").value.length <= 0) {
                    document.getElementById("errormsg").innerHTML = "Role name cannot be blank.";
                    return;
                }
                parent.domwindow.hide();
            }
        </script>
    </head>
    <table style=" width:100%; height:100%">
        <tr>
            <td>
                Role Name:<br />
                <input type="text" style=" width:100%" value="<%=(string)ViewData["rolename"]%>" id="rolename"/>
                <br /><br />
                <label id="errormsg" style=" color:Red"></label><br/>
                <input type="button" onclick="checkAndClose();" value="OK" />
            </td>
        </tr>        
    </table>
</html>