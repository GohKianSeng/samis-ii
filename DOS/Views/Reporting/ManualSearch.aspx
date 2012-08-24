<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Manual Search
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
<%}%>

<script language="C#" runat="server">
    void loadmaritalstatus(Object Sender, EventArgs e)
    {
        List<usp_getAllMaritalStatusResult> res = (List<usp_getAllMaritalStatusResult>)ViewData["maritalstatuslist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_marital_status.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).MaritalStatusName, res.ElementAt(x).MaritalStatusID.ToString());
            candidate_marital_status.Items.Add(item);
        }
    }

    void loadCountry(Object Sender, EventArgs e)
    {
        List<usp_getAllCountryResult> res = (List<usp_getAllCountryResult>)ViewData["countrylist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_nationality.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CountryName, res.ElementAt(x).CountryID.ToString());
            candidate_nationality.Items.Add(item);
        }
    }

    void loadDialect(Object Sender, EventArgs e)
    {
        List<usp_getAllDialectResult> res = (List<usp_getAllDialectResult>)ViewData["dialectlist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_dialect.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).DialectName, res.ElementAt(x).DialectID.ToString());
            candidate_dialect.Items.Add(item);
        }
    }

    void loadEducation(Object Sender, EventArgs e)
    {
        List<usp_getAllEducationResult> res = (List<usp_getAllEducationResult>)ViewData["educationlist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_education.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).EducationName, res.ElementAt(x).EducationID.ToString());
            candidate_education.Items.Add(item);
        }
    }

    void loadCongregation(Object Sender, EventArgs e)
    {
        List<usp_getAllCongregationResult> res = (List<usp_getAllCongregationResult>)ViewData["congregationlist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_congregation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CongregationName, res.ElementAt(x).CongregationID.ToString());
            candidate_congregation.Items.Add(item);
        }
    }

    void loadOccpation(Object Sender, EventArgs e)
    {
        List<usp_getAllOccupationResult> res = (List<usp_getAllOccupationResult>)ViewData["occupationlist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_occupation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).OccupationName, res.ElementAt(x).OccupationID.ToString());
            candidate_occupation.Items.Add(item);
        }
    }

    void loadLanguage(Object Sender, EventArgs e)
    {
        List<usp_getAllLanguageResult> res = (List<usp_getAllLanguageResult>)ViewData["languagelist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_languagelist.Items.Add(item);
        string list = "," + (string)ViewData["candidate_language"] + ",";
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).LanguageName, res.ElementAt(x).LanguageID.ToString());
            candidate_languagelist.Items.Add(item);
        }
    }

    void loadParish(Object Sender, EventArgs e)
    {
        List<usp_getAllParishResult> res = (List<usp_getAllParishResult>)ViewData["parishlist"];
        ListItem item = new ListItem("", "-");
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

    void loadClergy(Object Sender, EventArgs e)
    {
        List<usp_getAllClergyResult> res = (List<usp_getAllClergyResult>)ViewData["clergylist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
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

    void loadCellgroup(Object Sender, EventArgs e)
    {
        List<usp_getListofCellgroupResult> res = (List<usp_getListofCellgroupResult>)ViewData["cellgrouplist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_cellgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CellgroupName, res.ElementAt(x).CellgroupID.ToString());
            candidate_cellgroup.Items.Add(item);
        }
    }

    void loadMinistry(Object Sender, EventArgs e)
    {
        List<usp_getListofMinistryResult> res = (List<usp_getListofMinistryResult>)ViewData["ministrylist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        candidate_ministry.Items.Add(item);
       for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).MinistryName, res.ElementAt(x).MinistryID.ToString());
            candidate_ministry.Items.Add(item);
        }
    }
    
    void loadPostalCode(Object Sender, EventArgs e)
    {
        List<usp_getAllPostalCodeResult> res = (List<usp_getAllPostalCodeResult>)ViewData["postalarealist"];
        ListItem item = new ListItem("", "-");
        item.Selected = true;
        postalcode.Items.Add(item);
       for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).PostalAreaName, res.ElementAt(x).PostalDigit.ToString());
            postalcode.Items.Add(item);
        }
    }      
</script>

<script type="text/javascript">
    function reloadManualSearchList() {
        $("#MemberlistIframe").get(0).contentWindow.reloadCase($("#" + getGenderID()).val(), $("#" + getMarriageID()).val(), $("#" + getNationality()).val(), $("#" + getDialectID()).val(), $("#" + getEducationID()).val(), $("#" + getOccupationID()).val(), $("#" + getCongregationID()).val(), $("#" + getLanguageID()).val(), $("#" + getCellgroupID()).val(), $("#" + getMinistryID()).val(), $("#" + getBaptismChurchID()).val(), $("#" + getConfirmChurchID()).val(), $("#" + getPreviousChurchID()).val(), $("#" + getBaptismByID()).val(), $("#" + getConfirmByID()).val(), $("#" + getResidentalAreaID()).val()); 
    }

    function getGenderID() {
        return "candidate_gender";
    }
    function getMarriageID() {
        return "<%= candidate_marital_status.ClientID %>";
    }
    function getNationality() {
        return "<%= candidate_nationality.ClientID %>";
    }
    function getDialectID() {
        return "<%= candidate_dialect.ClientID %>";
    }
    function getEducationID() {
        return "<%= candidate_education.ClientID %>";
    }
    function getOccupationID() {
        return "<%= candidate_occupation.ClientID %>";
    }
    function getCongregationID() {
        return "<%= candidate_congregation.ClientID %>";
    }
    function getLanguageID() {
        return "<%= candidate_languagelist.ClientID %>";
    }
    function getCellgroupID() {
        return "<%= candidate_cellgroup.ClientID %>";
    }
    function getMinistryID() {
        return "<%= candidate_ministry.ClientID %>";
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
    function getBaptismByID() {
        return "<%= baptized_by.ClientID %>";
    }
    function getConfirmByID() {
        return "<%= confirm_by.ClientID %>";
    }
    function getResidentalAreaID() {
        return "<%= postalcode.ClientID %>";
    }
</script>    

<form id="form1" runat="server">
    <div class="container">
        <ul class="tabs">
            <li><a href="#tab1">Manual Search</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table style="width:80%" class="dottedview" cellspacing="0">
                    <tr>
                        <td style="width:20%">
                            Gender<br />
                                <select style="width:100%" class="element select small" id="candidate_gender" name="candidate_gender"> 
			                        <option value="-" selected="selected"></option>
                                    <option value="M" >Male</option>
                                    <option value="F" >Female</option>
		                        </select>
                        </td>
                        <td style="width:20%">
                                Marital Status <br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadmaritalstatus" name="candidate_marital_status" ID="candidate_marital_status" runat="server">
                                </asp:DropDownList> 
                        </td>
                        <td style="width:20%">
                                Nationality <br />	                      
		                        <asp:DropDownList style="width:100%" OnLoad="loadCountry" name="candidate_nationality" ID="candidate_nationality" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td style="width:20%">
                                Dialect <br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadDialect" name="candidate_dialect" ID="candidate_dialect" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td style="width:20%">
                                Education<br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadEducation" name="candidate_education" ID="candidate_education" runat="server">
                                </asp:DropDownList>
                        </td>
                </tr>
                <tr>
                        <td>
                                Occupation<br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadOccpation" name="candidate_occupation" ID="candidate_occupation" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td>
                                Congregation<br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadCongregation" name="candidate_congregation" ID="candidate_congregation" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td>
                                Language(s)<br />
		                        <asp:DropDownList style="width:100%" OnLoad="loadLanguage" name="candidate_languagelist" ID="candidate_languagelist" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td>
                                Cellgroup</label>
		                        <asp:DropDownList style=" width:100%" OnLoad="loadCellgroup" name="candidate_cellgroup" ID="candidate_cellgroup" runat="server">
                                </asp:DropDownList>
                        </td>
                        <td>
                            Ministry Involved </label>
                            <asp:DropDownList style=" width:100%" OnLoad="loadMinistry" name="candidate_ministry" ID="candidate_ministry" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Baptism Church </label>
		                    <asp:DropDownList style="width:100%" name="baptism_church" ID="baptism_church" runat="server">
                            </asp:DropDownList>                                
                        </td>
                        <td>
                            Confirmation Church </label>
		                    <asp:DropDownList style="width:100%" name="confirmation_church" ID="confirmation_church" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            Previous Church Membership </label>
		                    <asp:DropDownList style="width:100%" OnLoad="loadParish" name="previous_church_membership" ID="previous_church_membership" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            Baptised By </label>
		                    <asp:DropDownList style="width:100%" name="baptized_by" ID="baptized_by" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            Confirmation By </label>
		                    <asp:DropDownList OnLoad="loadClergy" style="width:100%" name="confirm_by" ID="confirm_by" runat="server">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Residental Area </label>
		                    <asp:DropDownList OnLoad="loadPostalCode" style="width:100%" name="postalcode" ID="postalcode" runat="server">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <br />  
                            <input type="button" onclick="reloadManualSearchList();" value="Reload"/>
                        </td>
                    </tr>
                </table>
                
                <iframe id="MemberlistIframe" frameborder="0" src="/Reporting.mvc/manualSearchlist" style="width: 100%; height: 440px;">
                    <p>Your browser does not support iframes.</p></iframe>
            </div>
        </div>
        <p>
            &nbsp;</p>
        &nbsp;
    </div>
    </form>





</asp:Content>