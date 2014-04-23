using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;

namespace DOS.Controllers
{
    [HandleError]
    public class ReportingController : MasterPageController
    {
        
        ////////////////////////////
        // REPORTING ///////////////
        ////////////////////////////
        [ErrorHandler]
        [Authorize]
        public ActionResult manualSearch()
        {
            initializedParameter();
            return View("ManualSearch");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult manualSearchlist(string gender, string marriage, string nationality, string dialect, string education, string occupation, string congregation, string language, string cellgroup, string ministry, string batismchurch, string confirmchurch, string previouschurch, string baptismby, string confirmby, string residentalarea)
        {
            if (gender == null && marriage == null && nationality == null && dialect == null && education == null && occupation == null && congregation == null && language == null && cellgroup == null && ministry == null && batismchurch == null && confirmchurch == null && previouschurch == null && baptismby == null && confirmby == null && residentalarea == null)
            {
                ViewData["reportinglist"] = null;
                ViewData["reportinglisttemp"] = null;
            }
            else{
                ViewData["reportinglist"] = sql_conn.usp_getMembersReportingManualSearch(gender, marriage, nationality, dialect, education, occupation, congregation, language, cellgroup, ministry, batismchurch, confirmchurch, previouschurch, baptismby, confirmby, residentalarea, User.Identity.Name).ToList();
                ViewData["reportinglisttemp"] = sql_conn.usp_getMembersTempReportingManualSearch(gender, marriage, nationality, dialect, education, occupation, congregation, language, cellgroup, ministry, batismchurch, confirmchurch, previouschurch, baptismby, confirmby, residentalarea, User.Identity.Name).ToList();
            }
            return View("ManualSearchList");
        }

        [ErrorHandler]
        [Authorize]        
        public ActionResult listbyministry()
        {
            ViewData["ministrylist"] = sql_conn.usp_getListofMinistry().ToList();
            return View("MinistryInvolvement");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ministrylist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("MIN", type, "", User.Identity.Name).ToList();
            return View("MinistryInvolvementList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbybaptisedconfirmed()
        {
            return View("BaptismConfirm");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult baptisedconfirmedlist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("BapCon", type, "", User.Identity.Name).ToList();
            return View("BaptismConfirmList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbycellgroup()
        {
            ViewData["cellgrouplist"] = sql_conn.usp_getListofCellgroup().ToList();
            return View("CellgroupInvolvement");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult cellgrouplist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("CELL", type, "", User.Identity.Name).ToList();
            return View("cellgroupInvolvementList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbymarriage()
        {
            ViewData["maritalstatuslist"] = sql_conn.usp_getAllMaritalStatus().ToList();
            return View("Marriage");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult marriagelist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("MAR", type, "", User.Identity.Name).ToList();
            return View("MarriageList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbyoccupation()
        {
            ViewData["occupationlist"] = sql_conn.usp_getAllOccupation().ToList();
            return View("occupation");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult occupationlist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("OCC", type, "", User.Identity.Name).ToList();
            return View("occupationList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbyage()
        {
            return View("Age");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult agelist(string from, string to)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("AGE", from, to, User.Identity.Name).ToList();
            return View("AgeList");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult listbyelectoral()
        {
            return View("Electoral");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult electorallist(string type)
        {
            ViewData["reportinglist"] = sql_conn.usp_getMembersReporting("ELECT", type, "", User.Identity.Name).ToList();
            return View("ElectoralList");
        }

        private void initializedParameter()
        {
            ViewData["educationlist"] = sql_conn.usp_getAllEducation().ToList();
            ViewData["postalarealist"] = sql_conn.usp_getAllPostalCode().ToList();
            ViewData["maritalstatuslist"] = sql_conn.usp_getAllMaritalStatus().ToList();
            ViewData["salutationlist"] = sql_conn.usp_getAllSalutation().ToList();
            ViewData["dialectlist"] = sql_conn.usp_getAllDialect().ToList();
            ViewData["occupationlist"] = sql_conn.usp_getAllOccupation().ToList();
            ViewData["countrylist"] = sql_conn.usp_getAllCountry().ToList();
            ViewData["parishlist"] = sql_conn.usp_getAllParish().ToList();
            ViewData["languagelist"] = sql_conn.usp_getAllLanguage().ToList();
            ViewData["clergylist"] = sql_conn.usp_getAllClergy().ToList();
            ViewData["congregationlist"] = sql_conn.usp_getAllCongregation().ToList();

            ViewData["ministrylist"] = sql_conn.usp_getListofMinistry().ToList();
            ViewData["courseslist"] = sql_conn.usp_getListofCourse(false, -1).ToList();
            ViewData["cellgrouplist"] = sql_conn.usp_getListofCellgroup().ToList();
        }
    }
}
