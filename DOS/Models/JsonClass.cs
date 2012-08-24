using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace DOS.Models.JsonClass
{
    public class OneMapToken
    {
        public class SubObject
        {
            public string NewToken { get; set; }
        }

        public OneMapToken() { GetToken = new List<SubObject>(); }
        public List<SubObject> GetToken { get; set; }
    }

    public class PostalCodeToAddress
    {
        public class SubObject
        {
            public string BUILDINGNAME { get; set; }
            public string BLOCK { get; set; }
            public string ROAD { get; set; }
            public string POSTALCODE { get; set; }
            public string XCOORD { get; set; }
            public string YCOORD { get; set; }
            public string ErrorMessage { get; set; }

        }

        public PostalCodeToAddress() { GeocodeInfo = new List<SubObject>(); }
        public List<SubObject> GeocodeInfo { get; set; }
    }
}