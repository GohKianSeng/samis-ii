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
    <script type="text/javascript" src="/Content/scripts/staffUpdateVisitor.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.debug.js"></script>
<%}else{%>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/staffUpdateVisitor.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.min.js"></script>    
<%}%>

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
<!-- uploadify scripts   -->

<!-- Fix header and sorter table scripts   -->
<link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
<script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
<!-- Fix header and sorter table scripts   -->    

<!-- watermark scripts   --> 
<script type="text/javascript" src="/Content/scripts/jquery.watermark.min.js"></script>
<!-- watermark scripts   --> 

<script language="C#" runat="server">
    void loadOccpation(Object Sender, EventArgs e)
    {
        List<usp_getAllOccupationResult> res = (List<usp_getAllOccupationResult>)ViewData["occupationlist"];
        ListItem item = new ListItem("", "");
        candidate_occupation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).OccupationName, res.ElementAt(x).OccupationID.ToString());
            if (((string)ViewData["Occupation"]) == res.ElementAt(x).OccupationID.ToString())
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
            if (((string)ViewData["Nationality"]) == res.ElementAt(x).CountryID.ToString())
                item.Selected = true;
            candidate_nationality.Items.Add(item);
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
            if (((string)ViewData["Education"]) == res.ElementAt(x).EducationID.ToString())
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
            if (((string)ViewData["Salutation"]) == res.ElementAt(x).SalutationID.ToString())
                item.Selected = true;
            candidate_salutation.Items.Add(item);
        }
    }

    void loadCourses(Object Sender, EventArgs e)
    {
        ListItem item = new ListItem("", "");
        XElement xml = (XElement)ViewData["CourseAttended"];
        string courseid = "";
        for (int x = 0; x < xml.Elements("CourseName").Count(); x++)
        {
            if (x == 0)
            {
                item = new ListItem("", "0");
                item.Selected = true;
                candidate_courses.Items.Add(item);
            }
            item = new ListItem(xml.Elements("CourseName").ElementAt(x).Value, xml.Elements("CourseID").ElementAt(x).Value);
            candidate_courses.Items.Add(item);
        }
        courseid = "," + courseid;
    }

    void loadParish(Object Sender, EventArgs e)
    {
        List<usp_getAllParishResult> res = (List<usp_getAllParishResult>)ViewData["parishlist"];
        ListItem item = new ListItem("", "");
        church.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).ParishName, res.ElementAt(x).ParishID.ToString());
            if (res.ElementAt(x).ParishID.ToString() == (string)ViewData["church"])
                item.Selected = true;
            church.Items.Add(item);
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
        
    function getGenderValue(){
        return "<%= (string)ViewData["Gender"]%>";
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
        return "<%= registration_form.ClientID%>";
    }
    
    function getCourseID(){
        return document.getElementById("<%= candidate_courses.ClientID%>");
    }

    function getNRIC(){
        return "<%= (string)ViewData["NRIC"]%>";
    }
    
    function getChurchByID(){
        return "<%= church.ClientID %>";
    }   

</script>

<form AUTOCOMPLETE="off" id="registration_form" action="/membership.mvc/submitUpdateVisitorForm" enctype="multipart/form-data" runat="server">
    <input type="hidden" id="OriginalNric" name="OriginalNric" value="<%= (string)ViewData["NRIC"] %>">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Personal Infomation</a></li>            
            <li><a href="#tab6">History</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                <table class="dottedview" cellspacing="0">
                    <tr>
                        <td>
                            
		                    <label class="description" for="element_6">
                                Salutation</label>
		                    <div>
                            <asp:DropDownList style=" width:80%" class="element select small" OnLoad="loadSalutation" name="candidate_salutation" ID="candidate_salutation" runat="server">
                            </asp:DropDownList>			                    
		                    </div> 
		                            
                        </td>
                        <td>
                            <label class="description" for="element_1">
                                
                                Name in English <span style="color:red;">*</span></label>
		                    <div>
			                    <input style=" width:80%" id="candidate_english_name" name="candidate_english_name" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","EnglishName")%> value="<%= (string)ViewData["EnglishName"] %>" size="20"/> 
		                    </div> 
		                    
                        </td>
                        <td>
                            <label class="description" for="element_4">
                            NRIC <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:80%" id="candidate_nric" name="candidate_nric" class="element text medium" readonly="readonly" type="text" <%=getTextfieldLength("tb_visitors","NRIC")%> value="<%= (string)ViewData["NRIC"] %>" size="20"/> 
		                        </div>                      
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="description" for="element_6">
                            Gender</label>
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
                                Date of Birth</label>
                                    <div>
                                          <input readonly="readonly" style=" width:80%" id="candidate_dob" name="candidate_dob" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["DOB"] %>" size="20"/> 
		                            </div>
                        </td>
                        <td>
                            <label class="description" for="element_7">
                        Nationality</label>
		                        <div>
		                            <asp:DropDownList  style=" width:80%" class="element select medium" OnLoad="loadCountry" name="candidate_nationality" ID="candidate_nationality" runat="server">
                                    </asp:DropDownList>
		                        </div>
                        </td>			            
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table class="noborderstyle" border=0>
                                <tr>
                                    <td colspan="3">
                                        <label class="description" for="element_5">
                                        Address </label>
		
		                                <div>
			                                <textarea style=" width:100%" id="candidate_street_address" <%=getAutoPostalCode() %> <%=getTextfieldLength("tb_visitors","AddressStreet")%> name="candidate_street_address"> <%= (string)ViewData["AddressStreet"]%></textarea>
			                                <br /><label class="makesmall" for="element_5_1">Street Address</label>
                                            <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["AddressStreet"] %>" <%=getAutoPostalCodeHiddenField()%> />
		                                </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_postal_code" name="candidate_postal_code" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["AddressPostalCode"] %>" type="text">
			                            <br /><label class="makesmall">Postal Code</label>
                                    </td>
                                    <td style="width=30%">
                                        <input style=" width:100%"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_visitors","AddressHouseBlk")%> <%=getAutoPostalCode() %> value="<%= (string)ViewData["AddressHouseBlk"] %>" type="text" size="20">
		                                <br /><label class="makesmall" for="element_5_6">Blk no. / House No.</label>
                                        <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["AddressHouseBlk"] %>" <%=getAutoPostalCodeHiddenField()%>/>
                                    </td>
                                    <td style="width=40%">
                                        <input style=" width:100%"  id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_visitors","AddressUnit")%> value="<%= (string)ViewData["AddressUnit"] %>" type="text" size="20">
		                            <br /><label class="makesmall" for="element_5_6">Unit #</label>
                                    </td>
                                </tr>

                            </table>		                        
                        </td>
                        <td rowspan="4">
                            <label style=" width:250px" class="description" for="element_17">
                            Courses Attended (Display Only)</label>
		                    <div style=" height:300px;overflow:auto">
                                <asp:dropdownlist style=" width:80%" class="single_select_course element select medium" OnLoad="loadCourses" name="candidate_courses" ID="candidate_courses" onchange="changeCourse();" runat="server">
                                </asp:dropdownlist>
                                Attendance &nbsp;<label id="AttendancePercentage"></label><br />
                                <table border="1" id="VisitorCaseTable" style=" width:80%; padding:0; margin-left:0%; margin-right:0%;">
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
                    </tr>       
                    <tr>
                        <td>
                            <label class="description" for="element_10">
                            Contact <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:80%" id="candidate_contact" name="candidate_contact" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","Contact")%> value="<%= (string)ViewData["Contact"] %>" size="20"/> 
		                        </div> 
		                        
		                        
                        </td>
                        <td>
                            
		                        <label class="description" for="element_19">
                                Email <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:80%" id="candidate_email" name="candidate_email" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","Email")%> value="<%= (string)ViewData["Email"] %>" size="20"/> 
		                        </div> 
		                        
                        </td>                        			            
                    </tr>
                    <tr>
                        <td colspan="2">
                            <label class="description" for="element_19">
                                Church</label>
		                        <div>
			                            <asp:DropDownList  style=" width:80%" onchange="changeChurch();" OnLoad="loadParish" class="element select medium" name="church" ID="church" runat="server">
                                        </asp:DropDownList>
                                        <input style="width:80%; display:none" value="<%=(string)ViewData["church_others"] %>" class="element text medium" type="text" id="church_others" name="church_others" />
		                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="description" for="element_16">
                                Education</label>
		                                <div>
                                        <asp:DropDownList style=" width:80%" class="element select medium" OnLoad="loadEducation" name="candidate_education" ID="candidate_education" runat="server">
                                        </asp:DropDownList>		                        
		                        
		                        </div>                             
                        </td>
                        <td>
                            
                            <label class="description" for="element_9">
                        Occupation</label>
		                        <div>
                                    <asp:DropDownList  style="width:80%" class="element select medium" OnLoad="loadOccpation" name="candidate_occupation" ID="candidate_occupation" runat="server">
                                    </asp:DropDownList>
			            
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
                                        
                                        
                                        if (row.Element("Description").Value == "UpdateVisitor")
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
                                                        %>                                                        
					                                </table>
            			                        </div>
                                            <%
                                        }
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
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("EnglishName").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Gender:</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Gender").Value%></td>
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
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Contact").Value%></td>
                                                        </tr>
                                                        <tr style=" font-size:12px">
                                                            <td>Email</td>
                                                            <td><%= row.Element("UpdatedElements").Element("row").Element("Email").Value%></td>
                                                        </tr>                                                                                                                
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
        
        
        <div style="clear:both; width:180px; text-align:left; padding-left:15px"><br />
            <% if (canAccess("Update Participant")){%>
                <input id="Submit" onclick="checkAndSubmit();" type="button" value="Update" />        
            <%}else{%>
                <input id="Button1" disabled="disabled" type="button" value="Update" />
            <%}%>
            
                    
        </div>     


    </div>
          
    </form>
        
</asp:Content>