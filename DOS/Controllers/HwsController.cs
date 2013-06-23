using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DOS.Controllers
{
    public class HwsController : MasterPageController
    {
        //
        // GET: /Hws/

        public ActionResult AddNewMember()
        {
            return View();
        }

    }
}
