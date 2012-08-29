<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.IO" %>
<html>
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>    
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}
    IEnumerable<usp_searchCityKidsForUpdateResult> res = (IEnumerable<usp_searchCityKidsForUpdateResult>)ViewData["listofkids"];
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
        parent.loadKid(nric);
    }

    function reloadCase(NRIC, name, busgroup, clubgroup) {
        var submitForm = getNewSubmitForm();
        createNewFormElement(submitForm, "NRIC", NRIC);
        createNewFormElement(submitForm, "Name", name);
        createNewFormElement(submitForm, "BusGroup", busgroup);
        createNewFormElement(submitForm, "ClubGroup", clubgroup);
        submitForm.action = "/CityKids.mvc/ListOfCityKids";
        submitForm.Method = "POST";
        submitForm.submit();
    }

    function disablePositiveRadio(nric){
        $("#otherP_"+nric).hide();
        $("#otherP_"+nric).val("");
    }

    function enablePositiveRadio(nric){
        $("#otherP_"+nric).show();
        disableNegativeRadio(nric)
    }

    function disableNegativeRadio(nric){
        $("#otherN_"+nric).hide();
        $("#otherN_"+nric).val("");
    }

    function enableNegativeRadio(nric){
        $("#otherN_"+nric).show();
        disablePositiveRadio(nric)
    }
    
    function disableAllRadio(nric){
        $("#otherN_"+nric).hide();
        $("#otherP_"+nric).hide();
        $("#otherN_"+nric).val("");
        $("#otherP_"+nric).val("");
    }

    function checkValue(obj){
        if(isNaN(obj.value)){
            obj.value = obj.value.substring(0, obj.value.length -1);
            alert("Number only!");
        }
    }

</script>
<form method="post" action="/CityKids.mvc/updateCityKidsPoints" AUTOCOMPLETE="off">
    <input type="hidden" name="Name" value="<%=(string) ViewData["Name"]%>">
    <input type="hidden" name="NRIC" value="<%=(string) ViewData["NRIC"]%>">
    <input type="hidden" name="BusGroup" value="<%=(string) ViewData["BusGroup"]%>">
    <input type="hidden" name="ClubGroup" value="<%=(string) ViewData["ClubGroup"]%>">
    <p style="font-size:12px; text-align:left; margin-right:1%;"># of members found <%= res.Count()%></p>
    <table class="tablesorter" width="100%" id="MemberCaseTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			<thead>
			<tr class="header">
				<th width=2% nowrap="nowrap">NRIC</th>
				<th width=10% nowrap="nowrap">Name</th>
				<th width=3% nowrap="nowrap">Gender</th>
				<th width=4% nowrap="nowrap">Email</th>
				<th width=5% nowrap="nowrap">Bus Group / Cluster</th>
                <th width=5% nowrap="nowrap">Club Group</th>
				<th width=3% nowrap="nowrap">Points</th>
                <td class="nosorting" width=35% nowrap="nowrap"><b>Update Points</b></td>
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
                                
				                <td><a href="#" onclick="loadMember('<%= res.ElementAt(x).NRIC %>');"><%= res.ElementAt(x).NRIC%></a></td>
				                <td><%= res.ElementAt(x).Name%></td>
				                <td><%= res.ElementAt(x).Gender%></td>
				                <td><%= res.ElementAt(x).Email%></td>
				                <td><%= res.ElementAt(x).BusGroupClusterName%></td>
				                <td><%= res.ElementAt(x).ClubGroupName%></td>
                                <td><%= res.ElementAt(x).Points%></td>
                                <td>
                                    <table width="100%" style=" font-size:11px;">
                                        <tr>
                                            <td rowspan="2" style=" padding: 0 2 0 0"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="0" checked="checked" />0</td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+10" /><b>+10</b></td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+20" /><b>+20</b></td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+30" /><b>+30</b></td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+40" /><b>+40</b></td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+50" /><b>+50</b></td>
                                            <td style=" padding: 0 2 0 0; color: green"><input type="radio" onclick="enablePositiveRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="+?" /><b>+??</b></td>
                                            <td style=" padding: 0 2 0 0; color: green; width:40px"><input type="text" onkeyup="checkValue(this);" id="otherP_<%= res.ElementAt(x).NRIC %>" name="other_<%= res.ElementAt(x).NRIC %>" style=" width:100%; height:100%; display:none" /></td>
                                            <td rowspan="2" valign="top">Remarks<textarea name="remarks_<%= res.ElementAt(x).NRIC %>" style=" width:70%" ></textarea></td>
                                        </tr>
                                        <tr>                                            
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-10" /><b>-10</b></td>
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-20" /><b>-20</b></td>
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-30" /><b>-30</b></td>
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-40" /><b>-40</b></td>
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="disableAllRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-50" /><b>-50</b></td>
                                            <td style=" padding: 0 2 0 0; color: red"><input type="radio" onclick="enableNegativeRadio('<%= res.ElementAt(x).NRIC %>')" name="pt_<%= res.ElementAt(x).NRIC %>" value="-?" /><b>-??</b></td>
                                            <td style=" padding: 0 2 0 0; color: green; width:40px"><input type="text" onkeyup="checkValue(this);" id="otherN_<%= res.ElementAt(x).NRIC %>" name="other_<%= res.ElementAt(x).NRIC %>" style=" width:100%; height:100%; display:none" /></td>
                                        </tr>
                                    </table>                                   
                                                                                                         
                                </td>
			                </tr>      
                        <%
                    }
                }
            %>
		</tbody>
		</table>
        <button type="submit">Update</button>
</form>        
</html>












        