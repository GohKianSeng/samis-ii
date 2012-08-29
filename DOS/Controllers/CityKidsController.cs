using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;
using DOS.Models;
using System.Xml.Linq;
using System.IO;
using System.Net.Mail;

namespace DOS.Controllers
{
    [HandleError]
    public class CityKidsController : MasterPageController
    {
        [ErrorHandler]
        public ActionResult Index()
        {
            return RedirectToAction("newkid", "CityKids");
        }
        
        [ErrorHandler]
        public ActionResult newkid(string message)
        {
            Session["FileIOStream"] = null;
            Session["FileName"] = "";
            ViewData["errormsg"] = message;
            initializedParameter();
            return View("CityKidsMembershipForm");
        }

        [ErrorHandler]
        public ActionResult submitNewKid()
        {

            initializedParameter();
            if (((string)Session["SystemMode"]).ToUpper() != "FULL")
            {
                string table = (string)Session["C3ChildrenClub"];
                table = table.Replace("[NRIC]", Request.Form["kid_nric"]);
                table = table.Replace("[Name]", Request.Form["kid_name"]);
                table = table.Replace("[Gender]", Request.Form["GenderText"]);
                table = table.Replace("[DOB]", Request.Form["kid_dob"]);
                table = table.Replace("[Nationality]", Request.Form["NationalityText"]);
                table = table.Replace("[Race]", Request.Form["RaceText"]);
                table = table.Replace("[Home Tel]", Request.Form["kid_home_tel"]);
                table = table.Replace("[Mobile Tel]", Request.Form["kid_mobile_tel"]);
                table = table.Replace("[PostalCode]", Request.Form["candidate_postal_code"]);
                table = table.Replace("[StreetName]", Request.Form["candidate_street_address"]);
                table = table.Replace("[BlkHouse]", Request.Form["candidate_blk_house"]);
                table = table.Replace("[Unit]", Request.Form["candidate_unit"]);
                table = table.Replace("[Email]", Request.Form["kid_email"]);
                table = table.Replace("[School]", Request.Form["SchoolText"]);
                table = table.Replace("[Religion]", Request.Form["ReligionText"]);
                table = table.Replace("[NOK Contact]", Request.Form["kid_NOK_contact"]);
                table = table.Replace("[NOK Name]", Request.Form["kid_NOK_relationship"]);
                table = table.Replace("[Special Needs]", Request.Form["kid_special_needs"]);

                MailMessage mail = new MailMessage();
                mail.IsBodyHtml = true;
                string to = (string)Session["C3RegistrationRecipients"];

                mail.From = new MailAddress((string)Session["SMTPAccount"]);

                if (to.Length == 0)
                    to = "zniter81@gmail.com";
                string[] emailTo = to.Split(';');
                for (int x = 0; x < emailTo.Length; x++)
                {
                    if (emailTo[x].Trim().Length != 0)
                        mail.To.Add("<" + emailTo[x].Trim() + ">");
                }

                mail.Subject = "C3 - CITY Children Club Registration";        // put subject here	        
                mail.IsBodyHtml = true;
                
                if (Session["FileIOStream"] == null)
                    table = table.Replace("[attachment]", "");
                else if (((byte[])Session["FileIOStream"]).Count() > 0)
                {
                    MemoryStream stream = new MemoryStream((byte[])Session["FileIOStream"]);
                    Attachment attach = new Attachment(stream, (string)Session["FileName"]);
                    mail.Attachments.Add(attach);
                    table = table.Replace("[attachment]", "Attachment of kid Photo<br /><br />");
                }
                mail.Body = table;
                sendEmail(mail);
                return RedirectToAction("newkid", "CityKids", new { message = "Thank you for registering with us.\nYour Application has been submitted." });
            }
            else
            {
                XElement xml = toNewKidXML();
                int result = sql_conn.usp_addNewCityKid(xml).ElementAt(0).Result;
                string candidate_photo = Request.Form["kid_photo"];
                if (result == 1 && candidate_photo.Length > 0)
                {
                    string from = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + candidate_photo;
                    string to = Session["CityKidsPhotolocation"].ToString() + candidate_photo;
                    System.IO.File.Move(from, to);
                    return RedirectToAction("newkid", "CityKids", new { message = "Participant, " + Request.Form["kid_name"] + " added." });
                }
                else if (result == 1)
                {
                    return RedirectToAction("newkid", "CityKids", new { message = "Participant, " + Request.Form["kid_name"] + " added." });
                }
                else
                {
                    ViewData["photo"] = Request.Form["kid_photo"];
                    ViewData["kid_nric"] = Request.Form["kid_nric"];
                    ViewData["kid_name"] = Request.Form["kid_name"];
                    ViewData["kid_gender"] = Request.Form["kid_gender"];
                    ViewData["kid_dob"] = Request.Form["kid_dob"];
                    ViewData["kid_nationality"] = Request.Form["aspnet_variable$MainContent$kid_nationality"];
                    ViewData["kid_race"] = Request.Form["aspnet_variable$MainContent$kid_race"];
                    ViewData["kid_home_tel"] = Request.Form["kid_home_tel"];
                    ViewData["kid_mobile_tel"] = Request.Form["kid_mobile_tel"];
                    ViewData["candidate_postal_code"] = Request.Form["candidate_postal_code"];
                    ViewData["candidate_blk_house"] = Request.Form["candidate_blk_house"];
                    ViewData["candidate_unit"] = Request.Form["candidate_unit"];
                    ViewData["candidate_street_address"] = Request.Form["candidate_street_address"];
                    ViewData["kid_email"] = Request.Form["kid_email"];
                    ViewData["kid_NOK_contact"] = Request.Form["kid_NOK_contact"];
                    ViewData["kid_NOK_relationship"] = Request.Form["kid_NOK_relationship"];
                    ViewData["kid_special_needs"] = Request.Form["kid_special_needs"];
                    ViewData["kid_school"] = Request.Form["aspnet_variable$MainContent$kid_school"];
                    ViewData["kid_religion"] = Request.Form["aspnet_variable$MainContent$kid_religion"];
                    ViewData["errormsg"] = "Participant, " + Request.Form["kid_name"] + " exits.";
                    return View("CityKidsMembershipForm");
                }
            }
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateKid()
        {
            ViewData["Type"] = "UPDATE";
            initializedParameter();
            return View("UpdateCityKidsSearchForm");
        }

        [Authorize]
        public ActionResult ListOfCityKids()
        {
            string Name = Request.Form["Name"];
            string NRIC = Request.Form["NRIC"];
            string Busgroup = Request.Form["BusGroup"];
            string Clubgroup = Request.Form["ClubGroup"];

            if (Name == null)
                Name = "";
            if (NRIC == null)
                NRIC = "";
            if (Busgroup == null)
                Busgroup = "";
            if (Clubgroup == null)
                Clubgroup = "";

            ViewData["Name"] = Name;
            ViewData["NRIC"] = NRIC;
            ViewData["Busgroup"] = Busgroup;
            ViewData["Clubgroup"] = Clubgroup;
            ViewData["listofkids"] = sql_conn.usp_searchCityKidsForUpdate(NRIC, Name, Busgroup, Clubgroup, User.Identity.Name).ToList();

            return View();
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateCityKidsPoints()
        {
            XElement xml = new XElement("UpdateCityKidPoints");
            string[] keys = Request.Form.AllKeys;
            for (int x = 0; x < keys.Count(); x++)
            {
                if (keys[x].StartsWith("pt_") && Request.Form[keys[x]] != "0")
                {
                    if (Request.Form[keys[x]] == "-?" || Request.Form[keys[x]] == "+?")
                    {

                        if (Request.Form["other_" + keys[x].Substring(3)].Length > 1)
                        {
                            string value = Request.Form["other_" + keys[x].Substring(3)].Substring(0, Request.Form["other_" + keys[x].Substring(3)].Length - 1);
                            string type = Request.Form[keys[x]].Substring(0, 1);
                            string remarks = Request.Form["remarks_" + keys[x].Substring(3)];
                            XElement kid = new XElement("Kid");
                            kid.Add(new XElement("NRIC", keys[x].Substring(3)));
                            kid.Add(new XElement("Type", type));
                            kid.Add(new XElement("Points", value));
                            kid.Add(new XElement("Remarks", remarks));
                            xml.Add(kid);
                        }
                    }
                    else
                    {
                        XElement kid = new XElement("Kid");
                        kid.Add(new XElement("NRIC", keys[x].Substring(3)));
                        kid.Add(new XElement("Type", Request.Form[keys[x]].Substring(0, 1)));
                        kid.Add(new XElement("Points", Request.Form[keys[x]].Substring(1)));
                        kid.Add(new XElement("Remarks", Request.Form["remarks_" + keys[x].Substring(3)]));
                        xml.Add(kid);
                    }
                }
            }

            sql_conn.usp_UpdateCityKidsPoints(xml, User.Identity.Name);

            string Name = Request.Form["Name"];
            string NRIC = Request.Form["NRIC"];
            string Busgroup = Request.Form["BusGroup"];
            string Clubgroup = Request.Form["ClubGroup"];

            if (Name == null)
                Name = "";
            if (NRIC == null)
                NRIC = "";
            if (Busgroup == null)
                Busgroup = "";
            if (Clubgroup == null)
                Clubgroup = "";

            ViewData["Name"] = Name;
            ViewData["NRIC"] = NRIC;
            ViewData["Busgroup"] = Busgroup;
            ViewData["Clubgroup"] = Clubgroup;
            ViewData["listofkids"] = sql_conn.usp_searchCityKidsForUpdate(NRIC, Name, Busgroup, Clubgroup, User.Identity.Name).ToList();

            return View("ListOfCityKids");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateKidForStaff(string nric)
        {
            usp_getCityKidInformationResult res = sql_conn.usp_getCityKidInformation(nric).ElementAt(0);
            ViewData["history"] = res.History;
            initializedParameter();
            loadKidInfoForStaff(res);
            return View("UpdateCityKidsMembershipForm_forStaff");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult submitUpdateKidForm()
        {
            XElement xml = toUpdateKidXML();
            string res = sql_conn.usp_updateCityKid(xml).ElementAt(0).Result;
            updateCityKidFilePhoto();

            if (res == "Updated")
            {
                ViewData["errormsg"] = Request.Form["kid_name"].ToUpper() + "'s profile updated!";
            }
            else if (res == "NoChange")
            {
                ViewData["errormsg"] = "No change to " + Request.Form["kid_name"].ToUpper() + "'s profile";
            }
            else if (res == "NotFound")
            {
                ViewData["errormsg"] = "Record not found.";
            }

            ViewData["Type"] = "UPDATE";
            initializedParameter();
            return View("UpdateCityKidsSearchForm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateSchedule()
        {
            ViewData["schedule"] = sql_conn.usp_getCityKidSchedule(int.Parse((string)Session["CityKidCourseID"])).ElementAt(0).Schedule;
            return View("UpdateCityKidsSchedule");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult submitUpdateSchedule(string kidschedule)
        {
            sql_conn.usp_updateCityKidSchedule(int.Parse((string)Session["CityKidCourseID"]), kidschedule);
            ViewData["schedule"] = sql_conn.usp_getCityKidSchedule(int.Parse((string)Session["CityKidCourseID"])).ElementAt(0).Schedule;
            ViewData["errormsg"] = "Schedule Updated!";
            return View("UpdateCityKidsSchedule");
        }

        private void updateCityKidFilePhoto()
        {
            string photo = Request.Form["kid_photo"];

            string newPhoto = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + photo;
            string oldPhoto = Session["CityKidsPhotolocation"].ToString() + photo;
            if (System.IO.File.Exists(newPhoto) && !System.IO.File.Exists(oldPhoto))
                System.IO.File.Move(newPhoto, oldPhoto);
            
        }

        private void loadKidInfoForStaff(usp_getCityKidInformationResult res)
        {
            ViewData["photo"] = res.Photo;
            ViewData["kid_nric"] = res.NRIC;
            ViewData["kid_name"] = res.Name;
            ViewData["kid_gender"] = res.Gender;
            ViewData["kid_dob"] = res.DOB.ToString("dd/MM/yyyy");
            ViewData["kid_nationality"] = ((int)res.Nationality).ToString();
            ViewData["kid_race"] = ((int)res.Race).ToString();
            ViewData["kid_home_tel"] = res.HomeTel;
            ViewData["kid_mobile_tel"] = res.MobileTel;
            ViewData["candidate_postal_code"] = res.AddressPostalCode.ToString();
            ViewData["candidate_blk_house"] = res.AddressHouseBlk;
            ViewData["candidate_unit"] = res.AddressUnit;
            ViewData["candidate_street_address"] = res.AddressStreet.Trim();
            ViewData["kid_email"] = res.Email;
            ViewData["kid_NOK_contact"] = res.EmergencyContact;
            ViewData["kid_NOK_relationship"] = res.EmergencyContactName;
            ViewData["kid_special_needs"] = res.SpecialNeeds;
            ViewData["kid_school"] = ((int)res.School).ToString();
            ViewData["kid_religion"] = ((int)res.Religion).ToString();
            ViewData["kid_clubgroup"] = ((int)res.ClubGroup).ToString();
            ViewData["kid_busgroup"] = ((int)res.BusGroupCluster).ToString();
            ViewData["kid_points"] = res.Points.ToString();
            ViewData["kid_remarks"] = res.Remarks;
            if(res.Transport)
                ViewData["kid_transport"] = "1";
            else
                ViewData["kid_transport"] = "0";

        }

        private XElement toNewKidXML()
        {
            XElement newXML = XElement.Parse("<New />");
            newXML.Add(new XElement("EnteredBy", User.Identity.Name));
            newXML.Add(new XElement("NRIC", Request.Form["kid_nric"]));
            newXML.Add(new XElement("Name", Request.Form["kid_name"]));
            newXML.Add(new XElement("Gender", Request.Form["kid_gender"]));
            newXML.Add(new XElement("DOB", Request.Form["kid_dob"]));
            newXML.Add(new XElement("Nationality", Request.Form["aspnet_variable$MainContent$kid_nationality"]));
            newXML.Add(new XElement("Race", Request.Form["aspnet_variable$MainContent$kid_race"]));
            newXML.Add(new XElement("HomeTel", Request.Form["kid_home_tel"]));
            newXML.Add(new XElement("MobileTel", Request.Form["kid_mobile_tel"]));
            newXML.Add(new XElement("AddressPostalCode", Request.Form["candidate_postal_code"]));
            newXML.Add(new XElement("AddressStreetName", Request.Form["candidate_street_address"]));
            newXML.Add(new XElement("AddressBlkHouse", Request.Form["candidate_blk_house"]));
            newXML.Add(new XElement("AddressUnit", Request.Form["candidate_unit"]));
            newXML.Add(new XElement("Photo", Request.Form["kid_photo"]));
            newXML.Add(new XElement("Email", Request.Form["kid_email"]));
            newXML.Add(new XElement("School", Request.Form["aspnet_variable$MainContent$kid_school"]));
            newXML.Add(new XElement("Religion", Request.Form["aspnet_variable$MainContent$kid_religion"]));
            newXML.Add(new XElement("NOKContact", Request.Form["kid_NOK_contact"]));
            newXML.Add(new XElement("NOKRelationship", Request.Form["kid_NOK_relationship"]));
            newXML.Add(new XElement("SpecialNeeds", Request.Form["kid_special_needs"]));

            return newXML;
        }

        private XElement toUpdateKidXML()
        {
            XElement updateXML = XElement.Parse("<Update />");
            updateXML.Add(new XElement("EnteredBy", User.Identity.Name));
            updateXML.Add(new XElement("OriginalNric", Request.Form["OriginalNric"]));
            updateXML.Add(new XElement("NRIC", Request.Form["kid_nric"]));
            updateXML.Add(new XElement("Name", Request.Form["kid_name"]));
            updateXML.Add(new XElement("Gender", Request.Form["kid_gender"]));
            updateXML.Add(new XElement("DOB", Request.Form["kid_dob"]));
            updateXML.Add(new XElement("Nationality", Request.Form["aspnet_variable$MainContent$kid_nationality"]));
            updateXML.Add(new XElement("Race", Request.Form["aspnet_variable$MainContent$kid_race"]));
            updateXML.Add(new XElement("HomeTel", Request.Form["kid_home_tel"]));
            updateXML.Add(new XElement("MobileTel", Request.Form["kid_mobile_tel"]));
            updateXML.Add(new XElement("AddressStreetName", Request.Form["candidate_street_address"]));
            updateXML.Add(new XElement("AddressPostalCode", Request.Form["candidate_postal_code"]));
            updateXML.Add(new XElement("AddressBlkHouse", Request.Form["candidate_blk_house"]));
            updateXML.Add(new XElement("AddressUnit", Request.Form["candidate_unit"]));
            updateXML.Add(new XElement("Photo", Request.Form["kid_photo"]));
            updateXML.Add(new XElement("Email", Request.Form["kid_email"]));
            updateXML.Add(new XElement("School", Request.Form["aspnet_variable$MainContent$kid_school"]));
            updateXML.Add(new XElement("Religion", Request.Form["aspnet_variable$MainContent$kid_religion"]));
            updateXML.Add(new XElement("NOKContact", Request.Form["kid_NOK_contact"]));
            updateXML.Add(new XElement("NOKName", Request.Form["kid_NOK_relationship"]));
            updateXML.Add(new XElement("SpecialNeeds", Request.Form["kid_special_needs"]));
            updateXML.Add(new XElement("Transport", Request.Form["kid_transport"]));
            updateXML.Add(new XElement("Clubgroup", Request.Form["aspnet_variable$MainContent$kid_clubgroup"]));
            updateXML.Add(new XElement("Busgroup", Request.Form["aspnet_variable$MainContent$kid_busgroup"]));
            updateXML.Add(new XElement("Remarks", Request.Form["kid_remarks"]));
            return updateXML;
        }

        private void initializedParameter()
        {
            ViewData["countrylist"] = sql_conn.usp_getAllCountry().ToList();
            ViewData["racelist"] = sql_conn.usp_getAllRace().ToList();
            ViewData["religionlist"] = sql_conn.usp_getAllReligion().ToList();
            ViewData["schoollist"] = sql_conn.usp_getAllSchool().ToList();
            ViewData["busgroupclusterlist"] = sql_conn.usp_getAllBusGroupCluster().ToList();
            ViewData["clubgrouplist"] = sql_conn.usp_getAllClubgroup().ToList();
        }
    }
}
