using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;

namespace DOS.Controllers
{
    [HandleError]
    public class HomeController : MasterPageController
    {
        [ErrorHandler]
        public ActionResult Index()
        {
            if (((string)Session["SystemMode"]).ToUpper() == "FULL" || ((string)Session["SystemMode"]).ToUpper() == "HWS")
            {
                if (!User.Identity.IsAuthenticated)
                    return RedirectToAction("LogOn", "Account");
                else
                    return RedirectToAction("About", "Home");
            }
            else if (((string)Session["SystemMode"]).ToUpper() == "SAMIS")
            {
                if (!User.Identity.IsAuthenticated)
                    return RedirectToAction("NewMember", "Membership");
                else
                    return RedirectToAction("About", "Home");
            }
            else if (((string)Session["SystemMode"]).ToUpper() == "C3CLUB")
            {
                if (!User.Identity.IsAuthenticated)
                    return RedirectToAction("newkid", "CityKids");
                else
                    return RedirectToAction("About", "Home");
            }
            return View();
            
        }

        [ErrorHandler]
        public ActionResult Login()
        {
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult About(string message)
        {
            if (message == null)
                message = "";
            ViewData["errormsg"] = message;
            return View();
        }
    }
}
