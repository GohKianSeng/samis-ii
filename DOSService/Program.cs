using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace DOSService
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            DOSService monitoring;
            if (args.Length > 0 && args[0] == "-console")
            {
                monitoring = new DOSService(true);
            }
            else
            {

                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
			{ 
				new Service1() 
			};
                ServiceBase.Run(ServicesToRun);
            }
        }
    }
}
