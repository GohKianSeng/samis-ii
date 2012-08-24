<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
   C3 Update
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">

<%if (!HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/citykids_membership.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/staffUpdateCityKids.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/citykids_membership.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/staffUpdateCityKids.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
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
    void loadClubgroup(Object Sender, EventArgs e)
    {
        List<usp_getAllClubgroupResult> res = (List<usp_getAllClubgroupResult>)ViewData["clubgrouplist"];
        ListItem item = new ListItem("", "");
        kid_clubgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).ClubGroupName, res.ElementAt(x).ClubGroupID.ToString());
            if (((string)ViewData["kid_clubgroup"]) == res.ElementAt(x).ClubGroupID.ToString())
                item.Selected = true;
            kid_clubgroup.Items.Add(item);
        }
    }

    void loadBusgroup(Object Sender, EventArgs e)
    {
        List<usp_getAllBusGroupClusterResult> res = (List<usp_getAllBusGroupClusterResult>)ViewData["busgroupclusterlist"];
        ListItem item = new ListItem("", "");
        kid_busgroup.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).BusGroupClusterName, res.ElementAt(x).BusGroupClusterID.ToString());
            if (((string)ViewData["kid_busgroup"]) == res.ElementAt(x).BusGroupClusterID.ToString())
                item.Selected = true;
            kid_busgroup.Items.Add(item);
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
        if(User.Identity.IsAuthenticated && Session["AccessRight"] == null)
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

    function getTransport(){
        return "<%=(string) ViewData["kid_transport"]%>";
    }
    
    function getPhotoFilename(){
        return "<%=(string) ViewData["photo"]%>";
    }

    function getGenderValue(){
        return "<%=(string) ViewData["kid_gender"]%>";
    }

    function getGUID() {
        return "<%= System.Guid.NewGuid().ToString()%>";
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
    
    function getFormID(){
        return "<%= registration_form.ClientID %>";
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
</script>

<form AUTOCOMPLETE="off" id="registration_form" action="/CityKids.mvc/submitUpdateKidForm" enctype="multipart/form-data" runat="server">
    <input type="hidden" id="OriginalNric" name="OriginalNric" value="<%= (string)ViewData["kid_nric"] %>">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Personal Infomation</a></li>
            <li><a href="#tab2">City Kid Information</a></li>           
            <li><a href="#tab6">History</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            <label class="description" for="element_4">NRIC <span style="color:red;">*</span></label>
		                    <div>
			                    <input style=" width:90%" id="kid_nric" name="kid_nric" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","NRIC")%> value="<%= (string)ViewData["kid_nric"] %>" size="20"/> 
		                    </div> 
                        </td>
                        <td>
                            <label class="description" for="element_1">
                                Name<span style="color:red;">*</span></label>
		                    <div>
			                    <input style=" width:90%" id="kid_name" name="kid_name" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","Name")%> value="<%= (string)ViewData["kid_name"] %>" size="20"/> 
		                    </div> 
		                    
                        </td>

                        <td >
                            <label class="description" for="element_6">
                            Gender <span style="color:red;">*</span></label>
		                    <div>
		                    <select style=" width:90%" class="element select small" id="kid_gender" name="kid_gender"> 
			                    <option value="" selected="selected"></option>
                                <option value="M" >Male</option>
                                <option value="F" >Female</option>
		                    </select>
		                    </div> 		                    
                        </td>
                        <td width="200">
                            <label class="description" for="element_3">
                            Date of Birth <span style="color:red;">*</span></label>
                                <div>
                                      <input readonly="readonly" style=" width:90%" id="kid_dob" name="kid_dob" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["kid_dob"] %>" size="20"/> 
		                        </div>                                                
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="description" for="element_7">
                            Nationality <span style="color:red;">*</span></label>
		                    <div>
		                        <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadCountry" name="kid_nationality" ID="kid_nationality" runat="server">
                                </asp:DropDownList>
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_7">
                            Race <span style="color:red;">*</span></label>
		                    <div>
                                <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadRace" name="kid_race" ID="kid_race" runat="server">
                                </asp:DropDownList>    	                
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_10">
                                Home Tel </label>
		                    <div>
			                    <input style=" width:90%" id="kid_home_tel" name="kid_home_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","HomeTel")%> value="<%= (string)ViewData["kid_home_tel"] %>" size="20"/> 
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_11">
                                Mobile Tel </label>
		                    <div>
			                    <input style=" width:90%" id="kid_mobile_tel" name="kid_mobile_tel" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","MobileTel")%> value="<%= (string)ViewData["kid_mobile_tel"] %>" size="20"/> 
		                    </div>
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
			                                <textarea style=" width:100%" id="candidate_street_address" <%=getAutoPostalCode() %> name="candidate_street_address" <%=getTextfieldLength("tb_ccc_kids", "AddressStreet")%>> <%= (string)ViewData["candidate_street_address"] %></textarea>
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
                                        <input style=" width:100%"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_ccc_kids","AddressHouseBlk")%> <%=getAutoPostalCode() %> value="<%= (string)ViewData["candidate_blk_house"] %>" type="text" size="20">
		                                <br /><label class="makesmall" for="element_5_6">Blk no. / House No.</label>
                                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCodeHiddenField()%> />
                                    </td>
                                    <td style="width=40%">
                                        <input style=" width:100%"  id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_ccc_kids","AddressUnit")%> value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
		                            <br /><label class="makesmall" for="element_5_6">Unit #</label>
                                    </td>
                                </tr>

                            </table>		                        
                        </td>
                        <td rowspan="1">
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
                        <td rowspan="1">
                            <img id="icphoto" src="/Content/images/ictemp.jpg" width="128" height="164" />
                            <input type="hidden" id="kid_photo" name="kid_photo" value="<%=(string) ViewData["photo"]%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="description" for="element_19">
                                Email </label>
		                    <div>
			                    <input style=" width:90%" id="kid_email" name="kid_email" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","Email")%> value="<%= (string)ViewData["kid_email"] %>" size="20"/> 
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_16">
                                School <span style="color:red;">*</span></label>
		                    <div>
                                <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadSchool" name="kid_school" ID="kid_school" runat="server">
                                </asp:DropDownList>
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_8">
                            Religion </label>
		                    <div>
			                    <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadReligion" name="kid_religion" ID="kid_religion" runat="server">
                                </asp:DropDownList>
                            </div>
                        </td>                        
                    </tr>
                    <tr>
                        <td>                            
		                        <label class="description" for="element_9">
                                Next Of Kin Contact <span style="color:red;">*</span></label>
		                        <div>                        
			                        <input style=" width:90%" id="kid_NOK_contact" name="kid_NOK_contact" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","EmergencyContact")%> value="<%= (string)ViewData["kid_NOK_contact"] %>" size="20"/> 
		                        </div> 		                    
                        </td>
			
                        <td colspan="1" >
                                <label class="description" for="element_9">
                                Next Of Kin Name <span style="color:red;">*</span></label>
		                        <div>
                                    <input style=" width:90%" id="kid_NOK_relationship" name="kid_NOK_relationship" class="element text medium" type="text" <%=getTextfieldLength("tb_ccc_kids","EmergencyContactName")%> value="<%= (string)ViewData["kid_NOK_relationship"] %>" size="20"/>                         			            
		                        </div> 
		                        
                        </td>
                     </tr>
                     <tr>
                        <td colspan="2">
                            <label class="description" for="element_9">
                            Special Need </label>
		                    <div>                        
			                    <textarea id="kid_special_needs" <%=getTextfieldLength("tb_ccc_kids","SpecialNeeds")%> name="kid_special_needs" rows="5" cols="40"><%=(string)ViewData["kid_special_needs"]%></textarea>
		                    </div> 
                        </td>
                     </tr>               
                    </table>
            </div>
            <div id="tab2" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            <label class="description" for="element_6">
                                SAC Transport</label>
		                    <div>
		                    <select style=" width:90%" class="element select small" id="kid_transport" name="kid_transport"> 
			                    <option value="" selected="selected"></option>
                                <option value="0" >False</option>
                                <option value="1" >True</option>
		                    </select>
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_7">
                            Club Group </label>
		                    <div>
		                        <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadClubgroup" name="kid_clubgroup" ID="kid_clubgroup" runat="server">
                                </asp:DropDownList>
		                    </div>
                        </td>
                        <td>
                            <label class="description" for="element_7">
                            Bus Group / Cluster </label>
		                    <div>
		                        <asp:DropDownList style=" width:90%" class="element select medium" OnLoad="loadBusgroup" name="kid_busgroup" ID="kid_busgroup" runat="server">
                                </asp:DropDownList>
		                    </div>
                        </td>
                        <td style=" width:150px">
                            <label class="description" for="element_7">
                            Points Accumulated</label>
		                    <div>
		                        <input style=" width:90%" id="kid_points" disabled="disabled" readonly="readonly" name="kid_points" class="element text medium" type="text" maxlength="255" value="<%= (string)ViewData["kid_points"] %>" size="20"/> 
		                    </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <label class="description" for="element_9">
                            Remarks </label>
		                    <div>                        
			                    <textarea id="kid_remarks" name="kid_remarks" <%=getTextfieldLength("tb_ccc_kids","Remarks")%> rows="5" cols="40"><%=(string)ViewData["kid_remarks"]%></textarea>
		                    </div> 
                        </td>
                    </tr>
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
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Name").Value%></td>
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
                                                            <td>Home Tel:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("HomeTel").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Mobile Tel:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("MobileTel").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Email</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Email").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Special Needs</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("SpecialNeeds").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>NOK Name</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("EmergencyContactName").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>NOK Contact</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("EmergencyContact").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Religion</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Religion").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Race</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Race").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>School</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("School").Value%></td>
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
                                                                        <td><%= update.Element("ChileAdded").Elements("Child").ElementAt(y).Element("ChildEnglishName").Value%></td>
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
                                                                        <td><%= update.Element("ChildRemoved").Elements("Child").ElementAt(y).Element("ChildEnglishName").Value%></td>
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
                                                                        <td><%= update.Element("FamilyAdded").Elements("Family").ElementAt(y).Element("FamilyEnglishName").Value%></td>
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
                                                                        <td><%= update.Element("FamilyRemoved").Elements("Family").ElementAt(y).Element("FamilyEnglishName").Value%></td>
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
                <input id="Submit1" class="button_text" type="button" onclick="checkStaffKidsForm()" value="Update" />        
        <%}else{%>
                <input id="Button1" class="button_text" type="button" disabled="disabled" value="Update" />
        <%}%>
        
    </div>     
    </div>
          
    </form>
        
</asp:Content>