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

            string baptismContent = @"<html>
    <head>
        <script type=""text/javascript"">
            function checkExtra() {
                var errormsg = """";
                if (document.getElementById(''extra_Age'').value.length <= 0) {
                    errormsg += ""Age is mandatory\n"";
                }
                else if (parseInt(document.getElementById(''extra_Age'').value).toString() == ""NaN"") {
                    errormsg += ""Age is must be numberic\n"";
                }
                if (document.getElementById(''extra_Marital Status'').value.length <= 0) {
                    errormsg += ""Martial Status is mandatory\n"";
                }

                var radios = document.getElementsByName(''extra_Reason'');
                var checked = false;
                for (var i = 0, length = radios.length; i < length; i++) {
                    if (radios[i].checked) {
                        checked = true;
                    }
                }
                if (!checked)
                    errormsg += ""Reason for joining the course is mandatory\n"";

                if (errormsg.length > 0)
                    alert(errormsg);
                else
                    document.getElementById(''form'').submit();
            }      
        </script>
    </head>

    <form method=""post"" id=""form"" action=""./submitExtraCourseQuestion"">
        Age<br />
        <input type=""text"" id=""extra_Age"" name=""extra_Age""/>
        <br />
        <br />
        
        Martial Status <br />
        <select id=""extra_Marital Status"" name=""extra_Marital Status"">
          <option value=""""></option>
          <option value=""Single"">Single</option>
          <option value=""Married"">Married</option>
          <option value=""Divorced"">Divorced</option>
          <option value=""Prefered not to say"">Prefered not to say</option>
        </select>
        <br />
        <br />
        Reason for joining the course<br />
        <table>
          <tr><td style=""border: 1px dotted; border-right:0;""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""I have turned to Christ, knowing that salvation is by Him and through Him alone, and desire to be baptised and later on, be confirmed in the Anglican Communion."" /></td><td style=""border: 1px dotted; border-left:0"">I have turned to Christ, knowing that salvation is by Him and through Him alone, and desire to be baptised and later on, be confirmed in the Anglican Communion.</td></tr>
          <tr><td style=""border: 1px dotted; border-right:0""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""I have turned to Christ, knowing that salvation is by Him and through Him alone. I was baptised as an infant/child. I wish to be confirmed and to join St. Andrew''s Cathedral as a member."" /></td><td style=""border: 1px dotted; border-left:0"">I have turned to Christ, knowing that salvation is by Him and through Him alone. I was baptised as an <b>infant/child</b>. I wish to be confirmed and to join St. Andrew''s Cathedral as a member.</td></tr>
          <tr><td style=""border: 1px dotted; border-right:0""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""Sit-in only (for refresher, accompanying a friend/relative, etc). I am already a confirmed member of St. Andrew''s Cathedral."" /></td><td style=""border: 1px dotted; border-left:0"">Sit-in only (for refresher, accompanying a friend/relative, etc). I am already a confirmed member of St. Andrew''s Cathedral.</td></tr>
        </table>

        <br />

		<b>Registration is to be accompanied with completed forms and a written testimony.</b><br /><br />
		
        <HR /><table border=""0"" cellpadding=""0"" cellspacing=""0"" style=""WIDTH:100%"" width=""100%"">
                  <tbody>
                  <tr>
                    <td style=""PADDING:3.75pt"">
                      <p>
                        <b><span style=""FONT-SIZE:13.5pt"">St Andrew''S Cathedral (Diocese of Singapore) Course Registration</span></b><tt><b><sup></sup></b></tt><b><span style=""FONT-SIZE:13.5pt"">

                        Terms and Conditions </span></b>

                      </p>
                      <p style=""FONT-SIZE:20.5pt; color:Red"">
                        <b>Please Bring along your NRIC for registration.</b>
                      </p>
                      <p>
                        By Clicking on <i>""I Agree""</i>, you agree that all information entered
                        by you are all accurate. I also agree to the use of my personal data for the purpose of notifying me of Christian Education courses conducted by St.Andrew’s Cathedral or for any other purposes relating to Christian Education program in St. Andrew’s Cathedral. 
              
                    </td>
                  </tr>
                  </tbody>
                </table>

        <table style=""width:100%"">
        <tr>
            <td style="" width:50%; text-align:right""><input type=""button"" onclick=""checkExtra();"" style="" width:80px"" value=""I Agree""/></td>
            <td style="" width:50%; text-align:left""><input onclick=""parent.agreeordisagree=''disagree'';parent.domwindow.hide();"" style="" width:80px"" type=""button"" value=""I Disagree""/></td>
        </tr>
        </table>

    </form>
</html>";

            string confirmation = @"<html>
    <head>
        <script type=""text/javascript"">
            function checkExtra() {
                var errormsg = """";
                if (document.getElementById(''extra_Age'').value.length <= 0) {
                    errormsg += ""Age is mandatory\n"";
                }
                else if (parseInt(document.getElementById(''extra_Age'').value).toString() == ""NaN"") {
                    errormsg += ""Age is must be numberic\n"";
                }
                if (document.getElementById(''extra_Marital Status'').value.length <= 0) {
                    errormsg += ""Martial Status is mandatory\n"";
                }

                var radios = document.getElementsByName(''extra_Reason'');
                var checked = false;
                for (var i = 0, length = radios.length; i < length; i++) {
                    if (radios[i].checked) {
                        checked = true;
                    }
                }
                if (!checked)
                    errormsg += ""Reason for joining the course is mandatory\n"";

                if (errormsg.length > 0)
                    alert(errormsg);
                else
                    document.getElementById(''form'').submit();
            }      
        </script>
    </head>

    <form method=""post"" id=""form"" action=""./submitExtraCourseQuestion"">
        Age<br />
        <input type=""text"" id=""extra_Age"" name=""extra_Age""/>
        <br />
        <br />
        
        Martial Status <br />
        <select id=""extra_Marital Status"" name=""extra_Marital Status"">
          <option value=""""></option>
          <option value=""Single"">Single</option>
          <option value=""Married"">Married</option>
          <option value=""Divorced"">Divorced</option>
          <option value=""Prefered not to say"">Prefered not to say</option>
        </select>
        <br />
        <br />
        Reason for joining the course<br />
        <table>
          <tr><td style=""border: 1px dotted; border-right:0;""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""I have turned to Christ, knowing that salvation is by Him and through Him alone. I was baptised as an adult of a non-Anglican/Anglican church. I wish to be confirmed and to join St. Andrew''s Cathedral as a member."" /></td><td style=""border: 1px dotted; border-left:0"">I have turned to Christ, knowing that salvation is by Him and through Him alone. I was baptised as an <b>adult</b> of a non-Anglican/Anglican church. I wish to be confirmed and to join St. Andrew''s Cathedral as a member.</td></tr>
          <tr><td style=""border: 1px dotted; border-right:0""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""I have turned to Christ, knowing that salvation is by Him and through Him alone. I am already a baptised and confirmed member of another Anglican church. I wish to transfer membership to St Andrew''s Cathedral."" /></td><td style=""border: 1px dotted; border-left:0"">I have turned to Christ, knowing that salvation is by Him and through Him alone. I am already a baptised and confirmed member of another Anglican church. I wish to transfer membership to St Andrew''s Cathedral.</td></tr>
          <tr><td style=""border: 1px dotted; border-right:0""><input type=""radio"" id=""extra_Reason"" name=""extra_Reason"" value=""Sit-in only (for refresher, accompanying a friend/relative, etc). I am already a confirmed member of St. Andrew''s Cathedral."" /></td><td style=""border: 1px dotted; border-left:0"">Sit-in only (for refresher, accompanying a friend/relative, etc). I am already a confirmed member of St. Andrew''s Cathedral.</td></tr>
        </table>

        <br />

		<b>Registration is to be accompanied with completed forms and a written testimony.</b><br /><br />
		
        <HR /><table border=""0"" cellpadding=""0"" cellspacing=""0"" style=""WIDTH:100%"" width=""100%"">
                  <tbody>
                  <tr>
                    <td style=""PADDING:3.75pt"">
                      <p>
                        <b><span style=""FONT-SIZE:13.5pt"">St Andrew''S Cathedral (Diocese of Singapore) Course Registration</span></b><tt><b><sup></sup></b></tt><b><span style=""FONT-SIZE:13.5pt"">

                        Terms and Conditions </span></b>

                      </p>
                      <p style=""FONT-SIZE:20.5pt; color:Red"">
                        <b>Please Bring along your NRIC for registration.</b>
                      </p>
                      <p>
                        By Clicking on <i>""I Agree""</i>, you agree that all information entered
                        by you are all accurate. I also agree to the use of my personal data for the purpose of notifying me of Christian Education courses conducted by St.Andrew’s Cathedral or for any other purposes relating to Christian Education program in St. Andrew’s Cathedral. 
              
                    </td>
                  </tr>
                  </tbody>
                </table>

        <table style=""width:100%"">
        <tr>
            <td style="" width:50%; text-align:right""><input type=""button"" onclick=""checkExtra();"" style="" width:80px"" value=""I Agree""/></td>
            <td style="" width:50%; text-align:left""><input onclick=""parent.agreeordisagree=''disagree'';parent.domwindow.hide();"" style="" width:80px"" type=""button"" value=""I Disagree""/></td>
        </tr>
        </table>

    </form>
</html>";


            string marriage = @"<html>
    <head>
        <script type=""text/javascript"">
            function checkExtra() {
                var errormsg = """";
                if (document.getElementById(''extra_Age'').value.length <= 0) {
                    errormsg += ""Age is mandatory\n"";
                }
                else if (parseInt(document.getElementById(''extra_Age'').value).toString() == ""NaN"") {
                    errormsg += ""Age is must be numberic\n"";
                }
                
                if (document.getElementById(''extra_Baptism Date'').value.length <= 0) {
                    errormsg += ""Baptism Date is mandatory\n"";
                }
                if (document.getElementById(''extra_Church'').value.length <= 0) {
                    errormsg += ""Church/Baptism At is mandatory\n"";
                }



                if (document.getElementById(''extra_Spouse Name'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Name is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Congregation'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Congregation is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Church'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Church is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Email'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Email Address is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Contact'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Contact Number is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Age'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Age is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Baptism Date'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Baptism Date is mandatory\n"";
                }
                if (document.getElementById(''extra_Spouse Baptism Church'').value.length <= 0) {
                    errormsg += ""Fiance''s/Fiancee''s Church/Baptism At is mandatory\n"";
                }
                if (document.getElementById(''extra_Marriage Date'').value.length <= 0) {
                    errormsg += ""Planned Marriage Date  is mandatory\n"";
                }

                

                if (errormsg.length > 0)
                    alert(errormsg);
                else
                    document.getElementById(''form'').submit();
            }      
        </script>
    </head>

    <form method=""post"" id=""form"" action=""./submitExtraCourseQuestion"">
        
        <label style="" font-weight:bolder"">Your Details</label>
        <HR /> 
        Age<br />
        <input type=""text"" id=""extra_Age"" name=""extra_Age""/>
        <br />
        <br />
        
        Baptism Date <br />
        <input type=""text"" id=""extra_Baptism Date"" name=""extra_Baptism Date""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">YYYY-MM-DD. If you can''t remember the exact date, just specify ""baptised as an adult/infant/child"" or ""NA"" if not applicable.</label>
        <br />
        <br />

        Church/Baptism at <br />
        <input type=""text"" id=""extra_Church"" name=""extra_Church""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">Include country if baptised outside of Singapore. ""NA"" if not applicable.</label>
        <br />
        <br />
        <br />
       
        <label style="" font-weight:bolder""> Your Fiance''s/Fiancee''s Details</label>
        <HR /> 
        Partner''s Full Name <br />
        <input type=""text"" id=""extra_Partner Name"" name=""extra_Partner Name""/><br />
        <br />
        <br />

		Partner''s NRIC <br />
        <input type=""text"" id=""extra_Partner NRIC"" name=""extra_Partner NRIC""/><br />
        <br />
        <br />
		
        Partner''s Cathedral Congregation<br />
        <select name=""extra_Partner Congregation"" id=""extra_Partner Congregation"">
            <option value=""7AM"">7AM</option>
            <option value=""8AM"">8AM</option>
            <option value=""9AM"">9AM</option>
            <option value=""11.15AM"">11.15AM</option>
            <option value=""5PM"">5PM</option>
            <option value=""Global Crossroads"">Global Crossroads</option>
            <option value=""New Life Service"">New Life Service</option>
            <option value=""Weekday Services"">Weekday Services</option>
            <option value=""ACTS Centre"">ACTS Centre</option>
            <option value=""Westside Anglican"">Westside Anglican</option>
            <option value=""Filipino Fellowship"">Filipino Fellowship</option>
            <option value=""J-Gospel Hour"">J-Gospel Hour</option>
            <option value=""Bahasa Indonesia Fellowship"">Bahasa Indonesia Fellowship</option>
            <option value=""Little Myanmar Fellowship"">Little Myanmar Fellowship</option>
            <option value=""YA"">YA</option> <option value=""LYnC"">LYnC</option>
            <option value=""CITYKids"">CITYKids</option>
            <option value=""Other Church (SG)"">Other Church (SG)</option>
            <option value=""Other Church (Overseas)"">Other Church (Overseas)</option>
        </select><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">If he/she is not from St. Andrew''s Cathedral, please choose ""Other Church (SG/Overseas)"" OR ""None""</label>
        <br />
        <br />
       
        Partner''s Church <br />
        <input type=""text"" id=""extra_Partner Church"" name=""extra_Partner Church""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">If not applicable, indicate ""NA""</label>
        <br />
        <br />

        Partner''s Email Address <br />
        <input type=""text"" id=""extra_Partner Email"" name=""extra_Partner Email""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">If not applicable, indicate ""NA""</label>
        <br />
        <br />

        Partner''s Contact Number<br />
        <input type=""text"" id=""extra_Partner Contact"" name=""extra_Partner Contact""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">Mobile number is preferred for SMS alerts or indicate ""NA"" if not applicable.</label>
        <br />
        <br />

        Partner''s Age <br />
        <input type=""text"" id=""extra_Partner Age"" name=""extra_Partner Age""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small""></label>
        <br />
        <br />

        Partner''s Baptism Date <br />
        <input type=""text"" id=""extra_Partner Baptism Date"" name=""extra_Partner Baptism Date""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">YYYY-MM-DD. If you can''t remember the exact date, just specify ""baptised as an adult"", ""baptised as an infant/child"". Please specify ""NA"" if not applicable.</label>
        <br />
        <br />

        Partner''s Church/Baptism At <br />
        <input type=""text"" id=""extra_Partner Baptism Church"" name=""extra_Partner Baptism Church""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">Include country if baptised outside of Singapore</label>
        <br />
        <br />

        Planned Marriage Date <br />
        <input type=""text"" id=""extra_Marriage Date"" name=""extra_Marriage Date""/><br />
        <label style="" color:Gray; font-style:italic; font-size: small"">YYYY-MM. ""NA"" if not applicable.</label>
        <br />
        <br />
        <HR /> 

        <table border=""0"" cellpadding=""0"" cellspacing=""0"" style=""WIDTH:100%"" width=""100%"">
                  <tbody>
                  <tr>
                    <td style=""PADDING:3.75pt"">
                      <p>
                        <b><span style=""FONT-SIZE:13.5pt"">St Andrew''S Cathedral (Diocese of Singapore) Course Registration</span></b><tt><b><sup></sup></b></tt><b><span style=""FONT-SIZE:13.5pt"">

                        Terms and Conditions </span></b>

                      </p>
                      <p style=""FONT-SIZE:20.5pt; color:Red"">
                        <b>Please Bring along your NRIC for registration.</b>
                      </p>
                      <p>
                        By Clicking on <i>""I Agree""</i>, you agree that all information entered
                        by you are all accurate. I also agree to the use of my personal data for the purpose of notifying me of Christian Education courses conducted by St.Andrew’s Cathedral or for any other purposes relating to Christian Education program in St. Andrew’s Cathedral.
              
                    </td>
                  </tr>
                  </tbody>
                </table>

        <table style=""width:100%"">
        <tr>
            <td style="" width:50%; text-align:right""><input type=""button"" onclick=""checkExtra();"" style="" width:80px"" value=""I Agree""/></td>
            <td style="" width:50%; text-align:left""><input onclick=""parent.agreeordisagree=''disagree'';parent.domwindow.hide();"" style="" width:80px"" type=""button"" value=""I Disagree""/></td>
        </tr>
        </table>

    </form>
</html>";

            dbconn.ExecuteCommand("UPDATE [dbo].[tb_course_agreement] set AgreementHTML = '" + marriage + "' WHERE AgreementID = 3");

            dbconn.ExecuteCommand("UPDATE [dbo].[tb_course_agreement] set AgreementHTML = '" + baptismContent + "' WHERE AgreementID = 2");

            dbconn.ExecuteCommand("INSERT INTO [dbo].[tb_course_agreement](AgreementType, AgreementHTML) VALUES('Confirmation Question', '" + confirmation + "')");

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
