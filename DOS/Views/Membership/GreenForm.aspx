<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>

<%  usp_getMemberInformationPrintingResult res = (usp_getMemberInformationPrintingResult)ViewData["usp_getMemberInformationPrintingResult"];%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:st1="urn:schemas-microsoft-com:office:smarttags"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Word.Document>
<meta name=Generator content="Microsoft Word 10">
<meta name=Originator content="Microsoft Word 10">
<link rel=File-List href="DOS_Membership_Registration_files/filelist.xml">
<title>&#22307;&#20844;&#20250;&#26032;&#21152;&#30772;&#25945;&#21306;&#20250;&#21451;&#30331;&#35760;&#34920;</title>
<o:SmartTagType namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="time"/>
<o:SmartTagType namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="country-region"/>
<o:SmartTagType namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="place"/>
<o:SmartTagType namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="date"/>
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:Author>Kian Seng Goh</o:Author>
  <o:Template>Normal</o:Template>
  <o:LastAuthor>-</o:LastAuthor>
  <o:Revision>2</o:Revision>
  <o:TotalTime>27</o:TotalTime>
  <o:LastPrinted>2011-11-23T05:02:00Z</o:LastPrinted>
  <o:Created>2012-01-05T01:20:00Z</o:Created>
  <o:LastSaved>2012-01-05T01:20:00Z</o:LastSaved>
  <o:Pages>1</o:Pages>
  <o:Words>281</o:Words>
  <o:Characters>1605</o:Characters>
  <o:Company>PSPL</o:Company>
  <o:Lines>13</o:Lines>
  <o:Paragraphs>3</o:Paragraphs>
  <o:CharactersWithSpaces>1883</o:CharactersWithSpaces>
  <o:Version>10.2625</o:Version>
 </o:DocumentProperties>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
  <o:PixelsPerInch>72</o:PixelsPerInch>
  <o:TargetScreenSize>1024x768</o:TargetScreenSize>
 </o:OfficeDocumentSettings>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:SpellingState>Clean</w:SpellingState>
  <w:GrammarState>Clean</w:GrammarState>
  <w:PunctuationKerning/>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:UseFELayout/>
  </w:Compatibility>
  <w:DoNotOptimizeForBrowser/>
 </w:WordDocument>
</xml><![endif]--><!--[if !mso]><object
 classid="clsid:38481807-CA0E-42D2-BF39-B33AF135CC4D" id=ieooui></object>
<style>
st1\:*{behavior:url(#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-alt:\5B8B\4F53;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:1627421319 -2147483648 8 0 66047 0;}
@font-face
	{font-family:Calibri;
	mso-font-alt:Arial;
	mso-font-charset:0;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:-520092929 1073786111 9 0 415 0;}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 135135232 16 0 262145 0;}
@font-face
	{font-family:\5B8B\4F53;
	mso-font-alt:SimSun;
	mso-font-charset:80;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:1 135135232 16 0 262144 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin-top:0in;
	margin-right:0in;
	margin-bottom:10.0pt;
	margin-left:0in;
	line-height:115%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:Calibri;
	mso-fareast-font-family:\5B8B\4F53;
	mso-bidi-font-family:"Times New Roman";}
h3
	{mso-style-link:" Char";
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	mso-pagination:widow-orphan;
	mso-outline-level:3;
	font-size:13.5pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
span.Char
	{mso-style-name:" Char";
	mso-style-parent:"";
	mso-style-link:"Heading 3";
	mso-ansi-font-size:13.5pt;
	mso-bidi-font-size:13.5pt;
	font-family:"Times New Roman";
	mso-ascii-font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";
	mso-hansi-font-family:"Times New Roman";
	mso-bidi-font-family:"Times New Roman";
	font-weight:bold;}
span.shorttext
	{mso-style-name:short_text;}
span.SpellE
	{mso-style-name:"";
	mso-spl-e:yes;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:.2in .1in .2in .3in;
	mso-header-margin:35.3pt;
	mso-footer-margin:35.3pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Table Normal";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-para-margin:0in;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:Calibri;}
table.MsoTableGrid
	{mso-style-name:"Table Grid";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	border:solid windowtext 1.0pt;
	mso-border-alt:solid windowtext .5pt;
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-border-insideh:.5pt solid windowtext;
	mso-border-insidev:.5pt solid windowtext;
	mso-para-margin:0in;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:Calibri;}
</style>
<![endif]--><!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext="edit" spidmax="2050"/>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext="edit">
  <o:idmap v:ext="edit" data="1"/>
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=EN-US style='tab-interval:.5in'>

<div class=Section1>

<table width="800px" class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;mso-table-layout-alt:fixed;mso-yfti-tbllook:
 1184;mso-padding-alt:0in 5.4pt 0in 5.4pt'>
 <tr style='mso-yfti-irow:0;height:.3in'>
  <td nowrap="nowrap" width="100%" colspan=26 style='width:100.0%;padding:0in 5.4pt 0in 5.4pt;
  height:.3in'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:14.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri'>&#22307;&#20844;&#20250;&#26032;&#21152;&#30772;&#25945;&#21306;&#20250;&#21451;&#30331;&#35760;&#34920;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:14.0pt'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  style='font-size:14.0pt'>DIOCESE OF </span></b><st1:country-region><st1:place><b
    style='mso-bidi-font-weight:normal'><span style='font-size:14.0pt'>SINGAPORE</span></b></st1:place></st1:country-region><b
  style='mso-bidi-font-weight:normal'><span style='font-size:14.0pt'>:
  MEMBERSHIP REGISTRATION</span></b><span style='font-size:14.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:.3in'>
  <td nowrap="nowrap" width="9%" colspan=2 valign=top style='width:9.72%;padding:0in 5.4pt 0in 5.4pt;
  height:.3in'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-bidi-font-family:SimSun'>&#29287;&#21306;</span></b><b><span
  style='font-size:10.0pt;font-family:SimSun;mso-bidi-font-family:SimSun;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>Parish of</span><b><span
  style='font-size:10.0pt;font-family:SimSun;mso-bidi-font-family:SimSun'><o:p></o:p></span></b></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=10 style='width:36.84%;border:none;border-bottom:
  solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:.3in'>
  <p class=MsoNormal style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.ParishName %><o:p></o:p></span></b></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=6 valign=top style='width:14.12%;padding:0in 5.4pt 0in 5.4pt;
  height:.3in'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;mso-outline-level:3'><b><span lang=ZH-CN style='font-size:10.0pt;
  font-family:SimSun;mso-bidi-font-family:SimSun;mso-ansi-language:EN-US'>&#22530;&#20250;</span></b><b><span
  style='font-size:10.0pt;font-family:"Times New Roman";mso-fareast-font-family:
  "Times New Roman";mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal;mso-outline-level:3'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'>Congregation</span><b><span style='font-size:10.0pt;font-family:SimSun;
  mso-bidi-font-family:SimSun;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td nowrap="nowrap" width="39%" colspan=8 style='width:39.32%;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:.3in'>
  <p class=MsoNormal style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><st1:time Hour="11" Minute="15"><b style='mso-bidi-font-weight:normal'><span
   style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.CongregationName %></span></b></st1:time><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;height:3.5pt'>
  <td nowrap="nowrap" width="100%" colspan=26 valign=top style='width:100.0%;border:none;
  border-bottom:solid windowtext 2.25pt;padding:0in 5.4pt 0in 5.4pt;height:
  3.5pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:1.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext 2.25pt;
  mso-border-top-alt:2.25pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:.75pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#33521;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Name in English<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 style='width:36.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.EnglishName %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20013;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='text-align:center;margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>Name in Chinese<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-top-alt:2.25pt;mso-border-left-alt:.75pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=ZH-CN style='font-size:9.0pt;
  font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;mso-ansi-language:EN-US'><%= res.ChineseName %></span><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20986;&#29983;&#26085;&#26399;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Date of birth<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 style='width:36.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="4" Day="21" Year="1981"><span
   style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.DOB.ToString("dd/MM/yyyy") %></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#24615;&#21035;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Sex<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.Gender %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#36523;&#20221;&#35777;&#21495;&#30721;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>NRIC No.<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 style='width:36.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.NRIC %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#24050;&#23130;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'>/</span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#26410;&#23130;</span></b><b style='mso-bidi-font-weight:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Marital Status<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.MaritalStatus %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#22269;&#31821;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Nationality<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 style='width:36.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.Nationality %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#31821;&#36143;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Dialect<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span class=SpellE><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.Dialect %></span></span><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:23.25pt'>
  <td nowrap="nowrap" width="19%" colspan=6 rowspan=2 style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:23.25pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#22320;&#22336;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Address<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 rowspan=2 style='width:36.44%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  23.25pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.Address1 %><o:p></o:p></span></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.Address2 %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  23.25pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20303;&#23478;&#30005;&#35805;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Home Tel:<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:23.25pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.HomeTel %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:25.15pt'>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  25.15pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#21150;&#20844;&#23460;&#30005;&#35805;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Office Tel:<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:25.15pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.MobileTel %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25945;&#32946;&#28304;&#27969;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Language(s)<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=9 style='width:36.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.Languages %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="16%" colspan=7 valign=top style='width:16.32%;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#32844;&#19994;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Occupation<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="27%" colspan=4 style='width:27.44%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.OccupationName %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td nowrap="nowrap" width="19%" colspan=6 valign=top style='width:19.8%;border-top:none;
  border-left:solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;
  border-right:solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25945;&#32946;&#31243;&#24230;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Education<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="80%" colspan=20 style='width:80.2%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.Education %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11'>
  <td nowrap="nowrap" width="19%" colspan=6 style='width:19.8%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#22307;&#27927;&#31036;&#26085;&#26399;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Date of Baptism<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=2 style='width:14.7%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'>
    <%if (res.BaptismDate != null)
      {
            %><%= ((DateTime)res.BaptismDate).ToString("dd/MM/yyyy") %><%
      }
    %>    
  </span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.18%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20027;&#31036;&#32773;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>By Whom<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="20%" colspan=9 style='width:20.78%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:8.0pt;
  mso-ansi-language:EN-US'><%= res.BaptismBy %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="7%" colspan=3 style='width:7.98%;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25945;&#20250;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Church<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="25%" colspan=3 style='width:25.56%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:8.0pt;
  mso-ansi-language:EN-US'><%= res.BaptismChurch %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12'>
  <td nowrap="nowrap" width="19%" colspan=6 style='width:19.8%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#22362;&#25391;&#31036;&#26085;&#26399;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Date of <span class=SpellE>Comfirmation</span><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=2 style='width:14.7%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>
  <%if (res.ConfirmDate != null)
    {
        %><%= ((DateTime)res.ConfirmDate).ToString("dd/MM/yyyy")%><%    
    }
  %>  
  <o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.18%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20027;&#31036;&#32773;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>By Whom<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="20%" colspan=9 style='width:20.78%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:8.0pt;
  mso-ansi-language:EN-US'><%= res.ConfirmBy %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="7%" colspan=3 style='width:7.98%;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25945;&#20250;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Church<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="25%" colspan=3 style='width:25.56%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:8.0pt;
  mso-ansi-language:EN-US'><%= res.ConfirmChurch %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13'>
  <td nowrap="nowrap" width="26%" colspan=7 style='width:26.1%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 2.25pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-top-alt:
  .75pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:2.25pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25656;&#23646;&#20309;&#25945;&#20250;&#20043;&#20250;&#21451;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Previous <span class=SpellE>Chruch</span> Membership<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="73%" colspan=19 style='width:73.9%;border-top:none;border-left:
  none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;text-align:
  justify;text-justify:inter-ideograph;line-height:normal'><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.PreviousChurch %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14'>
  <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext 2.25pt;mso-border-top-alt:
  2.25pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:.75pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#23478;&#23646;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>FAMILY<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#33521;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Name in English<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20013;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Name in Chinese<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#32844;&#19994;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Occupation<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="35%" colspan=7 style='width:35.14%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-top-alt:2.25pt;mso-border-left-alt:.75pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25152;&#23646;&#25945;&#20250;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'>/</span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri'>&#23447;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
  font-family:SimSun;mso-bidi-font-family:SimSun'>&#25945;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Church/Religion<o:p></o:p></span></p>
  </td>
 </tr>
 <% 
     XElement family = res.Family;
     for (int x = 1; x < family.Elements("Family").Count(); x++)
     {
        %>
              <tr style='mso-yfti-irow:16'>
              <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
              solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
              solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
              solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
              padding:0in 5.4pt 0in 5.4pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
              lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
              Calibri;mso-ansi-language:EN-US'>&#27597;&#20146;</span></b><span
              style='font-size:9.0pt;mso-ansi-language:EN-US'><br>
              <%= family.Elements("Family").ElementAt(x).Element("FamilyType").Value%><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:9.0pt;
              mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(x).Element("FamilyEnglishName").Value%><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span lang=ZH-CN style='font-size:9.0pt;
              font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(x).Element("FamilyChineseName").Value%></span><span
              style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:9.0pt;
              mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(x).Element("FamilyOccupation").Value%><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="35%" colspan=7 style='width:35.14%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
              padding:0in 5.4pt 0in 5.4pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:9.0pt;
              mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(x).Element("FamilyReligion").Value%><o:p></o:p></span></p>
              </td>
             </tr>
        <%
     }

            if (family.Elements("Family").Count() > 0)
            {
                %>
                      <tr style='mso-yfti-irow:17'>
                      <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
                      solid windowtext 2.25pt;border-bottom:solid windowtext 2.25pt;border-right:
                      solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-top-alt:
                      .75pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:2.25pt;mso-border-right-alt:
                      .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
                      0in 5.4pt 0in 5.4pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span class=shorttext><b
                      style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
                      font-family:\5B8B\4F53;mso-ascii-font-family:Calibri'>&#19976;&#22827;</span></b></span><span
                      class=shorttext><b style='mso-bidi-font-weight:normal'><span
                      style='font-size:9.0pt'>/</span></b></span><span class=shorttext><b
                      style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
                      font-family:\5B8B\4F53;mso-ascii-font-family:Calibri'>&#22971;</span></b></span><span
                      class=shorttext><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
                      style='font-size:9.0pt;font-family:SimSun;mso-bidi-font-family:SimSun'>&#23376;</span></b></span><span
                      class=shorttext><b style='mso-bidi-font-weight:normal'><span
                      style='font-size:9.0pt;font-family:SimSun;mso-bidi-font-family:SimSun;
                      mso-ansi-language:EN-US'><o:p></o:p></span></b></span></p>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span class=shorttext><span
                      style='font-size:9.0pt;mso-fareast-font-family:SimSun;mso-bidi-font-family:
                      Calibri;mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(0).Element("FamilyType").Value%></span></span><span style='font-size:
                      9.0pt;mso-bidi-font-family:Calibri;mso-ansi-language:EN-US'><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;mso-border-bottom-alt:solid windowtext 2.25pt;
                      padding:0in 5.4pt 0in 5.4pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:9.0pt;
                      mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(0).Element("FamilyEnglishName").Value%><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;mso-border-bottom-alt:solid windowtext 2.25pt;
                      padding:0in 5.4pt 0in 5.4pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span lang=ZH-CN style='font-size:9.0pt;
                      font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(0).Element("FamilyChineseName").Value%></span><span
                      style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;mso-border-bottom-alt:solid windowtext 2.25pt;
                      padding:0in 5.4pt 0in 5.4pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:9.0pt;
                      mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(0).Element("FamilyOccupation").Value%><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="35%" colspan=7 style='width:35.14%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 2.25pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      padding:0in 5.4pt 0in 5.4pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:9.0pt;
                      mso-ansi-language:EN-US'><%= family.Elements("Family").ElementAt(0).Element("FamilyReligion").Value%><o:p></o:p></span></p>
                      </td>
                     </tr>
                <%
            }
     
     
 %>   
 
 
 <tr style='mso-yfti-irow:18'>
  <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext 2.25pt;mso-border-top-alt:
  2.25pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:.75pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri'>&#20799;&#22899;</span></b><b style='mso-bidi-font-weight:normal'><span
  style='font-size:9.0pt'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Children<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#33521;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Name in English<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-top-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20013;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Name in Chinese<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-top-alt:2.25pt;mso-border-left-alt:.75pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:.5pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#21463;&#27927;&#26085;&#26399;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Date of Baptism<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="14%" colspan=6 style='width:14.36%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20027;&#31036;&#32773;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>By Whom<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></p>
  </td>
  <td nowrap="nowrap" width="20%" style='width:20.78%;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext 2.25pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-top-alt:2.25pt;mso-border-left-alt:.5pt;mso-border-bottom-alt:
  .75pt;mso-border-right-alt:2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:
  solid;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#25945;&#20250;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Church<o:p></o:p></span></p>
  </td>
 </tr>
 
  <% 
     XElement child = res.Child;
     for (int x = 1; x < child.Elements("Child").Count(); x++)
     {
        %>
              <tr style='mso-yfti-irow:21;height:26.5pt'>
              <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
              solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
              solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
              solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
              padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:9.0pt;
              mso-ansi-language:EN-US'><%= x.ToString() %>.<o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
              26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:9.0pt;
              mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(x).Element("ChildEnglishName").Value%><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
              26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span lang=ZH-CN style='font-size:9.0pt;
              font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(x).Element("ChildChineseName").Value%></span><span
              style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
              mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext .5pt;
              padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><st1:date Month="12" Day="12"
              Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(x).Element("ChildBaptismDate").Value%></span></st1:date><span
              style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="14%" colspan=6 style='width:14.36%;border-top:none;border-left:
              none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
              mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
              mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:8.0pt;
              mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(x).Element("ChildBaptismBy").Value%><o:p></o:p></span></p>
              </td>
              <td nowrap="nowrap" width="20%" style='width:20.78%;border-top:none;border-left:none;
              border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
              mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .5pt;
              mso-border-top-alt:.75pt;mso-border-left-alt:.5pt;mso-border-bottom-alt:.75pt;
              mso-border-right-alt:2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:
              solid;padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
              <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
              text-align:center;line-height:normal'><span style='font-size:8.0pt;
              mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(x).Element("ChildChurch").Value%><o:p></o:p></span></p>
              </td>
             </tr>
        <%
     }

            if (child.Elements("Child").Count() > 0)
            {
                %>
                      <tr style='mso-yfti-irow:22;height:26.5pt'>
                      <td nowrap="nowrap" width="13%" colspan=5 style='width:13.24%;border-top:none;border-left:
                      solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
                      solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
                      solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
                      padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:9.0pt;
                      mso-ansi-language:EN-US'><%=child.Elements("Child").Count().ToString()%>.<o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="22%" colspan=4 style='width:22.86%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
                      26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:9.0pt;
                      mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(0).Element("ChildEnglishName").Value%><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="14%" colspan=5 style='width:14.36%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
                      26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span lang=ZH-CN style='font-size:9.0pt;
                      font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(0).Element("ChildChineseName").Value%></span><span
                      style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="14%" colspan=5 style='width:14.4%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
                      mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext .5pt;
                      padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><st1:date Month="12" Day="12"
                      Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(0).Element("ChildBaptismDate").Value%></span></st1:date><span
                      style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="14%" colspan=6 style='width:14.36%;border-top:none;border-left:
                      none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
                      mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
                      mso-border-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:8.0pt;
                      mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(0).Element("ChildBaptismBy").Value%><o:p></o:p></span></p>
                      </td>
                      <td nowrap="nowrap" width="20%" style='width:20.78%;border-top:none;border-left:none;
                      border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
                      mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .5pt;
                      mso-border-top-alt:.75pt;mso-border-left-alt:.5pt;mso-border-bottom-alt:.75pt;
                      mso-border-right-alt:2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:
                      solid;padding:0in 5.4pt 0in 5.4pt;height:26.5pt'>
                      <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
                      text-align:center;line-height:normal'><span style='font-size:8.0pt;
                      mso-ansi-language:EN-US'><%= child.Elements("Child").ElementAt(0).Element("ChildChurch").Value%><o:p></o:p></span></p>
                      </td>
                     </tr>
                <%
            } 
 %> 
 
 
 <tr style='mso-yfti-irow:23;height:37.35pt'>
  <td nowrap="nowrap" width="13%" colspan=4 style='width:13.18%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 2.25pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-top-alt:
  .75pt;mso-border-left-alt:2.25pt;mso-border-bottom-alt:2.25pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt;height:37.35pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#22791;</span></b><span class=shorttext><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
  font-family:\5B8B\4F53;mso-ascii-font-family:Calibri'>&#27880;</span></b></span><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>Remarks:<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="86%" colspan=22 style='width:86.82%;border-top:none;border-left:
  none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  padding:0in 5.4pt 0in 5.4pt;height:37.35pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.Remarks1%><o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= res.Remarks2 %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:24;height:3.5pt'>
  <td nowrap="nowrap" width="100%" colspan=26 style='width:100.0%;border:none;mso-border-top-alt:
  solid windowtext 2.25pt;padding:0in 5.4pt 0in 5.4pt;height:3.5pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:25;height:27.0pt'>
  <td nowrap="nowrap" width="10%" colspan=3 style='width:10.42%;padding:0in 5.4pt 0in 5.4pt;
  height:27.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#22635;&#34920;&#26085;&#26399;</span><span
  style='mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=right style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span style='mso-ansi-language:EN-US'>Date</span><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="36%" colspan=10 style='width:36.68%;border:none;border-bottom:
  solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0in 5.4pt 0in 5.4pt;height:27.0pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><%= res.CreatedDate.ToString("dd/MM/yyyy") %><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=4 style='width:11.2%;padding:0in 5.4pt 0in 5.4pt;
  height:27.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#31614;&#21517;</span><span style='mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=right style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span style='mso-ansi-language:EN-US'>Signature</span><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="41%" colspan=9 style='width:41.7%;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0in 5.4pt 0in 5.4pt;
  height:27.0pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  style='font-size:8.0pt;mso-ansi-language:EN-US'>Computer generated form. No
  signature is required.<o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:26;height:3.5pt'>
  <td nowrap="nowrap" width="100%" colspan=26 style='width:100.0%;padding:0in 5.4pt 0in 5.4pt;
  height:3.5pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:27;height:3.5pt'>
  <td nowrap="nowrap" width="100%" colspan=26 style='width:100.0%;padding:0in 5.4pt 0in 5.4pt;
  height:3.5pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:12.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#21150;&#20107;&#22788;&#19987;&#26639;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:12.0pt;
  mso-ansi-language:EN-US'> </span></b><b style='mso-bidi-font-weight:normal'><span
  style='font-size:12.0pt;mso-ansi-language:EN-US'>For Official Use<o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:28;height:30.6pt'>
  <td nowrap="nowrap" width="44%" colspan=10 style='width:44.08%;border-top:2.25pt;border-left:
  2.25pt;border-bottom:1.0pt;border-right:1.0pt;border-color:windowtext;
  border-style:solid;mso-border-top-alt:2.25pt;mso-border-left-alt:2.25pt;
  mso-border-bottom-alt:.75pt;mso-border-right-alt:.75pt;mso-border-color-alt:
  windowtext;mso-border-style-alt:solid;padding:0in 5.4pt 0in 5.4pt;height:
  30.6pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#20250;&#21451;&#31867;&#21035;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Category of Membership<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="12%" colspan=6 style='width:12.7%;border-top:solid windowtext 2.25pt;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-alt:solid windowtext .75pt;
  mso-border-top-alt:solid windowtext 2.25pt;padding:0in 5.4pt 0in 5.4pt;
  height:30.6pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#22635;&#20889;&#26085;&#26399;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>Original Date<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=5 style='width:11.2%;border-top:solid windowtext 2.25pt;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-alt:solid windowtext .75pt;
  mso-border-top-alt:solid windowtext 2.25pt;padding:0in 5.4pt 0in 5.4pt;
  height:30.6pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#31532;&#19968;&#27425;&#26356;&#25913;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>1<sup>st</sup> Change<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.12%;border-top:solid windowtext 2.25pt;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-left-alt:solid windowtext .75pt;mso-border-top-alt:2.25pt;
  mso-border-left-alt:.75pt;mso-border-bottom-alt:.75pt;mso-border-right-alt:
  2.25pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt;height:30.6pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:
  Calibri;mso-ansi-language:EN-US'>&#31532;&#20108;&#27425;&#26356;&#25913;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'>2nd Change<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="20%" colspan=2 rowspan=5 style='width:20.9%;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext 2.25pt;mso-border-alt:
  solid windowtext .5pt;mso-border-left-alt:solid windowtext 2.25pt;padding:
  0in 5.4pt 0in 5.4pt;height:30.6pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span style='font-size:9.0pt;
  mso-ansi-language:EN-US'><img id="icphoto" src="/uploadfile.mvc/downloadPhoto?guid=<%= res.GUID %>&filename=<%= res.Filename %>" width="128" height="164" /><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:29;height:23.55pt'>
  <td nowrap="nowrap" width="44%" colspan=10 style='width:44.08%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:23.55pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#23646;&#36873;&#20030;&#21517;&#20876;&#20250;&#21451;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>1. Electoral
  Roll Member<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="12%" colspan=6 style='width:12.7%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  23.55pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'>
  <%if (res.ElectoralRoll != null)
    {
        %><%= ((DateTime)res.ElectoralRoll).ToString("dd/MM/yyyy")%><%
    }
  %>  
  </span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=5 style='width:11.2%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  23.55pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.12%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:23.55pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:30;height:27.15pt'>
  <td nowrap="nowrap" width="44%" colspan=10 style='width:44.08%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:27.15pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#24050;&#21463;&#22307;&#20844;&#20250;&#22362;&#25391;&#31036;&#20294;&#19981;&#23646;&#36873;&#20030;&#21517;&#20876;&#20250;&#21451;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>2. Confirmed in
  Anglican Church But Not On Electoral Roll<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="12%" colspan=6 style='width:12.7%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  27.15pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=5 style='width:11.2%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  27.15pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.12%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:27.15pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:31;height:24.9pt'>
  <td nowrap="nowrap" width="44%" colspan=10 style='width:44.08%;border-top:none;border-left:
  solid windowtext 2.25pt;border-bottom:solid windowtext 1.0pt;border-right:
  solid windowtext 1.0pt;mso-border-top-alt:solid windowtext .75pt;mso-border-alt:
  solid windowtext .75pt;mso-border-left-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:24.9pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#24050;&#21463;&#27927;&#31036;&#20294;&#26410;&#21463;&#22307;&#20844;&#20250;&#22362;&#25391;&#31036;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>3. Baptized But
  Not Confirmed<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="12%" colspan=6 style='width:12.7%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  24.9pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=5 style='width:11.2%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;padding:0in 5.4pt 0in 5.4pt;height:
  24.9pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="11%" colspan=3 style='width:11.12%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  mso-border-alt:solid windowtext .75pt;mso-border-right-alt:solid windowtext 2.25pt;
  padding:0in 5.4pt 0in 5.4pt;height:24.9pt'>
  <p class=MsoNormal align=center style='margin-bottom:0in;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><st1:date Month="12" Day="12"
  Year="2011"><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%></span></st1:date><span
  style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:32;mso-yfti-lastrow:yes;height:30.75pt'>
  <td nowrap="nowrap" width="8%" style='width:8.92%;border-top:none;border-left:solid windowtext 2.25pt;
  border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-top-alt:.75pt;
  mso-border-left-alt:2.25pt;mso-border-bottom-alt:2.25pt;mso-border-right-alt:
  .75pt;mso-border-color-alt:windowtext;mso-border-style-alt:solid;padding:
  0in 5.4pt 0in 5.4pt;height:30.75pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:9.0pt;font-family:\5B8B\4F53;mso-ascii-font-family:Calibri;
  mso-ansi-language:EN-US'>&#22791;</span></b><span class=shorttext><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
  font-family:\5B8B\4F53;mso-ascii-font-family:Calibri'>&#27880;</span></b></span><b
  style='mso-bidi-font-weight:normal'><span style='font-size:9.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'>Remarks:<o:p></o:p></span></p>
  </td>
  <td nowrap="nowrap" width="70%" colspan=23 style='width:70.18%;border-top:none;border-left:
  none;border-bottom:solid windowtext 2.25pt;border-right:solid windowtext 2.25pt;
  mso-border-top-alt:solid windowtext .75pt;mso-border-left-alt:solid windowtext .75pt;
  padding:0in 5.4pt 0in 5.4pt;height:30.75pt'>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["nufll"]%><o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
  normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><%= (string)ViewData["null"]%><o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td nowrap="nowrap" width=68 style='border:none'></td>
  <td nowrap="nowrap" width=6 style='border:none'></td>
  <td nowrap="nowrap" width=5 style='border:none'></td>
  <td nowrap="nowrap" width=21 style='border:none'></td>
  <td nowrap="nowrap" width=0 style='border:none'></td>
  <td nowrap="nowrap" width=49 style='border:none'></td>
  <td nowrap="nowrap" width=47 style='border:none'></td>
  <td nowrap="nowrap" width=63 style='border:none'></td>
  <td nowrap="nowrap" width=12 style='border:none'></td>
  <td nowrap="nowrap" width=60 style='border:none'></td>
  <td nowrap="nowrap" width=12 style='border:none'></td>
  <td nowrap="nowrap" width=7 style='border:none'></td>
  <td nowrap="nowrap" width=4 style='border:none'></td>
  <td nowrap="nowrap" width=25 style='border:none'></td>
  <td nowrap="nowrap" width=43 style='border:none'></td>
  <td nowrap="nowrap" width=4 style='border:none'></td>
  <td nowrap="nowrap" width=11 style='border:none'></td>
  <td nowrap="nowrap" width=18 style='border:none'></td>
  <td nowrap="nowrap" width=31 style='border:none'></td>
  <td nowrap="nowrap" width=12 style='border:none'></td>
  <td nowrap="nowrap" width=11 style='border:none'></td>
  <td nowrap="nowrap" width=34 style='border:none'></td>
  <td nowrap="nowrap" width=14 style='border:none'></td>
  <td nowrap="nowrap" width=35 style='border:none'></td>
  <td nowrap="nowrap" width=1 style='border:none'></td>
  <td nowrap="nowrap" width=156 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height:
normal'><span style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

</div>

</body>

</html>
