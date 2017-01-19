using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net.Mail;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Xml;
using System.Net;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using System.Data.Linq;
using DOS.Models;
using DOS.Models.JsonClass;
using System.Web.Script.Serialization;
using System.Net.NetworkInformation;
using System.Web.Routing;

namespace DOS.Controllers
{
    [RequireHttpsAttribute]
    public abstract class MasterPageController : Controller
    {
        public DOS_DBDataContext sql_conn = new DOS_DBDataContext();
        static DateTime tokenExpiredTime = DateTime.Now.AddYears(-100);
        static OneMapToken oneMapToken;
        
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Session["UserInformation"] == null && User.Identity.IsAuthenticated)
            {
                DOS_DBDataContext sql_conn = new DOS_DBDataContext();
                Session["UserInformation"] = sql_conn.usp_getUserInformation(User.Identity.Name).ElementAt(0).XML_F52E2B61_18A1_11d1_B105_00805F49916B;
                Session["AccessRight"] = sql_conn.usp_getModuleFunctionsAccessRight(User.Identity.Name).ElementAt(0).FunctionAccessRight;
                Session["LogonUserName"] = sql_conn.usp_getStaffName(User.Identity.Name).ElementAt(0).Name;
    
                WebClient client = new WebClient();                

                Session["TextfieldLength"] = sql_conn.usp_getAllTextFieldLengthInXML().ElementAt(0).XML.ToString();
                IEnumerable<usp_getAppConfigResult> res = sql_conn.usp_getAppConfig().ToList();
                for (int x = 0; x < res.Count(); x++)
                {

                    if (res.ElementAt(x).ConfigName == "OneMapTokenURL")
                    {
                        getOneMapToken(res.ElementAt(x).value.Trim());                        
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
            }

            base.OnActionExecuting(filterContext);
        }

        private void getOneMapToken(string OneMapTokenURL)
        {
            try
            {
                WebClient client = new WebClient();
                tokenExpiredTime = DateTime.Now.AddHours(23);
                string jsonstring = client.DownloadString(OneMapTokenURL);
                JavaScriptSerializer ser = new JavaScriptSerializer();
                oneMapToken = ser.Deserialize<OneMapToken>(jsonstring);
                if (oneMapToken.GetToken.ElementAt(0).NewToken == null)
                    Session["OneMapToken"] = "null";
                else
                    Session["OneMapToken"] = oneMapToken.GetToken.ElementAt(0).NewToken;
            }
            catch (Exception e)
            {
                Session["OneMapToken"] = "null";
            }
        }

        public bool IsConnectedToInternet()
        {
            string host = "www.google.com.sg";
            bool result = false;
            Ping p = new Ping();
            try
            {
                PingReply reply = p.Send(host, 3000);
                if (reply.Status == IPStatus.Success)
                    return true;
            }
            catch { }
            return result;
        }

        //protected override void OnActionExecuted(ActionExecutedContext filterContext)
        //{
        //    string s = "sdf";
        //}

        public void sendEmail(MailMessage mail)
        {
            
			mail.From = new MailAddress("jamestan@cathedral.org.sg");
			SmtpClient smtpclient = new SmtpClient("in-v3.mailjet.com");
            smtpclient.Credentials = new NetworkCredential("087009d1c4d72791e03c3167c2bf8d88", "322a6fccc20dba6a74fdb243edd2d9af");
            smtpclient.EnableSsl = true;
            smtpclient.Port = 587;

            smtpclient.Send(mail);            
        }

        public MasterPageController()
        {

        }        
    }
}
