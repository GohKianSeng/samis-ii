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

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/staffUpdateMembership.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/DOS_membership.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/staffUpdateMembership.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/DOS_membership.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.min.js"></script>
<%}%>

<script type="text/javascript" src="/Content/scripts/jquery.watermarkinput.min.js"></script>

<!-- history script   -->
<link rel="stylesheet" type="text/css" href="/Content/css/ITSCHistory.css" />
<script type="text/javascript" src="/Content/scripts/expand.min.js"></script>
<!-- history script   -->

<!-- datepicker script   -->
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>
<!-- datepicker script   -->

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

<!-- Fix header and sorter table scripts   -->
<link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
<script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
<!-- Fix header and sorter table scripts   -->    
<script language="C#" runat="server">
    
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
         
    void loadCountry(Object Sender, EventArgs e)
    {
        List<usp_getAllCountryResult> res = (List<usp_getAllCountryResult>)ViewData["countrylist"];
        ListItem item = new ListItem("", "");
        candidate_nationality.Items.Add(item);

        item = new ListItem("------------ South East Asia ------------", "-");
        item.Attributes.Add("disabled", "disabled");
        candidate_nationality.Items.Add(item);

        for (int x = 0; x < res.Count; x++)
        {
            if (x == 12)
            {
                item = new ListItem("----------- Others Countries -----------", "-");
                item.Attributes.Add("disabled", "disabled");
                candidate_nationality.Items.Add(item);
            }

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

    void loadEducation(Object Sender, EventArgs e)
    {
        List<usp_getAllEducationResult> res = (List<usp_getAllEducationResult>)ViewData["educationlist"];
        ListItem item = new ListItem("", "");
        candidate_education.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).EducationName, res.ElementAt(x).EducationID.ToString());
            if (((string)ViewData["candidate_education"]) == res.ElementAt(x).EducationID.ToString())
                item.Selected = true;
            candidate_education.Items.Add(item);
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

    void loadCellgroup(Object Sender, EventArgs e)
    {
        List<usp_getListofCellgroupResult> res = (List<usp_getListofCellgroupResult>)ViewData["cellgrouplist"];
        ListItem item = new ListItem("", "");
        candidate_cellgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CellgroupName, res.ElementAt(x).CellgroupID.ToString());
            if ((int)ViewData["candidate_cellgroup"] == (int)res.ElementAt(x).CellgroupID)
                item.Selected = true;
            candidate_cellgroup.Items.Add(item);
        }
    }

    void loadMinistry(Object Sender, EventArgs e)
    {
        List<usp_getListofMinistryResult> res = (List<usp_getListofMinistryResult>)ViewData["ministrylist"];
        ListItem item = new ListItem("", "");

        XElement xml = XElement.Parse((string)ViewData["candidate_ministry"]);
        string ministryid = "";
        for (int x = 0; x < xml.Elements("MinistryID").Count(); x++)
        {
            ministryid += xml.Elements("MinistryID").ElementAt(x).Value + ",";
        }
        ministryid = "," + ministryid;
        
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).MinistryName, res.ElementAt(x).MinistryID.ToString());
            if (ministryid.Contains("," + res.ElementAt(x).MinistryID.ToString() + ","))
                item.Selected = true;
            candidate_ministry.Items.Add(item);
        }
    }

    void loadCourses(Object Sender, EventArgs e)
    {
        ListItem item = new ListItem("", "");
        XElement xml = XElement.Parse((string)ViewData["candidate_courses"]);
        string courseid = "";
        for (int x = 0; x < xml.Elements("CourseName").Count(); x++)
        {
            if (x == 0)
            {
                item = new ListItem("","0");
                item.Selected = true;
                candidate_courses.Items.Add(item);
            }
            item = new ListItem(xml.Elements("CourseName").ElementAt(x).Value, xml.Elements("CourseID").ElementAt(x).Value);
            candidate_courses.Items.Add(item);
        }
        courseid = "," + courseid;
    }

    void loadFileType(Object Sender, EventArgs e)
    {
        List<usp_getAllFileTypeResult> res = (List<usp_getAllFileTypeResult>)ViewData["filetypelist"];
        ListItem item = new ListItem("", "");
        candidate_FileType.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).FileType, res.ElementAt(x).FileTypeID.ToString());
            candidate_FileType.Items.Add(item);
        }
    }
    
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
</script>

<script type="text/javascript">
    
    function getDateRangeString(){
        return '<%=DateTime.Now.Year - 100%>:<%=DateTime.Now.Year%>';
    }

    function OccupationOptionString(){
        return '<%= getOccupationString()%>';
    }

    function FamilyTypeOptionString(){
        return '<%= getFamilyTypeString()%>';
    }

    function ReligionOptionString(){
        return '<%= getReligionString()%>';
    }

    function ParishOptionString(){
        return '<%= getParishString()%>';
    }

    function isOffline(){
        return false;
    }

    function canUpdate(){
        return "<%= canAccess("Update Member")%>";
    }

    function getSubmitURL(){
        return "<%= submitURL()%>";
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
        return "candidate_dialect.ClientID";
    }

    function getEducationID(){
        return "<%= candidate_education.ClientID %>";
    }

    function getFileTypeID(){
        return "<%= candidate_FileType.ClientID%>";
    }

    function getCourseID(){
        return document.getElementById("<%= candidate_courses.ClientID %>");
    }

    function getNRIC(){
        return "<%= (string)ViewData["candidate_nric"] %>";
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
        return "<%=(string)Session["AutoPostalCode"] %>"
    }

    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>"
    }
    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
    }   

    function getJoinCellgroupYesNo(){
        return "";
    }

    function getServeCongregationYesNo(){
        return "";
    }

    function getTithingYesNo(){
        return "";
    }

    function getAcceptedFile(){
        return "<%= (string)Session["AcceptableFile"] %>";
    }

    function getSystemMode(){
        <%if(Page.User.Identity.IsAuthenticated){ %>
            return "FULL";
        <%}else{ %>
            return "<%=((string)Session["SystemMode"]).ToUpper() %>";
        <%} %>
    }
</script>

<form AUTOCOMPLETE="off" id="registration_form" action="/membership.mvc/submitUpdateMemberForm" enctype="multipart/form-data" runat="server">
    <input type="hidden" id="OriginalNric" name="OriginalNric" value="<%= (string)ViewData["candidate_nric"] %>">
    <input type="hidden" id="childlist" name="childlist" value="0">
	<input type="hidden" id="familylist" name="familylist" value="0">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Personal Infomation</a></li>
            <li><a href="#tab2">Baptism/Confirmation</a></li>
            <li><a href="#tab3">Family Members</a></li>
            <li><a href="#tab4">Children</a></li>
            <li><a href="#tab5">Others</a></li>
            <li><a href="#tab7">File Attachment</a></li>
            <li><a href="#tab6">History</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            
		                    <label class="description" for="element_6">
                                Salutation <span style="color:red;">*</span></label>
		                    <div>
                            <asp:DropDownList style=" width:80%" class="element select small" OnLoad="loadSalutation" name="candidate_salutation" ID="candidate_salutation" runat="server">
                            </asp:DropDownList>			                    
		                    </div> 
		                            
                        </td>
                        <td>
                            <label class="description" for="element_1">
                                
                                Name in English <span style="color:red;">*</span></label>
		                    <div>
			                    <input style=" width:80%" id="candidate_english_name" name="candidate_english_name" class="element text medium" type="text"<%=getTextfieldLength("tb_members","EnglishName")%> value="<%= (string)ViewData["candidate_english_name"] %>" size="20"/> 
		                    </div> 
		                    
                        </td>

                        <td >
                            <label class="description" for="element_2">
                                
                                Name in Chinese </label>
		                        <div>
			                        <input style=" width:80%" id="candidate_chinese_name" name="candidate_chinese_name" class="element text medium" type="text" <%=getTextfieldLength("tb_members","ChineseName")%> value="<%= (string)ViewData["candidate_chinses_name"] %>" size="20"/> 
		                        </div> 		                    
                        </td>
                        <td width="200">
                            <label class="description" for="element_4">
                            NRIC <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:150px" id="candidate_nric" readonly="readonly" name="candidate_nric" class="element text medium" type="text" <%=getTextfieldLength("tb_members","NRIC")%> value="<%= (string)ViewData["candidate_nric"] %>" size="20"/> 
		                        </div>                      
                        </td>
                    </tr>
                    <tr>
                        <td >
                            <label class="description" for="element_6">
                            Gender <span style="color:red;">*</span></label>
		                            <div>
		                            <select style="width:80%" class="element select small" id="candidate_gender" name="candidate_gender"> 
			                            <option value="" selected="selected"></option>
                                        <option value="M" >Male</option>
                                        <option value="F" >Female</option>
		                            </select>
		                            </div> 
		                        
                                
                        </td>
                        <td>
                                <label class="description" for="element_3">
                                Date of Birth <span style="color:red;">*</span></label>
                                    <div>
                                          <input readonly="readonly" style=" width:80%" id="candidate_dob" name="candidate_dob" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["candidate_dob"] %>" size="20"/> 
		                            </div>
                        </td>

			            <td>
                             <label class="description" for="element_7" nowarp="nowarp">
                                 Marital Status <span style="color:red;">*</span></label>
		                        <div>
		                        <asp:DropDownList  style=" width:80%" class="element select medium" OnLoad="loadmaritalstatus" name="candidate_marital_status" ID="candidate_marital_status" runat="server">
                                </asp:DropDownList>                                
		                        </div>
                        </td>
                        <td>
                             <div id="marriagedatediv" style="display:none">
                                
		                            <label class="description" for="element_7" nowarp="nowarp">
                                    Marriage Date <span style="color:red;">*</span></label>
		                            <div>
		                                <input readonly="readonly" style=" width:100px" id="candidate_marriage_date" name="candidate_marriage_date" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["candidate_marriage_date"] %>" size="20"/> 
		                            </div> 
		                            
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="description" for="element_7">
                                Nationality <span style="color:red;">*</span></label>
		                        <div>
		                            <asp:DropDownList  style=" width:80%" class="element select medium" OnLoad="loadCountry" name="candidate_nationality" ID="candidate_nationality" runat="server">
                                    </asp:DropDownList>
		                        </div>
                        </td>
                        <td colspan="1">
                            
		                        <label class="description" for="element_7">
                                Dialect </label>
		                        <div>
                                    <asp:DropDownList  style=" width:80%" class="element select small" OnLoad="loadDialect" name="candidate_dialect" ID="candidate_dialect" runat="server">
                                    </asp:DropDownList>		                            
		                        </div> 
		                        
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
			                        <input style=" width:80%" id="candidate_home_tel" name="candidate_home_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_members","HomeTel")%> value="<%= (string)ViewData["candidate_home_tel"] %>" size="20"/> 
		                        </div> 
		                        
		                        
                        </td>
                        <td>
                            
		                        <label class="description" for="element_19">
                        Email </label>
		                        <div>
			                        <input style=" width:80%" id="candidate_email" name="candidate_email" class="element text medium" type="text"<%=getTextfieldLength("tb_members","Email")%> value="<%= (string)ViewData["candidate_email"] %>" size="20"/> 
		                        </div> 
		                        
                        </td>
			            <td >
                            
		                        <label class="description" for="element_8">
                        Language(s) <span style="color:red;">*</span></label>
		                        <div>
			                        <asp:listBox SelectionMode="Multiple" style=" width:200px" class="multiple_select element select medium" OnLoad="loadLanguage" name="candidate_languagelist" ID="candidate_languagelist" runat="server">
                                    </asp:listBox>
                                    <input type="hidden" id="candidate_language" name="candidate_language" value="<%= (string)ViewData["candidate_language"] %>" />
		                        </div> 
		                        
                        </td>
                        <td>
                            <label class="description" for="element_8">Car IU No#</label>
                            <div>
			                        <input style=" width:80%" id="candidate_cariu" name="candidate_cariu" class="element text medium" type="text" <%=getTextfieldLength("tb_members","CarIU")%> value="<%= (string)ViewData["candidate_cariu"] %>" size="20"/> 
		                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td style=" width:20%">
                           
		                     <label class="description" for="element_11">
                        Mobile Tel </label>
		                        <div>
			                        <input style=" width:80%" id="candidate_mobile_tel" name="candidate_mobile_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_members","MobileTel")%> value="<%= (string)ViewData["candidate_mobile_tel"] %>" size="20"/> 
		                        </div>    
		                        
                        </td>
			            <td>


                                <label class="description" for="element_16">
                                Education <span style="color:red;">*</span></label>
		                                <div>
                                        <asp:DropDownList style=" width:80%" class="element select medium" OnLoad="loadEducation" name="candidate_education" ID="candidate_education" runat="server">
                                        </asp:DropDownList>		                        
		                        
		                        </div> 
                            
		                        
		                        
                        </td>
                        <td style="width:200px">
                            
                            <label class="description" for="element_9">
                        Occupation <span style="color:red;">*</span></label>
		                        <div>
                                    <asp:DropDownList  style="width:80%" class="element select medium" OnLoad="loadOccpation" name="candidate_occupation" ID="candidate_occupation" runat="server">
                                    </asp:DropDownList>
			            
		                        </div> 


		                        
		                        
                        </td>
                        <td colspan="1" >
                            
		                        <label class="description" for="element_9">
                                Congregation <span style="color:red;">*</span></label>
		                        <div>
                                    <asp:DropDownList  style="width:150px" class="element select medium" OnLoad="loadCongregation" name="candidate_congregation" ID="candidate_congregation" runat="server">
                                    </asp:DropDownList>
			            
		                        </div> 
		                        
                        </td>
                    </tr>
                    </table>
            </div>
            <div id="tab2" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                    <td>
                            <label class="description" for="element_12">
                            Baptism Date </label>
                            <div>
		                    <input style=" width:150px" id="candidate_baptism_date" name="candidate_baptism_date" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["candidate_baptism_date"] %>" size="20"/> 
		                    </div>                            
                    </td>
                    <td>
                        
		                    <label class="description" for="element_14">
                    Baptised By </label>
		                    <div>
			                    <asp:DropDownList style="width:150px" name="baptized_by" onchange="changeBaptisedBy();" ID="baptized_by" runat="server">
                                </asp:DropDownList>
                                <input style="width:150px; display:none" value="<%=ViewData["baptized_by_others"] %>" class="element text medium" <%=getTextfieldLength("tb_members","BaptismByOthers")%> type="text" id="baptized_by_others" name="baptized_by_others" />
		                    </div> 
		                    
                    </td>
                    <td>
                        
		                    <label class="description" for="element_39">
                            Church </label>
		                    <div>
                                <asp:DropDownList style=" width:300px" name="baptism_church" onchange="changeBaptismChurch();" ID="baptism_church" runat="server">
                                </asp:DropDownList>
                                <input style="width:300px; display:none" value="<%=ViewData["baptism_church_others"] %>" class="element text medium" <%=getTextfieldLength("tb_members","BaptismChurchOthers")%> type="text" id="baptism_church_others" name="baptism_church_others" />
		                    </div> 
		                    
                    </td>
                </tr>
                    <tr>
                    <td>
                        
		                    <label class="description" for="element_13">
                    Confirmation Date </label>
		                    <div>
		                        <input style=" width:150px" id="candidate_confirmation_date" name="candidate_confirmation_date" class="element text medium" type="text" maxlength="10" value="<%=(string)ViewData["candidate_confirmation_date"] %>" size="20"/> 
		                    </div>
		 
		                          
                    </td>
                    <td>
                        
		                    <label class="description" for="element_15">
                    Confirmation By </label>
		                    <div>
			                    <asp:DropDownList OnLoad="loadClergy" style="width:150px" onchange="changeConfirmBy();" name="confirm_by" ID="confirm_by" runat="server">
                                </asp:DropDownList>
                                <input style="width:150px; display:none" value="<%=ViewData["confirm_by_others"] %>" class="element text medium" type="text" <%=getTextfieldLength("tb_members","ConfirmByOthers")%> id="confirm_by_others" name="confirm_by_others" />
		                    </div> 
		                    
                    </td>
                    <td>
                        
		                    <label class="description" for="element_40">
                    Church </label>
		                    <div>
                                <asp:DropDownList style="width:300px" onchange="changeConfirmChurch();" name="confirmation_church" ID="confirmation_church" runat="server">
                                </asp:DropDownList>
                                <input style="width:300px; display:none" value="<%=ViewData["confirmation_church_others"] %>" class="element text medium" <%=getTextfieldLength("tb_members","ConfirmChurchOthers")%> type="text" id="confirmation_church_others" name="confirmation_church_others" />
		                    </div> 
		                    
                    </td>
                </tr>
                    <tr>
                        <td colspan="2">
                                
		                        <label style=" width:250px" class="description" for="element_17">
                        Previous Church Membership </label>
		                        <div>
                                <asp:DropDownList style=" width:350px" OnLoad="loadParish" onchange="changePreviousChurch();" name="previous_church_membership" ID="previous_church_membership" runat="server">
                                </asp:DropDownList>
		                        <input style="width:350px; display:none" value="<%=ViewData["previous_church_membership_others"] %>" class="element text medium" type="text" <%=getTextfieldLength("tb_members","PreviousChurchOthers")%> id="previous_church_membership_others" name="previous_church_membership_others" />
		                        </div> 
                        </td>
                        <td>
                                <label style=" width:250px" class="description" for="element_17">Reason for Transfer</label>
		                        <div>
                                    <textarea class="element text medium" id="candidate_transfer_reason" name="candidate_transfer_reason" <%=getTextfieldLength("tb_members","TransferReason")%> cols="30" rows="5"><%= (string)ViewData["candidate_transfer_reason"] %></textarea>
                                </div> 
                        </td>
                    </tr>
                </table> 
            </div>
            <div id="tab3" class="tab_content">
                <table class="dottedview" cellspacing="0" style="width:100%"  id="familytable">
                <tr>
                    <td style="width:110px"><label class="description" for="element_21b" nowrap="nowrap">Family </label>
                    </td>
                    <td style="width:130px"><label class="description" for="element_21b" nowrap="nowrap">Name in English </label>
                    </td>
                    <td style="width:130px"><label class="description" for="element_22b"  nowrap="nowrap">Name in Chinese </label>
                    </td>
                    <td style="width:130px"><label class="description" for="element_23b" nowrap="nowrap">Occupation </label>
                    </td>
                    <td style="width:130px"><label class="description" for="element_2b1" nowrap="nowrap">Religion</label>
                    </td>
				    <td style="width:1px"><img onclick="addNewFamily('', '', '', '', '')" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/>
				    </td>
                <tr>
                </table>
            </div>
            <div id="tab4" class="tab_content">
                <table class="dottedview" cellspacing="0" style="width:100%" id="childtable">
                    <tr>
                        <td style="width:50px" nowrap="nowrap"><label class="description" for="element_211">Child </label>
                        </td>
                        <td style="width:110px" nowrap="nowrap"><label class="description" for="element_21a">Name in English </label>
                        </td>
                        <td style="width:110px" nowrap="nowrap"><label class="description" for="element_22a" >Name in Chinese </label>
                        </td>
                        <td style="width:110px" nowrap="nowrap"><label class="description" for="element_293a">Date of Baptism </label>
                        </td>
                        <td style="width:110px" nowrap="nowrap"><label class="description" for="element_23a">Baptized By </label>
                        </td>
                        <td style="width:110px" nowrap="nowrap"><label class="description" for="element_24a">Church</label>
                        </td>
				        <td style="width:1px"><img onclick="addNewChild('','', '', '', '')" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/>
				        </td>
                    <tr>
            
                </table>
            </div>
            <div id="tab5" class="tab_content">
                <table class="dottedview" cellspacing="0" style="width:100%"  id="Table1">
                <tr>
                    <td style="width:110px">
                        <label class="description" for="element_12">
                            Sponsor 1 </label>
                            <div>
                                <input type="hidden" id="candidate_sponsor1" name="candidate_sponsor1" value="<%= (string)ViewData["sponsor1"]%>" />
		                        <input onkeyup="searchSuggest(1000, 'candidate_sponsor1_text', 'search_suggest_sponsor1', 'candidate_sponsor1');" style=" width:250px" id="candidate_sponsor1_text" name="candidate_sponsor1_text" class="element text medium" type="text" <%=getTextfieldLength("tb_members","EnglishName")%> value="<%= (string)ViewData["sponsor1_input"] %>" size="20"/> 
		                        <div id="search_suggest_sponsor1" style="border:1px solid black; background-color:White; position:absolute; z-index:99999; display:none; height:200px; overflow:auto; width:370px"></div>
                            </div>
                    </td>
                    <td style="width:110px">
                        <label class="description" for="element_12">
                            Sponsor 2 </label>
                            <div>
                                <input style=" width:250px" id="candidate_sponsor2" name="candidate_sponsor2" class="element text medium" type="text" <%=getTextfieldLength("tb_membersOtherInfo_temp","Sponsor2")%> value="<%= (string)ViewData["sponsor2"] %>" size="20"/> 		                        
                            </div><br />
                             
                    </td>
                </tr>
                <tr>
                    <td style="width:110px">
                        <label class="description" for="element_121">
                            Membership Transfer To </label>
                            <div>
                                <input type="text" id="candidate_transferto" <%=getTextfieldLength("tb_membersOtherInfo_temp","TransferTo")%> name="candidate_transferto" value="<%= (string)ViewData["candidate_transferto"]%>" />
		                    </div>
                    </td>
                    <td style="width:110px">
                        <label class="description" for="element_12">
                        Sponsor 2 Contact </label>
                        <div>
                            <input style=" width:250px" id="candidate_sponsor2contact" name="candidate_sponsor2contact" class="element text medium" type="text" <%=getTextfieldLength("tb_membersOtherInfo_temp","Sponsor2Contact")%> value="<%= (string)ViewData["sponsor2contact"] %>" size="20"/> 		                        
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="width:110px">
                         <label class="description" for="element_12">
                            Electoral Roll Date </label>
                            <div>
		                    <input style=" width:150px" id="candidate_electoralroll_date" name="candidate_electoralroll_date" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["candidate_electoralroll_date"] %>" size="20"/> 
		                    </div>
                    </td>
                    <td style="width:110px">
                        <label class="description" for="element_142">
                            Membership Transfer To Date </label>
                            <div>
                                 <input type="text" id="candidate_transfertodate" name="candidate_transfertodate" maxlength="10" value="<%= (string)ViewData["candidate_transfertodate"]%>" />
			                </div> 
                    </td>
                </tr>
                <tr>
                    <td style="width:110px">
                        <label class="description" for="element_12">
                            Ministry Involved </label>
                            <div>
		                        <asp:listBox SelectionMode="Multiple" style=" width:250px" class="multiple_select_ministry element select medium" OnLoad="loadMinistry" name="candidate_ministry" ID="candidate_ministry" runat="server">
                                </asp:listBox>
                            </div>   
                    </td>
                    <td style="width:130px">
                        <label style=" width:250px" class="description" for="element_17">
                        Cellgroup</label>
		                        <div>
                                <asp:DropDownList style=" width:150px" OnLoad="loadCellgroup" name="candidate_cellgroup" ID="candidate_cellgroup" runat="server">
                                </asp:DropDownList>
		
		                        </div> 
                    </td>
                </tr>
                <tr>
                    <td rowspan="3" style="width:110px">
                        <label style=" width:250px" class="description" for="element_17">
                        Courses Attended (Display Only)</label>
		                    <div>
                                <asp:dropdownlist style=" width:250px" class="single_select_course element select medium" OnLoad="loadCourses" name="candidate_courses" ID="candidate_courses" onchange="changeCourse();" runat="server">
                                </asp:dropdownlist>
		                    </div>
                            <div style=" height:180px; overflow:auto">
                            Attendance &nbsp;<label id="AttendancePercentage"></label><br />
                         
                            <table border="1" id="MemberCaseTable" style=" width:50%; padding:0; margin-left:0%; margin-right:0%;">
			                    <thead>
			                        <tr class="header">
                                        <th width=8% nowrap="nowrap" style="font-size:12px">Date</th>
				                        <th width=3% nowrap="nowrap" style="font-size:12px">Attended</th>				        
                                    </tr>
		                        </thead>
		                        <tbody>
			                    
		                        </tbody>
		                    </table>
                        </div>    
                    </td>
                     <td style="width:110px">
                        <label class="description" for="element_12">
                            Deceased Date </label>
                            <div>
		                        <input style=" width:150px" id="candidate_DeceasedDate" name="candidate_DeceasedDate" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["DeceasedDate"] %>" size="20"/> 
                            </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Church Member as of <br />
                        <input type="text" class="element text medium" id="candidate_MemberDate" maxlength="10" name="candidate_MemberDate" value="<%= (string)ViewData["MemberDate"] %>"/>
                            
                    </td>
                </tr>
                <tr>
                    <td>
                        Remarks <br />
                        <textarea class="element text medium" id="candidate_remarks" name="candidate_remarks" cols="30" rows="5"><%= (string)ViewData["Remarks"] %></textarea>                        
                    </td>
                </tr>
                </table>
            </div>
            <div id="tab7" class="tab_content">
                <table class="dottedview" cellspacing="0" style="width:100%"  id="Table2">
                    <tr>
                        <td style="width:20%">
                            <label class="description" for="element_121">
                            File Type </label>
                            <div>
                                <asp:DropDownList style=" width:100%" OnLoad="loadFileType" name="candidate_FileType" ID="candidate_FileType" runat="server">
                                </asp:DropDownList>
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_121">
                            Remarks </label>
                            <div>
                                <input style=" width:100%" type="text" <%=getTextfieldLength("tb_members_attachments","Remarks")%> id="fileRemarks" name="fileRemarks" />
                            </div>
                        </td>
                        <td>
                            <label class="description" for="element_121">
                            File </label>
                            <div>
                                <input type="file" id="candidate_Filename" name="candidate_Filename" />
                            </div>
                        </td>
                    </tr>
                </table>

                <table border=1 id="fileAttachment" style=" width:100%; padding:0; margin-left:0%; margin-right:0%;">
			        <thead>
			            <tr class="header">
                            <th width="1%" nowrap="nowrap" style="font-size:12px">&nbsp;</th>
                            <th width="3%" nowrap="nowrap" style="font-size:12px">Date Uploaded</th>
				            <th width="17%" nowrap="nowrap" style="font-size:12px">File Type</th>
                            <th width="60%" nowrap="nowrap" style="font-size:12px">Remarks</th>
                            <th width="30%" nowrap="nowrap" style="font-size:12px">File Name</th>				        
                        </tr>
		            </thead>
		            <tbody>
			        </tbody>
		        </table>
            </div>
            <div id="tab6" class="tab_content">
                <div id="HistoryWrapper"> 
      		        <div id="HistoryContent">  
          		        <div class="HistoryDiv">
                            <% 
                                XElement history = (XElement)ViewData["history"];
                                if (history != null)
                                {
                                    for (int x = 0; x < history.Elements("row").Count(); x++)
                                    {
                                        XElement row = history.Elements("row").ElementAt(x);
                                        if (row.Element("Description").Value == "New")
                                        {
                                            %>
                                                <h3 class="expand">Created by <%= row.Element("ActionBy").Value%> @ <%= row.Element("ActionTime").Value%></h3>
            			                        <div class="collapse">
					                                <table class="HistoryTable">
						                                <tr style=" font-size:12px">
                                                            <td>NRIC:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("NRIC").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Name:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("SalutationName").Value + " " + row.Element("UpdatedElements").Element("row").Element("EnglishName").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Gender:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Gender").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Date of Birth:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("DOB").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Address:</td>
                                                            <% if (row.Element("UpdatedElements").Element("row").Element("AddressUnit").Value.Length > 0)
                                                               {%>
                                                                    <td><pre><%= row.Element("UpdatedElements").Element("row").Element("AddressHouseBlk").Value + " " + row.Element("UpdatedElements").Element("row").Element("AddressStreet").Value + "\n" + row.Element("UpdatedElements").Element("row").Element("AddressUnit").Value + "\nSingapore " + row.Element("UpdatedElements").Element("row").Element("AddressPostalCode").Value%></pre></td>
                                                            <% }
                                                               else
                                                               {%>
                                                                    <td><pre><%= row.Element("UpdatedElements").Element("row").Element("AddressHouseBlk").Value + " " + row.Element("UpdatedElements").Element("row").Element("AddressStreet").Value + "\nSingapore " + row.Element("UpdatedElements").Element("row").Element("AddressPostalCode").Value%></pre></td>
                                                               <%}   
                                                            %>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Nationality:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Nationality").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Congregation:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Congregation").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Occupation:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Occupation").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>MaritalStatus:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("MaritalStatus").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Education:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Education").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Language:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Language").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Sponsor1:</td>
                                                            <td><% if(row.Element("UpdatedElements").Element("row").Element("Sponsor1") != null){%>
                                                                   <%= row.Element("UpdatedElements").Element("row").Element("Sponsor1").Value%>
                                                                <%} %>
                                                            </td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Sponsor2:</td>
                                                            <td><% if(row.Element("UpdatedElements").Element("row").Element("Sponsor2") != null){%>
                                                                   <%= row.Element("UpdatedElements").Element("row").Element("Sponsor2").Value%>
                                                                <%} %>
                                                            
                                                            </td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Sponsor2 Contact:</td>
                                                            <td><% if(row.Element("UpdatedElements").Element("row").Element("Sponsor2Contact") != null){%>
                                                                   <%= row.Element("UpdatedElements").Element("row").Element("Sponsor2Contact").Value%>
                                                                <%} %>
                                                            
                                                            </td>
                                                        </tr>
                                                        <!--tr style=" font-size:12px">
                                                            <td>Photo:</td>
                                                            <% 
                                                                //string res = row.Element("UpdatedElements").Element("row").Element("ICPhoto").Value;
                                                                //string[] ind = res.Split('_');
                                                                //string url = "/uploadfile.mvc/downloadPhoto?guid=" + ind[0] + "&filename=" + ind[1] + "&random=" + DateTime.Now.Millisecond.ToString();
                                            
                                                            %>
                                                            <td><img id="Img1" src="" width="128" height="164" /></td>
                                                        </tr-->                                                        
					                                </table>
            			                        </div>
                                            <%
                                        }
                                        else if (row.Element("Description").Value == "Update")
                                        {
                                            %>
                                                <h3 class="expand">Updated by <%= row.Element("ActionBy").Value%> @ <%= row.Element("ActionTime").Value%></h3>
            			                        <div class="collapse">
					                                <table class="HistoryTable">
						                                <% 
                                                            XElement update = row.Element("UpdatedElements").Element("Changes");
                                                            if (update.Element("FromTo") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("FromTo").Elements("Changes").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td><%= update.Element("FromTo").Elements("Changes").ElementAt(y).Element("ElementName").Value%>:</td>
                                                                        <td><%= update.Element("FromTo").Elements("Changes").ElementAt(y).Element("To").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("AttachmentRemoved") != null)
                                                            {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Attachment Removed</td>
                                                                        <td><a href="/uploadfile.mvc/downloadAttachment?guid=<%= update.Element("AttachmentRemoved").Element("GUID").Value%>&filename=<%= update.Element("AttachmentRemoved").Element("filename").Value%>"><%= update.Element("AttachmentRemoved").Element("filename").Value%></a></td>
                                                                    </tr>
                                                                <%                                                                
                                                                
                                                            }
                                                            if (update.Element("FileAdded") != null)
                                                            {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Attachment Added</td>
                                                                        <td><a href="/uploadfile.mvc/downloadAttachment?guid=<%= update.Element("FileAdded").Element("AttachmentAdded").Element("GUID").Value%>&filename=<%= update.Element("FileAdded").Element("AttachmentAdded").Element("filename").Value%>"><%= update.Element("FileAdded").Element("AttachmentAdded").Element("filename").Value%></a></td>
                                                                    </tr>
                                                                <%                                                                
                                                                
                                                            }
                                                            if (update.Element("ChileAdded") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("ChileAdded").Elements("Child").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Child Added:</td>
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildEnglishName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Chinese Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildChineseName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism Date:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildBaptismDate").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism By:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildBaptismBy").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism Church:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildChurch").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("ChildRemoved") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("ChildRemoved").Elements("Child").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Child Removed:</td>
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildEnglishName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Chinese Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildChineseName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism Date:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildBaptismDate").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism By:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildBaptismBy").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Baptism Church:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildChurch").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("FamilyAdded") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("FamilyAdded").Elements("Family").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Family Added:</td>
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Family Type</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyType").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">English Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyEnglishName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Chinese Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyChineseName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Occupation:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyOccupation").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Religion:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyReligion").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("FamilyRemoved") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("FamilyRemoved").Elements("Family").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Family Removed:</td>
                                                                        <td></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Family Type</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyType").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">English Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyEnglishName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Chinese Name:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyChineseName").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Occupation:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyOccupation").Value%></td>
                                                                    </tr>
                                                                    <tr style=" font-size:10px">
                                                                        <td style="padding-left:20px">Religion:</td>
                                                                        <td style="padding-left:20px"><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyReligion").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("MinistryInterestedRemoved") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("MinistryInterestedRemoved").Elements("MinistryInterested").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Ministry Interested Removed:</td>
                                                                        <td><%= update.Element("MinistryInterestedRemoved").Elements("MinistryInterested").ElementAt(y).Element("MinistryName").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("MinistryInterestedAdded") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("MinistryInterestedAdded").Elements("MinistryInterested").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Ministry Interested Added:</td>
                                                                        <td><%= update.Element("MinistryInterestedAdded").Elements("MinistryInterested").ElementAt(y).Element("MinistryName").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("MinistryRemoved") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("MinistryRemoved").Elements("Ministry").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Ministry Removed:</td>
                                                                        <td><%= update.Element("MinistryRemoved").Elements("Ministry").ElementAt(y).Element("MinistryName").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                            if (update.Element("MinistryAdded") != null)
                                                            {
                                                                for (int y = 0; y < update.Element("MinistryAdded").Elements("Ministry").Count(); y++)
                                                                {
                                                                %>
                                                                    <tr style=" font-size:10px">
                                                                        <td>Ministry Added:</td>
                                                                        <td><%= update.Element("MinistryAdded").Elements("Ministry").ElementAt(y).Element("MinistryName").Value%></td>
                                                                    </tr>
                                                                <%                                                                
                                                                }
                                                            }
                                                        %>                                                        
					                                </table>
            			                        </div>
                                            <%
                                        }
                                    }
                                }
                                
                            %> 
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
        <%if (((string)ViewData["UpdateType"]).ToString() == "Actual"){ %>
            <table width="100%">
                <tr>
                    <td><a href="#"><img border="0" onclick="printGreenForm('<%= (string)ViewData["candidate_nric"] %>');" src="/Content/images/printgreenform.jpg" title="View Green Form" /></a></td>
                    <td><a href="#"><img border="0" onclick="printElectoralRoll('<%= (string)ViewData["candidate_nric"] %>');" src="/Content/images/printelectoralroll.png" title="View Electoral Roll" /></a></td>
                    <td><a href="#"><img border="0" onclick="printTransferForm('<%= (string)ViewData["candidate_nric"] %>');" src="/Content/images/transfericon.png" title="View Transform Form"/></a></td>
                </tr>
            </table>          
        <%} %>
    </div>     
    </div>
          
    </form>
        
</asp:Content>