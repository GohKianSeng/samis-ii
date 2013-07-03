<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    About Us
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/HokkienMemberForm.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/HokkienMemberForm.min.js"></script>    
<%}%>

<!-- history script   -->
<link rel="stylesheet" type="text/css" href="/Content/css/ITSCHistory.css" />
<script type="text/javascript" src="/Content/scripts/expand.min.js"></script>
<!-- history script   -->

<!-- datepicker script   -->
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>
<!-- datepicker script   -->

<!-- uploadify scripts   -->
<script type="text/javascript" src="/Content/scripts/swfobject.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.uploadify.v2.1.4.min.js"></script>

<link rel="stylesheet" type="text/css" href="/Content/css/fileuploader.css" />
<script type="text/javascript" src="/Content/scripts/fileuploader.js"></script>
<!-- uploadify scripts   -->

<!-- Fix header and sorter table scripts   -->
<link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
<script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
<!-- Fix header and sorter table scripts   -->    

<script language="C#" runat="server">
    
    
    
    string submitURL()
    {
        if (((string)ViewData["UpdateType"]).ToString() == "Actual")
        {
            return "/Membership.mvc/submitUpdateMemberForm";
        }
        else if (((string)ViewData["UpdateType"]).ToString() == "Temp")
        {
            return "/Membership.mvc/submitUpdateTempMemberForm";
        }
        else
            return "";
    }

    string getAutoPostalCodeHiddenField()
    {
        if (((string)Session["AutoPostalCode"]) == "Off")
        {
            return "disabled=\"disabled\"";
        }
        else
        {
            return "";
        }
    }
    
    string getAutoPostalCode()
    {
        if (((string)Session["AutoPostalCode"]) != "On")
        {
            return "";
        }
        else
        {
            return "disabled=\"disabled\"";
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
    function getGUID() {
        return "<%= System.Guid.NewGuid().ToString()%>"
    }
    function getAutoPostalCode(){
        return "<%=(string)Session["AutoPostalCode"] %>"
    }
    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>"
    }
    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
    }
    function getDateRangeString(){
        return '<%=DateTime.Now.Year - 100%>:<%=DateTime.Now.Year%>';
    }
    function getBasicSearchRetrivalURL(){
        return "<%= Session["BasicSearchRetrivalURL"]%>";
    }
    function getMesssage(){
        return "<%= ViewData["message"]%>";
    }
    function changeType(){
        return "<%=ViewData["ChangeType"] %>";
    }
    function PhotoFilename(){
        return "<%= ViewData["Photo"]%>";
    }
</script>

<form AUTOCOMPLETE="off" id="registration_form" action="/hws.mvc/submitNewMemberForm" method="post" enctype="multipart/form-data" runat="server">
    <input type="hidden" id="ID" name="ID" value="<%= ViewData["ID"] %>">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Personal Infomation</a></li>
            <% 
                if ((string)ViewData["ChangeType"] == "Modify"){
            %>
            <li><a href="#tab2">Personal Infomation</a></li>
            <li><a href="#tab3">History</a></li>
            <%
                }
            %>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            <label>English Surname</label>
		                    <input type="text" id="EnglishSurname" name="EnglishSurname" value="<%=(string)ViewData["EnglishSurname"] %>" maxlength="20" />        
                        </td>
                        <td>
                            <label>English Given Name</label>
		                    <input type="text" id="EnglishGivenName" name="EnglishGivenName" value="<%=(string)ViewData["EnglishGivenName"] %>" maxlength="30" />        
                        </td>

                        <td>
                            <label>Chinese Surname</label>
		                    <input type="text" id="ChineseSurname" name="ChineseSurname" value="<%=(string)ViewData["ChineseSurname"] %>" maxlength="2" />        
                        </td>
                        <td>
                            <label>Chinese Given Name</label>
		                    <input type="text" id="ChineseGivenName" name="ChineseGivenName" value="<%=(string)ViewData["ChineseGivenName"] %>" maxlength="3" />        
                        </td>
                    </tr>
                   
                    <tr>
                        <td>
                            <label>Birthday</label>
		                    <input type="text" id="DOB" name="DOB" value="<%=(string)ViewData["DOB"] %>" maxlength="10" />        
                        </td>
                        <td>
                            <label>Contact</label><br />
		                    <input type="text" id="Contact" name="Contact" value="<%=(string)ViewData["Contact"] %>" maxlength="10" />
                        </td>
                        
                        <td>
                            <label>Next of Kin</label>
		                    <input type="text" id="NOK" name="NOK" value="<%=(string)ViewData["NextOfKinName"] %>" maxlength="50" />
                        </td>

                        <td>
                            <label>Next of Kin contact</label>
		                    <input type="text" id="NOKContact" name="NOKContact" value="<%=(string)ViewData["NextOfKinContact"] %>" maxlength="10" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table class="noborderstyle" border=0>
                                <tr>
                                    <td colspan="3">
                                        <label class="description" for="element_5">
                                        Address <span style="color:red;">*</span></label>
		
		                                <div>
			                                <textarea style=" width:100%" id="candidate_street_address" <%=getAutoPostalCode() %> <%=getTextfieldLength("tb_members","AddressStreet")%> name="candidate_street_address"> <%= (string)ViewData["AddressStreet"]%></textarea>
			                                <br /><label class="makesmall" for="element_5_1">Street Address</label>
                                            <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["AddressStreet"] %>" <%=getAutoPostalCodeHiddenField()%> />
		                                </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_postal_code" name="candidate_postal_code" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= ViewData["AddressPostalCode"] %>" type="text">
			                            <br /><label class="makesmall">Postal Code</label>
                                    </td>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_members","AddressHouseBlk")%> <%=getAutoPostalCode() %> value="<%= (string)ViewData["AddressHouseBlock"] %>" type="text" size="20">
		                                <br /><label class="makesmall" for="element_5_6">Blk no. / House No.</label>
                                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["AddressHouseBlock"] %>" <%=getAutoPostalCodeHiddenField()%> />
                                    </td>
                                    <td style="width=40%">
                                        <input style=" width:100%"  id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_members","AddressUnit")%> value="<%= (string)ViewData["AddressUnit"] %>" type="text" size="20">
		                            <br /><label class="makesmall" for="element_5_6">Unit #</label>
                                    </td>
                                </tr>

                            </table>		                        
                        </td>
                        <td>    
		                    <div id="filecanupdate">
                                <label class="description" for="element_5" nowarp="nowarp">
					            Photo<span style="color:red;">*</span></label><br />
                                <!--input type=file id="candidate_photofile" name="candidate_photofile" style="width:100%" /-->
                                <div id="candidate_photofile" >
                                    <noscript>
                                        <p>Please enable JavaScript to use file uploader.</p>
                                        <!-- or put a simple form for upload here -->
                                    </noscript>
                                </div>
                            </div>
                        </td>
                        <td rowspan="1">
                            <img id="icphoto" src="/Content/images/ictemp.jpg" width="128" height="164" />
                            <input type="hidden" id="candidate_photo" name="candidate_photo" value="<%= (string)ViewData["Photo"]%>" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            Remarks<br />
                            <textarea id="remarks" name="remarks" cols="50" rows="7"><%=(string)ViewData["Remarks"]%></textarea>
                        </td>
                    </tr>		                               
                    </table>
            </div>
           
            <div id="tab3" class="tab_content">
                <div id="HistoryWrapper"> 
      		        <div id="HistoryContent">  
          		        <div class="HistoryDiv">
                            <h3 class="expand">Created by KS @ Date</h3>
            			        <div class="collapse">
					                <table class="HistoryTable">
						                <tr style=" font-size:12px">
                                            <td>NRIC:</td>
                                        </tr>
                                    </table>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    <div style="clear:both; width:180px; text-align:left; padding-left:15px"><br />
        <input id="Submit1" class="button_text" type="button" onclick="checkHWSMemberFormNew();" value="Submit" />        
    </div>     
    </div>
          
    </form>
        
</asp:Content>