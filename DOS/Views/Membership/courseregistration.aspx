<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>
<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Course Registration
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/login_view.css">
<link rel="stylesheet" href="/Content/css/datepicker.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="/Content/css/searchsuggest.css">
<script type="text/javascript" src="/Content/scripts/datepicker.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.watermarkinput.min.js"></script>
<script type="text/javascript" src="/Content/scripts/jquery.cookie.js"></script>
    
<%if (HttpContext.Current.IsDebuggingEnabled){%>
    <script type="text/javascript" src="/Content/scripts/courseregistration.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.debug.js"></script>        
<%}else{%>    
    <script type="text/javascript" src="/Content/scripts/courseregistration.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
    <script type="text/javascript" src="/Content/scripts/navigateAway.min.js"></script>
<%}%>    
<script language="C#" runat="server">

    void loadOccpation(Object Sender, EventArgs e)
    {
        List<usp_getAllOccupationResult> res = (List<usp_getAllOccupationResult>)ViewData["occupationlist"];
        ListItem item = new ListItem("", "");
        candidate_occupation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                item = new ListItem(res.ElementAt(x).OccupationName, res.ElementAt(x).OccupationName);
                if (((string)ViewData["candidate_occupation"]) == res.ElementAt(x).OccupationName)
                    item.Selected = true;
                candidate_occupation.Items.Add(item);
            }
            else
            {
                item = new ListItem(res.ElementAt(x).OccupationName, res.ElementAt(x).OccupationID.ToString());
                if (((string)ViewData["candidate_occupation"]) == res.ElementAt(x).OccupationID.ToString())
                    item.Selected = true;
                candidate_occupation.Items.Add(item);
            }
        }
    }

    void loadEducation(Object Sender, EventArgs e)
    {
        List<usp_getAllEducationResult> res = (List<usp_getAllEducationResult>)ViewData["educationlist"];
        ListItem item = new ListItem("", "");
        candidate_education.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                item = new ListItem(res.ElementAt(x).EducationName, res.ElementAt(x).EducationName);
                if (((string)ViewData["candidate_education"]) == res.ElementAt(x).EducationName)
                    item.Selected = true;
                candidate_education.Items.Add(item);
            }
            else
            {
                item = new ListItem(res.ElementAt(x).EducationName, res.ElementAt(x).EducationID.ToString());
                if (((string)ViewData["candidate_education"]) == res.ElementAt(x).EducationID.ToString())
                    item.Selected = true;
                candidate_education.Items.Add(item);
            }
        }
    }

    void loadcourse(Object Sender, EventArgs e)
    {
        List<usp_getListofCourseResult> res = (List<usp_getListofCourseResult>)ViewData["listofcourse"];
        ListItem item = new ListItem("", "");
        candidate_course.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            item = new ListItem(res.ElementAt(x).CourseName, res.ElementAt(x).courseID.ToString());
            if (((string)ViewData["candidate_course"]) == res.ElementAt(x).courseID.ToString())
                item.Selected = true;
            candidate_course.Items.Add(item);
        }
    }

    void loadSalutation(Object Sender, EventArgs e)
    {
        List<usp_getAllSalutationResult> res = (List<usp_getAllSalutationResult>)ViewData["salutationlist"];
        ListItem item = new ListItem("", "");
        candidate_salutation.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                item = new ListItem(res.ElementAt(x).SalutationName, res.ElementAt(x).SalutationName);
                if (((string)ViewData["candidate_salutation"]) == res.ElementAt(x).SalutationName)
                    item.Selected = true;
                candidate_salutation.Items.Add(item);
            }
            else
            {
                item = new ListItem(res.ElementAt(x).SalutationName, res.ElementAt(x).SalutationID.ToString());
                if (((string)ViewData["candidate_salutation"]) == res.ElementAt(x).SalutationID.ToString())
                    item.Selected = true;
                candidate_salutation.Items.Add(item);
            }
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

            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                item = new ListItem(res.ElementAt(x).CountryName, res.ElementAt(x).CountryName);
                if (((string)ViewData["candidate_nationality"]) == res.ElementAt(x).CountryName)
                    item.Selected = true;
                candidate_nationality.Items.Add(item);
            }
            else
            {

                item = new ListItem(res.ElementAt(x).CountryName, res.ElementAt(x).CountryID.ToString());
                if (((string)ViewData["candidate_nationality"]) == res.ElementAt(x).CountryID.ToString())
                    item.Selected = true;
                candidate_nationality.Items.Add(item);
            }
        }
    }

    void loadParish(Object Sender, EventArgs e)
    {
        List<usp_getAllParishResult> res = (List<usp_getAllParishResult>)ViewData["parishlist"];
        ListItem item = new ListItem("", "");
        church.Items.Add(item);
        for (int x = 0; x < res.Count; x++)
        {
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                item = new ListItem(res.ElementAt(x).ParishName, res.ElementAt(x).ParishName);
                if (((string)ViewData["candidate_church"]) == res.ElementAt(x).ParishName)
                    item.Selected = true;
                church.Items.Add(item);
            }
            else
            {
                item = new ListItem(res.ElementAt(x).ParishName, res.ElementAt(x).ParishID.ToString());
                if (res.ElementAt(x).ParishID.ToString() == (string)ViewData["candidate_church"])
                    item.Selected = true;
                church.Items.Add(item);
            }            
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

    string isOn()
    {
        if (((string)ViewData["existingmember"]) == "on")
        {
            return "style='display:none'";
        }
        else if (((string)ViewData["existingmember"]) == "null")
        {
            return "style='display:block'";
        }
        else
            return "style='display:none'";
    }

    string ischeck()
    {
        if (((string)ViewData["existingmember"]) == "on")
        {
            return "checked='checked'";
        }
        else if (((string)ViewData["existingmember"]) == "null")
        {
            return "";
        }
        else
            return "checked='checked'";
    }

    string isAD()
    {
        return (string)ViewData["ad"];
        
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

    function getAutoPostalCode(){
        return "<%=(string)Session["AutoPostalCode"] %>"
    }

    function getPostalCodeRetrival(){
        return "<%=(string)Session["PostalCodeRetrival"] %>"
    }
    
    function getNationalityID(){
        return "<%= candidate_nationality.ClientID %>";
    }
    function getPostalCodeRetrivalURL(){
        return "<%= (string)Session["PostalCodeRetrivalURL"]%>";
    }
    function getSalutationID(){
        return "<%= candidate_salutation.ClientID %>";
    }
    function getCandidateOccupationID() {
        return "<%= candidate_occupation.ClientID %>";
    }
    function getEducationID(){
        return "<%=candidate_education.ClientID%>";
    }
    function getCourseID(){
        return "<%=candidate_course.ClientID%>";
    }
    function getFormID() {
        return "<%= registration_form.ClientID %>";
    }
    function getSubmitURL(){
        return "/membership.mvc/submitcourseregistration<%=isAD() %>";
    }
    function getGenderValue() {
        return "<%= (string)ViewData["candidate_gender"]%>";
    }
    function isMember(){
        return "<%=(string)ViewData["existingmember"] %>";
    }

    function getChurchByID(){
        return "<%= church.ClientID %>";
    }

    function getSystemMode(){
        return "<%=((string)Session["SystemMode"]).ToUpper() %>";        
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
	
		<form AUTOCOMPLETE="off" runat="server" id="registration_form" class="appnitro"  method="post" action="" enctype="multipart/form-data">
		<div class="form_description">
			<h3>Course Registration <%if((string)ViewData["ad"] == "_ad") %><%= " & And Attendance Taking" %></h3> <span style="color:red;"><%= (string)ViewData["errormsg"] %></span>
		</div>						
			<ul >
			    <h4>Personal Information</h4>
                <h5 style="color:red;"><%=(string)ViewData["Message"] %></h5>
				<table width="800" border="0">
                    <tr>
                        <td style="width:180px">
                            <%if (((string)Session["SystemMode"]).ToUpper() == "FULL"){ %>
                            <li id="li6" >
		                        <label class="description" for="element_6">Existing SAC Member?<br/>Returning Visitor?</label>
		                        <div>
                                    <input style=" width:20px" <%=ischeck() %> id="existingmember" name="existingmember" class="element text medium" type="checkbox" />		                
		                        </div> 
		                        </li>
                            <%}%>
                        </td>
                        <td style="width:230px">
                             
                            <li id="li7" >
		                        <li style="width:150px" id="li8" >
		                        <label class="description" for="element_4">课程<br>
                                Course Interested <span style="color:red;">*</span></label>
		                        <div>
			                        <asp:DropDownList  style=" width:200px" class="element select medium" OnLoad="loadcourse" name="candidate_course" ID="candidate_course" runat="server">
                                    </asp:DropDownList>
                                    <input type="hidden" id="candidate_course_name" name="candidate_course_name" value="" />
		                        </div> 
				            </li>   
                        </td>
                        <td colspan="1">
                                <li id="li1" >
		                            <label class="description" for="element_9">身份证号码<br>
                                    NRIC <span style="color:red;">*</span></label>
		                            <div>
                                        <input style=" width:150px" id="candidate_nric" name="candidate_nric" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","NRIC")%> value="<%= (string)ViewData["candidate_nric"] %>" size="20"/> 
			                        </div> 
		                    </li>
                        </td>                   
                    </tr>
                </table>
                <div id="visitor" <%=isOn()%>>
                    <table width="800" border="0">
                    <tr>
                        <td width="180">
                            <li style="width:110px" id="li3" >
                            <label class="description" for="element_6">招呼<br>
                                        Salutation</label>
		                            <div>
                                    <asp:DropDownList style=" width:100px" class="element select medium" OnLoad="loadSalutation" name="candidate_salutation" ID="candidate_salutation" runat="server">
                                    </asp:DropDownList>		                
		                            </div> 
		                            </li>
                        </td>
                        <td>
                            <li id="li_1">
		                        <label class="description" for="element_1">
                                    英文姓名<br>
                                    Name in English <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:150px" id="candidate_english_name" name="candidate_english_name" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","EnglishName")%> value="<%= (string)ViewData["candidate_english_name"] %>" size="20"/> 
		                        </div> 
		                    </li>	
                        </td>
                        <td style="width:150px">
                            <li id="li_356">
		                        <label class="description" for="element_3">出生日期<br>
                                Date of Birth</label>
                                    <div>
                                            <input readonly="readonly" style=" width:100px" id="candidate_dob" name="candidate_dob" class="element text medium" type="text" maxlength="10" value="<%= (string)ViewData["candidate_dob"] %>" size="20"/> 
		                            </div>
                                </li>
                        </td>
                        <td>
                                <li style="width:100px" id="li_6" >
		                            <label class="description" for="element_6">性别<br>
                                    Gender</label>
		                            <div>
		                            <select style="width:100px" class="element select small" id="candidate_gender" name="candidate_gender"> 
			                            <option value="" selected="selected"></option>
                                        <option value="M" >Male</option>
                                        <option value="F" >Female</option>
		                            </select>
		                            </div> 
		                            </li>
                        </td>			            
                    </tr>
                    <tr>
                        <td>
                               <li id="li2">
		                        <label class="description" for="element_7">国籍<br>
                                Nationality</label>
		                        <div>
		                            <asp:DropDownList style=" width:150px" class="element select medium" OnLoad="loadCountry" name="candidate_nationality" ID="candidate_nationality" runat="server">
                                    </asp:DropDownList>                                    
		                        </div> 
		                        </li>
                        </td>
                        <td style=" width:180px">
                            <li id="li_16" >
		                        <label class="description" for="element_16">教育程度<br />
                                    Education</label>
		                        <div>
                                <asp:DropDownList style=" width:150px" class="element select medium" OnLoad="loadEducation" name="candidate_education" ID="candidate_education" runat="server">
                                </asp:DropDownList>
		                        </div> 
		                        </li>
                        </td>
                        <td>
                            <li style="width:90px" id="li_9" >
		                            <label class="description" for="element_9">职业<br>
                            Occupation</label>
		                            <div>
                                        <asp:DropDownList  style="width:200px" class="element select medium" OnLoad="loadOccpation" name="candidate_occupation" ID="candidate_occupation" runat="server">
                                        </asp:DropDownList>
                                                                                
			                    </div> 
		                    </li>
                        </td>                       
                    </tr>
                    <tr>
                        <td colspan="2">
                            <li style="width:90px" id="li11" >
		                            <label class="description" for="element_9">教会<br>
                                    Church</label>
		                            <div>
                                        <asp:DropDownList  style="width:300px" onchange="changeChurch();" OnLoad="loadParish" class="element select medium" name="church" ID="church" runat="server">
                                        </asp:DropDownList>
                                        <input style="width:300px; display:none" value="<%=(string)ViewData["candidate_church_others"] %>" class="element text medium" type="text" id="church_others" name="church_others" />
                                                                                
			                    </div> 
		                    </li>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <li style="width:210px" id="li_5" >
		                        <label class="description" for="element_5">地址<br>
                                Address</label>
		                        <div style=" width:100px" >
			                        <input style=" width:100px" id="candidate_postal_code" name="candidate_postal_code" class="element text medium" maxlength="7" onkeyup="PostalCodeKeyup(event);" value="<%= (string)ViewData["candidate_postal_code"] %>" type="text" size="20" >
			                        <label class="makesmall" for="element_5_5">Postal Code</label>
		                        </div>
                                <div class="left">
			                        <input style=" width:100px"  id="candidate_blk_house" name="candidate_blk_house" class="element text medium" <%=getTextfieldLength("tb_visitors","AddressHouseBlk")%> value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
		                            <label class="makesmall" for="element_5_6">BLK / House</label>
                                    <input type="hidden" id="hidden_candidate_blk_house" name="candidate_blk_house" value="<%= (string)ViewData["candidate_blk_house"] %>" <%=getAutoPostalCodeHiddenField()%> />
		                        </div>
		                        <div class="right">
                                    <input style=" width:100px" id="candidate_unit" name="candidate_unit" class="element text medium" <%=getTextfieldLength("tb_visitors","AddressUnit")%> value="<%= (string)ViewData["candidate_unit"] %>" type="text" size="20">
			                        <label class="makesmall" for="element_5_5">Unit #</label>
	                            </div>
                                <div>
			                        <input style=" width:350px" id="candidate_street_address" name="candidate_street_address" class="element text medium" <%=getTextfieldLength("tb_visitors","AddressStreet")%> value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCode() %> type="text" size="20" >
			                        <label class="makesmall" for="element_5_1">Street Address</label>
                                    <input type="hidden" id="hidden_candidate_street_address" name="candidate_street_address" value="<%= (string)ViewData["candidate_street_address"] %>" <%=getAutoPostalCodeHiddenField()%> />
		                        </div> 
		                        </li>
                        </td>
                        <td>
                            <li id="li4" style="width:90px">
		                        <li style="width:150px" id="li5" >
		                        <label class="description" for="element_4">电话号码<br>
                                Contact No# <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:200px" id="candidate_contact" name="candidate_contact" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","Contact")%> value="<%= (string)ViewData["candidate_contact"] %>" size="20"/> 	
		                        </div> 
				            </li>
                            
                            <li id="li9" style="width:90px">
		                        <li style="width:150px" id="li10" >
		                        <label class="description" for="element_4">电子邮件地址<br>
                                Email <span style="color:red;">*</span></label>
		                        <div>
			                        <input style=" width:200px" id="candidate_email" name="candidate_email" class="element text medium" type="text" <%=getTextfieldLength("tb_visitors","Email")%> value="<%= (string)ViewData["candidate_email"] %>" size="20"/> 	
		                        </div> 
				            </li>
                        </td>                                                
                    </tr>
		        </table>
                </div>

            
        	        <%string hideRememberMe = "";
                      if(((string)Session["SystemMode"]).ToUpper() == "FULL"){
                        hideRememberMe = "display:none";   
                      }
                    %>
					<li class="buttons">
                        <div style="<%= hideRememberMe%>">
                            <input id="RememberMe" name="RememberMe" class="element checkbox" type="checkbox" value="" />
                            <label class="choice" for="element_2_1">Remember my information? So next time you don't need to rekey the same information again.</label>
                        </div>
			            <input id="saveForm" class="button_text" type="button" onclick="checkForm();" value="Submit" />
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