public class GoogleGeoCodeResponse
{

    public string status { get; set; }
    public results[] results { get; set; }

}

public class results
{
    public string BLOCK { get; set; }
    public string ROAD { get; set; }
    public string formatted_address { get; set; }
    public geometry geometry { get; set; }
    public string[] types { get; set; }
    public address_component[] address_components { get; set; }
}

public class geometry
{
    public string location_type { get; set; }
    public location location { get; set; }
}

public class location
{
    public string lat { get; set; }
    public string lng { get; set; }
}

public class address_component
{
    public string long_name { get; set; }
    public string short_name { get; set; }
    public string[] types { get; set; }
}

public class OneMapResponse{
    public GeocodeInfo[] GeocodeInfo { get; set; }
}

public class GeocodeInfo
{
    public string BUILDINGNAME { get; set; }
    public string BLOCK { get; set; }
    public string ROAD { get; set; }
    public string POSTALCODE { get; set; }
    public string XCOORD { get; set; }
    public string YCOORD { get; set; }
}


//{"GeocodeInfo":[{"BUILDINGNAME":"EUNOS DAMAI VILLE","BLOCK":"651","ROAD":"JALAN TENAGA","POSTALCODE":"410651","XCOORD":"36240.26745964","YCOORD":"34932.63508184"}]}
//{
//   "results" : [
//      {
//         "address_components" : [
//            {
//               "long_name" : "652",
//               "short_name" : "652",
//               "types" : [ "street_number" ]
//            },
//            {
//               "long_name" : "Jalan Tenaga",
//               "short_name" : "Jalan Tenaga",
//               "types" : [ "route" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            },
//            {
//               "long_name" : "410652",
//               "short_name" : "410652",
//               "types" : [ "postal_code" ]
//            }
//         ],
//         "formatted_address" : "652 Jalan Tenaga, Singapore 410652",
//         "geometry" : {
//            "location" : {
//               "lat" : 1.33259590,
//               "lng" : 103.9078320
//            },
//            "location_type" : "ROOFTOP",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333944880291502,
//                  "lng" : 103.9091809802915
//               },
//               "southwest" : {
//                  "lat" : 1.331246919708498,
//                  "lng" : 103.9064830197085
//               }
//            }
//         },
//         "types" : [ "street_address" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410670",
//               "short_name" : "410670",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410670",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33320650,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33202730,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.3327510,
//               "lng" : 103.9083820
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333965880291502,
//                  "lng" : 103.9092229802915
//               },
//               "southwest" : {
//                  "lat" : 1.331267919708498,
//                  "lng" : 103.9065250197085
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410654",
//               "short_name" : "410654",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410654",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33321490,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33202730,
//                  "lng" : 103.90569880
//               }
//            },
//            "location" : {
//               "lat" : 1.33299790,
//               "lng" : 103.90689990
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333970080291502,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.331272119708498,
//                  "lng" : 103.90569880
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410653",
//               "short_name" : "410653",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410653",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33437730,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33202730,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.3329790,
//               "lng" : 103.9075060
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.334551280291502,
//                  "lng" : 103.9092229802915
//               },
//               "southwest" : {
//                  "lat" : 1.331853319708498,
//                  "lng" : 103.9065250197085
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410671",
//               "short_name" : "410671",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410671",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33320650,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.33201910,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.3324570,
//               "lng" : 103.9087650
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333961780291502,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.331263819708498,
//                  "lng" : 103.9071490
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410652",
//               "short_name" : "410652",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410652",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33320650,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33202730,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.33259590,
//               "lng" : 103.9078320
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333965880291502,
//                  "lng" : 103.9092229802915
//               },
//               "southwest" : {
//                  "lat" : 1.331267919708498,
//                  "lng" : 103.9065250197085
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410669",
//               "short_name" : "410669",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410669",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33437730,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.33201910,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.3331070,
//               "lng" : 103.9084270
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.334547180291502,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.331849219708498,
//                  "lng" : 103.9071490
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410672",
//               "short_name" : "410672",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410672",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33320650,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.33084830,
//                  "lng" : 103.9071490
//               }
//            },
//            "location" : {
//               "lat" : 1.3321010,
//               "lng" : 103.9086790
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333376380291502,
//                  "lng" : 103.91004880
//               },
//               "southwest" : {
//                  "lat" : 1.330678419708498,
//                  "lng" : 103.9071490
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410650",
//               "short_name" : "410650",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410650",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33320650,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33085640,
//                  "lng" : 103.90569880
//               }
//            },
//            "location" : {
//               "lat" : 1.3319140,
//               "lng" : 103.9075420
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333380430291502,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.330682469708498,
//                  "lng" : 103.90569880
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "410651",
//               "short_name" : "410651",
//               "types" : [ "postal_code" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore 410651",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.33321490,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.33085640,
//                  "lng" : 103.90569880
//               }
//            },
//            "location" : {
//               "lat" : 1.3321890,
//               "lng" : 103.9073420
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.333384630291502,
//                  "lng" : 103.9085990
//               },
//               "southwest" : {
//                  "lat" : 1.330686669708498,
//                  "lng" : 103.90569880
//               }
//            }
//         },
//         "types" : [ "postal_code" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "Bedok",
//               "short_name" : "Bedok",
//               "types" : [ "neighborhood", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Bedok, Singapore",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.34804980,
//                  "lng" : 103.96460090
//               },
//               "southwest" : {
//                  "lat" : 1.30185290,
//                  "lng" : 103.89617780
//               }
//            },
//            "location" : {
//               "lat" : 1.32135870,
//               "lng" : 103.9318010
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.34804980,
//                  "lng" : 103.96460090
//               },
//               "southwest" : {
//                  "lat" : 1.30185290,
//                  "lng" : 103.89617780
//               }
//            }
//         },
//         "types" : [ "neighborhood", "political" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "Singapore",
//               "short_name" : "Singapore",
//               "types" : [ "locality", "political" ]
//            },
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.4706240,
//                  "lng" : 104.04149680
//               },
//               "southwest" : {
//                  "lat" : 1.22055970,
//                  "lng" : 103.60981820
//               }
//            },
//            "location" : {
//               "lat" : 1.28009450,
//               "lng" : 103.85094910
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.4706240,
//                  "lng" : 104.04149680
//               },
//               "southwest" : {
//                  "lat" : 1.22055970,
//                  "lng" : 103.60981820
//               }
//            }
//         },
//         "types" : [ "locality", "political" ]
//      },
//      {
//         "address_components" : [
//            {
//               "long_name" : "Singapore",
//               "short_name" : "SG",
//               "types" : [ "country", "political" ]
//            }
//         ],
//         "formatted_address" : "Singapore",
//         "geometry" : {
//            "bounds" : {
//               "northeast" : {
//                  "lat" : 1.47088090,
//                  "lng" : 104.08568050
//               },
//               "southwest" : {
//                  "lat" : 1.1663980,
//                  "lng" : 103.60562460
//               }
//            },
//            "location" : {
//               "lat" : 1.3520830,
//               "lng" : 103.8198360
//            },
//            "location_type" : "APPROXIMATE",
//            "viewport" : {
//               "northeast" : {
//                  "lat" : 1.47088090,
//                  "lng" : 104.08568050
//               },
//               "southwest" : {
//                  "lat" : 1.1663980,
//                  "lng" : 103.60562460
//               }
//            }
//         },
//         "types" : [ "country", "political" ]
//      }
//   ],
//   "status" : "OK"
//}
