﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" ContentType="text/html; charset=UTF-8"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
    string jquery164 = "";
    string jqueryUI186 = "";
    string loginviewcss = "";
    string datepickercss = "";
    string datepicker = "";
    string watermark = "";
    string multiselectscc1 = "";
    string multiselectscc2 = "";
    string jquerycss = "";
    string multiselect1 = "";
    string multiselect2 = "";
    string DOS = "";
    string common = "";
    jquery164 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\jquery-1.6.4.min.js");
    loginviewcss = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "css\\login_view.css");
    datepickercss = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "css\\datepicker.css");
    datepicker = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\datepicker.js");
    watermark = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\jquery.watermarkinput.min.js");
    multiselectscc1 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "css\\jquery.multiselect.css");
    multiselectscc2 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "css\\jquery.multiselect.filter.css");
    jquerycss = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "css\\jquery-ui.css");
    jqueryUI186 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\jquery-ui-1.8.16.custom.min.js");
    multiselect1 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\jquery.multiselect.min.js");
    multiselect2 = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\jquery.multiselect.filter.min.js");
    DOS = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\DOS_membership.debug.js");
    common = System.IO.File.ReadAllText((string)Session["JavascriptLocation"] + "scripts\\common_function.debug.js");
%>


<script type="text/javascript">
<%= jquery164 %>
</script>
<style type="text/css">
<%= loginviewcss%>
</style>
<style type="text/css">
<%= datepickercss %>
</style>

<script type="text/javascript">
<%= datepicker %>
</script>
<script type="text/javascript">
<%= watermark %>    
</script>

<!-- multi Select script   -->
<style type="text/css">
<%= multiselectscc1 %>       
</style>
<style type="text/css">
 <%= multiselectscc2 %>
</style>
<style type="text/css">
<%= jquerycss %>
</style>
<script type="text/javascript">
<%= jqueryUI186 %>
</script>
<script type="text/javascript">
<%= multiselect1 %>
</script>
<script type="text/javascript">
<%= multiselect2 %>
</script>
<!-- multi Select script   -->
    
<script type="text/javascript">
<%= DOS %>
</script>
<script type="text/javascript">
<%= common %>
</script>   
<script language="C#" runat="server">
    
    void loadMinistry(Object Sender, EventArgs e)
    {
        List<usp_getListofMinistryResult> res = (List<usp_getListofMinistryResult>)ViewData["ministrylist"];
        ListItem item = new ListItem("", "");

        string interested_ministry = "";
        if (ViewData["candidate_interested_ministry"] != null)
        {
            interested_ministry = "," + (string)ViewData["candidate_interested_ministry"] + ","; 
        }
        
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).MinistryName, res.ElementAt(x).MinistryID.ToString());
            if (interested_ministry.Contains("," + res.ElementAt(x).MinistryID.ToString() + ","))
                item.Selected = true;
            candidate_interested_ministry.Items.Add(item);
        }
    }    

    void loadClergy(Object Sender, EventArgs e)
    {
        List<usp_getAllClergyResult> res = (List<usp_getAllClergyResult>)ViewData["clergylist"];
        ListItem item = new ListItem("", "");
        confirm_by.Items.Add(item);
        baptized_by.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).Name, res.ElementAt(x).NRIC.ToString());
            confirm_by.Items.Add(item);
            baptized_by.Items.Add(item);
        }
        item = new ListItem("Others", "Others");
        confirm_by.Items.Add(item);
        baptized_by.Items.Add(item);
    }

    void loadParish(Object Sender, EventArgs e)
    {
        List<usp_getAllParishResult> res = (List<usp_getAllParishResult>)ViewData["parishlist"];
        ListItem item = new ListItem("", "");
        previous_church_membership.Items.Add(item);
        confirmation_church.Items.Add(item);
        baptism_church.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).ParishName, res.ElementAt(x).ParishID.ToString());
            previous_church_membership.Items.Add(item);
            confirmation_church.Items.Add(item);
            baptism_church.Items.Add(item);
        }
    }     

    void loadOccpation(Object Sender, EventArgs e)
    {
        List<usp_getAllOccupationResult> res = (List<usp_getAllOccupationResult>)ViewData["occupationlist"];
        ListItem item = new ListItem("", "");
        candidate_occupation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).OccupationName, res.ElementAt(x).OccupationID.ToString());
            if (((string)ViewData["candidate_occupation"]) == res.ElementAt(x).OccupationID.ToString())
                item.Selected = true;
            candidate_occupation.Items.Add(item);
        }
    }
    void loadmaritalstatus(Object Sender, EventArgs e)
    {
        List<usp_getAllMaritalStatusResult> res = (List<usp_getAllMaritalStatusResult>)ViewData["maritalstatuslist"];
        ListItem item = new ListItem("", "");
        candidate_marital_status.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).MaritalStatusName, res.ElementAt(x).MaritalStatusID.ToString());
            if (((string)ViewData["candidate_marital_status"]) == res.ElementAt(x).MaritalStatusID.ToString())
                item.Selected = true;
            candidate_marital_status.Items.Add(item);
        }
    }

    void loadEducation(Object Sender, EventArgs e)
    {
        List<usp_getAllEducationResult> res = (List<usp_getAllEducationResult>)ViewData["educationlist"];
        ListItem item = new ListItem("", "");
        candidate_education.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).EducationName, res.ElementAt(x).EducationID.ToString());
            if (((string)ViewData["candidate_marital_status"]) == res.ElementAt(x).EducationID.ToString())
                item.Selected = true;
            candidate_education.Items.Add(item);
        }
    }
    
    void loadDialect(Object Sender, EventArgs e)
    {
        List<usp_getAllDialectResult> res = (List<usp_getAllDialectResult>)ViewData["dialectlist"];
        ListItem item = new ListItem("", "");
        candidate_dialect.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).DialectName, res.ElementAt(x).DialectID.ToString());
            if (((string)ViewData["candidate_dialect"]) == res.ElementAt(x).DialectID.ToString())
                item.Selected = true;
            candidate_dialect.Items.Add(item);
        }
    }

    void loadSalutation(Object Sender, EventArgs e)
    {
        List<usp_getAllSalutationResult> res = (List<usp_getAllSalutationResult>)ViewData["salutationlist"];
        ListItem item = new ListItem("", "");
        candidate_salutation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).SalutationName, res.ElementAt(x).SalutationID.ToString());
            if (((string)ViewData["candidate_salutation"]) == res.ElementAt(x).SalutationID.ToString())
                item.Selected = true;
            candidate_salutation.Items.Add(item);
        }
    }
         
    void loadCountry(Object Sender, EventArgs e)
    {
        List<usp_getAllCountryResult> res = (List<usp_getAllCountryResult>)ViewData["countrylist"];
        ListItem item = new ListItem("", "");
        candidate_nationality.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {   
            item = new ListItem(res.ElementAt(x).CountryName, res.ElementAt(x).CountryID.ToString());
            if (((string)ViewData["candidate_nationality"]) == res.ElementAt(x).CountryID.ToString())
                item.Selected = true;
            candidate_nationality.Items.Add(item);
        }
    }
    void loadLanguage(Object Sender, EventArgs e)
    {
        List<usp_getAllLanguageResult> res = (List<usp_getAllLanguageResult>)ViewData["languagelist"];
        ListItem item = new ListItem("", "");
        string list = "," + (string)ViewData["candidate_language"] + ",";
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).LanguageName, res.ElementAt(x).LanguageID.ToString());
            if (list.IndexOf("," + res.ElementAt(x).LanguageID.ToString() + ",") > -1)
                item.Selected = true;
            candidate_languagelist.Items.Add(item);
        }
    }
    void loadCongregation(Object Sender, EventArgs e)
    {
        List<usp_getAllCongregationResult> res = (List<usp_getAllCongregationResult>)ViewData["congregationlist"];
        ListItem item = new ListItem("", "");
        candidate_congregation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CongregationName, res.ElementAt(x).CongregationID.ToString());
            candidate_congregation.Items.Add(item);
        }
    }

    string submitURL()
    {
        if (((string)ViewData["Type"]).ToString() == "UPDATE")
        {
            return "/Membership.mvc/resubmitMemberForm";
        }
        else if (((string)ViewData["Type"]).ToString() == "ADD")
        {
            return "/Membership.mvc/submitMemberForm";
        }
        else
            return "";
    }
    
    string getAutoPostalCode(){
        if (((string)Session["AutoPostalCode"]) != "On")
        {
            return "";
        } 
        else{
            return "";
        }
    }      

</script>

<script type="text/javascript">
    function isOffline(){
        return true;
    }
    
    function getDateRangeString(){
        return '<%=DateTime.Now.Year - 100%>:<%=DateTime.Now.Year%>';
    }

    function getGUID() {
        return "<%= System.Guid.NewGuid().ToString()%>"
    }

    function getFormID() {
        return "<%= registration_form.ClientID %>";
    }

    function getCandidateLanguageID() {
        return "<%= candidate_languagelist.ClientID %>";
    }

    function getCandidateCountryID() {
        return "<%= candidate_nationality.ClientID %>";
    }

    function getCandidateOccupationID() {
        return "<%= candidate_occupation.ClientID %>";
    }

    function getBaptismChurchID() {
        return "<%= baptism_church.ClientID %>";
    }

    function getConfirmChurchID() {
        return "<%= confirmation_church.ClientID %>";
    }

    function getPreviousChurchID() {
        return "<%= previous_church_membership.ClientID %>";
    }

    function getBaptistByID() {
        return "<%= baptized_by.ClientID %>";
    }

    function getConfirmByID() {
        return "<%= confirm_by.ClientID %>";
    }

    function getCongregationID(){
        return "<%= candidate_congregation.ClientID %>";
    }

    function getMaritalStatusID(){
        return "<%= candidate_marital_status.ClientID %>";
    }

    function getSalutationID(){
        return "<%= candidate_salutation.ClientID %>";
    }

    function getDialectID(){
        return "<%=candidate_dialect.ClientID%>";
    }

    function getEducationID(){
        return "<%=candidate_education.ClientID%>";
    }

    function getInterestedMinistryID(){        
        return "<%=candidate_interested_ministry.ClientID%>";
    }

    function getSalutationValue() {
        return "<%= (string)ViewData["candidate_salutation"]%>";
    }
    function getGenderValue() {
        return "<%= (string)ViewData["candidate_gender"]%>";
    }
    function getDialectValue() {
        return "<%= (string)ViewData["candidate_dialect"]%>";
    }
    function getMaritalStatusValue() {
        return "<%= (string)ViewData["candidate_marital_status"]%>";
    }
    function getEducationValue() {
        return "<%= (string)ViewData["candidate_education"]%>";
    }
    function getLanguageValue() {
        return "<%= (string)ViewData["candidate_language"]%>";
    }

    function getChristianYesNo(){
        return "<%= (string)ViewData["candidate_christian_yes_no"] %>";
    }

    function getPhotoFilename(){
        return "<%= (string)ViewData["candidate_photo"] %>";
    }

    function getBaptizedBy(){
        return "<%= (string)ViewData["baptized_by"] %>";
    }

    function getBaptizedChurch(){
        return "<%= (string)ViewData["baptism_church"] %>";
    }

    function getConfirmationBy(){
        return "<%= (string)ViewData["confirmation_by"] %>";
    }

    function getConfirmationChurch(){
        return "<%= (string)ViewData["confirmation_church"] %>";
    }

    function getPreviousChurch(){
        return "<%= (string)ViewData["previous_church_membership"] %>";
    }

    function getCongregation(){
        return "<%= (string)ViewData["candidate_congregation"] %>";
    }

    function getFamilyList(){
        return "<%= Microsoft.JScript.GlobalObject.escape((string)ViewData["familylist"]) %>";
    }

    function getChildList(){
        return "<%= Microsoft.JScript.GlobalObject.escape((string)ViewData["childlist"]) %>";
    }

    function getAutoPostalCode(){
        return "Off"
    }

    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>"
    }

    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
    }

    function getJoinCellgroupYesNo(){
        return "<%= (string)ViewData["candidate_join_cellgroup"] %>";
    }

    function getServeCongregationYesNo(){
        return "<%= (string)ViewData["candidate_serve_congregation"] %>";
    }

    function getTithingYesNo(){
        return "<%= (string)ViewData["candidate_tithing"] %>";
    }

    function getSubmitURL(){
        return "<%= submitURL() %>";
    }
</script>

<div class="bodycss">
	<div style=" width:800px" id="form_container">
	
		<form AUTOCOMPLETE="off" runat="server" id="registration_form" class="appnitro"  method="post" action="<%=submitURL()%>" enctype="multipart/form-data">
		<input type="hidden" id="childlist" name="childlist" value="0">
		<input type="hidden" id="familylist" name="familylist" value="0">
		<input type="hidden" id="OriginalNRIC" name="OriginalNRIC" value="<%=(string)ViewData["candidate_nric"] %>">
        <div class="form_description">
			<h3>Diocese of Singapore Membership Registration</h3> <span style="color:red;"><%= (string)ViewData["errormsg"] %></span>
		</div>						
			<ul >
			
					
			<h4>Personal Information</h4>
		
        <table width="800" border="0">
        <tr>
            <td>
                <li id="li4" >
		                <label class="description" for="element_6">招呼<br>
                            Salutation <span style="color:red;">*</span></label>
		                <div>
                        <asp:DropDownList style=" width:100px" class="element select medium" OnLoad="loadSalutation" name="candidate_salutation" ID="candidate_salutation" runat="server">
                        </asp:DropDownList>		                
		                </div> 
		                </li>
            </td>
            <td>
                <li style="width:110px" id="li_1" >
		            <label class="description" for="element_1">
                        英文姓名<br>
                        Name in English <span style="color:red;">*</span></label>
		            <div>
			            <input style=" width:150px" id="candidate_english_name" name="candidate_english_name" class="element text medium" type="text" maxlength="50" value="<%= (string)ViewData["candidate_english_name"] %>" size="20"/> 
		            </div> 
		        </li>	
            </td>
            <td colspan="2" width="400">
                <li style="width:200px" id="li_2" >
		            <label class="description" for="element_2">
                    中文姓名<br>
                    Name in Chinese </label>
		            <div>
			            <input style=" width:150px" id="candidate_chinese_name" name="candidate_chinese_name" class="element text medium" type="text" maxlength="50" value="<%= (string)ViewData["candidate_chinses_name"] %>" size="20"/> 
		            </div> 
		        </li>
            </td>
        </tr>
        <tr>
            <td >
                <li id="li_356" >
		            <label class="description" for="element_3">出生日期<br>
                    Date of Birth <span style="color:red;">*</span></label>
                        <div>
                              <input readonly="readonly" style=" width:100px" id="candidate_dob" name="candidate_dob" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_dob"] %>" size="20"/> 
		                </div>
                    </li>
            </td>
            <td>
                    <li style="width:100px" id="li_6" >
		                <label class="description" for="element_6">性别<br>
                Gender <span style="color:red;">*</span></label>
		                <div>
		                <select style="width:100px" class="element select small" id="candidate_gender" name="candidate_gender"> 
			                <option value="" selected="selected"></option>
                            <option value="M" >Male</option>
                            <option value="F" >Female</option>
		                </select>
		                </div> 
		                </li>
            </td>

			<td colspan="2" width="400">
                <li style="width:200px" id="li_4" >
		            <label class="description" for="element_4">身份证号码<br>
            NRIC <span style="color:red;">*</span></label>
		            <div>
			            <input style=" width:150px" id="candidate_nric" name="candidate_nric" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_nric"] %>" size="20"/> 
		            </div> 
				</li>
            </td>
        </tr>
        <tr>
            <td colspan="1">
                <li id="li2" >
		            <label class="description" for="element_7">国籍<br>
            Nationality <span style="color:red;">*</span></label>
		            <div>
		                <asp:DropDownList style=" width:150px" class="element select medium" OnLoad="loadCountry" name="candidate_nationality" ID="candidate_nationality" runat="server">
                        </asp:DropDownList>
		            </div> 
		            </li>
            </td>
            <td colspan="1">
                <li style="width:100px" id="li3" >
		            <label class="description" for="element_7">籍贯<br>
            Dialect </label>
		            <div>
                        <asp:DropDownList  style=" width:150px" class="element select medium" OnLoad="loadDialect" name="candidate_dialect" ID="candidate_dialect" runat="server">
                        </asp:DropDownList>		                
		            </div> 
		            </li>
            </td>
            <td colspan="1" width="100px">
                <li style="width:105px" id="li1" >
		            <label class="description" for="element_7" nowarp="nowarp">已婚/未婚<br>
            Marital Status <span style="color:red;">*</span></label>
		            <div>
                    <asp:DropDownList  style=" width:130px" class="element select medium" OnLoad="loadmaritalstatus" name="candidate_marital_status" ID="candidate_marital_status" runat="server">
                    </asp:DropDownList>		            
		            </div> 
		            </li>

            </td>
            <td>
                <div id="marriagedatediv" style="display:none">
                    <li style="width:105px" id="li5" >
		                <label class="description" for="element_7" nowarp="nowarp">結婚日期<br>
                        Marriage Date <span style="color:red;">*</span></label>
		                <div>
		                    <input readonly="readonly" style=" width:100px" id="candidate_marriage_date" name="candidate_marriage_date" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_marriage_date"] %>" size="20"/> 
		                </div> 
		                </li>
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <li style="width:210px" id="li_5" >
		            <label class="description" for="element_5">地址<br>
            Address <span style="color:red;">*</span></label>
		            <div style=" width:100px" >
			            <input style=" width:100px" id="candidate_postal_code" name="candidate_postal_code" class="element text medium" maxlength="10" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["candidate_postal_code"] %>" type="text" size="20" >
			            <label class="makesmall" for="element_5_5">Postal Code</label>
		            </div>
                    <div class="left">
			            <input style=" width:100px"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" maxlength="6" value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
		                <label class="makesmall" for="element_5_6">BLK / House</label>
                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>"/>
		            </div>
		            <div class="right">
                        <input style=" width:100px" id="candidate_unit" name="candidate_unit" class="element text medium" maxlength="10" value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
			            <label class="makesmall" for="element_5_5">Unit #</label>
	                </div>
                    <div>
			            <input style=" width:350px" id="candidate_street_address" name="candidate_street_address" class="element text medium" value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
			            <label class="makesmall" for="element_5_1">Street Address</label>
                        <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["candidate_street_address"] %>" />
		            </div> 
		            </li>
            </td>            
        </tr>
		<tr>
            
        </tr>
        <tr>
            <td>
                <li id="li_19" >
		            <label class="description" for="element_19">电子邮件地址<br>
            Email </label>
		            <div>
			            <input style=" width:150px" id="candidate_email" name="candidate_email" class="element text medium" type="text" maxlength="100" value="<%= (string)ViewData["candidate_email"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
            <td>
                <li  id="li_16" >
		            <label class="description" for="element_16">教育程度<br>
            Education <span style="color:red;">*</span></label>
		            <div>
                    <asp:DropDownList style=" width:150px" class="element select medium" OnLoad="loadEducation" name="candidate_education" ID="candidate_education" runat="server">
                    </asp:DropDownList>
		            </div> 
		            </li>
            </td>
			<td colspan="2" width="400">
                <li style="width:200px" id="li_8" >
		            <label class="description" for="element_8">教育源流<br>
            Language(s) <span style="color:red;">*</span></label>
		            <div>
			            <asp:listBox SelectionMode="Multiple" style=" width:250px" class="multiple_select element select medium" OnLoad="loadLanguage" name="candidate_languagelist" ID="candidate_languagelist" runat="server">
                        </asp:listBox>
                        <input type="hidden" id="candidate_language" name="candidate_language" value="<%= (string)ViewData["candidate_language"] %>" />
		            </div> 
		            </li>
            </td>
        </tr>
        <tr>
            <td>
                <li style="width:180px" id="li_9" >
		            <label class="description" for="element_9">职业<br>
            Occupation <span style="color:red;">*</span></label>
		            <div>
                        <asp:DropDownList  style="width:150px" class="element select medium" OnLoad="loadOccpation" name="candidate_occupation" ID="candidate_occupation" runat="server">
                        </asp:DropDownList>
			            
		            </div> 
		            </li>
            </td>
			<td>
                <li style="width:150px" id="li_10" >
		            <label class="description" for="element_10">住家电话<br>
            Home Tel </label>
		            <div>
			            <input style=" width:150px" id="candidate_home_tel" name="candidate_home_tel" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_home_tel"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
            <td colspan="1">
                <li style="width:150px" id="li_11" >
		            <label class="description" for="element_11">手机号码<br>
            Mobile Tel </label>
		            <div>
			            <input style=" width:150px" id="candidate_mobile_tel" name="candidate_mobile_tel" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_mobile_tel"] %>" size="20"/> 
		            </div> 
		            </li>
            </td>
            <td colspan="1" >
                <li style="width:180px" id="li6" >
		            <label class="description" for="element_9">堂会<br>
                    Congregation <span style="color:red;">*</span></label>
		            <div>
                        <asp:DropDownList  style="width:150px" class="element select medium" OnLoad="loadCongregation" name="candidate_congregation" ID="candidate_congregation" runat="server">
                        </asp:DropDownList>
			            
		            </div> 
		            </li>
            </td>
        </tr>
        </table>
                        <li class="section_break">
                            <br />
			                <h3></h3>
			                <p></p>
		                </li>
        <table>
            <tr>
                <td style=" width:20px">
                    <input style=" width:20px" id="candidate_christian_yes_no" name="candidate_christian_yes_no" class="element text medium" type="checkbox" />
                </td>
                <td style=" width:100%">
                    <div style=" width:100%" class="right">
                        <label class="description" for="element_11" nowrap="nowrap">圣洗/坚振在其他教會？<br>
                        Baptized/Confirm in other church? </label>
                    </div>
                </td>
            </tr>
        </table>
        <div id="christian_yes_no" style="display:none">
            <table>
            <tr>
            <td>
                <li style="width:180px" id="li_12" >
		            <label class="description" for="element_12">圣洗礼日期<br>
                    Baptism Date </label>
                    <div>
		            <input style=" width:150px" id="candidate_baptism_date" name="candidate_baptism_date" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["candidate_baptism_date"] %>" size="20"/> 
		            </div>
                    </li>
            </td>
            <td>
                <li style="width:180px" id="li_14" >
		            <label class="description" for="element_14">主礼者<br>
            Baptised By </label>
		            <div>
			            <asp:DropDownList style="width:150px" name="baptized_by" onchange="changeBaptisedBy();" ID="baptized_by" runat="server">
                        </asp:DropDownList>
                        <br />
                        <input style="width:150px; display:none" value="<%=ViewData["baptized_by_others"] %>" class="element text medium" type="text" id="baptized_by_others" name="baptized_by_others" />
		            </div> 
		            </li>
            </td>
            <td>
                <li style="width:180px" id="li_39" >
		            <label class="description" for="element_39">教会<br>
            Church </label>
		            <div>
                        <asp:DropDownList style=" width:300px" onchange="changeBaptismChurch();" name="baptism_church" ID="baptism_church" runat="server">
                        </asp:DropDownList>
                        <input style="width:300px; display:none" value="<%=ViewData["baptism_church_others"] %>" class="element text medium" type="text" id="baptism_church_others" name="baptism_church_others" />
		            </div> 
		            </li>
            </td>
        </tr>
        </table>        		
            <table>
            <tr>
                <td>
                    <li style="width:180px" id="li_13" >
		                <label class="description" for="element_13">坚振礼日期<br>
                Confirmation Date </label>
		                <div>
		                    <input style=" width:150px" id="candidate_confirmation_date" name="candidate_confirmation_date" class="element text medium" type="text" maxlength="255" value="<%=(string)ViewData["candidate_confirmation_date"] %>" size="20"/> 
		                </div>
		 
		                </li>       
                </td>
                <td>
                    <li style="width:180px" id="li_15" >
		                <label class="description" for="element_15">主礼者<br>
                Confirmation By </label>
		                <div>
			                <asp:DropDownList OnLoad="loadClergy" style="width:150px" onchange="changeConfirmBy();" name="confirm_by" ID="confirm_by" runat="server">
                            </asp:DropDownList>
                            <input style="width:150px; display:none" value="<%=ViewData["confirm_by_others"] %>" class="element text medium" type="text" id="confirm_by_others" name="confirm_by_others" />
		                </div> 
		                </li>
                </td>
                <td>
                    <li style="width:180px" id="li_40" >
		                <label class="description" for="element_40">教会<br>
                Church </label>
		                <div>
                            <asp:DropDownList style="width:300px" onchange="changeConfirmChurch();" name="confirmation_church" ID="confirmation_church" runat="server">
                            </asp:DropDownList>
                            <input style="width:300px; display:none" value="<%=ViewData["confirmation_church_others"] %>" class="element text medium" type="text" id="confirmation_church_others" name="confirmation_church_others" />
		                </div> 
		                </li>
                </td>
            </tr>
        </table>	
            <table>
            <tr>
                <td>
                        <li id="li_17" >
		                <label style=" width:250px" class="description" for="element_17">搸属何教会之会友<br>
                Previous Church Membership </label>
		                <div>
                        <asp:DropDownList style=" width:350px" OnLoad="loadParish" onchange="changePreviousChurch();" name="previous_church_membership" ID="previous_church_membership" runat="server">
                        </asp:DropDownList>
		                <input style="width:350px; display:none" value="<%=ViewData["previous_church_membership_others"] %>" class="element text medium" type="text" id="previous_church_membership_others" name="previous_church_membership_others" />
		                </div> 
                        </li>
                </td>
                <td>
                        <li id="li_17" >
		                <label style=" width:250px" class="description" for="element_17">转会原因<br>
                        Transfer Reason </label>
		                <div>
                            <textarea id="candidate_transfer_reason" name="candidate_transfer_reason" cols="35"><%= (string)ViewData["candidate_transfer_reason"]%></textarea>
		                </div>
                        </li>
                </td>
            </tr>
        </table>	
        </div>
            
                        <li class="section_break">

			                <h3>&nbsp;</h3>
			                <p></p>
		                </li>
        		
			<h4>家庭信息<br>Family Information</h4>
		
        <table style="width:100%"  id="familytable">
            <tr>
                <td style="width:110px"><label class="description" for="element_21b" nowrap="nowrap">家属<br>Family </label>
                </td>
                <td style="width:130px"><label class="description" for="element_21b" nowrap="nowrap">英文姓名<br>Name in English </label>
                </td>
                <td style="width:130px"><label class="description" for="element_22b"  nowrap="nowrap">中文姓名<br>Name in Chinese </label>
                </td>
                <td style="width:130px"><label class="description" for="element_23b" nowrap="nowrap">职业<br>Occupation </label>
                </td>
                <td style="width:130px"><label class="description" for="element_2b1" nowrap="nowrap">所属教会/宗教<br>Church/Religion</label>
                </td>
				<td style="width:1px"><input type="button" onclick="addNewFamily('', '', '', '', '')" value="+" />
				</td>
            <tr>
        </table>	
		<li class="section_break">

			<h3>&nbsp;</h3>
			<p></p>
		</li>										


                                                
        <h4>Children Information</h4>
		
        <table style="width:100%" id="childtable">
            <tr>
                <td style="width:50px" nowrap="nowrap"><label class="description" for="element_211">Child </label>
                </td>
                <td style="width:110px" nowrap="nowrap"><label class="description" for="element_21a">英文姓名<br>Name in English </label>
                </td>
                <td style="width:110px" nowrap="nowrap"><label class="description" for="element_22a" >中文姓名<br>Name in Chinese </label>
                </td>
                <td style="width:110px" nowrap="nowrap"><label class="description" for="element_293a">受洗日期<br>Date of Baptism </label>
                </td>
                <td style="width:110px" nowrap="nowrap"><label class="description" for="element_23a">Baptized By </label>
                </td>
                <td style="width:110px" nowrap="nowrap"><label class="description" for="element_24a">教会<br>Church</label>
                </td>
				<td style="width:1px"><input type="button" onclick="addNewChild('','', '', '', '')" value="+" />
				</td>
            <tr>
            
        </table>
        
        <li class="section_break">

			<h3>&nbsp;</h3>
			<p></p>
		</li>
        <h4>Community / Serving</h4>
            <table style=" width:100%">
            <tr>
            <td>
                
                <table>
                    <tr>
                        <td style=" width:20px">
                            <input style=" width:20px" id="candidate_join_cellgroup" name="candidate_join_cellgroup" class="element text medium" type="checkbox" />
                        </td>
                        <td style=" width:100%">
                            <div style=" width:100%" class="right">
                                <label class="description" for="element_11" nowrap="nowrap">
                                Join a Cellgroup</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style=" width:20px">
                            <input style=" width:20px" id="candidate_serve_congregation" name="candidate_serve_congregation" class="element text medium" type="checkbox" />
                        </td>
                        <td style=" width:100%">
                            <div style=" width:100%" class="right">
                                <label class="description" for="element_11" nowrap="nowrap">
                                Serve in my congregation</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style=" width:20px">
                            <input style=" width:20px" id="candidate_tithing" name="candidate_tithing" class="element text medium" type="checkbox" />
                        </td>
                        <td style=" width:100%">
                            <div style=" width:100%" class="right">
                                <label class="description" for="element_11" nowrap="nowrap">
                                Be a Tithing Member</label>
                            </div>
                        </td>
                    </tr>
                </table>

            </td>            
            <td>
                <li style="width:180px" id="li9" >
		            <label class="description" for="element_12">
                    Join A Ministry</label>
                    <div>
                        <asp:listBox SelectionMode="Multiple" style=" width:250px" class="multiple_select_ministry element select medium" OnLoad="loadMinistry" name="candidate_interested_ministry" ID="candidate_interested_ministry" runat="server">
                        </asp:listBox>
                    </div>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $(".multiple_select_ministry").multiselect({ minWidth: 'auto', selectedList: 3, HideCheckAll: true, multiple: true, selectedText: "# of # selected" }).multiselectfilter();
                        });
                    </script>
                    </li>
            </td>            
        </tr>
        </table>

            
        	
					<li class="buttons">
			    <input type="hidden" name="form_id" value="305427" />
			    <% if(((string)ViewData["Type"]) == "ADD"){%>
				    <input id="saveForm" class="button_text" type="button" onclick="checkForm();" value="Submit" />
                <%}
                else if (((string)ViewData["Type"]) == "UPDATE"){
                %>
                    <input id="Submit1" class="button_text" type="submit" onclick="checkUpdateForm();" value="Re-Submit" />
                <% }%>
		</li>
			</ul>
		</form>
        <div style="width=100%" id="footer">
			St Andrew's Cathedral
		</div>	
	</div>
	</div>