using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;
using DOS.Models;
using System.Xml.Linq;

namespace DOS.Controllers
{
    [HandleError]
    public class ParishController : MasterPageController
    {
        [ErrorHandler]
        [Authorize]
        public ActionResult CourseIndivudialAttendanceReport()
        {
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();
            return View();
        }
        [ErrorHandler]
        public ActionResult CourseIndivudialAttendanceReportResult(string FromYear, string numberOfCourse)
        {
            ViewData["res"] = sql_conn.usp_getCourseIndividualAttendanceReport(FromYear, int.Parse(numberOfCourse)).ToList();
            return View();
        }

        [ErrorHandler]
        public ActionResult LoadPeriodicAttendanceReportResult(string FromYear, string ToYear, string FromMonth, string ToMonth){

            IEnumerable<usp_getPeriodicAttendanceReportResult> res = sql_conn.usp_getPeriodicAttendanceReport(FromYear, ToYear, FromMonth, ToMonth).ToList();
            string CourseName = "";
            string CourseAttendance = "";
            for (int x = 0; x < res.Count(); x++)
            {
                CourseName += "'" + res.ElementAt(x).CourseName + "',";
                CourseAttendance += "[" + res.ElementAt(x).AttendanceAttended + "," + res.ElementAt(x).AttendanceCompleted + "],";
            }

            ViewData["res"] = res;
            if (CourseName.Length > 0)
                ViewData["CourseName"] = CourseName.Substring(0, CourseName.Length - 1);
            if (CourseAttendance.Length > 0)
                ViewData["CourseAttendance"] = CourseAttendance.Substring(0, CourseAttendance.Length - 1); ;
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult courseRegistrationStat()
        {
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();
            return View();
        }

        [ErrorHandler]
        public ActionResult CourseRegistrationStatResult(string FromYear, string FromMonth)
        {
            ViewData["res"] = sql_conn.usp_getCourseRegistrationStat(FromYear, FromMonth).ToList();
            return View();
        }
        
        [ErrorHandler]
        [Authorize]
        public ActionResult periodicAttendanceReport()
        {
            ViewData["Years"] = sql_conn.usp_getAllCourseYears().ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listallStaff(string message)
        {
            ViewData["errormsg"] = message;
            ViewData["lisfofstaff"] = sql_conn.usp_getAllStaff().ToList();
            return View("ListOfStaff");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult Staff()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateParticipantInformation()
        {
            string nric = Request.Form["nric"];
            string courseid = Request.Form["courseid"];
            string name = Request.Form["name"];
            string feepaid = Request.Form["feepaid"];
            string materialcollected = Request.Form["materialcollected"];

            int res = sql_conn.usp_UpdateCourseParticipantInformation(int.Parse(courseid), nric, feepaid, materialcollected).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Participant, " + name + ", information update.";
            }
            else
            {
                ViewData["errormsg"] = "Unable to update participant, " + name + " information.";
            }

            ViewData["listofparticipants"] = sql_conn.usp_getListofCourseParticipants(int.Parse(courseid)).ToList();
            return View("ListOfCourseParticipants");

        }

        [ErrorHandler]
        [Authorize]
        public ActionResult loadCourseParticipant(string courseid, string nric, string name)
        {
            ViewData["participantinformation"] = sql_conn.usp_getCourseParticipantInformation(int.Parse(courseid), nric).ElementAt(0);
            return View("CourseParticipant");

        }

        [ErrorHandler]
        [Authorize]
        public ActionResult removeCourseParticipant(string courseid, string nric, string name)
        {
            int res = sql_conn.usp_removeCourseParticipant(int.Parse(courseid), nric).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Participant, " + name + ", deleted.";
            }
            else
            {
                ViewData["errormsg"] = "Unable to delete participant, " + name + ".";
            }

            ViewData["listofparticipants"] = sql_conn.usp_getListofCourseParticipants(int.Parse(courseid)).ToList();
            return View("ListOfCourseParticipants");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult manualUpdateAttendance(string nric, string courseid, string date, string attendance)
        {
            ViewData["result"] = sql_conn.usp_ManualUpdateAttendance(int.Parse(courseid), nric, DateTime.ParseExact(date, "dd/MM/yyyy", null), attendance).ElementAt(0).Result;
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ListOfCourseParticipants(string courseid)
        {
            ViewData["listofparticipants"] = sql_conn.usp_getListofCourseParticipants(int.Parse(courseid)).ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ListOfCourse()
        {
            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false).ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult RemoveCourse(string courseid, string name)
        {
            int res = sql_conn.usp_removeCourse(int.Parse(courseid)).ElementAt(0).Result;

            if (res == 1)
            {
                ViewData["errormsg"] = "Course, " + name + " deleted.";
            }
            else
            {
                ViewData["errormsg"] = "Unable to delete course, " + name + ".";
            }
            ViewData["listofcourse"] = sql_conn.usp_getListofCourse(false).ToList();
            return View("ListOfCourse");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addcourse(string courseid)
        {
            if (courseid != null)
            {
                ViewData["courseinformation"] = sql_conn.usp_getCourseInfo(int.Parse(courseid)).ElementAt(0);
                ViewData["type"] = "update";
            }
            ViewData["listofchurcharea"] = sql_conn.usp_getAllChurchArea().ToList();
            ViewData["listofadditionalinfo"] = sql_conn.usp_getAllCourseAdditionalInfo().ToList();
            ViewData["hidemenu"] = "true";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addnewcourse()
        {
            string coursename = Request.Form["coursename"];
            string startdate = Request.Form["startdate"];
            string timestart = Request.Form["timestart"];
            string timeend = Request.Form["timeend"];
            int MinCompleteAttendance = int.Parse(Request.Form["MinCompleteAttendance"]);
            string courseArea = Request.Form["aspnet_variable$MainContent$courseArea"];
            string additionalAgreement = Request.Form["aspnet_variable$MainContent$AdditionalInfo"];
            string lastRegistrationDate = Request.Form["lastRegistrationDate"];
            string incharge = Request.Form["incharge"];
            decimal fee = 0;
            int res;
            if(decimal.TryParse(Request.Form["fee"], out fee))
                res = sql_conn.usp_addNewCourse(coursename, startdate, timestart, timeend, incharge, int.Parse(courseArea), fee, int.Parse(additionalAgreement), DateTime.ParseExact(lastRegistrationDate, "dd/MM/yyyy", null), MinCompleteAttendance).ElementAt(0).Result;
            else
                res = sql_conn.usp_addNewCourse(coursename, startdate, timestart, timeend, incharge, int.Parse(courseArea), (decimal)0, int.Parse(additionalAgreement), DateTime.ParseExact(lastRegistrationDate, "dd/MM/yyyy", null), MinCompleteAttendance).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Course added.";
            }
            else{
                ViewData["errormsg"] = "Course add unsuccessful.";
            }

            ViewData["hidemenu"] = "true";
            ViewData["listofchurcharea"] = sql_conn.usp_getAllChurchArea().ToList();
            ViewData["listofadditionalinfo"] = sql_conn.usp_getAllCourseAdditionalInfo().ToList();
            return View("addcourse");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult Course()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult modifyACourse(string courseid)
        {
            ViewData["modify"] = "?courseid=" + courseid;
            ViewData["type"] = "update";
            return View("Course");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult attendanceReport(string courseid)
        {
            int? totalday = 0, minAttendance = 0;
            XElement xml = null;
            int? attendedAtLeastOnce = 0, allCompletedCourse = 0, SACCompletedCourse = 0, NonSACCompletedCourse = 0;
            int? anglicanCompleted = 0, nonAnglicanCompleted = 0;
            ViewData["report"] = sql_conn.usp_getCourseReport(int.Parse(courseid), ref totalday, ref minAttendance, ref xml, ref attendedAtLeastOnce, ref allCompletedCourse, ref SACCompletedCourse, ref NonSACCompletedCourse, ref anglicanCompleted, ref nonAnglicanCompleted).ToList();
            ViewData["totalday"] = totalday;
            ViewData["xml"] = xml;
            ViewData["attendedAtLeastOnce"] = attendedAtLeastOnce;
            ViewData["allCompletedCourse"] = allCompletedCourse;
            ViewData["SACCompletedCourse"] = SACCompletedCourse;
            ViewData["NonSACCompletedCourse"] = NonSACCompletedCourse;
            ViewData["anglicanCompleted"] = anglicanCompleted;
            ViewData["nonAnglicanCompleted"] = nonAnglicanCompleted;
            ViewData["minAttendance"] = minAttendance;
            
            return View("AttendanceReport");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateAcourse()
        {
            int MinCompleteAttendance = int.Parse(Request.Form["MinCompleteAttendance"]);
            string courseid = Request.Form["courseid"];
            string coursename = Request.Form["coursename"];
            string startdate = Request.Form["startdate"];
            string enddate = Request.Form["enddate"];
            string timestart = Request.Form["timestart"];
            string timeend = Request.Form["timeend"];
            string courseArea = Request.Form["aspnet_variable$MainContent$courseArea"];
            string additionalAgreement = Request.Form["aspnet_variable$MainContent$AdditionalInfo"];
            string lastRegistrationDate = Request.Form["lastRegistrationDate"];
            string incharge = Request.Form["incharge"];

            int res = sql_conn.usp_UpdateCourse(int.Parse(courseid), coursename, startdate, timestart, timeend, incharge, int.Parse(courseArea), int.Parse(additionalAgreement), DateTime.ParseExact(lastRegistrationDate, "dd/MM/yyyy", null), MinCompleteAttendance).ElementAt(0).Result;

            ViewData["courseinformation"] = sql_conn.usp_getCourseInfo(int.Parse(courseid)).ElementAt(0);
            ViewData["type"] = "update";
            ViewData["listofchurcharea"] = sql_conn.usp_getAllChurchArea().ToList();
            ViewData["listofadditionalinfo"] = sql_conn.usp_getAllCourseAdditionalInfo().ToList();
            ViewData["hidemenu"] = "true";
            if (res == 1)
            {
                ViewData["errormsg"] = "Course Updated! <br />";
            }
            return View("AddCourse");
        }

        [ErrorHandler]        
        public ActionResult searchforInCharge(string name)
        {
            string res = sql_conn.usp_searchName(name).ElementAt(0).Result;
            if (res == null)
            {
                ViewData["result"] = "";
                return View("simplehtml");
            }


            ViewData["result"] = res;
            return View("simplehtml");
        }






        [ErrorHandler]
        [Authorize]
        public ActionResult Ministry()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ListOfMinistry()
        {
            ViewData["listofministry"] = sql_conn.usp_getListofMinistry().ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult RemoveMinistry(string MinistryID, string MinistryName)
        {
            int res = sql_conn.usp_removeMinistry(int.Parse(MinistryID)).ElementAt(0).Result;

            if (res == 1)
            {
                ViewData["errormsg"] = "Ministry, " + MinistryName + " deleted.";
            }
            else
            {
                ViewData["errormsg"] = "Unable to delete ministry, " + MinistryName + ".";
            }
            ViewData["listofministry"] = sql_conn.usp_getListofMinistry().ToList();
            return View("ListOfMinistry");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addMinistry(string ministryid)
        {
            if (ministryid != null)
            {
                ViewData["ministryinformation"] = sql_conn.usp_getMinistryInfo(int.Parse(ministryid)).ElementAt(0);
                ViewData["type"] = "update";
            }
            ViewData["hidemenu"] = "true";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addnewMinistry()
        {
            string ministryname = Request.Form["ministryname"];
            string ministrydescription = Request.Form["ministrydescription"];
            string incharge = Request.Form["incharge"];

            int res = sql_conn.usp_addNewMinistry(ministryname, ministrydescription, incharge).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Ministry added.";
            }
            else
            {
                ViewData["errormsg"] = "Ministry add unsuccessful.";
            }

            ViewData["hidemenu"] = "true";
            return View("addMinistry");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult modifyAMinistry(string ministryid)
        {
            ViewData["modify"] = "?ministryid=" + ministryid;
            ViewData["type"] = "update";
            return View("Ministry");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateAMinistry()
        {
            string ministryid = Request.Form["ministryid"];
            string ministryname = Request.Form["ministryname"];
            string ministrydescription = Request.Form["ministrydescription"];
            string incharge = Request.Form["incharge"];

            int res = sql_conn.usp_UpdateMinistry(int.Parse(ministryid), ministryname, ministrydescription, incharge).ElementAt(0).Result;

            ViewData["ministryinformation"] = sql_conn.usp_getMinistryInfo(int.Parse(ministryid)).ElementAt(0);
            ViewData["type"] = "update";
            ViewData["hidemenu"] = "true";
            if (res == 1)
            {
                ViewData["errormsg"] = "Ministry Updated! <br />";
            }
            return View("AddMinistry");
        }






        [ErrorHandler]
        [Authorize]
        public ActionResult Cellgroup()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ListOfCellgroup()
        {
            ViewData["listofcellgroup"] = sql_conn.usp_getListofCellgroup().ToList();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult RemoveCellgroup(string CellgroupID, string CellgroupName)
        {
            int res = sql_conn.usp_removeCellgroup(int.Parse(CellgroupID)).ElementAt(0).Result;

            if (res == 1)
            {
                ViewData["errormsg"] = "Cellgroup, " + CellgroupName + " deleted.";
            }
            else
            {
                ViewData["errormsg"] = "Unable to delete cellgroup, " + CellgroupName + ".";
            }
            ViewData["listofcellgroup"] = sql_conn.usp_getListofCellgroup().ToList();
            return View("ListOfCellgroup");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addCellgroup(string cellgroupid)
        {
            if (cellgroupid != null)
            {
                ViewData["cellgroupinformation"] = sql_conn.usp_getCellgroupInfo(int.Parse(cellgroupid)).ElementAt(0);
                ViewData["candidate_postal_code"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).PostalCode.ToString();
                ViewData["candidate_blk_house"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).BLKHouse;
                ViewData["candidate_unit"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).Unit;
                ViewData["candidate_street_address"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).StreetAddress;
                ViewData["type"] = "update";
            }
            ViewData["hidemenu"] = "true";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult addnewCellgroup()
        {
            string cellgroupname = Request.Form["cellgroupname"];
            string incharge = Request.Form["incharge"];
            string postalcode = Request.Form["candidate_postal_code"];
            string blkhouse = Request.Form["candidate_blk_house"];
            string unit = Request.Form["candidate_unit"];
            string street_address = Request.Form["candidate_street_address"];

            int res = sql_conn.usp_addNewCellgroup(cellgroupname, incharge, int.Parse(postalcode), blkhouse, street_address, unit).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Cellgroup added.";
            }
            else
            {
                ViewData["errormsg"] = "Cellgroup add unsuccessful.";
            }

            ViewData["hidemenu"] = "true";
            return View("addCellgroup");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult modifyACellgroup(string cellgroupid)
        {
            ViewData["type"] = "update";
            ViewData["modify"] = "?cellgroupid=" + cellgroupid;
            return View("Cellgroup");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateACellgroup()
        {
            string cellgroupid = Request.Form["cellgroupid"];
            string cellgroupname = Request.Form["cellgroupname"];
            string incharge = Request.Form["incharge"];
            string postalcode = Request.Form["candidate_postal_code"];
            string blkhouse = Request.Form["candidate_blk_house"];
            string unit = Request.Form["candidate_unit"];
            string street_address = Request.Form["candidate_street_address"];

            int res = sql_conn.usp_UpdateCellgroup(int.Parse(cellgroupid), cellgroupname, incharge, int.Parse(postalcode), blkhouse, street_address, unit).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "Cellgroup modified.";
            }

            ViewData["cellgroupinformation"] = sql_conn.usp_getCellgroupInfo(int.Parse(cellgroupid)).ElementAt(0);
            ViewData["candidate_postal_code"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).PostalCode.ToString();
            ViewData["candidate_blk_house"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).BLKHouse;
            ViewData["candidate_unit"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).Unit;
            ViewData["candidate_street_address"] = ((usp_getCellgroupInfoResult)ViewData["cellgroupinformation"]).StreetAddress;
            ViewData["type"] = "update";
            ViewData["hidemenu"] = "true";
            return View("AddCellgroup");
        }
    }
}
