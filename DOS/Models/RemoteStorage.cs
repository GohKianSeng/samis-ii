using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Net;
using DropNet;
using DropNet.Models;

namespace DOS.Models
{
    
    public class RemoteStorage
    {
        private DropNetClient _client;

        public RemoteStorage(string apiKey, string appSecret, string userToken, string userSecret)
        {
            _client = new DropNetClient(apiKey, appSecret, userToken, userSecret);
        }

        public bool saveToRemoteStorage(string filename, byte[] data)
        {
            MetaData res = _client.UploadFile("", filename, data);

            if (res.Bytes > 0)
            {
                return true;
            }
            return false;
        }

        public byte[] loadDataFromRemoteStorage(string filename, string guid)
        {
            string finalFilename = "";
            if (guid.Length > 0)
                finalFilename = guid + "_" + filename;
            else
                finalFilename = filename;
            byte[] data = {};


            try
            {
                data = _client.GetFile("temp_" + finalFilename);

            }
            catch (Exception e)
            {
                if (data.Length == 0)
                    data = _client.GetFile(finalFilename);

            }
            return data;
        }

        public void deleteDataFromRemoteStorage(string filename)
        {
            _client.Delete(filename);            
        }

        public void renameRemoteStorageFilename(string from, string to)
        {
            _client.Copy(from, to);
            _client.Delete(from);
        }
    }
}