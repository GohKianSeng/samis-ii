<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getAllHWSMemberResult> res = (IEnumerable<usp_getAllHWSMemberResult>)ViewData["listofmembers"];
  %>

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

    function loadMember(nric){
        parent.loadMember(nric);
    }

    function reloadCase(NRIC, name) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "NRIC", NRIC);
        createNewFormElement(submitForm, "Name", name);
        submitForm.action = "/Membership.mvc/SearchMemberForUpdate";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function deleteMember(id, name, obj) {
        
        var answer = confirm("Remove Member: " + name + "?")
        if (answer) {
            $.post("/hws.mvc/deleteMember",
                { ID: id },
                function (data) {
                    if (jQuery.trim(data) == "1"){
                        alert(name + " member deleted");                    
                        removeSelectedRow(obj);
                    }
                    else
                        alert("Unable to remove " + name);
                }
            );
        }
    }
</script>

    <p style="font-size:12px; text-align:left; margin-right:1%; margin-left:1%;"># of members found <%= res.Count()%></p>
    <table class="tablesorter" width="98%" id="MemberCaseTable" style=" width:98%; padding:0; margin-left:1%; margin-right:1%">
			<thead>
			<tr class="header">
                <td class="nosorting" width="1%" nowrap="nowrap"></td>
				<th width=1% nowrap="nowrap">ID</th>
				<th width=10% nowrap="nowrap">English Name</th>
				<th width=10% nowrap="nowrap">Chinese Name</th>
				<th width=10% nowrap="nowrap">Contact</th>				
				
		</thead>
		<tbody>
			    <% 
                if (res == null || res.Count() == 0)
                {
                    %>
                        <tr>
                            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>
				            <td></td>				           		            
			            </tr>      
                    <%
                }
                else
                {
                    for (int x = 0; x < res.Count(); x++)
                    {
                        %>
                            <tr>
                                <td><img onclick="deleteMember('<%=res.ElementAt(x).ID%>', '<%= res.ElementAt(x).ID%>', this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
				                <td><a href="/hws.mvc/loadMember?ID=<%= res.ElementAt(x).ID%>"><%= res.ElementAt(x).ID%></a></td>
				                <td><%= res.ElementAt(x).EnglishSurname + " " + res.ElementAt(x).EnglishGivenName%></td>
				                <td><%= res.ElementAt(x).ChineseSurname + " " + res.ElementAt(x).ChineseGivenName%></td>
				                <td><%= res.ElementAt(x).Contact%></td>				                
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
</asp:Content>        












        