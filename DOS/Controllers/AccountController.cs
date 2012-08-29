using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using DOS.Models;
using System.Security.Cryptography;
using System.Text;
using System.Web.Script.Serialization;
using DOS.Models.JsonClass;
using System.Net;

namespace DOS.Controllers
{
    [HandleError]
    public class AccountController : MasterPageController
    {

        public IFormsAuthenticationService FormsService { get; set; }
        //public IMembershipService MembershipService { get; set; }
        static DateTime tokenExpiredTime = DateTime.Now.AddYears(-100);
        static OneMapToken oneMapToken;

        protected override void Initialize(RequestContext requestContext)
        {
            if (FormsService == null) { FormsService = new FormsAuthenticationService(); }
            //if (MembershipService == null) { MembershipService = new AccountMembershipService(); }

            base.Initialize(requestContext);
        }

        // **************************************
        // URL: /Account/LogOn
        // **************************************

        public ActionResult LogOn()
        {
            ViewData["ReturnUrl"] = Request.Params["ReturnUrl"];
            return View();
        }

        [ErrorHandler]
        [HttpPost]
        public ActionResult LogOn(LogOnModel model)
        {
            //string xxx = null;
            //xxx.Trim();

            if (ModelState.IsValid)
            {
                IEnumerable<usp_checkUserLoginResult> result = sql_conn.usp_checkUserLogin(model.UserName, model.Password).ToList();
                if (result.Count() == 1 && result.ElementAt(0).Result != null)
                {
                    FormsService.SignIn(model.UserName, false);
                    Session["UserInformation"] = result.ElementAt(0).Result;
                    Session["AccessRight"] = sql_conn.usp_getModuleFunctionsAccessRight(model.UserName).ElementAt(0).FunctionAccessRight;
                    Session["LogonUserName"] = sql_conn.usp_getStaffName(model.UserName).ElementAt(0).Name;
                    if (Request.Params["ReturnURL"] != null)
                    {
                        if (Request.Params["ReturnURL"].Length > 0)
                        {
                            string controller = Request.Params["ReturnURL"].Substring(1, Request.Params["ReturnURL"].IndexOf(".mvc")-1);//"/membership.mvc/UpdateMember"
                            string method = Request.Params["ReturnURL"].Substring(Request.Params["ReturnURL"].IndexOf(".mvc/")+5);//"/membership.mvc/UpdateMember"
                            return RedirectToAction(method, controller);
                        }
                    }

                    WebClient client = new WebClient();
                    Session["FileIOStream"] = null;
                    Session["FileName"] = "";
                    Session["TextfieldLength"] = sql_conn.usp_getAllTextFieldLengthInXML().ElementAt(0).XML.ToString();
                    IEnumerable<usp_getAppConfigResult> res = sql_conn.usp_getAppConfig().ToList();
                    for (int x = 0; x < res.Count(); x++)
                    {

                        if (res.ElementAt(x).ConfigName == "OneMapTokenURL")
                        {
                            String jsonstring = "";
                            if (tokenExpiredTime != DateTime.Now && IsConnectedToInternet())
                            {
                                tokenExpiredTime = DateTime.Now.AddHours(23);
                                jsonstring = client.DownloadString(res.ElementAt(x).value.Trim());
                                JavaScriptSerializer ser = new JavaScriptSerializer();
                                oneMapToken = ser.Deserialize<OneMapToken>(jsonstring);
                                Session["OneMapToken"] = oneMapToken.GetToken.ElementAt(0).NewToken;
                            }
                            else
                            {
                                Session["OneMapToken"] = "null";
                            }
                        }
                        else if (res.ElementAt(x).ConfigName == "PostalCodeRetrivalURL")
                        {
                            Session[res.ElementAt(x).ConfigName] = res.ElementAt(x).value.Trim().Replace("<KSTOKEN>", (string)Session["OneMapToken"]);
                        }
                        else
                            Session[res.ElementAt(x).ConfigName] = res.ElementAt(x).value.Trim();
                    }
                    if (((string)Session["OneMapToken"]).ToString() == "null")
                    {
                        Session["AutoPostalCode"] = "Off";
                    }
                    if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                    {
                        IEnumerable<usp_getAllEmailResult> emailres = sql_conn.usp_getAllEmail().ToList();
                        for (int x = 0; x < emailres.Count(); x++)
                        {
                            Session[emailres.ElementAt(x).EmailType] = emailres.ElementAt(x).EmailContent;
                        }
                    }

                    return RedirectToAction("About", "Home");
                }
                else
                {
                    ViewData["error"] = "Invaid UserID or password. Please try again.";
                    return View("LogOn");
                }
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult LogOff()
        {
            FormsService.SignOut();

            return RedirectToAction("Index", "Home");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult AddUser()
        {
            setAllParameters();
            ViewData["error"] = "";
            ViewData["Name"] = "";
            ViewData["NRIC"] = "";
            ViewData["Email"] = "";
            ViewData["Phone"] = "";
            ViewData["Mobile"] = "";
            ViewData["UserID"] = "";
            ViewData["Department"] = "";
            ViewData["Type"] = "Register";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        [HttpPost]
        public ActionResult Register(string Name, string NRIC, string Email, string Phone, string Mobile, string UserID, string Department, string Style, string StyleName)
        {
            string password = BitConverter.ToString(SHA1Managed.Create().ComputeHash(Encoding.Default.GetBytes(UserID))).Replace("-", "");
            string res = sql_conn.usp_addNewUser(UserID, Name, Email, Phone, Mobile, Department, NRIC, password, Style).ElementAt(0).Result;
            setAllParameters();
            if (res != "OK")
            {
                if (res == "NRIC")
                    ViewData["error"] = "This person is already registered. NRIC exists in database.";
                if (res == "UserID")
                    ViewData["error"] = "UserID is in used. Please choose another one.";

                ViewData["Name"] = Name;
                ViewData["NRIC"] = NRIC;
                ViewData["Email"] = Email;
                ViewData["Phone"] = Phone;
                ViewData["Mobile"] = Mobile;
                ViewData["UserID"] = UserID;
                ViewData["Department"] = Department;
                ViewData["Style"] = Style;
                ViewData["Type"] = "Register";
                return View("AddUser");
            }
            ViewData["error"] = "User, " + StyleName + " " + Name + " added.";
            ViewData["Type"] = "Register";
            return View("AddUser");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateUser()
        {
            setAllParameters();
            ViewData["Type"] = "SaveUserInformation";
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult SaveUserInformation(string Name, string NRIC, string Email, string Phone, string Mobile, string UserID, string Department, string Style)
        {
            setAllParameters();
            Session["UserInformation"] = sql_conn.usp_UpdateUserInformation(UserID, Name, Email, Phone, Mobile, Department, NRIC, Style).ElementAt(0).Result;
            ViewData["error"] = "Information updated.";
            ViewData["Type"] = "SaveUserInformation";
            return View("AddUser");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult ChangePassword()
        {
            ViewData["PasswordLength"] = 6;
            return View();
        }

        [ErrorHandler]
        [Authorize]
        [HttpPost]
        public ActionResult updateNewPassword(ChangePasswordModel model)
        {
            int res = (int)sql_conn.usp_UpdateUserPassword(User.Identity.Name, model.OldPassword, model.NewPassword).ElementAt(0).Result;
            if(res == 1){
                ViewData["error"] = "Password change successfully.";
                return View("ChangePassword");
            }
            else{
                ViewData["error"] = "Old password is wrong Please Try again.";
                return View("ChangePassword");
            }
        }

        [ErrorHandler]
        [Authorize]
        [HttpPost]
        public ActionResult removeStaff(string userid, string name)
        {
            int res = (int)sql_conn.usp_removeUser(userid).ElementAt(0).Result;
            if (res == 1)
            {
                ViewData["errormsg"] = "User, " + name + ", successfully removed.";
            }
            else
            {
                ViewData["errormsg"] = "Name, " + name + " UserID: " + userid + " not found.";
            }

            ViewData["lisfofstaff"] = sql_conn.usp_getAllStaff().ToList();
            return View("ListOfStaff");
        }

        [ErrorHandler]
        public ActionResult ChangePasswordSuccess()
        {
            return View();
        }

        [ErrorHandler]
        public ActionResult resetStaffPassword(string UserID, string Name)
        {
            int result = sql_conn.usp_resetUserPassword(UserID, BitConverter.ToString(SHA1Managed.Create().ComputeHash(Encoding.Default.GetBytes(UserID))).Replace("-", "")).ElementAt(0).Column1;
            if (result == 1)
                ViewData["errormsg"] = "Password reset to default.";
            else
                ViewData["errormsg"] = Name + " record not found!";
            return RedirectToAction("listallStaff", "Parish", new { message = (string)ViewData["errormsg"] });
        }

        private void setAllParameters(){
            ViewData["stylelist"] = sql_conn.usp_getAllStyle().ToList();
        }
    }
}
