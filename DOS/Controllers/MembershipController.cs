using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;
using DOS.Models;
using System.Xml.Linq;
using System.Net;
using System.Net.Mail;
using System.IO;
using System.Web.Script.Serialization;

namespace DOS.Controllers
{
    [HandleError]
    public class MembershipController : MasterPageController
    {
        [ErrorHandler]
        [Authorize]
        public ActionResult deleteMember(string NRIC, string Name, string Type)
        {

            int count = sql_conn.usp_removeMember(NRIC, Type).ElementAt(0).Result;

            ViewData["result"] = count.ToString();
            return View("simplehtml");
        }

        //[ErrorHandler]
        //[Authorize]
        //public ActionResult downloadMembershipForm()
        //{
        //    initializedParameter();
        //    ViewData["Type"] = "ADD";
            
        //    Response.AppendHeader("Content-Disposition", "attachment; filename=OfflineForm_"+DateTime.Now.ToString("ddMMyyyy")+".html");
        //    return View();
        //}

        [ErrorHandler]
        [Authorize]
        public ActionResult submitofflineregistration()
        {
            try
            {
                string val = HttpUtility.UrlDecode(Request.Form["xmldoc"]);
                XElement xml = XElement.Parse(val);

                string res = "0";
                sql_conn.usp_addNewMember(xml, ref res);
                if (int.Parse(res) == 1)
                {
                    ViewData["errormsg"] = xml.Element("EnglishName").Value + " added.";
                }
                else
                {
                    ViewData["errormsg"] = xml.Element("EnglishName").Value + " not added. Record exist.";
                }
            }
            catch (Exception e)
            {
                if (e.Source == "System.Xml")
                    ViewData["errormsg"] = "Invalid Content. Please try to copy and paste again.";
                else
                    ViewData["errormsg"] = e.Message;
            }
            return View("OfflineMembership");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult OfflineMembership(){
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateVisitor()
        {
            return View("UpdateVisitorSearchForm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult SearchVisitorForUpdate(string NRIC, string Name)
        {
            if (NRIC == null)
                NRIC = "";
            if (Name == null)
                Name = "";

            ViewData["listofvisitor"] = sql_conn.usp_searchVisitorsForUpdate(NRIC, Name).ToList();
            return View("ListOfVisitors");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult submitUpdateVisitorForm()
        {
            string OriginalNRIC = Request.Form["OriginalNRIC"];
            string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
            string candidate_english_name = Request.Form["candidate_english_name"].ToUpper();
            string candidate_nric = Request.Form["candidate_nric"].ToUpper();
            string candidate_dob = Request.Form["candidate_dob"];
            string candidate_gender = Request.Form["candidate_gender"];
            string candidate_street_address = Request.Form["candidate_street_address"].ToUpper();
            string candidate_blk_house = Request.Form["candidate_blk_house"].ToUpper();
            string candidate_postal_code = Request.Form["candidate_postal_code"];
            string candidate_unit = Request.Form["candidate_unit"];
            string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
            string candidate_email = Request.Form["candidate_email"];
            string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
            string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
            string candidate_contact = Request.Form["candidate_contact"];
            string candidate_church = Request.Form["aspnet_variable$MainContent$church"];
            string candidate_church_others = Request.Form["church_others"];
            string mailingList = "";

            if (Request.Form["mailingList"] != null)
                mailingList = Request.Form["mailingList"].ToUpper();

            XElement xml = toUpdateXMLVisitor(mailingList, User.Identity.Name, OriginalNRIC, candidate_nric, candidate_salutation, candidate_english_name, candidate_unit, candidate_blk_house, candidate_nationality, candidate_occupation, candidate_dob, candidate_gender, candidate_street_address, candidate_postal_code, candidate_email, candidate_education, candidate_contact, candidate_church, candidate_church_others);
            string res = "NotFound";
            sql_conn.usp_updateVistor(xml, ref res);

            if (res == "Updated")
            {
                ViewData["errormsg"] = Request.Form["candidate_english_name"].ToUpper() + "'s profile updated!";
            }
            else if (res == "NoChange")
            {
                ViewData["errormsg"] = "No change to " + Request.Form["candidate_english_name"].ToUpper() + "'s profile";
            }
            else if (res == "NotFound")
            {
                ViewData["errormsg"] = "Record not found.";
            }
    
            return View("UpdateVisitorSearchForm");
        }

        [ErrorHandler]
        [Authorize]
        private XElement toUpdateXMLVisitor(string mailingList, string userID, string OriginalNRIC, string nric, string salutation, string english_name, string unit, string blk_house, string nationality, string occupation, string dob, string gender, string street_address, string postal_code, string email, string education,  string contact, string church, string churchOthers)
        {
            bool convertok = false;
            DateTime dt;
            convertok = DateTime.TryParseExact(dob, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out dt);

            XElement update = XElement.Parse("<Update />");
            update.Add(new XElement("EnteredBy", userID));
            update.Add(new XElement("OriginalNRIC", OriginalNRIC));
            update.Add(new XElement("NRIC", nric));
            update.Add(new XElement("Salutation", salutation));
            update.Add(new XElement("EnglishName", english_name));
            update.Add(new XElement("Gender", gender));
            if (convertok)
                update.Add(new XElement("DOB", dob));
            update.Add(new XElement("Nationality", nationality));
            update.Add(new XElement("AddressStreetName", street_address));
            update.Add(new XElement("AddressPostalCode", postal_code));
            update.Add(new XElement("AddressBlkHouse", blk_house));
            update.Add(new XElement("AddressUnit", unit));
            update.Add(new XElement("Email", email));
            update.Add(new XElement("Education", education));
            update.Add(new XElement("Occupation", occupation));
            update.Add(new XElement("Contact", contact));
            if (church.Length == 0)
                church = "0";
            update.Add(new XElement("Church", church));
            update.Add(new XElement("ChurchOthers", churchOthers));
            update.Add(new XElement("mailingList", mailingList));
            return update;
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateVisitorForStaff(string NRIC)
        {
            initializedParameter();
            usp_getVisitorInformationResult res = sql_conn.usp_getVisitorInformation(NRIC).ElementAt(0);
            ViewData["NRIC"] = res.NRIC;
            ViewData["AddressHouseBlk"] = res.AddressHouseBlk;
            ViewData["AddressPostalCode"] = res.AddressPostalCode;
            ViewData["AddressStreet"] = res.AddressStreet;
            ViewData["AddressUnit"] = res.AddressUnit;
            ViewData["Contact"] = res.Contact;
            ViewData["CourseAttended"] = res.CourseAttended;
            ViewData["DOB"] = res.DOB;
            ViewData["Education"] = res.Education;
            ViewData["Email"] = res.Email;
            ViewData["EnglishName"] = res.EnglishName;
            ViewData["Gender"] = res.Gender;
            ViewData["Nationality"] = res.Nationality;
            ViewData["Occupation"] = res.Occupation;
            ViewData["Salutation"] = res.Salutation;
            ViewData["history"] = res.History;
            ViewData["church"] = res.Church;
            ViewData["church_others"] = res.ChurchOthers;
            ViewData["mailingList"] = res.mailingList.ToString().ToUpper();
            return View("UpdateVisitorForm_forStaff");           
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateCourseAttendance()
        {
            string courseid = Request.Form["aspnet_variable$MainContent$courseid"];
            string date = Request.Form["date"];
            string nric = Request.Form["nric"];
            string res = sql_conn.usp_UpdateCourseAttendance(int.Parse(courseid), nric, DateTime.ParseExact(date, "dd/MM/yyyy", null)).ElementAt(0).Result;

            ViewData["errormsg"] = res;
            ViewData["courseid"] = courseid;
            ViewData["date"] = date;

            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, -1).ToList();
            return View("CourseAttendance");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult courseattendance()
        {
            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true,-1).ToList();
            return View("CourseAttendance");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult courseattendance_bd(string Year)
        {
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();            
            if (Year == null)
                Year = DateTime.Now.Year.ToString();
            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, int.Parse(Year)).ToList();
            ViewData["selectedYear"] = int.Parse(Year);
            return View("CourseAttendance_bd");
        }

        [ErrorHandler]
        public ActionResult displayAgreement()
        {
            return View("Agreement");
        }

        [ErrorHandler]
        public ActionResult displayCourseAgreement(string id)
        {
            usp_getCourseAdditionalInformationResult res = sql_conn.usp_getCourseAdditionalInformation(int.Parse(id)).ElementAt(0);
            ViewData["result"] = res.AgreementHTML;
            return View("simplehtml");
        }

        [ErrorHandler]
        public ActionResult displayCourseAgreementFrame(string id, string random)
        {
            ViewData["iframename"] = random;
            ViewData["siteURL"] = "./displayCourseAgreement?id=" + id;
            return View("displayModalClose");
        }

        private results getGooglePostalCodeResult(string postalCode){
            JavaScriptSerializer ser = new JavaScriptSerializer();
            WebClient client = new WebClient();
            GoogleGeoCodeResponse googlemap;
            string jsonstring;
            string searchURL = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&region=sg&address=Singapore " + postalCode;
            jsonstring = client.DownloadString(searchURL);

            googlemap = ser.Deserialize<GoogleGeoCodeResponse>(jsonstring);
            string lookUpAddress = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&latlng=" + googlemap.results[0].geometry.location.lat + "," + googlemap.results[0].geometry.location.lng;

            jsonstring = client.DownloadString(lookUpAddress);
            googlemap = ser.Deserialize<GoogleGeoCodeResponse>(jsonstring);
            results AddressResult = new results();
            if (googlemap.status == "OK")
            {
                for (int x = 0; x < googlemap.results.Length; x++)
                {
                    if (googlemap.results[x].types[0] == "street_address")
                    {
                        for (int y = 0; y < googlemap.results[x].address_components.Length; y++)
                        {
                            if (googlemap.results[x].address_components[y].types[0] == "street_number")
                            {
                                AddressResult.BLOCK = googlemap.results[x].address_components[y].long_name;
                            }
                            else if (googlemap.results[x].address_components[y].types[0] == "route")
                            {
                                AddressResult.ROAD = googlemap.results[x].address_components[y].long_name;
                            }
                        }
                    }
                }
            }

            return AddressResult;
        }

        [ErrorHandler]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult PostalCodeToAddress(string postalCode)
        {
            try
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                OneMapResponse onemap;
                OneMapBasicSearchResponse oneMapBasic;
                //onemap api
                WebClient clientaa = new WebClient();
                results AddressResult = new results();
                string jsonstringOneMapBasicSearch = clientaa.DownloadString((string)Session["BasicSearchRetrivalURL"] + postalCode);
                oneMapBasic = ser.Deserialize<OneMapBasicSearchResponse>(jsonstringOneMapBasicSearch);
                if (oneMapBasic.SearchResults[0].ErrorMessage != "No result(s) found.")
                {
                    string jsonstringOneMap = clientaa.DownloadString((string)Session["PostalCodeRetrivalURL"] + postalCode + "&location=" + oneMapBasic.SearchResults[1].X + "," + oneMapBasic.SearchResults[1].Y);
                    onemap = ser.Deserialize<OneMapResponse>(jsonstringOneMap);
                    if (onemap != null)
                    {
                        AddressResult.BLOCK = onemap.GeocodeInfo.ElementAt(0).BLOCK;
                        AddressResult.ROAD = onemap.GeocodeInfo.ElementAt(0).ROAD;
                    }
                }
                
                ViewData["result"] = ser.Serialize(AddressResult);
                return View("simplehtml");
            }
            catch (Exception e)
            {
                JavaScriptSerializer ser = new JavaScriptSerializer();
                ViewData["result"] = ser.Serialize(getGooglePostalCodeResult(postalCode));
                return View("simplehtml");                
            }
        }

        [ErrorHandler]        
        public ActionResult courseregistration(string Message, string candidate_course)
        {
            initializedParameter();
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();
            else
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, DateTime.Now.Year).ToList();
            ViewData["Year"] = "1";
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();
            ViewData["Message"] = Message;
            ViewData["candidate_course"] = candidate_course;
            ViewData["existingmember"] = "null";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult courseregistration_ad(string Message, string candidate_course, string Year)
        {
            initializedParameter();
            ViewData["ad"] = "_ad";
            if (Year == null)
            {
                Year = DateTime.Now.Year.ToString();
            }
            ViewData["Year"] = Year;
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();

            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, int.Parse(Year)).ToList();
            ViewData["Message"] = Message;
            ViewData["candidate_course"] = candidate_course;
            ViewData["WalkInDate"] = DateTime.Now.ToString("dd/MM/yyyy");
            return View("courseregistration");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult submitcourseregistration_ad()
        {
            initializedParameter();
            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();

            string existingmember = Request.Form["existingmember"];
            if (existingmember == null)
                existingmember = "null";
            DateTime WalkInDate = DateTime.ParseExact(Request.Form["WalkInDate"], "dd/MM/yyyy", null);
            ViewData["WalkInDate"] = Request.Form["WalkInDate"];
            string candidate_nric = Request.Form["candidate_nric"];
            string candidate_course = Request.Form["aspnet_variable$MainContent$candidate_course"];
            string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
            string candidate_english_name = Request.Form["candidate_english_name"];
            string candidate_dob = Request.Form["candidate_dob"];
            string candidate_gender = Request.Form["candidate_gender"];
            string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
            string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
            string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
            string candidate_postal_code = Request.Form["candidate_postal_code"];
            string decodedAdditionalInformation = HttpUtility.UrlDecode(Request.Form["EncodedAdditionalInformation"]);
            string candidate_blk_house;
            if (Request.Form["candidate_blk_house"] != null)
                candidate_blk_house = Request.Form["candidate_blk_house"];
            else
                candidate_blk_house = Request.Form["hidden_candidate_blk_house"];

            string candidate_street_address;
            if (Request.Form["candidate_street_address"] != null)
                candidate_street_address = Request.Form["candidate_street_address"];
            else
                candidate_street_address = Request.Form["hidden_candidate_street_address"];
            string candidate_unit = Request.Form["candidate_unit"];
            string candidate_contact = Request.Form["candidate_contact"];
            string candidate_email = Request.Form["candidate_email"];
            string candidate_church = Request.Form["aspnet_variable$MainContent$church"];
            string candidate_church_others = Request.Form["church_others"];
            string candidate_course_name = Request.Form["candidate_course_name"];
            string candidate_Congregation = Request.Form["aspnet_variable$MainContent$Congregation"];

            string result = "ERROR";
            usp_addNewCourseMemberParticipantAndAttendanceResult mem;
            usp_addNewCourseVisitorParticipantAndAttendanceResult vis;
            if (candidate_church.Length == 0)
                candidate_church = "0";

            string mailingList = "";
            if (Request.Form["mailingList"] != null)
                mailingList = Request.Form["mailingList"].ToUpper();

            if (existingmember == "null")
            {
                DateTime dt;
                bool convertok = false;
                convertok = DateTime.TryParseExact(candidate_dob, "dd/MM/yyyy", null, System.Globalization.DateTimeStyles.None, out dt);

                if (convertok)
                    vis = sql_conn.usp_addNewCourseVisitorParticipantAndAttendance(mailingList, candidate_nric, candidate_course, candidate_salutation.Split('~')[0], candidate_english_name, dt, candidate_gender, candidate_education, candidate_nationality, candidate_occupation, candidate_postal_code, candidate_blk_house, candidate_street_address, candidate_unit, candidate_contact, candidate_email, int.Parse(candidate_church.Split('~')[0]), candidate_church_others, User.Identity.Name, WalkInDate).ElementAt(0);
                else
                    vis = sql_conn.usp_addNewCourseVisitorParticipantAndAttendance(mailingList, candidate_nric, candidate_course, candidate_salutation.Split('~')[0], candidate_english_name, null, candidate_gender, candidate_education, candidate_nationality, candidate_occupation, candidate_postal_code, candidate_blk_house, candidate_street_address, candidate_unit, candidate_contact, candidate_email, int.Parse(candidate_church.Split('~')[0]), candidate_church_others, User.Identity.Name, WalkInDate).ElementAt(0);

                result = vis.Result;
            }
            else
            {
                mem = sql_conn.usp_addNewCourseMemberParticipantAndAttendance(candidate_nric, int.Parse(candidate_course), WalkInDate).ElementAt(0);
                result = mem.Result;
            }

            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();
            else
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, -1).ToList();

            ViewData["Message"] = result;
            ViewData["candidate_nric"] = "";
            ViewData["ad"] = "_ad";
            ViewData["candidate_course"] = Request.Form["aspnet_variable$MainContent$candidate_course"];
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();
            ViewData["Year"] = "1";
            return View("courseregistration");
        }

        [ErrorHandler]
        public ActionResult submitcourseregistration()
        {
            try
            {
                MailMessage mail = null;
                initializedParameter();
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                    ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();
                else
                    ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, -1).ToList();

                string existingmember = Request.Form["existingmember"];
                if (existingmember == null)
                    existingmember = "null";
                string candidate_nric = Request.Form["candidate_nric"];
                string candidate_course = Request.Form["aspnet_variable$MainContent$candidate_course"];
                string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
                string candidate_english_name = Request.Form["candidate_english_name"];
                string candidate_dob = Request.Form["candidate_dob"];
                string candidate_gender = Request.Form["candidate_gender"];
                string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
                string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
                string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
                string candidate_postal_code = Request.Form["candidate_postal_code"];
                string decodedAdditionalInformation = HttpUtility.UrlDecode(Request.Form["EncodedAdditionalInformation"]);
                string candidate_blk_house;
                if (Request.Form["candidate_blk_house"] != null)
                    candidate_blk_house = Request.Form["candidate_blk_house"];
                else
                    candidate_blk_house = Request.Form["hidden_candidate_blk_house"];

                string candidate_street_address;
                if (Request.Form["candidate_street_address"] != null)
                    candidate_street_address = Request.Form["candidate_street_address"];
                else
                    candidate_street_address = Request.Form["hidden_candidate_street_address"];
                string candidate_unit = Request.Form["candidate_unit"];
                string candidate_contact = Request.Form["candidate_contact"];
                string candidate_email = Request.Form["candidate_email"];
                string candidate_church = Request.Form["aspnet_variable$MainContent$church"];
                string candidate_church_others = Request.Form["church_others"];
                string candidate_course_name = Request.Form["candidate_course_name"];
                string candidate_Congregation = Request.Form["aspnet_variable$MainContent$Congregation"];

                string mailingList = "";
                if (Request.Form["mailingList"] != null)
                    mailingList = Request.Form["mailingList"].ToUpper();

                XElement temp = new XElement("Info");
                temp.Add(new XElement("Header", Request.Headers.ToString()));
                temp.Add(new XElement("Form", Request.Form.ToString()));
                temp.Add(new XElement("decodedAdditionalInformation", decodedAdditionalInformation));
                temp.Add(new XElement("UserAgent", Request.UserAgent));
                temp.Add(new XElement("UserHostAddress", Request.UserHostAddress));
                temp.Add(new XElement("UserHostName", Request.UserHostName));
                temp.Add(new XElement("Params", Request.Params.ToString()));

                ViewData["candidate_course_name"] = candidate_course_name;
                ViewData["existingmember"] = existingmember;
                ViewData["candidate_nric"] = candidate_nric;
                ViewData["candidate_course"] = candidate_course;
                ViewData["candidate_salutation"] = candidate_salutation;
                ViewData["candidate_english_name"] = candidate_english_name;
                ViewData["candidate_dob"] = candidate_dob;
                ViewData["candidate_gender"] = candidate_gender;
                ViewData["candidate_education"] = candidate_education;
                ViewData["candidate_nationality"] = candidate_nationality;
                ViewData["candidate_occupation"] = candidate_occupation;
                ViewData["candidate_postal_code"] = candidate_postal_code;
                ViewData["candidate_blk_house"] = candidate_blk_house;
                ViewData["candidate_street_address"] = candidate_street_address;
                ViewData["candidate_unit"] = candidate_unit;
                ViewData["candidate_contact"] = candidate_contact;
                ViewData["candidate_email"] = candidate_email;
                ViewData["candidate_church"] = candidate_church;
                ViewData["candidate_church_others"] = candidate_church_others;

                XElement additionalInfo = XElement.Parse(decodedAdditionalInformation);

                string result = "ERROR";
                string sal = "";
                string name = "";
                string course = "";
                usp_addNewCourseMemberParticipantResult mem;

                if (candidate_church.Length == 0)
                    candidate_church = "0";

                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    string mailbody = (string)Session["CourseRegistration"];
                    mailbody = mailbody.Replace("[candidate_course_name]", candidate_course_name);
                    mailbody = mailbody.Replace("[candidate_nric]", candidate_nric);
                    mailbody = mailbody.Replace("[candidate_salutation]", candidate_salutation);
                    mailbody = mailbody.Replace("[candidate_english_name]", candidate_english_name);
                    mailbody = mailbody.Replace("[candidate_dob]", candidate_dob);
                    mailbody = mailbody.Replace("[candidate_gender]", candidate_gender);
                    mailbody = mailbody.Replace("[candidate_nationality]", candidate_nationality);
                    mailbody = mailbody.Replace("[candidate_education]", candidate_education);
                    mailbody = mailbody.Replace("[candidate_church]", candidate_church);
                    mailbody = mailbody.Replace("[candidate_occupation]", candidate_occupation);
                    mailbody = mailbody.Replace("[candidate_church_others]", candidate_church_others);
                    mailbody = mailbody.Replace("[candidate_postal_code]", candidate_postal_code);
                    mailbody = mailbody.Replace("[candidate_blk_house]", candidate_blk_house);
                    mailbody = mailbody.Replace("[candidate_contact]", candidate_contact);
                    mailbody = mailbody.Replace("[candidate_email]", candidate_email);
                    mailbody = mailbody.Replace("[candidate_unit]", candidate_unit);
                    mailbody = mailbody.Replace("[candidate_street_address]", candidate_street_address);
                    mailbody = mailbody.Replace("[AdditionalInformation]", decodedAdditionalInformation);
                    mailbody = mailbody.Replace("[Congregation]", candidate_Congregation);
                    if (candidate_church.StartsWith((string)Session["OtherChurchParish"]))
                        mailbody = mailbody.Replace("[combine_church]", candidate_church_others);
                    else
                        mailbody = mailbody.Replace("[combine_church]", candidate_church);

                    string age = "";
                    if (candidate_dob.Length > 0)
                    {
                        age = (DateTime.Now.Year - DateTime.ParseExact(candidate_dob, "dd/MM/yyyy", null).Year).ToString();
                    }
                    mailbody = mailbody.Replace("[Age]", age);

                    mail = new MailMessage();
                    mail.IsBodyHtml = true;
                    string to = (string)Session["CERegistrationRecipients"] + ";" + candidate_email;

                    mail.From = new MailAddress((string)Session["SMTPAccount"]);

                    if (to.Length == 0)
                        to = "zniter81@gmail.com";
                    string[] emailTo = to.Split(';');
                    for (int x = 0; x < emailTo.Length; x++)
                    {
                        if (emailTo[x].Trim().Length != 0)
                            mail.To.Add("<" + emailTo[x].Trim() + ">");
                    }

                    mail.Subject = "Course Registration - " + candidate_course_name;        // put subject here	        
                    mail.IsBodyHtml = true;
                    mail.Body = mailbody;

                    sal = candidate_salutation;
                    name = candidate_english_name;
                    course = candidate_course_name;
                }

                XElement visitorxml = toUpdateXMLVisitor(mailingList, "Unspecified", candidate_nric, candidate_nric, candidate_salutation.Split('~')[0], candidate_english_name, candidate_unit, candidate_blk_house, candidate_nationality.Split('~')[0], candidate_occupation.Split('~')[0], candidate_dob, candidate_gender, candidate_street_address, candidate_postal_code, candidate_email, candidate_education.Split('~')[0], candidate_contact, candidate_church.Split('~')[0], candidate_church_others);
                if (existingmember == "null")
                {
                    sql_conn.usp_addNewCourseVisitorParticipant(visitorxml, candidate_course, ref result, ref sal, ref name, ref course, additionalInfo);
                }
                else
                {
                    mem = sql_conn.usp_addNewCourseMemberParticipant(candidate_nric, int.Parse(candidate_course), additionalInfo).ElementAt(0);
                    sal = mem.SalutationName;
                    name = mem.EnglishName;
                    course = mem.CourseName;
                    result = mem.Result;
                }


                ViewData["candidate_course"] = Request.Form["aspnet_variable$MainContent$candidate_course"];
                string url = "";
                sql_conn.usp_getCourseURL(int.Parse(candidate_course), ref url);

                ViewData["CourseURL"] = url;
                ViewData["ShowFB"] = (Session["ShowShareCourseOnFacebook"]).ToString().ToUpper();
                if (result == "OK")
                {
                    if (((string)Session["SystemMode"]).ToUpper() != "FULL" && mail != null)
                        sendEmail(mail);

                    ViewData["Message"] = "<label style=\"color:green;\">" + sal + " " + name + ", registration for [" + course + "], successfully.</label>";
                    return View("courseregistration");
                }
                else if (result == "EXISTS")
                {
                    ViewData["Message"] = "<label style=\"color:green;\">" + sal + " " + name + ", is already registered for [" + course + "].</label>";
                    return View("courseregistration");
                }
                else if (result == "NOTEXISTS")
                {
                    ViewData["Message"] = "<label style=\"color:red;\">" + candidate_nric + " is not a member nor a revisiting visitor.</label>";
                    ViewData["ShowFB"] = "FALSE";
                    return View("courseregistration");
                }
                else if (result == "NRICEXISTS")
                {
                    ViewData["Message"] = "<label style=\"color:red;\">" + candidate_english_name + " is already registered visitor, Please tick the 'Existing Member?/Revisiting Visitor?'</label>";
                    ViewData["ShowFB"] = "FALSE";
                    return View("courseregistration");
                }
                else if (result == "ERROR")
                {
                    ViewData["ShowFB"] = "FALSE";
                    ViewData["Message"] = "<label style=\"color:red;\">Unable to register user. Please try again.</label>";
                    return View("courseregistration");
                }

                return View();
            }
            catch (Exception e)
            {
                initializedParameter();
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                    ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();
                else
                    ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, -1).ToList();
                ViewData["Message"] = "<label style=\"color:red;\">Unable to register user. Please try again.</label>";          
                ViewData["existingmember"] = "null";
                return View("courseregistration");
            }
        }

        [ErrorHandler]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult submitApproveMembers(string NRIC)
        {
            int count = 0;
            IEnumerable<usp_ApproveMembershipResult> res = sql_conn.usp_ApproveMembership(NRIC).ToList();
            count = res.Count();

            for (int x = 0; x < count; x++ )
            {
                string from = Session["icphotolocation"].ToString() + "temp_" + res.ElementAt(x).ICPhoto;
                string to = Session["icphotolocation"].ToString() + res.ElementAt(x).ICPhoto;
                if (System.IO.File.Exists(from))
                    System.IO.File.Move(from, to);
            }
            ViewData["errormsg"] = "Total " + count.ToString() + " member/s approved.";
            ViewData["listoftempmembers"] = sql_conn.usp_getListOfTempMembersForApproval().ToList();
            return View("NewMemberApproval");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult NewMemberApproval()
        {
            ViewData["listoftempmembers"] = sql_conn.usp_getListOfTempMembersForApproval().ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult NewMemberResubmit()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SearchTempMember(string NRIC, string DOB)
        {
            IEnumerable<usp_searchTempMembersResult> res = sql_conn.usp_searchTempMembers(NRIC, DateTime.ParseExact(DOB, "dd/MM/yyyy", null)).ToList();
            if (res.Count() == 0)
            {
                ViewData["message"] = "Record not found!";
                return View("NewMemberResubmit");
            }
            initializedParameter();

            ViewData["candidate_congregation"] = ((int)res.ElementAt(0).Congregation).ToString();
            if (res.ElementAt(0).MarriageDate != null)
                ViewData["candidate_marriage_date"] = ((DateTime)res.ElementAt(0).MarriageDate).ToString("dd/MM/yyyy");

            if (res.ElementAt(0).BaptismDate != null || res.ElementAt(0).BaptismBy.Length > 0 || (int)res.ElementAt(0).BaptismChurch > 0
                || res.ElementAt(0).ConfirmDate != null || res.ElementAt(0).ConfirmBy.Length > 0 || (int)res.ElementAt(0).ConfirmChurch > 0
                || (int)res.ElementAt(0).PreviousChurch > 0)
                ViewData["candidate_christian_yes_no"] = "on";
            ViewData["candidate_salutation"] = ((int)res.ElementAt(0).Salutation).ToString();
            ViewData["candidate_photo"] = res.ElementAt(0).ICPhoto;
            ViewData["candidate_english_name"] = res.ElementAt(0).EnglishName;
            ViewData["candidate_chinses_name"] = res.ElementAt(0).ChineseName;
            ViewData["candidate_nric"] = res.ElementAt(0).NRIC.ToUpper();
            ViewData["candidate_dob"] = res.ElementAt(0).DOB.ToString("dd/MM/yyyy");
            ViewData["candidate_gender"] = res.ElementAt(0).Gender;
            ViewData["candidate_marital_status"] = ((int)res.ElementAt(0).MaritalStatus).ToString();
            ViewData["candidate_street_address"] = res.ElementAt(0).AddressStreet.ToUpper();
            ViewData["candidate_blk_house"] = res.ElementAt(0).AddressHouseBlk.ToUpper();
            ViewData["candidate_unit"] = res.ElementAt(0).AddressUnit;
            ViewData["candidate_postal_code"] = res.ElementAt(0).AddressPostalCode.ToString();
            ViewData["candidate_nationality"] = ((int)res.ElementAt(0).Nationality).ToString();
            ViewData["candidate_dialect"] = ((int)res.ElementAt(0).Dialect).ToString();
            ViewData["candidate_email"] = res.ElementAt(0).Email;
            ViewData["candidate_education"] = ((int)res.ElementAt(0).Education).ToString();
            ViewData["candidate_language"] = res.ElementAt(0).Language;
            ViewData["candidate_occupation"] = ((int)res.ElementAt(0).Occupation).ToString();
            ViewData["candidate_home_tel"] = res.ElementAt(0).HomeTel;
            ViewData["candidate_mobile_tel"] = res.ElementAt(0).MobileTel;
            if (res.ElementAt(0).BaptismDate != null)
                ViewData["candidate_baptism_date"] = ((DateTime)res.ElementAt(0).BaptismDate).ToString("dd/MM/yyyy");
            ViewData["baptized_by"] = res.ElementAt(0).BaptismBy;
            ViewData["baptism_church"] = ((int)res.ElementAt(0).BaptismChurch).ToString();
            if (res.ElementAt(0).ConfirmDate != null)
                ViewData["candidate_confirmation_date"] = ((DateTime)res.ElementAt(0).ConfirmDate).ToString("dd/MM/yyyy");
            ViewData["confirmation_by"] = res.ElementAt(0).ConfirmBy;
            ViewData["confirmation_church"] = ((int)res.ElementAt(0).ConfirmChurch).ToString();
            ViewData["previous_church_membership"] = ((int)res.ElementAt(0).PreviousChurch).ToString();
            ViewData["sponsor1"] = res.ElementAt(0).Sponsor1;
            ViewData["sponsor2"] = res.ElementAt(0).Sponsor2;
            ViewData["sponsor2contact"] = res.ElementAt(0).Sponsor2Contact;
            ViewData["sponsor1_input"] = res.ElementAt(0).Sponsor1Text;
            ViewData["sponsor2_input"] = res.ElementAt(0).Sponsor2Text;
            ViewData["candidate_transfer_reason"] = res.ElementAt(0).TransferReason;

            ViewData["baptized_by_others"] = res.ElementAt(0).BaptismByOthers;
            ViewData["baptism_church_others"] = res.ElementAt(0).BaptismChurchOthers;
            ViewData["confirm_by_others"] = res.ElementAt(0).ConfirmByOthers;
            ViewData["confirmation_church_others"] = res.ElementAt(0).ConfirmChurchOthers;
            ViewData["previous_church_membership_others"] = res.ElementAt(0).PreviousChurchOthers;

            string MinistryInterested = "";
            for (int x = 0; x < res.ElementAt(0).MinistryInterested.Elements("MinistryID").Count(); x++)
            {
                MinistryInterested += res.ElementAt(0).MinistryInterested.Elements("MinistryID").ElementAt(x).Value + ",";
            }
            ViewData["candidate_interested_ministry"] = MinistryInterested;

            if (res.ElementAt(0).CellgroupInterested)
                ViewData["candidate_join_cellgroup"] = "on";
            if (res.ElementAt(0).ServeCongregationInterested)
            ViewData["candidate_serve_congregation"] = "on";
            if (res.ElementAt(0).TithingInterested)
                ViewData["candidate_tithing"] = "on";

            ViewData["familylist"] = res.ElementAt(0).Family.ToString();
            ViewData["childlist"] = res.ElementAt(0).Child.ToString();
            ViewData["Type"] = "UPDATE";
            return View("MembershipForm");
        }

        [ErrorHandler]        
        public ActionResult NewMember(string message)
        {
            initializedParameter();
            ViewData["Type"] = "ADD";
            ViewData["errormsg"] = message;
            Session["FileIOStream"] = null;
            Session["FileName"] = "";
            return View("MembershipForm");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult resubmitMemberForm()
        {
            initializedParameter();
            string candidate_congregation = Request.Form["aspnet_variable$MainContent$candidate_congregation"];
            string OriginalNRIC = Request.Form["OriginalNRIC"];
            string candidate_marriage_date = Request.Form["candidate_marriage_date"];
            string candidate_christian_yes_no = Request.Form["candidate_christian_yes_no"];
            string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
            string candidate_photo = Request.Form["candidate_photo"];
            string candidate_english_name = Request.Form["candidate_english_name"].ToUpper();
            string candidate_chinses_name = Request.Form["candidate_chinese_name"];
            string candidate_nric = Request.Form["candidate_nric"].ToUpper();
            string candidate_dob = Request.Form["candidate_dob"];
            string candidate_gender = Request.Form["candidate_gender"];
            string candidate_marital_status = Request.Form["aspnet_variable$MainContent$candidate_marital_status"];
            string candidate_street_address = Request.Form["candidate_street_address"].ToUpper();
            string candidate_blk_house = Request.Form["candidate_blk_house"].ToUpper();
            string candidate_postal_code = Request.Form["candidate_postal_code"];
            string candidate_unit = Request.Form["candidate_unit"];
            string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
            string candidate_dialect = Request.Form["aspnet_variable$MainContent$candidate_dialect"];
            string candidate_email = Request.Form["candidate_email"];
            string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
            string candidate_language = Request.Form["candidate_language"];
            string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
            string candidate_home_tel = Request.Form["candidate_home_tel"];
            string candidate_mobile_tel = Request.Form["candidate_mobile_tel"];
            string candidate_baptism_date = Request.Form["candidate_baptism_date"];
            string baptized_by = Request.Form["aspnet_variable$MainContent$baptized_by"];
            string baptism_church = Request.Form["aspnet_variable$MainContent$baptism_church"];
            string candidate_confirmation_date = Request.Form["candidate_confirmation_date"];
            string confirmation_by = Request.Form["aspnet_variable$MainContent$confirm_by"];
            string confirmation_church = Request.Form["aspnet_variable$MainContent$confirmation_church"];
            string previous_church_membership = Request.Form["aspnet_variable$MainContent$previous_church_membership"];
            string sponsor1 = Request.Form["candidate_sponsor1"];
            string sponsor2 = Request.Form["candidate_sponsor2"];
            string sponsor2contact = Request.Form["candidate_sponsor2contact"];
            string candidate_transfer_reason = Request.Form["candidate_transfer_reason"];

            string baptized_by_others = Request.Form["baptized_by_others"];
            string baptism_church_others = Request.Form["baptism_church_others"];
            string confirm_by_others = Request.Form["confirm_by_others"];
            string confirmation_church_others = Request.Form["confirmation_church_others"];
            string previous_church_membership_others = Request.Form["previous_church_membership_others"];

            string childlist = "<ChildList></ChildList>";
            if (Request.Form["childlist"] != "0" && Request.Form["childlist"].Length > 0)
            {
                childlist = "<ChildList>";
                string[] childno = Request.Form["childlist"].Split(',');
                for (int x = 0; x < childno.Count(); x++)
                {
                    childlist += "<Child>";
                    childlist += "<ChildEnglishName>" + Request.Form["child_english_name_" + childno[x]].ToUpper() + "</ChildEnglishName>";
                    childlist += "<ChildChineseName>" + Request.Form["child_chinese_name_" + childno[x]] + "</ChildChineseName>";
                    childlist += "<ChildBaptismDate>" + Request.Form["child_baptism_date_" + childno[x]] + "</ChildBaptismDate>";
                    childlist += "<ChildBaptismBy>" + Request.Form["child_baptism_by_" + childno[x]] + "</ChildBaptismBy>";
                    childlist += "<ChildChurch>" + Request.Form["child_church_" + childno[x]] + "</ChildChurch>";
                    childlist += "</Child>";
                }
                childlist += "</ChildList>";
            }

            string familylist = "<FamilyList></FamilyList>";
            if (Request.Form["familylist"] != "0" && Request.Form["familylist"].Length > 0)
            {
                familylist = "<FamilyList>";
                string[] familyno = Request.Form["familylist"].Split(',');
                for (int x = 0; x < familyno.Count(); x++)
                {
                    familylist += "<Family>";
                    familylist += "<FamilyType>" + Request.Form["family_type_" + familyno[x]] + "</FamilyType>";
                    familylist += "<FamilyEnglishName>" + Request.Form["family_english_name_" + familyno[x]].ToUpper() + "</FamilyEnglishName>";
                    familylist += "<FamilyChineseName>" + Request.Form["family_chinese_name_" + familyno[x]] + "</FamilyChineseName>";
                    familylist += "<FamilyOccupation>" + Request.Form["family_occupation_" + familyno[x]] + "</FamilyOccupation>";
                    familylist += "<FamilyReligion>" + Request.Form["family_religion_" + familyno[x]] + "</FamilyReligion>";
                    familylist += "</Family>";
                }
                familylist += "</FamilyList>";
            }


            string candidate_join_cellgroup = Request.Form["candidate_join_cellgroup"];
            if (candidate_join_cellgroup != null)
                candidate_join_cellgroup = "1";
            else
                candidate_join_cellgroup = "0";
            string candidate_serve_congregation = Request.Form["candidate_serve_congregation"];
            if (candidate_serve_congregation != null)
                candidate_serve_congregation = "1";
            else
                candidate_serve_congregation = "0";
            string candidate_tithing = Request.Form["candidate_tithing"];
            if (candidate_tithing != null)
                candidate_tithing = "1";
            else
                candidate_tithing = "0";

            string candidate_interested_ministry = Request.Form["aspnet_variable$MainContent$candidate_interested_ministry"];
            if (candidate_interested_ministry != null)
            {
                string[] ministry = candidate_interested_ministry.Split(',');
                candidate_interested_ministry = "<Ministry>";
                for (int x = 0; x < ministry.Count(); x++)
                {
                    candidate_interested_ministry += "<MinistryID>" + ministry[x] + "</MinistryID>";
                }
                candidate_interested_ministry += "</Ministry>";
            }
            else
            {
                candidate_interested_ministry = "<Ministry />";
            }

            XElement xml = toUpdateXMLNewMember(User.Identity.Name, OriginalNRIC, candidate_salutation, candidate_photo, candidate_english_name, candidate_unit, candidate_blk_house, candidate_nationality, candidate_dialect, candidate_occupation, baptized_by, baptism_church, confirmation_by, confirmation_church, previous_church_membership, candidate_chinses_name, candidate_nric, candidate_dob, candidate_gender, candidate_marital_status, candidate_street_address, candidate_postal_code, candidate_email, candidate_education, candidate_language, candidate_home_tel, candidate_mobile_tel, candidate_baptism_date, candidate_confirmation_date, candidate_marriage_date, candidate_congregation, sponsor1, sponsor2, familylist, childlist, candidate_join_cellgroup, candidate_interested_ministry, candidate_serve_congregation, candidate_tithing, candidate_transfer_reason, baptized_by_others, baptism_church_others, confirm_by_others, confirmation_church_others, previous_church_membership_others, sponsor2contact);

            string res = sql_conn.usp_UpdateNewMember(xml).ElementAt(0).Result;
            if (res == "Updated")
            {
                //string from = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + candidate_photo;
                //string to = Session["icphotolocation"].ToString() + candidate_photo;
                //if(System.IO.File.Exists(from))
                //    System.IO.File.Move(from, to);
                return RedirectToAction("NewMember", "Membership", new { message = "Member, " + candidate_english_name + " updated." });
            }
            else if (res == "NoChange")
            {
                //string from = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + candidate_photo;
                //string to = Session["icphotolocation"].ToString() + candidate_photo;
                //if(System.IO.File.Exists(from))
                //    System.IO.File.Move(from, to);
                return RedirectToAction("NewMember", "Membership", new { message = "Member, " + candidate_english_name + " unchanged." });
            }
            else if (res == "NotFound")
            {
                ViewData["candidate_congregation"] = Request.Form["aspnet_variable$MainContent$candidate_congregation"];
                ViewData["candidate_marriage_date"] = Request.Form["candidate_marriage_date"];
                ViewData["candidate_christian_yes_no"] = Request.Form["candidate_christian_yes_no"];
                ViewData["candidate_salutation"] = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
                ViewData["candidate_photo"] = Request.Form["candidate_photo"];
                ViewData["candidate_english_name"] = Request.Form["candidate_english_name"].ToUpper();
                ViewData["candidate_chinses_name"] = Request.Form["candidate_chinese_name"];
                ViewData["candidate_nric"] = Request.Form["candidate_nric"].ToUpper();
                ViewData["candidate_dob"] = Request.Form["candidate_dob"];
                ViewData["candidate_gender"] = Request.Form["candidate_gender"];
                ViewData["candidate_marital_status"] = Request.Form["aspnet_variable$MainContent$candidate_marital_status"];
                ViewData["candidate_street_address"] = Request.Form["candidate_street_address"].ToUpper();
                ViewData["candidate_blk_house"] = Request.Form["candidate_blk_house"].ToUpper();
                ViewData["candidate_unit"] = Request.Form["candidate_unit"];
                ViewData["candidate_postal_code"] = Request.Form["candidate_postal_code"];
                ViewData["candidate_nationality"] = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
                ViewData["candidate_dialect"] = Request.Form["aspnet_variable$MainContent$candidate_dialect"];
                ViewData["candidate_email"] = Request.Form["candidate_email"];
                ViewData["candidate_education"] = Request.Form["aspnet_variable$MainContent$candidate_education"];
                ViewData["candidate_language"] = Request.Form["candidate_language"];
                ViewData["candidate_occupation"] = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
                ViewData["candidate_home_tel"] = Request.Form["candidate_home_tel"];
                ViewData["candidate_mobile_tel"] = Request.Form["candidate_mobile_tel"];
                ViewData["candidate_baptism_date"] = Request.Form["candidate_baptism_date"];
                ViewData["baptized_by"] = Request.Form["aspnet_variable$MainContent$baptized_by"];
                ViewData["baptism_church"] = Request.Form["aspnet_variable$MainContent$baptism_church"];
                ViewData["candidate_confirmation_date"] = Request.Form["candidate_confirmation_date"];
                ViewData["confirmation_by"] = Request.Form["aspnet_variable$MainContent$confirm_by"];
                ViewData["confirmation_church"] = Request.Form["aspnet_variable$MainContent$confirmation_church"];
                ViewData["previous_church_membership"] = Request.Form["aspnet_variable$MainContent$previous_church_membership"];
                ViewData["sponsor1"] = Request.Form["candidate_sponsor1"];
                ViewData["sponsor1_input"] = Request.Form["candidate_sponsor1_text"];                
                ViewData["sponsor2"] = Request.Form["candidate_sponsor2"];
                ViewData["sponsor2contact"] = Request.Form["candidate_sponsor2contact"];
                ViewData["candidate_transfer_reason"] = Request.Form["candidate_transfer_reason"];

                ViewData["candidate_interested_ministry"] = Request.Form["aspnet_variable$MainContent$candidate_interested_ministry"];
                ViewData["candidate_join_cellgroup"] = Request.Form["candidate_join_cellgroup"];
                ViewData["candidate_serve_congregation"] = Request.Form["candidate_serve_congregation"];
                ViewData["candidate_tithing"] = Request.Form["candidate_tithing"];

                ViewData["familylist"] = familylist;
                ViewData["childlist"] = childlist;

                ViewData["errormsg"] = "Member, " + candidate_english_name + " not Updated. Please try again.";
            }
            ViewData["Type"] = "UPDATE";
            return View("MembershipForm");
        }


        [ErrorHandler]        
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult submitMemberForm()
        {
            try
            {
                initializedParameter();

                string candidate_congregation = Request.Form["aspnet_variable$MainContent$candidate_congregation"];
                string candidate_marriage_date = Request.Form["candidate_marriage_date"];
                string candidate_christian_yes_no = Request.Form["candidate_christian_yes_no"];
                string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
                string candidate_photo = Request.Form["candidate_photo"];
                string candidate_english_name = Request.Form["candidate_english_name"].ToUpper();
                string candidate_chinses_name = Request.Form["candidate_chinese_name"];
                string candidate_nric = Request.Form["candidate_nric"].ToUpper();
                string candidate_dob = Request.Form["candidate_dob"];
                string candidate_gender = Request.Form["candidate_gender"];
                string candidate_marital_status = Request.Form["aspnet_variable$MainContent$candidate_marital_status"];
                string candidate_street_address = Request.Form["candidate_street_address"].ToUpper();
                string candidate_blk_house = Request.Form["candidate_blk_house"].ToUpper();
                string candidate_postal_code = Request.Form["candidate_postal_code"];
                string candidate_unit = Request.Form["candidate_unit"];
                string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
                string candidate_dialect = Request.Form["aspnet_variable$MainContent$candidate_dialect"];
                string candidate_email = Request.Form["candidate_email"];
                string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
                string candidate_language = Request.Form["candidate_language"];
                string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
                string candidate_home_tel = Request.Form["candidate_home_tel"];
                string candidate_mobile_tel = Request.Form["candidate_mobile_tel"];
                string candidate_baptism_date = Request.Form["candidate_baptism_date"];
                string baptized_by = Request.Form["aspnet_variable$MainContent$baptized_by"];
                string baptism_church = Request.Form["aspnet_variable$MainContent$baptism_church"];
                string candidate_confirmation_date = Request.Form["candidate_confirmation_date"];
                string confirmation_by = Request.Form["aspnet_variable$MainContent$confirm_by"];
                string confirmation_church = Request.Form["aspnet_variable$MainContent$confirmation_church"];
                string previous_church_membership = Request.Form["aspnet_variable$MainContent$previous_church_membership"];
                string sponsor1 = Request.Form["candidate_sponsor1"];
                string sponsor2 = Request.Form["candidate_sponsor2"];
                string sponsor2contact = Request.Form["candidate_sponsor2contact"];
                string candidate_transfer_reason = Request.Form["candidate_transfer_reason"];

                string baptized_by_others = Request.Form["baptized_by_others"];
                string baptism_church_others = Request.Form["baptism_church_others"];
                string confirm_by_others = Request.Form["confirm_by_others"];
                string confirmation_church_others = Request.Form["confirmation_church_others"];
                string previous_church_membership_others = Request.Form["previous_church_membership_others"];
                string childhtml = "";
                string familyhtml = "";

                string childlist = "<ChildList></ChildList>";
                if (Request.Form["childlist"] != "0" && Request.Form["childlist"].Length > 0)
                {
                    childlist = "<ChildList>";
                    string[] childno = Request.Form["childlist"].Split(',');
                    for (int x = 0; x < childno.Count(); x++)
                    {
                        childlist += "<Child>";
                        childlist += "<ChildEnglishName>" + Request.Form["child_english_name_" + childno[x]].ToUpper() + "</ChildEnglishName>";
                        childlist += "<ChildChineseName>" + Request.Form["child_chinese_name_" + childno[x]] + "</ChildChineseName>";
                        childlist += "<ChildBaptismDate>" + Request.Form["child_baptism_date_" + childno[x]] + "</ChildBaptismDate>";
                        childlist += "<ChildBaptismBy>" + Request.Form["child_baptism_by_" + childno[x]] + "</ChildBaptismBy>";
                        childlist += "<ChildChurch>" + Request.Form["child_church_" + childno[x]] + "</ChildChurch>";
                        childlist += "</Child>";

                        childhtml += "<tr><td>" + Request.Form["child_english_name_" + childno[x]].ToUpper() + "</td><td>" + Request.Form["child_chinese_name_" + childno[x]].ToUpper() + "</td><td>" + Request.Form["child_baptism_date_" + childno[x]].ToUpper() + "</td><td>" + Request.Form["child_baptism_by_" + childno[x]].ToUpper() + "</td><td>" + Request.Form["child_church_text_" + childno[x]].ToUpper() + "</td></tr>";
                    }
                    childlist += "</ChildList>";
                }

                string familylist = "<FamilyList></FamilyList>";
                if (Request.Form["familylist"] != "0" && Request.Form["familylist"].Length > 0)
                {
                    familylist = "<FamilyList>";
                    string[] familyno = Request.Form["familylist"].Split(',');
                    for (int x = 0; x < familyno.Count(); x++)
                    {
                        familylist += "<Family>";
                        familylist += "<FamilyType>" + Request.Form["family_type_" + familyno[x]] + "</FamilyType>";
                        familylist += "<FamilyEnglishName>" + Request.Form["family_english_name_" + familyno[x]].ToUpper() + "</FamilyEnglishName>";
                        familylist += "<FamilyChineseName>" + Request.Form["family_chinese_name_" + familyno[x]] + "</FamilyChineseName>";
                        familylist += "<FamilyOccupation>" + Request.Form["family_occupation_" + familyno[x]] + "</FamilyOccupation>";
                        familylist += "<FamilyReligion>" + Request.Form["family_religion_" + familyno[x]] + "</FamilyReligion>";
                        familylist += "</Family>";
                        familyhtml += "<tr><td>" + Request.Form["family_type_text_" + familyno[x]] + "</td><td>" + Request.Form["family_english_name_" + familyno[x]] + "</td><td>" + Request.Form["family_chinese_name_" + familyno[x]] + "</td><td>" + Request.Form["family_occupation_text_" + familyno[x]] + "</td><td>" + Request.Form["family_religion_text_" + familyno[x]] + "</td></tr>";
                    }
                    familylist += "</FamilyList>";
                }


                string candidate_join_cellgroup = Request.Form["candidate_join_cellgroup"];
                if (candidate_join_cellgroup != null)
                    candidate_join_cellgroup = "1";
                else
                    candidate_join_cellgroup = "0";
                string candidate_serve_congregation = Request.Form["candidate_serve_congregation"];
                if (candidate_serve_congregation != null)
                    candidate_serve_congregation = "1";
                else
                    candidate_serve_congregation = "0";
                string candidate_tithing = Request.Form["candidate_tithing"];
                if (candidate_tithing != null)
                    candidate_tithing = "1";
                else
                    candidate_tithing = "0";

                string candidate_interested_ministry = Request.Form["aspnet_variable$MainContent$candidate_interested_ministry"];
                if (candidate_interested_ministry != null)
                {
                    string[] ministry = candidate_interested_ministry.Split(',');
                    candidate_interested_ministry = "<Ministry>";
                    for (int x = 0; x < ministry.Count(); x++)
                    {
                        candidate_interested_ministry += "<MinistryID>" + ministry[x] + "</MinistryID>";
                    }
                    candidate_interested_ministry += "</Ministry>";
                }
                else
                {
                    candidate_interested_ministry = "<Ministry />";
                }




                ViewData["candidate_congregation"] = Request.Form["aspnet_variable$MainContent$candidate_congregation"];
                ViewData["candidate_marriage_date"] = Request.Form["candidate_marriage_date"];
                ViewData["candidate_christian_yes_no"] = Request.Form["candidate_christian_yes_no"];
                ViewData["candidate_salutation"] = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
                ViewData["candidate_photo"] = Request.Form["candidate_photo"];
                ViewData["candidate_english_name"] = Request.Form["candidate_english_name"].ToUpper();
                ViewData["candidate_chinses_name"] = Request.Form["candidate_chinese_name"];
                ViewData["candidate_nric"] = Request.Form["candidate_nric"].ToUpper();
                ViewData["candidate_dob"] = Request.Form["candidate_dob"];
                ViewData["candidate_gender"] = Request.Form["candidate_gender"];
                ViewData["candidate_marital_status"] = Request.Form["aspnet_variable$MainContent$candidate_marital_status"];
                ViewData["candidate_street_address"] = Request.Form["candidate_street_address"].ToUpper();
                ViewData["candidate_blk_house"] = Request.Form["candidate_blk_house"].ToUpper();
                ViewData["candidate_unit"] = Request.Form["candidate_unit"];
                ViewData["candidate_postal_code"] = Request.Form["candidate_postal_code"];
                ViewData["candidate_nationality"] = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
                ViewData["candidate_dialect"] = Request.Form["aspnet_variable$MainContent$candidate_dialect"];
                ViewData["candidate_email"] = Request.Form["candidate_email"];
                ViewData["candidate_education"] = Request.Form["aspnet_variable$MainContent$candidate_education"];
                ViewData["candidate_language"] = Request.Form["candidate_language"];
                ViewData["candidate_occupation"] = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
                ViewData["candidate_home_tel"] = Request.Form["candidate_home_tel"];
                ViewData["candidate_mobile_tel"] = Request.Form["candidate_mobile_tel"];
                ViewData["candidate_baptism_date"] = Request.Form["candidate_baptism_date"];
                ViewData["baptized_by"] = Request.Form["aspnet_variable$MainContent$baptized_by"];
                ViewData["baptism_church"] = Request.Form["aspnet_variable$MainContent$baptism_church"];
                ViewData["candidate_confirmation_date"] = Request.Form["candidate_confirmation_date"];
                ViewData["confirmation_by"] = Request.Form["aspnet_variable$MainContent$confirm_by"];
                ViewData["confirmation_church"] = Request.Form["aspnet_variable$MainContent$confirmation_church"];
                ViewData["previous_church_membership"] = Request.Form["aspnet_variable$MainContent$previous_church_membership"];
                ViewData["sponsor1"] = Request.Form["candidate_sponsor1"];
                ViewData["sponsor2"] = Request.Form["candidate_sponsor2"];
                ViewData["sponsor2contact"] = Request.Form["candidate_sponsor2contact"];
                ViewData["sponsor1_input"] = Request.Form["candidate_sponsor1_text"];
                ViewData["candidate_transfer_reason"] = Request.Form["candidate_transfer_reason"];

                ViewData["candidate_interested_ministry"] = Request.Form["aspnet_variable$MainContent$candidate_interested_ministry"];
                ViewData["candidate_join_cellgroup"] = Request.Form["candidate_join_cellgroup"];
                ViewData["candidate_serve_congregation"] = Request.Form["candidate_serve_congregation"];
                ViewData["candidate_tithing"] = Request.Form["candidate_tithing"];

                ViewData["baptized_by_others"] = Request.Form["baptized_by_others"];
                ViewData["baptism_church_others"] = Request.Form["baptism_church_others"];
                ViewData["confirm_by_others"] = Request.Form["confirm_by_others"];
                ViewData["confirmation_church_others"] = Request.Form["confirmation_church_others"];
                ViewData["previous_church_membership_others"] = Request.Form["previous_church_membership_others"];

                ViewData["familylist"] = familylist;
                ViewData["childlist"] = childlist;


                XElement xml = toAddXMLNewMember(User.Identity.Name, candidate_salutation, candidate_photo, candidate_english_name, candidate_unit, candidate_blk_house, candidate_nationality, candidate_dialect, candidate_occupation, baptized_by, baptism_church, confirmation_by, confirmation_church, previous_church_membership, candidate_chinses_name, candidate_nric, candidate_dob, candidate_gender, candidate_marital_status, candidate_street_address, candidate_postal_code, candidate_email, candidate_education, candidate_language, candidate_home_tel, candidate_mobile_tel, candidate_baptism_date, candidate_confirmation_date, candidate_marriage_date, candidate_congregation, sponsor1, sponsor2, XElement.Parse(familylist), XElement.Parse(childlist), XElement.Parse(candidate_interested_ministry), candidate_join_cellgroup, candidate_serve_congregation, candidate_tithing, candidate_transfer_reason, baptized_by_others, baptism_church_others, confirm_by_others, confirmation_church_others, previous_church_membership_others, sponsor2contact);
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    string mailBody = (string)Session["GreenForm"];
                    mailBody = mailBody.Replace("[Salutation]", Request.Form["SalutationText"]);
                    mailBody = mailBody.Replace("[English Name]", candidate_english_name);
                    mailBody = mailBody.Replace("[Chinese Name]", candidate_chinses_name);
                    mailBody = mailBody.Replace("[DOB]", candidate_dob);
                    mailBody = mailBody.Replace("[Gender]", Request.Form["GenderText"]);
                    mailBody = mailBody.Replace("[NRIC]", candidate_nric);
                    mailBody = mailBody.Replace("[Nationality]", Request.Form["NationalityText"]);
                    mailBody = mailBody.Replace("[Dialect]", Request.Form["DialectText"]);
                    mailBody = mailBody.Replace("[Marital Status]", Request.Form["MaritalStatusText"]);
                    mailBody = mailBody.Replace("[Marital Status Date]", candidate_marriage_date);
                    mailBody = mailBody.Replace("[Postal Code]", candidate_postal_code);
                    mailBody = mailBody.Replace("[Email]", candidate_email);
                    mailBody = mailBody.Replace("[Education]", Request.Form["EducationText"]);
                    mailBody = mailBody.Replace("[Blk House]", candidate_blk_house);
                    mailBody = mailBody.Replace("[Language]", Request.Form["LanguageText"]);
                    mailBody = mailBody.Replace("[Occupation]", Request.Form["OccupationText"]);
                    mailBody = mailBody.Replace("[Unit]", candidate_unit);
                    mailBody = mailBody.Replace("[Home Tel]", candidate_home_tel);
                    mailBody = mailBody.Replace("[Mobile Tel]", candidate_mobile_tel);
                    mailBody = mailBody.Replace("[Street Address]", candidate_street_address);

                    mailBody = mailBody.Replace("[Congregation]", Request.Form["CongregationText"]);
                    mailBody = mailBody.Replace("[Sponsor 1]", Request.Form["candidate_sponsor1_text"]);
                    mailBody = mailBody.Replace("[Sponsor 2]", sponsor2);
                    mailBody = mailBody.Replace("[Sponsor 2 Contact]", sponsor2contact);
                    mailBody = mailBody.Replace("[Baptism Date]", candidate_baptism_date);
                    mailBody = mailBody.Replace("[Baptism By]", Request.Form["BaptisedByText"]);
                    mailBody = mailBody.Replace("[Baptism By Others]", baptized_by_others);
                    mailBody = mailBody.Replace("[Baptism Church]", Request.Form["BaptisedChurchText"]);
                    mailBody = mailBody.Replace("[Baptism Church Others]", baptism_church_others);
                    mailBody = mailBody.Replace("[Confirmation Date]", candidate_confirmation_date);
                    mailBody = mailBody.Replace("[Confirmation By]", Request.Form["ComfirmationByText"]);
                    mailBody = mailBody.Replace("[Confirmation By Others]", confirm_by_others);
                    mailBody = mailBody.Replace("[Confirmation Church]", Request.Form["ComfirmationChurchText"]);
                    mailBody = mailBody.Replace("[Confirmation Church Others]", confirmation_church_others);
                    mailBody = mailBody.Replace("[Previous Church Membership]", Request.Form["PreviousChurchText"]);
                    mailBody = mailBody.Replace("[Previous Church Membership Others]", previous_church_membership_others);
                    mailBody = mailBody.Replace("[Transfer Reason]", candidate_transfer_reason);
                    mailBody = mailBody.Replace("[Family]", familyhtml);
                    mailBody = mailBody.Replace("[Child]", childhtml);
                    if (candidate_join_cellgroup == "1")
                        mailBody = mailBody.Replace("[Join Cellgroup]", "Yes");
                    else
                        mailBody = mailBody.Replace("[Join Cellgroup]", "No");
                    if (candidate_serve_congregation == "1")
                        mailBody = mailBody.Replace("[Serve Congregation]", "Yes");
                    else
                        mailBody = mailBody.Replace("[Serve Congregation]", "No");
                    if (candidate_tithing == "1")
                        mailBody = mailBody.Replace("[Tithing Member]", "Yes");
                    else
                        mailBody = mailBody.Replace("[Tithing Member]", "No");
                    mailBody = mailBody.Replace("[Join Ministry]", Request.Form["MinistryText"]);
                    mailBody = mailBody.Replace("[xmlcontent]", "<table><tr><td>" + xml.ToString().Replace("<", "&lt;").Replace(">", "&gt;") + "</td></tr></table>");


                    MailMessage mail = new MailMessage();
                    mail.IsBodyHtml = true;
                    string to = (string)Session["SamisRegistrationRecipients"];

                    mail.From = new MailAddress((string)Session["SMTPAccount"]);

                    if (to.Length == 0)
                        to = "zniter81@gmail.com";
                    string[] emailTo = to.Split(';');
                    for (int x = 0; x < emailTo.Length; x++)
                    {
                        if (emailTo[x].Trim().Length != 0)
                            mail.To.Add("<" + emailTo[x].Trim() + ">");
                    }

                    mail.Subject = "SAC Green Form Registration";        // put subject here	        
                    mail.IsBodyHtml = true;

                    if (Session["FileIOStream"] == null)
                        mailBody = mailBody.Replace("[attachment]", "<br /><br />");
                    else if (((byte[])Session["FileIOStream"]).Count() > 0)
                    {
                        MemoryStream stream = new MemoryStream((byte[])Session["FileIOStream"]);
                        Attachment attach = new Attachment(stream, (string)Session["FileName"]);
                        mail.Attachments.Add(attach);
                        mailBody = mailBody.Replace("[attachment]", "Attachment of person IC Photo<br /><br />");
                    }


                    mail.Body = mailBody;
                    sendEmail(mail);
                }

                string res = "0";
                sql_conn.usp_addNewMember(xml, ref res);
                if (int.Parse(res) == 1)
                {
                    if (candidate_photo.Length > 0)
                    {
                        if (Session["RemoteStorage"].ToString().ToUpper() == "ON")
                        {
                            new RemoteStorage((string)Session["DropBoxApiKey"], (string)Session["DropBoxAppSecret"], (string)Session["DropBoxUserToken"], (string)Session["DropBoxUserSecret"]).renameRemoteStorageFilename("temp_" + candidate_photo, candidate_photo);
                        }
                        else
                        {
                            string from = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + candidate_photo;
                            string to = Session["icphotolocation"].ToString() + candidate_photo;
                            System.IO.File.Move(from, to);
                        }
                    }
                    return RedirectToAction("NewMember", "Membership", new { message = "Member, " + candidate_english_name + " added." });
                }
                else
                {
                    ViewData["errormsg"] = "Member, " + candidate_english_name + " not added. Record exist.";
                    ViewData["Type"] = "ADD";
                    return View("MembershipForm");
                }
            }
            catch (Exception e)
            {
                ViewData["errormsg"] = "Member, " + Request.Form["candidate_english_name"] + " not added. Please Try again.";
                ViewData["Type"] = "ADD";
                return View("MembershipForm");
            }
            
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateMemberForStaff(string NRIC)
        {
            initializedParameter();
            ViewData["UpdateType"] = "Actual";
            usp_getMemberInformationResult res = sql_conn.usp_getMemberInformation(NRIC, "Actual").ElementAt(0);
            loadMemberforStaff(res);

            return View("UpdateMembershipForm_forStaff");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateTempMemberForStaff(string NRIC)
        {
            initializedParameter();
            ViewData["UpdateType"] = "Temp";
            usp_getMemberInformationResult res = sql_conn.usp_getMemberInformation(NRIC, "Temp").ElementAt(0);
            loadMemberforStaff(res);           
            return View("UpdateMembershipForm_forStaff");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateMember()
        {
            ViewData["Type"] = "UPDATE";
            return View("UpdateMembershipSearchForm");
        }

        [ErrorHandler]
        [Authorize]        
        public ActionResult SearchMemberForUpdate(string NRIC, string Name)
        {
            if(NRIC == null)
                NRIC = "";
            if (Name == null)
                Name = "";

            ViewData["listofmembers"] = sql_conn.usp_searchMembersForUpdate(NRIC, Name, User.Identity.Name).ToList();
            return View("ListOfMembers");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult submitUpdateTempMemberForm()
        {
            string res = updateMemberInformation("Temp");
            if (res == "Updated")
            {
                ViewData["errormsg"] = Request.Form["candidate_english_name"].ToUpper() + "'s profile updated!";
            }
            else if (res == "NoChange")
            {
                ViewData["errormsg"] = "No change to " + Request.Form["candidate_english_name"].ToUpper() + "'s profile";
            }
            else if (res == "NotFound")
            {
                ViewData["errormsg"] = "Record not found.";
            }

            ViewData["listoftempmembers"] = sql_conn.usp_getListOfTempMembersForApproval().ToList();
            return View("NewMemberApproval");            
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult submitUpdateMemberForm()
        {
            string res = updateMemberInformation("Actual");
            updateMemberInformationFilePhoto("Actual");
            if (res == "Updated")
            {
                ViewData["errormsg"] = Request.Form["candidate_english_name"].ToUpper() + "'s profile updated!";
            }
            else if (res == "NoChange")
            {
                ViewData["errormsg"] = "No change to " + Request.Form["candidate_english_name"].ToUpper() + "'s profile";
            }
            else if (res == "NotFound")
            {
                ViewData["errormsg"] = "Record not found.";
            }

            return View("UpdateMembershipSearchForm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult printGreenForm(string nric)
        {
            ViewData["usp_getMemberInformationPrintingResult"] = sql_conn.usp_getMemberInformationPrinting(nric).ElementAt(0);

            return View("GreenForm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult printelectoralroll(string nric)
        {
            ViewData["usp_getMemberInformationPrintingResult"] = sql_conn.usp_getMemberInformationPrinting(nric).ElementAt(0);

            return View("ElectoralRoll");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult printtransferform(string nric)
        {
            ViewData["usp_getMemberInformationPrintingResult"] = sql_conn.usp_getMemberInformationPrinting(nric).ElementAt(0);

            return View("MembershipTransferForm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult getCourseAttendance(string CourseID, string NRIC)
        {
            ViewData["result"] = sql_conn.usp_getCourseParticipantInformation(int.Parse(CourseID), NRIC).ElementAt(0).Attendance;
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult getUploadedAttachment(string nric)
        {
            XElement res = sql_conn.usp_getAllUploadedAttachment(nric).ElementAt(0).XML;
            ViewData["result"] = res.ToString();
            return View("simplehtml");
        }

        public ActionResult submitExtraCourseQuestion()
        {
            string temp = "<div>";
            for (int x = 0; x < Request.Form.Count; x++)
            {
                string sss = Request.Form.Keys[x].ToString();
                if (sss.StartsWith("extra_"))
                {
                    temp += sss.Substring(6) + ":<br />";
                    temp += Request.Form[sss] + "<br /><br />";
                }
            }
            temp += "</div>";

            ViewData["result"] = Microsoft.JScript.GlobalObject.escape(temp);
            return View("CourseAgreement");

        }




        private XElement toAddXMLNewMember(string UserID, string candidate_salutation, string candidate_photo, string candidate_english_name, string candidate_unit, string candidate_blk_house, string candidate_nationality, string candidate_dialect, string candidate_occupation, string baptized_by, string baptism_church, string confirmation_by, string confirmation_church, string previous_church_membership, string candidate_chinses_name, string candidate_nric, string candidate_dob, string candidate_gender, string candidate_marital_status, string candidate_street_address, string candidate_postal_code, string candidate_email, string candidate_education, string candidate_language, string candidate_home_tel, string candidate_mobile_tel, string candidate_baptism_date, string candidate_confirmation_date, string candidate_marriage_date, string candidate_congregation, string sponsor1, string sponsor2, XElement familylist, XElement childlist, XElement candidate_interested_ministry, string candidate_join_cellgroup, string candidate_serve_congregation, string candidate_tithing, string candidate_transfer_reason, string baptized_by_others, string baptism_church_others, string confirm_by_others, string confirmation_church_others, string previous_church_membership_others, string sponsor2contact)
        {
            XElement update = XElement.Parse("<New />");
            update.Add(new XElement("EnteredBy", UserID));
            update.Add(new XElement("NRIC", candidate_nric));
            update.Add(new XElement("Salutation", candidate_salutation));
            update.Add(new XElement("EnglishName", candidate_english_name));
            update.Add(new XElement("ChineseName", candidate_chinses_name));
            update.Add(new XElement("Gender", candidate_gender));
            update.Add(new XElement("DOB", candidate_dob));
            update.Add(new XElement("MaritalStatus", candidate_marital_status));
            update.Add(new XElement("MarriageDate", candidate_marriage_date));
            update.Add(new XElement("Nationality", candidate_nationality));
            update.Add(new XElement("Dialect", candidate_dialect));
            update.Add(new XElement("Photo", candidate_photo));
            update.Add(new XElement("Sponsor1", sponsor1));
            update.Add(new XElement("AddressStreetName", candidate_street_address));
            update.Add(new XElement("AddressPostalCode", candidate_postal_code));
            update.Add(new XElement("AddressBlkHouse", candidate_blk_house));
            update.Add(new XElement("AddressUnit", candidate_unit));
            update.Add(new XElement("HomeTel", candidate_home_tel));
            update.Add(new XElement("MobileTel", candidate_mobile_tel));
            update.Add(new XElement("Email", candidate_email));
            update.Add(new XElement("Education", candidate_education));
            update.Add(new XElement("Language", candidate_language));
            update.Add(new XElement("Occupation", candidate_occupation));
            update.Add(new XElement("Congregation", candidate_congregation));
            update.Add(new XElement("BaptismBy", baptized_by));
            update.Add(new XElement("BaptismDate", candidate_baptism_date));
            update.Add(new XElement("BaptismChurch", baptism_church));
            update.Add(new XElement("ConfirmationBy", confirmation_by));
            update.Add(new XElement("ConfirmationChurch", confirmation_church));
            update.Add(new XElement("ConfirmationDate", candidate_confirmation_date));
            update.Add(new XElement("PreviousChurchMembership", previous_church_membership));
            update.Add(familylist);
            update.Add(childlist);
            update.Add(new XElement("Sponsor2", sponsor2));
            update.Add(new XElement("Sponsor2Contact", sponsor2contact));
            update.Add(new XElement("InterestedServeCongregation", candidate_serve_congregation));
            update.Add(new XElement("InterestedCellgroup", candidate_join_cellgroup));
            update.Add(candidate_interested_ministry);
            update.Add(new XElement("InterestedTithing", candidate_tithing));
            update.Add(new XElement("TransferReason", candidate_transfer_reason));

            update.Add(new XElement("BaptismByOthers", baptized_by_others));
            update.Add(new XElement("BaptismChurchOthers", baptism_church_others));
            update.Add(new XElement("ConfirmByOthers", confirm_by_others));
            update.Add(new XElement("ConfirmChurchOthers", confirmation_church_others));
            update.Add(new XElement("PreviousChurchOthers", previous_church_membership_others));



            return update;
        }
        
        private void initializedParameter(){
            ViewData["educationlist"] = sql_conn.usp_getAllEducation().ToList();
            ViewData["maritalstatuslist"] = sql_conn.usp_getAllMaritalStatus().ToList();
            ViewData["salutationlist"] = sql_conn.usp_getAllSalutation().ToList();
            ViewData["dialectlist"] = sql_conn.usp_getAllDialect().ToList();
            ViewData["occupationlist"] = sql_conn.usp_getAllOccupation().ToList();
            ViewData["countrylist"] = sql_conn.usp_getAllCountry().ToList();
            ViewData["parishlist"] = sql_conn.usp_getAllParish().ToList();
            ViewData["languagelist"] = sql_conn.usp_getAllLanguage().ToList();
            ViewData["clergylist"] = sql_conn.usp_getAllClergy().ToList();
            ViewData["congregationlist"] = sql_conn.usp_getAllCongregation().ToList();
            ViewData["filetypelist"] = sql_conn.usp_getAllFileType().ToList();
            ViewData["familytypelist"] = sql_conn.usp_getAllFamilyType().ToList();

            ViewData["ministrylist"] = sql_conn.usp_getListofMinistry().ToList();

            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(true, -1).ToList();
            else
                ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false, -1).ToList();

            ViewData["cellgrouplist"] = sql_conn.usp_getListofCellgroup().ToList();
            ViewData["religionlist"] = sql_conn.usp_getAllReligion().ToList();
            ViewData["familylist"] = "";
            ViewData["childlist"] = "";
        }

        private void updateMemberInformationFilePhoto(string type)
        {
            if (type == "Actual")
            {
                string photo = Request.Form["candidate_photo"];

                string newPhoto = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + photo;
                string oldPhoto = Session["icphotolocation"].ToString() + photo;
                if (System.IO.File.Exists(newPhoto) && !System.IO.File.Exists(oldPhoto))
                    System.IO.File.Move(newPhoto, oldPhoto);
            }
        }

        private string updateMemberInformation(string type)
        {
            string FileType = "";
            string Filename = "";
            string GUID = Guid.NewGuid().ToString();
            string fileremarks = "";
            for (int x = 0; x < Request.Files.Count; x++ )
            {
                
                var receivedfile = Request.Files[x];
                if (receivedfile.FileName.Length > 0)
                {
                    string saveas = Session["AttachmentLocation"].ToString() + GUID + "_" + receivedfile.FileName;
                    if (!System.IO.File.Exists(saveas))
                    {
                        receivedfile.SaveAs(saveas);
                        FileType = Request.Form["aspnet_variable$MainContent$candidate_FileType"];
                        Filename = receivedfile.FileName;
                        fileremarks = Request.Form["fileRemarks"];
                    }
                }
            }

            string original_nric = Request.Form["OriginalNric"];
            string candidate_congregation = Request.Form["aspnet_variable$MainContent$candidate_congregation"];
            string candidate_marriage_date = Request.Form["candidate_marriage_date"];
            string candidate_christian_yes_no = Request.Form["candidate_christian_yes_no"];
            string candidate_salutation = Request.Form["aspnet_variable$MainContent$candidate_salutation"];
            string candidate_photo = Request.Form["candidate_photo"];
            string candidate_english_name = Request.Form["candidate_english_name"].ToUpper();
            string candidate_chinses_name = Request.Form["candidate_chinese_name"];
            string candidate_nric = Request.Form["candidate_nric"].ToUpper();
            string candidate_dob = Request.Form["candidate_dob"];
            string candidate_gender = Request.Form["candidate_gender"];
            string candidate_marital_status = Request.Form["aspnet_variable$MainContent$candidate_marital_status"];
            string candidate_street_address = Request.Form["candidate_street_address"].ToUpper();
            string candidate_blk_house = Request.Form["candidate_blk_house"].ToUpper();
            string candidate_postal_code = Request.Form["candidate_postal_code"];
            string candidate_unit = Request.Form["candidate_unit"];
            string candidate_nationality = Request.Form["aspnet_variable$MainContent$candidate_nationality"];
            string candidate_dialect = Request.Form["aspnet_variable$MainContent$candidate_dialect"];
            string candidate_email = Request.Form["candidate_email"];
            string candidate_education = Request.Form["aspnet_variable$MainContent$candidate_education"];
            string candidate_language = Request.Form["candidate_language"];
            string candidate_occupation = Request.Form["aspnet_variable$MainContent$candidate_occupation"];
            string candidate_home_tel = Request.Form["candidate_home_tel"];
            string candidate_mobile_tel = Request.Form["candidate_mobile_tel"];
            string candidate_baptism_date = Request.Form["candidate_baptism_date"];
            string baptized_by = Request.Form["aspnet_variable$MainContent$baptized_by"];
            string baptism_church = Request.Form["aspnet_variable$MainContent$baptism_church"];
            string candidate_confirmation_date = Request.Form["candidate_confirmation_date"];
            string confirmation_by = Request.Form["aspnet_variable$MainContent$confirm_by"];
            string confirmation_church = Request.Form["aspnet_variable$MainContent$confirmation_church"];
            string previous_church_membership = Request.Form["aspnet_variable$MainContent$previous_church_membership"];
            string sponsor1 = Request.Form["candidate_sponsor1"];
            string sponsor2 = Request.Form["candidate_sponsor2"];
            string sponsor2contact = Request.Form["candidate_sponsor2contact"];
            string DeceasedDate = Request.Form["candidate_DeceasedDate"];
            string MemberDate = Request.Form["candidate_MemberDate"];
            string candidate_transfer_reason = Request.Form["candidate_transfer_reason"];
            string candidate_cariu = Request.Form["candidate_cariu"];
            string candidate_remarks = Request.Form["candidate_remarks"];

            string baptized_by_others = Request.Form["baptized_by_others"];
            string baptism_church_others = Request.Form["baptism_church_others"];
            string confirm_by_others = Request.Form["confirm_by_others"];
            string confirmation_church_others = Request.Form["confirmation_church_others"];
            string previous_church_membership_others = Request.Form["previous_church_membership_others"];

            string transferTo = Request.Form["candidate_transferto"];
            string transferToDate = Request.Form["candidate_transfertodate"];

            string candidate_ministry = Request.Form["multiselect_MainContent_candidate_ministry"];
            if (candidate_ministry != null)
            {
                string[] ministry = candidate_ministry.Split(',');
                candidate_ministry = "<Ministry>";
                for (int x = 0; x < ministry.Count(); x++)
                {
                    candidate_ministry += "<MinistryID>" + ministry[x] + "</MinistryID>";
                }
                candidate_ministry += "</Ministry>";
            }
            else
            {
                candidate_ministry = "<Ministry />";
            }

            string candidate_courses = Request.Form["aspnet_variable$MainContent$candidate_courses"];
            if (candidate_courses != null)
            {
                string[] courses = candidate_courses.Split(',');
                candidate_courses = "<Courses>";
                for (int x = 0; x < courses.Count(); x++)
                {
                    candidate_courses += "<CourseID>" + courses[x] + "</CourseID>";
                }
                candidate_courses += "</Courses>";
            }
            else
            {
                candidate_courses = "<Courses />";
            }

            string candidate_electoralroll = Request.Form["candidate_electoralroll_date"];
            string candidate_cellgroup = Request.Form["aspnet_variable$MainContent$candidate_cellgroup"];

            string childlist = "<ChildList></ChildList>";
            if (Request.Form["childlist"] != "0" && Request.Form["childlist"].Length > 0)
            {
                childlist = "<ChildList>";
                string[] childno = Request.Form["childlist"].Split(',');
                for (int x = 0; x < childno.Count(); x++)
                {
                    childlist += "<Child>";
                    childlist += "<ChildEnglishName>" + Request.Form["child_english_name_" + childno[x]].ToUpper() + "</ChildEnglishName>";
                    childlist += "<ChildChineseName>" + Request.Form["child_chinese_name_" + childno[x]] + "</ChildChineseName>";
                    childlist += "<ChildBaptismDate>" + Request.Form["child_baptism_date_" + childno[x]] + "</ChildBaptismDate>";
                    childlist += "<ChildBaptismBy>" + Request.Form["child_baptism_by_" + childno[x]] + "</ChildBaptismBy>";
                    childlist += "<ChildChurch>" + Request.Form["child_church_" + childno[x]] + "</ChildChurch>";
                    childlist += "</Child>";
                }
                childlist += "</ChildList>";
            }

            string familylist = "<FamilyList></FamilyList>";
            if (Request.Form["familylist"] != "0" && Request.Form["familylist"].Length > 0)
            {
                familylist = "<FamilyList>";
                string[] familyno = Request.Form["familylist"].Split(',');
                for (int x = 0; x < familyno.Count(); x++)
                {
                    familylist += "<Family>";
                    familylist += "<FamilyType>" + Request.Form["family_type_" + familyno[x]] + "</FamilyType>";
                    familylist += "<FamilyEnglishName>" + Request.Form["family_english_name_" + familyno[x]].ToUpper() + "</FamilyEnglishName>";
                    familylist += "<FamilyChineseName>" + Request.Form["family_chinese_name_" + familyno[x]] + "</FamilyChineseName>";
                    familylist += "<FamilyOccupation>" + Request.Form["family_occupation_" + familyno[x]] + "</FamilyOccupation>";
                    familylist += "<FamilyReligion>" + Request.Form["family_religion_" + familyno[x]] + "</FamilyReligion>";
                    familylist += "</Family>";
                }
                familylist += "</FamilyList>";
            }


            string mailingList = "";
            if(Request.Form["mailingList"] != null)
                mailingList = Request.Form["mailingList"].ToUpper();

            XElement xml = toUpdateXML(mailingList, Filename, GUID, FileType, fileremarks, User.Identity.Name, original_nric, candidate_salutation, candidate_photo, candidate_english_name, candidate_unit, candidate_blk_house, candidate_nationality, candidate_dialect, candidate_occupation, baptized_by, baptism_church, confirmation_by, confirmation_church, previous_church_membership, candidate_chinses_name, candidate_nric, candidate_dob, candidate_gender, candidate_marital_status, candidate_street_address, candidate_postal_code, candidate_email, candidate_education, candidate_language, candidate_home_tel, candidate_mobile_tel, candidate_baptism_date, candidate_confirmation_date, candidate_marriage_date, candidate_congregation, candidate_electoralroll, candidate_cellgroup, sponsor1, sponsor2, candidate_ministry, DeceasedDate, MemberDate, familylist, childlist, candidate_transfer_reason, candidate_cariu, candidate_remarks, baptized_by_others, baptism_church_others, confirm_by_others, confirmation_church_others, previous_church_membership_others, transferTo, transferToDate, sponsor2contact);
      
            if (type == "Actual")
                return sql_conn.usp_updateMember(xml).ElementAt(0).Result;
            else if (type == "Temp")
                return sql_conn.usp_updateTempMember(xml).ElementAt(0).Result;
            return "ERROR";
        }

        private XElement toUpdateXML(string mailingList, string filename, string guid, string filetype, string fileremarks, string userID, string originalNric, string salutation, string photo, string english_name, string unit, string blk_house, string nationality, string dialect, string occupation, string baptized_by, string baptize_church, string confirmation_by, string confirmation_church, string previous_church_membership, string chinese_name, string nric, string dob, string gender, string marital_status, string street_address, string postal_code, string email, string education, string language, string home_tel, string mobile_tel, string baptism_date, string confirmation_date, string marriage_date, string congregation, string electoralroll, string cellgroup, string sponsor1, string sponsor2, string ministry, string deceasedDate, string memberDate, string family, string child, string transferReason, string cariu, string remarks, string baptized_by_others, string baptism_church_others, string confirm_by_others, string confirmation_church_others, string previous_church_membership_others, string transferTo, string transferToDate, string sponsor2contact)
        {
            XElement update = XElement.Parse("<Update />");
            update.Add(new XElement("EnteredBy", userID));
            update.Add(new XElement("OriginalNRIC", originalNric));
            update.Add(new XElement("NRIC", nric));
            update.Add(new XElement("Salutation", salutation));
            update.Add(new XElement("EnglishName", english_name));
            update.Add(new XElement("ChineseName", chinese_name));
            update.Add(new XElement("Gender", gender));
            update.Add(new XElement("DOB", dob));
            update.Add(new XElement("MaritalStatus", marital_status));
            update.Add(new XElement("MarriageDate", marriage_date));
            update.Add(new XElement("Nationality", nationality));
            update.Add(new XElement("Dialect", dialect));
            update.Add(new XElement("Photo", photo));
            update.Add(new XElement("AddressStreetName", street_address));
            update.Add(new XElement("AddressPostalCode", postal_code));
            update.Add(new XElement("AddressBlkHouse", blk_house));
            update.Add(new XElement("AddressUnit", unit));
            update.Add(new XElement("HomeTel", home_tel));
            update.Add(new XElement("MobileTel", mobile_tel));
            update.Add(new XElement("Email", email));
            update.Add(new XElement("Education", education));
            update.Add(new XElement("Language", language));
            update.Add(new XElement("Occupation", occupation));
            update.Add(new XElement("Congregation", congregation));
            update.Add(new XElement("BaptismBy", baptized_by));
            update.Add(new XElement("BaptismDate", baptism_date));
            update.Add(new XElement("BaptismChurch", baptize_church));
            update.Add(new XElement("ConfirmationBy", confirmation_by));
            update.Add(new XElement("ConfirmationChurch", confirmation_church));
            update.Add(new XElement("ConfirmationDate", confirmation_date));
            update.Add(new XElement("PreviousChurchMembership", previous_church_membership));
            update.Add(new XElement("TransferReason", transferReason));
            update.Add(XElement.Parse("<FamilyXML>" + family + "</FamilyXML>"));
            update.Add(XElement.Parse("<ChildXML>" + child + "</ChildXML>"));
            update.Add(new XElement("Sponsor1", sponsor1));
            update.Add(new XElement("Sponsor2", sponsor2));
            update.Add(new XElement("Sponsor2Contact", sponsor2contact));
            update.Add(new XElement("ElectoralRoll", electoralroll));
            update.Add(new XElement("MemberDate", memberDate));
            update.Add(new XElement("Cellgroup", cellgroup));
            update.Add(XElement.Parse("<MinistryInvolvement>" + ministry + "</MinistryInvolvement>"));
            update.Add(new XElement("DeceasedDate", deceasedDate));
            update.Add(new XElement("DeceasedDate", deceasedDate));
            update.Add(new XElement("Remarks", remarks));
            update.Add(new XElement("CarIU", cariu));

            update.Add(new XElement("BaptismByOthers", baptized_by_others));
            update.Add(new XElement("BaptismChurchOthers", baptism_church_others));
            update.Add(new XElement("ConfirmByOthers", confirm_by_others));
            update.Add(new XElement("ConfirmChurchOthers", confirmation_church_others));
            update.Add(new XElement("PreviousChurchOthers", previous_church_membership_others));

            update.Add(new XElement("TransferTo", transferTo));
            update.Add(new XElement("TransferToDate", transferToDate));

            update.Add(new XElement("Filename", filename));
            update.Add(new XElement("GUID", guid));
            update.Add(new XElement("Filetype", filetype));
            update.Add(new XElement("FileRemarks", fileremarks));

            update.Add(new XElement("mailingList", mailingList));

            return update;
        }

        private XElement toUpdateXMLNewMember(string userID, string originalNric, string salutation, string photo, string english_name, string unit, string blk_house, string nationality, string dialect, string occupation, string baptized_by, string baptize_church, string confirmation_by, string confirmation_church, string previous_church_membership, string chinese_name, string nric, string dob, string gender, string marital_status, string street_address, string postal_code, string email, string education, string language, string home_tel, string mobile_tel, string baptism_date, string confirmation_date, string marriage_date, string congregation, string sponsor1, string sponsor2, string family, string child, string InterestedCellgroup, string InterestedMinistry, string InterestedServeCongregation, string InterestedTithing, string transferReason, string baptized_by_others, string baptism_church_others, string confirm_by_others, string confirmation_church_others, string previous_church_membership_others, string sponsor2contact)
        {
            XElement update = XElement.Parse("<Update />");
            update.Add(new XElement("EnteredBy", userID));
            update.Add(new XElement("OriginalNRIC", originalNric));
            update.Add(new XElement("NRIC", nric));
            update.Add(new XElement("Salutation", salutation));
            update.Add(new XElement("EnglishName", english_name));
            update.Add(new XElement("ChineseName", chinese_name));
            update.Add(new XElement("Gender", gender));
            update.Add(new XElement("DOB", dob));
            update.Add(new XElement("MaritalStatus", marital_status));
            update.Add(new XElement("MarriageDate", marriage_date));
            update.Add(new XElement("Nationality", nationality));
            update.Add(new XElement("Dialect", dialect));
            update.Add(new XElement("Photo", photo));
            update.Add(new XElement("AddressStreetName", street_address));
            update.Add(new XElement("AddressPostalCode", postal_code));
            update.Add(new XElement("AddressBlkHouse", blk_house));
            update.Add(new XElement("AddressUnit", unit));
            update.Add(new XElement("HomeTel", home_tel));
            update.Add(new XElement("MobileTel", mobile_tel));
            update.Add(new XElement("Email", email));
            update.Add(new XElement("Education", education));
            update.Add(new XElement("Language", language));
            update.Add(new XElement("Occupation", occupation));
            update.Add(new XElement("Congregation", congregation));
            update.Add(new XElement("BaptismBy", baptized_by));
            update.Add(new XElement("BaptismDate", baptism_date));
            update.Add(new XElement("BaptismChurch", baptize_church));
            update.Add(new XElement("ConfirmationBy", confirmation_by));
            update.Add(new XElement("ConfirmationChurch", confirmation_church));
            update.Add(new XElement("ConfirmationDate", confirmation_date));
            update.Add(new XElement("PreviousChurchMembership", previous_church_membership));
            update.Add(XElement.Parse("<FamilyXML>" + family + "</FamilyXML>"));
            update.Add(XElement.Parse("<ChildXML>" + child + "</ChildXML>"));
            update.Add(new XElement("Sponsor1", sponsor1));
            update.Add(new XElement("Sponsor2", sponsor2));
            update.Add(new XElement("Sponsor2Contact", sponsor2contact));
            update.Add(new XElement("InterestedServeCongregation", InterestedServeCongregation));
            update.Add(new XElement("InterestedCellgroup", InterestedCellgroup));
            update.Add(XElement.Parse("<InterestedMinistry>" + InterestedMinistry + "</InterestedMinistry>"));
            update.Add(new XElement("InterestedTithing", InterestedTithing));
            update.Add(new XElement("TransferReason", transferReason));

            update.Add(new XElement("BaptismByOthers", baptized_by_others));
            update.Add(new XElement("BaptismChurchOthers", baptism_church_others));
            update.Add(new XElement("ConfirmByOthers", confirm_by_others));
            update.Add(new XElement("ConfirmChurchOthers", confirmation_church_others));
            update.Add(new XElement("PreviousChurchOthers", previous_church_membership_others));
            return update;
        }
       
        private void loadMemberforStaff(usp_getMemberInformationResult res)
        {
            ViewData["candidate_congregation"] = ((int)res.Congregation).ToString();
            if (res.MarriageDate != null)
                ViewData["candidate_marriage_date"] = ((DateTime)res.MarriageDate).ToString("dd/MM/yyyy");
            else
                ViewData["candidate_marriage_date"] = "";
            ViewData["history"] = res.History;
            ViewData["candidate_christian_yes_no"] = "";
            ViewData["candidate_salutation"] = res.Salutation.ToString();
            ViewData["candidate_photo"] = res.ICPhoto;
            ViewData["candidate_english_name"] = res.EnglishName;
            ViewData["candidate_chinses_name"] = res.ChineseName;
            ViewData["candidate_nric"] = res.NRIC;
            ViewData["candidate_dob"] = ((DateTime)res.DOB).ToString("dd/MM/yyyy");
            ViewData["candidate_gender"] = res.Gender;
            ViewData["candidate_marital_status"] = ((int)res.MaritalStatus).ToString();
            ViewData["candidate_street_address"] = res.AddressStreet;
            ViewData["candidate_blk_house"] = res.AddressHouseBlk;
            ViewData["candidate_postal_code"] = res.AddressPostalCode.ToString();
            ViewData["candidate_unit"] = res.AddressUnit;
            ViewData["candidate_nationality"] = ((int)res.Nationality).ToString();
            ViewData["candidate_dialect"] = ((int)res.Dialect).ToString();
            ViewData["candidate_email"] = res.Email;
            ViewData["candidate_education"] = ((int)res.Education).ToString();
            ViewData["candidate_language"] = res.Language;
            ViewData["candidate_occupation"] = ((int)res.Occupation).ToString();
            ViewData["candidate_home_tel"] = res.HomeTel;
            ViewData["candidate_mobile_tel"] = res.MobileTel;
            if (res.BaptismDate != null)
                ViewData["candidate_baptism_date"] = ((DateTime)res.BaptismDate).ToString("dd/MM/yyyy");
            else
                ViewData["candidate_baptism_date"] = "";
            ViewData["baptized_by"] = res.BaptismBy;
            ViewData["baptism_church"] = ((int)res.BaptismChurch).ToString();
            if (res.ConfirmDate != null)
                ViewData["candidate_confirmation_date"] = ((DateTime)res.ConfirmDate).ToString("dd/MM/yyyy");
            else
                ViewData["candidate_confirmation_date"] = "";
            ViewData["confirmation_by"] = res.ConfirmBy;
            ViewData["confirmation_church"] = ((int)res.ConfirmChurch).ToString();
            ViewData["candidate_transfer_reason"] = res.TransferReason;
            ViewData["previous_church_membership"] = ((int)res.PreviousChurch).ToString();
            if (res.DeceasedDate != null)
                ViewData["DeceasedDate"] = ((DateTime)res.DeceasedDate).ToString("dd/MM/yyyy");
            else
                ViewData["DeceasedDate"] = "";

            ViewData["candidate_cariu"] = res.CarIU;
            ViewData["Remarks"] = res.Remarks;
            ViewData["familylist"] = res.Family.ToString();
            ViewData["childlist"] = res.Child.ToString();

            ViewData["candidate_cellgroup"] = (int)res.CellGroup;
            if (res.ElectoralRoll != null)
                ViewData["candidate_electoralroll_date"] = ((DateTime)res.ElectoralRoll).ToString("dd/MM/yyyy");
            else
                ViewData["candidate_electoralroll_date"] = "";

            ViewData["candidate_ministry"] = res.MinistryInvolvement.ToString();
            ViewData["candidate_courses"] = res.CourseAttended.ToString();

            ViewData["sponsor1"] = res.Sponsor1;
            ViewData["sponsor1_input"] = res.Sponsor1Name;
            ViewData["sponsor2"] = res.Sponsor2;
            ViewData["sponsor2contact"] = res.Sponsor2Contact;
            if (res.MemberDate != null)
                ViewData["MemberDate"] = ((DateTime)res.MemberDate).ToString("dd/MM/yyyy");
            else
                ViewData["MemberDate"] = "";

            ViewData["baptized_by_others"] = res.BaptismByOthers;
            ViewData["baptism_church_others"] = res.BaptismChurchOthers;
            ViewData["confirm_by_others"] = res.ConfirmByOthers;
            ViewData["confirmation_church_others"] = res.ConfirmChurchOthers;
            ViewData["previous_church_membership_others"] = res.PreviousChurchOthers;

            ViewData["candidate_transferto"] = res.TransferTo;
            if (res.TransferToDate != null)
                ViewData["candidate_transfertodate"] = ((DateTime)res.TransferToDate).ToString("dd/MM/yyyy");
            else
                ViewData["candidate_transfertodate"] = "";

            ViewData["candidate_mailingList"] = res.ReceiveMailingList.ToString().ToUpper();
        }        
    }

}
