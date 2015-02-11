using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using DOS.Models;

namespace DOS.Controllers
{
    public class HwsController : MasterPageController
    {
        //
        // GET: /Hws/

        public ActionResult attendanceReport()
        {
            string date = Request.Form["aspnet_variable$MainContent$serviceDate"];
            if (date == null || date.Length <= 0)
                date = "11/11/1900";
            ViewData["date"] = sql_conn.usp_getAllHWSAttendanceDate().ToList();
            ViewData["listofmembers"] = sql_conn.usp_getHWSMemberAttendance(DateTime.ParseExact(date, "dd/MM/yyyy", null)).ToList();
            return View();
        }

        public ActionResult AddNewMember(string message)
        {
            ViewData["message"] = message;
            ViewData["ChangeType"] = "New";
            return View();
        }

        public ActionResult UpdateAttendance(string id)
        {
            sql_conn.usp_UpdateHWSAttendance(int.Parse(id));
            ViewData["result"] = "OK";
            return View("simplehtml");
        }

        public ActionResult manualAttendance()
        {
            ViewData["listofmembers"] = sql_conn.usp_getAllHWSMember().ToList();
            return View();
        }

        public ActionResult scanAttendance()
        {
            return View("scanAttendance");
        }

        public ActionResult updateMemberAttendance(string ID, string date)
        {
            if(ID == null || ID.Length <=0)
                return View("scanAttendance");

            List<usp_UpdateHWSAttendanceResult> res1 = sql_conn.usp_UpdateHWSAttendance(int.Parse(ID)).ToList();
            if (res1.Count > 0)
            {
                usp_UpdateHWSAttendanceResult res = res1.ElementAt(0);
                ViewData["errormsg"] = "Welcome, " + res.EnglishSurname + " " + res.EnglishGivenName + " / " + res.ChineseSurname + res.ChineseGivenName;
                return View("scanAttendance");
            }
            else
            {
                ViewData["errormsg"] = "Worshipper not found.";
                return View("scanAttendance");
            }
        }

        public ActionResult listmember()
        {
            ViewData["listofmembers"] = sql_conn.usp_getAllHWSMember().ToList();
            return View("ListOfMembers");
        }

        [HttpPost]
        public ActionResult updateMember()
        {
            XElement xml = parseFormRequestNewMember();
            string msg = sql_conn.usp_updateHWSMember(xml).ElementAt(0).Result;
            return RedirectToAction("listmember", "hws", new { message = "Updated" });
        }

        public ActionResult deleteMember(string ID)
        {
            sql_conn.usp_removeHWSMember(int.Parse(ID));

            ViewData["result"] = "1";
            return View("simplehtml");
        }

        public ActionResult loadMember(string ID)
        {
            usp_getHWSMemberInformationResult res = sql_conn.usp_getHWSMemberInformation(int.Parse(ID)).ElementAt(0);
            ViewData["ChangeType"] = "Modify";

            ViewData["AddressHouseBlock"] = res.AddressHouseBlock;
            ViewData["AddressPostalCode"] = res.AddressPostalCode;
            ViewData["AddressStreet"] = res.AddressStreet;
            ViewData["AddressUnit"] = res.AddressUnit;
            ViewData["ChineseGivenName"] = res.ChineseGivenName;
            ViewData["ChineseSurname"] = res.ChineseSurname;
            ViewData["Contact"] = res.Contact;
            ViewData["DOB"] = res.DOB;
            ViewData["EnglishGivenName"] = res.EnglishGivenName;
            ViewData["EnglishSurname"] = res.EnglishSurname;
            ViewData["ID"] = res.ID;
            ViewData["NextOfKinContact"] = res.NextOfKinContact;
            ViewData["NextOfKinName"] = res.NextOfKinName;
            ViewData["Photo"] = res.Photo;
            ViewData["Remarks"] = res.Remarks;
            



            return View("AddNewMember");
        }

        [HttpPost]
        public ActionResult submitNewMemberForm()
        {
            string result = "";
            XElement newXML = parseFormRequestNewMember();
            sql_conn.usp_addNewHWSMember(newXML, ref result);
            if (result == "OK")
                result = "Worshipper Added.";

            if (Request.Form["candidate_photo"].Length > 0)
            {
                if (Session["RemoteStorage"].ToString().ToUpper() == "ON")
                {
                    new RemoteStorage((string)Session["DropBoxApiKey"], (string)Session["DropBoxAppSecret"], (string)Session["DropBoxUserToken"], (string)Session["DropBoxUserSecret"]).renameRemoteStorageFilename("temp_" + Request.Form["candidate_photo"], Request.Form["candidate_photo"]);
                }
                else
                {
                    string from = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + Request.Form["candidate_photo"];
                    string to = Session["icphotolocation"].ToString() + Request.Form["candidate_photo"];
                    System.IO.File.Move(from, to);
                }
            }


            return RedirectToAction("AddNewMember", "hws", new { message = result });
        }

        private XElement parseFormRequestNewMember()
        {
            XElement newXML = new XElement("new");
            newXML.Add(new XElement("EnteredBy", User.Identity.Name));
            newXML.Add(new XElement("ID", Request.Form["ID"]));
            newXML.Add(new XElement("EnglishSurname",Request.Form["EnglishSurname"]));
            newXML.Add(new XElement("EnglishGivenName", Request.Form["EnglishGivenName"]));
            newXML.Add(new XElement("ChineseSurname", Request.Form["ChineseSurname"]));
            newXML.Add(new XElement("ChineseGivenName", Request.Form["ChineseGivenName"]));
            newXML.Add(new XElement("DOB", Request.Form["DOB"]));
            newXML.Add(new XElement("Contact", Request.Form["Contact"]));
            newXML.Add(new XElement("NOK", Request.Form["NOK"]));
            newXML.Add(new XElement("NOKContact", Request.Form["NOKContact"]));
            newXML.Add(new XElement("candidate_street_address", Request.Form["candidate_street_address"]));
            newXML.Add(new XElement("candidate_postal_code", Request.Form["candidate_postal_code"]));
            newXML.Add(new XElement("candidate_blk_house", Request.Form["candidate_blk_house"]));
            newXML.Add(new XElement("candidate_unit", Request.Form["candidate_unit"]));
            newXML.Add(new XElement("candidate_photo", Request.Form["candidate_photo"]));
            newXML.Add(new XElement("remarks", Request.Form["remarks"]));

            return newXML;
        }
    }
}
