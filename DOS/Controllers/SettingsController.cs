using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DOS.Controllers;
using DOS.Models;
using System.Xml.Linq;
using System.IO;
using System.Net;
using System.Diagnostics;
using System.Threading;
using System.Net.Mail;

namespace DOS.Controllers
{
    [HandleError]
    public class SettingsController : MasterPageController
    {
        static string serverSideProcessMsg = "";

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SyncAllSettings()
        {
            serverSideProcessMsg = "";
            Thread t1 = new Thread(ExecuteSyncDBJob);
            t1.Start(new string[] { 
                Session["ErrorRecipients"].ToString(),
                Session["SMTPAccount"].ToString(),
                Session["SMTPAddress"].ToString(),
                Session["SMTPAccountPassword"].ToString(),
                Session["icphotolocation"].ToString()
            });
            return View("simplehtml");
        }

        private void ExecuteSyncDBJob(object args)
        {
            string[] obj = (string[])args;

            XElement xmlDoc = sql_conn.usp_GetAllSettingsInXML().ElementAt(0).XML;
            IEnumerable<usp_getAllSettingResult> res = sql_conn.usp_getAllSetting().ToList();
            serverSideProcessMsg = "8";
            int count = 8;
            
            string url = "https://" + res.ElementAt(0).ExternalDBIP;
            for (int b = 0; b < xmlDoc.Elements().Count(); b++)
            {
                XElement temp = new XElement("All");
                temp.Add(xmlDoc.Elements().ElementAt(b));
                string updateResult = HttpPost(url + "/settings.mvc/SyncxmlDoc", temp.ToString(), xmlDoc.Elements().ElementAt(b).Name.ToString());
                if (updateResult == "Error")
                {
                    serverSideProcessMsg = "Error";
                    return;
                }
                count++; count++;
                serverSideProcessMsg = count.ToString();
            }
            count = 50;
            serverSideProcessMsg = "50";

            XElement tempRec = new XElement("All");
            tempRec.Add(new XElement("userid", "getallrecords"));
            tempRec.Add(new XElement("password", "t@@uyawamuv7darachu$ran2dewa#rE-h3sec3a?an9za_uwRepr8?ab#s9u+$#t"));

            string recResult = HttpPost(url + "/settings.mvc/GetVisitorMemberForSync", tempRec.ToString(), "nil");
            IEnumerable<usp_SyncVisitorAndMembersResult> syncRes = sql_conn.usp_SyncVisitorAndMembers(XElement.Parse(recResult)).ToList();
            if (syncRes.Count() > 0)
            {
                double countincrement = 50.0 / ((float)syncRes.Count());
                double downloadCount = 0.0;
                for (int y = 0; y < syncRes.Count(); y++)
                {
                    if (syncRes.ElementAt(y).Type == "New" && (bool)syncRes.ElementAt(y).Successful)
                    {
                        downloadAndDeleteRemoteStorageFile(syncRes.ElementAt(y).PhotoFile, url, obj[4]);
                        new WebClient().DownloadString(url + "/settings.mvc/SyncDeleteMember?NRIC=" + syncRes.ElementAt(y).NRIC);
                    }
                    else if (syncRes.ElementAt(y).Type == "Update" && (bool)syncRes.ElementAt(y).Successful)
                    {
                        new WebClient().DownloadString(url + "/settings.mvc/SyncDeleteVisitor?NRIC=" + syncRes.ElementAt(y).NRIC);                        
                    }
                    downloadCount += countincrement;
                    count = count + (int)downloadCount;
                    serverSideProcessMsg = count.ToString();
                    if (!(bool)syncRes.ElementAt(y).Successful)
                    {
                        SendSyncDataEmail(recResult, syncRes.ElementAt(y).NRIC, obj[0], obj[1], obj[2], obj[3]);
                    }
                }
            }


            serverSideProcessMsg = "100";
            System.Threading.Thread.Sleep(2000);
            serverSideProcessMsg = "Updated";
        }

        private void SendSyncDataEmail(string xml, string nric, string ErrorRecipient, string SMTPAccount, string SMTPAddress, string SMTPAccountPassword)
        {
            MailMessage mail = new MailMessage();
            mail.IsBodyHtml = false;

            mail.From = new MailAddress(SMTPAccount);
            string[] emailTo = ErrorRecipient.Split(';');
            for (int x = 0; x < emailTo.Length; x++)
            {
                if (emailTo[x].Trim().Length != 0)
                    mail.To.Add("<" + emailTo[x].Trim() + ">");
            }

            mail.Subject = "SAMIS Sync Data Error, NRIC: " + nric;        // put subject here	        
            mail.Body = xml;

            SmtpClient smtpclient = new SmtpClient(SMTPAddress);
            smtpclient.Credentials = new NetworkCredential(SMTPAccount, SMTPAccountPassword);
            smtpclient.EnableSsl = true;
            smtpclient.Port = 587;

            smtpclient.Send(mail);
        }
        

        private void downloadAndDeleteRemoteStorageFile(string filename, string host, string savelocation)
        {
            if (filename == null || filename.Length <= 0)
                return;

            WebClient client = new WebClient();
            client.DownloadFile(host + "/UploadFile.mvc/downloadPhoto?guid=&filename=" + filename, savelocation + "temp_" +filename);
            client.DownloadString(host + "/UploadFile.mvc/deleteRemoteStoragePhoto?filename=" + filename);
            
        }

        public static string HttpPost(string url, string files, string type)
        {
            string boundary = "----------------------------" + DateTime.Now.Ticks.ToString("x");

            HttpWebRequest httpWebRequest2 = (HttpWebRequest)WebRequest.Create(url);
            httpWebRequest2.ContentType = "multipart/form-data; boundary=" + boundary;
            httpWebRequest2.Method = "POST";
            httpWebRequest2.KeepAlive = true;
            httpWebRequest2.Credentials = System.Net.CredentialCache.DefaultCredentials;



            Stream memStream = new System.IO.MemoryStream();

            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");


            string formdataTemplate = "\r\n--" + boundary + "\r\nContent-Disposition: form-data; name=\"{0}\";\r\n\r\n{1}";


            string formitem = string.Format(formdataTemplate, "UserID", "samissync");
            byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
            memStream.Write(formitembytes, 0, formitembytes.Length);

            formitem = string.Format(formdataTemplate, "Password", "Fe6eyuf3a2U8hah");
            formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
            memStream.Write(formitembytes, 0, formitembytes.Length);

            formitem = string.Format(formdataTemplate, "SyncType", type);
            formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
            memStream.Write(formitembytes, 0, formitembytes.Length);

            memStream.Write(boundarybytes, 0, boundarybytes.Length);

            string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\n Content-Type: application/octet-stream\r\n\r\n";

            string header = string.Format(headerTemplate, "", "");

            byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);

            memStream.Write(headerbytes, 0, headerbytes.Length);



            byte[] buffer = System.Text.Encoding.ASCII.GetBytes(HttpUtility.UrlEncode(files.Replace("\n", "").Replace("\r", "")));
            memStream.Write(buffer, 0, buffer.Length);

            memStream.Write(boundarybytes, 0, boundarybytes.Length);


            httpWebRequest2.ContentLength = memStream.Length;

            Stream requestStream = httpWebRequest2.GetRequestStream();

            memStream.Position = 0;
            byte[] tempBuffer = new byte[memStream.Length];
            memStream.Read(tempBuffer, 0, tempBuffer.Length);
            memStream.Close();
            requestStream.Write(tempBuffer, 0, tempBuffer.Length);
            requestStream.Close();


            WebResponse webResponse2 = httpWebRequest2.GetResponse();
            System.IO.StreamReader sr = new System.IO.StreamReader(webResponse2.GetResponseStream());
            string result = sr.ReadToEnd().Trim();

            webResponse2.Close();
            httpWebRequest2 = null;
            webResponse2 = null;

            return result;
        }

        public ActionResult SyncDeleteMember(string NRIC)
        {
            sql_conn.usp_removeMember(NRIC, "Temp");
            return View("simplehtml");
        }

        public ActionResult SyncDeleteVisitor(string NRIC)
        {
            sql_conn.usp_removeMember(NRIC, "Visitor");
            return View("simplehtml");
        }

        public ActionResult checkSyncAllSettings()
        {
            ViewData["result"] = serverSideProcessMsg;
            return View("simplehtml");
        }

        [ErrorHandler]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult SyncxmlDoc(string xmlDoc)
        {
            if (Request.Files.Count == 1)
            {
                Stream input = Request.Files[0].InputStream;
                byte[] buffer = new byte[Request.Files[0].ContentLength];
                int len;
                string value = "";
                while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    value += System.Text.ASCIIEncoding.ASCII.GetString(buffer);
                }
                XElement xml = XElement.Parse(HttpUtility.UrlDecode(value));
                string userid = Request.Form["UserID"];
                string password = Request.Form["Password"];
                string SyncType = Request.Form["SyncType"];

                if (userid == "samissync" && password == "Fe6eyuf3a2U8hah")
                {
                    string result = "";
                    switch (SyncType)
                    {
                        case "AllChurchArea":
                            result = sql_conn.usp_SyncAllSettings_Area(xml).ElementAt(0).Result;
                            break;
                        case "AllCongregation":
                            result = sql_conn.usp_SyncAllSettings_Congregation(xml).ElementAt(0).Result;
                            break;
                        case "AllCountry":
                            result = sql_conn.usp_SyncAllSettings_Country(xml).ElementAt(0).Result;
                            break;
                        case "AllDialect":
                            result = sql_conn.usp_SyncAllSettings_Dialect(xml).ElementAt(0).Result;
                            break;
                        case "AllEducation":
                            result = sql_conn.usp_SyncAllSettings_Education(xml).ElementAt(0).Result;
                            break;
                        case "AllFileType":
                            result = sql_conn.usp_SyncAllSettings_FileType(xml).ElementAt(0).Result;
                            break;
                        case "AllFamilyType":
                            result = sql_conn.usp_SyncAllSettings_FamilyType(xml).ElementAt(0).Result;
                            break;
                        case "AllLanguage":
                            result = sql_conn.usp_SyncAllSettings_Language(xml).ElementAt(0).Result;
                            break;
                        case "AllMaritalStatus":
                            result = sql_conn.usp_SyncAllSettings_MaritalStatus(xml).ElementAt(0).Result;
                            break;
                        case "AllOccupation":
                            result = sql_conn.usp_SyncAllSettings_Occupation(xml).ElementAt(0).Result;
                            break;
                        case "AllParish":
                            result = sql_conn.usp_SyncAllSettings_Parish(xml).ElementAt(0).Result;
                            break;
                        case "AllSalutation":
                            result = sql_conn.usp_SyncAllSettings_Salutation(xml).ElementAt(0).Result;
                            break;
                        case "AllStyle":
                            result = sql_conn.usp_SyncAllSettings_Style(xml).ElementAt(0).Result;
                            break;
                        case "AllPostalArea":
                            result = sql_conn.usp_SyncAllSettings_PostalArea(xml).ElementAt(0).Result;
                            break;
                        case "AllBusGroupCluster":
                            result = sql_conn.usp_SyncAllSettings_BusGroupCluster(xml).ElementAt(0).Result;
                            break;
                        case "AllClubGroup":
                            result = sql_conn.usp_SyncAllSettings_ClubGroup(xml).ElementAt(0).Result;
                            break;
                        case "AllRace":
                            result = sql_conn.usp_SyncAllSettings_Race(xml).ElementAt(0).Result;
                            break;
                        case "AllReligion":
                            result = sql_conn.usp_SyncAllSettings_Religion(xml).ElementAt(0).Result;
                            break;
                        case "AllSchool":
                            result = sql_conn.usp_SyncAllSettings_School(xml).ElementAt(0).Result;
                            break;
                        case "AllCourse":
                            result = sql_conn.usp_SyncAllSettings_Course(xml).ElementAt(0).Result;
                            break;
                        case "AllChurchAgreement":
                            result = sql_conn.usp_SyncAllSettings_AdditionalInformation(xml).ElementAt(0).Result;
                            break;
                        case "AllChurchEmail":
                            result = sql_conn.usp_SyncAllSettings_EmailContent(xml).ElementAt(0).Result;
                            break;
                    }

                    if (result != "Updated")
                    {
                        ViewData["result"] = "Error";
                        return View("simplehtml");
                    }

                }
                else
                {
                    ViewData["result"] = "Error";
                    return View("simplehtml");
                }
            }
            else
            {
                ViewData["result"] = "Error";
                return View("simplehtml");
            }

            ViewData["result"] = "Updated";
            return View("simplehtml");
        }

        [ErrorHandler]
        public ActionResult GetVisitorMemberForSync(string xmlDoc)
        {
            XElement records = new XElement("empty");
            if (Request.Files.Count == 1)
            {
                Stream input = Request.Files[0].InputStream;
                byte[] buffer = new byte[Request.Files[0].ContentLength];
                int len;
                string value = "";
                while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
                {
                    value += System.Text.ASCIIEncoding.ASCII.GetString(buffer);
                }
                XElement xml = XElement.Parse(HttpUtility.UrlDecode(value));
                string userid = Request.Form["UserID"];
                string password = Request.Form["Password"];
                string SyncType = Request.Form["SyncType"];

                string recordUserid = xml.Element("userid").Value;
                string recordpassword = xml.Element("password").Value;

                if (userid == "samissync" && password == "Fe6eyuf3a2U8hah" && recordUserid == "getallrecords" && recordpassword == "t@@uyawamuv7darachu$ran2dewa#rE-h3sec3a?an9za_uwRepr8?ab#s9u+$#t")
                {
                    records = sql_conn.usp_getRecordForSync().ElementAt(0).SyncData;
                }

            }



            ViewData["result"] = records.ToString();
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult Samis2Settings()
        {
            IEnumerable<usp_getAllExternalDBInXMLResult> ext = sql_conn.usp_getAllExternalDBInXML().ToList();
            if (ext.Count() == 0)
                ViewData["externaldbxml"] = "<ExternalDB />";
            else if (ext.Count() > 0)
                ViewData["externaldbxml"] = ext.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllChurchAreaInXMLResult> ca = sql_conn.usp_getAllChurchAreaInXML().ToList();
            if (ca.Count() == 0)
                ViewData["churchareaxml"] = "<ChurchArea />";
            else if (ca.Count() > 0)
                ViewData["churchareaxml"] = ca.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllCongregationInXMLResult> con = sql_conn.usp_getAllCongregationInXML().ToList();
            if (con.Count() == 0)
                ViewData["congregationxml"] = "<ChurchCongregation />";
            else if (con.Count() > 0)
                ViewData["congregationxml"] = con.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllCountryInXMLResult> cou = sql_conn.usp_getAllCountryInXML().ToList();
            if (cou.Count() == 0)
                ViewData["countryxml"] = "<ChurchCountry />";
            else if (cou.Count() > 0)
                ViewData["countryxml"] = cou.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllDialectInXMLResult> dia = sql_conn.usp_getAllDialectInXML().ToList();
            if (dia.Count() == 0)
                ViewData["dialectxml"] = "<ChurchDialect />";
            else if (dia.Count() > 0)
                ViewData["dialectxml"] = dia.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllEducationInXMLResult> edu = sql_conn.usp_getAllEducationInXML().ToList();
            if (edu.Count() == 0)
                ViewData["educationxml"] = "<ChurchEducation />";
            else if (edu.Count() > 0)
                ViewData["educationxml"] = edu.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllLanguageInXMLResult> lang = sql_conn.usp_getAllLanguageInXML().ToList();
            if (lang.Count() == 0)
                ViewData["languagexml"] = "<ChurchLanguage />";
            else if (lang.Count() > 0)
                ViewData["languagexml"] = lang.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllMaritalStatusInXMLResult> mar = sql_conn.usp_getAllMaritalStatusInXML().ToList();
            if (mar.Count() == 0)
                ViewData["maritalsStatusxml"] = "<ChurchLanguage />";
            else if (mar.Count() > 0)
                ViewData["maritalsStatusxml"] = mar.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllOccupationInXMLResult> occ = sql_conn.usp_getAllOccupationInXML().ToList();
            if (occ.Count() == 0)
                ViewData["occupationxml"] = "<ChurchOccupation />";
            else if (occ.Count() > 0)
                ViewData["occupationxml"] = occ.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllParishInXMLResult> par = sql_conn.usp_getAllParishInXML().ToList();
            if (par.Count() == 0)
                ViewData["parishxml"] = "<ChurchParish />";
            else if (occ.Count() > 0)
                ViewData["parishxml"] = par.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllRoleInXMLResult> ro = sql_conn.usp_getAllRoleInXML().ToList();
            if (ro.Count() == 0)
                ViewData["rolexml"] = "<ChurchRole />";
            else if (ro.Count() > 0)
                ViewData["rolexml"] = ro.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllSalutationInXMLResult> sal = sql_conn.usp_getAllSalutationInXML().ToList();
            if (sal.Count() == 0)
                ViewData["salutationxml"] = "<ChurchSalutation />";
            else if (sal.Count() > 0)
                ViewData["salutationxml"] = sal.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllStyleInXMLResult> sty = sql_conn.usp_getAllStyleInXML().ToList();
            if (sty.Count() == 0)
                ViewData["stylexml"] = "<ChurchStyle />";
            else if (sty.Count() > 0)
                ViewData["stylexml"] = sty.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllConfigInXMLResult> config = sql_conn.usp_getAllConfigInXML().ToList();
            if (config.Count() == 0)
                ViewData["configxml"] = "<ChurchConfig />";
            else if (config.Count() > 0)
                ViewData["configxml"] = config.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllEmailInXMLResult> tEmailContent = sql_conn.usp_getAllEmailInXML().ToList();
            XElement EmailContent = new XElement("ChurchEmail");
            if (tEmailContent.Count() == 0)
                ViewData["emailxml"] = "<ChurchEmail />";
            else if (tEmailContent.Count() > 0)
            {
                XElement temp = tEmailContent.ElementAt(0).XML;
                for (int x = 0; x < temp.Elements("Email").Count(); x++)
                {
                    XElement email = new XElement("Email");
                    email.Add(new XElement("EmailID", temp.Elements("Email").ElementAt(x).Element("EmailID").Value));
                    email.Add(new XElement("EmailType", temp.Elements("Email").ElementAt(x).Element("EmailType").Value));
                    email.Add(new XElement("EmailContent", System.Uri.EscapeDataString(temp.Elements("Email").ElementAt(x).Element("EmailContent").Value)));
                    EmailContent.Add(email);
                }

                ViewData["emailxml"] = EmailContent.ToString();
            }

            IEnumerable<usp_getAllPostalAreaInXMLResult> postal = sql_conn.usp_getAllPostalAreaInXML().ToList();
            if (postal.Count() == 0)
                ViewData["postalxml"] = "<ChurchPostal />";
            else if (postal.Count() > 0)
                ViewData["postalxml"] = postal.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllFileTypeInXMLResult> File = sql_conn.usp_getAllFileTypeInXML().ToList();
            if (File.Count() == 0)
                ViewData["filetypexml"] = "<ChurchFileType />";
            else if (File.Count() > 0)
                ViewData["filetypexml"] = File.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllBusGroupClusterInXMLResult> busgroup = sql_conn.usp_getAllBusGroupClusterInXML().ToList();
            if (busgroup.Count() == 0)
                ViewData["busgroupclusterxml"] = "<ChurchBusGroupCluster />";
            else if (busgroup.Count() > 0)
                ViewData["busgroupclusterxml"] = busgroup.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllClubGroupInXMLResult> clubgroup = sql_conn.usp_getAllClubGroupInXML().ToList();
            if (clubgroup.Count() == 0)
                ViewData["clubgroupxml"] = "<ClubGroup />";
            else if (clubgroup.Count() > 0)
                ViewData["clubgroupxml"] = clubgroup.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllRaceInXMLResult> race = sql_conn.usp_getAllRaceInXML().ToList();
            if (race.Count() == 0)
                ViewData["racexml"] = "<Race />";
            else if (race.Count() > 0)
                ViewData["racexml"] = race.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllReligionInXMLResult> reli = sql_conn.usp_getAllReligionInXML().ToList();
            if (reli.Count() == 0)
                ViewData["religionxml"] = "<Religion />";
            else if (reli.Count() > 0)
                ViewData["religionxml"] = reli.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllSchoolInXMLResult> sch = sql_conn.usp_getAllSchoolInXML().ToList();
            if (sch.Count() == 0)
                ViewData["schoolxml"] = "<School />";
            else if (sch.Count() > 0)
                ViewData["schoolxml"] = sch.ElementAt(0).XML.ToString();

            IEnumerable<usp_getAllFamilyTypeInXMLResult> familyty = sql_conn.usp_getAllFamilyTypeInXML().ToList();
            if (familyty.Count() == 0)
                ViewData["familytypexml"] = "<FamilyType />";
            else if (familyty.Count() > 0)
                ViewData["familytypexml"] = familyty.ElementAt(0).XML.ToString();


            IEnumerable<usp_getAllCourseAdditionalInfoInXMLResult> tAdditionalInfoContent = sql_conn.usp_getAllCourseAdditionalInfoInXML().ToList();
            XElement AdditionalInfoContent = new XElement("ChurchAdditionalInfo");
            if (tAdditionalInfoContent.Count() == 0)
                ViewData["additionalinfoxml"] = "<ChurchAdditionalInfo />";
            else if (tAdditionalInfoContent.Count() > 0)
            {
                XElement temp = tAdditionalInfoContent.ElementAt(0).XML;
                for (int x = 0; x < temp.Elements("AdditionalInfo").Count(); x++)
                {
                    XElement additionalInfo = new XElement("AdditionalInfo");
                    additionalInfo.Add(new XElement("AgreementID", temp.Elements("AdditionalInfo").ElementAt(x).Element("AgreementID").Value));
                    additionalInfo.Add(new XElement("AgreementType", temp.Elements("AdditionalInfo").ElementAt(x).Element("AgreementType").Value));
                    additionalInfo.Add(new XElement("AgreementHTML", System.Uri.EscapeDataString(temp.Elements("AdditionalInfo").ElementAt(x).Element("AgreementHTML").Value)));
                    AdditionalInfoContent.Add(additionalInfo);
                }

                ViewData["additionalinfoxml"] = AdditionalInfoContent.ToString();
            }
            return View();
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateChurchArea(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateChurchArea(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllChurchAreaInXMLResult> ca = sql_conn.usp_getAllChurchAreaInXML().ToList();
            if (ca.Count() == 0)
                ViewData["churchareaxml"] = "<ChurchArea />";
            else if (ca.Count() > 0)
                ViewData["churchareaxml"] = ca.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["churchareaxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateCongregation(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateCongregation(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllCongregationInXMLResult> con = sql_conn.usp_getAllCongregationInXML().ToList();
            if (con.Count() == 0)
                ViewData["congregationxml"] = "<ChurchCongregation />";
            else if (con.Count() > 0)
                ViewData["congregationxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["congregationxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateCountry(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateCountry(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllCountryInXMLResult> con = sql_conn.usp_getAllCountryInXML().ToList();
            if (con.Count() == 0)
                ViewData["countryxml"] = "<ChurchCountry />";
            else if (con.Count() > 0)
                ViewData["countryxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["countryxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateDialect(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateDialect(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllDialectInXMLResult> con = sql_conn.usp_getAllDialectInXML().ToList();
            if (con.Count() == 0)
                ViewData["dialectxml"] = "<ChurchDialect />";
            else if (con.Count() > 0)
                ViewData["dialectxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["dialectxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateEducation(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateEducation(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllEducationInXMLResult> con = sql_conn.usp_getAllEducationInXML().ToList();
            if (con.Count() == 0)
                ViewData["educationxml"] = "<ChurchEducation />";
            else if (con.Count() > 0)
                ViewData["educationxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["educationxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateLanguage(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateLanguage(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllLanguageInXMLResult> con = sql_conn.usp_getAllLanguageInXML().ToList();
            if (con.Count() == 0)
                ViewData["languagexml"] = "<ChurchLanguage />";
            else if (con.Count() > 0)
                ViewData["languagexml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["languagexml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateMaritalStatus(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateMaritalStatus(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllMaritalStatusInXMLResult> con = sql_conn.usp_getAllMaritalStatusInXML().ToList();
            if (con.Count() == 0)
                ViewData["maritalsStatusxml"] = "<ChurchMaritalStatus />";
            else if (con.Count() > 0)
                ViewData["maritalsStatusxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["maritalsStatusxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateOccupation(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateOccupation(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllOccupationInXMLResult> con = sql_conn.usp_getAllOccupationInXML().ToList();
            if (con.Count() == 0)
                ViewData["occupationxml"] = "<ChurchOccupation />";
            else if (con.Count() > 0)
                ViewData["occupationxml"] = con.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["occupationxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateParish(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateParish(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllParishInXMLResult> par = sql_conn.usp_getAllParishInXML().ToList();
            if (par.Count() == 0)
                ViewData["parishxml"] = "<ChurchParish />";
            else if (par.Count() > 0)
                ViewData["parishxml"] = par.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["parishxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateSalutation(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateSalutation(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllSalutationInXMLResult> sal = sql_conn.usp_getAllSalutationInXML().ToList();
            if (sal.Count() == 0)
                ViewData["salutationxml"] = "<ChurchSalutation />";
            else if (sal.Count() > 0)
                ViewData["salutationxml"] = sal.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["salutationxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateStyle(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateStyle(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllStyleInXMLResult> sty = sql_conn.usp_getAllStyleInXML().ToList();
            if (sty.Count() == 0)
                ViewData["stylexml"] = "<ChurchStyle />";
            else if (sty.Count() > 0)
                ViewData["stylexml"] = sty.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["stylexml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateConfig(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            XElement input = new XElement("ChurchConfig");

            for (int x = 0; x < xmldoc.Elements("Config").Count(); x++)
            {
                XElement conf = new XElement("Config");
                conf.Add(new XElement("ConfigID", HttpUtility.UrlDecode(xmldoc.Elements("Config").ElementAt(x).Element("ConfigID").Value)));
                conf.Add(new XElement("value", HttpUtility.UrlDecode(xmldoc.Elements("Config").ElementAt(x).Element("value").Value)));
                input.Add(conf);
            }


            string result = sql_conn.usp_UpdateConfig(input).ElementAt(0).Result;

            IEnumerable<usp_getAllConfigInXMLResult> config = sql_conn.usp_getAllConfigInXML().ToList();
            if (config.Count() == 0)
                ViewData["configxml"] = "<ChurchConfig />";
            else if (config.Count() > 0)
                ViewData["configxml"] = config.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["configxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateEmail(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            XElement input = new XElement("ChurchEmail");

            for (int x = 0; x < xmldoc.Elements("Email").Count(); x++)
            {
                XElement conf = new XElement("Email");
                conf.Add(new XElement("EmailID", HttpUtility.UrlDecode(xmldoc.Elements("Email").ElementAt(x).Element("EmailID").Value)));
                conf.Add(new XElement("EmailContent", HttpUtility.UrlDecode(xmldoc.Elements("Email").ElementAt(x).Element("EmailContent").Value)));
                input.Add(conf);
            }


            string result = sql_conn.usp_UpdateEmail(input).ElementAt(0).Result;

            IEnumerable<usp_getAllEmailInXMLResult> email = sql_conn.usp_getAllEmailInXML().ToList();
            if (email.Count() == 0)
                ViewData["emailxml"] = "<ChurchEmail />";
            else if (email.Count() > 0)
                ViewData["emailxml"] = email.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["emailxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateAdditionalInfo(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            XElement input = new XElement("ChurchAdditionalInfo");

            for (int x = 0; x < xmldoc.Elements("AdditionalInfo").Count(); x++)
            {
                XElement conf = new XElement("AdditionalInfo");
                conf.Add(new XElement("AgreementID", HttpUtility.UrlDecode(xmldoc.Elements("AdditionalInfo").ElementAt(x).Element("AgreementID").Value)));
                conf.Add(new XElement("AgreementType", HttpUtility.UrlDecode(xmldoc.Elements("AdditionalInfo").ElementAt(x).Element("AgreementType").Value)));
                conf.Add(new XElement("AgreementHTML", HttpUtility.UrlDecode(xmldoc.Elements("AdditionalInfo").ElementAt(x).Element("AgreementHTML").Value)));
                input.Add(conf);
            }


            string result = sql_conn.usp_UpdateAdditionalInfo(input).ElementAt(0).Result;

            IEnumerable<usp_getAllCourseAdditionalInfoInXMLResult> additionalinfo = sql_conn.usp_getAllCourseAdditionalInfoInXML().ToList();
            if (additionalinfo.Count() == 0)
                ViewData["additionalinfoxml"] = "<ChurchAdditionalInfo />";
            else if (additionalinfo.Count() > 0)
                ViewData["additionalinfoxml"] = additionalinfo.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["additionalinfoxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updatePostal(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            XElement input = new XElement("ChurchPostal");

            for (int x = 0; x < xmldoc.Elements("Postal").Count(); x++)
            {
                XElement post = new XElement("Postal");
                post.Add(new XElement("PostalID", HttpUtility.UrlDecode(xmldoc.Elements("Postal").ElementAt(x).Element("PostalID").Value)));
                post.Add(new XElement("Postalvalue", HttpUtility.UrlDecode(xmldoc.Elements("Postal").ElementAt(x).Element("Postalvalue").Value)));
                post.Add(new XElement("PostalName", HttpUtility.UrlDecode(xmldoc.Elements("Postal").ElementAt(x).Element("PostalName").Value)));
                input.Add(post);
            }


            string result = sql_conn.usp_UpdatePostal(input).ElementAt(0).Result;

            IEnumerable<usp_getAllPostalAreaInXMLResult> po = sql_conn.usp_getAllPostalAreaInXML().ToList();
            if (po.Count() == 0)
                ViewData["postalxml"] = "<ChurchPostal />";
            else if (po.Count() > 0)
                ViewData["postalxml"] = po.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["postalxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateExternalDB(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            XElement input = new XElement("ChurchExternalDB");

            for (int x = 0; x < xmldoc.Elements("ExternalDB").Count(); x++)
            {
                XElement post = new XElement("ExternalDB");
                post.Add(new XElement("ExternalDBID", HttpUtility.UrlDecode(xmldoc.Elements("ExternalDB").ElementAt(x).Element("ExternalDBID").Value)));
                post.Add(new XElement("ExternalDBIP", HttpUtility.UrlDecode(xmldoc.Elements("ExternalDB").ElementAt(x).Element("ExternalDBIP").Value)));
                post.Add(new XElement("ExternalDBName", HttpUtility.UrlDecode(xmldoc.Elements("ExternalDB").ElementAt(x).Element("ExternalDBName").Value)));
                input.Add(post);
            }


            string result = sql_conn.usp_UpdateExternalDB(input).ElementAt(0).Result;

            IEnumerable<usp_getAllExternalDBInXMLResult> ext = sql_conn.usp_getAllExternalDBInXML().ToList();
            if (ext.Count() == 0)
                ViewData["externaldbxml"] = "<ExternalDB />";
            else if (ext.Count() > 0)
                ViewData["externaldbxml"] = ext.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["externaldbxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateFileType(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateFileType(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllFileTypeInXMLResult> file = sql_conn.usp_getAllFileTypeInXML().ToList();
            if (file.Count() == 0)
                ViewData["filetypexml"] = "<ChurchStyle />";
            else if (file.Count() > 0)
                ViewData["filetypexml"] = file.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["filetypexml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }


        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateBusGroupCluster(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateBusGroupCluster(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllBusGroupClusterInXMLResult> bus = sql_conn.usp_getAllBusGroupClusterInXML().ToList();
            if (bus.Count() == 0)
                ViewData["busgroupclusterxml"] = "<ChurchBusGroupCluster />";
            else if (bus.Count() > 0)
                ViewData["busgroupclusterxml"] = bus.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["busgroupclusterxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateClubGroup(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateClubGroup(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllClubGroupInXMLResult> club = sql_conn.usp_getAllClubGroupInXML().ToList();
            if (club.Count() == 0)
                ViewData["clubgroupxml"] = "<ClubGroup />";
            else if (club.Count() > 0)
                ViewData["clubgroupxml"] = club.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["clubgroupxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateRace(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateRace(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllRaceInXMLResult> race = sql_conn.usp_getAllRaceInXML().ToList();
            if (race.Count() == 0)
                ViewData["racexml"] = "<Race />";
            else if (race.Count() > 0)
                ViewData["racexml"] = race.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["racexml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateReligion(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateReligion(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllReligionInXMLResult> reli = sql_conn.usp_getAllReligionInXML().ToList();
            if (reli.Count() == 0)
                ViewData["religionxml"] = "<Religion />";
            else if (reli.Count() > 0)
                ViewData["religionxml"] = reli.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["religionxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateSchool(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateSchool(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllSchoolInXMLResult> reli = sql_conn.usp_getAllSchoolInXML().ToList();
            if (reli.Count() == 0)
                ViewData["schoolxml"] = "<School />";
            else if (reli.Count() > 0)
                ViewData["schoolxml"] = reli.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["schoolxml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult updateFamilyType(string xml)
        {
            XElement xmldoc = XElement.Parse(HttpUtility.UrlDecode(xml));
            string result = sql_conn.usp_UpdateFamilyType(xmldoc).ElementAt(0).Result;

            IEnumerable<usp_getAllFamilyTypeInXMLResult> fam = sql_conn.usp_getAllFamilyTypeInXML().ToList();
            if (fam.Count() == 0)
                ViewData["familytypexml"] = "<FamilyType />";
            else if (fam.Count() > 0)
                ViewData["familytypexml"] = fam.ElementAt(0).XML.ToString();

            xmldoc = XElement.Parse((string)ViewData["familytypexml"]);
            xmldoc.Add(new XElement("Result", result));

            ViewData["result"] = System.Uri.EscapeDataString(xmldoc.ToString());
            return View("simplehtml");
        }






        /************************************************
         ************************************************
         ************************************************ 
         ************************************************
         ****************** Access Control **************
         ************************************************ 
         ************************************************ 
         ************************************************/


        [ErrorHandler]
        [Authorize]
        public ActionResult accessControl()
        {
            ViewData["listofstaff"] = sql_conn.usp_getAllStaff().ToList();
            ViewData["listofroles"] = sql_conn.usp_listOfRoles().ToList();
            usp_getAllModulesFunctionsResult res = sql_conn.usp_getAllModulesFunctions().ElementAt(0);
            ViewData["AllFunctions"] = res.Functions.ToString();
            ViewData["AllModules"] = res.Modules.ToString();
            return View();
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult AddRemoveRoles(string xml)
        {
            XElement roleXML = XElement.Parse(HttpUtility.UrlDecode(xml));
            ViewData["updateRolesResult"] = sql_conn.usp_UpdateRoles(roleXML).ElementAt(0);
            ViewData["tab"] = "Roles";


            ViewData["listofstaff"] = sql_conn.usp_getAllStaff().ToList();
            ViewData["listofroles"] = sql_conn.usp_listOfRoles().ToList();
            usp_getAllModulesFunctionsResult res = sql_conn.usp_getAllModulesFunctions().ElementAt(0);
            ViewData["AllFunctions"] = res.Functions.ToString();
            ViewData["AllModules"] = res.Modules.ToString();
            return View("accessControl");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult UpdateRolesUserID(string userids, string roleid)
        {
            try
            {
                usp_UpdateRolesUserIDResult res = sql_conn.usp_UpdateRolesUserID(userids, roleid).ElementAt(0);
                XElement AddedUsers = XElement.Parse(res.AddedUsers);
                XElement InvalidUsers = XElement.Parse(res.InvalidUsers);
                XElement UpdatedUsers = XElement.Parse(res.UpdatedUsers);
                string usersadded = "";
                string invalidusers = "";
                string updatedusers = "";
                for (int x = 0; x < AddedUsers.Elements("UserID").Count(); x++)
                {
                    usersadded += AddedUsers.Elements("UserID").ElementAt(x).Value + ", ";
                }
                for (int x = 0; x < InvalidUsers.Elements("UserID").Count(); x++)
                {
                    invalidusers += InvalidUsers.Elements("UserID").ElementAt(x).Value + ", ";
                }
                for (int x = 0; x < UpdatedUsers.Elements("UserID").Count(); x++)
                {
                    updatedusers += UpdatedUsers.Elements("UserID").ElementAt(x).Value + ", ";
                }

                string resultmsg = "";
                if (usersadded.Length != 0)
                    resultmsg += "Users Added: " + usersadded + "<br><br>";

                if (updatedusers.Length != 0)
                    resultmsg += "Users Updated: " + updatedusers + "<br><br>";

                if (invalidusers.Length != 0)
                    resultmsg += "Invalid User: " + invalidusers + "<br><br>";

                resultmsg += "Updated @ " + DateTime.Now.ToString();

                ViewData["result"] = resultmsg;
                return View("simplehtml");
            }
            catch (Exception e)
            {
                ViewData["result"] = "Error Enountered!<br><br>Read log file for detail";
                return View("simplehtml");
            }
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult getAssignedModuleFunction(string roleid)
        {
            ViewData["result"] = sql_conn.usp_getAssignedModulesFunctions(int.Parse(roleid)).ElementAt(0).XML;
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult getUserInRole(string roleid)
        {
            ViewData["result"] = sql_conn.usp_getUsersInRole(int.Parse(roleid)).ElementAt(0).Display;
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult updateAssignedModuleFunction(string xml, string roleid)
        {
            XElement modulefunctionXML = XElement.Parse(HttpUtility.UrlDecode(xml));

            ViewData["result"] = sql_conn.usp_UpdateAssignedModulesFunctions(modulefunctionXML, User.Identity.Name).ElementAt(0).Result + " as of " + DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss");
            return View("simplehtml");
        }

        [ErrorHandler]
        [Authorize]
        public FilePathResult samis2backup()
        {

            sql_conn.usp_getDBBackup();
            string filename = (string)Session["DBBackupLocation"];
            return File(filename, "application/octetstream", "SAMIS_" + DateTime.Now.ToString("yyyy-MM-dd") + ".bak");
        }


        public ActionResult displayNewRole(string random)
        {
            ViewData["iframename"] = "iframe" + random;
            ViewData["siteURL"] = "/settings.mvc/DisplayCreateNewRole";
            return View("displayModalClose");
        }

        public ActionResult DisplayCreateNewRole()
        {
            ViewData["rolename"] = "";
            return View();
        }

        public ActionResult renameRole(string random, string rolename)
        {
            ViewData["iframename"] = "iframe" + random;
            ViewData["siteURL"] = "/settings.mvc/DisplayRenameRole?rolename=" + rolename;
            return View("displayModalClose");
        }

        public ActionResult DisplayRenameRole(string rolename)
        {
            ViewData["rolename"] = rolename;
            return View("DisplayCreateNewRole");
        }




        /************************************************
         ************************************************
         ************************************************ 
         ************************************************
         ****************** Remove Files ****************
         ************************************************ 
         ************************************************ 
         ************************************************/

        [ErrorHandler]
        [Authorize]
        public ActionResult removeFiles()
        {
            string[] icphotolocation = Directory.GetFiles((string)Session["icphotolocation"]);
            string[] temp_uploadfilesavedlocation = Directory.GetFiles((string)Session["temp_uploadfilesavedlocation"]);
            string[] CityKidsPhotolocation = Directory.GetFiles((string)Session["CityKidsPhotolocation"]);
            XElement files = new XElement("Files");
            for (int x = 0; x < icphotolocation.Length; x++)
            {
                icphotolocation[x] = icphotolocation[x].Substring(((string)Session["icphotolocation"]).Length);
                XElement file = new XElement("File");
                file.Add(new XElement("Type", "icphotolocation"));
                file.Add(new XElement("Filename", icphotolocation[x]));
                files.Add(file);
            }
            for (int x = 0; x < temp_uploadfilesavedlocation.Length; x++)
            {
                temp_uploadfilesavedlocation[x] = temp_uploadfilesavedlocation[x].Substring(((string)Session["temp_uploadfilesavedlocation"]).Length);
                XElement file = new XElement("File");
                file.Add(new XElement("Type", "temp_uploadfilesavedlocation"));
                file.Add(new XElement("Filename", temp_uploadfilesavedlocation[x].Substring(5)));
                files.Add(file);
            }
            for (int x = 0; x < CityKidsPhotolocation.Length; x++)
            {
                CityKidsPhotolocation[x] = CityKidsPhotolocation[x].Substring(((string)Session["CityKidsPhotolocation"]).Length);
                XElement file = new XElement("File");
                file.Add(new XElement("Type", "CityKidsPhotolocation"));
                file.Add(new XElement("Filename", CityKidsPhotolocation[x]));
                files.Add(file);
            }

            files = sql_conn.usp_checkFileInUsed(files).ElementAt(0).Res;
            for (int x = 0; x < files.Elements("File").Count(); x++)
            {
                string filename = files.Elements("File").ElementAt(x).Element("Filename").Value;
                string type = files.Elements("File").ElementAt(x).Element("Type").Value;
                if (type != "temp_uploadfilesavedlocation")
                    System.IO.File.Move(Session[type].ToString() + filename, Session["PermanentDeletedLocation"].ToString() + filename);
                else
                    System.IO.File.Move(Session[type].ToString() + "temp_" + filename, Session["PermanentDeletedLocation"].ToString() + "temp_" + filename);
            }

            return RedirectToAction("About", "Home", new { Message = "All unused files has been moved to, " + Session["PermanentDeletedLocation"].ToString() });
        }










        /************************************************
         ************************************************
         ************************************************ 
         ************************************************
         *********** View web.Config file ***************
         ************************************************ 
         ************************************************ 
         ************************************************/

        public ActionResult samis2webconfig()
        {
            ViewData["xml"] = System.IO.File.ReadAllText(Request.PhysicalApplicationPath + "/Web.config");

            return View("webconfig");
        }

        public ActionResult samis2sessions()
        {
            return View("viewSessionVariable");
        }
    }
}
