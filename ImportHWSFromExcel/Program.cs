using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.Data;
using System.Xml.Linq;

namespace ImportHWSFromExcel
{
    class Program
    {
        public Program()
        {
            string conStr1 = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + @"C:\Users\sisgks\Desktop\SACHWS.xlsx" + ";Extended Properties=\"Excel 12.0;HDR=YES;\"";
            string sqlst = @"Select [ChineseSurname], [ChineseGivenName], [EnglishSurname], [EnglishGivenName], [DOBDAY], [DOBMONTH], [DOBYEAR], [Contact], [Apt Blk], [Unit], [Street], [Postal], [Next of Kin], [NoK Contact], [Remarks]" +
                    " from [HWS$] ";

            BDConnectionDataContext dbConn = new BDConnectionDataContext();


            DataSet ds = new DataSet();
            using (OleDbConnection connection = new OleDbConnection(conStr1))
            using (OleDbCommand command = new OleDbCommand(sqlst, connection))
            using (OleDbDataAdapter adapter = new OleDbDataAdapter(command))
            {
                adapter.Fill(ds);
            }

            foreach (DataRow Row in ds.Tables[0].Rows)
            {
                string query = "INSERT INTO [dbo].[tb_HokkienMember]([EnglishSurname] ,[EnglishGivenName] ,[ChineseSurname] ,[ChineseGivenName] ,[Birthday] ,[Contact] ,[AddressHouseBlock] ,[AddressStreet] ,[AddressUnit] ,[AddressPostalCode] ,[NextOfKinName] ,[NextOfKinContact] ,[Remarks])" +
                               "SELECT ''";


                string ChineseSurname = Row[0].ToString();
                string ChineseGivenName = Row[1].ToString();
                string EnglishSurname = Row[2].ToString();
                string EnglishGivenName = Row[3].ToString();
                DateTime DOB;
                bool successful = DateTime.TryParse(Row[5].ToString() + "/" + Row[4].ToString() + "/" + Row[6].ToString(), out DOB);
                Console.WriteLine(DOB);
                string Contact = Row[7].ToString();
                string AddressHouseBlock = Row[8].ToString();
                string AddressStreet = Row[10].ToString();
                string AddressUnit = Row[9].ToString();
                string AddressPostalCode = Row[11].ToString();
                string NextOfKinName = Row[12].ToString(); ;
                string NextOfKinContact = Row[13].ToString(); ;
                string Remarks = Row[14].ToString(); ;


                XElement newXML = new XElement("new");
                newXML.Add(new XElement("EnteredBy", "gohks"));
                newXML.Add(new XElement("EnglishSurname", EnglishSurname));
                newXML.Add(new XElement("EnglishGivenName", EnglishGivenName));
                newXML.Add(new XElement("ChineseSurname", ChineseSurname));
                newXML.Add(new XElement("ChineseGivenName", ChineseGivenName));
                if (successful)
                    newXML.Add(new XElement("DOB", DOB.ToString("dd/MM/yyyy")));

                newXML.Add(new XElement("Contact", Contact));
                newXML.Add(new XElement("NOK", NextOfKinName));
                newXML.Add(new XElement("NOKContact", NextOfKinContact));
                newXML.Add(new XElement("candidate_street_address", AddressStreet));
                newXML.Add(new XElement("candidate_postal_code", AddressPostalCode));
                newXML.Add(new XElement("candidate_blk_house", AddressHouseBlock));
                newXML.Add(new XElement("candidate_unit", AddressUnit));
                newXML.Add(new XElement("candidate_photo", ""));
                newXML.Add(new XElement("remarks", Remarks));
                string msg = "";

                if (EnglishSurname.Length == 0 && EnglishGivenName.Length == 0 && ChineseSurname.Length == 0 && ChineseGivenName.Length == 0)
                {

                }
                else
                {
                    dbConn.usp_addNewHWSMember(newXML, ref msg);
                }
                
            }


        }

        static void Main(string[] args)
        {
            new Program();
        }
    }
}
