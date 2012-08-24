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
<link rel=File-List href="Electoralroll_files/filelist.xml">
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:Author>Kian Seng Goh</o:Author>
  <o:Template>Normal</o:Template>
  <o:LastAuthor>Kian Seng Goh</o:LastAuthor>
  <o:Revision>2</o:Revision>
  <o:TotalTime>209</o:TotalTime>
  <o:Created>2012-03-23T08:59:00Z</o:Created>
  <o:LastSaved>2012-03-23T08:59:00Z</o:LastSaved>
  <o:Pages>1</o:Pages>
  <o:Words>257</o:Words>
  <o:Characters>1470</o:Characters>
  <o:Lines>12</o:Lines>
  <o:Paragraphs>3</o:Paragraphs>
  <o:CharactersWithSpaces>1724</o:CharactersWithSpaces>
  <o:Version>14.00</o:Version>
 </o:DocumentProperties>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->
<link rel=dataStoreItem href="Electoralroll_files/item0001.xml"
target="Electoralroll_files/props002.xml">
<link rel=themeData href="Electoralroll_files/themedata.thmx">
<link rel=colorSchemeMapping href="Electoralroll_files/colorschememapping.xml">
<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:SpellingState>Clean</w:SpellingState>
  <w:GrammarState>Clean</w:GrammarState>
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
span.SpellE
	{mso-style-name:"";
	mso-spl-e:yes;}
span.GramE
	{mso-style-name:"";
	mso-gram-e:yes;}
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

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width=616 colspan=5 valign=top style='width:462.1pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:16.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin'>&#26032;&#21152;&#30772;&#25945;&#21306;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:16.0pt;
  mso-ansi-language:EN-US'><br>
  THE DIOCESE OF SINGAPORE<br>
  </span></b><b style='mso-bidi-font-weight:normal'><span lang=ZH-CN
  style='font-size:16.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;
  mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:
  minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin'>&#29287;&#21306;&#36873;&#20030;&#21517;&#20876;&#30003;&#35831;&#20070;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:16.0pt;
  mso-ansi-language:EN-US'><br>
  <u>APPLICATION FOR ENROLMENT ON CHURCH ELECTORAL ROLL</u></span></b><b
  style='mso-bidi-font-weight:normal'><u><span lang=EN-US style='font-size:
  14.0pt;mso-ansi-language:EN-US'><br>
  </span></u></b><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:9.0pt;mso-ansi-language:EN-US'>(</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=ZH-CN style='font-size:9.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#26681;&#25454;&#25945;&#21306;&#23466;&#31456;&#31532;&#19977;&#31456;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:9.0pt;
  mso-ansi-language:EN-US'>A</span></b><b style='mso-bidi-font-weight:normal'><span
  lang=ZH-CN style='font-size:9.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#39033;</span></b><b
  style='mso-bidi-font-weight:normal'><span lang=EN-US style='font-size:9.0pt;
  mso-ansi-language:EN-US'>)<o:p></o:p></span></b></p>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><b style='mso-bidi-font-weight:normal'><span
  lang=EN-US style='font-size:9.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width=102 style='width:76.3pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><b style='mso-bidi-font-weight:normal'><span lang=EN-US
  style='font-size:9.0pt;mso-ansi-language:EN-US'><br>
  </span></b><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;</span><span
  lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><br>
  </span><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>I
  (full name)</span><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:
  EN-US'><o:p></o:p></span></p>
  </td>
  <td width=265 colspan=2 style='width:7.0cm;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><%= res.EnglishName %><o:p></o:p></span></p>
  </td>
  <td width=94 style='width:70.85pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#23621;&#27665;&#35777;&#21495;&#30721;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><br>
  NRIC No.<o:p></o:p></span></p>
  </td>
  <td width=155 style='width:116.5pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><%= res.NRIC %><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width=140 colspan=2 style='width:104.65pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#20303;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>(</span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#29992;&#33521;&#25991;&#22320;&#22336;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>)<o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Of
  (full postal address)</span><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><o:p></o:p></span></p>
  </td>
  <td width=477 colspan=3 style='width:357.45pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span class=SpellE><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><%= res.Address1 %></span></span><span lang=EN-US style='font-size:
  12.0pt;mso-ansi-language:EN-US'></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;mso-yfti-lastrow:yes'>
  <td width=140 colspan=2 style='width:104.65pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=477 colspan=3 style='width:357.45pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-top-alt:solid windowtext .5pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:12.0pt;mso-ansi-language:EN-US'><%= res.Address2 %><o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=102 style='border:none'></td>
  <td width=38 style='border:none'></td>
  <td width=227 style='border:none'></td>
  <td width=94 style='border:none'></td>
  <td width=155 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:12.0pt;mso-ansi-language:EN-US'><br>
</span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin;mso-ansi-language:EN-US'>&#20857;&#23459;&#31216;</span><span
lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>:<br>
declare that: -<o:p></o:p></span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>(<span class=SpellE>i</span>)<o:p></o:p></span></p>
  </td>
  <td width=514 colspan=6 valign=top style='width:385.8pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#26159;&#22307;&#20844;&#20250;&#39046;&#22307;&#39184;&#30340;&#20250;&#21451;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>, </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#19981;&#38582;&#23646;&#20110;&#20854;&#20182;&#23447;&#25945;&#22242;&#20307;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  I am a communicant member of the Anglican Church and do not belong to any
  religious body which is not in communion with it.<br style='mso-special-character:
  line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>(ii)<o:p></o:p></span></p>
  </td>
  <td width=514 colspan=6 valign=top style='width:385.8pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#24050;&#24180;&#23626;&#21313;&#19971;&#23681;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  I am not less than 17 years of age.<br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>(iii)<o:p></o:p></span></p>
  </td>
  <td width=142 colspan=2 valign=top style='width:106.3pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#32463;&#24120;&#21442;&#21152;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><br>
  I worship regularly at <o:p></o:p></span></p>
  </td>
  <td width=284 colspan=3 style='width:212.65pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><%= res.ParishName %><o:p></o:p></span></p>
  </td>
  <td width=89 valign=top style='width:66.85pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=right style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:right;line-height:normal'><span lang=ZH-CN style='font-size:10.0pt;
  font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;
  mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#22530;&#30340;&#23815;&#25308;</span><span lang=EN-US
  style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  Church<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=514 colspan=6 valign=top style='width:385.8pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span class=GramE><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>in</span></span><span lang=EN-US style='font-size:
  10.0pt;mso-ansi-language:EN-US'> the Parish in which I am applying for
  registration.<br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>(iv)<o:p></o:p></span></p>
  </td>
  <td width=514 colspan=6 valign=top style='width:385.8pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#26126;&#30637;&#22522;&#30563;&#24466;&#30340;&#29983;&#27963;&#65292;&#21253;&#25324;&#21892;&#29992;&#19978;&#24093;&#25152;&#25176;&#20184;&#30340;&#26102;&#38388;&#65292;&#25165;&#24178;&#21644;&#37329;&#38065;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>. <br>
  </span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#20915;&#23450;&#32463;&#24120;&#20026;&#29287;&#21306;&#30340;&#20107;&#24037;&#22857;&#29486;&#65292;&#24182;&#23613;&#21147;&#20107;&#22857;&#19978;&#24093;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>. <br>
  I understand that the Christian life includes stewardship of time, talent and
  money, and I have decided that I will make regular financial contribution to
  the work of the Church in this Parish and also practice other forms of
  stewardship.<br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5;mso-row-margin-left:36.0pt'>
  <td style='mso-cell-special:placeholder;border:none;padding:0cm 0cm 0cm 0cm'
  width=48><p class='MsoNormal'>&nbsp;</td>
  <td width=54 colspan=2 valign=top style='width:40.3pt;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>(v)<o:p></o:p></span></p>
  </td>
  <td width=514 colspan=6 valign=top style='width:385.8pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25105;&#30340;&#21517;&#23383;&#20856;&#24182;&#19981;&#21015;&#20837;&#26412;&#25945;&#21306;&#20854;&#20182;&#29287;&#21306;&#30340;&#36873;&#20030;&#21517;&#20876;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  So far as I am aware my name is not included in any Electoral Roll in this Diocese.<br
  style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;mso-yfti-lastrow:yes'>
  <td width=64 colspan=2 valign=top style='width:47.95pt;border:none;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26085;&#26399;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>:<o:p></o:p></span></p>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Date:<o:p></o:p></span></p>
  </td>
  <td width=132 colspan=2 style='width:99.2pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:12.0pt;
  mso-ansi-language:EN-US'><%= res.CreatedDate.ToString("dd/MM/yyyy") %><o:p></o:p></span></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border:none;padding:
  0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=104 valign=top style='width:78.0pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#31614;&#21517;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>:<br>
  Signature:<o:p></o:p></span></p>
  </td>
  <td width=165 colspan=2 style='width:123.55pt;border:none;border-bottom:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><i style='mso-bidi-font-style:normal'><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>Computer
  generated<br>
  No signature required<o:p></o:p></span></i></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=48 style='border:none'></td>
  <td width=16 style='border:none'></td>
  <td width=38 style='border:none'></td>
  <td width=94 style='border:none'></td>
  <td width=47 style='border:none'></td>
  <td width=104 style='border:none'></td>
  <td width=104 style='border:none'></td>
  <td width=76 style='border:none'></td>
  <td width=89 style='border:none'></td>
 </tr>
 <![endif]>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:12.0pt;mso-ansi-language:EN-US'><br>
</span><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;mso-hansi-theme-font:
minor-latin;mso-ansi-language:EN-US'>&#38468;&#27880;</span><span lang=EN-US
style='font-size:10.0pt;mso-ansi-language:EN-US'>:<br>
Note:<o:p></o:p></span></p>

<table class=MsoTableGrid border=1 cellspacing=0 cellpadding=0
 style='margin-left:36.0pt;border-collapse:collapse;border:none;mso-border-alt:
 solid windowtext .5pt;mso-yfti-tbllook:1184;mso-padding-alt:0cm 5.4pt 0cm 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width=54 valign=top style='width:40.3pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>1.<o:p></o:p></span></p>
  </td>
  <td width=514 valign=top style='width:385.8pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>“</span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#39046;&#22307;&#39184;&#30340;&#20250;&#21451;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>” </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26159;&#25351;&#22312;&#22307;&#20844;&#20250;&#30340;&#25945;&#20250;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>, </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#25110;&#19982;&#22307;&#20844;&#20250;&#26377;&#32852;&#31995;&#30340;&#25945;&#20250;&#20013;&#39046;&#22307;&#39184;&#32773;</span><span
  class=GramE><span lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>;<span
  style='mso-spacerun:yes'>  </span></span><span lang=ZH-CN style='font-size:
  10.0pt;font-family:SimSun;mso-ascii-font-family:Calibri;mso-ascii-theme-font:
  minor-latin;mso-fareast-font-family:SimSun;mso-fareast-theme-font:minor-fareast;
  mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;mso-ansi-language:
  EN-US'>&#22312;&#31614;&#32626;&#30003;&#35831;&#20070;&#20043;&#21069;&#30340;&#21313;&#20108;&#20010;&#26376;&#20869;</span></span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>, </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#26368;&#23569;&#24050;&#39046;&#36807;&#39184;&#31036;&#19977;&#27425;&#32780;&#35328;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  A “Communicant member” means a person who has received Communion according to
  the use of the Anglican Church or of a Church in Communion with it at least
  three times within the twelve months preceding the signing of the above
  Application<br style='mso-special-character:line-break'>
  <![if !supportLineBreakNewLine]><br style='mso-special-character:line-break'>
  <![endif]><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;mso-yfti-lastrow:yes'>
  <td width=54 valign=top style='width:40.3pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='margin-bottom:0cm;margin-bottom:.0001pt;
  text-align:center;line-height:normal'><span lang=EN-US style='font-size:10.0pt;
  mso-ansi-language:EN-US'>2.<o:p></o:p></span></p>
  </td>
  <td width=514 valign=top style='width:385.8pt;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='margin-bottom:0cm;margin-bottom:.0001pt;line-height:
  normal'><span lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;
  mso-ascii-font-family:Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:
  SimSun;mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#20250;&#21451;&#24212;&#35813;&#22312;&#20182;&#32463;&#24120;&#32858;&#20250;&#30340;&#29287;&#21306;&#22530;&#20250;&#20013;&#30003;&#35831;&#21015;&#20837;&#35813;&#29287;&#21306;&#30340;&#20250;&#21451;&#21517;&#20876;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>, </span><span
  lang=ZH-CN style='font-size:10.0pt;font-family:SimSun;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-fareast-font-family:SimSun;
  mso-fareast-theme-font:minor-fareast;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-ansi-language:EN-US'>&#32780;&#19981;&#26159;&#20182;&#25152;&#23621;&#20303;&#30340;&#29287;&#21306;</span><span
  lang=EN-US style='font-size:10.0pt;mso-ansi-language:EN-US'>.<br>
  If a person worships regularly in a Church of a parish in which he is not
  resident, he is eligible to apply for registration on the Electoral Roll of
  that Church or congregation. In such case he may not also be on the Electoral
  Roll of the parish in which he is resident.<o:p></o:p></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='line-height:normal'><span lang=EN-US
style='font-size:10.0pt;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

</div>

</body>

</html>

