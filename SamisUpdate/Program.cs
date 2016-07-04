using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SamisUpdate
{
    class Program
    {
        public Program()
        {
            string connectionString = "Data Source=localhost;Initial Catalog=DOS;Persist Security Info=True;User ID=root;Password=root";

            dbconnectionDataContext dbconn = new dbconnectionDataContext(connectionString);

            string baptismContent = @"";

            string confirmation = @"";


            string marriage = @"";

            dbconn.ExecuteCommand("");

            Console.WriteLine("Update Successfully. James please login and start the sync process.");
            Console.WriteLine("Press ENTER key to exit");
            Console.Read();
        }

        static void Main(string[] args)
        {
            new Program();
        }
    }
}
