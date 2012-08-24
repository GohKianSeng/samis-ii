using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;

namespace DOS.Controllers
{
    public class ErrorController : MasterPageController
    {
        public ActionResult DisplayError(string controllername, string methodname, string messagestring, string innerexception, string stacktrace)
        {
            ViewData["ControllerName"] = controllername;
            ViewData["Method"] = methodname;
            ViewData["Message"] = messagestring;
            ViewData["InnerException"] = innerexception;
            ViewData["StackTrace"] = HttpUtility.UrlDecode(stacktrace);
            return View();
        }
    }
}
