<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    C3 Registration
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>

<script type="text/javascript" src="/Content/scripts/jquery.watermarkinput.min.js"></script>

<!-- multi Select script   -->
<link rel="stylesheet" type="text/css" href="/Content/css/jquery.multiselect.css" />
<link rel="stylesheet" type="text/css" href="/Content/css/jquery.multiselect.filter.css" />
<link rel="stylesheet" type="text/css" href="/Content/css/jquery-ui.css" />    
<script type="text/javascript" src="/Content/scripts/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.multiselect.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.multiselect.filter.min.js"></script>
<!-- multi Select script   -->

<!-- uploadify scripts   -->
<script type="text/javascript" src="/Content/scripts/swfobject.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.uploadify.v2.1.4.min.js"></script>

<link rel="stylesheet" type="text/css" href="/Content/css/fileuploader.css" />
<script type="text/javascript" src="/Content/scripts/fileuploader.js"></script>
<!-- uploadify scripts   -->

<!-- modal windows scripts   -->
<link rel="stylesheet" href="/Content/css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/dhtmlwindow.min.js"></script>
<link rel="stylesheet" href="/Content/css/modal.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/modal.min.js"></script>
<!-- modal windows scripts   -->
    
<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/citykids_membership.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/citykids_membership.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.min.js"></script>
<%}%>    

<script language="C#" runat="server">
    
    void loadCountry(Object Sender, EventArgs e)
    {
        List<usp_getAllCountryResult> res = (List<usp_getAllCountryResult>)ViewData["countrylist"];
        ListItem item = new ListItem("", "");
        kid_nationality.Items.Add(item);

        item = new ListItem("------------ South East Asia ------------", "-");
        item.Attributes.Add("disabled", "disabled");
        kid_nationality.Items.Add(item);

        for (int x = 0; x < res.Count; x++)
        {
            if (x == 12)
            {
                item = new ListItem("----------- Others Countries -----------", "-");
                item.Attributes.Add("disabled", "disabled");
                kid_nationality.Items.Add(item);
            }

            item = new ListItem(res.ElementAt(x).CountryName, res.ElementAt(x).CountryID.ToString());
            if (((string)ViewData["kid_nationality"]) == res.ElementAt(x).CountryID.ToString())
                item.Selected = true;
            kid_nationality.Items.Add(item);
        }
    }

    void loadSchool(Object Sender, EventArgs e)
    {
        List<usp_getAllSchoolResult> res = (List<usp_getAllSchoolResult>)ViewData["schoollist"];
        ListItem item = new ListItem("", "");
        kid_school.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).SchoolName, res.ElementAt(x).SchoolID.ToString());
            if (((string)ViewData["kid_school"]) == res.ElementAt(x).SchoolID.ToString())
                item.Selected = true;
            kid_school.Items.Add(item);
        }
    }

    void loadRace(Object Sender, EventArgs e)
    {
        List<usp_getAllRaceResult> res = (List<usp_getAllRaceResult>)ViewData["racelist"];
        ListItem item = new ListItem("", "");
        kid_race.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).RaceName, res.ElementAt(x).RaceID.ToString());
            if (((string)ViewData["kid_race"]) == res.ElementAt(x).RaceID.ToString())
                item.Selected = true;
            kid_race.Items.Add(item);
        }
    }

    void loadReligion(Object Sender, EventArgs e)
    {
        List<usp_getAllReligionResult> res = (List<usp_getAllReligionResult>)ViewData["religionlist"];
        ListItem item = new ListItem("", "");
        kid_religion.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).ReligionName, res.ElementAt(x).ReligionID.ToString());
            if (((string)ViewData["kid_religion"]) == res.ElementAt(x).ReligionID.ToString())
                item.Selected = true;
            kid_religion.Items.Add(item);
        }
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
        
    string getAutoPostalCode(){
        if (((string)Session["AutoPostalCode"]) != "On")
        {
            return "";
        } 
        else{
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

    function getDateRangeString(){
        return '<%=DateTime.Now.Year - 100%>:<%=DateTime.Now.Year%>';
    }

    function getGUID() {
        return "<%= System.Guid.NewGuid().ToString()%>";
    }

    function getAutoPostalCode(){
        return "<%=(string)Session["AutoPostalCode"] %>";
    }

    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>";
    }

    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
    }

    function getFormID(){
        return "<%= registration_form.ClientID%>"
    }

    function getNationalityID(){
        return "<%= kid_nationality.ClientID%>";
    }

    function getRaceID(){
        return "<%= kid_race.ClientID%>";
    }

    function getSchoolID(){
        return "<%= kid_school.ClientID%>";
    }

    function getGenderValue(){
        return "<%=(string) ViewData["kid_gender"]%>";
    }

    function getPhotoFilename(){
        return "<%=(string) ViewData["photo"]%>";
    }
    
    function changeHiddenText(obj, hidden){
        $("#"+hidden).val(obj.options[obj.selectedIndex].text);
    }    
</script>


<div id="loadingdiv" style=" display:none">
    <table style=" height:90%"  width="100%">
            <tr>
                <td style=" vertical-align:center; text-align:center">
                    <img border="0" src="/Content/images/loading.gif" /> Please wait...
                </td>
            </tr>            
        </table>
</div>
<div id="maindiv" class="bodycss">
	<img style=" width:800px" id="top" src="/Content/images/top.png" alt="">
	<div style=" width:800px" id="form_container">
	
		<form AUTOCOMPLETE="off" runat="server" id="registration_form" class="appnitro"  method="post" action="/CityKids.mvc/submitNewKid" enctype="multipart/form-data">
		<input type="hidden" id="OriginalNRIC" name="OriginalNRIC" value="<%=(string)ViewData["candidate_nric"] %>">
        
        
        <div class="form_description">
			<h3>C3 - CITY Children Club Registration <img src="/Content/images/C3-icon.jpg" /></h3>
            <span style="color:red;"><%= (string)ViewData["errormsg"] %></span>
		</div>						
		<ul >					
			<h4>Personal Information</h4>
		
        <table width="780" border="0">
        <tr>
            <td style=" width:25%">
                <li id="li_4" >
		            <label class="description" for="element_4">NRIC <span style="color:red;">*</span></label>
		            <div>
			            <input style=" width:90%" id="kid_nric" name="kid_nric" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","NRIC")%> value="<%= (string)ViewData["kid_nric"] %>" size="20"/> 
		            </div> 
				</li>
            </td>
            <td style=" width:25%">
                <li id="li_1" >
		            <label class="description" for="element_1">
                        Name<span style="color:red;">*</span></label>
		            <div>
			            <input style=" width:90%" id="kid_name" name="kid_name" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","Name")%> value="<%= (string)ViewData["kid_name"] %>" size="20"/> 
		            </div> 
		        </li>	
            </td>
            <td style=" width:25%">
                    <li id="li_6" >
		                <label class="description" for="element_6">
                            Gender <span style="color:red;">*</span></label>
		                <div>
                        <input type="hidden" id="GenderText" name="GenderText" />
		                <select style=" width:90%" class="element select small" onchange="changeHiddenText(this, 'GenderText');" id="kid_gender" name="kid_gender"> 
			                <option value="" selected="selected"></option>
                            <option value="M" >Male</option>
                            <option value="F" >Female</option>
		                </select>
		                </div> 
		                </li>
            </td>
            <td style=" width:25%">
                <li id="li_356" >
		            <label class="description" for="element_3">
                    Date of Birth <span style="color:red;">*</span></label>
                        <div>
                              <input readonly="readonly" style=" width:90%" id="kid_dob" name="kid_dob" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["kid_dob"] %>" size="20"/> 
		                </div>
                    </li>
            </td>            
        </tr>
        <tr>
            
            

			
        </tr>
        <tr>
            <td colspan="1">
                <li id="li2" >
		            <label class="description" for="element_7">
                    Nationality <span style="color:red;">*</span></label>
		            <div>
                        <input type="hidden" id="NationalityText" name="NationalityText" />
		                <asp:DropDownList style=" width:90%" class="element select medium" onchange="changeHiddenText(this, 'NationalityText');" OnLoad="loadCountry" name="kid_nationality" ID="kid_nationality" runat="server">
                        </asp:DropDownList>
		            </div> 
		            </li>
            </td>
            <td colspan="1">
                <li id="li3" >
		            <label class="description" for="element_7">
                    Race <span style="color:red;">*</span></label>
		            <div>
                        <input type="hidden" id="RaceText" name="RaceText" />
                        <asp:DropDownList style=" width:90%" class="element select medium" onchange="changeHiddenText(this, 'RaceText');" OnLoad="loadRace" name="kid_race" ID="kid_race" runat="server">
                        </asp:DropDownList>    	                
		            </div> 
		            </li>
            </td>
            <td>
                <li id="li_10" >
		            <label class="description" for="element_10">
                        Home Tel </label>
		            <div>
			            <input style=" width:90%" id="kid_home_tel" name="kid_home_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","HomeTel")%> value="<%= (string)ViewData["kid_home_tel"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
            <td colspan="1">
                <li id="li_11" >
		            <label class="description" for="element_11">
            Mobile Tel </label>
		            <div>
			            <input style=" width:90%" id="kid_mobile_tel" name="kid_mobile_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","MobileTel")%> value="<%= (string)ViewData["kid_mobile_tel"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>            
        </tr>
        <tr>
            <td colspan="2">
                <li style="width:210px" id="li_5" >
		            <label class="description" for="element_5">地址<br>
            Address <span style="color:red;">*</span></label>
		            <div style=" width:100px" >
			            <input style=" width:100px" id="candidate_postal_code" name="candidate_postal_code" class="element text medium" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["candidate_postal_code"] %>" type="text" size="20" >
			            <label class="makesmall" for="element_5_5">Postal Code</label>
		            </div>
                    <div class="left">
			            <input style=" width:100px"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_ccc_kids","AddressHouseBlk")%> value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
		                <label class="makesmall" for="element_5_6">BLK / House</label>
                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCodeHiddenField()%> />
		            </div>
		            <div class="right">
                        <input style=" width:100px" id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_ccc_kids","AddressUnit")%> value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
			            <label class="makesmall" for="element_5_5">Unit #</label>
	                </div>
                    <div>
			            <input style=" width:350px" id="candidate_street_address" name="candidate_street_address" class="element text medium" <%=getTextfieldLength("tb_ccc_kids","AddressStreet")%> value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
			            <label class="makesmall" for="element_5_1">Street Address</label>
                        <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCodeHiddenField()%> />
		            </div> 
		            </li>
            </td>
            <td rowspan="2" width="180">
                <div>
                <label class="description" for="element_5" nowarp="nowarp">身份证/护照照片<br>
					IC/Passport Photo</label>
                <!--input type="file" id="kid_photofile" name="kid_photofile" style="width:100%" /-->
                    <div id="kid_photofile" >
                        <noscript>
                            <p>Please enable JavaScript to use file uploader.</p>
                            <!-- or put a simple form for upload here -->
                        </noscript>
                    </div>
                </div>
            </td>
            <td rowspan="2" width="280">
                <img id="icphoto" src="/Content/images/ictemp.jpg" width="128" height="164" />
                <input type="hidden" id="kid_photo" name="kid_photo" value="<%=(string) ViewData["photo"]%>"/>
            </td>
        </tr>
		<tr>
            
        </tr>
        <tr>
            <td>
                <li id="li_19" >
		            <label class="description" for="element_19">
            Email </label>
		            <div>
			            <input style=" width:90%" id="kid_email" name="kid_email" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","Email")%> value="<%= (string)ViewData["kid_email"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
            <td>
                <li  id="li_16" >
		            <label class="description" for="element_16">
                        School <span style="color:red;">*</span></label>
		            <div>
                        <input type="hidden" id="SchoolText" name="SchoolText" />
                        <asp:DropDownList style=" width:90%" class="element select medium" onchange="changeHiddenText(this, 'SchoolText');" OnLoad="loadSchool" name="kid_school" ID="kid_school" runat="server">
                        </asp:DropDownList>
		            </div> 
		            </li>
            </td>
			<td>
                <li id="li_8" >
		            <label class="description" for="element_8">
                    Religion </label>
		            <div>
                        <input type="hidden" id="ReligionText" name="ReligionText" />
			            <asp:DropDownList style=" width:90%" class="element select medium" onchange="changeHiddenText(this, 'ReligionText');" OnLoad="loadReligion" name="kid_religion" ID="kid_religion" runat="server">
                        </asp:DropDownList>
                    </div> 
		            </li>
            </td>
        </tr>
        <tr>
            <td>
                <li id="li_9" >
		            <label class="description" for="element_9">
                    Next Of Kin Contact <span style="color:red;">*</span></label>
		            <div>                        
			            <input style=" width:90%" id="kid_NOK_contact" name="kid_NOK_contact" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","EmergencyContact")%> value="<%= (string)ViewData["kid_NOK_contact"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
			
            <td colspan="1" >
                <li id="li6" >
		            <label class="description" for="element_9">
                    Next Of Kin Name <span style="color:red;">*</span></label>
		            <div>
                        <input style=" width:90%" id="kid_NOK_relationship" name="kid_NOK_relationship" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","EmergencyContactName")%> value="<%= (string)ViewData["kid_NOK_relationship"] %>" size="20"/>                         			            
		            </div> 
		            </li>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <li id="li1" >
		            <label class="description" for="element_9">
                    Special Need / Remarks </label>
		            <div>                        
			            <textarea id="kid_special_needs" name="kid_special_needs" <%=getTextfieldLength("tb_ccc_kids","SpecialNeeds")%> rows="5" cols="40"><%=(string)ViewData["kid_special_needs"]%></textarea>
		            </div> 
		            </li>
            </td>
        </tr>
        </table>
                        	
     
        

            
        	
				<li class="buttons">
			        <input type="hidden" name="form_id" value="305427" />
			        <input id="Submit1" class="button_text" type="button" onclick="checkForm();" value="Submit" />                
                </li>
			</ul>

		</form>
        <div style="width=100%" id="footer">
			St Andrew's Cathedral
		</div>
    </div>
	<img style=" width:800px" id="bottom" src="/Content/images/bottom.png" alt="">
</div>
</asp:Content>