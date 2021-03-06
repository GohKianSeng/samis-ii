﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Member Approval
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_getListOfTempMembersForApprovalResult> res = (IEnumerable<usp_getListOfTempMembersForApprovalResult>)ViewData["listoftempmembers"];
  %>

<script language="C#" runat="server">
    
    string partialBlankIC(string nric)
    {
        Regex rgx = new Regex("[A-Za-z0-9._%+-]");
        if (nric.Length == 9)
        {
            return "S" + rgx.Replace(nric.Substring(0, 4), "x") + nric.Substring(6);
        }
        else
        {
            return rgx.Replace(nric, "x");                      
        }
        
    }
</script>    

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

    
    $(document).ready(function () {
        $("table").tablesorter({ dateFormat: "uk" });
        $(".tablesorter tr:even").addClass("alt");

        <% if(res != null){%>
            if ("100" == "<%= res.Count() %>") {
                alert("Only top 100 records are displayed. You may narrow down your search criteria to see fewer records");
            }
        <%}%>
    });

    function deleteMember(NRIC, name, obj) {
        
        var answer = confirm("Remove Member: " + name + "?")
        if (answer) {
            $.post("/Membership.mvc/deleteMember",
                { NRIC: NRIC, Name: name, Type: "Temp" },
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

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Approve New Membership</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                
                <% IEnumerable<usp_getListOfTempMembersForApprovalResult> res = (IEnumerable<usp_getListOfTempMembersForApprovalResult>)ViewData["listoftempmembers"];%>
                <label><span style="color:red;"><%=(string)ViewData["errormsg"]%></span></label>
                <br /><br />
                <input type="hidden" id="totalrecord" name="totalrecord" value="<%= res.Count()%>" />
                <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%= res.Count()%></p>
                <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			            <thead>
			            <tr class="header">
                            <td class="nosorting" width=1% nowrap><input id="check_uncheck_all" onclick="for_check_uncheck_all();" type="checkbox"/></td>
				            <td class="nosorting" width="1%" nowrap="nowrap"></td>
                            <th width=6% nowrap="nowrap">Name</th>
                            <th width=2% nowrap="nowrap">NRIC</th>
				            <th width=3% nowrap="nowrap">Age</th>                           
				            <th width=2% nowrap="nowrap">Gender</th>
                            <th width=3% nowrap="nowrap">Service</th>
				            <th width=2% nowrap="nowrap">Mobile No</th>
                            <th width=3% nowrap="nowrap">Email</th>
                            <th width=10% nowrap="nowrap">Residential Address</th>
                            <th width=2% nowrap="nowrap">Occupation</th>

		            </thead>
		            <tbody>
			                <% 
                            if (res == null || res.Count() == 0)
                            {
                                %>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>				                       
				                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>
				                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>				                        
			                        </tr>      
                                <%
                            }
                            else
                            {
                                for (int x = 0; x < res.Count(); x++)
                                {
                                    %>
                                        <tr>
                                            <td><input id="approveCheckBox<%=x.ToString() %>" value="<%= res.ElementAt(x).NRIC%>" onclick="checkBoxIndividualApprove(this)" type="checkbox"/></td>
				                            <td><img onclick="deleteMember('<%=res.ElementAt(x).NRIC%>', '<%= res.ElementAt(x).Name%>', this);" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Remove"  alt="Remove"/></td>
                                            <td><%= res.ElementAt(x).Name%></td>
                                            <td><a href="#" onclick="loadTempMember('<%= res.ElementAt(x).NRIC %>');"><%= partialBlankIC(res.ElementAt(x).NRIC)%></a></td>
				                            <td><%= DateTime.Now.Year - res.ElementAt(x).DOB.Year%></td>
				                            <td><%= res.ElementAt(x).Gender%></td>
				                            <td><%= res.ElementAt(x).CongregationName%></td>
				                            <td><%= res.ElementAt(x).MobileTel%></td>
                                            <td><%= res.ElementAt(x).Email%></td>	
                                            <%string unit = res.ElementAt(x).AddressUnit; if (unit.Length > 0 && !unit.StartsWith("#")) unit = "#" + unit;%>
                                            <td><%= res.ElementAt(x).AddressHouseBlk + " " + res.ElementAt(x).AddressStreet + " " + unit + " S'(" + res.ElementAt(x).AddressPostalCode.ToString() + ")"%></td>
			                                <td><%= res.ElementAt(x).OccupationName%></td>	
                                        </tr>      
                                    <%
                                }
                            }
                        %>
		            </tbody>
		            </table>

                    <table style="font-size:14px; font-weight:bold; height:80px; width:100%;">
                        <tr>
                            <td style="width:3%">
                                <input type="button" value="Approve Selected"  onclick="ApproveSelectedMembers()"/>
                            </td>                            
                        </tr>                          
                    </table>


            </div>
        </div>
    </div>
    </form>





</asp:Content>