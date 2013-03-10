using System.Web.Mvc;
using DOS.Models;
using System.Xml.Linq;
using System.Text;
using System;
using System.Web.Routing;
using System.Net.Mail;
using System.Collections.Generic;
using System.Net;
using System.Net.Mime;
using System.Net.NetworkInformation;
using System.Data.Linq;
public class ErrorHandler : HandleErrorAttribute
{
    
    public override void OnException(ExceptionContext httpContext)
    {
        XElement error = new XElement("Error");
        string emailbody = "<table border='1'>";
        emailbody += "<tr><td>User</td><td>" + (string)httpContext.HttpContext.Session["LogonUserName"] + "</td></tr>";
        emailbody += "<tr><td>Site</td><td>" + httpContext.HttpContext.Request.Url.ToString() + "</td></tr>";
        emailbody += "<tr><td>ControllerName</td><td>" + httpContext.Controller.ToString() + "</td></tr>";
        emailbody += "<tr><td>Method</td><td>" + httpContext.Exception.TargetSite.Name + "</td></tr>";
        emailbody += "<tr><td>Message</td><td>" + httpContext.Exception.Message + "</td></tr>";
        emailbody += "<tr><td>InnerException</td><td>" + httpContext.Exception.InnerException + "</td></tr>";
        emailbody += "<tr><td>StackTrace</td><td>" + httpContext.Exception.StackTrace.ToString() + "</td></tr>";


        error.Add(new XElement("ControllerName", httpContext.Controller.ToString()));
        error.Add(new XElement("Method", httpContext.Exception.TargetSite.Name));       
        error.Add(new XElement("Message", httpContext.Exception.Message));
        error.Add(new XElement("InnerException", httpContext.Exception.InnerException));
        error.Add(new XElement("StackTrace", httpContext.Exception.StackTrace.ToString()));
        
        XElement para = new XElement("Parameters");
        for (int x = 0; x < httpContext.HttpContext.Request.Form.Count; x++)
        {
            XElement parameters = new XElement("para");
            parameters.Add(new XElement("Name", httpContext.HttpContext.Request.Form.AllKeys[x]));
            parameters.Add(new XElement("Value", httpContext.HttpContext.Request.Form[httpContext.HttpContext.Request.Form.AllKeys[x]]));
            emailbody += "<tr><td>" + httpContext.HttpContext.Request.Form.AllKeys[x] + "</td><td>" + httpContext.HttpContext.Request.Form[httpContext.HttpContext.Request.Form.AllKeys[x]] + "</td></tr>";
            para.Add(parameters);
        }
        error.Add(para);

        DOS_DBDataContext sql_conn = new DOS_DBDataContext();
        sql_conn.usp_insertlogging('E', "System", "SystemError", "SystemError", 1, "NA", "", error);

        sendErrorEmail(emailbody, (string)httpContext.HttpContext.Session["ErrorRecipients"], (string)httpContext.HttpContext.Session["SMTPAccount"], (string)httpContext.HttpContext.Session["SMTPAccountPassword"], (string)httpContext.HttpContext.Session["SMTPAddress"]);

        httpContext.Result = new RedirectToRouteResult(new RouteValueDictionary(
                new { controller = "Error", action = "DisplayError"                      
                }));
    }

    public bool sendErrorEmail(string error, string recepients, string from, string password, string smtp)
    {
        MailMessage mail = new MailMessage();
        mail.IsBodyHtml = true;
        string to = recepients;

        mail.From = new MailAddress(from);
        
        if (to.Length == 0)
            return false;
        string[] emailTo = to.Split(';');
        for (int x = 0; x < emailTo.Length; x++)
        {
            if (emailTo[x].Trim().Length != 0)
                mail.To.Add("<" + emailTo[x].Trim() + ">");
        }

        mail.Subject = "SAMIS Error";        // put subject here	        
        mail.Body = error;

        SmtpClient smtpclient = new SmtpClient(smtp);
        smtpclient.Credentials = new NetworkCredential(from, password);
        smtpclient.EnableSsl = true;
        smtpclient.Port = 587;

        if (IsConnectedToInternet())
        {
            //smtpclient.Send(mail);
            return true;
        }
        return false;
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
}