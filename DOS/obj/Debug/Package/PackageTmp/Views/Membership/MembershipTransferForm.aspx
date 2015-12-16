<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>
<%@ Import Namespace="DOS.Models" %>
<%@ Import Namespace="System.Xml.Linq" %>

<%  usp_getMemberInformationPrintingResult res = (usp_getMemberInformationPrintingResult)ViewData["usp_getMemberInformationPrintingResult"];%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Word.Document>
<meta name=Generator content="Microsoft Word 14">
<meta name=Originator content="Microsoft Word 14">
<link rel=File-List href="Membershiptransfer_files/filelist.xml">
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:Author>Kian Seng Goh</o:Author>
  <o:Template>Normal</o:Template>
  <o:LastAuthor>Kian Seng Goh</o:LastAuthor>
  <o:Revision>2</o:Revision>
  <o:TotalTime>80</o:TotalTime>
  <o:Created>2012-03-23T08:57:00Z</o:Created>
  <o:LastSaved>2012-03-23T08:57:00Z</o:LastSaved>
  <o:Pages>1</o:Pages>
  <o:Words>137</o:Words>
  <o:Characters>783</o:Characters>
  <o:Lines>6</o:Lines>
  <o:Paragraphs>1</o:Paragraphs>
  <o:CharactersWithSpaces>919</o:CharactersWithSpaces>
  <o:Version>14.00</o:Version>
 </o:DocumentProperties>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->
<link rel=dataStoreItem href="Membershiptransfer_files/item0001.xml"
target="Membershiptransfer_files/props002.xml">
<link rel=themeData href="Membershiptransfer_files/themedata.thmx">
<link rel=colorSchemeMapping
href="Membershiptransfer_files/colorschememapping.xml">
<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:TrackMoves>false</w:TrackMoves>
  <w:TrackFormatting/>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>EN-SG</w:LidThemeOther>
  <w:LidThemeAsian>ZH-CN</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
   <w:UseFELayout/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val="Cambria Math"/>
   <m:brkBin m:val="before"/>
   <m:brkBinSub m:val="&#45;-"/>
   <m:smallFrac m:val="off"/>
   <m:dispDef/>
   <m:lMargin m:val="0"/>
   <m:rMargin m:val="0"/>
   <m:defJc m:val="centerGroup"/>
   <m:wrapIndent m:val="1440"/>
   <m:intLim m:val="subSup"/>
   <m:naryLim m:val="undOvr"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="true"
  DefSemiHidden="true" DefQFormat="false" DefPriority="99"
  LatentStyleCount="267">
  <w:LsdException Locked="false" Priority="0" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Normal"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="heading 1"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 2"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 3"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 4"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 5"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 6"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 7"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 8"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 9"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 1"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 2"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 3"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 4"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 5"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 6"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 7"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 8"/>
  <w:LsdException Locked="false" Priority="39" Name="toc 9"/>
  <w:LsdException Locked="false" Priority="35" QFormat="true" Name="caption"/>
  <w:LsdException Locked="false" Priority="10" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Title"/>
  <w:LsdException Locked="false" Priority="1" Name="Default Paragraph Font"/>
  <w:LsdException Locked="false" Priority="11" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Subtitle"/>
  <w:LsdException Locked="false" Priority="22" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Strong"/>
  <w:LsdException Locked="false" Priority="20" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Emphasis"/>
  <w:LsdException Locked="false" Priority="59" SemiHidden="false"
   UnhideWhenUsed="false" Name="Table Grid"/>
  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Placeholder Text"/>
  <w:LsdException Locked="false" Priority="1" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="No Spacing"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 1"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 1"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 1"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 1"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 1"/>
  <w:LsdException Locked="false" UnhideWhenUsed="false" Name="Revision"/>
  <w:LsdException Locked="false" Priority="34" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="List Paragraph"/>
  <w:LsdException Locked="false" Priority="29" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Quote"/>
  <w:LsdException Locked="false" Priority="30" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Intense Quote"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 1"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 1"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 1"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 1"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 1"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 1"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 2"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 2"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 2"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 2"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 2"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 2"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 2"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 2"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 3"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 3"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 3"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 3"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 3"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 3"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 3"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 3"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 4"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 4"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 4"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 4"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 4"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 4"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 4"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 4"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 5"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 5"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 5"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 5"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 5"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 5"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 5"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 5"/>
  <w:LsdException Locked="false" Priority="60" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Shading Accent 6"/>
  <w:LsdException Locked="false" Priority="61" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light List Accent 6"/>
  <w:LsdException Locked="false" Priority="62" SemiHidden="false"
   UnhideWhenUsed="false" Name="Light Grid Accent 6"/>
  <w:LsdException Locked="false" Priority="63" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="64" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Shading 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="65" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="66" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium List 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="67" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="68" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="69" SemiHidden="false"
   UnhideWhenUsed="false" Name="Medium Grid 3 Accent 6"/>
  <w:LsdException Locked="false" Priority="70" SemiHidden="false"
   UnhideWhenUsed="false" Name="Dark List Accent 6"/>
  <w:LsdException Locked="false" Priority="71" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Shading Accent 6"/>
  <w:LsdException Locked="false" Priority="72" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful List Accent 6"/>
  <w:LsdException Locked="false" Priority="73" SemiHidden="false"
   UnhideWhenUsed="false" Name="Colorful Grid Accent 6"/>
  <w:LsdException Locked="false" Priority="19" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Subtle Emphasis"/>
  <w:LsdException Locked="false" Priority="21" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Intense Emphasis"/>
  <w:LsdException Locked="false" Priority="31" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Subtle Reference"/>
  <w:LsdException Locked="false" Priority="32" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Intense Reference"/>
  <w:LsdException Locked="false" Priority="33" SemiHidden="false"
   UnhideWhenUsed="false" QFormat="true" Name="Book Title"/>
  <w:LsdException Locked="false" Priority="37" Name="Bibliography"/>
  <w:LsdException Locked="false" Priority="39" QFormat="true" Name="TOC Heading"/>
 </w:LatentStyles>
</xml><![endif]-->
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
	mso-font-signature:3 680460288 22 0 262145 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;
	mso-font-charset:1;
	mso-generic-font-family:roman;
	mso-font-format:other;
	mso-font-pitch:variable;
	mso-font-signature:0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-520092929 1073786111 9 0 415 0;}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 680460288 22 0 262145 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	line-height:115%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:SimSun;
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:SimSun;
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
.MsoPapDefault
	{mso-style-type:export-only;
	margin-bottom:10.0pt;
	line-height:115%;}
@page WordSection1
	{size:595.3pt 841.9pt;
	margin:42.55pt 72.0pt 42.55pt 72.0pt;
	mso-header-margin:35.45pt;
	mso-footer-margin:35.45pt;
	mso-paper-source:0;}
div.WordSection1
	{page:WordSection1;}
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
	mso-style-priority:99;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:10.0pt;
	mso-para-margin-left:0cm;
	line-height:115%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
table.MsoTableGrid
	{mso-style-name:"Table Grid";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-priority:59;
	mso-style-unhide:no;
	border:solid windowtext 1.0pt;
	mso-border-alt:solid windowtext .5pt;
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-border-insideh:.5pt solid windowtext;
	mso-border-insidev:.5pt solid windowtext;
	mso-para-margin:0cm;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
</style>
<![endif]--><!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext="edit" spidmax="1026"/>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext="edit">
  <o:idmap v:ext="edit" data="1"/>
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=EN-SG style='tab-interval:36.0pt'>

<div class=WordSection1>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=659
 style='width:494.45pt;border-collapse:collapse;border:none;mso-border-alt:
 solid windowtext .5pt;mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-row-margin-right:32.35pt'>
  <td width=616 colspan=5 valign=top style='width:462.1pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:16.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin'>&#26032;&#21152;&#30772;&#25945;&#21306;&#30003;&#35831;&#36716;&#20250;&#34920;&#26684;</span></b><b
  style='mso-bidi-font-weight:normal'><span style='font-size:16.0pt'><br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:16.0pt;mso-ansi-language:EN-US'>DIOCESE OF SINGAPORE:
  MEMBERSHIP TRANSFER<o:p></o:p></span></b></p>
  </td>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=43><p class='MsoNormal'>&nbsp;</td>
 </tr>
 <tr style='mso-yfti-irow:1;mso-row-margin-right:32.35pt'>
  <td width=616 colspan=5 valign=top style='width:462.1pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:12.0pt;mso-ansi-language:EN-US'><br style='mso-special-character:
  line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:12.0pt;mso-ansi-language:EN-US'>I<span style='mso-tab-count:
  1'>           </span>TO BE COMPLETED BY THE APPLICANT (in duplicate)<br>
  <span style='mso-tab-count:1'>            </span></span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:12.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#30001;&#30003;&#35831;&#20154;&#22635;&#20889;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'> (</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:12.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#20004;&#20221;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'>)<br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]></span></b><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:16.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td style='mso-cell-special:placeholder;border:none;border-bottom:solid windowtext 1.0pt'
  width=43><p class='MsoNormal'>&nbsp;</td>
 </tr>
 <tr style='mso-yfti-irow:2;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>NAME<o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#33521;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=208 style='width:155.95pt;border:solid windowtext 1.0pt;border-left:
  none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.EnglishName %><o:p></o:p></span></p>
  </td>
  <td width=104 style='width:77.95pt;border:solid windowtext 1.0pt;border-left:
  none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#20013;&#25991;&#22995;&#21517;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=142 colspan=2 style='width:106.3pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'><%= res.ChineseName %></span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>NRIC No.<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#36523;&#20221;&#35777;&#21495;&#30721;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=208 style='width:155.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.NRIC %><o:p></o:p></span></p>
  </td>
  <td width=104 style='width:77.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#24615;&#21035;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Sex<o:p></o:p></span></b></p>
  </td>
  <td width=142 colspan=2 style='width:106.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.Gender %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>ADDRESS<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#22320;&#22336;</span></b><b style='mso-bidi-font-weight:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=454 colspan=4 style='width:12.0cm;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.Address1 %>&nbsp;<%= res.Address2 %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>Home Tel:<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#20303;&#23478;&#30005;&#35805;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=208 style='width:155.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.HomeTel %><o:p></o:p></span></p>
  </td>
  <td width=104 style='width:77.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Office Tel:<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#21150;&#20844;&#23460;&#30005;&#35805;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=142 colspan=2 style='width:106.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.MobileTel %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>CHURCH<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#25152;&#23646;&#22530;&#20250;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=454 colspan=4 style='width:12.0cm;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%
                                                                                if (res.PreviousChurch == "Others")
                                                                                {
                                                                                    %><%=res.PreviousChurchOthers%><%
                                                                                }
                                                                                else
                                                                                {
                                                                                    %><%=res.PreviousChurch%><%
                                                                                }                                        
                                                                            %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>REQUEST FOR </span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:10.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#30003;&#35831;</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>TRANSFER TO </span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:10.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#36716;&#33267;</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=454 colspan=4 style='width:12.0cm;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%= res.ParishName %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>REASONS FOR </span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:10.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#36716;&#20250;</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>TRANSFER<span
  style='mso-spacerun:yes'>       </span></span></b><b style='mso-bidi-font-weight:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#21407;&#22240;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=454 colspan=4 style='width:12.0cm;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%=res.TransferReason %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;mso-yfti-lastrow:yes;mso-row-margin-left:62.1pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=83><p class='MsoNormal'>&nbsp;</td>
  <td width=123 valign=top style='width:92.15pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>SIGNATURE<o:p></o:p></span></b></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#31614;&#21517;</span></b><b style='mso-bidi-font-weight:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=208 style='width:155.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Computer
  generated.<br>
  No Signature is required.<o:p></o:p></span></p>
  </td>
  <td width=104 style='width:77.95pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>DATE<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#26085;&#26399;</span></b><b style='mso-bidi-font-weight:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=142 colspan=2 style='width:106.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><%=DateTime.Now.ToString("dd/MM/yyyy") %><o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=83 style='border:none'></td>
  <td width=123 style='border:none'></td>
  <td width=208 style='border:none'></td>
  <td width=104 style='border:none'></td>
  <td width=99 style='border:none'></td>
  <td width=43 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'>
  <td width=616 valign=top style='width:462.1pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:12.0pt;mso-ansi-language:EN-US'>II<span style='mso-tab-count:
  1'>          </span>FOR PARISH USE (Return one copy to Diocesan office)<br>
  <span style='mso-tab-count:1'>            </span></span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:12.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#20379;&#29287;&#21306;&#22635;&#20889;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'> (</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:12.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#19968;&#20221;&#23492;&#25945;&#21306;&#21150;&#20107;&#22788;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'>)<o:p></o:p></span></b></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
normal'><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></b></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=576
 style='width:432.35pt;margin-left:62.1pt;border-collapse:collapse;border:none;
 mso-border-alt:solid windowtext .5pt;mso-yfti-tbllook:1184;mso-padding-alt:
 0cm 5.4pt 0cm 5.4pt;mso-border-insideh:none;mso-border-insidev:none'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width=482 colspan=4 style='width:361.5pt;border:solid windowtext 1.0pt;
  border-right:none;mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:
  solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>To Vicar/Priest-in-Charge<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#33268;</span></b><b style='mso-bidi-font-weight:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>:<o:p></o:p></span></b></p>
  </td>
  <td width=94 style='width:70.85pt;border:solid windowtext 1.0pt;border-left:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><br>
  </span><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:12.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#29287;&#21306;&#29287;&#24072;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width=576 colspan=5 valign=top style='width:432.35pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>The
  above request for transfer of membership is/is not approved.<br>
  His/her membership registration is/is not forward to you.<o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#19978;&#36848;&#36716;&#20250;&#30003;&#35831;&#24050;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>/</span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#19981;&#34987;&#25509;&#21463;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>. </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#20250;&#21451;&#34920;&#26684;&#38543;&#20990;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>/ </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26410;&#33021;&#38468;&#23492;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  <br>
  Remarks:<o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#22791;&#27880;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>:<br>
  <br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width=340 colspan=2 valign=top style='width:9.0cm;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;
  border-right:none;mso-border-top-alt:solid windowtext .5pt;mso-border-top-alt:
  solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:12.0pt;mso-ansi-language:EN-US'>VICAR/PRIEST-IN-CHARGE</span></b><span
  lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=236 colspan=3 style='width:177.2pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-top-alt:solid windowtext .5pt;
  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:12.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#29287;&#27491;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'> / </span></b><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:12.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#29287;&#24072;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;mso-yfti-lastrow:yes;height:37.0pt'>
  <td width=95 style='width:70.9pt;border:solid windowtext 1.0pt;border-top:
  none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:37.0pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>SIGNATURE<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#31614;&#21517;</span></b><b style='mso-bidi-font-weight:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=246 style='width:184.25pt;border-top:none;border-left:none;
  border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;height:37.0pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></b></p>
  </td>
  <td width=57 style='width:42.55pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt;
  height:37.0pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>Date<br>
  </span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26085;&#26399;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=180 colspan=2 style='width:134.65pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt;height:37.0pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=95 style='border:none'></td>
  <td width=246 style='border:none'></td>
  <td width=57 style='border:none'></td>
  <td width=85 style='border:none'></td>
  <td width=94 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-yfti-lastrow:yes'>
  <td width=616 valign=top style='width:462.1pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:12.0pt;mso-ansi-language:EN-US'>III<span style='mso-tab-count:
  1'>         </span>FOR DIOCESAN USE<br>
  <span style='mso-tab-count:1'>            </span></span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:12.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#20379;&#29287;&#21306;&#22635;&#20889;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
normal'><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></b></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0 width=576
 style='width:432.35pt;margin-left:62.1pt;border-collapse:collapse;border:none;
 mso-border-alt:solid windowtext .5pt;mso-yfti-tbllook:1184;mso-padding-alt:
 0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width=170 valign=top style='width:127.55pt;border:solid windowtext 1.0pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>RECORD AMENDED BY<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#35760;&#24405;&#32773;</span></b><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=199 valign=top style='width:148.9pt;border:solid windowtext 1.0pt;
  border-left:none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=57 style='width:42.5pt;border:solid windowtext 1.0pt;border-left:
  none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>Date<br>
  </span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26085;&#26399;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=151 style='width:4.0cm;border:solid windowtext 1.0pt;border-left:
  none;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'>
  <td width=170 valign=top style='width:127.55pt;border:solid windowtext 1.0pt;
  border-top:none;mso-border-top-alt:solid windowtext .5pt;mso-border-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>NOTED BY BISHOP<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
  mso-ansi-language:EN-US'>&#20250;&#30563;&#22791;&#27880;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></b></p>
  </td>
  <td width=199 valign=top style='width:148.9pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;
  mso-border-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=57 style='width:42.5pt;border-top:none;border-left:none;border-bottom:
  solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;mso-border-top-alt:
  solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>Date<br>
  </span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26085;&#26399;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=151 style='width:4.0cm;border-top:none;border-left:none;border-bottom:
  solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;mso-border-top-alt:
  solid windowtext .5pt;mso-border-left-alt:solid windowtext .5pt;mso-border-alt:
  solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:12.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

</div>

</body>

</html>
