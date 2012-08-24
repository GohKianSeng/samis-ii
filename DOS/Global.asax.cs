using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using DOS.Models;
using DOS.Models.JsonClass;
using System.Net;
using System.Web.Script.Serialization;
using System.Net.NetworkInformation;

namespace DOS
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public DOS_DBDataContext sql_conn = new DOS_DBDataContext();
        static DateTime tokenExpiredTime = DateTime.Now.AddYears(-100);
        static OneMapToken oneMapToken;
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default.mvc", // Route name
                "{controller}.mvc/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );
            routes.MapRoute(
                "Default",                                              // Route name
                "{controller}/{action}/{id}",                           // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional }  // Parameter defaults
            );

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

        protected void Session_Start(object sender, EventArgs e)
        {
            WebClient client = new WebClient();
            DOS_DBDataContext sql_conn = new DOS_DBDataContext();

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
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }

    }
}


/*
32bit (x86) Windows

    %windir%\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -ir

64bit (x64) Windows

    %windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe -ir
*/