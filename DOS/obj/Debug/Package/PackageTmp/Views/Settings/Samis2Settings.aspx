<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>
<%@ Import Namespace="DOS.Models" %>

<asp:Content ID="aboutTitle" ContentPlaceHolderID="TitleContent" runat="server">
Settings
</asp:Content>

<asp:Content ID="aboutContent" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Content/scripts/jquery-1.6.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="/Content/css/TabsView.css">

    <!-- Fix header and sorter table scripts   -->
    <link rel="stylesheet" type="text/css" href="/Content/css/TablesView.css" />
    <script type="text/javascript" src="/Content/scripts/jquery.tablesorter.min.js"></script> 
    <!-- Fix header and sorter table scripts   -->

    <%if (HttpContext.Current.IsDebuggingEnabled){%>
        <script type="text/javascript" src="/Content/scripts/common_function.debug.js"></script>
        <script type="text/javascript" src="/Content/scripts/samis2settings.debug.js"></script>
        
    <%}else{%>
        <script type="text/javascript" src="/Content/scripts/common_function.min.js"></script>
        <script type="text/javascript" src="/Content/scripts/samis2settings.min.js"></script>
    <%}%>

    <script type="text/javascript" src="/Content/scripts/progressbar_min.js"></script>
    <link rel="stylesheet" type="text/css" href="/Content/css/progressbar.css" />    

    <script language="C#" runat="server">
    
        string EscapeDataString(string value)
        {
            int limit = 2000;

            StringBuilder sb = new StringBuilder();
            int loops = value.Length / limit;

            for (int i = 0; i <= loops; i++)
            {
                if (i < loops)
                {

                    sb.Append(System.Uri.EscapeDataString(value.Substring(limit * i, limit)));
                }
                else
                {
                    sb.Append(System.Uri.EscapeDataString(value.Substring(limit * i)));
                }
            }
            return sb.ToString();
        }
    </script>

    <form AUTOCOMPLETE="off" action="" enctype="multipart/form-data" runat="server">
    <div class="container" style="width:830px">
        <ul class="tabs">
            <li><a href="#tab1">Church Area</a></li>
            <li><a href="#tab2">Congregation</a></li>
            <li><a href="#tab3">Country</a></li>
            <li><a href="#tab4">Dialect</a></li>
            <li><a href="#tab5">Education</a></li>
            <li><a href="#tab22">Email</a></li>
            <li><a href="#tab15">File Type</a></li>
            <li><a href="#tab21">Family Type</a></li>
            <li><a href="#tab6">Languages</a></li>
            <li><a href="#tab7">Marital Status</a></li>
            <li><a href="#tab8">Occupation</a></li>
            <li><a href="#tab9">Parish</a></li>
            <li><a href="#tab11">Salutation</a></li>
            <li><a href="#tab12">Style</a></li>
            <li><a href="#tab13">DB Config</a></li>
            <li><a href="#tab14">Postal Code Config</a></li>
            <li><a href="#tab16">Bus Group/Clusters</a></li>
            <li><a href="#tab17">Club Group</a></li>
            <li><a href="#tab18">Race</a></li>
            <li><a href="#tab19">Religion</a></li>
            <li><a href="#tab20">School</a></li>
            <li><a href="#tab23">External Site</a></li>
            <li><a href="#tab24">Additional Information</a></li>
        </ul>
        <div class="tab_container">
            <div id="tab1" class="tab_content" style="height:70%">
            <br /><br /><br /><br />
                <input type="hidden" id="ChurchArealist" name="ChurchArealist" value="0">
                <input type="hidden" id="ChurchAreaXML" name="ChurchAreaXML" value="<%= System.Uri.EscapeDataString((string)ViewData["churchareaxml"]) %>">
                <input type="button" id="updateChurchAreaButton" onclick="checkAndSubmit('ChurchArea', 'ChurchAreaXML', 'ChurchAreaTable', 'ChurchArealist', 'ChurchAreaID', 'ChurchAreaName', 'ChurchArea', 'Area', 'AreaID', 'AreaName');" value="Update" />                
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="ChurchAreaTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width="1%" nowrap="nowrap"><img onclick="addType(this, 'ChurchArea', 'ChurchArealist', 'ChurchAreaTable', 'ChurchAreaID', 'ChurchAreaName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Church Area ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Church Area Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table> 
                </div>
            <br />
            </div>
            <div id="tab2" class="tab_content" style="height:70%">
               <br /><br /><br /><br />
                <input type="hidden" id="Congregationlist" name="Congregationlist" value="0">
                <input type="hidden" id="CongregationXML" name="CongregationXML" value="<%= System.Uri.EscapeDataString((string)ViewData["congregationxml"]) %>">
                <input type="button" id="updateCongregationButton" onclick="checkAndSubmit('Congregation', 'CongregationXML', 'CongregationTable', 'Congregationlist', 'CongregationID', 'CongregationName', 'ChurchCongregation', 'Congregation', 'CongregationID', 'CongregationName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="CongregationTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Congregation', 'Congregationlist', 'CongregationTable', 'CongregationID', 'CongregationName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Congregation ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Congregation Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            <br />
            </div>
            <div id="tab3" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Countrylist" name="Countrylist" value="0">
                <input type="hidden" id="CountryXML" name="CountryXML" value="<%= System.Uri.EscapeDataString((string)ViewData["countryxml"]) %>">
                <input type="button" id="updateCountryButton" onclick="checkAndSubmit('Country', 'CountryXML', 'CountryTable', 'Countrylist', 'CountryID', 'CountryName', 'ChurchCountry', 'Country', 'CountryID', 'CountryName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="CountryTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Country', 'Countrylist', 'CountryTable', 'CountryID', 'CountryName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Country ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Country Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab4" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Dialectlist" name="Dialectlist" value="0">
                <input type="hidden" id="DialectXML" name="DialectXML" value="<%= System.Uri.EscapeDataString((string)ViewData["dialectxml"]) %>">
                <input type="button" id="updateDialectButton" onclick="checkAndSubmit('Dialect', 'DialectXML', 'DialectTable', 'Dialectlist', 'DialectID', 'DialectName', 'ChurchDialect', 'Dialect', 'DialectID', 'DialectName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="DialectTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Dialect', 'Dialectlist', 'DialectTable', 'DialectID', 'DialectName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Dialect ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Dialect Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab5" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Educationlist" name="Educationlist" value="0">
                <input type="hidden" id="EducationXML" name="EducationXML" value="<%= System.Uri.EscapeDataString((string)ViewData["educationxml"]) %>">
                <input type="button" id="updateEducationButton" onclick="checkAndSubmit('Education', 'EducationXML', 'EducationTable', 'Educationlist', 'EducationID', 'EducationName', 'ChurchEducation', 'Education', 'EducationID', 'EducationName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="EducationTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Education', 'Educationlist', 'EducationTable', 'EducationID', 'EducationName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Education ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Education Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab22" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Emaillist" name="Emaillist" value="0">
                <input type="hidden" id="EmailXML" name="EmailXML" value="<%= System.Uri.EscapeDataString((string)ViewData["emailxml"]) %>">
                <label style=" color:red">Warning, modify the below setting might cause SAMIS II to malfunction.<br />Please restart your browser to let the changes take effect.</label><br /><br />
                <input type="button" id="updateEmailButton" onclick="checkAndSubmitEmail();" value="Update" />                
                <div style=" overflow:auto; height:75%">
                    <table class="tablesorter" id="EmailTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width="1%" nowrap="nowrap">ID</td>
                                <td class="nosorting" width="20%" nowrap="nowrap">Email Type</td>
				                <td class="nosorting" width="80%" nowrap="nowrap">Email Content</td>
                            </tr>
		                </thead>
		                <tbody>
                            
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab15" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="FileTypelist" name="FileTypelist" value="0">
                <input type="hidden" id="FileTypeXML" name="FileTypeXML" value="<%= System.Uri.EscapeDataString((string)ViewData["filetypexml"]) %>">
                <input type="button" id="Button4" onclick="checkAndSubmit('FileType', 'FileTypeXML', 'FileTypeTable', 'FileTypelist', 'FileTypeID', 'FileTypeName', 'FileType', 'Group', 'FileTypeID', 'FileTypeName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="FileTypeTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'FileType', 'FileTypelist', 'FileTypeTable', 'FileTypeID', 'FileTypeName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">File Type ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">File Type Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab21" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="FamilyTypelist" name="FamilyTypelist" value="0">
                <input type="hidden" id="FamilyTypeXML" name="FamilyTypeXML" value="<%= System.Uri.EscapeDataString((string)ViewData["familytypexml"]) %>">
                <input type="button" id="Button6" onclick="checkAndSubmit('FamilyType', 'FamilyTypeXML', 'FamilyTypeTable', 'FamilyTypelist', 'FamilyTypeID', 'FamilyTypeName', 'FamilyType', 'Group', 'FamilyTypeID', 'FamilyTypeName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="FamilyTypeTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'FamilyType', 'FamilyTypelist', 'FamilyTypeTable', 'FamilyTypeID', 'FamilyTypeName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Family Type ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Family Type Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab6" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Languagelist" name="Languagelist" value="0">
                <input type="hidden" id="LanguageXML" name="LanguageXML" value="<%= System.Uri.EscapeDataString((string)ViewData["languagexml"]) %>">
                <input type="button" id="updateLanguageButton" onclick="checkAndSubmit('Language', 'LanguageXML', 'LanguageTable', 'Languagelist', 'LanguageID', 'LanguageName', 'ChurchLanguage', 'Language', 'LanguageID', 'LanguageName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="LanguageTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Language', 'Languagelist', 'LanguageTable', 'LanguageID', 'LanguageName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Language ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Language Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab7" class="tab_content" style="height:70%">
               <br /><br /><br /><br />
                <input type="hidden" id="MaritalStatuslist" name="MaritalStatuslist" value="0">
                <input type="hidden" id="MaritalStatusXML" name="MaritalStatusXML" value="<%= System.Uri.EscapeDataString((string)ViewData["maritalsStatusxml"]) %>">
                <input type="button" id="updateMaritalStatusButton" onclick="checkAndSubmit('MaritalStatus', 'MaritalStatusXML', 'MaritalStatusTable', 'MaritalStatuslist', 'MaritalStatusID', 'MaritalStatusName', 'ChurchMaritalStatus', 'MaritalStatus', 'MaritalStatusID', 'MaritalStatusName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="MaritalStatusTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'MaritalStatus', 'MaritalStatuslist', 'MaritalStatusTable', 'MaritalStatusID', 'MaritalStatusName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Marital Status ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Marital Status Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab8" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Occupationlist" name="Occupationlist" value="0">
                <input type="hidden" id="OccupationXML" name="OccupationXML" value="<%= System.Uri.EscapeDataString((string)ViewData["occupationxml"]) %>">
                <input type="button" id="updateOccupationButton" onclick="checkAndSubmit('Occupation', 'OccupationXML', 'OccupationTable', 'Occupationlist', 'OccupationID', 'OccupationName', 'ChurchOccupation', 'Occupation', 'OccupationID', 'OccupationName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="OccupationTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Occupation', 'Occupationlist', 'OccupationTable', 'OccupationID', 'OccupationName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Occupation ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Occupation Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab9" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Parishlist" name="Parishlist" value="0">
                <input type="hidden" id="ParishXML" name="ParishXML" value="<%= System.Uri.EscapeDataString((string)ViewData["parishxml"]) %>">
                <input type="button" id="updateParishButton" onclick="checkAndSubmit('Parish', 'ParishXML', 'ParishTable', 'Parishlist', 'ParishID', 'ParishName', 'ChurchParish', 'Parish', 'ParishID', 'ParishName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="ParishTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Parish', 'Parishlist', 'ParishTable', 'ParishID', 'ParishName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Parish ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Parish Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>            
            <div id="tab11" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Salutationlist" name="Salutationlist" value="0">
                <input type="hidden" id="SalutationXML" name="SalutationXML" value="<%= System.Uri.EscapeDataString((string)ViewData["salutationxml"]) %>">
                <input type="button" id="updateSalutationButton" onclick="checkAndSubmit('Salutation', 'SalutationXML', 'SalutationTable', 'Salutationlist', 'SalutationID', 'SalutationName', 'ChurchSalutation', 'Salutation', 'SalutationID', 'SalutationName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="SalutationTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Salutation', 'Salutationlist', 'SalutationTable', 'SalutationID', 'SalutationName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Salutation ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Salutation Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab12" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Stylelist" name="Stylelist" value="0">
                <input type="hidden" id="StyleXML" name="StyleXML" value="<%= System.Uri.EscapeDataString((string)ViewData["stylexml"]) %>">
                <input type="button" id="updateStyleButton" onclick="checkAndSubmit('Style', 'StyleXML', 'StyleTable', 'Stylelist', 'StyleID', 'StyleName', 'ChurchStyle', 'Style', 'StyleID', 'StyleName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="StyleTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Style', 'Stylelist', 'StyleTable', 'StyleID', 'StyleName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Style ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Style Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab13" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Configlist" name="Configlist" value="0">
                <input type="hidden" id="ConfigXML" name="ConfigXML" value="<%= System.Uri.EscapeDataString((string)ViewData["configxml"]) %>">
                <label style=" color:red">Warning, modify the below setting might cause SAMIS II to malfunction.<br />Please restart your browser to let the changes take effect.</label><br /><br />
                <input type="button" id="updateConfigButton" onclick="checkAndSubmitConfig();" value="Update" />                
                <div style=" overflow:auto; height:75%">
                    <table class="tablesorter" id="ConfigTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width="1%" nowrap="nowrap">ID</td>
                                <td class="nosorting" width="20%" nowrap="nowrap">Name</td>
				                <td class="nosorting" width="80%" nowrap="nowrap">Value</td>
                            </tr>
		                </thead>
		                <tbody>
                            
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab14" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Postallist" name="Postallist" value="0">
                <input type="hidden" id="PostalXML" name="PostalXML" value="<%= System.Uri.EscapeDataString((string)ViewData["postalxml"]) %>">
                <input type="button" id="updatePostalButton" onclick="checkAndSubmitPostal();" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="PostalTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addPostal(this);" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
                                <td class="nosorting" width="1%" nowrap="nowrap">District</td>
                                <td class="nosorting" width="20%" nowrap="nowrap">Postal Area</td>
				                <td class="nosorting" width="80%" nowrap="nowrap">Postal Code</td>
                            </tr>
		                </thead>
		                <tbody>
                            
			            </tbody>
		            </table>
                </div>
            </div>
            <div id="tab16" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="BusGroupClusterlist" name="BusGroupClusterlist" value="0">
                <input type="hidden" id="BusGroupClusterXML" name="BusGroupClusterXML" value="<%= System.Uri.EscapeDataString((string)ViewData["busgroupclusterxml"]) %>">
                <input type="button" id="BusGroupClusterButton" onclick="checkAndSubmit('BusGroupCluster', 'BusGroupClusterXML', 'BusGroupClusterTable', 'BusGroupClusterlist', 'BusGroupClusterID', 'BusGroupClusterName', 'BusGroupCluster', 'Group', 'BusGroupClusterID', 'BusGroupClusterName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="BusGroupClusterTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'BusGroupCluster', 'BusGroupClusterlist', 'BusGroupClusterTable', 'BusGroupClusterID', 'BusGroupClusterName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Bus Group Cluster ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Bus Group Cluster Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab17" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="ClubGrouplist" name="ClubGrouplist" value="0">
                <input type="hidden" id="ClubGroupXML" name="ClubGroupXML" value="<%= System.Uri.EscapeDataString((string)ViewData["clubgroupxml"]) %>">
                <input type="button" id="Button1" onclick="checkAndSubmit('ClubGroup', 'ClubGroupXML', 'ClubGroupTable', 'ClubGrouplist', 'ClubGroupID', 'ClubGroupName', 'ClubGroup', 'Group', 'ClubGroupID', 'ClubGroupName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="ClubGroupTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'ClubGroup', 'ClubGrouplist', 'ClubGroupTable', 'ClubGroupID', 'ClubGroupName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Club Group ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Club Group Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab18" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Racelist" name="Racelist" value="0">
                <input type="hidden" id="RaceXML" name="RaceXML" value="<%= System.Uri.EscapeDataString((string)ViewData["racexml"]) %>">
                <input type="button" id="Button2" onclick="checkAndSubmit('Race', 'RaceXML', 'RaceTable', 'Racelist', 'RaceID', 'RaceName', 'Race', 'Group', 'RaceID', 'RaceName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="RaceTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Race', 'Racelist', 'RaceTable', 'RaceID', 'RaceName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Race ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Race Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab19" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Religionlist" name="Religionlist" value="0">
                <input type="hidden" id="ReligionXML" name="ReligionXML" value="<%= System.Uri.EscapeDataString((string)ViewData["religionxml"]) %>">
                <input type="button" id="Button3" onclick="checkAndSubmit('Religion', 'ReligionXML', 'ReligionTable', 'Religionlist', 'ReligionID', 'ReligionName', 'Religion', 'Group', 'ReligionID', 'ReligionName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="ReligionTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'Religion', 'Religionlist', 'ReligionTable', 'ReligionID', 'ReligionName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">Religion ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">Religion Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab20" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="Schoollist" name="Schoollist" value="0">
                <input type="hidden" id="SchoolXML" name="SchoolXML" value="<%= System.Uri.EscapeDataString((string)ViewData["schoolxml"]) %>">
                <input type="button" id="Button5" onclick="checkAndSubmit('School', 'SchoolXML', 'SchoolTable', 'Schoollist', 'SchoolID', 'SchoolName', 'School', 'Group', 'SchoolID', 'SchoolName');" value="Update" />
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="SchoolTable" style=" width:60%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addType(this, 'School', 'Schoollist', 'SchoolTable', 'SchoolID', 'SchoolName');" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">School ID</td>
				                <td class="nosorting" width="8%" nowrap="nowrap">School Name</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab23" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="ExternalDBlist" name="ExternalDBlist" value="0">
                <input type="hidden" id="ExternalDBXML" name="ExternalDBXML" value="<%= System.Uri.EscapeDataString((string)ViewData["externaldbxml"]) %>">
                
                
                <table style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
                    <tr>
                        <td><input type="button" id="updateExternalDBButton" onclick="checkAndSubmitExternalDB()" value="Update" /></td>
                        <td><div style=""><input style="float: right;" type="button" id="Button7" onclick="SyncAllSettings()" value="Sync All" /><div style="float: right; display:none" id="syncMessageDiv"><img id="syncimg" align="top" height="20px" style="" src="/Content/images/loading.gif" /> <label style=" color:Red" id="syncMessage">Synchronizing. Please wait......</label></div></div></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div id="progressDIV" style="width: 100%; height: 100%; margin: 0px auto;display:none">
                                <div id="my_progress_bar_1" style="position: relative; top: 45%; margin: 0px auto;"></div>
                            </div>
                        </td>
                    </tr>
                </table>
                <div style=" overflow:auto; height:80%">
                    <table class="tablesorter" id="ExternalDBTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width=1% nowrap="nowrap"><img onclick="addExternalDB(this);" border="0" src="/Content/images/add.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/></td>
				                <td class="nosorting" width="1%" nowrap="nowrap">ID</td>
				                <td class="nosorting" width="20%" nowrap="nowrap">External DB Name</td>
                                <td class="nosorting" width="50%" nowrap="nowrap">External DB IP</td>
		                </thead>
		                <tbody>
			            </tbody>
		            </table>
                </div>   
            </div>
            <div id="tab24" class="tab_content" style="height:70%">
                <br /><br /><br /><br />
                <input type="hidden" id="AdditionalInfolist" name="AdditionalInfolist" value="0">
                <input type="hidden" id="AdditionalInfoXML" name="AdditionalInfoXML" value="<%= EscapeDataString((string)ViewData["additionalinfoxml"]) %>">
                <label style=" color:red">Warning, modify the below setting might cause SAMIS II to malfunction.<br />Please restart your browser to let the changes take effect.</label><br /><br />
                <input type="button" id="Button8" onclick="checkAndSubmitAdditionalInfo();" value="Update" />                
                <div style=" overflow:auto; height:75%">
                    <table class="tablesorter" id="AdditionalInfoTable" style=" width:100%; padding:0; margin-left:0%; margin-right:0%">
			                <thead>
			                <tr class="header">
                                <td class="nosorting" width="1%" nowrap="nowrap">ID</td>
                                <td class="nosorting" width="20%" nowrap="nowrap">Additional Information Type</td>
				                <td class="nosorting" width="80%" nowrap="nowrap">Additional Information Content</td>
                            </tr>
		                </thead>
		                <tbody>
                            
			            </tbody>
		            </table>
                </div>
            </div>


        </div>  
    </div>
          
    </form>
</asp:Content>
