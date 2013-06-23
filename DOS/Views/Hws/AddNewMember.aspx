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

<script type='text/JavaScript' src='http://www.onemap.sg/API/JS?accessKEY=PDIDjkx/B4ZBAoLJtr15ygW8aLgQHc7jnnwrOGFryjrxDn0yQz0Fp9iZenaweM8buhmy99i4KVNmzs5sR3+C7D2A8ejA2pUn|mv73ZvjFcSo='></script>

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

    bool canAccess(string function)
    {
        if (User.Identity.IsAuthenticated && Session["AccessRight"] == null)
        {
            DOS_DBDataContext sql_conn = new DOS_DBDataContext();
            Session["UserInformation"] = sql_conn.usp_getUserInformation(User.Identity.Name).ElementAt(0).XML_F52E2B61_18A1_11d1_B105_00805F49916B;
            Session["AccessRight"] = sql_conn.usp_getModuleFunctionsAccessRight(User.Identity.Name).ElementAt(0).FunctionAccessRight;
            Session["LogonUserName"] = sql_conn.usp_getStaffName(User.Identity.Name).ElementAt(0).Name;
        }
        
        XElement accessright = XElement.Parse(Session["AccessRight"].ToString());
        if (accessright.Elements("AccessTo").Count() == 0)
            return false;
        else
        {
            for (int x = 0; x < accessright.Elements("AccessTo").Count(); x++)
            {
                if (accessright.Elements("AccessTo").ElementAt(x).Element("functionName").Value.ToUpper() == function.ToUpper())
                {
                    return true;
                }

            }
            return false;
        }
    }

    string getReligionString()
    {
        string religion = "<option value=\"\"></option>";
        List<usp_getAllReligionResult> res = (List<usp_getAllReligionResult>)ViewData["religionlist"];
        for (int x = 0; x < res.Count; x++)
        {
            religion += "<option value=\"" + res.ElementAt(x).ReligionID + "\">" + res.ElementAt(x).ReligionName + "</option>";
        }

        return religion;
    }

    string getParishString()
    {
        string parish = "<option value=\"\"></option>";
        List<usp_getAllParishResult> res = (List<usp_getAllParishResult>)ViewData["parishlist"];
        for (int x = 0; x < res.Count; x++)
        {
            parish += "<option value=\"" + res.ElementAt(x).ParishID + "\">" + res.ElementAt(x).ParishName.Replace('\'', ' ') + "</option>";
        }

        return parish;
    }

    string getFamilyTypeString()
    {
        string Family = "<option value=\"\"></option>";
        List<usp_getAllFamilyTypeResult> res = (List<usp_getAllFamilyTypeResult>)ViewData["familytypelist"];
        for (int x = 0; x < res.Count; x++)
        {
            Family += "<option value=\"" + res.ElementAt(x).FamilyTypeID + "\">" + res.ElementAt(x).FamilyType + "</option>";
        }

        return Family;
    }

    string getOccupationString()
    {
        string occ = "<option value=\"\"></option>";
        List<usp_getAllOccupationResult> res = (List<usp_getAllOccupationResult>)ViewData["occupationlist"];
        for (int x = 0; x < res.Count; x++)
        {
            occ += "<option value=\"" + res.ElementAt(x).OccupationID + "\">" + res.ElementAt(x).OccupationName + "</option>";
        }
        
        return occ;
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

    string getXMLValue(XElement node, string name)
    {
        if (node == null)
            return "";
        if (node.Element(name) == null)
            return "";
        else
            return node.Element(name).Value;
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

    function getBasicSearchRetrivalURL(){
        return "<%= Session["BasicSearchRetrivalURL"]%>";
    }
</script>

<form AUTOCOMPLETE="off" id="registration_form" action="/membership.mvc/submitUpdateMemberForm" enctype="multipart/form-data" runat="server">
    <input type="hidden" id="OriginalNric" name="OriginalNric" value="<%= (string)ViewData["candidate_nric"] %>">
    <input type="hidden" id="childlist" name="childlist" value="0">
	<input type="hidden" id="familylist" name="familylist" value="0">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Personal Infomation</a></li>
            <li><a href="#tab2">Personal Infomation</a></li>
            <li><a href="#tab3">History</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            <label>English Surname</label>
		                    <input type="text" id="Text1" name="" />        
                        </td>
                        <td>
                            <label>English Given Name</label>
		                    <input type="text" id="Text2" name="" />        
                        </td>

                        <td>
                            <label>Chinese Surname</label>
		                    <input type="text" id="Text3" name="" />        
                        </td>
                        <td>
                            <label>Chinese Given Name</label>
		                    <input type="text" id="Text4" name="" />        
                        </td>
                    </tr>
                   
                    <tr>
                        <td>
                            <label>Birthday</label>
		                    <input type="text" id="Text5" name="" />        
                        </td>
                        <td>
                            <label>Contact</label>
		                    <input type="text" id="Text6" name="" />        
                        </td>
                        <td>
                            
		                    <div id="filecanupdate">
                                <label class="description" for="element_5" nowarp="nowarp">
					            IC/Passport Photo<span style="color:red;">*</span></label><br />
                                <!--input type=file id="candidate_photofile" name="candidate_photofile" style="width:100%" /-->
                                <div id="candidate_photofile" >
                                    <noscript>
                                        <p>Please enable JavaScript to use file uploader.</p>
                                        <!-- or put a simple form for upload here -->
                                    </noscript>
                                </div>

                            </div>
		                        

                        </td>
                        <td>
                            
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
			                                <textarea style=" width:100%" id="candidate_street_address" <%=getAutoPostalCode() %> <%=getTextfieldLength("tb_members","AddressStreet")%> name="candidate_street_address"> <%= (string)ViewData["candidate_street_address"] %></textarea>
			                                <br /><label class="makesmall" for="element_5_1">Street Address</label>
                                            <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCodeHiddenField()%> />
		                                </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_postal_code" name="candidate_postal_code" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["candidate_postal_code"] %>" type="text">
			                            <br /><label class="makesmall">Postal Code</label>
                                    </td>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_members","AddressHouseBlk")%> <%=getAutoPostalCode() %> value="<%= (string)ViewData["candidate_blk_house"] %>" type="text" size="20">
		                                <br /><label class="makesmall" for="element_5_6">Blk no. / House No.</label>
                                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCodeHiddenField()%> />
                                    </td>
                                    <td style="width=40%">
                                        <input style=" width:100%"  id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_members","AddressUnit")%> value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
		                            <br /><label class="makesmall" for="element_5_6">Unit #</label>
                                    </td>
                                </tr>

                            </table>		                        
                        </td>
                        <td rowspan="1">
                            <img id="icphoto" src="/Content/images/ictemp.jpg" width="128" height="164" />
                            <input type="hidden" id="candidate_photo" name="candidate_photo" />
                        </td>
                        <td rowspan="1">
                            
                        </td>
                    </tr>
		            
                    <tr>
                        <td>
                            <label class="description" for="element_10">
                        Home Tel </label>
		                        <div>
			                        
		                        </div> 
		                        
		                        
                        </td>
                        <td>
                            
		                        <label class="description" for="element_19">
                        Email </label>
		                        <div>
			                        
		                        </div> 
		                        
                        </td>
			            <td >
                            
		                        <label class="description" for="element_8">
                        Language(s) <span style="color:red;">*</span></label>
		                        <div>
			                        
		                        </div> 
		                        
                        </td>
                        <td>
                            <label class="description" for="element_8">Car IU No#</label>
                            <div>
			                       
		                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td style=" width:20%">
                           
		                     <label class="description" for="element_11">
                        Mobile Tel </label>
		                        <div>
			                        
		                        </div>    
		                        
                        </td>
			            <td>


                                <label class="description" for="element_16">
                                Education <span style="color:red;">*</span></label>
		                                <div>
                                        
		                        
		                        </div> 
                            
		                        
		                        
                        </td>
                        <td style="width:200px">
                            
                            <label class="description" for="element_9">
                        Occupation <span style="color:red;">*</span></label>
		                        <div>
                                    
			            
		                        </div> 


		                        
		                        
                        </td>
                        <td colspan="1" >
                            
		                        <label class="description" for="element_9">
                                Congregation <span style="color:red;">*</span></label>
		                        <div>
                                    
			            
		                        </div> 
		                        
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
        <% if (canAccess("Update Member")){%>
                <input id="Submit1" class="button_text" type="button" onclick="checkStaffMemberForm()" value="Update" />        
        <%}else{%>
                <input id="Button1" class="button_text" type="button" disabled="disabled" value="Update" />
        <%}%>
        
    </div>     
    </div>
          
    </form>
        
</asp:Content>