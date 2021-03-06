USE [DOS]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getAppModFuncPredcessor]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getAppModFuncPredcessor]
(
	-- Add the parameters for the function here
	@text_to_count VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
DECLARE
@delim as VARCHAR(1) = '.',
@pos AS INT = 0,
@contains AS INT = 1, 
@last_count AS INT = 0,
@returnMessage AS VARCHAR(20);
WHILE @pos < LEN(@text_to_count)
BEGIN
  SET @contains = CHARINDEX(@delim, @text_to_count, @pos + 1); 
  
  IF @contains > 0
  BEGIN
	SET @last_count = @contains;
  end
  SET @pos = @pos + 1;
  
END
IF @last_count = 0
Begin
	set @returnMessage = NULL;
END
ELSE
	set @returnMessage =  SUBSTRING (@text_to_count, 1, @last_count-1);

return @returnMessage;

END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getCongregationIDFromModuleFunction]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getCongregationIDFromModuleFunction]
(
	-- Add the parameters for the function here
	@string VARCHAR(100)
)
RETURNS VARCHAR(3)
AS
BEGIN

return SUBSTRING(@string, CHARINDEX(':', @string)+1, CHARINDEX(',', @string) - CHARINDEX(':', @string)-1);

END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getGender]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getGender]
(
	-- Add the parameters for the function here
	@gender VARCHAR(1)
)
RETURNS VARCHAR(6)
AS
BEGIN

IF(@gender = 'M')
BEGIN
	RETURN 'Male'
END
ELSE
BEGIN
	RETURN 'Female'
END

RETURN ''
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_UrlEncode]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[udf_UrlEncode](@url VARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @count INT, @c NCHAR(1), @i INT, @urlReturn VARCHAR(MAX);
    SET @count = LEN(@url);
    SET @i = 1;
    SET @urlReturn = '';    
    WHILE (@i <= @count)
     BEGIN
        SET @c = SUBSTRING(@url, @i, 1)
        IF @c LIKE N'[A-Za-z0-9()''*\-._!~]' COLLATE Latin1_General_BIN ESCAPE N'\' COLLATE Latin1_General_BIN
         BEGIN
            SET @urlReturn = @urlReturn + @c;
         END;
        ELSE
         BEGIN
            SET @urlReturn = 
                   @urlReturn + '%'
                   + SUBSTRING(sys.fn_varbintohexstr(CAST(@c AS VARBINARY(MAX))),3,2)
                   + ISNULL(NULLIF(SUBSTRING(sys.fn_varbintohexstr(CAST(@c AS VARBINARY(MAX))),5,2), '00'), '');
         END;
        SET @i = @i +1;
     END;
    RETURN @urlReturn
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Split](@String varchar(8000), @Delimiter char(1))       
returns @temptable TABLE (items varchar(8000))       
as       
begin       
    declare @idx int;       
    declare @slice varchar(8000);       
      
    select @idx = 1;       
        if len(@String)<1 or @String is null  return;       
      
    while @idx!= 0       
    begin;       
        set @idx = charindex(@Delimiter,@String);       
        if @idx!=0       
            set @slice = left(@String,@idx - 1);       
        else       
            set @slice = @String;       
          
        if(len(@slice)>0)  
            insert into @temptable(Items) values(@slice);       
  
        set @String = right(@String,len(@String) - @idx);       
        if len(@String) = 0 break;       
    end   
return;       
end
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllTextFieldLengthInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllTextFieldLengthInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select column_name AS ColumnName, TABLE_NAME AS TableName, character_maximum_length AS [Length] from information_schema.columns where data_type = 'varchar' OR DATA_TYPE = 'nvarchar' ORDER BY TABLE_NAME, information_schema.columns.column_name FOR XML PATH('Column'), ELEMENTS, ROOT('Table'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  Table [dbo].[tb_course_Attendance]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course_Attendance](
	[NRIC] [varchar](20) NOT NULL,
	[CourseID] [int] NOT NULL,
	[Date] [date] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course](
	[courseID] [int] IDENTITY(20,1) NOT NULL,
	[CourseName] [varchar](100) NOT NULL,
	[CourseStartDate] [varchar](2000) NOT NULL,
	[CourseEndDate] [date] NULL,
	[CourseStartTime] [time](7) NOT NULL,
	[CourseEndTime] [time](7) NOT NULL,
	[CourseInCharge] [varchar](10) NOT NULL,
	[CourseLocation] [tinyint] NOT NULL,
	[CourseDay] [varchar](50) NULL,
	[Deleted] [bit] NOT NULL,
	[Fee] [decimal](5, 2) NOT NULL,
 CONSTRAINT [PK_tb_course] PRIMARY KEY CLUSTERED 
(
	[courseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_country]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_country](
	[CountryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_country] ON
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (1, N'Brunei')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (2, N'Cambodia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (3, N'East Timor')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (4, N'India')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (5, N'Indonesia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (6, N'Laos')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (7, N'Malaysia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (8, N'Myanmar')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (9, N'Philippines')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (10, N'Singapore')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (11, N'Thailand')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (12, N'Vietnam')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (13, N'Afghanistan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (14, N'Albania')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (15, N'Algeria')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (16, N'Andorra')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (17, N'Antigua and Barbuda')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (18, N'Argentina')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (19, N'Armenia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (20, N'Australia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (21, N'Austria')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (22, N'Azerbaijan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (23, N'Bahamas')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (24, N'Bahrain')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (25, N'Bangladesh')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (26, N'Barbados')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (27, N'Belarus')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (28, N'Belgium')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (29, N'Belize')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (30, N'Benin')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (31, N'Bhutan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (32, N'Bolivia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (33, N'Bosnia and Herzegovina')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (34, N'Botswana')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (35, N'Brazil')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (36, N'Bulgaria')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (37, N'Burkina Faso')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (38, N'Burundi')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (39, N'Cameroon')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (40, N'Canada')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (41, N'Cape Verde')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (42, N'Central African Republic')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (43, N'Chad')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (44, N'Chile')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (45, N'China')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (46, N'Colombia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (47, N'Comoros')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (48, N'Congo')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (49, N'Costa Rica')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (50, N'Côte d''Ivoire')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (51, N'Croatia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (52, N'Cuba')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (53, N'Cyprus')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (54, N'Czech Republic')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (55, N'Denmark')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (56, N'Djibouti')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (57, N'Dominica')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (58, N'Dominican Republic')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (59, N'Ecuador')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (60, N'Egypt')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (61, N'El Salvador')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (62, N'Equatorial Guinea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (63, N'Eritrea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (64, N'Estonia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (65, N'Ethiopia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (66, N'Fiji')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (67, N'Finland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (68, N'France')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (69, N'Gabon')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (70, N'Gambia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (71, N'Georgia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (72, N'Germany')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (73, N'Ghana')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (74, N'Greece')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (75, N'Grenada')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (76, N'Guatemala')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (77, N'Guinea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (78, N'Guinea-Bissau')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (79, N'Guyana')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (80, N'Haiti')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (81, N'Honduras')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (82, N'Hong Kong')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (83, N'Hungary')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (84, N'Iceland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (85, N'Iran')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (86, N'Iraq')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (87, N'Ireland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (88, N'Israel')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (89, N'Italy')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (90, N'Jamaica')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (91, N'Japan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (92, N'Jordan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (93, N'Kazakhstan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (94, N'Kenya')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (95, N'Kiribati')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (96, N'North Korea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (97, N'South Korea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (98, N'Kuwait')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (99, N'Kyrgyzstan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (100, N'Latvia')
GO
print 'Processed 100 total records'
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (101, N'Lebanon')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (102, N'Lesotho')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (103, N'Liberia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (104, N'Libya')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (105, N'Liechtenstein')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (106, N'Lithuania')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (107, N'Luxembourg')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (108, N'Macedonia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (109, N'Madagascar')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (110, N'Malawi')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (111, N'Maldives')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (112, N'Mali')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (113, N'Malta')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (114, N'Marshall Islands')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (115, N'Mauritania')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (116, N'Mauritius')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (117, N'Mexico')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (118, N'Micronesia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (119, N'Moldova')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (120, N'Monaco')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (121, N'Mongolia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (122, N'Montenegro')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (123, N'Morocco')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (124, N'Mozambique')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (125, N'Namibia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (126, N'Nauru')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (127, N'Nepal')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (128, N'Netherlands')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (129, N'New Zealand')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (130, N'Nicaragua')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (131, N'Niger')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (132, N'Nigeria')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (133, N'Norway')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (134, N'Oman')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (135, N'Pakistan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (136, N'Palau')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (137, N'Panama')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (138, N'Papua New Guinea')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (139, N'Paraguay')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (140, N'Peru')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (141, N'Poland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (142, N'Portugal')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (143, N'Puerto Rico')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (144, N'Qatar')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (145, N'Romania')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (146, N'Russia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (147, N'Rwanda')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (148, N'Saint Kitts and Nevis')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (149, N'Saint Lucia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (150, N'Saint Vincent and the Grenadines')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (151, N'Samoa')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (152, N'San Marino')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (153, N'Sao Tome and Principe')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (154, N'Saudi Arabia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (155, N'Senegal')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (156, N'Serbia and Montenegro')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (157, N'Seychelles')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (158, N'Sierra Leone')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (159, N'Slovakia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (160, N'Slovenia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (161, N'Solomon Islands')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (162, N'Somalia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (163, N'South Africa')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (164, N'Spain')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (165, N'Sri Lanka')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (166, N'Sudan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (167, N'Suriname')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (168, N'Swaziland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (169, N'Sweden')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (170, N'Switzerland')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (171, N'Syria')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (172, N'Taiwan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (173, N'Tajikistan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (174, N'Tanzania')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (175, N'Togo')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (176, N'Tonga')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (177, N'Trinidad and Tobago')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (178, N'Tunisia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (179, N'Turkey')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (180, N'Turkmenistan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (181, N'Tuvalu')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (182, N'Uganda')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (183, N'Ukraine')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (184, N'United Arab Emirates')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (185, N'United Kingdom')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (186, N'United States')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (187, N'Uruguay')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (188, N'Uzbekistan')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (189, N'Vanuatu')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (190, N'Vatican City')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (191, N'Venezuela')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (192, N'Yemen')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (193, N'Zambia')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (194, N'Zimbabwe')
INSERT [dbo].[tb_country] ([CountryID], [CountryName]) VALUES (196, N'Unspecified')
SET IDENTITY_INSERT [dbo].[tb_country] OFF
/****** Object:  Table [dbo].[tb_congregation]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_congregation](
	[CongregationID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CongregationName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_congregation_1] PRIMARY KEY CLUSTERED 
(
	[CongregationID] ASC,
	[CongregationName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_congregation] ON
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (1, N'7:00am English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (2, N'8:00am English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (3, N'9:00am English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (4, N'10.00am WAC')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (5, N'10.00am Acts Centre')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (6, N'11:15am English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (7, N'1:30pm LYnC English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (8, N'2:00pm Filipino')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (9, N'2:30pm Bahasa Indonesia')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (10, N'5:00pm Mandarin CNS')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (11, N'5:00pm Engish')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (12, N'7:00pm Myanmar')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (13, N'7.00pm Global Crossroads (Sat)')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (14, N'7:30pm English')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (15, N'Others')
INSERT [dbo].[tb_congregation] ([CongregationID], [CongregationName]) VALUES (22, N'5.00pm J-Gospel (Sat)')
SET IDENTITY_INSERT [dbo].[tb_congregation] OFF
/****** Object:  Table [dbo].[tb_clubgroup]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_clubgroup](
	[ClubGroupID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ClubGroupName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_clubgroup] PRIMARY KEY CLUSTERED 
(
	[ClubGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_churchArea]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_churchArea](
	[AreaID] [tinyint] IDENTITY(1,1) NOT NULL,
	[AreaName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_churchArea] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_churchArea] ON
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (1, N'Prayer Hall A')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (2, N'Prayer Hall B')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (3, N'Prayer Hall C')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (4, N'Nave')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (49, N'Cathedral New Sanctuary (CNS)')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (50, N'CNS Basement 1 Lobby')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (51, N'Basement 2 Classroom A')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (52, N'Basement 2 Classroom B')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (53, N'North Transept Hall')
INSERT [dbo].[tb_churchArea] ([AreaID], [AreaName]) VALUES (54, N'South Transept Hall')
SET IDENTITY_INSERT [dbo].[tb_churchArea] OFF
/****** Object:  Table [dbo].[tb_cellgroup]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_cellgroup](
	[CellgroupID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CellgroupName] [varchar](50) NOT NULL,
	[CellgroupLeader] [varchar](20) NOT NULL,
	[PostalCode] [int] NOT NULL,
	[StreetAddress] [varchar](100) NOT NULL,
	[BLKHouse] [varchar](10) NOT NULL,
	[Unit] [varchar](10) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tb_cellgroup] PRIMARY KEY CLUSTERED 
(
	[CellgroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ccc_kids]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_ccc_kids](
	[NRIC] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Gender] [varchar](1) NOT NULL,
	[DOB] [date] NOT NULL,
	[HomeTel] [varchar](15) NOT NULL,
	[MobileTel] [varchar](15) NOT NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](7) NOT NULL,
	[AddressPostalCode] [int] NOT NULL,
	[AddressUnit] [varchar](10) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[SpecialNeeds] [varchar](1000) NOT NULL,
	[EmergencyContact] [varchar](15) NOT NULL,
	[EmergencyContactName] [varchar](50) NOT NULL,
	[Transport] [bit] NOT NULL,
	[Religion] [tinyint] NOT NULL,
	[Race] [tinyint] NOT NULL,
	[Nationality] [tinyint] NOT NULL,
	[School] [tinyint] NOT NULL,
	[ClubGroup] [tinyint] NOT NULL,
	[BusGroupCluster] [tinyint] NOT NULL,
	[Remarks] [varchar](1000) NOT NULL,
	[Points] [int] NOT NULL,
	[Photo] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_tb_ccc_kids] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_busgroup_cluster]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_busgroup_cluster](
	[BusGroupClusterID] [tinyint] IDENTITY(1,1) NOT NULL,
	[BusGroupClusterName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_busgroup_cluster] PRIMARY KEY CLUSTERED 
(
	[BusGroupClusterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_AppModFunc]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_AppModFunc](
	[AppModFuncID] [varchar](20) NOT NULL,
	[AppModFuncName] [varchar](50) NOT NULL,
	[URL] [varchar](200) NOT NULL,
	[Sequence] [int] NULL,
 CONSTRAINT [PK_tb_AppModFunc] PRIMARY KEY CLUSTERED 
(
	[AppModFuncID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1', N'DMS', N'', NULL)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1', N'Membership', N'membership', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.1', N'Add New Member', N'membership.mvc/NewMember', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.2', N'Update Member', N'membership.mvc/UpdateMember', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.3', N'Member Resubmit', N'membership.mvc/NewMemberResubmit', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.4', N'Membership Approval', N'membership.mvc/NewMemberApproval', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.5', N'Course Registration', N'membership.mvc/courseregistration', 5)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.6', N'Course Attendance', N'membership.mvc/courseattendance', 6)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.7', N'Course Registration Walk-In', N'membership.mvc/courseregistration_ad', 7)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.8', N'Update CE Participant', N'membership.mvc/UpdateVisitor', 8)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.1.9', N'Offline Membership', N'membership.mvc/offlineMembership', 9)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.2', N'Account', N'admin', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.2.1', N'Add User- DUN USE', N'Account.mvc/AddUser', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.2.2', N'Remove User- DUN USE', N'Account.mvc/RemoveUser', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.2.3', N'Update Particular', N'Account.mvc/UpdateUser', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.2.4', N'Change Password', N'Account.mvc/ChangePassword', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3', N'Reporting', N'reporting', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.1', N'Baptised/Confirmed Members', N'Reporting.mvc/listbybaptisedconfirmed', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.10', N'Member By Ministry', N'Reporting.mvc/listbyministry', 10)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.4', N'Member By Marital Status', N'Reporting.mvc/listbymarriage', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.5', N'Member By Occupation', N'Reporting.mvc/listbyoccupation', 5)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.6', N'Member In Electoral Roll', N'Reporting.mvc/listbyelectoral', 6)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.7', N'Member By Cell Group', N'Reporting.mvc/listbycellgroup', 7)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.9', N'Member By Age', N'Reporting.mvc/listbyage', 9)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.3.99', N'Manual Search', N'Reporting.mvc/manualSearch', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.4', N'Parish Administrative', N'Admin', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.4.1', N'Staff Related', N'parish.mvc/Staff', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.4.2', N'Course Related', N'parish.mvc/Course', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.4.3', N'Ministry Related', N'parish.mvc/Ministry', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.4.4', N'Cell-Group Related ', N'parish.mvc/Cellgroup', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.5', N'Settings', N'SAMIS', 5)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.5.1', N'SAMIS II Setting', N'settings.mvc/samis2settings', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.5.2', N'SAMIS Access Control', N'settings.mvc/accessControl', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.5.3', N'SAMIS DB Backup', N'settings.mvc/samis2backup', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.5.4', N'Remove Unused Files', N'settings.mvc/removeFiles', 4)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.6', N'City Comm', N'City Comm', 6)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.6.1', N'New Kid', N'citykids.mvc/newkid', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.6.2', N'Update Kid', N'citykids.mvc/updatekid', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.6.3', N'Update Points - DUN USE', N'citykids.mvc/updatePoints', 3)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.7', N'Public Registration', N'Registration', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.7.1', N'Membership Signup', N'membership.mvc/NewMember', 1)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.7.2', N'Course Signup', N'membership.mvc/courseregistration', 2)
INSERT [dbo].[tb_AppModFunc] ([AppModFuncID], [AppModFuncName], [URL], [Sequence]) VALUES (N'1.7.3', N'CITY Children Club Signup', N'citykids.mvc/newkid', 3)
/****** Object:  Table [dbo].[tb_App_Config]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_App_Config](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[ConfigName] [varchar](100) NOT NULL,
	[value] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_tb_App_Config] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_App_Config] ON
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (1, N'ChurchName', N'ST ANDREW''S CATHEDRAL')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (3, N'temp_uploadfilesavedlocation', N'C:\tempfile\temp\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (5, N'icphotolocation', N'C:\tempfile\icphoto\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (6, N'currentparish', N'16')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (7, N'OneMapTokenURL', N'http://www.onemap.sg/API/services.svc/getToken?accessKEY=OmjF+W2pSqxA2mON0cpxI7HEYEVeGJhCyIofbFDD1jMv5lTgvjhcggozqqTfEDhRjdi1M3Dv497ZSEACTKnNzw==|mv73ZvjFcSo=')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (8, N'AutoPostalCode', N'On')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (9, N'PostalCodeRetrival', N'Server')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (10, N'PostalCodeRetrivalURL', N'http://www.onemap.sg/API/services.svc/revgeocode?token=<KSTOKEN>&Postalcode=')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (13, N'AcceptableFile', N'jpg,jpeg,gif,png,docx,doc,txt')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (14, N'AttachmentLocation', N'C:\tempfile\attachment\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (17, N'DeletedAttachmentLocation', N'C:\tempfile\deletedattachment\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (19, N'CityKidsPhotolocation', N'C:\tempfile\CityKids_photo\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (20, N'DBBackupLocation', N'C:\tempfile\SAMIS2.bak')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (21, N'JavascriptLocation', N'C:\inetpub\SAMIS\Content\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (22, N'PermanentDeletedLocation', N'C:\tempfile\PermanentDeleted\')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (23, N'CityKidBaseAttendancePoint', N'10')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (24, N'CityKidContinualAttendance', N'5')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (25, N'ErrorRecipients', N'zniter81@gmail.com')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (26, N'SMTPAccount', N'postmaster@samisemail.mailgun.org')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (27, N'SMTPAddress', N'smtp.mailgun.org')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (28, N'SMTPAccountPassword', N'P@ssw0rd')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (29, N'SystemMode', N'SAMIS')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (30, N'SamisRegistrationRecipients', N'zniter81@gmail.com')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (31, N'CERegistrationRecipients', N'zniter81@gmail.com')
INSERT [dbo].[tb_App_Config] ([ConfigID], [ConfigName], [value]) VALUES (32, N'C3RegistrationRecipients', N'zniter81@gmail.com')
SET IDENTITY_INSERT [dbo].[tb_App_Config] OFF
/****** Object:  Table [dbo].[tb_members]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_members](
	[Salutation] [tinyint] NOT NULL,
	[EnglishName] [varchar](50) NOT NULL,
	[ChineseName] [nvarchar](50) NOT NULL,
	[DOB] [date] NOT NULL,
	[Gender] [varchar](1) NOT NULL,
	[NRIC] [varchar](20) NOT NULL,
	[Nationality] [tinyint] NOT NULL,
	[Dialect] [tinyint] NOT NULL,
	[MaritalStatus] [tinyint] NOT NULL,
	[MarriageDate] [date] NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](70) NOT NULL,
	[AddressPostalCode] [int] NOT NULL,
	[AddressUnit] [varchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Education] [tinyint] NOT NULL,
	[Language] [varchar](200) NOT NULL,
	[Occupation] [tinyint] NOT NULL,
	[HomeTel] [varchar](50) NOT NULL,
	[MobileTel] [varchar](50) NOT NULL,
	[BaptismDate] [date] NULL,
	[BaptismBy] [varchar](20) NOT NULL,
	[BaptismByOthers] [varchar](100) NOT NULL,
	[BaptismChurch] [tinyint] NOT NULL,
	[BaptismChurchOthers] [varchar](100) NOT NULL,
	[ConfirmDate] [date] NULL,
	[ConfirmBy] [varchar](20) NOT NULL,
	[ConfirmByOthers] [varchar](100) NOT NULL,
	[ConfirmChurch] [tinyint] NOT NULL,
	[ConfirmChurchOthers] [varchar](100) NOT NULL,
	[TransferReason] [varchar](1000) NOT NULL,
	[Family] [xml] NOT NULL,
	[Child] [xml] NOT NULL,
	[CurrentParish] [tinyint] NOT NULL,
	[ICPhoto] [varchar](1000) NOT NULL,
	[PreviousChurch] [tinyint] NOT NULL,
	[PreviousChurchOthers] [varchar](100) NOT NULL,
	[DeceasedDate] [date] NULL,
	[CreatedDate] [date] NOT NULL,
	[CarIU] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tb_members] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_maritalstatus]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_maritalstatus](
	[MaritalStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[MaritalStatusName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_maritalstatus] PRIMARY KEY CLUSTERED 
(
	[MaritalStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_maritalstatus] ON
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (1, N'Single')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (2, N'Married')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (3, N'Divorced')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (4, N'Widowed')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (6, N'Separated')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (7, N'Unspecified')
INSERT [dbo].[tb_maritalstatus] ([MaritalStatusID], [MaritalStatusName]) VALUES (8, N'Married (Unspecified Date)')
SET IDENTITY_INSERT [dbo].[tb_maritalstatus] OFF
/****** Object:  Table [dbo].[tb_language]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_language](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [varchar](100) NULL,
 CONSTRAINT [PK_tb_language] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_language] ON
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (1, N'Malay')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (2, N'English')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (3, N'Lao')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (4, N'Burmese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (5, N'Filipino')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (6, N'Chinese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (7, N'Tamil')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (8, N'Hindu')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (9, N'Thai')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (10, N'Vietnamese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (11, N'Japanese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (12, N'French')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (13, N'Spanish')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (14, N'German')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (15, N'Sign Language')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (16, N'Hokkien')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (17, N'Cantonese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (19, N'Hakka')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (20, N'Foochow')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (21, N'Hainanese')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (22, N'Khek')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (23, N'Korean')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (24, N'Teochew')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (25, N'Tagalog')
INSERT [dbo].[tb_language] ([LanguageID], [LanguageName]) VALUES (26, N'Shanghainese')
SET IDENTITY_INSERT [dbo].[tb_language] OFF
/****** Object:  Table [dbo].[tb_file_type]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_file_type](
	[FileTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FileType] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_file_type] PRIMARY KEY CLUSTERED 
(
	[FileTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_file_type] ON
INSERT [dbo].[tb_file_type] ([FileTypeID], [FileType]) VALUES (1, N'Testimony')
INSERT [dbo].[tb_file_type] ([FileTypeID], [FileType]) VALUES (2, N'Baptism Certificate')
INSERT [dbo].[tb_file_type] ([FileTypeID], [FileType]) VALUES (6, N'Photo ID')
INSERT [dbo].[tb_file_type] ([FileTypeID], [FileType]) VALUES (7, N'Transfer Letter')
INSERT [dbo].[tb_file_type] ([FileTypeID], [FileType]) VALUES (8, N'Others')
SET IDENTITY_INSERT [dbo].[tb_file_type] OFF
/****** Object:  Table [dbo].[tb_familytype]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_familytype](
	[FamilyTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[FamilyType] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_familytype] PRIMARY KEY CLUSTERED 
(
	[FamilyTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_familytype] ON
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (1, N'Father')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (2, N'Mother')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (3, N'Brother')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (4, N'Sister')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (5, N'Grandfather')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (6, N'Grandmother')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (7, N'Relative')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (8, N'Spouse')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (9, N'Son')
INSERT [dbo].[tb_familytype] ([FamilyTypeID], [FamilyType]) VALUES (10, N'Daughter')
SET IDENTITY_INSERT [dbo].[tb_familytype] OFF
/****** Object:  Table [dbo].[tb_emailContent]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_emailContent](
	[EmailID] [int] IDENTITY(1,1) NOT NULL,
	[EmailType] [varchar](100) NOT NULL,
	[EmailContent] [varchar](max) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_emailContent] ON
INSERT [dbo].[tb_emailContent] ([EmailID], [EmailType], [EmailContent]) VALUES (1, N'GreenForm', N'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" ><head><title>SAMIS New Membership</title><style type="text/css">    body { font-family:Calibri; }    table { border-collapse: collapse; }     td, th { padding: .3em; border: 1px #ccc solid; white-space: nowrap;}</style></head>  <body>  Dear SAMIS Administrator,<br />  <br />  System has received a Green Form Registration request. Below is the information of the person. <br /><br />
<style>
    table.dottedview
    {
        empty-cells: hide;
	    width: 100%;
    }

    table.dottedview td {
	    font-family:arial, verdana, sans-serif;
	    font-size: 10px;
	    padding: 10px;
	    vertical-align:top;
	    border-right: 1px none #C0C0C0;
	    border-bottom: 1px none #C0C0C0;
	
    }
</style>

<table border="1" class="dottedview">
    <tr>
        <td style=" background-color:Orange">Salutation</td>
        <td style=" width:200px">[Salutation]</td>

        <td style=" background-color:Orange">English Name</td>
        <td style=" width:200px">[English Name]</td>

        <td style=" background-color:Orange">Chinese Name</td>
        <td style=" width:200px">[Chinese Name]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Date Of Birth</td>
        <td>[DOB]</td>

        <td style=" background-color:Orange">Gender</td>
        <td>[Gender]</td>

        <td style=" background-color:Orange">NRIC</td>
        <td>[NRIC]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Nationality</td>
        <td>[Nationality]</td>

        <td style=" background-color:Orange">Dialect</td>
        <td>[Dialect]</td>

        <td style=" background-color:Orange">Marital Status</td>
        <td>[Marital Status],[Marital Status Date]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Postal Code</td>
        <td>[Postal Code]</td>

        <td style=" background-color:Orange">Email</td>
        <td>[Email]</td>

        <td style=" background-color:Orange">Education</td>
        <td>[Education]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Blk/House</td>
        <td>[Blk House]</td>

        <td style=" background-color:Orange">Language</td>
        <td>[Language]</td>

        <td style=" background-color:Orange">Occupation</td>
        <td>[Occupation]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Unit</td>
        <td>[Unit]</td>

        <td style=" background-color:Orange">Home Tel</td>
        <td>[Home Tel]</td>

        <td style=" background-color:Orange">Mobile Tel</td>
        <td>[Mobile Tel]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Street Address</td>
        <td>[Street Address]</td>

        <td style=" background-color:Orange">Mobile Tel</td>
        <td>[Mobile Tel]</td>

        <td style=" background-color:Orange">Congregation</td>
        <td>[Congregation]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Sponsor 1</td>
        <td>[Sponsor 1]</td>

        <td style=" background-color:Orange">Sponsor 2</td>
        <td>[Sponsor 2]</td>

        <td style=" background-color:Orange">Sponsor 2 Contact</td>
        <td>[Sponsor 2 Contact]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Baptism Date</td>
        <td>[Baptism Date]</td>

        <td style=" background-color:Orange">Baptism By</td>
        <td>[Baptism By],[Baptism By Others]</td>

        <td style=" background-color:Orange">Baptism Church</td>
        <td>[Baptism Church],[Baptism Church Others]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Confirmation Date</td>
        <td>[Confirmation Date]</td>

        <td style=" background-color:Orange">Confirmation By</td>
        <td>[Confirmation By],[Confirmation By Others]</td>

        <td style=" background-color:Orange">Confirmation Church</td>
        <td>[Confirmation Church],[Confirmation Church Others]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Previous Church Membership</td>
        <td>[Previous Church Membership],[Previous Church Membership Others]</td>

        <td style=" background-color:Orange">Transfer Reason</td>
        <td colspan="3">[Transfer Reason]</td>        
    </tr>
     <tr>
        <td colspan="6" style=" padding:2.5% 2.5% 2.5% 2.5%">
            <table width="100%" border="0" style=" border-color:Orange">
                <tr>
                    <td style=" background-color:Orange">Family</td>
                    <td style=" background-color:Orange">English Name</td>
                    <td style=" background-color:Orange">Chinese Name</td>
                    <td style=" background-color:Orange">Occupation</td>
                    <td style=" background-color:Orange">Religion</td>
                </tr>
                [Family]
            </table>
         </td>       
    </tr>
    <tr>
        <td colspan="6"  style=" padding:2.5% 2.5% 2.5% 2.5%">
            <table width="100%">
                <tr>
                    <td style=" background-color:Orange">English Name</td>
                    <td style=" background-color:Orange">Chinese Name</td>
                    <td style=" background-color:Orange">Baptism Date</td>
                    <td style=" background-color:Orange">Baptism By</td>
                    <td style=" background-color:Orange">Church</td>
                </tr>
                [Child]
            </table>
        </td>       
    </tr>
    <tr>
        <td style=" background-color:Orange">Join Cellgroup</td>
        <td>[Join Cellgroup]</td>

        <td style=" background-color:Orange">Serve in my congregation</td>
        <td>[Serve Congregation]</td>

        <td style=" background-color:Orange">Be a tithing member</td>
        <td>[Tithing Member]</td>
    </tr>    
    <tr>
        <td style=" background-color:Orange">Join Ministry</td>
        <td colspan="5">[Join Ministry]</td>        
    </tr>
</table>

<br /><br /> [attachment] <br /><br />
Offline Submission Content<br />
[xmlcontent] Regards,  <br />  <br /><hr>  <span style="font-style:italic; font-size:12px; padding-top:0">This is an automated email notification from http://samis2.apphb.com/</span>  </body>  </html>')
INSERT [dbo].[tb_emailContent] ([EmailID], [EmailType], [EmailContent]) VALUES (4, N'C3ChildrenClub', N'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" ><head><title>C3 Children Club Membership</title><style type="text/css">    body { font-family:Calibri; }    table { border-collapse: collapse; }     td, th { padding: .3em; border: 1px #ccc solid; white-space: nowrap;}</style></head>  <body>  Dear C3 Administrator,<br />  <br />  System has received a C3 Children Club Registration request. Below is the information of the person. <br /><br />
<style>
    table.dottedview
    {
        empty-cells: hide;
	    width: 100%;
    }

    table.dottedview td {
	    font-family:arial, verdana, sans-serif;
	    font-size: 10px;
	    padding: 10px;
	    vertical-align:top;
	    border-right: 1px none #C0C0C0;
	    border-bottom: 1px none #C0C0C0;
	
    }
</style>

<table border="1" class="dottedview">
    <tr>
        <td style=" background-color:Orange">NRIC</td>
        <td style="width:250px">[NRIC]</td>
        
        <td style=" background-color:Orange">Name</td>
        <td style="width:250px">[Name]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Gender</td>
        <td>[Gender]</td>
            
        <td style=" background-color:Orange">DOB</td>
        <td>[DOB]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Nationality</td>
        <td>[Nationality]</td>
        
        <td style=" background-color:Orange">Race</td>
        <td>[Race]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Home Tel</td>
        <td>[Home Tel]</td>
        
        <td style=" background-color:Orange">Mobile Tel</td>
        <td>[Mobile Tel]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Address PostalCode</td>
        <td>[PostalCode]</td>
        
        <td style=" background-color:Orange">Address StreetName</td>
        <td>[StreetName]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Address BlkHouse</td>
        <td>[BlkHouse]</td>
        
        <td style=" background-color:Orange">Address Unit</td>
        <td>[Unit]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Email</td>
        <td>[Email]</td>
        
        <td style=" background-color:Orange">School</td>
        <td>[School]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">Religion</td>
        <td>[Religion]</td>
        
        <td style=" background-color:Orange">NOK Contact</td>
        <td>[NOK Contact]</td>
    </tr>
    <tr>
        <td style=" background-color:Orange">NOK Name</td>
        <td>[NOK Name]</td>
        
        <td style=" background-color:Orange">Special Needs</td>
        <td>[Special Needs]</td>
    </tr>
</table>

<br /><br /> [attachment] <br /><br />
Regards,  <br />  <br /><hr>  <span style="font-style:italic; font-size:12px; padding-top:0">This is an automated email notification from http://samis2.apphb.com/</span>  </body>  </html>')
INSERT [dbo].[tb_emailContent] ([EmailID], [EmailType], [EmailContent]) VALUES (2, N'CourseRegistration', N'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" ><head><title>SAMIS New Membership</title><style type="text/css">    body { font-family:Calibri; }    table { border-collapse: collapse; }     td, th { padding: .3em; border: 1px #ccc solid; white-space: nowrap;}</style></head>  <body>  Dear CE Administrator,<br />  <br />  System has received a CE Registration request. Below is the information of the person.  <br /><br />
<style>
    table.dottedview
    {
        empty-cells: hide;
	    width: 100%;
    }

    table.dottedview td {
	    font-family:arial, verdana, sans-serif;
	    font-size: 10px;
	    padding: 10px;
	    vertical-align:top;
	    border-right: 1px none #C0C0C0;
	    border-bottom: 1px none #C0C0C0;
	
    }
</style>

<table border="1" class="dottedview">
    <tr>
        <td style=" background-color:Orange">Course</td>
        <td style=''width:200px''>[candidate_course_name]</td>
        
        <td style=" background-color:Orange">NRIC</td>
        <td style=''width:200px''>[candidate_nric]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Salutation</td>
        <td>[candidate_salutation]</td>
        
        <td style=" background-color:Orange">English Name</td>
        <td>[candidate_english_name]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Date of Birth</td>
        <td>[candidate_dob]</td>
        
        <td style=" background-color:Orange">Gender</td>
        <td>[candidate_gender]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Nationality</td>
        <td>[candidate_nationality]</td>
        
        <td style=" background-color:Orange">Education</td>
        <td>[candidate_education]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Church</td>
        <td>[candidate_church]</td>
        
        <td style=" background-color:Orange">Occupation</td>
        <td>[candidate_occupation]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Church Others</td>
        <td colspan=''3''>[candidate_church_others]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Postal Code</td>
        <td>[candidate_postal_code]</td>
        
        <td style=" background-color:Orange">Blk/House</td>
        <td>[candidate_blk_house]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Contact</td>
        <td>[candidate_contact]</td>
        
        <td style=" background-color:Orange">Email</td>
        <td>[candidate_email]</td>
     </tr>
     <tr>
        <td style=" background-color:Orange">Unit</td>
        <td>[candidate_unit]</td>
        
        <td style=" background-color:Orange">Street Address</td>
        <td>[candidate_street_address]</td>
     </tr>
</table>

<br /><br /> 
Regards,  <br />  <br /><hr>  <span style="font-style:italic; font-size:12px; padding-top:0">This is an automated email notification from http://samis2.apphb.com/</span>  </body>  </html>')
SET IDENTITY_INSERT [dbo].[tb_emailContent] OFF
/****** Object:  Table [dbo].[tb_education]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_education](
	[EducationID] [tinyint] IDENTITY(1,1) NOT NULL,
	[EducationName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_education] PRIMARY KEY CLUSTERED 
(
	[EducationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_education] ON
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (1, N'Primary')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (2, N'Secondary')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (3, N'Polytechnic')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (4, N'University')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (6, N'Junior College')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (7, N'Others')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (8, N'None')
INSERT [dbo].[tb_education] ([EducationID], [EducationName]) VALUES (9, N'ITE')
SET IDENTITY_INSERT [dbo].[tb_education] OFF
/****** Object:  Table [dbo].[tb_DOSLogging]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_DOSLogging](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[ActionTime] [datetime] NOT NULL,
	[Type] [char](1) NOT NULL,
	[ActionBy] [varchar](50) NOT NULL,
	[ProgramReference] [varchar](100) NOT NULL,
	[Description] [varchar](2000) NOT NULL,
	[DebugLevel] [tinyint] NOT NULL,
	[Reference] [varchar](100) NULL,
	[ReferenceType] [nchar](10) NULL,
	[UpdatedElements] [xml] NOT NULL,
 CONSTRAINT [PK_tb_AuditLog_LogID] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_dialect]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_dialect](
	[DialectID] [int] IDENTITY(1,1) NOT NULL,
	[DialectName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_dialect] PRIMARY KEY CLUSTERED 
(
	[DialectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_dialect] ON
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (1, N'Cantonese')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (2, N'Foochow')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (3, N'Hainanese')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (4, N'Hakka')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (5, N'Henghua')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (6, N'Hockchia')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (7, N'Hokkien')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (8, N'Shanghainese')
INSERT [dbo].[tb_dialect] ([DialectID], [DialectName]) VALUES (9, N'Teochew')
SET IDENTITY_INSERT [dbo].[tb_dialect] OFF
/****** Object:  Table [dbo].[tb_course_schedule]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_course_schedule](
	[CourseID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Remark] [nchar](50) NULL,
 CONSTRAINT [PK_tb_course_schedule] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC,
	[Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tb_Roles]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_Roles](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_Roles] ON
INSERT [dbo].[tb_Roles] ([RoleID], [RoleName]) VALUES (-1, N'Do Not Use. Do Not Delete.')
INSERT [dbo].[tb_Roles] ([RoleID], [RoleName]) VALUES (1, N'Administrator')
SET IDENTITY_INSERT [dbo].[tb_Roles] OFF
/****** Object:  Table [dbo].[tb_religion]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_religion](
	[ReligionID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReligionName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_religion] PRIMARY KEY CLUSTERED 
(
	[ReligionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_religion] ON
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (1, N'Christianity')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (2, N'Buddhism')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (3, N'Taoism')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (4, N'Hinduism')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (5, N'Islam')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (6, N'Free Thinker')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (8, N'Others')
INSERT [dbo].[tb_religion] ([ReligionID], [ReligionName]) VALUES (9, N'Sikhism')
SET IDENTITY_INSERT [dbo].[tb_religion] OFF
/****** Object:  Table [dbo].[tb_race]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_race](
	[RaceID] [tinyint] IDENTITY(1,1) NOT NULL,
	[RaceName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_race] PRIMARY KEY CLUSTERED 
(
	[RaceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_race] ON
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (1, N'Chinese')
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (2, N'Malay')
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (3, N'Indian')
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (5, N'Asian')
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (6, N'White')
INSERT [dbo].[tb_race] ([RaceID], [RaceName]) VALUES (7, N'Black')
SET IDENTITY_INSERT [dbo].[tb_race] OFF
/****** Object:  Table [dbo].[tb_postalArea]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_postalArea](
	[District] [int] IDENTITY(1,1) NOT NULL,
	[PostalAreaName] [varchar](200) NOT NULL,
	[PostalDigit] [varchar](200) NOT NULL,
 CONSTRAINT [PK_tb_postalArea] PRIMARY KEY CLUSTERED 
(
	[District] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_postalArea] ON
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (1, N'Raffles Place, Cecil, Marina, People''s Park', N'01, 02, 03, 04, 05, 06')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (2, N'Anson, Tanjong Pagar', N'07, 08')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (3, N'Queenstown, Tiong Bahru', N'14,15, 16')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (4, N'Telok Blangah, Harbourfront', N'09, 10')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (5, N'Pasir Panjang, Hong Leong Garden, Clementi New Town', N'11, 12, 13')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (6, N'High Street, Beach Road (part)', N'17')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (7, N'Middle Road, Golden Mile', N'18, 19')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (8, N'Little India', N'20, 21')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (9, N'Orchard, Cairnhill, River Valley', N'22, 23')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (10, N'Ardmore, Bukit Timah, Holland Road, Tanglin', N'24, 25, 26, 27')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (11, N'Watten Estate, Novena, Thomson', N'28, 29, 30')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (12, N'Balestier, Toa Payoh, Serangoon', N'31, 32, 33')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (13, N'Macpherson, Braddell', N'34, 35, 36, 37')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (14, N'Geylang, Eunos', N'38, 39, 40, 41')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (15, N'Katong, Joo Chiat, Amber Road', N'42, 43, 44, 45')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (16, N'Bedok, Upper East Coast, Eastwood, Kew Drive', N'46, 47, 48')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (17, N'Loyang, Changi', N'49, 50, 81')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (18, N'Tampines, Pasir Ris', N'51, 52')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (19, N'Serangoon Garden, Hougang, Ponggol', N'53, 54, 55, 82')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (20, N'Bishan, Ang Mo Kio', N'56, 57')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (21, N'Upper Bukit Timah, Clementi Park, Ulu Pandan', N'58, 59')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (22, N'Jurong', N'60, 61, 62, 63, 64')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (23, N'Hillview, Dairy Farm, Bukit Panjang, Choa Chu Kang', N'65, 66, 67, 68')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (24, N'Lim Chu Kang, Tengah', N'69, 70, 71')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (25, N'Kranji, Woodgrove', N'72, 73')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (26, N'Upper Thomson, Springleaf', N'77, 78')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (27, N'Yishun, Sembawang', N'75, 76')
INSERT [dbo].[tb_postalArea] ([District], [PostalAreaName], [PostalDigit]) VALUES (28, N'Seletar', N'79, 80')
SET IDENTITY_INSERT [dbo].[tb_postalArea] OFF
/****** Object:  Table [dbo].[tb_parish]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_parish](
	[ParishID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ParishName] [varchar](100) NULL,
 CONSTRAINT [PK_tb_parish] PRIMARY KEY CLUSTERED 
(
	[ParishID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_parish] ON
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (1, N'ALL SAINTS'' CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (2, N'CHAPEL OF CHRIST THE REDEEMER')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (3, N'CHAPEL OF THE HOLY SPIRIT')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (4, N'CHAPEL OF CHRIST THE KING')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (5, N'CHAPEL OF THE RESURRECTION')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (6, N'CHRIST CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (7, N'CHURCH OF THE ASCENSION')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (8, N'CHURCH OF THE EPIPHANY')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (9, N'CHURCH OF THE GOOD SHEPHERD')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (10, N'CHURCH OF OUR SAVIOUR')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (11, N'CHURCH OF THE TRUE LIGHT')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (12, N'HOLY TRINITY PARISH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (13, N'LIGHT OF CHRIST CHURCH WOODLANDS')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (14, N'MARINE PARADE CHRISTIAN CENTRE')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (15, N'MY SAVIOUR''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (16, N'ST ANDREW''S CATHEDRAL')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (17, N'ST ANDREW''S CITY CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (18, N'ST ANDREW''S COMMUNITY CHAPEL')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (19, N'ST GEORGE''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (20, N'ST HILDA''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (21, N'ST JAMES'' CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (22, N'ST JOHN''S CHAPEL')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (23, N'ST JOHN''S - ST MARGARET''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (24, N'ST MATTHEW''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (25, N'ST PAUL''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (26, N'ST PETER''S CHURCH')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (27, N'YISHUN CHRISTIAN CHURCH (ANGLICAN)')
INSERT [dbo].[tb_parish] ([ParishID], [ParishName]) VALUES (28, N'Others')
SET IDENTITY_INSERT [dbo].[tb_parish] OFF
/****** Object:  Table [dbo].[tb_occupation]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_occupation](
	[OccupationID] [int] IDENTITY(1,1) NOT NULL,
	[OccupationName] [varchar](100) NULL,
 CONSTRAINT [PK_tb_occupation] PRIMARY KEY CLUSTERED 
(
	[OccupationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_occupation] ON
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (1, N'Accounting/Finance')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (2, N'Administrative')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (3, N'Advertising')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (4, N'Architecture')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (5, N'Artist/Actor/Creative/Performer')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (6, N'Aviation/Airlines')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (7, N'Banking/Financial')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (8, N'Bio-Pharmaceutical')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (9, N'Bookkeeper')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (10, N'Builder')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (11, N'Business')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (12, N'Celebrity')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (13, N'Chef')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (14, N'Clerical')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (15, N'Computer Related (hardware)')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (16, N'Computer Related (software)')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (17, N'Computer Related (IT)')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (18, N'Consulting')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (19, N'Craftsman/Construction')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (20, N'Customer Support')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (21, N'Designer')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (22, N'Doctor')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (23, N'Educator/Academic')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (24, N'Engineering/Architecture')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (25, N'Entertainment')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (26, N'Environmental')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (27, N'Executive/Senior Management')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (28, N'Farmer')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (29, N'Finance')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (30, N'Flight Attendant')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (31, N'Food Services')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (32, N'Government')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (33, N'Homemaker')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (34, N'Household')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (35, N'Human Resources')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (36, N'Industrial')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (37, N'Insurance')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (38, N'Lawyer')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (39, N'Legal Professions')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (40, N'Medical/Healthcare')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (41, N'Management')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (42, N'Manufacturing/Operations')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (43, N'Marine')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (44, N'Marketing')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (45, N'Media')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (46, N'Medical/Healthcare')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (47, N'Military')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (48, N'Musician')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (49, N'Nurse')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (50, N'Political')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (51, N'Professor')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (52, N'Public Relations')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (53, N'Public Sector')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (54, N'Publishing')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (55, N'Real Estate')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (56, N'Recreation')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (57, N'Research/Scientist')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (58, N'Retail')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (59, N'Retired')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (60, N'Sales')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (61, N'Secretary')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (62, N'Self Employed')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (63, N'Service Industry')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (64, N'Social Science')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (65, N'Social Services')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (66, N'Sports')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (67, N'Student')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (68, N'Technical')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (69, N'Technician')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (70, N'Teaching')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (71, N'Telecommunications')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (72, N'Transportation/Logistics')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (73, N'Travel/Hospitality/Tourism')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (74, N'Unemployed')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (75, N'Other')
INSERT [dbo].[tb_occupation] ([OccupationID], [OccupationName]) VALUES (78, N'Church Worker')
SET IDENTITY_INSERT [dbo].[tb_occupation] OFF
/****** Object:  Table [dbo].[tb_ModulesFunctions]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_ModulesFunctions](
	[functionID] [int] IDENTITY(1,1) NOT NULL,
	[Module] [varchar](100) NOT NULL,
	[functionName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_ModulesFunctions] PRIMARY KEY CLUSTERED 
(
	[functionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_ModulesFunctions] ON
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (1, N'Member', N'Update Member')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (38, N'Congregation', N'Congregation:1, 7:00am English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (39, N'Congregation', N'Congregation:2, 8:00am English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (40, N'Congregation', N'Congregation:3, 9:00am English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (41, N'Congregation', N'Congregation:4, 10.00am WAC')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (42, N'Congregation', N'Congregation:5, 10.00am Acts Centre')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (43, N'Congregation', N'Congregation:6, 11:15am English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (44, N'Congregation', N'Congregation:7, 1:30pm LYnC English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (45, N'Congregation', N'Congregation:8, 2:00pm Filipino')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (46, N'Congregation', N'Congregation:9, 2:30pm Bahasa Indonesia')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (47, N'Congregation', N'Congregation:10, 5:00pm Mandarin CNS')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (48, N'Congregation', N'Congregation:11, 5:00pm Engish')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (49, N'Congregation', N'Congregation:12, 7:00pm Myanmar')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (50, N'Congregation', N'Congregation:13, 7.00pm Global Crossroads (Sat)')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (51, N'Congregation', N'Congregation:14, 7:30pm English')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (52, N'Congregation', N'Congregation:15, Others')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (56, N'Visitor', N'Update Visitor')
INSERT [dbo].[tb_ModulesFunctions] ([functionID], [Module], [functionName]) VALUES (57, N'Congregation', N'Congregation:22, 5.00pm J-Gospel (Sat)')
SET IDENTITY_INSERT [dbo].[tb_ModulesFunctions] OFF
/****** Object:  Table [dbo].[tb_ministry]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_ministry](
	[MinistryID] [tinyint] IDENTITY(1,1) NOT NULL,
	[MinistryName] [varchar](50) NOT NULL,
	[MinistryInCharge] [varchar](10) NOT NULL,
	[MinistryDescription] [varchar](2000) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_tb_ministry] PRIMARY KEY CLUSTERED 
(
	[MinistryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_membersOtherInfo_temp]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_membersOtherInfo_temp](
	[NRIC] [varchar](20) NOT NULL,
	[ElectoralRoll] [date] NULL,
	[CellGroup] [tinyint] NOT NULL,
	[Congregation] [tinyint] NOT NULL,
	[MinistryInvolvement] [xml] NOT NULL,
	[MinistryInterested] [xml] NOT NULL,
	[TithingInterested] [bit] NOT NULL,
	[CellgroupInterested] [bit] NOT NULL,
	[ServeCongregationInterested] [bit] NOT NULL,
	[Sponsor1] [varchar](20) NOT NULL,
	[Sponsor2] [varchar](100) NOT NULL,
	[Sponsor2Contact] [varchar](100) NOT NULL,
	[MemberDate] [date] NULL,
	[Remarks] [varchar](1000) NOT NULL,
	[TransferTo] [varchar](100) NOT NULL,
	[TransferToDate] [date] NULL,
 CONSTRAINT [PK_tb_membersOtherInfo_temp] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_membersOtherInfo]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_membersOtherInfo](
	[NRIC] [varchar](20) NOT NULL,
	[ElectoralRoll] [date] NULL,
	[CellGroup] [tinyint] NOT NULL,
	[Congregation] [tinyint] NOT NULL,
	[MinistryInvolvement] [xml] NOT NULL,
	[MinistryInterested] [xml] NOT NULL,
	[TithingInterested] [bit] NOT NULL,
	[CellgroupInterested] [bit] NOT NULL,
	[ServeCongregationInterested] [bit] NOT NULL,
	[Sponsor1] [varchar](20) NOT NULL,
	[Sponsor2] [varchar](100) NOT NULL,
	[Sponsor2Contact] [varchar](100) NOT NULL,
	[MemberDate] [date] NULL,
	[Remarks] [varchar](1000) NOT NULL,
	[TransferTo] [varchar](100) NOT NULL,
	[TransferToDate] [date] NULL,
 CONSTRAINT [PK_tb_membersOtherInfo] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_members_temp]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_members_temp](
	[Salutation] [tinyint] NOT NULL,
	[EnglishName] [varchar](50) NOT NULL,
	[ChineseName] [nvarchar](50) NOT NULL,
	[DOB] [date] NOT NULL,
	[Gender] [varchar](1) NOT NULL,
	[NRIC] [varchar](20) NOT NULL,
	[Nationality] [tinyint] NOT NULL,
	[Dialect] [tinyint] NOT NULL,
	[MaritalStatus] [tinyint] NOT NULL,
	[MarriageDate] [date] NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](7) NOT NULL,
	[AddressPostalCode] [int] NOT NULL,
	[AddressUnit] [varchar](10) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Education] [tinyint] NOT NULL,
	[Language] [varchar](200) NOT NULL,
	[Occupation] [tinyint] NOT NULL,
	[HomeTel] [varchar](15) NOT NULL,
	[MobileTel] [varchar](15) NOT NULL,
	[BaptismDate] [date] NULL,
	[BaptismBy] [varchar](20) NOT NULL,
	[BaptismByOthers] [varchar](100) NOT NULL,
	[BaptismChurch] [tinyint] NOT NULL,
	[BaptismChurchOthers] [varchar](100) NOT NULL,
	[ConfirmDate] [date] NULL,
	[ConfirmBy] [varchar](20) NOT NULL,
	[ConfirmByOthers] [varchar](100) NOT NULL,
	[ConfirmChurch] [tinyint] NOT NULL,
	[ConfirmChurchOthers] [varchar](100) NOT NULL,
	[TransferReason] [varchar](1000) NOT NULL,
	[Family] [xml] NOT NULL,
	[Child] [xml] NOT NULL,
	[CurrentParish] [tinyint] NOT NULL,
	[ICPhoto] [varchar](1000) NOT NULL,
	[PreviousChurch] [tinyint] NOT NULL,
	[PreviousChurchOthers] [varchar](100) NOT NULL,
	[DeceasedDate] [date] NULL,
	[CreatedDate] [date] NOT NULL,
	[CarIU] [nchar](10) NOT NULL,
 CONSTRAINT [PK_tb_members_temp] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [dbo].[udf_CheckSAMIS1Remarks]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_CheckSAMIS1Remarks]
(
	-- Add the parameters for the function here
	@name VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	
	IF(CHARINDEX('(', @name) = 1)
	BEGIN
		RETURN LTRIM(RTRIM(SUBSTRING(@name,  CHARINDEX('(', @name), CHARINDEX(')', @name))))
	END 
	
	return ''
	
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_CheckSAMIS1Name]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_CheckSAMIS1Name]
(
	-- Add the parameters for the function here
	@name VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	
	IF(CHARINDEX('(', @name) = 1)
	BEGIN
		RETURN LTRIM(RTRIM(SUBSTRING(@name, CHARINDEX(')', @name)+1, 99)))
	END 
	
	return @name
	
END
GO
/****** Object:  Table [dbo].[tb_visitorType]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_visitorType](
	[VisitorTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[VisitorTypeName] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tb_visitorType] PRIMARY KEY CLUSTERED 
(
	[VisitorTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_visitorType] ON
INSERT [dbo].[tb_visitorType] ([VisitorTypeID], [VisitorTypeName]) VALUES (1, N'Public')
INSERT [dbo].[tb_visitorType] ([VisitorTypeID], [VisitorTypeName]) VALUES (3, N'Others')
SET IDENTITY_INSERT [dbo].[tb_visitorType] OFF
/****** Object:  Table [dbo].[tb_visitors]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_visitors](
	[Salutation] [tinyint] NULL,
	[NRIC] [varchar](20) NOT NULL,
	[EnglishName] [varchar](50) NOT NULL,
	[DOB] [date] NULL,
	[Gender] [varchar](1) NOT NULL,
	[Education] [tinyint] NULL,
	[Occupation] [tinyint] NULL,
	[Nationality] [tinyint] NULL,
	[Email] [varchar](100) NOT NULL,
	[Contact] [varchar](15) NOT NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](10) NOT NULL,
	[AddressPostalCode] [int] NULL,
	[AddressUnit] [varchar](10) NOT NULL,
	[Church] [tinyint] NOT NULL,
	[ChurchOthers] [varchar](100) NOT NULL,
	[VisitorType] [tinyint] NOT NULL,
 CONSTRAINT [PK_tb_visitors] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Users]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_Users](
	[UserID] [varchar](50) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Phone] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Department] [varchar](100) NULL,
	[NRIC] [varchar](20) NOT NULL,
	[Password] [varchar](40) NOT NULL,
	[Style] [int] NULL,
 CONSTRAINT [PK_tb_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tb_Users] ([UserID], [Name], [Email], [Phone], [Mobile], [Department], [NRIC], [Password], [Style]) VALUES (N'gohks', N'Goh Kian Seng', N'zniter81@gmail.com', N'68425818', N'90102609', N'Admin', N'S8111010G', N'd1ff45b65f458651929092502f2749199208f149', NULL)
INSERT [dbo].[tb_Users] ([UserID], [Name], [Email], [Phone], [Mobile], [Department], [NRIC], [Password], [Style]) VALUES (N'Unspecified', N'Unspecified', N'noEmail@noEmail.com', N'-', N'-', N'Internal Use, Do not delete.', N'S00000000', N'A6E7EB706E115CDAF88206BE37EB67B232D007BC', 0)
/****** Object:  Table [dbo].[tb_style]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_style](
	[styleID] [int] IDENTITY(1,1) NOT NULL,
	[styleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_appointment] PRIMARY KEY CLUSTERED 
(
	[styleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_style] ON
INSERT [dbo].[tb_style] ([styleID], [styleName]) VALUES (1, N'The Most Revd')
INSERT [dbo].[tb_style] ([styleID], [styleName]) VALUES (2, N'The Right Revd')
INSERT [dbo].[tb_style] ([styleID], [styleName]) VALUES (3, N'The Very Revd')
INSERT [dbo].[tb_style] ([styleID], [styleName]) VALUES (4, N'The Revd Canon')
INSERT [dbo].[tb_style] ([styleID], [styleName]) VALUES (5, N'The Revd')
SET IDENTITY_INSERT [dbo].[tb_style] OFF
/****** Object:  Table [dbo].[tb_school]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_school](
	[SchoolID] [int] IDENTITY(1,1) NOT NULL,
	[SchoolName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_school] PRIMARY KEY CLUSTERED 
(
	[SchoolID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_school] ON
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (4, N'Anderson Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (5, N'Ang Mo Kio Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (6, N'CHIJ (St Nicholas Girls'')')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (7, N'Da Qiao Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (8, N'Jing Shan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (9, N'Mayflower Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (10, N'Teck Ghee Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (11, N'Townsville Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (12, N'Bedok Green Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (13, N'Bedok West Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (14, N'CHIJ (Katong) Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (15, N'Damai Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (16, N'East Coast Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (17, N'Fengshan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (18, N'Opera Estate Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (19, N'Red Swastika')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (20, N'St Anthony''s Canossian')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (21, N'St Stephen''s')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (22, N'Telok Kurau Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (23, N'Temasek Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (24, N'Yu Neng Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (25, N'Ai Tong')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (26, N'Catholic High')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (27, N'Guangyang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (28, N'Kuo Chuan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (29, N'Bukit View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (30, N'Dazhong Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (31, N'Hong Kah Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (32, N'Keming Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (33, N'Lianhua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (34, N'Princess Elizabeth Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (35, N'St Anthony''s Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (36, N'Blangah Rise Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (37, N'Cantonment Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (38, N'CHIJ (Kellock)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (39, N'Gan Eng Seng Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (40, N'Radin Mas Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (41, N'Zhangde Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (42, N'Beacon Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (43, N'Bukit Panjang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (44, N'CHIJ (Our Lady Queen of Peace)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (45, N'Greenridge Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (46, N'West View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (47, N'Zhenghua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (48, N'Bukit Timah Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (49, N'Henry Park Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (50, N'Methodist Girls''')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (51, N'Nanyang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (52, N'Pei Hwa Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (53, N'Raffles Girls'' Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (54, N'ACS(Junior)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (55, N'River Valley Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (56, N'St Margaret''s Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (57, N'Stamford Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (58, N'Chua Chu Kang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (59, N'Concord Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (60, N'De La Salle')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (61, N'Kranji Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (62, N'South View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (63, N'Teck Whye Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (64, N'Unity Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (65, N'Yew Tee Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (66, N'Clementi Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (67, N'Nan Hua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (68, N'Pei Tong Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (69, N'Qifa Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (70, N'Canossa Convent Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (71, N'Eunos Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (72, N'Geylang Methodist School')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (73, N'Haig Girls''')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (74, N'Kong Hwa')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (75, N'MacPherson Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (76, N'Maha Bodhi')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (77, N'CHIJ (OLN)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (78, N'Holy Innocents'' Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (79, N'Hougang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (80, N'Montfort Jr')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (81, N'Paya Lebar MGS Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (82, N'Punggol Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (83, N'Xinghua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (84, N'Xinmin Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (85, N'Yio Chu Kang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (86, N'Fuhua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (87, N'Jurong Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (88, N'Yuhua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (89, N'Boon Lay Gdn Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (90, N'Corporation Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (91, N'Frontier Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (92, N'Jurong West Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (93, N'Juying Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (94, N'Lakeside Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (95, N'Pioneer Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (96, N'Rulang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (97, N'Shuqun Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (98, N'West Grove Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (99, N'Westwood Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (100, N'Xingnan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (101, N'Bendemeer Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (102, N'Farrer Park Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (103, N'Hong Wen')
GO
print 'Processed 100 total records'
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (104, N'Ngee Ann Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (105, N'Tanjong Katong Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (106, N'Tao Nan')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (107, N'ACS (Pri Sch)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (108, N'Balestier Hill Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (109, N'St Joseph''s Institution Jr')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (110, N'S''pore Chinese Girls''')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (111, N'Casuarina Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (112, N'Coral Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (113, N'Elias Park Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (114, N'Loyang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (115, N'Meridian Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (116, N'Park View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (117, N'Pasir Ris Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (118, N'White Sands Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (119, N'Edgefield Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (120, N'Greendale Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (121, N'Horizon Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (122, N'Mee Toh')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (123, N'Punggol Green Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (124, N'Punggol View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (125, N'Fairfield Methodist School')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (126, N'New Town Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (127, N'Queenstown Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (128, N'Canberra Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (129, N'Endeavour Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (130, N'Sembawang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (131, N'Wellington Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (132, N'Anchor Green Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (133, N'Compassvale Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (134, N'Fernvale Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (135, N'Nan Chiau Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (136, N'North Spring Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (137, N'North Vista Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (138, N'Palm View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (139, N'Rivervale Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (140, N'Seng Kang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (141, N'Sengkang Green Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (142, N'Springdale Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (143, N'CHIJ (OLGC)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (144, N'Rosyth')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (145, N'St Gabriel''s Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (146, N'Yangzheng Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (147, N'Zhonghua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (148, N'Changkat Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (149, N'Chongzheng Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (150, N'East SPri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (151, N'East View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (152, N'Gongshang Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (153, N'Griffiths Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (154, N'Junyuan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (155, N'Poi Ching')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (156, N'Qiaonan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (157, N'St Hilda''s Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (158, N'Tampines Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (159, N'Tampines North Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (160, N'Yumin Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (161, N'Cedar Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (162, N'CHIJ Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (163, N'First Toa Payoh Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (164, N'Kheng Cheng')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (165, N'Maris Stella High (Pri Sch)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (166, N'Marymount Convent')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (167, N'Pei Chun Public')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (168, N'St Andrew''s Jr')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (169, N'Admiralty Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (170, N'Evergreen Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (171, N'Fuchun Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (172, N'Greenwood Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (173, N'Innova Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (174, N'Marsiling Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (175, N'Qihua Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (176, N'Riverside Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (177, N'Si Ling Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (178, N'Woodgrove Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (179, N'Woodlands Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (180, N'Woodlands Ring Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (181, N'Ahmad Ibrahim Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (182, N'Chongfu Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (183, N'Huamin Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (184, N'Jiemin Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (185, N'Naval Base Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (186, N'Northland Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (187, N'North View Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (188, N'Peiying Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (189, N'Xishan Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (190, N'Yishun Pri Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (191, N'Admiralty Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (192, N'Ahmad Ibrahim Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (193, N'Anderson Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (194, N'Ang Mo Kio Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (195, N'Anglican High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (196, N'Anglo-Chinese Sch (Barker Road)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (197, N'Assumption English Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (198, N'Balestier Hill Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (199, N'Bartley Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (200, N'Beatty Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (201, N'Bedok Green Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (202, N'Bedok North Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (203, N'Bedok South Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (204, N'Bedok Town Sec Sch')
GO
print 'Processed 200 total records'
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (205, N'Bedok View Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (206, N'Bendemeer Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (207, N'Bishan Park Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (208, N'Boon Lay Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (209, N'Bowen Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (210, N'Broadrick Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (211, N'Bukit Batok Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (212, N'Bukit Merah Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (213, N'Bukit Panjang Govt. High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (214, N'Bukit View Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (215, N'Canberra Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (216, N'Catholic High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (217, N'Cedar Girls'' Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (218, N'Changkat Changi Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (219, N'Chestnut Drive Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (220, N'CHIJ Katong Convent')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (221, N'CHIJ Sec (Toa Payoh)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (222, N'CHIJ St. Joseph''s Convent')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (223, N'CHIJ St. Nicholas Girls'' Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (224, N'CHIJ St. Theresa''s Convent')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (225, N'Chong Boon Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (226, N'Christ Church Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (227, N'Chua Chu Kang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (228, N'Chung Cheng High Sch (Main)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (229, N'Chung Cheng High Sch (Yishun)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (230, N'Clementi Town Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (231, N'Clementi Woods Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (232, N'Commonwealth Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (233, N'Compassvale Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (234, N'Coral Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (235, N'Crescent Girls'' Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (236, N'Damai Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (237, N'Deyi Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (238, N'Dunearn Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (239, N'Dunman High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (240, N'Dunman Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (241, N'East Spring Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (242, N'East View Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (243, N'Edgefield Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (244, N'Evergreen Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (245, N'Fairfield Methodist Sch (Sec)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (246, N'Fairfield Methodist Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (247, N'Fajar Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (248, N'First Toa Payoh Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (249, N'Fuchun Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (250, N'Fuhua Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (251, N'Gan Eng Seng Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (252, N'Geylang Methodist Sch (Sec)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (253, N'Greendale Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (254, N'Greenridge Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (255, N'Greenview Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (256, N'Guangyang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (257, N'Hai Sing Catholic Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (258, N'Henderson Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (259, N'Hillgrove Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (260, N'Holy Innocents'' High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (261, N'Hong Kah Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (262, N'Hougang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (263, N'Hua Yi Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (264, N'Junyuan Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (265, N'Jurong Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (266, N'Jurong West Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (267, N'Jurongville Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (268, N'Juying Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (269, N'Kent Ridge Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (270, N'Kranji Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (271, N'Kuo Chuan Presbyterian Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (272, N'Loyang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (273, N'MacPherson Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (274, N'Manjusri Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (275, N'Maris Stella High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (276, N'Marsiling Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (277, N'Mayflower Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (278, N'Montfort Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (279, N'Nan Chiau High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (280, N'Nan Hua High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (281, N'Naval Base Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (282, N'New Town Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (283, N'Ngee Ann Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (284, N'North View Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (285, N'North Vista Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (286, N'Northbrooks Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (287, N'Northland Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (288, N'Orchid Park Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (289, N'Outram Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (290, N'Pasir Ris Crest Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (291, N'Pasir Ris Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (292, N'Paya Lebar Methodist Girls'' Sch (Sec)')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (293, N'Pei Hwa Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (294, N'Peicai Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (295, N'Peirce Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (296, N'Ping Yi Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (297, N'Pioneer Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (298, N'Presbyterian High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (299, N'Punggol Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (300, N'Queenstown Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (301, N'Queensway Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (302, N'Regent Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (303, N'River Valley High Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (304, N'Riverside Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (305, N'Sembawang Sec Sch')
GO
print 'Processed 300 total records'
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (306, N'Seng Kang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (307, N'Serangoon Garden Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (308, N'Serangoon Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (309, N'Shuqun Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (310, N'Si Ling Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (311, N'Siglap Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (312, N'Springfield Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (313, N'St. Andrew''s Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (314, N'St. Anthony''s Canossian Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (315, N'St. Gabriel''s Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (316, N'St. Hilda''s Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (317, N'St. Margaret''s Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (318, N'St. Patrick''s Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (319, N'Swiss Cottage Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (320, N'Tampines Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (321, N'Tanglin Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (322, N'Tanjong Katong Girls'' Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (323, N'Tanjong Katong Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (324, N'Teck Whye Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (325, N'Temasek Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (326, N'Unity Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (327, N'Victoria Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (328, N'West Spring Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (329, N'Westwood Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (330, N'Whitley Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (331, N'Woodgrove Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (332, N'Woodlands Ring Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (333, N'Woodlands Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (334, N'Xinmin Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (335, N'Yio Chu Kang Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (336, N'Yishun Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (337, N'Yishun Town Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (338, N'Yuan Ching Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (339, N'Yuhua Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (340, N'Yusof Ishak Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (341, N'Yuying Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (342, N'Zhenghua Sec Sch')
INSERT [dbo].[tb_school] ([SchoolID], [SchoolName]) VALUES (343, N'Zhonghua Sec Sch')
SET IDENTITY_INSERT [dbo].[tb_school] OFF
/****** Object:  Table [dbo].[tb_Salutation]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_Salutation](
	[SalutationID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SalutationName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tb_Salutation] PRIMARY KEY CLUSTERED 
(
	[SalutationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tb_Salutation] ON
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (1, N'Mr')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (2, N'Mrs')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (3, N'Miss')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (4, N'Dr')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (5, N'Prof')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (7, N'Mdm')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (8, N'A/Prof')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (9, N'Revd')
INSERT [dbo].[tb_Salutation] ([SalutationID], [SalutationName]) VALUES (11, N'Ms')
SET IDENTITY_INSERT [dbo].[tb_Salutation] OFF
/****** Object:  Table [dbo].[tb_Roles_Users]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_Roles_Users](
	[RoleID] [int] NOT NULL,
	[UserID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tb_Roles_Users] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tb_Roles_Users] ([RoleID], [UserID]) VALUES (1, N'gohks')
/****** Object:  Table [dbo].[tb_Roles_ModulesFunctionsAccessRight]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight](
	[RoleID] [int] NOT NULL,
	[functionID] [int] NOT NULL,
 CONSTRAINT [PK_tb_Roles_ModulesFunctionsAccessRight] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC,
	[functionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 1)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 38)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 39)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 40)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 41)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 42)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 43)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 44)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 45)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 46)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 47)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 48)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 49)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 50)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 51)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 52)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 56)
INSERT [dbo].[tb_Roles_ModulesFunctionsAccessRight] ([RoleID], [functionID]) VALUES (1, 57)
/****** Object:  Table [dbo].[tb_Roles_AMF_AccessRights]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_Roles_AMF_AccessRights](
	[RoleID] [int] NOT NULL,
	[AppModFuncID] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tb_Roles_AMF_AccessRights] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC,
	[AppModFuncID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (-1, N'1.7.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (-1, N'1.7.2')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (-1, N'1.7.3')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.2')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.3')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.4')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.5')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.6')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.7')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.8')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.1.9')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.2.3')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.2.4')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.10')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.4')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.5')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.6')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.7')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.9')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.3.99')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.4.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.4.2')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.4.3')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.4.4')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.5.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.5.2')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.5.3')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.5.4')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.6.1')
INSERT [dbo].[tb_Roles_AMF_AccessRights] ([RoleID], [AppModFuncID]) VALUES (1, N'1.6.2')
/****** Object:  Table [dbo].[tb_members_attachments]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_members_attachments](
	[AttachmentID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[NRIC] [varchar](20) NOT NULL,
	[GUID] [varchar](50) NOT NULL,
	[Filename] [varchar](200) NOT NULL,
	[FileType] [tinyint] NOT NULL,
	[Remarks] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_tb_member_attachments] PRIMARY KEY CLUSTERED 
(
	[AttachmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course_participant]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course_participant](
	[NRIC] [varchar](10) NOT NULL,
	[courseID] [int] NOT NULL,
	[feePaid] [bit] NOT NULL,
	[materialReceived] [bit] NOT NULL,
	[RegistrationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_tb_course_participant] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC,
	[courseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_removeCourse]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeCourse]
(@CourseID INT)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_course WHERE courseID = @CourseID)
BEGIN
	UPDATE dbo.tb_course SET Deleted = 1 WHERE courseID = @CourseID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeCellgroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeCellgroup]
(@CellgroupID INT)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_cellgroup WHERE CellgroupID = @CellgroupID)
BEGIN
	UPDATE dbo.tb_cellgroup SET Deleted = 1 WHERE CellgroupID = @CellgroupID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_searchCityKidsForUpdate]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_searchCityKidsForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50),
 @BusGroup VARCHAR(3),
 @ClubGroup VARCHAR(3),
 @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%' OR A.Name LIKE '%'+@Name+'%'	
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@NRIC) > 0 AND LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@NRIC) = 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.Name LIKE '%'+@Name+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0 AND LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup) AND A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	ORDER BY Name, NRIC
END


SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_resetUserPassword]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_resetUserPassword]
(@UserID VARCHAR(50),
 @Password VARCHAR(40))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET [Password] = @Password WHERE UserID = @UserID

SELECT @@ROWCOUNT;

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeUser]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeUser]
(@USERID VARCHAR(50))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_Users WHERE UserID = @USERID)
BEGIN
	DELETE FROM dbo.tb_Users WHERE UserID = @USERID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeMinistry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeMinistry]
(@MinistryID INT)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_ministry WHERE MinistryID = @MinistryID)
BEGIN
	UPDATE dbo.tb_ministry SET Deleted = 1 WHERE MinistryID = @MinistryID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_searchName]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_searchName]
(@searchText VARCHAR(100))
 
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

SELECT (select ISNULL(B.ICPhoto,'') AS ICPhoto, ISNULL(Name,'') + ISNULL(B.EnglishName,'') AS Name, ISNULL(A.NRIC,'') + ISNULL(B.NRIC,'') AS NRIC, ISNULL(A.Email,'') + ISNULL(B.Email,'') + ' ' AS Email from dbo.tb_Users AS A
Full JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
WHERE A.Name like '%'+@searchText+'%' OR B.EnglishName like '%'+@searchText+'%' AND B.CurrentParish = @CurrentParish
ORDER BY ISNULL(Name,'') + ISNULL(B.EnglishName,'') ASC
FOR XML PATH('found'), Elements, Root('Root')) AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_searchVisitorsForUpdate]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_searchVisitorsForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email 
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE NRIC LIKE '%'+@NRIC+'%' OR EnglishName LIKE '%'+@Name+'%'
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email  
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE NRIC LIKE '%'+@NRIC+'%'
END
ELSE
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE EnglishName LIKE '%'+@Name+'%'
	ORDER BY Name
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateChurchArea]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateChurchArea]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (AreaID VARCHAR(10), AreaName VARCHAR(100))
	INSERT INTO @table(AreaID, AreaName)
	Select AreaID, AreaName
	from OpenXml(@xdoc, '/ChurchArea/*')
	with (
	AreaID VARCHAR(10) './AreaID',
	AreaName VARCHAR(100) './AreaName') WHERE AreaID <> 'New';		
	
	UPDATE dbo.tb_churchArea SET dbo.tb_churchArea.AreaName = a.AreaName
	from @table AS a WHERE a.AreaID <> 'New' AND dbo.tb_churchArea.AreaID = a.AreaID; 
	
	DELETE FROM @table WHERE AreaID = 'New'
	
	
	if EXISTS(SELECT 1 FROM dbo.tb_churchArea 
				WHERE AreaID IN (SELECT DISTINCT CourseLocation FROM dbo.tb_course)
				AND AreaID NOT IN (Select AreaID FROM @table))
	BEGIN
		
		INSERT INTO dbo.tb_churchArea (AreaName)
		Select AreaName
		from OpenXml(@xdoc, '/ChurchArea/*')
		with (
		AreaID VARCHAR(10) './AreaID',
		AreaName VARCHAR(100) './AreaName') WHERE AreaID = 'New';
	
		SELECT 'Unable to delete, area still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_churchArea 
		WHERE AreaID NOT IN (SELECT DISTINCT CourseLocation FROM dbo.tb_course)
		AND AreaID NOT IN (Select AreaID FROM @table)
		
		INSERT INTO dbo.tb_churchArea (AreaName)
		Select AreaName
		from OpenXml(@xdoc, '/ChurchArea/*')
		with (
		AreaID VARCHAR(10) './AreaID',
		AreaName VARCHAR(100) './AreaName') WHERE AreaID = 'New';
		
		SELECT 'Area updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCellgroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCellgroup]
(@cellgroupid INT,
 @cellgroupname VARCHAR(50),
 @incharge VARCHAR(10),
 @postalCode INT,
 @blkhouse VARCHAR(10),
 @streetAddress VARCHAR(100),
 @unit VARCHAR(10))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_cellgroup SET CellgroupName = @cellgroupname, CellgroupLeader = @incharge, PostalCode = @postalCode, StreetAddress = @streetAddress, BLKHouse = @blkhouse, Unit = @unit
       WHERE CellgroupID = @cellgroupid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateBusGroupCluster]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateBusGroupCluster]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (BusGroupClusterID VARCHAR(10), BusGroupClusterName VARCHAR(100))
	INSERT INTO @table(BusGroupClusterID, BusGroupClusterName)
	Select BusGroupClusterID, BusGroupClusterName
	from OpenXml(@xdoc, '/BusGroupCluster/*')
	with (
	BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
	BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID <> 'New';		
	
	UPDATE dbo.tb_BusGroup_Cluster SET dbo.tb_BusGroup_Cluster.BusGroupClusterName = a.BusGroupClusterName
	from @table AS a WHERE a.BusGroupClusterID <> 'New' AND dbo.tb_BusGroup_Cluster.BusGroupClusterID = a.BusGroupClusterID; 
	
	DELETE FROM @table WHERE BusGroupClusterID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_BusGroup_Cluster 
				WHERE BusGroupClusterID IN (SELECT DISTINCT BusGroupCluster FROM dbo.tb_ccc_kids)
				AND BusGroupClusterID NOT IN (Select BusGroupClusterID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_BusGroup_Cluster (BusGroupClusterName)
		Select BusGroupClusterName
		from OpenXml(@xdoc, '/BusGroupCluster/*')
		with (
		BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
		BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID = 'New';
	
		SELECT 'Unable to delete, BusGroupCluster still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_BusGroup_Cluster 
		WHERE BusGroupClusterID NOT IN (SELECT DISTINCT BusGroupCluster FROM dbo.tb_ccc_kids)
		AND BusGroupClusterID NOT IN (Select BusGroupClusterID FROM @table)
		
		INSERT INTO dbo.tb_BusGroup_Cluster (BusGroupClusterName)
		Select BusGroupClusterName
		from OpenXml(@xdoc, '/BusGroupCluster/*')
		with (
		BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
		BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID = 'New';
		
		SELECT 'BusGroupCluster updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateFamilyType]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateFamilyType]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (FamilyTypeID VARCHAR(10), FamilyTypeName VARCHAR(200))
	INSERT INTO @table(FamilyTypeID, FamilyTypeName)
	Select FamilyTypeID, FamilyTypeName
	from OpenXml(@xdoc, '/FamilyType/*')
	with (
	FamilyTypeID VARCHAR(10) './FamilyTypeID',
	FamilyTypeName VARCHAR(200) './FamilyTypeName') WHERE FamilyTypeID <> 'New';		
	
	UPDATE dbo.tb_FamilyType SET dbo.tb_FamilyType.FamilyType = a.FamilyTypeName
	from @table AS a WHERE a.FamilyTypeID <> 'New' AND dbo.tb_FamilyType.FamilyTypeID = a.FamilyTypeID; 
	
	DELETE FROM @table WHERE FamilyTypeID = 'New'
	
	
	DELETE FROM dbo.tb_FamilyType 
	WHERE FamilyTypeID NOT IN (Select FamilyTypeID FROM @table)
	
	INSERT INTO dbo.tb_FamilyType (FamilyType)
	Select FamilyTypeName
	from OpenXml(@xdoc, '/FamilyType/*')
	with (
	FamilyTypeID VARCHAR(10) './FamilyTypeID',
	FamilyTypeName VARCHAR(200) './FamilyTypeName') WHERE FamilyTypeID = 'New';
	
	SELECT 'FamilyType updated.' AS Result
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateEmail]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateEmail]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (EmailID VARCHAR(10), EmailContent VARCHAR(MAX))
	INSERT INTO @table(EmailID, EmailContent)
	Select EmailID, EmailContent
	from OpenXml(@xdoc, '/ChurchEmail/*')
	with (
	EmailID VARCHAR(10) './EmailID',
	EmailContent VARCHAR(MAX) './EmailContent');		
	
	UPDATE dbo.tb_emailContent SET dbo.tb_emailContent.EmailContent = A.EmailContent
	FROM @table AS A
	WHERE A.EmailID = dbo.tb_emailContent.EmailID
	
	SELECT 'Email updated.' AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateEducation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateEducation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (EducationID VARCHAR(10), EducationName VARCHAR(100))
	INSERT INTO @table(EducationID, EducationName)
	Select EducationID, EducationName
	from OpenXml(@xdoc, '/ChurchEducation/*')
	with (
	EducationID VARCHAR(10) './EducationID',
	EducationName VARCHAR(100) './EducationName') WHERE EducationID <> 'New';		
	
	UPDATE dbo.tb_education SET dbo.tb_education.EducationName = a.EducationName
	from @table AS a WHERE a.EducationID <> 'New' AND dbo.tb_education.EducationID = a.EducationID; 
	
	DELETE FROM @table WHERE EducationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_members)
				AND EducationID NOT IN (Select EducationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_members_temp)
				AND EducationID NOT IN (Select EducationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_visitors)
				AND EducationID NOT IN (Select EducationID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_education (EducationName)
		Select EducationName
		from OpenXml(@xdoc, '/ChurchEducation/*')
		with (
		EducationID VARCHAR(10) './EducationID',
		EducationName VARCHAR(100) './EducationName') WHERE EducationID = 'New';
	
		SELECT 'Unable to delete, Education still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_education 
		WHERE EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_members)
		AND EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_members_temp)
		AND EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_visitors)
		AND EducationID NOT IN (Select EducationID FROM @table)
		
		INSERT INTO dbo.tb_education (EducationName)
		Select EducationName
		from OpenXml(@xdoc, '/ChurchEducation/*')
		with (
		EducationID VARCHAR(10) './EducationID',
		EducationName VARCHAR(100) './EducationName') WHERE EducationID = 'New';
		
		SELECT 'Education updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateDialect]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateDialect]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (DialectID VARCHAR(10), DialectName VARCHAR(100))
	INSERT INTO @table(DialectID, DialectName)
	Select DialectID, DialectName
	from OpenXml(@xdoc, '/ChurchDialect/*')
	with (
	DialectID VARCHAR(10) './DialectID',
	DialectName VARCHAR(100) './DialectName') WHERE DialectID <> 'New';		
	
	UPDATE dbo.tb_dialect SET dbo.tb_dialect.DialectName = a.DialectName
	from @table AS a WHERE a.DialectID <> 'New' AND dbo.tb_dialect.DialectID = a.DialectID; 
	
	DELETE FROM @table WHERE DialectID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_dialect 
				WHERE DialectID IN (SELECT DISTINCT Dialect FROM dbo.tb_members)
				AND DialectID NOT IN (Select DialectID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_dialect 
				WHERE DialectID IN (SELECT DISTINCT Dialect FROM dbo.tb_members_temp)
				AND DialectID NOT IN (Select DialectID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_dialect (DialectName)
		Select DialectName
		from OpenXml(@xdoc, '/ChurchDialect/*')
		with (
		DialectID VARCHAR(10) './DialectID',
		DialectName VARCHAR(100) './DialectName') WHERE DialectID = 'New';
	
		SELECT 'Unable to delete, dialect still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_dialect 
		WHERE DialectID NOT IN (SELECT DISTINCT Dialect FROM dbo.tb_members)
		AND DialectID NOT IN (SELECT DISTINCT Dialect FROM dbo.tb_members_temp)
		AND DialectID NOT IN (Select DialectID FROM @table)
		
		INSERT INTO dbo.tb_dialect (DialectName)
		Select DialectName
		from OpenXml(@xdoc, '/ChurchDialect/*')
		with (
		DialectID VARCHAR(10) './DialectID',
		DialectName VARCHAR(100) './DialectName') WHERE DialectID = 'New';
		
		SELECT 'Dialect updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateConfig]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateConfig]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ConfigID VARCHAR(10), value VARCHAR(1000))
	INSERT INTO @table(ConfigID, value)
	Select ConfigID, value
	from OpenXml(@xdoc, '/ChurchConfig/*')
	with (
	ConfigID VARCHAR(10) './ConfigID',
	value VARCHAR(1000) './value');		
	
	UPDATE dbo.tb_App_Config SET dbo.tb_App_Config.value = A.value
	FROM @table AS A
	WHERE A.ConfigID = dbo.tb_App_Config.ConfigID
	
	SELECT 'Config updated.' AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateClubGroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateClubGroup]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ClubGroupID VARCHAR(10), ClubGroupName VARCHAR(100))
	INSERT INTO @table(ClubGroupID, ClubGroupName)
	Select ClubGroupID, ClubGroupName
	from OpenXml(@xdoc, '/ClubGroup/*')
	with (
	ClubGroupID VARCHAR(10) './ClubGroupID',
	ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID <> 'New';		
	
	UPDATE dbo.tb_clubgroup SET dbo.tb_clubgroup.ClubGroupName = a.ClubGroupName
	from @table AS a WHERE a.ClubGroupID <> 'New' AND dbo.tb_clubgroup.ClubGroupID = a.ClubGroupID; 
	
	DELETE FROM @table WHERE ClubGroupID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_clubgroup 
				WHERE ClubGroupID IN (SELECT DISTINCT ClubGroup FROM dbo.tb_ccc_kids)
				AND ClubGroupID NOT IN (Select ClubGroupID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_clubgroup (ClubGroupName)
		Select ClubGroupName
		from OpenXml(@xdoc, '/ClubGroup/*')
		with (
		ClubGroupID VARCHAR(10) './ClubGroupID',
		ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID = 'New';
	
		SELECT 'Unable to delete, ClubGroup still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_clubgroup 
		WHERE ClubGroupID NOT IN (SELECT DISTINCT ClubGroup FROM dbo.tb_ccc_kids)
		AND ClubGroupID NOT IN (Select ClubGroupID FROM @table)
		
		INSERT INTO dbo.tb_clubgroup (ClubGroupName)
		Select ClubGroupName
		from OpenXml(@xdoc, '/ClubGroup/*')
		with (
		ClubGroupID VARCHAR(10) './ClubGroupID',
		ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID = 'New';
		
		SELECT 'ClubGroup updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCityKidsPoints]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCityKidsPoints]
(@XML XML, @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;

DECLARE @kidtable TABLE (NRIC VARCHAR(20), [Type] VARCHAR(1), Points INT, Remarks VARCHAR(1000));

INSERT INTO @kidtable (NRIC, [Type], Points, Remarks)
SELECT NRIC, [Type], Points, Remarks
FROM OPENXML(@idoc, '/UpdateCityKidPoints/Kid')
	WITH (
	NRIC VARCHAR(20)'./NRIC',
	[Type] VARCHAR(1)'./Type',
	Points INT'./Points',
	Remarks VARCHAR(1000)'./Remarks');

UPDATE dbo.tb_ccc_kids
SET dbo.tb_ccc_kids.Points = A.Points + dbo.tb_ccc_kids.Points    
FROM @kidtable AS A
WHERE A.NRIC = dbo.tb_ccc_kids.NRIC AND A.[Type] = '+';

UPDATE dbo.tb_ccc_kids
SET dbo.tb_ccc_kids.Points = dbo.tb_ccc_kids.Points - A.Points
FROM @kidtable AS A
WHERE A.NRIC = dbo.tb_ccc_kids.NRIC AND A.[Type] = '-';

UPDATE dbo.tb_ccc_kids
SET Points = 0 WHERE Points < 0

INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
SELECT 'I', @UserID,  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Added</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),Points) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>' + Remarks + '</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', NRIC
FROM @kidtable WHERE [Type] = '+'

INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
SELECT 'I', @UserID,  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Deducted</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),Points) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>' + Remarks + '</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', NRIC
FROM @kidtable WHERE [Type] = '-'


SET NOCOUNT OFF;

-- [dbo].[usp_UpdateCityKidsPoints] ''
GO
/****** Object:  StoredProcedure [dbo].[usp_updateCityKidSchedule]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_updateCityKidSchedule]
(@CourseID INT,
@Schedule VARCHAR(MAX))
AS
SET NOCOUNT ON;

DECLARE @schTable TABLE([Date] DATE)
INSERT INTO @schTable([Date])
SELECT CONVERT(DATE, ITEMS, 103) FROM dbo.udf_Split(@Schedule, ',')

DELETE FROM dbo.tb_course_schedule WHERE [Date] NOT IN (SELECT DISTINCT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @CourseID) AND [Date] NOT IN(SELECT [Date] FROM @schTable) AND [Date] >= CONVERT(DATE, GETDATE()) AND CourseID = @CourseID

INSERT INTO dbo.tb_course_schedule([Date], CourseID)
SELECT [DATE], @CourseID FROM @schTable WHERE [Date] NOT IN(SELECT [Date] FROM dbo.tb_course_schedule WHERE CourseID = @CourseID AND [Date] >= CONVERT(DATE, GETDATE()))

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourse]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourse]
(@courseid INT,
 @coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT)
AS
SET NOCOUNT ON;

UPDATE dbo.tb_course SET CourseName = @coursename, CourseStartDate = @startdate,
	   CourseStartTime = @starttime, CourseEndTime = @endtime, CourseInCharge = @incharge, CourseLocation = @location
       WHERE courseID = @courseid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCountry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCountry]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (CountryID VARCHAR(10), CountryName VARCHAR(100))
	INSERT INTO @table(CountryID, CountryName)
	Select CountryID, CountryName
	from OpenXml(@xdoc, '/ChurchCountry/*')
	with (
	CountryID VARCHAR(10) './CountryID',
	CountryName VARCHAR(100) './CountryName') WHERE CountryID <> 'New';		
	
	UPDATE dbo.tb_country SET dbo.tb_country.CountryName = a.CountryName
	from @table AS a WHERE a.CountryID <> 'New' AND dbo.tb_country.CountryID = a.CountryID; 
	
	DELETE FROM @table WHERE CountryID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_members)
				AND CountryID NOT IN (Select CountryID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_members_temp)
				AND CountryID NOT IN (Select CountryID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_visitors)
				AND CountryID NOT IN (Select CountryID FROM @table))				
	BEGIN
		
		INSERT INTO dbo.tb_country (CountryName)
		Select CountryName
		from OpenXml(@xdoc, '/ChurchCountry/*')
		with (
		CountryID VARCHAR(10) './CountryID',
		CountryName VARCHAR(100) './CountryName') WHERE CountryID = 'New';
	
		SELECT 'Unable to delete, country still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_country 
		WHERE CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_members)
		AND CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_members_temp)
		AND CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_visitors)
		AND CountryID NOT IN (Select CountryID FROM @table)
		
		INSERT INTO dbo.tb_country (CountryName)
		Select CountryName
		from OpenXml(@xdoc, '/ChurchCountry/*')
		with (
		CountryID VARCHAR(10) './CountryID',
		CountryName VARCHAR(100) './CountryName') WHERE CountryID = 'New';
		
		SELECT 'Country updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateMaritalStatus]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateMaritalStatus]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (MaritalStatusID VARCHAR(10), MaritalStatusName VARCHAR(100))
	INSERT INTO @table(MaritalStatusID, MaritalStatusName)
	Select MaritalStatusID, MaritalStatusName
	from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
	with (
	MaritalStatusID VARCHAR(10) './MaritalStatusID',
	MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID <> 'New';		
	
	UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = a.MaritalStatusName
	from @table AS a WHERE a.MaritalStatusID <> 'New' AND dbo.tb_maritalstatus.MaritalStatusID = a.MaritalStatusID; 
	
	DELETE FROM @table WHERE MaritalStatusID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_maritalstatus 
				WHERE MaritalStatusID IN (SELECT DISTINCT MaritalStatus FROM tb_members)
				AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_maritalstatus 
				WHERE MaritalStatusID IN (SELECT DISTINCT MaritalStatus FROM tb_members_temp)
				AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_maritalstatus (MaritalStatusName)
		Select MaritalStatusName
		from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
		with (
		MaritalStatusID VARCHAR(10) './MaritalStatusID',
		MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID = 'New';
	
		SELECT 'Unable to delete, Marital Status still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_maritalstatus 
		WHERE MaritalStatusID NOT IN (SELECT DISTINCT MaritalStatus FROM tb_members)
		AND MaritalStatusID NOT IN (SELECT DISTINCT MaritalStatus FROM tb_members_temp)
		AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table)
		
		INSERT INTO dbo.tb_maritalstatus (MaritalStatusName)
		Select MaritalStatusName
		from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
		with (
		MaritalStatusID VARCHAR(10) './MaritalStatusID',
		MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID = 'New';
		
		SELECT 'MaritalStatus updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateLanguage]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateLanguage]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (LanguageID VARCHAR(10), LanguageName VARCHAR(100))
	INSERT INTO @table(LanguageID, LanguageName)
	Select LanguageID, LanguageName
	from OpenXml(@xdoc, '/ChurchLanguage/*')
	with (
	LanguageID VARCHAR(10) './LanguageID',
	LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID <> 'New';		
	
	UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = a.LanguageName
	from @table AS a WHERE a.LanguageID <> 'New' AND dbo.tb_language.LanguageID = a.LanguageID; 
	
	DELETE FROM @table WHERE LanguageID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_language 
				WHERE LanguageID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
				AND LanguageID NOT IN (Select LanguageID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_language 
				WHERE LanguageID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members_temp FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
				AND LanguageID NOT IN (Select LanguageID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_language (LanguageName)
		Select LanguageName
		from OpenXml(@xdoc, '/ChurchLanguage/*')
		with (
		LanguageID VARCHAR(10) './LanguageID',
		LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID = 'New';
	
		SELECT 'Unable to delete, Language still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Language 
		WHERE LanguageID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
		AND LanguageID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members_temp FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
		AND LanguageID NOT IN (Select LanguageID FROM @table)
		
		INSERT INTO dbo.tb_Language (LanguageName)
		Select LanguageName
		from OpenXml(@xdoc, '/ChurchLanguage/*')
		with (
		LanguageID VARCHAR(10) './LanguageID',
		LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID = 'New';
		
		SELECT 'Language updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateReligion]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateReligion]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ReligionID VARCHAR(10), ReligionName VARCHAR(100))
	INSERT INTO @table(ReligionID, ReligionName)
	Select ReligionID, ReligionName
	from OpenXml(@xdoc, '/Religion/*')
	with (
	ReligionID VARCHAR(10) './ReligionID',
	ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID <> 'New';		
	
	UPDATE dbo.tb_Religion SET dbo.tb_Religion.ReligionName = a.ReligionName
	from @table AS a WHERE a.ReligionID <> 'New' AND dbo.tb_Religion.ReligionID = a.ReligionID; 
	
	DELETE FROM @table WHERE ReligionID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Religion 
				WHERE ReligionID IN (SELECT DISTINCT Religion FROM dbo.tb_ccc_kids)
				AND ReligionID NOT IN (Select ReligionID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_Religion (ReligionName)
		Select ReligionName
		from OpenXml(@xdoc, '/Religion/*')
		with (
		ReligionID VARCHAR(10) './ReligionID',
		ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID = 'New';
	
		SELECT 'Unable to delete, Religion still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Religion 
		WHERE ReligionID NOT IN (SELECT DISTINCT Religion FROM dbo.tb_ccc_kids)
		AND ReligionID NOT IN (Select ReligionID FROM @table)
		
		INSERT INTO dbo.tb_Religion (ReligionName)
		Select ReligionName
		from OpenXml(@xdoc, '/Religion/*')
		with (
		ReligionID VARCHAR(10) './ReligionID',
		ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID = 'New';
		
		SELECT 'Religion updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateRace]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRace]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (RaceID VARCHAR(10), RaceName VARCHAR(100))
	INSERT INTO @table(RaceID, RaceName)
	Select RaceID, RaceName
	from OpenXml(@xdoc, '/Race/*')
	with (
	RaceID VARCHAR(10) './RaceID',
	RaceName VARCHAR(100) './RaceName') WHERE RaceID <> 'New';		
	
	UPDATE dbo.tb_Race SET dbo.tb_Race.RaceName = a.RaceName
	from @table AS a WHERE a.RaceID <> 'New' AND dbo.tb_Race.RaceID = a.RaceID; 
	
	DELETE FROM @table WHERE RaceID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Race 
				WHERE RaceID IN (SELECT DISTINCT Race FROM dbo.tb_ccc_kids)
				AND RaceID NOT IN (Select RaceID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_Race (RaceName)
		Select RaceName
		from OpenXml(@xdoc, '/Race/*')
		with (
		RaceID VARCHAR(10) './RaceID',
		RaceName VARCHAR(100) './RaceName') WHERE RaceID = 'New';
	
		SELECT 'Unable to delete, Race still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Race 
		WHERE RaceID NOT IN (SELECT DISTINCT Race FROM dbo.tb_ccc_kids)
		AND RaceID NOT IN (Select RaceID FROM @table)
		
		INSERT INTO dbo.tb_Race (RaceName)
		Select RaceName
		from OpenXml(@xdoc, '/Race/*')
		with (
		RaceID VARCHAR(10) './RaceID',
		RaceName VARCHAR(100) './RaceName') WHERE RaceID = 'New';
		
		SELECT 'Race updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdatePostal]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdatePostal]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (DISTRICT INT, PostalAreaName VARCHAR(200), PostalDigit VARCHAR(200))
	DECLARE @newtable AS TABLE (DISTRICT INT, PostalAreaName VARCHAR(200), PostalDigit VARCHAR(200))
	
	INSERT INTO @table(DISTRICT, PostalAreaName, PostalDigit)
	Select DISTRICT, PostalAreaName, PostalDigit
	from OpenXml(@xdoc, '/ChurchPostal/*')
	with (
	DISTRICT VARCHAR(10) './PostalID',
	PostalAreaName VARCHAR(200) './PostalName',
	PostalDigit VARCHAR(200) './Postalvalue') WHERE DISTRICT <> 'New';		
	
	UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.PostalAreaName, dbo.tb_postalArea.PostalDigit = A.PostalDigit
	FROM @table AS A
	WHERE A.DISTRICT = dbo.tb_postalArea.District 
	
	DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT DISTRICT FROM @table)
	
	INSERT INTO dbo.tb_postalArea(PostalAreaName, PostalDigit)
	Select PostalAreaName, PostalDigit
	from OpenXml(@xdoc, '/ChurchPostal/*')
	with (
	DISTRICT VARCHAR(10) './PostalID',
	PostalAreaName VARCHAR(200) './PostalName',
	PostalDigit VARCHAR(200) './Postalvalue') WHERE DISTRICT = 'New';
	
	SELECT 'Postal updated.' AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateParish]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateParish]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ParishID VARCHAR(10), ParishName VARCHAR(100))
	INSERT INTO @table(ParishID, ParishName)
	Select ParishID, ParishName
	from OpenXml(@xdoc, '/ChurchParish/*')
	with (
	ParishID VARCHAR(10) './ParishID',
	ParishName VARCHAR(100) './ParishName') WHERE ParishID <> 'New';		
	
	UPDATE dbo.tb_parish SET dbo.tb_parish.ParishName = a.ParishName
	from @table AS a WHERE a.ParishID <> 'New' AND dbo.tb_Parish.ParishID = a.ParishID; 
	
	DELETE FROM @table WHERE ParishID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_parish 
				WHERE ParishID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
				AND ParishID NOT IN (Select ParishID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_Parish 
				WHERE ParishID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members_temp FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
				AND ParishID NOT IN (Select ParishID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_parish (ParishName)
		Select ParishName
		from OpenXml(@xdoc, '/ChurchParish/*')
		with (
		ParishID VARCHAR(10) './ParishID',
		ParishName VARCHAR(100) './ParishName') WHERE ParishID = 'New';
	
		SELECT 'Unable to delete, Parish still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_parish 
		WHERE ParishID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members_temp FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
		AND ParishID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
		AND ParishID NOT IN (Select ParishID FROM @table)
		
		INSERT INTO dbo.tb_parish (ParishName)
		Select ParishName
		from OpenXml(@xdoc, '/ChurchParish/*')
		with (
		ParishID VARCHAR(10) './ParishID',
		ParishName VARCHAR(100) './ParishName') WHERE ParishID = 'New';
		
		SELECT 'Parish updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateOccupation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateOccupation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (OccupationID VARCHAR(10), OccupationName VARCHAR(100))
	INSERT INTO @table(OccupationID, OccupationName)
	Select OccupationID, OccupationName
	from OpenXml(@xdoc, '/ChurchOccupation/*')
	with (
	OccupationID VARCHAR(10) './OccupationID',
	OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID <> 'New';		
	
	UPDATE dbo.tb_occupation SET dbo.tb_Occupation.OccupationName = a.OccupationName
	from @table AS a WHERE a.OccupationID <> 'New' AND dbo.tb_Occupation.OccupationID = a.OccupationID; 
	
	DELETE FROM @table WHERE OccupationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_members)
				AND OccupationID NOT IN (Select OccupationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_members_temp)
				AND OccupationID NOT IN (Select OccupationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_visitors)
				AND OccupationID NOT IN (Select OccupationID FROM @table))				
	BEGIN
		
		INSERT INTO dbo.tb_occupation (OccupationName)
		Select OccupationName
		from OpenXml(@xdoc, '/ChurchOccupation/*')
		with (
		OccupationID VARCHAR(10) './OccupationID',
		OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID = 'New';
	
		SELECT 'Unable to delete, Occupation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_occupation 
		WHERE OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_members)
		AND OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_members_temp)
		AND OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_visitors)
		AND OccupationID NOT IN (Select OccupationID FROM @table)
		
		INSERT INTO dbo.tb_occupation (OccupationName)
		Select OccupationName
		from OpenXml(@xdoc, '/ChurchOccupation/*')
		with (
		OccupationID VARCHAR(10) './OccupationID',
		OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID = 'New';
		
		SELECT 'Occupation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateStyle]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateStyle]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (StyleID VARCHAR(10), StyleName VARCHAR(100))
	INSERT INTO @table(StyleID, StyleName)
	Select StyleID, StyleName
	from OpenXml(@xdoc, '/ChurchStyle/*')
	with (
	StyleID VARCHAR(10) './StyleID',
	StyleName VARCHAR(100) './StyleName') WHERE StyleID <> 'New';		
	
	UPDATE dbo.tb_Style SET dbo.tb_Style.StyleName = a.StyleName
	from @table AS a WHERE a.StyleID <> 'New' AND dbo.tb_Style.StyleID = a.StyleID; 
	
	DELETE FROM @table WHERE StyleID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Style 
				WHERE StyleID IN (SELECT DISTINCT Style FROM dbo.tb_Users)
				AND StyleID NOT IN (Select StyleID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_Style (StyleName)
		Select StyleName
		from OpenXml(@xdoc, '/ChurchStyle/*')
		with (
		StyleID VARCHAR(10) './StyleID',
		StyleName VARCHAR(100) './StyleName') WHERE StyleID = 'New';
	
		SELECT 'Unable to delete, Style still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Style 
		WHERE StyleID NOT IN (SELECT DISTINCT ISNULL(Style,0) FROM dbo.tb_Users)
		AND StyleID NOT IN (Select StyleID FROM @table)
		
		INSERT INTO dbo.tb_Style (StyleName)
		Select StyleName
		from OpenXml(@xdoc, '/ChurchStyle/*')
		with (
		StyleID VARCHAR(10) './StyleID',
		StyleName VARCHAR(100) './StyleName') WHERE StyleID = 'New';
		
		SELECT 'Style updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateSchool]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSchool]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (SchoolID VARCHAR(10), SchoolName VARCHAR(100))
	INSERT INTO @table(SchoolID, SchoolName)
	Select SchoolID, SchoolName
	from OpenXml(@xdoc, '/School/*')
	with (
	SchoolID VARCHAR(10) './SchoolID',
	SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID <> 'New';		
	
	UPDATE dbo.tb_School SET dbo.tb_School.SchoolName = a.SchoolName
	from @table AS a WHERE a.SchoolID <> 'New' AND dbo.tb_School.SchoolID = a.SchoolID; 
	
	DELETE FROM @table WHERE SchoolID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_School 
				WHERE SchoolID IN (SELECT DISTINCT School FROM dbo.tb_ccc_kids)
				AND SchoolID NOT IN (Select SchoolID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_School (SchoolName)
		Select SchoolName
		from OpenXml(@xdoc, '/School/*')
		with (
		SchoolID VARCHAR(10) './SchoolID',
		SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID = 'New';
	
		SELECT 'Unable to delete, School still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_School 
		WHERE SchoolID NOT IN (SELECT DISTINCT School FROM dbo.tb_ccc_kids)
		AND SchoolID NOT IN (Select SchoolID FROM @table)
		
		INSERT INTO dbo.tb_School (SchoolName)
		Select SchoolName
		from OpenXml(@xdoc, '/School/*')
		with (
		SchoolID VARCHAR(10) './SchoolID',
		SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID = 'New';
		
		SELECT 'School updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateSalutation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSalutation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (SalutationID VARCHAR(10), SalutationName VARCHAR(100))
	INSERT INTO @table(SalutationID, SalutationName)
	Select SalutationID, SalutationName
	from OpenXml(@xdoc, '/ChurchSalutation/*')
	with (
	SalutationID VARCHAR(10) './SalutationID',
	SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID <> 'New';		
	
	UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = a.SalutationName
	from @table AS a WHERE a.SalutationID <> 'New' AND dbo.tb_Salutation.SalutationID = a.SalutationID; 
	
	DELETE FROM @table WHERE SalutationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_members)
				AND SalutationID NOT IN (Select SalutationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_members_temp)
				AND SalutationID NOT IN (Select SalutationID FROM @table))
    OR EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_visitors)
				AND SalutationID NOT IN (Select SalutationID FROM @table))								
	BEGIN
			
		INSERT INTO dbo.tb_Salutation (SalutationName)
		Select SalutationName
		from OpenXml(@xdoc, '/ChurchSalutation/*')
		with (
		SalutationID VARCHAR(10) './SalutationID',
		SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID = 'New';
	
		SELECT 'Unable to delete, Salutation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Salutation 
		WHERE SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_members)
		AND SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_members_temp)
		AND SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_visitors)
		AND SalutationID NOT IN (Select SalutationID FROM @table)
		
		INSERT INTO dbo.tb_Salutation (SalutationName)
		Select SalutationName
		from OpenXml(@xdoc, '/ChurchSalutation/*')
		with (
		SalutationID VARCHAR(10) './SalutationID',
		SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID = 'New';
		
		SELECT 'Salutation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateMinistry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateMinistry]
(@ministryid INT,
 @ministryname VARCHAR(50),
 @ministrydescription VARCHAR(2000),
 @incharge VARCHAR(10))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_ministry SET MinistryName = @ministryname, [MinistryDescription] = @ministrydescription, MinistryInCharge = @incharge
       WHERE MinistryID = @ministryid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserPassword]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateUserPassword]
(@UserID VARCHAR(50),
 @oldPassword VARCHAR(40),
 @newPassword VARCHAR(50))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET [Password] = @newPassword
WHERE UserID = @UserID AND [Password] = @oldPassword

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateUserInformation]
(@UserID VARCHAR(50),
 @Name VARCHAR(100),
 @Email VARCHAR(100),
 @Phone VARCHAR(100),
 @Mobile VARCHAR(100),
 @Department VARCHAR(100),
 @NRIC VARCHAR(50),
 @Style VARCHAR(2))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET Name = @Name, Email = @Email, Phone = @Phone, Mobile = @Mobile, Department = @Department, Style = @Style
WHERE UserID = @UserID AND NRIC = @NRIC

SELECT (SELECT UserID, Name, Email, Phone, Mobile, Department, NRIC, Style FROM dbo.tb_Users 
WHERE UserID = @UserID AND NRIC = @NRIC
FOR XML RAW('UserInformation'), ELEMENTS) AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAppConfig]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAppConfig]
AS
SET NOCOUNT ON;
SELECT [ConfigName]
      ,[value]
  FROM [dbo].[tb_App_Config];
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllStyleInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllStyleInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select StyleID, StyleName from dbo.tb_style FOR XML PATH('Style'), ROOT('ChurchStyle'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllStyle]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllStyle]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,StyleID) AS StyleID, StyleName FROM tb_style
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getPredcessor]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getPredcessor]
@InputString VARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @TVP TABLE(AppModFuncID VARCHAR(20))
INSERT INTO @TVP
SELECT Items FROM dbo.udf_Split(@InputString, ',')

DECLARE @stillgot INT;
DECLARE @Resulttable TABLE(AppModFuncID VARCHAR(20));

DECLARE @PredcessorInputString VARCHAR(MAX)

INSERT INTO @Resulttable
SELECT DISTINCT [dbo].udf_getAppModFuncPredcessor(AppModFuncID) AS PredcessorID
FROM [dbo].[tb_AppModFunc] WHERE AppModFuncID IN (SELECT AppModFuncID FROM @TVP);

SET @stillgot = (SELECT COUNT(*) FROM @Resulttable WHERE AppModFuncID <> 'NULL');
IF @stillgot>0
BEGIN
    
    SELECT @PredcessorInputString = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(
	SELECT AppModFuncID AS a FROM @Resulttable FOR XML PATH('')
	)), '</a><a>', ','), '</a>', ''), '<a>', '')
    
    EXEC [dbo].[usp_getPredcessor] @PredcessorInputString;
END
SELECT * FROM @Resulttable;
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCityKidSchedule]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCityKidSchedule]
(@CourseID INT)
AS
SET NOCOUNT ON;

DECLARE @schedule VARCHAR(MAX) = '';
SELECT @schedule = @schedule + CONVERT(VARCHAR(10), [Date], 103) + ','      
FROM [DOS].[dbo].[tb_course_schedule] WHERE [Date] >= CONVERT(DATE, GETDATE()) AND CourseID = @CourseID

SELECT @schedule AS Schedule
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCityKidInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCityKidInformation]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;


SELECT NRIC, Name, Gender, [DOB], [HomeTel] ,[MobileTel] ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit]
      ,Email, SpecialNeeds, EmergencyContact, EmergencyContactName, Transport, Religion, Race, Nationality, School, ClubGroup
      ,BusGroupCluster, Remarks, Points, Photo
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
				FROM dbo.tb_DOSLogging AS A
				INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
				WHERE [TYPE] = 'I' AND Reference = @NRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'CityKidMembership'
				ORDER BY A.ActionTime DESC 
				FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
FROM dbo.tb_ccc_kids
WHERE NRIC = @NRIC


SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getDBBackup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getDBBackup]

AS
SET NOCOUNT ON;

DECLARE @tempLocation VARCHAR(1000) = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'DBBackupLocation')

DBCC SHRINKDATABASE (DOS, 10)

BACKUP DATABASE DOS
TO DISK = @tempLocation
   WITH FORMAT,
   NAME = 'Full Backup of SAMIS 2DB'
GO
/****** Object:  StoredProcedure [dbo].[usp_getUserInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getUserInformation]
(@UserID VARCHAR(50))
AS
SET NOCOUNT ON;

	SELECT UserID, Name, Email, Phone, Mobile, Department, NRIC, ISNULL(Style,'') AS Style FROM dbo.tb_Users
	WHERE UserID = @UserID
	FOR XML RAW('UserInformation'), ELEMENTS
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_listOfRoles]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* Created by: Goh Kian Seng
* Date: 15/03/2012
* Used by: ITSM
* Called by: ITSCController.cs
*
* Purpose: list of roles
*  
*/

CREATE PROCEDURE [dbo].[usp_listOfRoles]

AS
SET NOCOUNT ON;

SELECT [RoleID] ,[RoleName]
  FROM [dbo].[tb_Roles] ORDER BY [RoleName] ASC

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_insertlogging]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_insertlogging] 
	(@Type CHAR(1),
	 @ActionBy varchar(50),
	 @ProgramReference varchar(100),
	 @Description VARCHAR(2000),
	 @DebugLevel INT,
	 @ReferenceType VARCHAR(100),
	 @Reference VARCHAR(100),
	 @Updates XML)	
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @definedLogLevel TINYINT;
    SET @definedLogLevel = 1; --(SELECT TOP 1[logLevel] FROM [log].[dbo].[logRequirement])
	IF (@DebugLevel <= @definedLogLevel)
	BEGIN
		INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, Description, DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference) VALUES (@Type, @ActionBy, @ProgramReference, @Description, @DebugLevel, ISNULL(@Updates, '<empty />'), GETDATE(), @ReferenceType, @Reference);
--		DECLARE @LogID INT
	END
	SELECT @@identity AS Result;
	SET NOCOUNT ON;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSchoolInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSchoolInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select SchoolID AS ID, SchoolName AS Name from dbo.tb_school ORDER BY SchoolName ASC FOR XML PATH('Type'), ROOT('School'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSchool]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSchool]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,SchoolID) AS SchoolID, SchoolName FROM tb_school ORDER BY SchoolName ASC
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSalutationInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSalutationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select SalutationID, SalutationName from dbo.tb_Salutation FOR XML PATH('Salutation'), ROOT('ChurchSalutation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSalutation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSalutation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,SalutationID) AS SalutationID, SalutationName FROM dbo.tb_Salutation
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllRoleInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllRoleInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select RoleID, RoleName from dbo.tb_Roles FOR XML PATH('Role'), ROOT('ChurchRole'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllReligionInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllReligionInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ReligionID AS ID, ReligionName AS Name from dbo.tb_religion FOR XML PATH('Type'), ROOT('Religion'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllReligion]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllReligion]

AS
SET NOCOUNT ON;

	Select CONVERT(INT, ReligionID) AS ReligionID, ReligionName FROM dbo.tb_religion
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllRaceInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllRaceInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select RaceID AS ID, RaceName AS Name from dbo.tb_race FOR XML PATH('Type'), ROOT('Race'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllRace]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllRace]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,RaceID) AS RaceID, RaceName FROM dbo.tb_race
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllPostalCode]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllPostalCode]

AS
SET NOCOUNT ON;

	Select PostalAreaName, PostalDigit FROM dbo.tb_postalArea
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllPostalAreaInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllPostalAreaInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select District, PostalAreaName, PostalDigit from dbo.tb_postalArea FOR XML PATH('Postal'), ROOT('ChurchPostal'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllParishInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllParishInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ParishID, ParishName from dbo.tb_parish FOR XML PATH('Parish'), ROOT('ChurchParish'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllParish]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllParish]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,ParishID) AS ParishID, ParishName FROM tb_parish
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllOccupationInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllOccupationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select OccupationID, OccupationName from dbo.tb_occupation FOR XML PATH('Occupation'), ROOT('ChurchOccupation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllOccupation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllOccupation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,OccupationID) AS OccupationID, OccupationName FROM tb_occupation
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllModulesFunctions]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllModulesFunctions]
/*
* Created by: Goh Kian Seng
* Date: 30/05/2012
* Used by: ITSM, PSPL\SMUser
* Called by: ITSCController.cs
*
* Purpose: Get all module and function for user administration
*
*
*/ 
AS
SET NOCOUNT ON;

SELECT CONVERT(XML,(SELECT AppModFuncID, AppModFuncName FROM dbo.tb_AppModFunc WHERE AppModFuncID like '%.%.%' FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules'))) AS Modules,
CONVERT(XML,(SELECT functionID, FunctionName FROM dbo.tb_ModulesFunctions FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions'))) AS Functions

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllMaritalStatusInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllMaritalStatusInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select MaritalStatusID, MaritalStatusName from dbo.tb_maritalstatus FOR XML PATH('MaritalStatus'), ROOT('ChurchMaritalStatus'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllMaritalStatus]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllMaritalStatus]

AS
SET NOCOUNT ON;

	Select MaritalStatusID, MaritalStatusName FROM dbo.tb_maritalstatus;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllLanguageInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllLanguageInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select LanguageID, LanguageName from dbo.tb_language FOR XML PATH('Language'), ROOT('ChurchLanguage'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllLanguage]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllLanguage]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,LanguageID) AS LanguageID, LanguageName FROM tb_language ORDER BY LanguageName
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllFileTypeInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllFileTypeInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select FileTypeID AS ID, FileType AS Name from dbo.tb_file_type FOR XML PATH('Type'), ROOT('ChurchFileType'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllFileType]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllFileType]

AS
SET NOCOUNT ON;

	Select CONVERT(INT, FileTypeID) AS FileTypeID, FileType FROM tb_file_type
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllFamilyTypeInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllFamilyTypeInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select FamilyTypeID AS ID, FamilyType AS Name from dbo.tb_familytype FOR XML PATH('Type'), ROOT('FamilyType'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllFamilyType]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllFamilyType]

AS
SET NOCOUNT ON;

	Select CONVERT(INT, FamilyTypeID) AS FamilyTypeID, FamilyType FROM tb_familytype
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEmailInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEmailInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EmailID, EmailType, EmailContent from dbo.tb_emailContent FOR XML PATH('Email'), ROOT('ChurchEmail'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEmail]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEmail]

AS
SET NOCOUNT ON;

	Select EmailType, EmailContent FROM dbo.tb_emailContent
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEducationInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEducationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EducationID, EducationName from dbo.tb_education FOR XML PATH('Education'), ROOT('ChurchEducation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEducation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEducation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,EducationID) AS EducationID, EducationName FROM dbo.tb_education
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllDialectInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllDialectInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select DialectID, DialectName from dbo.tb_dialect FOR XML PATH('Dialect'), ROOT('ChurchDialect'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllDialect]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllDialect]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,DialectID) AS DialectID, DialectName FROM dbo.tb_dialect
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCountryInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCountryInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select CountryID, CountryName from dbo.tb_country FOR XML PATH('Country'), ROOT('ChurchCountry'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCountry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCountry]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,CountryID) AS CountryID, CountryName FROM tb_country
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCongregationInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCongregationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select CongregationID, CongregationName from dbo.tb_congregation FOR XML PATH('Congregation'), ROOT('ChurchCongregation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCongregation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCongregation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,CongregationID) AS CongregationID, CongregationName FROM tb_congregation
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllConfigInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllConfigInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ConfigID, ConfigName, value from dbo.tb_App_Config FOR XML PATH('Config'), ROOT('ChurchConfig'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllClubGroupInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllClubGroupInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ClubGroupID AS ID, ClubGroupName AS Name from dbo.tb_clubgroup FOR XML PATH('Type'), ROOT('ClubGroup'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllClubgroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllClubgroup]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,ClubGroupID) AS ClubGroupID, ClubGroupName FROM dbo.tb_clubgroup
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllClergy]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllClergy]

AS
SET NOCOUNT ON;

	Select NRIC, UserID, B.StyleName + ' ' + Name AS Name FROM tb_users AS A
	INNER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllChurchAreaInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllChurchAreaInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select AreaID AS ID, AreaName AS Name from dbo.tb_churchArea FOR XML PATH('Type'), ROOT('ChurchArea'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllChurchArea]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllChurchArea]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,AreaID) AS AreaID, AreaName FROM tb_ChurchArea
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllBusGroupClusterInXML]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllBusGroupClusterInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select BusGroupClusterID AS ID, BusGroupClusterName AS Name from dbo.tb_busgroup_cluster FOR XML PATH('Type'), ROOT('ChurchBusGroupCluster'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllBusGroupCluster]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllBusGroupCluster]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,BusGroupClusterID) AS BusGroupClusterID, BusGroupClusterName FROM dbo.tb_busgroup_cluster
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_checkUserLogin]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_checkUserLogin]
(@UserID VARCHAR(50),
 @Password VARCHAR(40))
AS
SET NOCOUNT ON;

SELECT (SELECT UserID, Name, Email, Phone, Mobile, Department, ISNULL(Style,'') AS Style, NRIC FROM dbo.tb_Users 
WHERE UserID = @UserID AND [Password] = @Password
FOR XML RAW('UserInformation'), ELEMENTS) AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_checkFileInUsed]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_checkFileInUsed]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	
	
	DECLARE @table AS TABLE ([Filename] VARCHAR(1000), [Type] VARCHAR(100));
	INSERT INTO @table([Filename], [Type])
	Select [Filename], [Type]
	from OpenXml(@xdoc, '/Files/*')
	with (
	[Type] VARCHAR(100) './Type',
	[Filename] VARCHAR(1000) './Filename');
	
	DELETE FROM @table WHERE [Type] = 'icphotolocation' AND [Filename] IN (SELECT ICPhoto FROM dbo.tb_members WHERE LEN(ICPhoto) > 0);
	DELETE FROM @table WHERE [Type] = 'CityKidsPhotolocation' AND [Filename] IN (SELECT Photo FROM dbo.tb_ccc_kids WHERE LEN(Photo) > 0);
	DELETE FROM @table WHERE [Type] = 'temp_uploadfilesavedlocation' AND [Filename] IN (SELECT ICPhoto FROM dbo.tb_members_temp WHERE LEN(ICPhoto) > 0);
	
	DECLARE @res AS XML = (SELECT [Type], [Filename] FROM @table FOR XML PATH('File'), ELEMENTS, ROOT('Files'));
	SELECT ISNULL(@res,'<Files />') AS Res;

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_ApproveMembership]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ApproveMembership]
(@NRICS VARCHAR(MAX))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_members
SELECT * FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

INSERT INTO dbo.tb_membersOtherInfo
SELECT * FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
	
DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
DELETE FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SELECT ICPhoto, @@ROWCOUNT AS Result FROM dbo.tb_members WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewUser]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewUser]
(@UserID VARCHAR(50),
 @Name VARCHAR(100),
 @Email VARCHAR(100),
 @Phone VARCHAR(100),
 @Mobile VARCHAR(100),
 @Department VARCHAR(100),
 @NRIC VARCHAR(50),
 @Password VARCHAR(40),
 @Style VARCHAR(2))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_Users WHERE UserID = @UserID)
BEGIN
	SELECT 'UserID' AS Result;
END
ELSE IF EXISTS (SELECT * FROM dbo.tb_Users WHERE NRIC = @NRIC)
BEGIN
	SELECT 'NRIC' AS Result;
END
ELSE
BEGIN
	INSERT INTO dbo.tb_Users (UserID, Name, Email, Phone, Mobile, Department, NRIC, [Password], Style)
	SELECT @UserID, @Name, @Email, @Phone, @Mobile, @Department, @NRIC, @Password, @Style;
	
	SELECT 'OK' AS Result;
END
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewMinistry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewMinistry]
(@ministryname VARCHAR(50),
 @ministrydescription VARCHAR(2000),
 @incharge VARCHAR(10))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_ministry(MinistryName, [MinistryDescription], MinistryInCharge)
SELECT @ministryname, @ministrydescription, @incharge

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  UserDefinedFunction [dbo].[udf_isCourseStillRunning]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_isCourseStillRunning]
(
	@startdate VARCHAR(2000),
	@todayDate DATETIME
)
RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.udf_Split(@startdate, ',') WHERE CONVERT(DATETIME, ITEMS, 103) >= @todayDate)
	BEGIN
		return 1;
	END
	ELSE
	BEGIN
		RETURN 0;
	END
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getStafforMemberName]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getStafforMemberName]
(
	-- Add the parameters for the function here
	@nric VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @name VARCHAR(100)

IF EXISTS(SELECT * FROM dbo.tb_Users WHERE Nric = @nric)
BEGIN
	SELECT @name = RTRIM(LTRIM(ISNULL(B.StyleName,'') + ' ' + Name)) FROM dbo.tb_Users AS A
	LEFT OUTER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	WHERE A.NRIC = @nric
END
ELSE
BEGIN
	SELECT @name = SalutationName + ' ' + EnglishName FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_Salutation AS B ON A.Salutation = B.SalutationID
	WHERE NRIC = @nric
END

RETURN @name
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getMinistry]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getMinistry]
(
	-- Add the parameters for the function here
	@xml VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @return VARCHAR(MAX)
SET @return = ''
DECLARE @MinistryTable TABLE(ministryid tinyint)
DECLARE @table TABLE(ministry XML)
INSERT INTO @table (ministry)
SELECT @xml


INSERT INTO @MinistryTable(MinistryID)
SELECT p.value('(.)', 'VARCHAR(5)') as MinistryID
FROM @table CROSS APPLY ministry.nodes('/Ministry/MinistryID') t(p)

SELECT @return = @return + B.MinistryName + ',' FROM @MinistryTable AS A
INNER JOIN dbo.tb_ministry AS B ON B.MinistryID = A.MinistryID

RETURN @return
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getMaritialStatus]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getMaritialStatus]
(
	-- Add the parameters for the function here
	@maritialstatus INT
)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @res VARCHAR(100)

SELECT @res = MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @maritialstatus

RETURN @res
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getLanguages]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getLanguages]
(
	-- Add the parameters for the function here
	@languages VARCHAR(1000)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @returnlanguage VARCHAR(MAX)
	SET @returnlanguage = ''
	
	SELECT @returnlanguage = @returnlanguage + B.LanguageName + ', ' FROM dbo.udf_Split(@languages, ',') AS A
	JOIN dbo.tb_language AS B ON B.LanguageID = A.Items

	RETURN @returnlanguage
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getEducation]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getEducation]
(
	-- Add the parameters for the function here
	@education INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @res VARCHAR(100)
SELECT @res = EducationName FROM dbo.tb_education WHERE EducationID = @education

RETURN @res
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getDialect]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getDialect]
(
	-- Add the parameters for the function here
	@dialect tinyint
)
RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @res VARCHAR(100)
	SELECT @res = DialectName FROM dbo.tb_dialect WHERE DialectID = @dialect
	return @res
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getAttendencePoint]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_getAttendencePoint]
(	
	@NRIC VARCHAR(10), 
	@CourceID INT
)
RETURNS INT 
AS

BEGIN
	
	/* retrieve CITY KIDS Settings*/
	DECLARE @BasePoint INT = (SELECT CONVERT(INT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'CityKidBaseAttendancePoint')
	DECLARE @ContinualAttendance INT = (SELECT CONVERT(INT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'CityKidContinualAttendance')
	
	/* Initail Award Point is 10 */
	DECLARE @iAwardPoint int = 10, @iCount int = 1, @iCheckAttendance int = 0;
	DECLARE @dtCheckDate date;
	
	/* Create first cursor to get last 6 course schedule dates */
	DECLARE ScheduleCursor CURSOR FOR 
	SELECT [DOS].[dbo].[tb_course_schedule].[Date]
	FROM [DOS].[dbo].[tb_course_schedule] WHERE [DOS].[dbo].[tb_course_schedule].[Date] <= CONVERT(date, GETDATE())
	ORDER BY [DOS].[dbo].[tb_course_schedule].[Date] DESC
	
	OPEN ScheduleCursor
	
	/* put schedule date result into @dtCheckDate */
	FETCH NEXT FROM ScheduleCursor
	INTO @dtCheckDate
	
	/* if @dtCheckDate data is available */
	WHILE @@FETCH_STATUS = 0
	BEGIN
		/* Find the attendance record in the tb_course_Attendance by using @dtChkDate */
		SET @iCheckAttendance = 0;
		
		/* Create second cursor to check in tb_course_Attendance table */
		DECLARE CheckAttendanceCursor CURSOR FOR 
		SELECT 1
		FROM dbo.tb_course_Attendance
		WHERE dbo.tb_course_Attendance.NRIC = @NRIC AND dbo.tb_course_Attendance.CourseID = 13 AND dbo.tb_course_Attendance.Date = @dtCheckDate
		
		/* put search result into @iCheckAttendance */
		OPEN CheckAttendanceCursor;
		FETCH NEXT FROM CheckAttendanceCursor INTO @iCheckAttendance
		
		/* put search result into @iCheckAttendance */
		IF @iCheckAttendance = 1
		BEGIN
			/* if search result is 1, then increase Award Point and increase @iCount by 1 */
			IF (@iCount % @ContinualAttendance) = 0
				SET @iAwardPoint = @ContinualAttendance * @BasePoint
			ELSE
				SET @iAwardPoint = (@iCount % @ContinualAttendance) * @BasePoint;
			SET @iCount = @iCount + 1;
			/* Close the cursor for next search */
			CLOSE CheckAttendanceCursor;
			DEALLOCATE CheckAttendanceCursor;
		END
		ELSE
		BEGIN
			/* Close the cursor for next search */
			CLOSE CheckAttendanceCursor;
			DEALLOCATE CheckAttendanceCursor;
			/* break while loop and stop searching */
			BREAK;
		END
		
		FETCH NEXT FROM ScheduleCursor
		INTO @dtCheckDate
	END
	
	CLOSE ScheduleCursor;
	DEALLOCATE ScheduleCursor;
	
	RETURN @iAwardPoint;
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getAttendancePercentage]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_getAttendancePercentage]
(@NRIC VARCHAR(20),
@CourseID INT,
@type VARCHAR(10))
RETURNS VARCHAR(50)
AS
BEGIN
	
	DECLARE @AttendanceTable TABLE ([Date] DATE, Attended VARCHAR(3));

	INSERT INTO @AttendanceTable ([Date], Attended)
	SELECT CONVERT(DATE, ITEMS, 103), '-' FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');
	UPDATE @AttendanceTable SET Attended = 'Yes' WHERE [Date] IN (SELECT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @courseid AND NRIC = @nric);
	UPDATE @AttendanceTable SET Attended = '??' WHERE [Date] > GETDATE();

	DECLARE @TotalDayConducted INT = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended <> '??');
	DECLARE @TotalDayAttended INT = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended = 'Yes');
	DECLARE @AttandancePercentage NUMERIC(6,2) = 0;
	IF(@TotalDayConducted > 0)
	BEGIN
		SET @AttandancePercentage  = (SELECT CONVERT(NUMERIC(4,2), @TotalDayAttended) / CONVERT(NUMERIC(4,2), @TotalDayConducted) * 100);
	END
	
	IF(@type = 'percentage')
	BEGIN
		return CONVERT(VARCHAR(10),@AttandancePercentage)+'%';
	END
	ELSE
	BEGIN
		return CONVERT(VARCHAR(10),@TotalDayAttended)+ '/' + CONVERT(VARCHAR(10),@TotalDayConducted);
	END
	
	return '';
END
GO
/****** Object:  UserDefinedFunction [dbo].[udf_getAppModFuncCategorize]    Script Date: 08/24/2012 23:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getAppModFuncCategorize]
(
	-- Add the parameters for the function here
	@text_to_count VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
DECLARE
@last_count AS INT = 0,
@returnMessage AS VARCHAR(20);

SELECT @last_count = COUNT(*) FROM dbo.udf_Split(@text_to_count, '.')
SET @last_count = @last_count - 1


IF @last_count = 0
Begin
	set @returnMessage = NULL;
END

ELSE IF @last_count = 1
BEGIN
	set @returnMessage =  'top';
END

ELSE IF @last_count = 2
BEGIN
	set @returnMessage =  'sub';
END

ELSE
	set @returnMessage =  'fly';
	
return @returnMessage;

END
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourse]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourse]
(@coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT,
 @fee DECIMAL(5, 2))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_course (Fee, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation)
SELECT @fee, @coursename, @startdate, @starttime, @endtime, @incharge, @location

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCellgroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCellgroup]
(@cellgroupname VARCHAR(50),
 @incharge VARCHAR(20),
 @postalCode INT,
 @blkhouse VARCHAR(10),
 @streetAddress VARCHAR(100),
 @unit VARCHAR(10))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_cellgroup(CellgroupName, CellgroupLeader, PostalCode, StreetAddress, BLKHouse, Unit)
SELECT @cellgroupname, @incharge, @postalCode, @streetAddress, @blkhouse, @unit

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseMemberParticipant]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipant]
(@NRIC VARCHAR(100),
 @courseid int)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON C.courseID = A.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON C.courseID = A.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE
BEGIN
		SELECT 'NOTEXISTS' AS Result, '' AS SalutationName, '' AS EnglishName, '' AS CourseName
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCityKid]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCityKid]
(@newXML AS XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_race VARCHAR(4),
@candidate_school VARCHAR(4),
@candidate_religion VARCHAR(4),
@candidate_emergency_contact VARCHAR(15),
@candidate_emergency_relationship VARCHAR(50),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_specialneed VARCHAR(1000)




DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @candidate_photo = Photo, @candidate_english_name = EnglishName, 
    @candidate_unit = AddressUnit, @candidate_blk_house = AddressBlkHouse, @candidate_nationality = Nationality, @candidate_race = Race,
    @candidate_school = School, @candidate_religion = Religion, @candidate_emergency_contact = NOKContact, @candidate_emergency_relationship = NOKRelationship,
    @candidate_nric = NRIC, @candidate_dob = CONVERT(DATETIME, DOB, 103), @candidate_gender = Gender, @candidate_street_address = AddressStreetName,
    @candidate_postal_code = AddressPostalCode, @candidate_email = Email, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
    @candidate_specialneed = SpecialNeeds
	FROM OPENXML(@idoc, '/New')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	Photo VARCHAR(1000) './Photo',
	EnglishName VARCHAR(50) './Name',
	AddressUnit VARCHAR(10) './AddressUnit',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	Nationality VARCHAR(3) './Nationality',
	Race VARCHAR(3) './Race',
	School VARCHAR(3) './School',
	Religion VARCHAR(3) './Religion',
	NOKContact VARCHAR(15) './NOKContact',
	NOKRelationship VARCHAR(50) './NOKRelationship',
	NRIC VARCHAR(20)'./NRIC',
	DOB VARCHAR(10) './DOB',
	Gender VARCHAR(1) './Gender',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	Email VARCHAR(100) './Email',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	SpecialNeeds VARCHAR(1000) './SpecialNeeds');
	
	
IF NOT EXISTS( SELECT * FROM dbo.tb_ccc_kids WHERE NRIC = @candidate_nric)
BEGIN
	
	INSERT INTO dbo.tb_ccc_kids(NRIC, Name, Gender, DOB, HomeTel, MobileTel, AddressHouseBlk, AddressPostalCode,
				AddressStreet, AddressUnit, Email, SpecialNeeds, EmergencyContact, EmergencyContactName,
				Religion, Race, Nationality, School, Photo)
	SELECT @candidate_nric, @candidate_english_name, @candidate_gender, @candidate_dob, @candidate_home_tel, @candidate_mobile_tel,
	       @candidate_blk_house, @candidate_postal_code, @candidate_street_address, @candidate_unit, @candidate_email, @candidate_specialneed,
	       @candidate_emergency_contact, @candidate_emergency_relationship, @candidate_religion, @candidate_race, @candidate_nationality,
	       @candidate_school, @candidate_photo
	
	DECLARE @rowcount INT = @@ROWCOUNT;	
	
	DECLARE @newKidXML XML = (SELECT NRIC, Name, Gender, DOB, HomeTel, MobileTel, AddressHouseBlk, AddressPostalCode,
										AddressStreet, AddressUnit, Email, SpecialNeeds, EmergencyContact, EmergencyContactName,
										ISNULL(B.ReligionName, '') AS Religion, ISNULL(C.RaceName, '') AS Race, ISNULL(D.CountryName, '') AS Nationality, ISNULL(E.SchoolName, '') AS School, Photo
								 FROM dbo.tb_ccc_kids AS A
								 LEFT OUTER JOIN dbo.tb_religion AS B ON A.Religion = B.ReligionID
								 LEFT OUTER JOIN dbo.tb_race AS C ON A.Race = C.RaceID
								 LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
								 LEFT OUTER JOIN dbo.tb_school AS E ON A.School = E.SchoolID
								 WHERE NRIC = @candidate_nric
								 FOR XML PATH, ELEMENTS)
	SELECT ISNULL(@rowcount, 0) AS Result
	EXEC dbo.usp_insertlogging 'I', @UserID, 'CityKidMembership', 'New', 1, 'NRIC', @candidate_nric, @newKidXML;								 
	
END	

SELECT 0 AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewMember]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewMember]
(@newXML AS XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_salutation VARCHAR(4),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_dialect VARCHAR(4),
@candidate_occupation VARCHAR(4),
@baptized_by VARCHAR(50),
@baptism_church VARCHAR(4),
@confirmation_by VARCHAR(50),
@confirmation_church VARCHAR(4),
@previous_church_membership VARCHAR(4),
@candidate_chinses_name NVARCHAR(50),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_marital_status VARCHAR(3),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_language VARCHAR(200),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_baptism_date VARCHAR(15),
@candidate_confirmation_date VARCHAR(15),
@candidate_marriage_date VARCHAR(15),
@candidate_congregation VARCHAR(3),
@candidate_sponsor1 VARCHAR(10),
@candidate_sponsor2 VARCHAR(10),
@candidate_sponsor2contact VARCHAR(100),
@family XML,
@child XML,
@candidate_interested_ministry XML,
@candidate_join_cellgroup VARCHAR(1),
@candidate_serve_congregation VARCHAR(1),
@candidate_tithing VARCHAR(1),
@candidate_transfer_reason VARCHAR(1000),
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100)





DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact= Sponsor2Contact,
	@candidate_transfer_reason = TransferReason, @candidate_congregation = Congregation,
	@candidate_serve_congregation = ServeCongregation, @candidate_interested_ministry = Ministry, @candidate_join_cellgroup = Cellgroup, @candidate_tithing = Tithing,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers
	FROM OPENXML(@idoc, '/New')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	ChineseName NVARCHAR(50) './ChineseName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	MaritalStatus VARCHAR(3) './MaritalStatus',
	MarriageDate VARCHAR(20) './MarriageDate',
	Nationality VARCHAR(3) './Nationality',
	Dialect VARCHAR(3) './Dialect',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	[Language] VARCHAR(200) './Language',
	Occupation VARCHAR(3) './Occupation',
	Congregation VARCHAR(3) './Congregation',
	BaptismBy VARCHAR(20) './BaptismBy',
	BaptismDate VARCHAR(10) './BaptismDate',
	BaptismChurch VARCHAR(3) './BaptismChurch',
	ConfirmationBy VARCHAR(20) './ConfirmationBy',
	ConfirmationChurch VARCHAR(3) './ConfirmationChurch',
	ConfirmationDate VARCHAR(10) './ConfirmationDate',
	PreviousChurchMembership VARCHAR(3) './PreviousChurchMembership',
	TransferReason VARCHAR(1000) './TransferReason',
	FamilyXML XML './FamilyList',
	ChildXML XML './ChildList',
	ServeCongregation VARCHAR(1) './InterestedServeCongregation',
	Cellgroup VARCHAR(1) './InterestedCellgroup',
	Tithing VARCHAR(1) './InterestedTithing',
	Ministry XML './Ministry',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(20) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers');






IF(LEN(@candidate_baptism_date) = 0)
BEGIN
	SET @candidate_baptism_date = NULL;
END

IF(LEN(@candidate_marriage_date) = 0)
BEGIN
	SET @candidate_marriage_date = NULL;
END

if(LEN(@candidate_confirmation_date) = 0)
BEGIN
	SET @candidate_confirmation_date = NULL;
END

IF EXISTS (SELECT * FROM dbo.tb_visitors WHERE NRIC = @candidate_nric)
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_visitors WHERE NRIC = @candidate_nric;
END

IF NOT EXISTS( SELECT * FROM dbo.tb_members WHERE NRIC = @candidate_nric)
BEGIN

	IF NOT EXISTS( SELECT * FROM dbo.tb_members_temp WHERE NRIC = @candidate_nric)
	BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'


	INSERT INTO dbo.tb_members_temp (Salutation, ICPhoto, EnglishName, AddressUnit,
							AddressHouseBlk, Nationality, Dialect, Occupation, BaptismBy, BaptismChurch,
							ConfirmBy, ConfirmChurch, PreviousChurch, ChineseName, NRIC,
							DOB, Gender, MaritalStatus, AddressStreet,
							AddressPostalCode, Email, Education, [Language],
							HomeTel, MobileTel, BaptismDate, ConfirmDate,
							MarriageDate, CurrentParish, Family, Child, TransferReason,
							BaptismByOthers, ConfirmByOthers , BaptismChurchOthers , ConfirmChurchOthers , PreviousChurchOthers)
	SELECT  @candidate_salutation, @candidate_photo,
			@candidate_english_name, @candidate_unit,
			@candidate_blk_house, @candidate_nationality,
			@candidate_dialect, @candidate_occupation,
			@baptized_by, @baptism_church,
			@confirmation_by, @confirmation_church,
			@previous_church_membership, @candidate_chinses_name,
			@candidate_nric, @candidate_dob,
			@candidate_gender, @candidate_marital_status,
			@candidate_street_address, @candidate_postal_code,
			@candidate_email, @candidate_education,
			@candidate_language, @candidate_home_tel,
			@candidate_mobile_tel,
			CONVERT(DATETIME, @candidate_baptism_date, 103),
			CONVERT(DATETIME, @candidate_confirmation_date, 103),
			CONVERT(DATETIME, @candidate_marriage_date, 103),
			@CurrentParish, @family, @child, @candidate_transfer_reason,
			@baptism_by_others,
			@confirm_by_others,
			@baptism_church_others,
			@confirm_church_others,
			@previous_church_others;
			
			DECLARE @rowcount INT = @@ROWCOUNT;
			
			INSERT INTO dbo.tb_membersOtherInfo_temp (NRIC, Congregation, Sponsor1, Sponsor2, Sponsor2Contact, MinistryInterested, CellgroupInterested, ServeCongregationInterested, TithingInterested)
			SELECT @candidate_nric, @candidate_congregation, @candidate_sponsor1, @candidate_sponsor2, @candidate_sponsor2contact, @candidate_interested_ministry, @candidate_join_cellgroup, @candidate_serve_congregation, @candidate_tithing
			
			DECLARE @newMemberXML XML = (
			SELECT  C.SalutationName, A.ICPhoto, A.EnglishName, A.AddressUnit,
					A.AddressHouseBlk, D.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect, F.OccupationName AS Occupation, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
					dbo.udf_getStafforMemberName(A.ConfirmBy) AS ConfirmBy, G.ParishName AS ConfirmChurch, L.ParishName AS PreviousChurch, A.ChineseName, A.NRIC,
					A.DOB, dbo.udf_getGender(A.Gender) AS Gender, dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, A.AddressStreet,
					A.AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education, dbo.udf_getLanguages(A.[Language]) AS [Language],
					A.HomeTel, A.MobileTel, A.BaptismDate, A.ConfirmDate, A.TransferReason,
					A.MarriageDate, A.CurrentParish, A.Family, A.Child, K.CongregationName AS Congregation, dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1, B.Sponsor2 AS Sponsor2, B.Sponsor2Contact,
					B.MinistryInterested, B.TithingInterested, B.CellgroupInterested, B.CellgroupInterested, BaptismByOthers, ConfirmByOthers , BaptismChurchOthers , ConfirmChurchOthers , PreviousChurchOthers
			FROM dbo.tb_members_temp AS A
			INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON B.NRIC = A.NRIC
			INNER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
			INNER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_parish AS G ON A.ConfirmChurch = G.ParishID
			LEFT OUTER JOIN dbo.tb_parish AS H ON A.BaptismChurch = H.ParishID
			INNER JOIN dbo.tb_congregation AS K ON B.Congregation = K.CongregationID
			LEFT OUTER JOIN dbo.tb_parish AS L ON A.PreviousChurch = L.ParishID
			WHERE A.NRIC = @candidate_nric
			FOR XML PATH, ELEMENTS)
			SELECT ISNULL(@rowcount, 0) AS Result
			EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'New', 1, 'NRIC', @candidate_nric, @newMemberXML;
			
	END

END		
SELECT ISNULL(@rowcount, 0) AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getVisitorInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getVisitorInformation]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;


	SELECT [EnglishName], CONVERT(VARCHAR(5), [Salutation]) AS Salutation
      ,ISNULL(CONVERT(VARCHAR(10),[DOB],103), '') AS DOB ,[Gender] ,@NRIC AS [NRIC] , CONVERT(VARCHAR(5),[Nationality]) AS [Nationality]
      ,[AddressStreet] ,[AddressHouseBlk] , ISNULL(CONVERT(VARCHAR(6),[AddressPostalCode]),'' ) AS [AddressPostalCode] ,[AddressUnit] ,[Email]
      ,CONVERT(VARCHAR(5), [Education]) AS Education , CONVERT(VARCHAR(5),[Occupation]) AS [Occupation], Contact 
      ,CONVERT(VARCHAR(3),A.Church) AS Church, A.ChurchOthers
      ,   Convert(XML, ISNULL((SELECT B.CourseName AS CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @NRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended       
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @NRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'VisitorMembership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_visitors AS A
	WHERE A.NRIC = @NRIC


SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getUsersInRole]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getUsersInRole]
(@RoleID AS INT)

AS
SET NOCOUNT ON;

SELECT (SELECT B.Name FROM dbo.tb_Roles_Users AS A
INNER JOIN dbo.tb_Users AS B ON A.UserID = B.UserID
WHERE A.RoleID = @RoleID
FOR XML PATH(''), ELEMENTS, ROOT('All')) AS Display

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getStaffName]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getStaffName]
(@UserID VARCHAR(50))
AS
SET NOCOUNT ON;

SELECT dbo.udf_getStafforMemberName(NRIC) AS Name FROM dbo.tb_Users WHERE UserID = @UserID

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseParticipantInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseParticipantInformation]
(@courseid INT,
@nric VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @AttendanceTable TABLE ([Date] DATE, Attended VARCHAR(3));

INSERT INTO @AttendanceTable ([Date], Attended)
SELECT CONVERT(DATE, ITEMS, 103), '-' FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');
UPDATE @AttendanceTable SET Attended = 'Yes' WHERE [Date] IN (SELECT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @courseid AND NRIC = @nric);
UPDATE @AttendanceTable SET Attended = '??' WHERE [Date] > GETDATE();

DECLARE @TotalDayConducted NUMERIC(4,2) = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended <> '??');
DECLARE @TotalDayAttended NUMERIC(4,2) = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended = 'Yes');
DECLARE @AttandancePercentage NUMERIC(6,2) = 0;
IF(@TotalDayConducted > 0)
BEGIN
	SET @AttandancePercentage  = (SELECT @TotalDayAttended / @TotalDayConducted * 100);
END

DECLARE @xml XML = (SELECT [Date], Attended, @AttandancePercentage AS AttendancePercentage FROM @AttendanceTable Order by [Date] ASC FOR XML PATH('ATT'), ROOT('Attendance'));

SELECT @xml AS Attendance, A.NRIC, ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName) AS EnglishName, courseID, feePaid, materialReceived FROM dbo.tb_course_participant AS A
  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
  WHERE A.courseID = @courseid AND A.NRIC = @nric;


SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseInfo]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseInfo]
(@courseid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT Fee, CourseDay, courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name, A.CourseInCharge FROM dbo.tb_course AS A
LEFT OUTER JOIN dbo.tb_members AS B on A.CourseInCharge = B.NRIC
LEFT OUTER JOIN dbo.tb_Users AS C on A.CourseInCharge = C.NRIC
LEFT OUTER JOIN dbo.tb_style AS D ON C.Style = D.styleID
LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
WHERE courseID = @courseid

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCellgroupInfo]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCellgroupInfo]
(@cellgroupid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT CONVERT(VARCHAR(4), CellgroupID) AS CellgroupID, CellgroupName,  dbo.udf_getStafforMemberName(CellgroupLeader) AS Name, CellgroupLeader, PostalCode, StreetAddress, BLKHouse, Unit FROM dbo.tb_cellgroup
WHERE CellgroupID = @cellgroupid

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAssignedModulesFunctions]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAssignedModulesFunctions]
(@RoleID AS INT)
AS
SET NOCOUNT ON;

SELECT (SELECT CONVERT(XML,ISNULL((SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules')),'<AllModules />')),
CONVERT(XML, ISNULL((SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions')),'<AllFunctions />')) FOR XML PATH(''), ELEMENTS, ROOT('All')) AS XML

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAppModFuncAccessRights]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAppModFuncAccessRights]
(@UserID VARCHAR(50))
AS
SET NOCOUNT ON;
DECLARE @RoleTable AS TABLE(RoleID INT);
--DECLARE @MyOwnTable AS LocationTableType;
DECLARE @MyOwnTable AS TABLE(AppModFuncID VARCHAR(20))
DECLARE @MyOwnTableString VARCHAR(MAX)

INSERT INTO @RoleTable
SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID=@UserID;

IF NOT EXISTS(SELECT 1 FROM @RoleTable)
BEGIN
	INSERT INTO @RoleTable
	SELECT -1;
END

INSERT INTO @MyOwnTable (AppModFuncID)
SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID IN(SELECT RoleID FROM @RoleTable);

SELECT @MyOwnTableString = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(
	SELECT AppModFuncID AS a FROM @MyOwnTable FOR XML PATH('')
)), '</a><a>', ','), '</a>', ''), '<a>', '')


INSERT INTO @MyOwnTable
EXEC [dbo].[usp_getPredcessor] @MyOwnTableString;

SELECT dbo.udf_getAppModFuncPredcessor(AppModFuncID) AS PredcessorID, 
         dbo.udf_getAppModFuncCategorize(AppModFuncID) AS GroupID, 
         AppModFuncID, 
         AppModFuncName, 
         URL, 
         Sequence 
FROM dbo.tb_AppModFunc WHERE dbo.udf_getAppModFuncPredcessor(AppModFuncID) <> 'NULL' 
AND AppModFuncID IN (SELECT DISTINCT * FROM @MyOwnTable WHERE AppModFuncID <> 'NULL') 
ORDER BY PredcessorID, Sequence;
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getModuleFunctionsAccessRight]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getModuleFunctionsAccessRight]
(@UserID VARCHAR(50))
 
AS
SET NOCOUNT ON;
DECLARE @xml AS XML;
DECLARE @count AS INT;
SELECT @count = COUNT(*) FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
JOIN dbo.tb_ModulesFunctions ON dbo.tb_ModulesFunctions.functionID = dbo.tb_Roles_ModulesFunctionsAccessRight.functionID
WHERE RoleID IN (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID) OR RoleID = -1;

IF (@count = 0)
BEGIN
	SET @xml = '<FunctionAccessRight></FunctionAccessRight>';
END
ELSE
BEGIN
	SET @xml = (SELECT CONVERT (XML, (SELECT functionName FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
	JOIN dbo.tb_ModulesFunctions ON dbo.tb_ModulesFunctions.functionID = dbo.tb_Roles_ModulesFunctionsAccessRight.functionID
	WHERE Module <> 'Congregation' AND RoleID IN (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID) OR RoleID = -1
	FOR XML RAW('AccessTo'), ELEMENTS)) FOR XML RAW('FunctionAccessRight'), ELEMENTS);
	
END
SELECT @xml AS FunctionAccessRight;
SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getMinistryInfo]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMinistryInfo]
(@ministryid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT CONVERT(VARCHAR(4), MinistryID) AS MinistryID, MinistryName, MinistryDescription,  dbo.udf_getStafforMemberName(MinistryInCharge) AS Name, MinistryInCharge FROM dbo.tb_ministry
WHERE MinistryID = @ministryid

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getMembersTempReportingManualSearch]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMembersTempReportingManualSearch]
(@gender VARCHAR(3),
@marriage VARCHAR(3),
@nationality VARCHAR(3),
@dialect VARCHAR(3),
@education VARCHAR(3),
@occupation VARCHAR(3),
@congregation VARCHAR(3),
@language VARCHAR(3),
@cellgroup VARCHAR(3),
@ministry VARCHAR(3),
@batismchurch VARCHAR(3),
@confirmchurch VARCHAR(3),
@previouschurch VARCHAR(3),
@baptismby VARCHAR(3),
@confirmby VARCHAR(3),
@residentalarea VARCHAR(200), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @allMember TABLE(NRIC VARCHAR(20))
DECLARE @congregationTable Table (congregationID TINYINT)


declare 
@tgender VARCHAR(3) = @gender,
@tmarriage VARCHAR(3) = @marriage,
@tnationality VARCHAR(3) = @nationality,
@tdialect VARCHAR(3) = @dialect,
@teducation VARCHAR(3) = @education,
@toccupation VARCHAR(3) = @occupation,
@tcongregation VARCHAR(3) = @congregation,
@tlanguage VARCHAR(3) = @language,
@tcellgroup VARCHAR(3) = @cellgroup,
@tministry VARCHAR(3) = @ministry,
@tbatismchurch VARCHAR(3) = @batismchurch,
@tconfirmchurch VARCHAR(3) = @confirmchurch,
@tpreviouschurch VARCHAR(3) = @previouschurch,
@tbaptismby VARCHAR(3) = @baptismby,
@tconfirmby VARCHAR(3) = @confirmby,
@tresidentalarea VARCHAR(200) = @residentalarea, @tUserID VARCHAR(50) = @UserID;



INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))


INSERT INTO @allMember (NRIC)
SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE Congregation IN (SELECT CongregationID FROM @congregationTable)

IF(ISNULL(@tgender, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Gender = @tgender)
END

IF(ISNULL(@tmarriage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE MaritalStatus = @tmarriage)
END

IF(ISNULL(@tnationality, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Nationality = @tnationality)
END

IF(ISNULL(@tdialect, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Dialect = @tdialect)
END

IF(ISNULL(@teducation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Education = @teducation)
END

IF(ISNULL(@toccupation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Occupation = @toccupation)
END

IF(ISNULL(@tcongregation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE Congregation = @tcongregation)
END

IF(ISNULL(@tcellgroup, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE CellGroup = @tcellgroup)
END

IF(ISNULL(@tbatismchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE BaptismChurch = @tbatismchurch)
END

IF(ISNULL(@tconfirmchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE ConfirmChurch = @tconfirmchurch)
END

IF(ISNULL(@tpreviouschurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE PreviousChurch = @tpreviouschurch)
END

IF(ISNULL(@tbaptismby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE BaptismBy = @tbaptismby)
END

IF(ISNULL(@tconfirmby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE ConfirmBy = @tconfirmby)
END

IF(ISNULL(@tlanguage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_members_temp AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(A.[Language],',') WHERE items = @tlanguage))
END

IF(ISNULL(@tministry, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_membersOtherInfo_temp AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(8000), A.MinistryInvolvement),'<Ministry/>',''),'</MinistryID><MinistryID>',','),'<Ministry><MinistryID>',''),'</MinistryID></Ministry>',''), ',') WHERE items = @tministry))
END

IF(ISNULL(@tresidentalarea, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE SUBSTRING(CONVERT(VARCHAR(7),AddressPostalCode), 1, 2) IN (SELECT RTRIM(LTRIM(ITEMS)) FROM dbo.udf_Split(@tresidentalarea, ',')))
END












DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'
SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
		dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
		A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
		A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
		A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
		ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
		dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
		ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
		
FROM dbo.tb_membersOtherInfo_temp AS B 
INNER JOIN dbo.tb_members_temp AS A ON A.NRIC = B.NRIC
INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
WHERE A.CurrentParish = @CurrentParish AND B.NRIC IN (SELECT NRIC FROM @allMember)

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getMembersReportingManualSearch]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMembersReportingManualSearch]
(@gender VARCHAR(3),
@marriage VARCHAR(3),
@nationality VARCHAR(3),
@dialect VARCHAR(3),
@education VARCHAR(3),
@occupation VARCHAR(3),
@congregation VARCHAR(3),
@language VARCHAR(3),
@cellgroup VARCHAR(3),
@ministry VARCHAR(3),
@batismchurch VARCHAR(3),
@confirmchurch VARCHAR(3),
@previouschurch VARCHAR(3),
@baptismby VARCHAR(3),
@confirmby VARCHAR(3),
@residentalarea VARCHAR(200), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @allMember TABLE(NRIC VARCHAR(20))
DECLARE @congregationTable Table (congregationID TINYINT)


declare 
@tgender VARCHAR(3) = @gender,
@tmarriage VARCHAR(3) = @marriage,
@tnationality VARCHAR(3) = @nationality,
@tdialect VARCHAR(3) = @dialect,
@teducation VARCHAR(3) = @education,
@toccupation VARCHAR(3) = @occupation,
@tcongregation VARCHAR(3) = @congregation,
@tlanguage VARCHAR(3) = @language,
@tcellgroup VARCHAR(3) = @cellgroup,
@tministry VARCHAR(3) = @ministry,
@tbatismchurch VARCHAR(3) = @batismchurch,
@tconfirmchurch VARCHAR(3) = @confirmchurch,
@tpreviouschurch VARCHAR(3) = @previouschurch,
@tbaptismby VARCHAR(3) = @baptismby,
@tconfirmby VARCHAR(3) = @confirmby,
@tresidentalarea VARCHAR(200) = @residentalarea, @tUserID VARCHAR(50) = @UserID;



INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))


INSERT INTO @allMember (NRIC)
SELECT NRIC FROM dbo.tb_membersOtherInfo WHERE Congregation IN (SELECT CongregationID FROM @congregationTable)

IF(ISNULL(@tgender, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE Gender = @tgender)
END

IF(ISNULL(@tmarriage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE MaritalStatus = @tmarriage)
END

IF(ISNULL(@tnationality, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE Nationality = @tnationality)
END

IF(ISNULL(@tdialect, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE Dialect = @tdialect)
END

IF(ISNULL(@teducation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE Education = @teducation)
END

IF(ISNULL(@toccupation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE Occupation = @toccupation)
END

IF(ISNULL(@tcongregation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo WHERE Congregation = @tcongregation)
END

IF(ISNULL(@tcellgroup, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo WHERE CellGroup = @tcellgroup)
END

IF(ISNULL(@tbatismchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE BaptismChurch = @tbatismchurch)
END

IF(ISNULL(@tconfirmchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE ConfirmChurch = @tconfirmchurch)
END

IF(ISNULL(@tpreviouschurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE PreviousChurch = @tpreviouschurch)
END

IF(ISNULL(@tbaptismby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE BaptismBy = @tbaptismby)
END

IF(ISNULL(@tconfirmby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE ConfirmBy = @tconfirmby)
END

IF(ISNULL(@tlanguage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_members AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(A.[Language],',') WHERE items = @tlanguage))
END

IF(ISNULL(@tministry, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_membersOtherInfo AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(8000), A.MinistryInvolvement),'<Ministry/>',''),'</MinistryID><MinistryID>',','),'<Ministry><MinistryID>',''),'</MinistryID></Ministry>',''), ',') WHERE items = @tministry))
END

IF(ISNULL(@tresidentalarea, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members WHERE SUBSTRING(CONVERT(VARCHAR(7),AddressPostalCode), 1, 2) IN (SELECT RTRIM(LTRIM(ITEMS)) FROM dbo.udf_Split(@tresidentalarea, ',')))
END












DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'
SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
		dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
		A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
		A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
		A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
		ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
		dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
		ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
		
FROM dbo.tb_membersOtherInfo AS B 
INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
WHERE A.CurrentParish = @CurrentParish AND B.NRIC IN (SELECT NRIC FROM @allMember)

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getMembersReporting]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMembersReporting]
(@reportType VARCHAR(10),
 @inputA VARCHAR(100),
 @inputB VARCHAR(100), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'
DECLARE @congregationTable Table (congregationID TINYINT)

INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))

	
	IF(@reportType = 'MIN')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		CROSS APPLY B.MinistryInvolvement.nodes('/Ministry/MinistryID') t(MinInv)
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND MinInv.value('(.)', 'VARCHAR(10)') = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'CELL')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND ISNULL(K.CellgroupID, '') = ISNULL(@inputA, '')
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'BapCon')
	BEGIN	
		IF(@inputA = 'NotBap')
		BEGIN
			SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND ISNULL(CONVERT(VARCHAR(20),A.BaptismDate, 103),'NULL') = 'NULL'
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
		ELSE IF(@inputA = 'BapNotCon')
		BEGIN
			SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll,  B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND LEN(CONVERT(VARCHAR(20),A.BaptismDate, 103)) > 5 AND ISNULL(CONVERT(VARCHAR(20),B.MemberDate, 103),'NULL') = 'NULL'
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
		ELSE IF(@inputA = 'BapAndCon')
		BEGIN
			SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND LEN(CONVERT(VARCHAR(20),A.BaptismDate, 103)) > 5 AND LEN(CONVERT(VARCHAR(20),B.MemberDate, 103)) > 5
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
	END
	ELSE IF(@reportType = 'MAR')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND A.MaritalStatus = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'OCC')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND A.Occupation = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'AGE')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish 
		AND ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') >= @inputA
		AND ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') <= @inputB
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'ELECT')
	BEGIN	
		SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') <> ''
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getMemberInformationPrinting]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMemberInformationPrinting]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;

	SELECT	C.ParishName, D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
			dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
			A.AddressHouseBlk + ' ' + A.AddressStreet AS Address1, 'Singapore '+ CONVERT(VARCHAR(MAX),A.AddressPostalCode) AS Address2,
			A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
			A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
			A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
			'Sponsor: ' + dbo.udf_getStafforMemberName(B.Sponsor1) + ', ' + dbo.udf_getStafforMemberName(B.Sponsor2) AS Remarks1, '' AS Remarks2,
			A.CreatedDate, A.Family, A.Child, B.ElectoralRoll AS ElectoralRoll, B.MemberDate, A.TransferReason, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers, 
			SUBSTRING (A.ICPhoto, 0, 37) AS [GUID], SUBSTRING (A.ICPhoto, 38, 999) AS [Filename]
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_membersOtherInfo AS B ON A.NRIC = B.NRIC
	INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
	INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
	INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
	INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
	LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
	LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
	LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
	LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
	WHERE A.NRIC = @NRIC
	

SET NOCOUNT OFF;

--[dbo].[usp_getMemberInformationPrinting] 'S7286405J'
GO
/****** Object:  StoredProcedure [dbo].[usp_getMemberInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getMemberInformation]
(@NRIC VARCHAR(10), @Type VARCHAR(10))
AS
SET NOCOUNT ON;

DECLARE @tNRIC VARCHAR(10) = @NRIC, @tType VARCHAR(10) = @Type;

IF(@tType = 'Actual')
BEGIN
	SELECT [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
      ,[ChineseName],[DOB] ,[Gender] ,@tNRIC AS [NRIC] ,[Nationality] ,[Dialect] ,[MaritalStatus]
      ,[MarriageDate]  ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit] ,[Email]
      ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate]
      ,[BaptismBy] ,[BaptismChurch] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmChurch] ,[Family] ,[Child] ,[CurrentParish]
      ,[ICPhoto] ,[PreviousChurch] ,[DeceasedDate] ,[CreatedDate], TransferReason 
      ,B.CellGroup, B.Congregation, CarIU, B.Remarks, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers
      ,   Convert(XML, ISNULL((SELECT B.CourseName AS CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @tNRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended 
      ,B.ElectoralRoll, B.MinistryInvolvement, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, B.MemberDate, B.TransferTo, B.TransferToDate
      ,dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Name
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @tNRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'Membership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_membersOtherInfo AS B ON A.NRIC = B.NRIC
	WHERE A.NRIC = @tNRIC
END
ELSE IF(@tType = 'Temp')
BEGIN
	SELECT [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
      ,[ChineseName],[DOB] ,[Gender] ,@tNRIC AS [NRIC] ,[Nationality] ,[Dialect] ,[MaritalStatus]
      ,[MarriageDate]  ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit] ,[Email]
      ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate]
      ,[BaptismBy] ,[BaptismChurch] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmChurch] ,[Family] ,[Child] ,[CurrentParish]
      ,[ICPhoto] ,[PreviousChurch] ,[DeceasedDate] ,[CreatedDate], TransferReason 
      ,B.CellGroup, B.Congregation, CarIU, B.Remarks, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers
      , Convert(XML, ISNULL((SELECT B.CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @tNRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended
      , B.ElectoralRoll, B.MinistryInvolvement, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, B.MemberDate, B.TransferTo, B.TransferToDate
      ,dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Name
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @tNRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'Membership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC
	WHERE A.NRIC = @tNRIC
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getListOfTempMembersForApproval]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getListOfTempMembersForApproval]

AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	SELECT TOP 100 NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	INNER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE CurrentParish = @CurrentParish
	ORDER BY Name, NRIC

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getListofMinistry]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getListofMinistry]
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT MinistryID, MinistryName, dbo.udf_getStafforMemberName(MinistryInCharge) AS Name, [MinistryDescription] FROM dbo.tb_ministry AS A
WHERE DELETED = 0

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getListofCourseParticipants]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCourseParticipants]
(@courseID INT)
AS
SET NOCOUNT ON;

  SELECT A.NRIC, ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName) AS EnglishName, courseID, feePaid, materialReceived,
  dbo.udf_getAttendancePercentage(A.NRIC, @courseID, 'percentage') AS Percentage, dbo.udf_getAttendancePercentage(A.NRIC, @courseID, '') AS Attendance
  FROM dbo.tb_course_participant AS A
  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
  WHERE courseID = @courseid

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getListofCourse]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCourse]
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT courseID, CourseName, REPLACE(CourseStartDate, ',', ', ')AS CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name FROM dbo.tb_course AS A
LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
WHERE dbo.udf_isCourseStillRunning(CourseStartDate, @today) = 1 AND Deleted = 0

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getListofCellgroup]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCellgroup]
AS
SET NOCOUNT ON;

SELECT CellgroupID, CellgroupName, dbo.udf_getStafforMemberName(CellgroupLeader) AS Name FROM dbo.tb_cellgroup
WHERE Deleted = 0

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllStaff]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllStaff]

AS
SET NOCOUNT ON;

	Select RTRIM(LTRIM(ISNULL(B.StyleName, '') + ' ' + Name)) AS Name, A.USERID, Email, Phone, Mobile, Department, ISNULL(D.RoleName, 'Unspecified') AS RoleName FROM tb_users AS A
	LEFT OUTER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	LEFT OUTER JOIN dbo.tb_Roles_Users AS C ON C.UserID = A.UserID
	LEFT OUTER JOIN dbo.tb_Roles AS D ON D.RoleID = C.RoleID
	

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getAllUploadedAttachment]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllUploadedAttachment]
(@nric VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @xml AS XML = ( select ISNULL(Remarks,' ') AS Remarks, AttachmentID, CONVERT(VARCHAR(15),[Date], 103) AS [DATE], [GUID], [Filename], A.FileType AS FileType FROM dbo.tb_members_attachments
						INNER JOIN dbo.tb_file_type AS A ON A.FileTypeID = dbo.tb_members_attachments.FileType
						WHERE NRIC = @nric FOR XML PATH('Attachment'), ELEMENTS, ROOT('AllAttachments'))		
SELECT CONVERT(XML, ISNULL(@xml, '<AllAttachments />')) AS [XML];

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseVisitorParticipant]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipant]
(@nric VARCHAR(10),
@course VARCHAR(10),
@salutation VARCHAR(10),
@english_name VARCHAR(50),
@dob DATE,
@gender VARCHAR(1),
@education VARCHAR(10),
@nationality VARCHAR(10),
@occupation VARCHAR(10),
@postal_code VARCHAR(6),
@blk_house  VARCHAR(10),
@street_address  VARCHAR(1000),
@unit  VARCHAR(10),
@contact  VARCHAR(15),
@email  VARCHAR(100),
@church INT,
@church_others VARCHAR(100), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
BEGIN
	SELECT 'NRICEXISTS' AS Result, '' AS SalutationName, @english_name AS EnglishName, '' AS CourseName
END
ELSE
BEGIN
	
	if(len(@postal_code) = 0)
	BEGIN
		SET @postal_code = null;
	END
	if(@dob = CONVERT(DATE, '',103))
	BEGIN
		SET @dob = NULL;
	END
	
	INSERT INTO dbo.tb_visitors(Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID)
	SELECT @nric, @course;
	
	DECLARE @newVisitorXML XML = (
	SELECT  C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	DECLARE @temp table(a INT)
	INSERT INTO @temp(a)
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
	
	SELECT 'OK' AS Result, ISNULL(D.SalutationName, '') AS SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
	INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
	INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
	LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
	WHERE A.NRIC = @nric AND A.courseID = @course
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_updateVistor]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_updateVistor]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_occupation VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob VARCHAR(15),
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(100),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_contact VARCHAR(15),
@candidate_education VARCHAR(3),
@candidate_church VARCHAR(3),
@candidate_churchOthers VARCHAR(100)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = DOB,
	@candidate_nationality = Nationality, @candidate_contact = Contact,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation,
	@candidate_church = Church, @candidate_churchOthers = ChurchOthers
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(15) './DOB',
	Nationality VARCHAR(3) './Nationality',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	Contact VARCHAR(15) './Contact',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	Occupation VARCHAR(3) './Occupation',
	Church VARCHAR(3) './Church',
	ChurchOthers VARCHAR(3) './ChurchOthers');	

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_gender) = 0)
BEGIN
	SET @candidate_gender = ''
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob VARCHAR(15)
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_contact VARCHAR(15)
	DECLARE @Orig_candidate_church VARCHAR(3)
	DECLARE @Orig_candidate_church_others VARCHAR(100)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));																									

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = ISNULL(CONVERT(VARCHAR(15),DOB,103),''), @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_contact = Contact, @Orig_candidate_church = CONVERT(VARCHAR(3),Church), @Orig_candidate_church_others = ChurchOthers
	FROM dbo.tb_visitors AS A
	WHERE A.NRIC = @candidate_original_nric;
	
	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_salutation <> @candidate_salutation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));		
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_contact <> @candidate_contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Contact', @Orig_candidate_contact, @candidate_contact);
	END
	
	IF(@Orig_candidate_church <> @candidate_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_candidate_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @candidate_church);
	END

	IF(@Orig_candidate_church_others <> @candidate_churchOthers)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Church Others', @Orig_candidate_church_others, @candidate_churchOthers);
	END
		
	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		IF(LEN(@candidate_dob) = 0)
		BEGIN
			SET @candidate_dob = NULL;
		END
		
		UPDATE tb_visitors SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Occupation = @candidate_occupation,
							DOB = CONVERT(DATE, @candidate_dob, 103),
							Gender = @candidate_gender,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Contact = @candidate_contact,
							Email = @candidate_email,
							Education = @candidate_education,
							Church = CONVERT(TINYINT,@candidate_church),
							ChurchOthers = @candidate_churchOthers
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'UpdateVisitor', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_updateTempMember]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_updateTempMember]
(@updateXML XML)
AS
SET NOCOUNT ON;


DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_dialect VARCHAR(4),
@candidate_occupation VARCHAR(4),
@baptized_by VARCHAR(50),
@baptism_church VARCHAR(4),
@confirmation_by VARCHAR(50),
@confirmation_church VARCHAR(4),
@previous_church_membership VARCHAR(4),
@candidate_chinses_name NVARCHAR(50),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_marital_status VARCHAR(3),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_language VARCHAR(200),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_baptism_date VARCHAR(15),
@candidate_confirmation_date VARCHAR(15),
@candidate_marriage_date VARCHAR(15),
@candidate_congregation VARCHAR(3),
@candidate_electoralroll VARCHAR(15),
@candidate_cellgroup VARCHAR(3),
@candidate_sponsor1 VARCHAR(10),
@candidate_sponsor2 VARCHAR(100),
@candidate_sponsor2contact VARCHAR(100),
@candidate_transfer_reason VARCHAR(1000),
@candidate_ministry XML,
@candidate_DeceasedDate VARCHAR(15),
@candidate_MemberDate VARCHAR(15),
@candidate_cariu VARCHAR(20),
@candidate_remarks VARCHAR(1000),
@family XML,
@child XML,
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100),
@transferTo VARCHAR(100),
@transferToDate VARCHAR(15),
@Filename VARCHAR(200),
@GUID VARCHAR(50),
@Filetype VARCHAR(3),
@Fileremarks VARCHAR(1000)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact = Sponsor2Contact, @candidate_electoralroll = ElectoralRoll,
	@candidate_remarks = Remarks, @candidate_cariu = CarIU, @candidate_transfer_reason = TransferReason, @candidate_cellgroup = Cellgroup, @candidate_ministry = MinistryInvolvement, @candidate_DeceasedDate = DeceasedDate, @candidate_MemberDate = MemberDate, @candidate_congregation = Congregation,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers,
	@transferTo = TransferTo, @transferToDate = TransferToDate,
	@Filename = [Filename], @GUID = [GUID], @Filetype = Filetype, @Fileremarks = Fileremarks
	FROM OPENXML(@idoc, '/Update')
	WITH (
	[Filename] VARCHAR(200)'./Filename',
	[GUID] VARCHAR(50)'./GUID',
	Filetype VARCHAR(3)'./Filetype',
	Fileremarks VARCHAR(1000)'./FileRemarks',
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	ChineseName NVARCHAR(50) './ChineseName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	MaritalStatus VARCHAR(3) './MaritalStatus',
	MarriageDate VARCHAR(20) './MarriageDate',
	Nationality VARCHAR(3) './Nationality',
	Dialect VARCHAR(3) './Dialect',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	[Language] VARCHAR(200) './Language',
	Occupation VARCHAR(3) './Occupation',
	Congregation VARCHAR(3) './Congregation',
	BaptismBy VARCHAR(20) './BaptismBy',
	BaptismDate VARCHAR(10) './BaptismDate',
	BaptismChurch VARCHAR(3) './BaptismChurch',
	ConfirmationBy VARCHAR(20) './ConfirmationBy',
	ConfirmationChurch VARCHAR(3) './ConfirmationChurch',
	ConfirmationDate VARCHAR(10) './ConfirmationDate',
	TransferReason VARCHAR(10) './TransferReason',
	PreviousChurchMembership VARCHAR(3) './PreviousChurchMembership',
	CarIU VARCHAR(20) './CarIU',
	Remarks VARCHAR(1000) './Remarks',
	FamilyXML XML './FamilyXML/FamilyList',
	ChildXML XML './ChildXML/ChildList',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(100) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	ElectoralRoll VARCHAR(10) './ElectoralRoll',
	Cellgroup VARCHAR(3) './Cellgroup',
	MinistryInvolvement XML './MinistryInvolvement/Ministry',
	MemberDate VARCHAR(10) './MemberDate',
	DeceasedDate VARCHAR(10) './DeceasedDate',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers',
	TransferTo VARCHAR(100) './TransferTo',
	TransferToDate VARCHAR(100) './TransferToDate');

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_cellgroup) = 0)
BEGIN
	SET @candidate_cellgroup = '0'
END

IF(LEN(@candidate_dialect) = 0)
BEGIN
	SET @candidate_dialect = '0'
END

IF(LEN(@previous_church_membership) = 0)
BEGIN
	SET @previous_church_membership = '0'
END

IF(LEN(@baptism_church) = 0)
BEGIN
	SET @baptism_church = '0'
END

IF(LEN(@confirmation_church) = 0)
BEGIN
	SET @confirmation_church = '0'
END

IF(LEN(@TransferToDate) = 0)
BEGIN
	SET @TransferToDate = NULL;
END

IF(LEN(@candidate_MemberDate) = 0)
BEGIN
	SET @candidate_MemberDate = NULL;
END

IF(LEN(@candidate_DeceasedDate) = 0)
BEGIN
	SET @candidate_DeceasedDate = NULL;
END

IF(LEN(@candidate_electoralroll) = 0)
BEGIN
	SET @candidate_electoralroll = NULL;
END

IF(LEN(@candidate_baptism_date) = 0)
BEGIN
	SET @candidate_baptism_date = NULL;
END

IF(LEN(@candidate_marriage_date) = 0)
BEGIN
	SET @candidate_marriage_date = NULL;
END

if(LEN(@candidate_confirmation_date) = 0)
BEGIN
	SET @candidate_confirmation_date = NULL;
END

IF EXISTS( SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_photo VARCHAR(1000)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_dialect VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_baptized_by VARCHAR(50)
	DECLARE @Orig_baptism_church VARCHAR(4)
	DECLARE @Orig_confirmation_by VARCHAR(50)
	DECLARE @Orig_confirmation_church VARCHAR(4)
	DECLARE @Orig_previous_church_membership VARCHAR(4)
	DECLARE @Orig_candidate_chinses_name NVARCHAR(50)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_marital_status VARCHAR(3)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_language VARCHAR(200)
	DECLARE @Orig_candidate_home_tel VARCHAR(15)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)
	DECLARE @Orig_candidate_baptism_date VARCHAR(15)
	DECLARE @Orig_candidate_confirmation_date VARCHAR(15)
	DECLARE @Orig_candidate_marriage_date VARCHAR(15)
	DECLARE @Orig_candidate_congregation VARCHAR(3)
	DECLARE @Orig_candidate_electoralroll VARCHAR(15)
	DECLARE @Orig_candidate_cellgroup VARCHAR(3)
	DECLARE @Orig_candidate_sponsor1 VARCHAR(20)
	DECLARE @Orig_candidate_sponsor2 VARCHAR(100)
	DECLARE @Orig_candidate_sponsor2contact VARCHAR(100)
	DECLARE @Orig_candidate_transfer_reason VARCHAR(1000)
	DECLARE @Orig_candidate_ministry XML
	DECLARE @Orig_candidate_DeceasedDate VARCHAR(15)
	DECLARE @Orig_candidate_MemberDate VARCHAR(15)
	DECLARE @Orig_candidate_remarks VARCHAR(1000)
	DECLARE @Orig_candidate_cariu VARCHAR(20)
	DECLARE @Orig_family XML
	DECLARE @Orig_child XML
	
	DECLARE @Orig_baptism_by_others VARCHAR(100),
	@Orig_confirm_by_others VARCHAR(100),
	@Orig_baptism_church_others VARCHAR(100),
	@Orig_confirm_church_others VARCHAR(100),
	@Orig_previous_church_others VARCHAR(100),
	@Orig_transferTo VARCHAR(100),
	@Orig_transferToDate VARCHAR(15)

	DECLARE @FileAdded TABLE ([filename] VARCHAR(200),
								[GUID] VARCHAR(50),
								FileType VARCHAR(100),
								Fileremarks VARCHAR(1000))

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	
	DECLARE @FamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @OriginalFamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
								
	DECLARE @FamilyAdded TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @FamilyRemoved TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	
	DECLARE @ChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @OriginalChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildAdded TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildRemoved TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	
	DECLARE @MinistryTable TABLE (MinistryID VARCHAR(100),
								  MinistryName VARCHAR(100))
	DECLARE @OriginalMinistryTable TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
	DECLARE @MinistryTableAdded TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
    DECLARE @MinistryTableRemoved TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))										  
																																

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_dialect = Dialect, @Orig_candidate_occupation = Occupation, @Orig_baptized_by = BaptismBy, @Orig_baptism_church = BaptismChurch,
			@Orig_confirmation_by = ConfirmBy, @Orig_confirmation_church = ConfirmChurch, @Orig_previous_church_membership = PreviousChurch, @Orig_candidate_chinses_name = ChineseName,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_marital_status = MaritalStatus, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education, @Orig_candidate_language = [Language],
			@Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_baptism_date = CONVERT(VARCHAR(15), BaptismDate,103), @Orig_candidate_confirmation_date = CONVERT(VARCHAR(15), ConfirmDate, 103),
			@Orig_candidate_marriage_date = CONVERT(VARCHAR(15),MarriageDate, 103), @Orig_family = Family, @Orig_child = Child, @Orig_candidate_congregation = Congregation, @Orig_candidate_sponsor1 = Sponsor1, @Orig_candidate_sponsor2 = Sponsor2, @Orig_candidate_sponsor2contact = Sponsor2Contact,
			@Orig_candidate_ministry = MinistryInvolvement, @Orig_candidate_DeceasedDate = CONVERT(VARCHAR(15), DeceasedDate, 103), @Orig_candidate_electoralroll = CONVERT(VARCHAR(15), ElectoralRoll, 103),
			@Orig_candidate_cariu = CarIU, @Orig_candidate_remarks = B.Remarks, @Orig_candidate_transfer_reason = TransferReason, @Orig_candidate_cellgroup = CellGroup, @Orig_candidate_MemberDate = CONVERT(VARCHAR(15), MemberDate, 103),
			@Orig_baptism_by_others = BaptismByOthers,
			@Orig_confirm_by_others = ConfirmByOthers,
			@Orig_baptism_church_others = BaptismChurchOthers,
			@Orig_confirm_church_others = ConfirmChurchOthers,
			@Orig_previous_church_others = PreviousChurchOthers,
			@Orig_transferTo = B.TransferTo,
			@Orig_transferToDate = CONVERT(VARCHAR(15),B.TransferToDate, 103)
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON B.NRIC = A.NRIC
	WHERE A.NRIC = @candidate_original_nric
	
	IF(LEN(@Filename) > 0)
	BEGIN
		INSERT INTO @FileAdded ([filename], [GUID], FileType, Fileremarks)
		SELECT @Filename, @GUID, @Filetype, @Fileremarks;
		
		INSERT INTO dbo.tb_members_attachments([DATE], NRIC, [GUID], [Filename], FileType, Remarks)
		SELECT GETDATE(), @candidate_nric, @GUID, @Filename, @Filetype, @Fileremarks;
	END
	
	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_salutation <> @candidate_salutation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));		
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
	END

	IF(@Orig_candidate_chinses_name <> @candidate_chinses_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Name', @Orig_candidate_chinses_name, @candidate_chinses_name);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_transfer_reason <> @candidate_transfer_reason)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer Reason', @Orig_candidate_transfer_reason, @candidate_transfer_reason);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
	END

	IF(@Orig_candidate_dialect <> @candidate_dialect)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Dialect', ISNULL((SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @Orig_candidate_dialect), ''), ISNULL((SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @candidate_dialect), ''));
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
	END

	IF(@Orig_baptized_by <> @baptized_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Baptised By', ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @Orig_baptized_by),''), ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @baptized_by),'');
	END

	IF(@Orig_baptism_church <> @baptism_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Baptism Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_baptism_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @baptism_church);
	END

	IF(ISNULL(@Orig_candidate_baptism_date,'') <> ISNULL(@candidate_baptism_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Date', ISNULL(@Orig_candidate_baptism_date,''), ISNULL(@candidate_baptism_date,''));
	END

	IF(@Orig_confirmation_by <> @confirmation_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Confirmation By', ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @Orig_confirmation_by),''), ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @confirmation_by),'');
	END

	IF(@Orig_confirmation_church <> @confirmation_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Conformation Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_confirmation_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @confirmation_church);
	END

	IF(ISNULL(@Orig_candidate_confirmation_date,'') <> ISNULL(@candidate_confirmation_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Date', ISNULL(@Orig_candidate_confirmation_date,''), ISNULL(@candidate_confirmation_date,''));
	END

	IF(@Orig_previous_church_membership <> @previous_church_membership)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Previous Church Membership', ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_previous_church_membership),''), ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @previous_church_membership),''));		
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_marital_status <> @candidate_marital_status)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Marital Status', (SELECT MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @Orig_candidate_marital_status), (SELECT MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @candidate_marital_status);
	END

	IF(ISNULL(@Orig_candidate_marriage_date,'') <> ISNULL(@candidate_marriage_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marriage Date', ISNULL(@Orig_candidate_marriage_date,''), ISNULL(@candidate_marriage_date,''));
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_language <> @candidate_language)
	BEGIN
		DECLARE @oldLang VARCHAR(1000) = '';
		DECLARE @newLang VARCHAR(1000) = '';
		
		SELECT @oldLang = @oldLang + A.LanguageName + ', ' FROM dbo.udf_Split(@Orig_candidate_language, ',')
		LEFT OUTER JOIN dbo.tb_language AS A ON A.LanguageID = items;
		
		SELECT @newLang = @newLang + A.LanguageName + ', ' FROM dbo.udf_Split(@candidate_language, ',')
		LEFT OUTER JOIN dbo.tb_language AS A ON A.LanguageID = items;
	
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Language', @oldLang, @newLang);
	END

	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END

	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Congregation', (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @Orig_candidate_congregation), (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @candidate_congregation);
	END

	IF(@Orig_candidate_sponsor1 <> @candidate_sponsor1)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Sponsor 1', ISNULL((SELECT dbo.udf_getStafforMemberName(@Orig_candidate_sponsor1)),''), ISNULL((SELECT dbo.udf_getStafforMemberName(@candidate_sponsor1)),'');
	END

	IF(@Orig_candidate_sponsor2 <> @candidate_sponsor2)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2', @Orig_candidate_sponsor2, @candidate_sponsor2);
	END
	
	IF(@Orig_candidate_sponsor2contact <> @candidate_sponsor2contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2 Contact', @Orig_candidate_sponsor2contact, @candidate_sponsor2contact);
	END
	
	IF(ISNULL(@Orig_candidate_DeceasedDate,'') <> ISNULL(@candidate_DeceasedDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Deceased Date', ISNULL(@Orig_candidate_DeceasedDate,''), ISNULL(@candidate_DeceasedDate,''));
	END
	
	IF(ISNULL(@Orig_candidate_MemberDate,'') <> ISNULL(@candidate_MemberDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Church Member as of', ISNULL(@Orig_candidate_MemberDate,''), ISNULL(@candidate_MemberDate,''));
	END
	
	IF(ISNULL(@Orig_candidate_electoralroll,'') <> ISNULL(@candidate_electoralroll,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Electoral Roll Date', ISNULL(@Orig_candidate_electoralroll,''), ISNULL(@candidate_electoralroll,''));
	END
	
	IF(@Orig_candidate_remarks <> @candidate_remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_candidate_remarks, @candidate_remarks);
	END
	
	IF(@Orig_candidate_cariu <> @candidate_cariu)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Car IU', @Orig_candidate_cariu, @candidate_cariu);
	END
	
	IF(@Orig_candidate_cellgroup <> @candidate_cellgroup)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Cellgroup', ISNULL((SELECT CellgroupName FROM dbo.tb_cellgroup WHERE CellgroupID = @Orig_candidate_cellgroup),''), ISNULL((SELECT CellgroupName FROM dbo.tb_cellgroup WHERE CellgroupID = @candidate_cellgroup),'');
	END
	
	IF(@Orig_baptism_by_others <> @baptism_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_baptism_by_others, @baptism_by_others);
	END
	IF(@Orig_confirm_by_others <> @confirm_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm By Others', @Orig_confirm_by_others, @confirm_by_others);
	END
	IF(@Orig_baptism_church_others <> @baptism_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church By Others', @Orig_baptism_church_others, @baptism_church_others);
	END
	IF(@Orig_confirm_church_others <> @confirm_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm Church By Others', @Orig_confirm_church_others, @confirm_church_others);
	END
	IF(@Orig_previous_church_others <> @previous_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_previous_church_others, @previous_church_others);
	END
	
	IF(ISNULL(@Orig_transferTo,'') <> ISNULL(@transferTo,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer To', ISNULL(@Orig_transferTo,''), ISNULL(@transferTo,''));
	END
	
	IF(ISNULL(@Orig_transferToDate,'') <> ISNULL(@transferToDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer To Date', ISNULL(@Orig_transferToDate,''), ISNULL(@transferToDate,''));
	END
	
	----------------------------
	
	DECLARE @xdoc int;
	DECLARE @familyxml AS XML = (SELECT Family FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;

	INSERT INTO @OriginalFamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	SET @familyxml = @family;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;
	
	INSERT INTO @FamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	INSERT INTO @FamilyAdded
	SELECT * FROM @FamilyTable WHERE FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion NOT IN (SELECT FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion FROM @OriginalFamilyTable)
	
	INSERT INTO @FamilyRemoved
	SELECT * FROM @OriginalFamilyTable WHERE FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion NOT IN (SELECT FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion FROM @FamilyTable)	
	
	-------------------------
	
	
	DECLARE @chilexml AS XML = (SELECT Child FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;

	INSERT INTO @OriginalChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	SET @chilexml = @child;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;
	
	INSERT INTO @ChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	INSERT INTO @ChildAdded
	SELECT * FROM @ChildTable WHERE ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch NOT IN (SELECT ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch FROM @OriginalChildTable)
	
	INSERT INTO @ChildRemoved
	SELECT * FROM @OriginalChildTable WHERE ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch NOT IN (SELECT ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch FROM @ChildTable)	
	
	--------------
	
	
	DECLARE @ministryxml AS VARCHAR(MAX) = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(SELECT MinistryInvolvement FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @candidate_original_nric)), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');

	INSERT INTO @OriginalMinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	SET @ministryxml = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@candidate_ministry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');
	
	INSERT INTO @MinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	INSERT INTO @MinistryTableAdded
	SELECT * FROM @MinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @OriginalMinistryTable)
	
	INSERT INTO @MinistryTableRemoved
	SELECT * FROM @OriginalMinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @MinistryTable)	
	
	--------------
	
	
	
	DECLARE @returnTable TABLE (
		FromTo XML,
		FamilyRemoved XML,
		FamilyAdded XML,
		ChildRemoved XML,
		ChileAdded XML,
		MinistryAdded XML,
		MinistryRemoved XML,
		FileAdded XML);
		
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	OR EXISTS (SELECT 1 FROM @FamilyRemoved)
	OR EXISTS (SELECT 1 FROM @FamilyAdded)
	OR EXISTS (SELECT 1 FROM @ChildAdded)
	OR EXISTS (SELECT 1 FROM @ChildRemoved)
	OR EXISTS (SELECT 1 FROM @MinistryTableAdded)
	OR EXISTS (SELECT 1 FROM @MinistryTableRemoved)
	OR EXISTS (SELECT 1 FROM @FileAdded)
	BEGIN
		INSERT INTO @returnTable (FromTo, FamilyRemoved, FamilyAdded, MinistryRemoved, MinistryAdded, ChildRemoved, ChileAdded, FileAdded)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyRemoved FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyAdded FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableRemoved FOR XML RAW('Ministry'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableAdded FOR XML RAW('Ministry'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildRemoved FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildAdded FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT [filename], [GUID], FileType, Fileremarks FROM @FileAdded FOR XML RAW('AttachmentAdded'), ELEMENTS));
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo, FamilyRemoved, FamilyAdded, ChildRemoved, ChileAdded, MinistryRemoved, MinistryAdded, FileAdded FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		
		
		UPDATE tb_members_temp SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							ICPhoto = @candidate_photo,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Dialect = @candidate_dialect,
							Occupation = @candidate_occupation,
							BaptismBy = @baptized_by,
							BaptismChurch = @baptism_church,
							ConfirmBy = @confirmation_by,
							ConfirmChurch = @confirmation_church,
							PreviousChurch = @previous_church_membership,
							ChineseName = @candidate_chinses_name,
							DOB = @candidate_dob,
							Gender = @candidate_gender,
							MaritalStatus = @candidate_marital_status,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Email = @candidate_email,
							Education = @candidate_education,
							[Language] = @candidate_language,
							HomeTel = @candidate_home_tel,
							MobileTel = @candidate_mobile_tel,
							TransferReason = @candidate_transfer_reason,
							CarIU = @candidate_cariu,
							BaptismDate = CONVERT(DATETIME, @candidate_baptism_date, 103),
							ConfirmDate = CONVERT(DATETIME, @candidate_confirmation_date, 103),
							MarriageDate = CONVERT(DATETIME, @candidate_marriage_date, 103),
							CurrentParish = @CurrentParish,
							DeceasedDate = CONVERT(DATETIME, @candidate_DeceasedDate, 103),
							Family = @family,
							Child = @child,
							BaptismByOthers = @baptism_by_others,
							ConfirmByOthers = @confirm_by_others,
							BaptismChurchOthers = @baptism_church_others,
							ConfirmChurchOthers = @confirm_church_others,
							PreviousChurchOthers = @previous_church_others
		WHERE NRIC = @candidate_original_nric
			
		UPDATE dbo.tb_membersOtherInfo_temp SET Congregation = @candidate_congregation,
									   NRIC = @candidate_nric,
									   ElectoralRoll = CONVERT(DATETIME, @candidate_electoralroll, 103),
									   CellGroup = @candidate_cellgroup,
									   MinistryInvolvement = @candidate_ministry,
									   Sponsor1 = @candidate_sponsor1,
									   Sponsor2 = @candidate_sponsor2,
									   Sponsor2Contact = @candidate_sponsor2contact,
									   Remarks = @candidate_remarks,
									   TransferTo = @transferTo,
									   TransferToDate = CONVERT(DATE, @transferToDate, 103),
									   MemberDate = @candidate_MemberDate
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_updateMember]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_updateMember]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_dialect VARCHAR(4),
@candidate_occupation VARCHAR(4),
@baptized_by VARCHAR(50),
@baptism_church VARCHAR(4),
@confirmation_by VARCHAR(50),
@confirmation_church VARCHAR(4),
@previous_church_membership VARCHAR(4),
@candidate_chinses_name NVARCHAR(50),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_marital_status VARCHAR(3),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_language VARCHAR(200),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_baptism_date VARCHAR(15),
@candidate_confirmation_date VARCHAR(15),
@candidate_marriage_date VARCHAR(15),
@candidate_congregation VARCHAR(3),
@candidate_electoralroll VARCHAR(15),
@candidate_cellgroup VARCHAR(3),
@candidate_sponsor1 VARCHAR(20),
@candidate_sponsor2 VARCHAR(100),
@candidate_sponsor2contact VARCHAR(100),
@candidate_transfer_reason VARCHAR(1000),
@candidate_ministry XML,
@candidate_DeceasedDate VARCHAR(15),
@candidate_MemberDate VARCHAR(15),
@candidate_cariu VARCHAR(20),
@candidate_remarks VARCHAR(1000),
@family XML,
@child XML,
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100),
@transferTo VARCHAR(100),
@transferToDate VARCHAR(15),
@Filename VARCHAR(200),
@GUID VARCHAR(50),
@Filetype VARCHAR(3),
@Fileremarks VARCHAR(1000)


	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact = Sponsor2Contact, @candidate_electoralroll = ElectoralRoll,
	@candidate_remarks = Remarks, @candidate_cariu = CarIU, @candidate_transfer_reason = TransferReason, @candidate_cellgroup = Cellgroup, @candidate_ministry = MinistryInvolvement, @candidate_DeceasedDate = DeceasedDate, @candidate_MemberDate = MemberDate, @candidate_congregation = Congregation,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers,
	@transferTo = TransferTo, @transferToDate = TransferToDate,
	@Filename = [Filename], @GUID = [GUID], @Filetype = Filetype, @Fileremarks = Fileremarks
	FROM OPENXML(@idoc, '/Update')
	WITH (
	[Filename] VARCHAR(200)'./Filename',
	[GUID] VARCHAR(50)'./GUID',
	Filetype VARCHAR(3)'./Filetype',
	Fileremarks VARCHAR(1000)'./FileRemarks',	
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	ChineseName NVARCHAR(50) './ChineseName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	MaritalStatus VARCHAR(3) './MaritalStatus',
	MarriageDate VARCHAR(20) './MarriageDate',
	Nationality VARCHAR(3) './Nationality',
	Dialect VARCHAR(3) './Dialect',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	[Language] VARCHAR(200) './Language',
	Occupation VARCHAR(3) './Occupation',
	Congregation VARCHAR(3) './Congregation',
	BaptismBy VARCHAR(20) './BaptismBy',
	BaptismDate VARCHAR(10) './BaptismDate',
	BaptismChurch VARCHAR(3) './BaptismChurch',
	ConfirmationBy VARCHAR(20) './ConfirmationBy',
	ConfirmationChurch VARCHAR(3) './ConfirmationChurch',
	ConfirmationDate VARCHAR(10) './ConfirmationDate',
	PreviousChurchMembership VARCHAR(3) './PreviousChurchMembership',
	TransferReason VARCHAR(1000) './TransferReason',
	CarIU VARCHAR(20) './CarIU',
	Remarks VARCHAR(1000) './Remarks',
	FamilyXML XML './FamilyXML/FamilyList',
	ChildXML XML './ChildXML/ChildList',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(100) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	ElectoralRoll VARCHAR(10) './ElectoralRoll',
	Cellgroup VARCHAR(3) './Cellgroup',
	MinistryInvolvement XML './MinistryInvolvement/Ministry',
	MemberDate VARCHAR(10) './MemberDate',
	DeceasedDate VARCHAR(10) './DeceasedDate',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers',
	TransferTo VARCHAR(100) './TransferTo',
	TransferToDate VARCHAR(100) './TransferToDate');

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_cellgroup) = 0)
BEGIN
	SET @candidate_cellgroup = '0'
END

IF(LEN(@candidate_dialect) = 0)
BEGIN
	SET @candidate_dialect = '0'
END

IF(LEN(@previous_church_membership) = 0)
BEGIN
	SET @previous_church_membership = '0'
END

IF(LEN(@baptism_church) = 0)
BEGIN
	SET @baptism_church = '0'
END

IF(LEN(@confirmation_church) = 0)
BEGIN
	SET @confirmation_church = '0'
END

IF(LEN(@TransferToDate) = 0)
BEGIN
	SET @TransferToDate = NULL;
END

IF(LEN(@candidate_MemberDate) = 0)
BEGIN
	SET @candidate_MemberDate = NULL;
END

IF(LEN(@candidate_DeceasedDate) = 0)
BEGIN
	SET @candidate_DeceasedDate = NULL;
END

IF(LEN(@candidate_electoralroll) = 0)
BEGIN
	SET @candidate_electoralroll = NULL;
END

IF(LEN(@candidate_baptism_date) = 0)
BEGIN
	SET @candidate_baptism_date = NULL;
END

IF(LEN(@candidate_marriage_date) = 0)
BEGIN
	SET @candidate_marriage_date = NULL;
END

if(LEN(@candidate_confirmation_date) = 0)
BEGIN
	SET @candidate_confirmation_date = NULL;
END

IF EXISTS( SELECT 1 FROM dbo.tb_members WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_photo VARCHAR(1000)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_dialect VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_baptized_by VARCHAR(50)
	DECLARE @Orig_baptism_church VARCHAR(4)
	DECLARE @Orig_confirmation_by VARCHAR(50)
	DECLARE @Orig_confirmation_church VARCHAR(4)
	DECLARE @Orig_previous_church_membership VARCHAR(4)
	DECLARE @Orig_candidate_chinses_name NVARCHAR(50)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_marital_status VARCHAR(3)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_language VARCHAR(200)
	DECLARE @Orig_candidate_home_tel VARCHAR(15)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)
	DECLARE @Orig_candidate_baptism_date VARCHAR(15)
	DECLARE @Orig_candidate_confirmation_date VARCHAR(15)
	DECLARE @Orig_candidate_marriage_date VARCHAR(15)
	DECLARE @Orig_candidate_congregation VARCHAR(3)
	DECLARE @Orig_candidate_electoralroll VARCHAR(15)
	DECLARE @Orig_candidate_cellgroup VARCHAR(3)
	DECLARE @Orig_candidate_sponsor1 VARCHAR(20)
	DECLARE @Orig_candidate_sponsor2 VARCHAR(100)
	DECLARE @Orig_candidate_sponsor2contact VARCHAR(100)
	DECLARE @Orig_candidate_transfer_reason VARCHAR(1000)
	DECLARE @Orig_candidate_remarks VARCHAR(1000)
	DECLARE @Orig_candidate_cariu VARCHAR(20)
	DECLARE @Orig_candidate_ministry XML
	DECLARE @Orig_candidate_DeceasedDate VARCHAR(15)
	DECLARE @Orig_candidate_MemberDate VARCHAR(15)
	DECLARE @Orig_family XML
	DECLARE @Orig_child XML
	
	DECLARE @Orig_baptism_by_others VARCHAR(100),
	@Orig_confirm_by_others VARCHAR(100),
	@Orig_baptism_church_others VARCHAR(100),
	@Orig_confirm_church_others VARCHAR(100),
	@Orig_previous_church_others VARCHAR(100),
	@Orig_transferTo VARCHAR(100),
	@Orig_transferToDate VARCHAR(15)

	DECLARE @FileAdded TABLE ([filename] VARCHAR(200),
								[GUID] VARCHAR(50),
								FileType VARCHAR(100),
								Fileremarks VARCHAR(1000))

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	
	DECLARE @FamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @OriginalFamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
								
	DECLARE @FamilyAdded TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @FamilyRemoved TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	
	DECLARE @ChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @OriginalChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildAdded TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildRemoved TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	
	DECLARE @MinistryTable TABLE (MinistryID VARCHAR(100),
								  MinistryName VARCHAR(100))
	DECLARE @OriginalMinistryTable TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
	DECLARE @MinistryTableAdded TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
    DECLARE @MinistryTableRemoved TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))										  
																																

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_dialect = Dialect, @Orig_candidate_occupation = Occupation, @Orig_baptized_by = BaptismBy, @Orig_baptism_church = BaptismChurch,
			@Orig_confirmation_by = ConfirmBy, @Orig_confirmation_church = ConfirmChurch, @Orig_previous_church_membership = PreviousChurch, @Orig_candidate_chinses_name = ChineseName,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_marital_status = MaritalStatus, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education, @Orig_candidate_language = [Language],
			@Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_baptism_date = CONVERT(VARCHAR(15), BaptismDate,103), @Orig_candidate_confirmation_date = CONVERT(VARCHAR(15), ConfirmDate, 103),
			@Orig_candidate_marriage_date = CONVERT(VARCHAR(15),MarriageDate, 103), @Orig_family = Family, @Orig_child = Child, @Orig_candidate_congregation = Congregation, @Orig_candidate_sponsor1 = Sponsor1, @Orig_candidate_sponsor2 = Sponsor2, @Orig_candidate_sponsor2contact = Sponsor2Contact,
			@Orig_candidate_ministry = MinistryInvolvement, @Orig_candidate_DeceasedDate = CONVERT(VARCHAR(15), DeceasedDate, 103), @Orig_candidate_electoralroll = CONVERT(VARCHAR(15), ElectoralRoll, 103),
			@Orig_candidate_cariu = CarIU, @Orig_candidate_remarks = B.Remarks, @Orig_candidate_transfer_reason = TransferReason, @Orig_candidate_cellgroup = CellGroup, @Orig_candidate_MemberDate = CONVERT(VARCHAR(15), MemberDate, 103),
			@Orig_baptism_by_others = BaptismByOthers,
			@Orig_confirm_by_others = ConfirmByOthers,
			@Orig_baptism_church_others = BaptismChurchOthers,
			@Orig_confirm_church_others = ConfirmChurchOthers,
			@Orig_previous_church_others = PreviousChurchOthers,
			@Orig_transferTo = B.TransferTo,
			@Orig_transferToDate = CONVERT(VARCHAR(15),B.TransferToDate, 103)
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_membersOtherInfo AS B ON B.NRIC = A.NRIC
	WHERE A.NRIC = @candidate_original_nric

	IF(LEN(@Filename) > 0)
	BEGIN
		INSERT INTO @FileAdded ([filename], [GUID], FileType, Fileremarks)
		SELECT @Filename, @GUID, @Filetype, @Fileremarks;
		
		INSERT INTO dbo.tb_members_attachments([DATE], NRIC, [GUID], [Filename], FileType, Remarks)
		SELECT GETDATE(), @candidate_nric, @GUID, @Filename, @Filetype, @Fileremarks;
	END

	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_salutation <> @candidate_salutation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));		
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
	END

	IF(@Orig_candidate_chinses_name <> @candidate_chinses_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Name', @Orig_candidate_chinses_name, @candidate_chinses_name);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_transfer_reason <> @candidate_transfer_reason)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer Reason', @Orig_candidate_transfer_reason, @candidate_transfer_reason);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
	END

	IF(@Orig_candidate_dialect <> @candidate_dialect)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Dialect', ISNULL((SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @Orig_candidate_dialect), ''), ISNULL((SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @candidate_dialect), ''));
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
	END

	IF(@Orig_baptized_by <> @baptized_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Baptised By', ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @Orig_baptized_by),''), ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @baptized_by),'');
	END

	IF(@Orig_baptism_church <> @baptism_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Baptism Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_baptism_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @baptism_church);
	END

	IF(ISNULL(@Orig_candidate_baptism_date,'') <> ISNULL(@candidate_baptism_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Date', ISNULL(@Orig_candidate_baptism_date,''), ISNULL(@candidate_baptism_date,''));
	END

	IF(@Orig_confirmation_by <> @confirmation_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Confirmation By', ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @Orig_confirmation_by),''), ISNULL((SELECT dbo.udf_getStafforMemberName(NRIC) FROM dbo.tb_Users WHERE NRIC = @confirmation_by),'');
	END

	IF(@Orig_confirmation_church <> @confirmation_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Conformation Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_confirmation_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @confirmation_church);
	END

	IF(ISNULL(@Orig_candidate_confirmation_date,'') <> ISNULL(@candidate_confirmation_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Date', ISNULL(@Orig_candidate_confirmation_date,''), ISNULL(@candidate_confirmation_date,''));
	END

	IF(@Orig_previous_church_membership <> @previous_church_membership)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Previous Church Membership', ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_previous_church_membership),''), ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @previous_church_membership),''));		
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_marital_status <> @candidate_marital_status)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Marital Status', (SELECT MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @Orig_candidate_marital_status), (SELECT MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @candidate_marital_status);
	END

	IF(ISNULL(@Orig_candidate_marriage_date,'') <> ISNULL(@candidate_marriage_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marriage Date', ISNULL(@Orig_candidate_marriage_date,''), ISNULL(@candidate_marriage_date,''));
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_language <> @candidate_language)
	BEGIN
		DECLARE @oldLang VARCHAR(1000) = '';
		DECLARE @newLang VARCHAR(1000) = '';
		
		SELECT @oldLang = @oldLang + A.LanguageName + ', ' FROM dbo.udf_Split(@Orig_candidate_language, ',')
		LEFT OUTER JOIN dbo.tb_language AS A ON A.LanguageID = items;
		
		SELECT @newLang = @newLang + A.LanguageName + ', ' FROM dbo.udf_Split(@candidate_language, ',')
		LEFT OUTER JOIN dbo.tb_language AS A ON A.LanguageID = items;
	
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Language', @oldLang, @newLang);
	END

	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END

	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Congregation', (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @Orig_candidate_congregation), (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @candidate_congregation);
	END

	IF(@Orig_candidate_sponsor1 <> @candidate_sponsor1)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Sponsor 1', ISNULL((SELECT dbo.udf_getStafforMemberName(@Orig_candidate_sponsor1)),''), ISNULL((SELECT dbo.udf_getStafforMemberName(@candidate_sponsor1)),'');
	END

	IF(@Orig_candidate_sponsor2 <> @candidate_sponsor2)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2', @Orig_candidate_sponsor2, @candidate_sponsor2);
	END
	
	IF(@Orig_candidate_sponsor2contact <> @candidate_sponsor2contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2 Contact', @Orig_candidate_sponsor2contact, @candidate_sponsor2contact);
	END

	IF(ISNULL(@Orig_candidate_DeceasedDate,'') <> ISNULL(@candidate_DeceasedDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Deceased Date', ISNULL(@Orig_candidate_DeceasedDate,''), ISNULL(@candidate_DeceasedDate,''));
	END
	
	IF(ISNULL(@Orig_candidate_MemberDate,'') <> ISNULL(@candidate_MemberDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Church Member as of', ISNULL(@Orig_candidate_MemberDate,''), ISNULL(@candidate_MemberDate,''));
	END
	
	IF(ISNULL(@Orig_candidate_electoralroll,'') <> ISNULL(@candidate_electoralroll,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Electoral Roll Date', ISNULL(@Orig_candidate_electoralroll,''), ISNULL(@candidate_electoralroll,''));
	END
	
	IF(@Orig_candidate_remarks <> @candidate_remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_candidate_remarks, @candidate_remarks);
	END
	
	IF(@Orig_candidate_cariu <> @candidate_cariu)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Car IU', @Orig_candidate_cariu, @candidate_cariu);
	END
	
	IF(@Orig_candidate_cellgroup <> @candidate_cellgroup)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Cellgroup', ISNULL((SELECT CellgroupName FROM dbo.tb_cellgroup WHERE CellgroupID = @Orig_candidate_cellgroup),''), ISNULL((SELECT CellgroupName FROM dbo.tb_cellgroup WHERE CellgroupID = @candidate_cellgroup),'');
	END
	
	IF(@Orig_baptism_by_others <> @baptism_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_baptism_by_others, @baptism_by_others);
	END
	IF(@Orig_confirm_by_others <> @confirm_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm By Others', @Orig_confirm_by_others, @confirm_by_others);
	END
	IF(@Orig_baptism_church_others <> @baptism_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church By Others', @Orig_baptism_church_others, @baptism_church_others);
	END
	IF(@Orig_confirm_church_others <> @confirm_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm Church By Others', @Orig_confirm_church_others, @confirm_church_others);
	END
	IF(@Orig_previous_church_others <> @previous_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_previous_church_others, @previous_church_others);
	END
	
	IF(ISNULL(@Orig_transferTo,'') <> ISNULL(@transferTo,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer To', ISNULL(@Orig_transferTo,''), ISNULL(@transferTo,''));
	END
	
	IF(ISNULL(@Orig_transferToDate,'') <> ISNULL(@transferToDate,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer To Date', ISNULL(@Orig_transferToDate,''), ISNULL(@transferToDate,''));
	END
	
	---------------------------
	
	DECLARE @xdoc int;
	DECLARE @familyxml AS XML = (SELECT Family FROM dbo.tb_members WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;

	INSERT INTO @OriginalFamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	SET @familyxml = @family;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;
	
	INSERT INTO @FamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	INSERT INTO @FamilyAdded
	SELECT * FROM @FamilyTable WHERE FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion NOT IN (SELECT FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion FROM @OriginalFamilyTable)
	
	INSERT INTO @FamilyRemoved
	SELECT * FROM @OriginalFamilyTable WHERE FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion NOT IN (SELECT FamilyType+FamilyEnglishName+FamilyChineseName+FamilyOccupation+FamilyReligion FROM @FamilyTable)	
	
	-------------------------
	
	
	DECLARE @chilexml AS XML = (SELECT Child FROM dbo.tb_members WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;

	INSERT INTO @OriginalChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	SET @chilexml = @child;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;
	
	INSERT INTO @ChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	INSERT INTO @ChildAdded
	SELECT * FROM @ChildTable WHERE ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch
	NOT IN (SELECT ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch
	FROM @OriginalChildTable)
	
	INSERT INTO @ChildRemoved
	SELECT * FROM @OriginalChildTable WHERE ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch
	NOT IN (SELECT ChildEnglishName+ChildChineseName+ChildBaptismDate+ChildBaptismBy+ChildChurch
	FROM @ChildTable)	

	--------------
	
	
	DECLARE @ministryxml AS VARCHAR(MAX) = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(SELECT MinistryInvolvement FROM dbo.tb_membersOtherInfo WHERE NRIC = @candidate_original_nric)), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');

	INSERT INTO @OriginalMinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	SET @ministryxml = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@candidate_ministry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');
	
	INSERT INTO @MinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	INSERT INTO @MinistryTableAdded
	SELECT * FROM @MinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @OriginalMinistryTable)
	
	INSERT INTO @MinistryTableRemoved
	SELECT * FROM @OriginalMinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @MinistryTable)	
	
	--------------
	
	
	
	DECLARE @returnTable TABLE (
		FromTo XML,
		FamilyRemoved XML,
		FamilyAdded XML,
		ChildRemoved XML,
		ChileAdded XML,
		MinistryAdded XML,
		MinistryRemoved XML,
		FileAdded XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	OR EXISTS (SELECT 1 FROM @FamilyRemoved)
	OR EXISTS (SELECT 1 FROM @FamilyAdded)
	OR EXISTS (SELECT 1 FROM @ChildAdded)
	OR EXISTS (SELECT 1 FROM @ChildRemoved)
	OR EXISTS (SELECT 1 FROM @MinistryTableAdded)
	OR EXISTS (SELECT 1 FROM @MinistryTableRemoved)
	OR EXISTS (SELECT 1 FROM @FileAdded)
	BEGIN
		INSERT INTO @returnTable (FromTo, FamilyRemoved, FamilyAdded, MinistryRemoved, MinistryAdded, ChildRemoved, ChileAdded, FileAdded)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyRemoved FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyAdded FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableRemoved FOR XML RAW('Ministry'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableAdded FOR XML RAW('Ministry'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildRemoved FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildAdded FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT [filename], [GUID], FileType, Fileremarks FROM @FileAdded FOR XML RAW('AttachmentAdded'), ELEMENTS));
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo, FamilyRemoved, FamilyAdded, ChildRemoved, ChileAdded, MinistryRemoved, MinistryAdded, FileAdded FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		
		
		UPDATE tb_members SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							ICPhoto = @candidate_photo,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Dialect = @candidate_dialect,
							Occupation = @candidate_occupation,
							BaptismBy = @baptized_by,
							BaptismChurch = @baptism_church,
							ConfirmBy = @confirmation_by,
							ConfirmChurch = @confirmation_church,
							PreviousChurch = @previous_church_membership,
							ChineseName = @candidate_chinses_name,
							DOB = @candidate_dob,
							Gender = @candidate_gender,
							MaritalStatus = @candidate_marital_status,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Email = @candidate_email,
							Education = @candidate_education,
							[Language] = @candidate_language,
							HomeTel = @candidate_home_tel,
							MobileTel = @candidate_mobile_tel,
							TransferReason = @candidate_transfer_reason,
							CarIU = @candidate_cariu,
							BaptismDate = CONVERT(DATETIME, @candidate_baptism_date, 103),
							ConfirmDate = CONVERT(DATETIME, @candidate_confirmation_date, 103),
							MarriageDate = CONVERT(DATETIME, @candidate_marriage_date, 103),
							CurrentParish = @CurrentParish,
							DeceasedDate = CONVERT(DATETIME, @candidate_DeceasedDate, 103),
							Family = @family,
							Child = @child,
							BaptismByOthers = @baptism_by_others,
							ConfirmByOthers = @confirm_by_others,
							BaptismChurchOthers = @baptism_church_others,
							ConfirmChurchOthers = @confirm_church_others,
							PreviousChurchOthers = @previous_church_others
		WHERE NRIC = @candidate_original_nric
			
		UPDATE dbo.tb_membersOtherInfo SET Congregation = @candidate_congregation,
									   NRIC = @candidate_nric,
									   ElectoralRoll = CONVERT(DATETIME, @candidate_electoralroll, 103),
									   CellGroup = @candidate_cellgroup,
									   MinistryInvolvement = @candidate_ministry,
									   Sponsor1 = @candidate_sponsor1,
									   Sponsor2 = @candidate_sponsor2,
									   Sponsor2Contact = @candidate_sponsor2contact,
									   Remarks = @candidate_remarks,
									   TransferTo = @transferTo,
									   TransferToDate = CONVERT(DATETIME, @transferToDate, 103),
									   MemberDate = CONVERT(DATETIME, @candidate_MemberDate, 103)
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateRolesUserID]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRolesUserID]
(@UserID VARCHAR(MAX),
 @Role VARCHAR(3))
AS

BEGIN TRY

	SET NOCOUNT ON;

	DECLARE @UserIDTable TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))
	DECLARE @InvalidUser TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))
	DECLARE @UpdatedUser TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))

	INSERT INTO @UserIDTable(UserID)
	SELECT LTRIM(RTRIM(Items)) FROM dbo.udf_Split(@UserID, ',')
	
	
	DELETE FROM @UserIDTable OUTPUT DELETED.UserID INTO @InvalidUser WHERE UserID NOT IN (SELECT UserID FROM dbo.tb_Users)
	DELETE FROM @UserIDTable OUTPUT DELETED.UserID INTO @UpdatedUser WHERE UserID IN (SELECT UserID FROM dbo.tb_Roles_Users)
	
	INSERT INTO dbo.tb_Roles_Users (RoleID, UserID)
	SELECT @Role, UserID FROM @UserIDTable

	UPDATE dbo.tb_Roles_Users SET RoleID = @Role
	WHERE UserID IN (SELECT UserID FROM @UpdatedUser)
	
	DECLARE @IndividualUserID VARCHAR(50)
	DECLARE @X INT = 0
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM @UpdatedUser
	WHILE @X < @COUNT
	BEGIN
		SELECT @IndividualUserID = UserID FROM @UpdatedUser WHERE ID=@X
		--EXEC dbo.usp_updateUserPreferences @IndividualUserID, 'HomePage', '1.1.1';
		SET @X = @X +1
	END
	
	SET @X = 0
	SELECT @COUNT = COUNT(*) FROM @UserIDTable
	WHILE @X < @COUNT
	BEGIN
		SELECT @IndividualUserID = UserID FROM @UserIDTable WHERE ID=@X
		--EXEC dbo.usp_updateUserPreferences @IndividualUserID, 'HomePage', '1.1.1';
		SET @X = @X +1
	END

	SELECT ISNULL((SELECT UserID FROM @UserIDTable
			FOR XML RAW(''), ELEMENTS, Root('AddedUsers')
			), '<AddedUsers />') AS AddedUsers,
		   ISNULL((SELECT UserID FROM @UpdatedUser
			FOR XML RAW(''), ELEMENTS, Root('UpdatedUsers')
			), '<UpdatedUsers />') AS UpdatedUsers,
		   ISNULL((SELECT UserID FROM @InvalidUser
			FOR XML RAW(''), ELEMENTS, Root('InvalidUsers')
			), '<InvalidUsers />') AS InvalidUsers

	SET NOCOUNT OFF;
END TRY	
	
BEGIN CATCH
	
	DECLARE @ErrorMSG XML;
	
	SET @ErrorMSG = (
	SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage FOR XML RAW, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'E', 'SQLERROR', '<SQLERROR />', 'usp_updatedRolesUserID', '<SQLERROR />', 1, 0, @ErrorMSG;
	SET NOCOUNT OFF;
	
END CATCH
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateRoles_bk]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRoles_bk]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (RolesID VARCHAR(10), RolesName VARCHAR(100))
	INSERT INTO @table(RolesID, RolesName)
	Select RolesID, RolesName
	from OpenXml(@xdoc, '/ChurchRole/*')
	with (
	RolesID VARCHAR(10) './RoleID',
	RolesName VARCHAR(100) './RoleName') WHERE RolesID <> 'New';		
	
	UPDATE dbo.tb_roles SET dbo.tb_Roles.RoleName = a.RolesName
	from @table AS a WHERE a.RolesID <> 'New' AND dbo.tb_roles.RoleID = a.RolesID; 
	
	DELETE FROM @table WHERE RolesID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_roles 
				WHERE RoleID IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_AMF_AccessRights)
				AND RoleID NOT IN (Select RolesID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_Roles (RoleName)
		Select RolesName
		from OpenXml(@xdoc, '/ChurchRole/*')
		with (
		RolesID VARCHAR(10) './RoleID',
		RolesName VARCHAR(100) './RoleName') WHERE RolesID = 'New';
	
		SELECT 'Unable to delete, Roles still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Roles 
		WHERE RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_AMF_AccessRights)
		AND RoleID NOT IN (Select RolesID FROM @table)
		
		INSERT INTO dbo.tb_Roles (RoleName)
		Select RolesName
		from OpenXml(@xdoc, '/ChurchRoles/*')
		with (
		RolesID VARCHAR(10) './RolesID',
		RolesName VARCHAR(100) './RolesName') WHERE RolesID = 'New';
		
		SELECT 'Roles updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateRoles]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRoles]
(@AllRoles AS XML)
AS

BEGIN
	
	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @AllRoles;
	DECLARE @oldRoles Table(RoleID INT, RoleName VARCHAR(50))
	DECLARE @newRoles Table(RoleName VARCHAR(50))
	DECLARE @RolesInUse Table(RoleName VARCHAR(50))
	DECLARE @RolesDeleted Table(RoleName VARCHAR(50))
	
	INSERT INTO @oldRoles(RoleID, RoleName)
	SELECT RoleID, RoleName
	FROM OPENXML(@idoc, '/AllRoles/*')
	WITH (
	RoleID VARCHAR(50)'./RoleID',
	RoleName VARCHAR(50)'./RoleName') WHERE RoleID <> 'new';
	
	INSERT INTO @newRoles(RoleName)
	SELECT RoleName
	FROM OPENXML(@idoc, '/AllRoles/*')
	WITH (
	RoleID VARCHAR(50)'./RoleID',
	RoleName VARCHAR(50)'./RoleName') WHERE RoleID = 'new';
	
	INSERT INTO @RolesInUse(RoleName)
	SELECT RoleName FROM dbo.tb_Roles WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	
	DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	DELETE FROM dbo.tb_Roles OUTPUT DELETED.RoleName INTO @RolesDeleted WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)	
	
	INSERT INTO dbo.tb_Roles (RoleName)
	SELECT RoleName FROM @newRoles
	
		SELECT ISNULL((SELECT RoleName FROM @newRoles
			FOR XML RAW(''), ELEMENTS, Root('AddedRoles')
			), '<AddedRoles />') AS AddedUsers,
		   ISNULL((SELECT RoleName FROM @RolesInUse
			FOR XML RAW(''), ELEMENTS, Root('FailedRole')
			), '<FailedRole />') AS FailedRole,
		   ISNULL((SELECT RoleName FROM @RolesDeleted
			FOR XML RAW(''), ELEMENTS, Root('DeletedUsers')
			), '<DeletedUsers />') AS DeletedUsers
	

SET NOCOUNT OFF;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateNewMember]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateNewMember]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_dialect VARCHAR(4),
@candidate_occupation VARCHAR(4),
@baptized_by VARCHAR(50),
@baptism_church VARCHAR(4),
@confirmation_by VARCHAR(50),
@confirmation_church VARCHAR(4),
@previous_church_membership VARCHAR(4),
@candidate_chinses_name NVARCHAR(50),
@candidate_nric VARCHAR(10),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_marital_status VARCHAR(3),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_language VARCHAR(200),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_baptism_date VARCHAR(15),
@candidate_confirmation_date VARCHAR(15),
@candidate_marriage_date VARCHAR(15),
@candidate_congregation VARCHAR(3),
@candidate_sponsor1 VARCHAR(20),
@candidate_sponsor2 VARCHAR(100),
@candidate_sponsor2contact VARCHAR(100),
@family XML,
@child XML,
@TransferReason VARCHAR(1000),
@InterestedCellgroup VARCHAR(1),
@InterestedMinistry XML,
@InterestedServeCongregation VARCHAR(1),
@InterestedTithing VARCHAR(1),
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact = Sponsor2Contact, @candidate_congregation = Congregation,
	@InterestedCellgroup = InterestedCellgroup, @InterestedMinistry = InterestedMinistry, @InterestedServeCongregation = InterestedServeCongregation,
	@InterestedTithing = InterestedTithing, @TransferReason = TransferReason,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	ChineseName NVARCHAR(50) './ChineseName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	MaritalStatus VARCHAR(3) './MaritalStatus',
	MarriageDate VARCHAR(20) './MarriageDate',
	Nationality VARCHAR(3) './Nationality',
	Dialect VARCHAR(3) './Dialect',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	[Language] VARCHAR(200) './Language',
	Occupation VARCHAR(3) './Occupation',
	Congregation VARCHAR(3) './Congregation',
	BaptismBy VARCHAR(20) './BaptismBy',
	BaptismDate VARCHAR(10) './BaptismDate',
	BaptismChurch VARCHAR(3) './BaptismChurch',
	ConfirmationBy VARCHAR(20) './ConfirmationBy',
	ConfirmationChurch VARCHAR(3) './ConfirmationChurch',
	ConfirmationDate VARCHAR(10) './ConfirmationDate',
	PreviousChurchMembership VARCHAR(3) './PreviousChurchMembership',
	FamilyXML XML './FamilyXML/FamilyList',
	ChildXML XML './ChildXML/ChildList',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(100) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	InterestedCellgroup VARCHAR(1) './InterestedCellgroup',
	InterestedMinistry XML './InterestedMinistry/Ministry',
	InterestedServeCongregation VARCHAR(1) './InterestedServeCongregation',
	TransferReason VARCHAR(1000) './TransferReason',
	InterestedTithing VARCHAR(1) './InterestedTithing',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers');

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_dialect) = 0)
BEGIN
	SET @candidate_dialect = '0'
END

IF(LEN(@previous_church_membership) = 0)
BEGIN
	SET @previous_church_membership = '0'
END

IF(LEN(@baptism_church) = 0)
BEGIN
	SET @baptism_church = '0'
END

IF(LEN(@confirmation_church) = 0)
BEGIN
	SET @confirmation_church = '0'
END

IF(LEN(@candidate_baptism_date) = 0)
BEGIN
	SET @candidate_baptism_date = NULL;
END

IF(LEN(@candidate_marriage_date) = 0)
BEGIN
	SET @candidate_marriage_date = NULL;
END

if(LEN(@candidate_confirmation_date) = 0)
BEGIN
	SET @candidate_confirmation_date = NULL;
END

IF EXISTS( SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_photo VARCHAR(1000)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_dialect VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_baptized_by VARCHAR(50)
	DECLARE @Orig_baptism_church VARCHAR(4)
	DECLARE @Orig_confirmation_by VARCHAR(50)
	DECLARE @Orig_confirmation_church VARCHAR(4)
	DECLARE @Orig_previous_church_membership VARCHAR(4)
	DECLARE @Orig_candidate_chinses_name NVARCHAR(50)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_marital_status VARCHAR(3)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_language VARCHAR(200)
	DECLARE @Orig_candidate_home_tel VARCHAR(15)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)
	DECLARE @Orig_candidate_baptism_date VARCHAR(15)
	DECLARE @Orig_candidate_confirmation_date VARCHAR(15)
	DECLARE @Orig_candidate_marriage_date VARCHAR(15)
	DECLARE @Orig_candidate_congregation VARCHAR(3)
	DECLARE @Orig_candidate_electoralroll VARCHAR(15)
	DECLARE @Orig_candidate_cellgroup VARCHAR(3)
	DECLARE @Orig_candidate_sponsor1 VARCHAR(20)
	DECLARE @Orig_candidate_sponsor2 VARCHAR(100)
	DECLARE @Orig_candidate_sponsor2contact VARCHAR(100)
	DECLARE @Orig_candidate_ministry XML
	DECLARE @Orig_candidate_DeceasedDate VARCHAR(15)
	DECLARE @Orig_candidate_TransferReason VARCHAR(1000)
	DECLARE @Orig_family XML
	DECLARE @Orig_child XML
	DECLARE @Orig_InterestedCellgroup VARCHAR(1),
	@Orig_InterestedMinistry XML,
	@Orig_InterestedServeCongregation VARCHAR(1),
	@Orig_InterestedTithing VARCHAR(1)
	
	DECLARE @Orig_baptism_by_others VARCHAR(100),
	@Orig_confirm_by_others VARCHAR(100),
	@Orig_baptism_church_others VARCHAR(100),
	@Orig_confirm_church_others VARCHAR(100),
	@Orig_previous_church_others VARCHAR(100)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	
	DECLARE @FamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @OriginalFamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
								
	DECLARE @FamilyAdded TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @FamilyRemoved TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	
	DECLARE @ChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @OriginalChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildAdded TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildRemoved TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	
	DECLARE @MinistryTable TABLE (MinistryID VARCHAR(100),
								  MinistryName VARCHAR(100))
	DECLARE @OriginalMinistryTable TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
	DECLARE @MinistryTableAdded TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
    DECLARE @MinistryTableRemoved TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))										  
																																

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_dialect = Dialect, @Orig_candidate_occupation = Occupation, @Orig_baptized_by = BaptismBy, @Orig_baptism_church = BaptismChurch,
			@Orig_confirmation_by = ConfirmBy, @Orig_confirmation_church = ConfirmChurch, @Orig_previous_church_membership = PreviousChurch, @Orig_candidate_chinses_name = ChineseName,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_marital_status = MaritalStatus, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education, @Orig_candidate_language = [Language],
			@Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_baptism_date = CONVERT(VARCHAR(15), BaptismDate,103), @Orig_candidate_confirmation_date = CONVERT(VARCHAR(15), ConfirmDate, 103),
			@Orig_candidate_marriage_date = CONVERT(VARCHAR(15),MarriageDate, 103), @Orig_family = Family, @Orig_child = Child, @Orig_candidate_congregation = Congregation, @Orig_candidate_sponsor1 = Sponsor1, @Orig_candidate_sponsor2 = Sponsor2, @Orig_candidate_sponsor2contact = Sponsor2Contact,
			@Orig_candidate_ministry = MinistryInvolvement, @Orig_candidate_DeceasedDate = CONVERT(VARCHAR(15), DeceasedDate, 103), @Orig_candidate_electoralroll = CONVERT(VARCHAR(15), ElectoralRoll, 103),
			@Orig_candidate_cellgroup = CellGroup, @Orig_InterestedCellgroup = B.CellgroupInterested, @Orig_InterestedMinistry = B.MinistryInterested, @Orig_InterestedServeCongregation = B.ServeCongregationInterested, @Orig_InterestedTithing = B.TithingInterested,
			@Orig_candidate_TransferReason = A.TransferReason,
			@Orig_baptism_by_others = BaptismByOthers,
			@Orig_confirm_by_others = ConfirmByOthers,
			@Orig_baptism_church_others = BaptismChurchOthers,
			@Orig_confirm_church_others = ConfirmChurchOthers,
			@Orig_previous_church_others = PreviousChurchOthers
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON B.NRIC = A.NRIC
	WHERE A.NRIC = @candidate_original_nric
	
	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_salutation <> @candidate_salutation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));		
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
	END

	IF(@Orig_candidate_chinses_name <> @candidate_chinses_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Name', @Orig_candidate_chinses_name, @candidate_chinses_name);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_TransferReason <> @TransferReason)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer Reason', @Orig_candidate_TransferReason, @TransferReason);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Nationality', @Orig_candidate_nationality, @candidate_nationality);
	END

	IF(@Orig_candidate_dialect <> @candidate_dialect)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Dialect', (SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @Orig_candidate_dialect), (SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @candidate_dialect));
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Occupation', @Orig_candidate_occupation, @candidate_occupation);
	END

	IF(@Orig_baptized_by <> @baptized_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptised By', @Orig_baptized_by, @baptized_by);
	END

	IF(@Orig_baptism_church <> @baptism_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church', @Orig_baptism_church, @baptism_church);
	END

	IF(ISNULL(@Orig_candidate_baptism_date,'') <> ISNULL(@candidate_baptism_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Date', ISNULL(@Orig_candidate_baptism_date,''), ISNULL(@candidate_baptism_date,''));
	END

	IF(@Orig_confirmation_by <> @confirmation_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation By', @Orig_confirmation_by, @confirmation_by);
	END

	IF(@Orig_confirmation_church <> @confirmation_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Church', @Orig_confirmation_church, @confirmation_church);
	END

	IF(ISNULL(@Orig_candidate_confirmation_date,'') <> ISNULL(@candidate_confirmation_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Date', ISNULL(@Orig_candidate_confirmation_date,''), ISNULL(@candidate_confirmation_date,''));
	END

	IF(@Orig_previous_church_membership <> @previous_church_membership)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Previous Church Membership', ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_previous_church_membership),''), ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @previous_church_membership),''));
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_marital_status <> @candidate_marital_status)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marital Status', @Orig_candidate_marital_status, @candidate_marital_status);
	END

	IF(ISNULL(@Orig_candidate_marriage_date,'') <> ISNULL(@candidate_marriage_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marriage Date', ISNULL(@Orig_candidate_marriage_date,''), ISNULL(@candidate_marriage_date,''));
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_language <> @candidate_language)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Language', @Orig_candidate_language, @candidate_language);
	END

	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END

	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Congregation', @Orig_candidate_congregation, @candidate_congregation);
	END

	IF(@Orig_candidate_sponsor1 <> @candidate_sponsor1)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 1', @Orig_candidate_sponsor1, @candidate_sponsor1);
	END

	IF(@Orig_candidate_sponsor2 <> @candidate_sponsor2)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2', @Orig_candidate_sponsor2, @candidate_sponsor2);
	END
	
	IF(@Orig_candidate_sponsor2contact <> @candidate_sponsor2contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2 Contact', @Orig_candidate_sponsor2contact, @candidate_sponsor2contact);
	END
	
	IF(@Orig_InterestedCellgroup <> @InterestedCellgroup)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Join Cellgroup', REPLACE(REPLACE(@Orig_InterestedCellgroup , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedCellgroup , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_InterestedServeCongregation <> @InterestedServeCongregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Serve Congregation', REPLACE(REPLACE(@Orig_InterestedServeCongregation , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedServeCongregation , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_InterestedTithing <> @InterestedTithing)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Give Tithing', REPLACE(REPLACE(@Orig_InterestedTithing , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedTithing , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_baptism_by_others <> @baptism_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_baptism_by_others, @baptism_by_others);
	END
	IF(@Orig_confirm_by_others <> @confirm_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm By Others', @Orig_confirm_by_others, @confirm_by_others);
	END
	IF(@Orig_baptism_church_others <> @baptism_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church By Others', @Orig_baptism_church_others, @baptism_church_others);
	END
	IF(@Orig_confirm_church_others <> @confirm_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm Church By Others', @Orig_confirm_church_others, @confirm_church_others);
	END
	IF(@Orig_previous_church_others <> @previous_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_previous_church_others, @previous_church_others);
	END
	
	DECLARE @xdoc int;
	DECLARE @familyxml AS XML = (SELECT Family FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;

	INSERT INTO @OriginalFamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	SET @familyxml = @family;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;
	
	INSERT INTO @FamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	INSERT INTO @FamilyAdded
	SELECT * FROM @FamilyTable WHERE FamilyEnglishName NOT IN (SELECT FamilyEnglishName FROM @OriginalFamilyTable)
	
	INSERT INTO @FamilyRemoved
	SELECT * FROM @OriginalFamilyTable WHERE FamilyEnglishName NOT IN (SELECT FamilyEnglishName FROM @FamilyTable)	
	
	-------------------------
	
	
	DECLARE @chilexml AS XML = (SELECT Child FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;

	INSERT INTO @OriginalChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	SET @chilexml = @child;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;
	
	INSERT INTO @ChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	INSERT INTO @ChildAdded
	SELECT * FROM @ChildTable WHERE ChildEnglishName NOT IN (SELECT ChildEnglishName FROM @OriginalChildTable)
	
	INSERT INTO @ChildRemoved
	SELECT * FROM @OriginalChildTable WHERE ChildEnglishName NOT IN (SELECT ChildEnglishName FROM @ChildTable)	
	
	--------------
	
	
	DECLARE @ministryxml AS VARCHAR(MAX) = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@Orig_InterestedMinistry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');

	INSERT INTO @OriginalMinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	SET @ministryxml = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@InterestedMinistry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');
	
	INSERT INTO @MinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	INSERT INTO @MinistryTableAdded
	SELECT * FROM @MinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @OriginalMinistryTable)
	
	INSERT INTO @MinistryTableRemoved
	SELECT * FROM @OriginalMinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @MinistryTable)	
	
	--------------
	
	
	
	DECLARE @returnTable TABLE (
		FromTo XML,
		FamilyRemoved XML,
		FamilyAdded XML,
		ChildRemoved XML,
		ChileAdded XML,
		MinistryInterestedAdded XML,
		MinistryInterestedRemoved XML);
		
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	OR EXISTS (SELECT 1 FROM @FamilyRemoved)
	OR EXISTS (SELECT 1 FROM @FamilyAdded)
	OR EXISTS (SELECT 1 FROM @ChildAdded)
	OR EXISTS (SELECT 1 FROM @ChildRemoved)
	OR EXISTS (SELECT 1 FROM @MinistryTableAdded)
	OR EXISTS (SELECT 1 FROM @MinistryTableRemoved)
	BEGIN
		INSERT INTO @returnTable (FromTo, FamilyRemoved, FamilyAdded, MinistryInterestedRemoved, MinistryInterestedAdded, ChildRemoved, ChileAdded)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyRemoved FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyAdded FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableRemoved FOR XML RAW('MinistryInterested'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableAdded FOR XML RAW('MinistryInterested'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildRemoved FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildAdded FOR XML RAW('Child'), ELEMENTS));
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo, FamilyRemoved, FamilyAdded, ChildRemoved, ChileAdded, MinistryInterestedRemoved, MinistryInterestedAdded FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		
		
		UPDATE tb_members_temp SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							ICPhoto = @candidate_photo,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Dialect = @candidate_dialect,
							Occupation = @candidate_occupation,
							BaptismBy = @baptized_by,
							BaptismChurch = @baptism_church,
							ConfirmBy = @confirmation_by,
							ConfirmChurch = @confirmation_church,
							PreviousChurch = @previous_church_membership,
							ChineseName = @candidate_chinses_name,
							DOB = @candidate_dob,
							Gender = @candidate_gender,
							MaritalStatus = @candidate_marital_status,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Email = @candidate_email,
							Education = @candidate_education,
							[Language] = @candidate_language,
							HomeTel = @candidate_home_tel,
							MobileTel = @candidate_mobile_tel,
							TransferReason = @TransferReason,
							BaptismDate = CONVERT(DATETIME, @candidate_baptism_date, 103),
							ConfirmDate = CONVERT(DATETIME, @candidate_confirmation_date, 103),
							MarriageDate = CONVERT(DATETIME, @candidate_marriage_date, 103),
							CurrentParish = @CurrentParish,
							Family = @family,
							Child = @child,
							BaptismByOthers = @baptism_by_others,
							ConfirmByOthers = @confirm_by_others,
							BaptismChurchOthers = @baptism_church_others,
							ConfirmChurchOthers = @confirm_church_others,
							PreviousChurchOthers = @previous_church_others
		WHERE NRIC = @candidate_original_nric
			
		UPDATE dbo.tb_membersOtherInfo_temp SET Congregation = @candidate_congregation,
									   NRIC = @candidate_nric,
									   CellgroupInterested = @InterestedCellgroup,
									   MinistryInterested = @InterestedMinistry,
									   ServeCongregationInterested = @InterestedServeCongregation,
									   TithingInterested = @InterestedTithing,
									   Sponsor1 = @candidate_sponsor1,
									   Sponsor2 = @candidate_sponsor2,
									   Sponsor2Contact = @candidate_sponsor2contact
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateFileType]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateFileType]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (FileTypeID VARCHAR(10), FileTypeName VARCHAR(200))
	INSERT INTO @table(FileTypeID, FileTypeName)
	Select FileTypeID, FileTypeName
	from OpenXml(@xdoc, '/FileType/*')
	with (
	FileTypeID VARCHAR(10) './FileTypeID',
	FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID <> 'New';		
	
	UPDATE dbo.tb_File_Type SET dbo.tb_File_Type.FileType = a.FileTypeName
	from @table AS a WHERE a.FileTypeID <> 'New' AND dbo.tb_File_Type.FileTypeID = a.FileTypeID; 
	
	DELETE FROM @table WHERE FileTypeID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_File_Type 
				WHERE FileTypeID IN (SELECT DISTINCT FileType FROM dbo.tb_members_attachments)
				AND FileTypeID NOT IN (Select FileTypeID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_File_Type (FileType)
		Select FileTypeName
		from OpenXml(@xdoc, '/FileType/*')
		with (
		FileTypeID VARCHAR(10) './FileTypeID',
		FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID = 'New';
	
		SELECT 'Unable to delete, FileType still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_File_Type 
		WHERE FileTypeID NOT IN (SELECT DISTINCT FileType FROM dbo.tb_members_attachments)
		AND FileTypeID NOT IN (Select FileTypeID FROM @table)
		
		INSERT INTO dbo.tb_File_Type (FileType)
		Select FileTypeName
		from OpenXml(@xdoc, '/FileType/*')
		with (
		FileTypeID VARCHAR(10) './FileTypeID',
		FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID = 'New';
		
		SELECT 'FileType updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCongregation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCongregation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (CongregationID VARCHAR(10), CongregationName VARCHAR(100))
	INSERT INTO @table(CongregationID, CongregationName)
	Select CongregationID, CongregationName
	from OpenXml(@xdoc, '/ChurchCongregation/*')
	with (
	CongregationID VARCHAR(10) './CongregationID',
	CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID <> 'New';		
	
	UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = a.CongregationName
	from @table AS a WHERE a.CongregationID <> 'New' AND dbo.tb_congregation.CongregationID = a.CongregationID; 
	
	---------------------------------------
	--- update Module function ------------
	---------------------------------------	
	UPDATE
		dbo.tb_ModulesFunctions
	SET
		dbo.tb_ModulesFunctions.functionName = 'Congregation:' + Convert(VARCHAR(3),B.CongregationID) + ', ' + B.CongregationName
	FROM dbo.tb_ModulesFunctions AS A
	INNER JOIN dbo.tb_congregation AS B ON B.CongregationID = dbo.udf_getCongregationIDFromModuleFunction(A.functionName)
	where A.Module = 'Congregation'
	---------------------------------------
	---------------------------------------
	---------------------------------------
	
	DELETE FROM @table WHERE CongregationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_congregation 
				WHERE CongregationID IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo)
				AND CongregationID NOT IN (Select CongregationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_congregation 
				WHERE CongregationID IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo_temp)
				AND CongregationID NOT IN (Select CongregationID FROM @table))
	BEGIN
		
		INSERT INTO dbo.tb_congregation (CongregationName)
		Select CongregationName
		from OpenXml(@xdoc, '/ChurchCongregation/*')
		with (
		CongregationID VARCHAR(10) './CongregationID',
		CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID = 'New';
		
		---------------------------------------
		--- insert Module function ------------
		---------------------------------------
		INSERT INTO dbo.tb_ModulesFunctions(Module, functionName)
		SELECT 'Congregation', 'Congregation:' + CONVERT(VARCHAR(3), CongregationID) + ', ' + CongregationName FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT dbo.udf_getCongregationIDFromModuleFunction(functionName) FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation')
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		SELECT 'Unable to delete, congregation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_congregation 
		WHERE CongregationID NOT IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo)
		AND CongregationID NOT IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo_temp)
		AND CongregationID NOT IN (Select CongregationID FROM @table)
		
		---------------------------------------
		--- delete Module function ------------
		---------------------------------------
		DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE functionID IN (
		SELECT functionID
		FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation' AND dbo.udf_getCongregationIDFromModuleFunction(functionName) NOT IN (SELECT CongregationID FROM dbo.tb_congregation)
		AND LEN(dbo.udf_getCongregationIDFromModuleFunction(functionName)) <> 0)

		DELETE
		FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation' AND dbo.udf_getCongregationIDFromModuleFunction(functionName) NOT IN (SELECT CongregationID FROM dbo.tb_congregation)
		AND LEN(dbo.udf_getCongregationIDFromModuleFunction(functionName)) <> 0
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		
		INSERT INTO dbo.tb_congregation (CongregationName)
		Select CongregationName
		from OpenXml(@xdoc, '/ChurchCongregation/*')
		with (
		CongregationID VARCHAR(10) './CongregationID',
		CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID = 'New';
		
		---------------------------------------
		--- insert Module function ------------
		---------------------------------------
		INSERT INTO dbo.tb_ModulesFunctions(Module, functionName)
		SELECT 'Congregation', 'Congregation:' + CONVERT(VARCHAR(3), CongregationID) + ', ' + CongregationName FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT dbo.udf_getCongregationIDFromModuleFunction(functionName) FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation')
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		SELECT 'Congregation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCityKidsAttendance]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCityKidsAttendance]
(
	@NRIC VARCHAR(10),
	@CourseID INT
)
AS
SET NOCOUNT ON;

/* Convert input NRIC to upper case */
SET @NRIC = UPPER(@NRIC);

DECLARE @iAwardPoint INT = 0;
DECLARE @dtTodayDate date = CONVERT(date, GETDATE());

--IF NOT EXISTS(SELECT 1 FROM dbo.tb_course WHERE dbo.tb_course.courseID = @CourseID)
--BEGIN
--	/* return COURSE ID NOT FOUND if cannot locate the course id in [tb_course] */
--	SELECT	@NRIC AS NRIC, 'COURSE ID NOT FOUND' AS EnglishName, @iAwardPoint AS Point
--	RETURN;
--END
--ELSE 
IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_schedule WHERE dbo.tb_course_schedule.Date = @dtTodayDate AND CourseID = @CourseID)
BEGIN
	/* return NO SCHEDULED COURSE if cannot find today's date in [tb_course_schedule] */
	SELECT	@NRIC AS NRIC, 'COURSE SCHEDULE DATE NOT FOUND' AS EnglishName, @iAwardPoint AS Point, 0 AS Awarded
	RETURN;
END
ELSE IF EXISTS(SELECT 1 FROM dbo.tb_ccc_kids WHERE dbo.tb_ccc_kids.NRIC = @NRIC) /* first, find record in [tb_ccc_kids] */
BEGIN
	/* Search course attendance table look for double entry checking */
	IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_Attendance WHERE dbo.tb_course_Attendance.NRIC = @NRIC AND dbo.tb_course_Attendance.Date = CONVERT(date, GETDATE()))
	BEGIN
		/* Insert today's visit record in dbo.tb_course_Attendance table */
		INSERT INTO dbo.tb_course_Attendance ( dbo.tb_course_Attendance.NRIC, dbo.tb_course_Attendance.CourseID, dbo.tb_course_Attendance.Date) 
		VALUES ( @NRIC, @CourseID, @dtTodayDate)
		
		/* Check attendance history */
		SET @iAwardPoint = dbo.udf_getAttendencePoint(@NRIC, @CourseID);
		PRINT @iAwardPoint
		
		INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
		SELECT 'I', 'BarcodeSystem',  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Added</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),@iAwardPoint) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>Attendance Point</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', @NRIC
		 
		/* Update point in dbo.tb_ccc_kids */
		UPDATE dbo.tb_ccc_kids SET dbo.tb_ccc_kids.Points = dbo.tb_ccc_kids.Points + @iAwardPoint WHERE dbo.tb_ccc_kids.NRIC = @NRIC						
	END
	/* reselect record data after update point*/
	SET @iAwardPoint = dbo.udf_getAttendencePoint(@NRIC, @CourseID);
	SELECT @NRIC AS NRIC, dbo.tb_ccc_kids.Name AS EnglishName, dbo.tb_ccc_kids.Points AS Point, @iAwardPoint AS Awarded FROM dbo.tb_ccc_kids WHERE dbo.tb_ccc_kids.NRIC = @NRIC
END
ELSE
BEGIN
	/* Record not found in [tb_ccc_kids] */
	SELECT	@NRIC AS NRIC, 'RECORD NOT FOUND' AS EnglishName, @iAwardPoint AS Point, 0 AS Awarded
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_updateCityKid]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_updateCityKid]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_photo VARCHAR(1000),
@candidate_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_race VARCHAR(4),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_school VARCHAR(4),
@candidate_religion VARCHAR(4),
@candidate_NOK_contact VARCHAR(15),
@candidate_NOK_name VARCHAR(50),
@candidate_special_needs VARCHAR(1000),
@candidate_transport VARCHAR(1),
@candidate_club_group VARCHAR(4),
@candidate_bus_group VARCHAR(4),
@candidate_remarks VARCHAR(1000)

DECLARE @Orig_candidate_photo VARCHAR(1000),
@Orig_candidate_name VARCHAR(50),
@Orig_candidate_unit VARCHAR(10),
@Orig_candidate_blk_house VARCHAR(10),
@Orig_candidate_nationality VARCHAR(4),
@Orig_candidate_nric VARCHAR(20),
@Orig_candidate_dob DATETIME,
@Orig_candidate_gender VARCHAR(1),
@Orig_candidate_race VARCHAR(4),
@Orig_candidate_street_address VARCHAR(1000),
@Orig_candidate_postal_code INT,
@Orig_candidate_email VARCHAR(100),
@Orig_candidate_home_tel VARCHAR(15),
@Orig_candidate_mobile_tel VARCHAR(15),
@Orig_candidate_school VARCHAR(4),
@Orig_candidate_religion VARCHAR(4),
@Orig_candidate_NOK_contact VARCHAR(15),
@Orig_candidate_NOK_name VARCHAR(50),
@Orig_candidate_special_needs VARCHAR(1000),
@Orig_candidate_transport VARCHAR(1),
@Orig_candidate_club_group VARCHAR(4),
@Orig_candidate_bus_group VARCHAR(4),
@Orig_candidate_remarks VARCHAR(1000)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_photo = Photo , @candidate_name = Name, 
		   @candidate_unit = AddressUnit, @candidate_blk_house = AddressBlkHouse, @candidate_nationality = Nationality, @candidate_nric = NRIC,
		   @candidate_dob = CONVERT(DATETIME, DOB, 103), @candidate_gender = Gender, @candidate_race = Race, @candidate_street_address = AddressStreetName,
		   @candidate_postal_code = AddressPostalCode, @candidate_email = Email, @candidate_home_tel = HomeTel, 
		   @candidate_mobile_tel = MobileTel, @candidate_school = School, @candidate_religion = Religion, @candidate_NOK_contact = NOKContact,
		   @candidate_NOK_name = NOKName, @candidate_special_needs = SpecialNeeds, @candidate_transport = Transport, 
		   @candidate_club_group = Clubgroup, @candidate_bus_group = Busgroup, @candidate_remarks = Remarks
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNric',
	NRIC VARCHAR(20)'./NRIC',
	Name VARCHAR(50) './Name',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	Nationality VARCHAR(4) './Nationality',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Race VARCHAR(4) './Race',
	School VARCHAR(4) './School',
	Religion VARCHAR(4) './Religion',
	NOKContact VARCHAR(15) './NOKContact',
	NOKName VARCHAR(50) './NOKName',
	SpecialNeeds VARCHAR(1000) './SpecialNeeds',
	Transport VARCHAR(1) './Transport',
	Clubgroup VARCHAR(4) './Clubgroup',
	Busgroup VARCHAR(4) './Busgroup',
	Remarks VARCHAR(1000) './Remarks');

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_club_group) = 0)
BEGIN
	SET @candidate_club_group = '0'
END

IF(LEN(@candidate_religion) = 0)
BEGIN
	SET @candidate_religion = '0'
END

IF(LEN(@candidate_bus_group) = 0)
BEGIN
	SET @candidate_bus_group = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_ccc_kids WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));

	SELECT  @Orig_candidate_photo = Photo, @Orig_candidate_name = Name, @Orig_candidate_unit = AddressUnit, 
	        @Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_nric = NRIC, @Orig_candidate_dob = DOB,
			@Orig_candidate_gender = Gender, @Orig_candidate_race = Race, @Orig_candidate_street_address = AddressStreet, @Orig_candidate_postal_code = AddressPostalCode,
            @Orig_candidate_email = Email, @Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_school = School,
            @Orig_candidate_religion = Religion, @Orig_candidate_NOK_contact = EmergencyContact, @Orig_candidate_NOK_name = EmergencyContactName,
            @Orig_candidate_special_needs = SpecialNeeds,  @Orig_candidate_transport = Transport, @Orig_candidate_club_group = ClubGroup,
			@Orig_candidate_bus_group = BusGroupCluster, @Orig_candidate_remarks = Remarks 	FROM dbo.tb_ccc_kids 
	WHERE NRIC = @candidate_original_nric


	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
	END
	
	IF(@Orig_candidate_name <> @candidate_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Name', @Orig_candidate_name, @candidate_name);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END
	
	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality)
		
	END
	
	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date of Birth', Convert(VARCHAR(10), @Orig_candidate_dob, 103), Convert(VARCHAR(10), @candidate_dob, 103));
	END
	
	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END
	
	IF(@Orig_candidate_race <> @candidate_race)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Race', (SELECT RaceName FROM dbo.tb_race WHERE RaceID = @Orig_candidate_race), (SELECT RaceName FROM dbo.tb_race WHERE RaceID = @candidate_race);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END
	
	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END
	
	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END
	
	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END
	
	IF(@Orig_candidate_school <> @candidate_school)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'School', (SELECT SchoolName FROM dbo.tb_school WHERE SchoolID = @Orig_candidate_school), (SELECT SchoolName FROM dbo.tb_school WHERE SchoolID = @candidate_school);
	END
	
	IF(@Orig_candidate_religion <> @candidate_religion)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Religion', ISNULL((SELECT ReligionName FROM dbo.tb_religion WHERE ReligionID = @Orig_candidate_religion),''), ISNULL((SELECT ReligionName FROM dbo.tb_religion WHERE ReligionID = @candidate_religion),'');
	END
	
	IF(@Orig_candidate_NOK_contact <> @candidate_NOK_contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next Of Kin Contact', @Orig_candidate_NOK_contact, @candidate_NOK_contact);
	END
	
	IF(@Orig_candidate_NOK_name <> @candidate_NOK_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next Of Kin Name', @Orig_candidate_NOK_name, @candidate_NOK_name);
	END
	
	IF(@Orig_candidate_special_needs <> @candidate_special_needs)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Special Needs', @Orig_candidate_special_needs, @candidate_special_needs);
	END
	
	IF(@Orig_candidate_transport <> @candidate_transport)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transport', REPLACE(REPLACE(@Orig_candidate_transport,'0', 'False'),'1', 'True'), REPLACE(REPLACE(@candidate_transport,'0', 'False'),'1', 'True'));
	END
	
	IF(@Orig_candidate_club_group <> @candidate_club_group)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Club Group', (SELECT ClubGroupName FROM dbo.tb_clubgroup WHERE ClubGroupID = @Orig_candidate_club_group), (SELECT ClubGroupName FROM dbo.tb_clubgroup WHERE ClubGroupID = @candidate_club_group); 
	END
	
	IF(@Orig_candidate_bus_group <> @candidate_bus_group)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Bus Group / Cluster', (SELECT BusGroupClusterName FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID = @Orig_candidate_bus_group), (SELECT BusGroupClusterName FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID = @candidate_bus_group);
	END
	
	IF(@Orig_candidate_remarks <> @candidate_remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_candidate_remarks, @candidate_remarks);
	END
	
	
	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		UPDATE dbo.tb_ccc_kids SET
			NRIC = @candidate_nric, Name = @candidate_name, Gender = @candidate_gender, DOB = @candidate_dob, HomeTel = @candidate_home_tel,
			MobileTel = @candidate_mobile_tel, AddressStreet = @candidate_street_address, AddressHouseBlk = @candidate_blk_house,
			AddressPostalCode = @candidate_postal_code, AddressUnit = @candidate_unit, Email = @candidate_email,
			SpecialNeeds = @candidate_special_needs, EmergencyContact = @candidate_NOK_contact, EmergencyContactName = @candidate_NOK_name,
			Transport = @candidate_transport, Religion = @candidate_religion, Race = @candidate_race, Nationality = @candidate_nationality,
			School = @candidate_school, ClubGroup = @candidate_club_group, BusGroupCluster = @candidate_bus_group, Remarks = @candidate_remarks,
			Photo = @candidate_photo
		WHERE NRIC = @candidate_original_nric		
		
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'CityKidMembership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourseParticipantInformation]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourseParticipantInformation]
(@courseid INT,
 @nric VARCHAR(20),
 @feepaid VARCHAR(1),
 @materialreceived VARCHAR(1))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_course_participant SET feePaid = @feepaid, materialReceived = @materialreceived
WHERE courseID = @courseid AND NRIC = @nric

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourseAttendance]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourseAttendance]
(@courseid INT,
 @nric VARCHAR(20),
 @DATE DATE)
AS
SET NOCOUNT ON;

DECLARE @AttendanceTable TABLE ([Date] DATE)
DECLARE @name VARCHAR(50);
DECLARE @coursename VARCHAR(100);

INSERT INTO @AttendanceTable ([Date])
SELECT CONVERT(DATE, ITEMS, 103) FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');

IF EXISTS(SELECT 1 FROM @AttendanceTable WHERE [Date] in (SELECT @DATE))
BEGIN
	IF EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE courseID = @courseid AND NRIC = @nric)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.tb_course_Attendance WHERE courseID = @courseid AND NRIC = @nric AND [Date] = @DATE)
		BEGIN
			 INSERT INTO dbo.tb_course_Attendance(CourseID, NRIC, [Date])
			 SELECT @courseid, @nric, @DATE;
			
			  SELECT @name = ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName), @coursename = E.CourseName FROM dbo.tb_course_participant AS A
			  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
			  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
			  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
			  INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
			  WHERE A.courseID = @courseid AND A.NRIC = @nric
			
			  SELECT 'Welcome ' + @name + ', thank you for attending, ' + @coursename AS Result;
		END
		ELSE
		BEGIN
			  SELECT @name = ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName), @coursename = E.CourseName FROM dbo.tb_course_participant AS A
			  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
			  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
			  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
			  INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
			  WHERE A.courseID = @courseid AND A.NRIC = @nric
			
			  SELECT 'Welcome ' + @name + ', your attendance registered, ' + @coursename AS Result;
		END
	END
	ELSE
	BEGIN
		SELECT 'Sorry you are not registered.' AS Result;
	END
END
ELSE
BEGIN
	SELECT @coursename = CourseName FROM dbo.tb_course WHERE courseID = @courseid
	SELECT 'Sorry, there no class for, ' + @coursename AS Result;
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateAssignedModulesFunctions]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateAssignedModulesFunctions]
(@XML AS XML, @RoleID AS INT)
 
AS
SET NOCOUNT ON;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
	
	DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID
	
	INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
	SELECT @RoleID, ModuleID
	FROM OPENXML(@idoc, '/All/AllModules/*')
	WITH (
	ModuleID VARCHAR(50)'./ModuleID');
	
	DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID
	
	INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight
	SELECT @RoleID, FunctionID
	FROM OPENXML(@idoc, '/All/AllFunctions/*')
	WITH (
	FunctionID VARCHAR(50)'./FunctionID');
	
	SELECT RoleName + ' updated.' AS Result FROM dbo.tb_Roles where RoleID = @RoleID

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_searchTempMembers]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_searchTempMembers]
(@NRIC VARCHAR(10),
 @DOB DATE)
AS
SET NOCOUNT ON;

SELECT B.Congregation, A.MarriageDate, A.Salutation, A.ICPhoto, A.EnglishName, A.ChineseName, A.NRIC
		,A.DOB, A.Gender, A.MaritalStatus, A.AddressStreet, A.AddressHouseBlk, A.AddressUnit, A.AddressPostalCode
		,A.Nationality, A.Dialect, A.Email, A.Education, A.[Language], A.Occupation, A.HomeTel, A.MobileTel
		,A.BaptismDate, A.BaptismBy, A.BaptismChurch, A.ConfirmBy, A.ConfirmChurch, A.ConfirmDate
		,A.PreviousChurch, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Text
		,dbo.udf_getStafforMemberName(B.Sponsor2) AS Sponsor2Text
		,B.MinistryInterested, B.CellgroupInterested
		,B.ServeCongregationInterested, B.TithingInterested, A.Family, A.Child, A.TransferReason,
		A.BaptismByOthers, A.BaptismChurchOthers, A.ConfirmByOthers, A.ConfirmChurchOthers, A.PreviousChurchOthers
FROM dbo.tb_members_temp AS A
INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC
WHERE A.NRIC = @NRIC AND A.DOB = @DOB


SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_searchMembersForUpdate]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_searchMembersForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
DECLARE @congregationTable Table (congregationID TINYINT)

INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))

SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	INNER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	INNER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE (A.NRIC LIKE '%'+@NRIC+'%' OR EnglishName LIKE '%'+@Name+'%')
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	INNER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	INNER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	INNER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	INNER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE EnglishName LIKE '%'+@Name+'%'
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeMember]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeMember]
(@NRIC VARCHAR(20), @Type VARCHAR(10))
AS
SET NOCOUNT ON;

IF(@Type = 'Actual')
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_members_attachments WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_membersOtherInfo WHERE NRIC = @NRIC;
	DELETE FROM tb_members WHERE NRIC = @NRIC;
END
ELSE IF(@Type = 'Temp')
BEGIN
    DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_members_attachments WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @NRIC;
	DELETE FROM tb_members_temp WHERE NRIC = @NRIC;
END

ELSE IF(@Type = 'Visitor')
BEGIN
    DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_visitors WHERE NRIC = @NRIC;
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeCourseParticipant]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeCourseParticipant]
(@CourseID INT,
@nric VARCHAR(20))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE courseID = @CourseID AND NRIC = @nric)
BEGIN
	DELETE FROM dbo.tb_course_participant WHERE courseID = @CourseID AND NRIC = @nric
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_removeAttachment]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_removeAttachment]
(@AttachmentID INT, @userID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @GUID VARCHAR(50);
DECLARE @Filename VARCHAR(200);
DECLARE @NRIC VARCHAR(20);

SELECT @NRIC = NRIC, @GUID = [GUID], @Filename = [Filename] FROM dbo.tb_members_attachments WHERE AttachmentID = @AttachmentID

DELETE FROM dbo.tb_members_attachments WHERE AttachmentID = @AttachmentID

DECLARE @XML AS XML = '<Changes>
  <AttachmentRemoved>
      <filename>' + @Filename + '</filename>
      <GUID>' + @GUID + '</GUID>      
    </AttachmentRemoved>
</Changes>'

EXEC dbo.usp_insertlogging 'I', @userID, 'Membership', 'Update', 1, 'NRIC', @NRIC, @XML;

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_ManualUpdateAttendance]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ManualUpdateAttendance]
(@courseid INT,
 @nric VARCHAR(20),
 @date DATETIME,
 @attendance VARCHAR(10))
AS
SET NOCOUNT ON;

IF(@attendance = 'yes')
BEGIN
	EXEC dbo.usp_UpdateCourseAttendance @courseid, @nric, @date;
	SELECT 'Attendance added.' AS Result;
END
ELSE IF(@attendance = 'no')
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @nric AND CourseID = @courseid AND [Date] = @date
	SELECT 'Attendance removed.' AS Result;
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseMemberParticipantAndAttendance]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipantAndAttendance]
(@NRIC VARCHAR(100),
 @courseid int)
AS
SET NOCOUNT ON;
DECLARE @today DATE = GETDATE();

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE
BEGIN
		SELECT 'SORRY Your are not yet registered.' AS Result
END

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseVisitorParticipantAndAttendance]    Script Date: 08/24/2012 23:40:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipantAndAttendance]
(@nric VARCHAR(10),
@course VARCHAR(10),
@salutation VARCHAR(10),
@english_name VARCHAR(50),
@dob DATE,
@gender VARCHAR(1),
@education VARCHAR(10),
@nationality VARCHAR(10),
@occupation VARCHAR(10),
@postal_code VARCHAR(6),
@blk_house  VARCHAR(10),
@street_address  VARCHAR(1000),
@unit  VARCHAR(10),
@contact  VARCHAR(15),
@email  VARCHAR(100),
@church INT,
@church_others VARCHAR(100), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @today DATE = GETDATE();

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
BEGIN
	EXEC dbo.usp_UpdateCourseAttendance @course, @NRIC, @today;
END
ELSE
BEGIN
	if(len(@postal_code) = 0)
	BEGIN
		SET @postal_code = null;
	END
	if(@dob = CONVERT(DATE, '',103))
	BEGIN
		SET @dob = NULL;
	END

	INSERT INTO dbo.tb_visitors(Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID)
	SELECT @nric, @course;
	
	EXEC dbo.usp_UpdateCourseAttendance @course, @NRIC, @today;
	
	DECLARE @newVisitorXML XML = (
	SELECT  C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
END

SET NOCOUNT OFF;
GO
/****** Object:  Default [DF_tb_ccc_kids_Email]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Email]  DEFAULT ('') FOR [Email]
GO
/****** Object:  Default [DF_tb_ccc_kids_SpecialNeeds]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_SpecialNeeds]  DEFAULT ('') FOR [SpecialNeeds]
GO
/****** Object:  Default [DF_tb_ccc_kids_Transport]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Transport]  DEFAULT ((0)) FOR [Transport]
GO
/****** Object:  Default [DF_tb_ccc_kids_Religion]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Religion]  DEFAULT ((0)) FOR [Religion]
GO
/****** Object:  Default [DF_tb_ccc_kids_ClubGroup]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_ClubGroup]  DEFAULT ((0)) FOR [ClubGroup]
GO
/****** Object:  Default [DF_tb_ccc_kids_BusGroupCluster]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_BusGroupCluster]  DEFAULT ((0)) FOR [BusGroupCluster]
GO
/****** Object:  Default [DF_tb_ccc_kids_Remarks]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Remarks]  DEFAULT ('') FOR [Remarks]
GO
/****** Object:  Default [DF_tb_ccc_kids_Points]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Points]  DEFAULT ((0)) FOR [Points]
GO
/****** Object:  Default [DF_tb_ccc_kids_Photo]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Photo]  DEFAULT ('') FOR [Photo]
GO
/****** Object:  Default [DF_tb_cellgroup_Unit]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_cellgroup] ADD  CONSTRAINT [DF_tb_cellgroup_Unit]  DEFAULT ('') FOR [Unit]
GO
/****** Object:  Default [DF_tb_cellgroup_Deleted]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_cellgroup] ADD  CONSTRAINT [DF_tb_cellgroup_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_tb_course_Deleted]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course] ADD  CONSTRAINT [DF_tb_course_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_tb_course_Fee]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course] ADD  CONSTRAINT [DF_tb_course_Fee]  DEFAULT ((0.00)) FOR [Fee]
GO
/****** Object:  Default [DF_tb_course_participant_feePaid]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course_participant] ADD  CONSTRAINT [DF_tb_course_participant_feePaid]  DEFAULT ((0)) FOR [feePaid]
GO
/****** Object:  Default [DF_tb_course_participant_materialReceived]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course_participant] ADD  CONSTRAINT [DF_tb_course_participant_materialReceived]  DEFAULT ((0)) FOR [materialReceived]
GO
/****** Object:  Default [DF_tb_course_participant_RegistrationDate]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course_participant] ADD  CONSTRAINT [DF_tb_course_participant_RegistrationDate]  DEFAULT (getdate()) FOR [RegistrationDate]
GO
/****** Object:  Default [DF_tb_members_ChineseName]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_ChineseName]  DEFAULT ('') FOR [ChineseName]
GO
/****** Object:  Default [DF_tb_members_Dialect]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_Dialect]  DEFAULT ((0)) FOR [Dialect]
GO
/****** Object:  Default [DF_tb_members_AddressUnit]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_AddressUnit]  DEFAULT ('') FOR [AddressUnit]
GO
/****** Object:  Default [DF_tb_members_Email]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_Email]  DEFAULT ('') FOR [Email]
GO
/****** Object:  Default [DF_tb_members_HomeTel]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_HomeTel]  DEFAULT ('') FOR [HomeTel]
GO
/****** Object:  Default [DF_tb_members_MobileTel]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_MobileTel]  DEFAULT ('') FOR [MobileTel]
GO
/****** Object:  Default [DF_tb_members_BaptismDate]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_BaptismDate]  DEFAULT ('') FOR [BaptismDate]
GO
/****** Object:  Default [DF_tb_members_BaptismBy]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_BaptismBy]  DEFAULT ('') FOR [BaptismBy]
GO
/****** Object:  Default [DF_tb_members_BaptismByOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_BaptismByOthers]  DEFAULT ('') FOR [BaptismByOthers]
GO
/****** Object:  Default [DF_tb_members_BaptismChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_BaptismChurch]  DEFAULT ((0)) FOR [BaptismChurch]
GO
/****** Object:  Default [DF_tb_members_BaptismChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_BaptismChurchOthers]  DEFAULT ('') FOR [BaptismChurchOthers]
GO
/****** Object:  Default [DF_tb_members_ConfirmBy]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_ConfirmBy]  DEFAULT ('') FOR [ConfirmBy]
GO
/****** Object:  Default [DF_tb_members_ConfirmByOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_ConfirmByOthers]  DEFAULT ('') FOR [ConfirmByOthers]
GO
/****** Object:  Default [DF_tb_members_ConfirmChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_ConfirmChurch]  DEFAULT ((0)) FOR [ConfirmChurch]
GO
/****** Object:  Default [DF_tb_members_ConfirmChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_ConfirmChurchOthers]  DEFAULT ('') FOR [ConfirmChurchOthers]
GO
/****** Object:  Default [DF_tb_members_TransferReason]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_TransferReason]  DEFAULT ('') FOR [TransferReason]
GO
/****** Object:  Default [DF_tb_members_Family]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_Family]  DEFAULT ('<FamilyList></FamilyList>') FOR [Family]
GO
/****** Object:  Default [DF_tb_members_Child]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_Child]  DEFAULT ('<ChildList></ChildList>') FOR [Child]
GO
/****** Object:  Default [DF_tb_members_CurrentParish]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_CurrentParish]  DEFAULT ((0)) FOR [CurrentParish]
GO
/****** Object:  Default [DF_tb_members_PreviousChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_PreviousChurch]  DEFAULT ((0)) FOR [PreviousChurch]
GO
/****** Object:  Default [DF_tb_members_PreviousChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_PreviousChurchOthers]  DEFAULT ('') FOR [PreviousChurchOthers]
GO
/****** Object:  Default [DF_tb_members_CreatedDate]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
/****** Object:  Default [DF_tb_members_CarIU]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members] ADD  CONSTRAINT [DF_tb_members_CarIU]  DEFAULT ('') FOR [CarIU]
GO
/****** Object:  Default [DF_tb_members_attachments_Remarks]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_attachments] ADD  CONSTRAINT [DF_tb_members_attachments_Remarks]  DEFAULT ('') FOR [Remarks]
GO
/****** Object:  Default [DF_tb_members_temp_Dialect]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_Dialect]  DEFAULT ((0)) FOR [Dialect]
GO
/****** Object:  Default [DF_tb_members_temp_BaptismByOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_BaptismByOthers]  DEFAULT ('') FOR [BaptismByOthers]
GO
/****** Object:  Default [DF_tb_members_temp_BaptismChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_BaptismChurch]  DEFAULT ((0)) FOR [BaptismChurch]
GO
/****** Object:  Default [DF_tb_members_temp_BaptismChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_BaptismChurchOthers]  DEFAULT ('') FOR [BaptismChurchOthers]
GO
/****** Object:  Default [DF_tb_members_temp_ConfirmByOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_ConfirmByOthers]  DEFAULT ('') FOR [ConfirmByOthers]
GO
/****** Object:  Default [DF_tb_members_temp_ConfirmChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_ConfirmChurch]  DEFAULT ((0)) FOR [ConfirmChurch]
GO
/****** Object:  Default [DF_tb_members_temp_ConfirmChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_ConfirmChurchOthers]  DEFAULT ('') FOR [ConfirmChurchOthers]
GO
/****** Object:  Default [DF_tb_members_temp_TransferReason]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_TransferReason]  DEFAULT ('') FOR [TransferReason]
GO
/****** Object:  Default [DF_tb_members_temp_PreviousChurch]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_PreviousChurch]  DEFAULT ((0)) FOR [PreviousChurch]
GO
/****** Object:  Default [DF_tb_members_temp_PreviousChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_PreviousChurchOthers]  DEFAULT ('') FOR [PreviousChurchOthers]
GO
/****** Object:  Default [DF_tb_members_temp_CreatedDate]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
/****** Object:  Default [DF_tb_members_temp_CarIU]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_temp] ADD  CONSTRAINT [DF_tb_members_temp_CarIU]  DEFAULT ('') FOR [CarIU]
GO
/****** Object:  Default [DF_tb_memberOtherInfo_CellGroup]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_memberOtherInfo_CellGroup]  DEFAULT ((0)) FOR [CellGroup]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_MinistryInvolvement]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_MinistryInvolvement]  DEFAULT ('<Ministry></Ministry>') FOR [MinistryInvolvement]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_MinistryInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_MinistryInterested]  DEFAULT ('<Ministry></Ministry>') FOR [MinistryInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_TithingInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_TithingInterested]  DEFAULT ((0)) FOR [TithingInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_CellgroupInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_CellgroupInterested]  DEFAULT ((0)) FOR [CellgroupInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_ServeCongregationInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_ServeCongregationInterested]  DEFAULT ((0)) FOR [ServeCongregationInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_Sponsor2Contact]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_Sponsor2Contact]  DEFAULT ('') FOR [Sponsor2Contact]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_Remarks]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_Remarks]  DEFAULT ('') FOR [Remarks]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_TransferTo]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD  CONSTRAINT [DF_tb_membersOtherInfo_TransferTo]  DEFAULT ('') FOR [TransferTo]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_CellGroup]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_CellGroup]  DEFAULT ((0)) FOR [CellGroup]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_MinistryInvolvement]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInvolvement]  DEFAULT ('<Ministry></Ministry>') FOR [MinistryInvolvement]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_MinistryInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInterested]  DEFAULT ('<Ministry></Ministry>') FOR [MinistryInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_TithingInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_TithingInterested]  DEFAULT ((0)) FOR [TithingInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_CellgroupInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_CellgroupInterested]  DEFAULT ((0)) FOR [CellgroupInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_ServeCongregationInterested]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_ServeCongregationInterested]  DEFAULT ((0)) FOR [ServeCongregationInterested]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_Sponsor2Contact]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_Sponsor2Contact]  DEFAULT ('') FOR [Sponsor2Contact]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_Remarks]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_Remarks]  DEFAULT ('') FOR [Remarks]
GO
/****** Object:  Default [DF_tb_membersOtherInfo_temp_TransferTo]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD  CONSTRAINT [DF_tb_membersOtherInfo_temp_TransferTo]  DEFAULT ('') FOR [TransferTo]
GO
/****** Object:  Default [DF_tb_ministry_Deleted]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_ministry] ADD  CONSTRAINT [DF_tb_ministry_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
/****** Object:  Default [DF_tb_postalArea_PostalDigit]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_postalArea] ADD  CONSTRAINT [DF_tb_postalArea_PostalDigit]  DEFAULT ('') FOR [PostalDigit]
GO
/****** Object:  Default [DF_tb_Users_Password]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Users] ADD  CONSTRAINT [DF_tb_Users_Password]  DEFAULT ('') FOR [Password]
GO
/****** Object:  Default [DF_tb_Users_Appointment]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Users] ADD  CONSTRAINT [DF_tb_Users_Appointment]  DEFAULT ((0)) FOR [Style]
GO
/****** Object:  Default [DF_tb_visitors_Email]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_visitors] ADD  CONSTRAINT [DF_tb_visitors_Email]  DEFAULT ('') FOR [Email]
GO
/****** Object:  Default [DF_tb_visitors_Contact]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_visitors] ADD  CONSTRAINT [DF_tb_visitors_Contact]  DEFAULT ('') FOR [Contact]
GO
/****** Object:  Default [DF_tb_visitors_Church]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_visitors] ADD  CONSTRAINT [DF_tb_visitors_Church]  DEFAULT ((0)) FOR [Church]
GO
/****** Object:  Default [DF_tb_visitors_ChurchOthers]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_visitors] ADD  CONSTRAINT [DF_tb_visitors_ChurchOthers]  DEFAULT ('') FOR [ChurchOthers]
GO
/****** Object:  ForeignKey [FK_tb_course_participant_tb_course]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_course_participant]  WITH CHECK ADD  CONSTRAINT [FK_tb_course_participant_tb_course] FOREIGN KEY([courseID])
REFERENCES [dbo].[tb_course] ([courseID])
GO
ALTER TABLE [dbo].[tb_course_participant] CHECK CONSTRAINT [FK_tb_course_participant_tb_course]
GO
/****** Object:  ForeignKey [FK_tb_members_attachments_tb_file_type]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_members_attachments]  WITH CHECK ADD  CONSTRAINT [FK_tb_members_attachments_tb_file_type] FOREIGN KEY([FileType])
REFERENCES [dbo].[tb_file_type] ([FileTypeID])
GO
ALTER TABLE [dbo].[tb_members_attachments] CHECK CONSTRAINT [FK_tb_members_attachments_tb_file_type]
GO
/****** Object:  ForeignKey [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc] FOREIGN KEY([AppModFuncID])
REFERENCES [dbo].[tb_AppModFunc] ([AppModFuncID])
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] CHECK CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc]
GO
/****** Object:  ForeignKey [FK_tb_Roles_AMF_AccessRights_tb_Roles]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] CHECK CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_Roles]
GO
/****** Object:  ForeignKey [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions] FOREIGN KEY([functionID])
REFERENCES [dbo].[tb_ModulesFunctions] ([functionID])
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] CHECK CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions]
GO
/****** Object:  ForeignKey [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] CHECK CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles]
GO
/****** Object:  ForeignKey [FK_tb_Roles_Users_tb_Roles]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_Users]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_Users_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_Users] CHECK CONSTRAINT [FK_tb_Roles_Users_tb_Roles]
GO
/****** Object:  ForeignKey [FK_tb_Roles_Users_tb_Users]    Script Date: 08/24/2012 23:40:31 ******/
ALTER TABLE [dbo].[tb_Roles_Users]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_Users_tb_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[tb_Users] ([UserID])
GO
ALTER TABLE [dbo].[tb_Roles_Users] CHECK CONSTRAINT [FK_tb_Roles_Users_tb_Users]
GO
