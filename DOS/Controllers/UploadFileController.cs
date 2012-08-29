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
using System.IO;

namespace DOS.Controllers
{

    [HandleError]
    public class UploadFileController : MasterPageController
    {

        [ErrorHandler]
        public ActionResult SaveFile(string guid)
        {
            string saveas = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + guid + "_" + getFilename();
            
            if (Request.Params["qqfile"] != null)
            {
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    Session["FileIOStream"] = CopyStreamToBytes(Request.InputStream);
                    Session["FileName"] = getFilename();
                    ViewData["result"] = "1";
                }
                else{
                    Stream file = System.IO.File.OpenWrite(saveas);
                    CopyStreamToFile(Request.InputStream, file);
                    ViewData["result"] = "1";
                }
            }
            else if (Request.Files.Count > 0)
            {
                var receivedfile = Request.Files[0];
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    Session["FileIOStream"] = CopyStreamToBytes(receivedfile.InputStream);
                    Session["FileName"] = getFilename();
                    ViewData["result"] = "1";
                }
                else
                {
                    receivedfile.SaveAs(saveas);
                    ViewData["result"] = "1";
                }
            }

            return View("simplehtml");
        }

        public string getFilename()
        {
            if (Request.Params["qqfile"] != null)
                return Request.Params["qqfile"];
            else if (Request.Files.Count > 0)
            {
                string[] name = Request.Files[0].FileName.Split('\\');
                return name[name.Length -1];
            }
            return "";
        }

        public void CopyStreamToFile(Stream input, Stream filename)
        {
            byte[] buffer = new byte[Request.ContentLength];
            int len;
            while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                filename.Write(buffer, 0, len);
            }
            filename.Close();
            input.Close();
        }

        public byte[] CopyStreamToBytes(Stream input)
        {
            byte[] buffer = new byte[Request.ContentLength];
            int len;
            while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                
            }
            input.Close();
            return buffer;
        }

        [ErrorHandler]
        [Authorize]
        public ActionResult removeAttachment(string id, string guid, string filename)
        {
            try
            {
                guid = HttpUtility.UrlDecode(guid);
                filename = HttpUtility.UrlDecode(filename);
                string path1 = Session["AttachmentLocation"].ToString() + guid + "_" + filename;
                string path2 = Session["DeletedAttachmentLocation"].ToString() + guid + "_" + filename;
                sql_conn.usp_removeAttachment(int.Parse(id), User.Identity.Name);

                System.IO.File.Move(path1, path2);
                ViewData["result"] = "OK";
                return View("simplehtml");
            }
            catch (Exception e)
            {
                ViewData["result"] = e.Message;
                return View("simplehtml");
            }
        }

        [ErrorHandler]
        [Authorize]
        public FilePathResult downloadAttachment(string guid, string filename)
        {
            try
            {
                guid = HttpUtility.UrlDecode(guid);
                filename = HttpUtility.UrlDecode(filename);
                string path1 = Session["AttachmentLocation"].ToString() + guid + "_" + filename;
                string path2 = Session["DeletedAttachmentLocation"].ToString() + guid + "_" + filename;
                if (System.IO.File.Exists(path1))
                    return File(path1, MimeType(filename), filename);
                else if (System.IO.File.Exists(path2))
                    return File(path2, MimeType(filename), filename);
                else
                {
                    return null;
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        [ErrorHandler]
        public FileContentResult downloadCityKidsPhoto(string guid, string filename)
        {
            try
            {
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    return File((byte[])Session["FileIOStream"], MimeType(filename), filename);
                }
                else
                {

                    filename = HttpUtility.UrlDecode(filename);
                    string path1 = "";
                    string path2 = "";
                    if (guid != null)
                    {
                        path1 = Session["CityKidsPhotolocation"].ToString() + guid + "_" + filename;
                        path2 = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + guid + "_" + filename;
                    }
                    else
                    {
                        path1 = Session["CityKidsPhotolocation"].ToString() + filename;
                        path2 = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + filename;
                    }
                    if (System.IO.File.Exists(path1))
                        return File(ReadFile(path1), MimeType(filename), filename);
                    else if (System.IO.File.Exists(path2))
                        return File(ReadFile(path2), MimeType(filename), filename);
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        [ErrorHandler]        
        public FileContentResult downloadPhoto(string guid, string filename)
        {
            try
            {
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    return File((byte[])Session["FileIOStream"], MimeType(filename), filename);
                }
                else
                {

                    filename = HttpUtility.UrlDecode(filename);
                    string path1 = Session["icphotolocation"].ToString() + guid + "_" + filename;
                    string path2 = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" + guid + "_" + filename;
                    if (System.IO.File.Exists(path1))
                        return File(ReadFile(path1), MimeType(filename), filename);
                    else if (System.IO.File.Exists(path2))
                        return File(ReadFile(path2), MimeType(filename), filename);
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        [ErrorHandler]
        public FileContentResult downloadPhotoWithoutGUID(string filename)
        {
            try
            {
                if (((string)Session["SystemMode"]).ToUpper() != "FULL")
                {
                    return File((byte[])Session["FileIOStream"], MimeType(filename), filename);
                }
                else
                {

                    filename = HttpUtility.UrlDecode(filename);
                    string path1 = Session["icphotolocation"].ToString() + filename;
                    string path2 = Session["temp_uploadfilesavedlocation"].ToString() + "temp_" +  filename;
                    if (System.IO.File.Exists(path1))
                        return File(ReadFile(path1), MimeType(filename), filename);
                    else if (System.IO.File.Exists(path2))
                        return File(ReadFile(path2), MimeType(filename), filename);
                    else
                    {
                        return null;
                    }
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        

        public byte[] ReadFile(string filePath)
        {
            byte[] buffer;
            FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            try
            {
                int length = (int)fileStream.Length;  // get file length
                buffer = new byte[length];            // create buffer
                int count;                            // actual number of bytes read
                int sum = 0;                          // total number of bytes read

                // read until Read method returns 0 (end of the stream has been reached)
                while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                    sum += count;  // sum is a buffer offset for next reading
            }
            finally
            {
                fileStream.Close();
            }
            return buffer;
        }

        private string MimeType(string Filename)
        {
            string mime = "application/octetstream";
            string ext = System.IO.Path.GetExtension(Filename).ToLower();
            Microsoft.Win32.RegistryKey rk = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);
            if (rk != null && rk.GetValue("Content Type") != null)
                mime = rk.GetValue("Content Type").ToString();
            return mime;
        } 

    }
}
