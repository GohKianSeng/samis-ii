using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using System.IO;
using System.Net;

namespace DOS.Models
{
    
    public class RemoteStorage
    {
        private Account account;
        private Cloudinary cloudinary;
        
        public RemoteStorage(string CloudName, string accessKey, string secretKey)
        {
            account= new Account(CloudName, accessKey, secretKey);
            cloudinary = new Cloudinary(account);
        }

        public bool saveToRemoteStorage(string filename, byte[] data)
        {
            MemoryStream memoryStream = new MemoryStream(data);
            ImageUploadParams uploadParams = new ImageUploadParams()
            {
                File = new FileDescription("streamed", memoryStream),
                PublicId = filename
            };

            ImageUploadResult uploadResult = cloudinary.Upload(uploadParams);
            if(uploadResult.SecureUri != null){
                return true;
            }
            return false;
        }

        public byte[] loadDataFromRemoteStorage(string filename, string guid)
        {
            WebClient client = new WebClient();

            ListResourcesResult res = cloudinary.ListResourcesByPrefix("upload", "temp_" + guid + "_" + filename, null);
            if (res.Resources.Count() == 0){
                res = cloudinary.ListResourcesByPrefix("upload", guid + "_" + filename, null);

                if (res.Resources.Count() == 0)
                    res = cloudinary.ListResourcesByPrefix("upload", filename, null);
            }

            return client.DownloadData(res.Resources[0].SecureUri);
        }

        public void deleteDataFromRemoteStorage(string filename)
        {
            cloudinary.DeleteResources(filename);
        }

        public void renameRemoteStorageFilename(string from, string to)
        {

            WebClient client = new WebClient();
            
            ListResourcesResult result = cloudinary.ListResourcesByPrefix("upload", from, null);
            MemoryStream memoryStream = new MemoryStream(client.DownloadData(result.Resources[0].SecureUri));

            ImageUploadParams uploadParams = new ImageUploadParams()
            {
                File = new FileDescription("streamed", memoryStream),
                PublicId = to
            };

            ImageUploadResult uploadResult = cloudinary.Upload(uploadParams);
            cloudinary.DeleteResources(from);
        }
    }
}