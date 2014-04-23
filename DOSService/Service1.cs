using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace DOSService
{
    public partial class Service1 : ServiceBase
    {
        DOSService monitoring;
        public Service1()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            monitoring = new DOSService(false);
        }

        protected override void OnStop()
        {
            monitoring.stopMonitoring();
        }
    }
}
