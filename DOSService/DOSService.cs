using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;
using System.Threading;
using System.Xml.Linq;
using System.Net.Mail;
using System.Net;
using System.Configuration;

namespace DOSService
{
    class DOSService
    {
        string SMTPAccount = "";
        string SMTPAddress = "";
        string SMTPAccountPassword = "";
        private int sleepinminutes = 1;
        private bool continueRun = true;
        System.Timers.Timer MonitoringThreadTimer;
        private Thread subThreadEmailAlert = null;
        string emailContent = "";
        public DOSService(bool isConsole)
        {
            sleepinminutes = int.Parse(ConfigurationManager.AppSettings.Get("SleepInMinutes"));

            MonitoringThreadTimer = new System.Timers.Timer();
            MonitoringThreadTimer.Elapsed += new ElapsedEventHandler(StartMonitoring);
            
            MonitoringThreadTimer.Interval = 1000;
            MonitoringThreadTimer.Enabled = true;

            if (isConsole)
                Console.Read();
        }

        private void StartMonitoring(object source, ElapsedEventArgs e)
        {
            
            try
            {
                Console.WriteLine("StartMonitoring starts " + DateTime.Now);
                DBConnectionDataContext sql_conn = new DBConnectionDataContext();
                MonitoringThreadTimer.Enabled = false;
                MonitoringThreadTimer.Interval = sleepinminutes * 1000 * 60;

                IEnumerable<usp_getAppConfigResult> res = sql_conn.usp_getAppConfig().ToList();
                for (int x = 0; x < res.Count(); x++)
                {
                    if (res.ElementAt(x).ConfigName == "SMTPAccount")
                    {
                        SMTPAccount = res.ElementAt(x).value;
                    }
                    else if (res.ElementAt(x).ConfigName == "SMTPAddress")
                    {
                        SMTPAddress = res.ElementAt(x).value;
                    }
                    else if (res.ElementAt(x).ConfigName == "SMTPAccountPassword")
                    {
                        SMTPAccountPassword = res.ElementAt(x).value;
                    }
                }

                IEnumerable<usp_getAllEmailResult> emailres = sql_conn.usp_getAllEmail().ToList();
                for (int x = 0; x < emailres.Count(); x++)
                {
                    if (emailres.ElementAt(x).EmailType.ToUpper() == "COURSEREMINDER")
                    {
                        emailContent = emailres.ElementAt(x).EmailContent;
                    }
                }

                if (subThreadEmailAlert == null || !subThreadEmailAlert.IsAlive)
                {
                    continueRun = true;
                    sql_conn.usp_insertlogging('I', "DOSService", "DOSService", "MainThread Started",  0, "", "", XElement.Parse("<empty />"));
                    subThreadEmailAlert = new Thread(EmailAlert);
                    subThreadEmailAlert.IsBackground = false;
                    subThreadEmailAlert.Start(new string[] { "" });
                }

                MonitoringThreadTimer.Enabled = true;
                sql_conn.Connection.Close();
            }
            catch(Exception err){
                XElement xml = new XElement("Error");
                xml.Add(new XElement("Message", err.Message));
                xml.Add(new XElement("InnerException", err.InnerException));
                xml.Add(new XElement("Source", err.Source));
                xml.Add(new XElement("StackTrace", err.StackTrace));

                DBConnectionDataContext exception_sql_conn = new DBConnectionDataContext();
                exception_sql_conn.usp_insertlogging('E', "DOSService", "DOSService", "EmailAlertThread Exception", 0, "", "", xml);
                exception_sql_conn.Connection.Close();
            }

        }
        
        private void EmailAlert(object args)
        {            
            try
            {
                Console.WriteLine("Email Alert Starts " + DateTime.Now);
                DBConnectionDataContext sql_conn = new DBConnectionDataContext();
                IEnumerable<usp_getAllCourseReminderRecipientsResult> res = sql_conn.usp_getAllCourseReminderRecipients().ToList();
                foreach (usp_getAllCourseReminderRecipientsResult recipient in res)
                {
                    if (recipient.Email.Length > 0)
                    {
                        string mailbody = emailContent;
                        mailbody = mailbody.Replace("[AreaName]", recipient.AreaName);
                        mailbody = mailbody.Replace("[CourseEndTime]", recipient.CourseEndTime.ToString(@"hh\:mm"));
                        mailbody = mailbody.Replace("[CourseName]", recipient.CourseName);
                        mailbody = mailbody.Replace("[CourseStartDate]", recipient.CourseStartDate.ToString());
                        mailbody = mailbody.Replace("[CourseStartTime]", recipient.CourseStartTime.ToString(@"hh\:mm"));
                        mailbody = mailbody.Replace("[Email]", recipient.Email);
                        mailbody = mailbody.Replace("[Name]", recipient.Name);


                        MailMessage mail = new MailMessage();
                        mail.IsBodyHtml = true;
                        string to = recipient.Email;

                        mail.From = new MailAddress(SMTPAccount);
                        mail.To.Add("<" + to + ">");

                        mail.Subject = "Course Commencing Reminder";        // put subject here	        
                        mail.IsBodyHtml = true;
                        mail.Body = mailbody;

                        SmtpClient smtpclient = new SmtpClient(SMTPAddress);
                        smtpclient.Credentials = new NetworkCredential(SMTPAccount, SMTPAccountPassword);
                        smtpclient.EnableSsl = true;
                        smtpclient.Port = 587;

                        smtpclient.Send(mail);
                        Console.WriteLine("EmailAlertThread EmailSent " + recipient.Email + " " + recipient.CourseName);
                        sql_conn.usp_insertlogging('I', "DOSService", "DOSService", "EmailAlertThread EmailSent " + recipient.Email + " " + recipient.CourseName, 0, "", "", XElement.Parse("<empty />"));
                    
                    }                        
                }

                sql_conn.usp_insertlogging('I', "DOSService", "DOSService", "EmailAlertThread Exit, Starting again on " + DateTime.Now.AddMinutes(sleepinminutes).ToString(), 0, "", "", XElement.Parse("<empty />"));
                Console.WriteLine("EmailAlert Done");                
            }
            catch (Exception e)
            {
                XElement xml = new XElement("Error");
                xml.Add(new XElement("Message", e.Message));
                xml.Add(new XElement("InnerException", e.InnerException));
                xml.Add(new XElement("Source", e.Source));
                xml.Add(new XElement("StackTrace", e.StackTrace));

                DBConnectionDataContext exception_sql_conn = new DBConnectionDataContext();
                exception_sql_conn.usp_insertlogging('E', "DOSService", "DOSService", "EmailAlertThread Exception", 0, "", "", xml);
                exception_sql_conn.Connection.Close();
            }
            
        }

        public void stopMonitoring()
        {            
            DBConnectionDataContext exception_sql_conn = new DBConnectionDataContext();
            exception_sql_conn.usp_insertlogging('I', "DOSService", "DOSService", "MainThread Exiting", 0, "", "", XElement.Parse("<empty />"));
            exception_sql_conn.Connection.Close();

            subThreadEmailAlert.Abort();
            MonitoringThreadTimer.Enabled = false;

        }
    }
}
