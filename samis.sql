USE [DOS]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_CheckSAMIS1Name]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_CheckSAMIS1Remarks]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getAppModFuncCategorize]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getAppModFuncPredcessor]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getAttendancePercentage]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	DECLARE @AttandancePercentage NUMERIC(6,0) = 0;
	IF(@TotalDayConducted > 0)
	BEGIN
		SET @AttandancePercentage  = (SELECT CONVERT(NUMERIC(4,0), @TotalDayAttended) / CONVERT(NUMERIC(4,2), @TotalDayConducted) * 100);
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
/****** Object:  UserDefinedFunction [dbo].[udf_getAttendencePoint]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getCongregationIDFromModuleFunction]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getDialect]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getEducation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getEndDate]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getEndDate]
(
	-- Add the parameters for the function here
	@date VARCHAR(MAX)
)
RETURNS DATE
AS
BEGIN

DECLARE @myDate DATE = (
	SELECT TOP 1 CONVERT(DATE, items, 103) AS MyDate FROM [dbo].[udf_Split](@date, ',')
	ORDER BY MyDate DESC);

RETURN @myDate;
END

GO
/****** Object:  UserDefinedFunction [dbo].[udf_getGender]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getLanguages]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getMaritialStatus]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getMinistry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getStafforMemberName]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_getStartDate]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getStartDate]
(
	-- Add the parameters for the function here
	@date VARCHAR(MAX)
)
RETURNS DATE
AS
BEGIN

DECLARE @myDate DATE = (
	SELECT TOP 1 CONVERT(DATE, items, 103) AS MyDate FROM [dbo].[udf_Split](@date, ',')
	ORDER BY MyDate ASC);

RETURN @myDate;
END

GO
/****** Object:  UserDefinedFunction [dbo].[udf_isCourseConductedInYear]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_isCourseConductedInYear]
(
	@startdate VARCHAR(2000),
	@Year INT
)
RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT 1 WHERE DATEPART(YEAR, CONVERT(DATE, (SELECT TOP 1 CONVERT(DATE, items, 103) FROM dbo.udf_Split(@startdate, ',') ORDER BY CONVERT(DATE, items, 103) ASC), 103)) = @Year)
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
/****** Object:  UserDefinedFunction [dbo].[udf_isCourseStillRunning]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_SearchName]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION  [dbo].[udf_SearchName]
(
-- Add the parameters for the function here
@NameSearch VARCHAR(200),
@Value VARCHAR(2000)
)
RETURNS BIT
AS
BEGIN


DECLARE @TABLE TABLE(SearchValue VARCHAR(20), Found BIT)
INSERT INTO @TABLE(SearchValue, Found)
SELECT ITEMS, 0 FROM dbo.udf_Split(RTRIM(LTRIM(@NameSearch)),' ')

UPDATE @TABLE SET Found = 1
WHERE SearchValue IN(
SELECT ITEMS FROM dbo.udf_Split(RTRIM(LTRIM(@NameSearch)),' ')
WHERE @Value LIKE ITEMS + ' %' OR @Value LIKE '% ' + ITEMS OR @Value LIKE '% ' +ITEMS+' %' OR @Value LIKE '% '+ITEMS+',%' OR @Value LIKE ITEMS+',%')
IF ((SELECT COUNT(1) FROM @TABLE) = (SELECT COUNT(1) FROM @TABLE WHERE Found = 1))
BEGIN
RETURN CONVERT(bit, 1)
END
ELSE
BEGIN
RETURN CONVERT(bit, 0)
END

RETURN 0


END




GO
/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_Split](@String varchar(MAX), @Delimiter char(1))       
returns @temptable TABLE (items varchar(100))       
as       
begin       
    declare @idx int;       
    declare @slice varchar(MAX);       
      
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
/****** Object:  UserDefinedFunction [dbo].[udf_UrlEncode]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  Table [dbo].[tb_App_Config]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_AppModFunc]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[Description] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_AppModFunc_Description]  DEFAULT (''),
 CONSTRAINT [PK_tb_AppModFunc] PRIMARY KEY CLUSTERED 
(
	[AppModFuncID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_busgroup_cluster]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ccc_kids]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_cellgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_churchArea]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_clubgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_congregation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_congregation](
	[CongregationID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CongregationName] [varchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_congregation_Deleted]  DEFAULT ((0)),
 CONSTRAINT [PK_tb_congregation] PRIMARY KEY CLUSTERED 
(
	[CongregationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_country]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course](
	[courseID] [int] IDENTITY(20,1) NOT NULL,
	[CourseName] [varchar](100) NOT NULL,
	[CourseStartDate] [varchar](8000) NOT NULL,
	[CourseEndDate] [date] NULL,
	[CourseStartTime] [time](7) NOT NULL,
	[CourseEndTime] [time](7) NOT NULL,
	[CourseInCharge] [varchar](10) NOT NULL,
	[CourseLocation] [tinyint] NOT NULL,
	[CourseDay] [varchar](50) NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_course_Deleted]  DEFAULT ((0)),
	[Fee] [decimal](5, 2) NOT NULL CONSTRAINT [DF_tb_course_Fee]  DEFAULT ((0.00)),
	[LastRegistrationDate] [date] NOT NULL,
	[AdditionalQuestion] [int] NOT NULL CONSTRAINT [DF_tb_course_AdditionalQuestion]  DEFAULT ((1)),
	[MinCompleteAttendance] [int] NOT NULL CONSTRAINT [DF_tb_course_MinPercentage]  DEFAULT ((1)),
	[URLLink] [varchar](2000) NOT NULL CONSTRAINT [DF_tb_course_URLLink]  DEFAULT (''),
	[SendReminder] [bit] NOT NULL CONSTRAINT [DF_tb_course_SendReminder]  DEFAULT ((1)),
	[ReminderSent] [bit] NOT NULL CONSTRAINT [DF_tb_course_ReminderSent]  DEFAULT ((0)),
	[Speaker] [varchar](100) NOT NULL CONSTRAINT [DF_tb_course_Speaker_1]  DEFAULT (''),
 CONSTRAINT [PK_tb_course] PRIMARY KEY CLUSTERED 
(
	[courseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course_agreement]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course_agreement](
	[AgreementID] [int] IDENTITY(1,1) NOT NULL,
	[AgreementType] [varchar](100) NULL,
	[AgreementHTML] [varchar](max) NOT NULL,
 CONSTRAINT [PK_tb_course_agreement] PRIMARY KEY CLUSTERED 
(
	[AgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course_attachment]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course_attachment](
	[FileName] [varchar](50) NOT NULL,
	[base64Content] [varchar](max) NOT NULL,
 CONSTRAINT [PK_tb_course_attachment] PRIMARY KEY CLUSTERED 
(
	[FileName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course_Attendance]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  Table [dbo].[tb_course_participant]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_course_participant](
	[NRIC] [varchar](20) NOT NULL,
	[courseID] [int] NOT NULL,
	[feePaid] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_feePaid]  DEFAULT ((0)),
	[materialReceived] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_materialReceived]  DEFAULT ((0)),
	[RegistrationDate] [datetime] NOT NULL CONSTRAINT [DF_tb_course_participant_RegistrationDate]  DEFAULT (getdate()),
	[MarkSync] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_MarkSync]  DEFAULT ((0)),
	[AdditionalInformation] [xml] NOT NULL CONSTRAINT [DF_tb_course_participant_AdditionalInformation]  DEFAULT ('<div />'),
 CONSTRAINT [PK_tb_course_participant] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC,
	[courseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_course_schedule]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_dialect]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_DOSLogging]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[LogID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_education]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_emailContent]    Script Date: 5/7/2016 6:44:01 AM ******/
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ExternalDB]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_ExternalDB](
	[ExternalDBID] [int] IDENTITY(1,1) NOT NULL,
	[ExternalSiteName] [varchar](200) NOT NULL CONSTRAINT [DF_tb_ExternalDB_ExternalSiteName]  DEFAULT (''),
	[ExternalDBIP] [varchar](200) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_familytype]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_file_type]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_HokkienAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_HokkienAttendance](
	[ID] [int] NOT NULL,
	[AttendanceDate] [date] NOT NULL,
 CONSTRAINT [PK_tb_HokkienAttendance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[AttendanceDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_HokkienMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_HokkienMember](
	[ID] [int] IDENTITY(1000,1) NOT NULL,
	[EnglishSurname] [varchar](10) NOT NULL,
	[EnglishGivenName] [varchar](30) NOT NULL,
	[ChineseSurname] [nvarchar](2) NOT NULL,
	[ChineseGivenName] [nvarchar](3) NOT NULL,
	[Birthday] [date] NULL,
	[Contact] [varchar](10) NOT NULL,
	[AddressHouseBlock] [varchar](70) NOT NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressUnit] [varchar](10) NOT NULL,
	[AddressPostalCode] [int] NOT NULL,
	[Photo] [varchar](1000) NOT NULL,
	[NextOfKinName] [varchar](50) NOT NULL,
	[NextOfKinContact] [varchar](10) NOT NULL,
	[Remarks] [varchar](8000) NOT NULL,
 CONSTRAINT [PK_tb_HokkienMember] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_HokkienWorshipDate]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_HokkienWorshipDate](
	[WorshipDate] [date] NOT NULL,
 CONSTRAINT [PK_tb_HokkienWorshipDate] PRIMARY KEY CLUSTERED 
(
	[WorshipDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_language]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_maritalstatus]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_members]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_members](
	[Salutation] [tinyint] NOT NULL,
	[EnglishName] [varchar](50) NOT NULL,
	[ChineseName] [nvarchar](50) NOT NULL CONSTRAINT [DF_tb_members_ChineseName]  DEFAULT (''),
	[DOB] [date] NOT NULL,
	[Gender] [varchar](1) NOT NULL,
	[NRIC] [varchar](20) NOT NULL,
	[Nationality] [tinyint] NOT NULL,
	[Dialect] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_Dialect]  DEFAULT ((0)),
	[MaritalStatus] [tinyint] NOT NULL,
	[MarriageDate] [date] NULL,
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](70) NOT NULL,
	[AddressPostalCode] [int] NOT NULL,
	[AddressUnit] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_AddressUnit]  DEFAULT (''),
	[Email] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_Email]  DEFAULT (''),
	[Education] [tinyint] NOT NULL,
	[Language] [varchar](200) NOT NULL,
	[Occupation] [tinyint] NOT NULL,
	[HomeTel] [varchar](50) NOT NULL CONSTRAINT [DF_tb_members_HomeTel]  DEFAULT (''),
	[MobileTel] [varchar](50) NOT NULL CONSTRAINT [DF_tb_members_MobileTel]  DEFAULT (''),
	[BaptismDate] [date] NULL CONSTRAINT [DF_tb_members_BaptismDate]  DEFAULT (''),
	[BaptismBy] [varchar](20) NOT NULL CONSTRAINT [DF_tb_members_BaptismBy]  DEFAULT (''),
	[BaptismByOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_BaptismByOthers]  DEFAULT (''),
	[BaptismChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_BaptismChurch]  DEFAULT ((0)),
	[BaptismChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_BaptismChurchOthers]  DEFAULT (''),
	[ConfirmDate] [date] NULL,
	[ConfirmBy] [varchar](20) NOT NULL CONSTRAINT [DF_tb_members_ConfirmBy]  DEFAULT (''),
	[ConfirmByOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_ConfirmByOthers]  DEFAULT (''),
	[ConfirmChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_ConfirmChurch]  DEFAULT ((0)),
	[ConfirmChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_ConfirmChurchOthers]  DEFAULT (''),
	[TransferReason] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_members_TransferReason]  DEFAULT (''),
	[Family] [xml] NOT NULL CONSTRAINT [DF_tb_members_Family]  DEFAULT ('<FamilyList></FamilyList>'),
	[Child] [xml] NOT NULL CONSTRAINT [DF_tb_members_Child]  DEFAULT ('<ChildList></ChildList>'),
	[CurrentParish] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_CurrentParish]  DEFAULT ((0)),
	[ICPhoto] [varchar](1000) NOT NULL,
	[PreviousChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_PreviousChurch]  DEFAULT ((0)),
	[PreviousChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_PreviousChurchOthers]  DEFAULT (''),
	[DeceasedDate] [date] NULL,
	[CreatedDate] [date] NOT NULL CONSTRAINT [DF_tb_members_CreatedDate]  DEFAULT (getdate()),
	[CarIU] [varchar](20) NOT NULL CONSTRAINT [DF_tb_members_CarIU]  DEFAULT (''),
	[ReceiveMailingList] [bit] NOT NULL CONSTRAINT [DF_tb_members_ReceiveMailingList]  DEFAULT ((0)),
 CONSTRAINT [PK_tb_members] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_members_attachments]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_members_temp]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[Dialect] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_Dialect]  DEFAULT ((0)),
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
	[BaptismByOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismByOthers]  DEFAULT (''),
	[BaptismChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismChurch]  DEFAULT ((0)),
	[BaptismChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismChurchOthers]  DEFAULT (''),
	[ConfirmDate] [date] NULL,
	[ConfirmBy] [varchar](20) NOT NULL,
	[ConfirmByOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmByOthers]  DEFAULT (''),
	[ConfirmChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmChurch]  DEFAULT ((0)),
	[ConfirmChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmChurchOthers]  DEFAULT (''),
	[TransferReason] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_members_temp_TransferReason]  DEFAULT (''),
	[Family] [xml] NOT NULL,
	[Child] [xml] NOT NULL,
	[CurrentParish] [tinyint] NOT NULL,
	[ICPhoto] [varchar](1000) NOT NULL,
	[PreviousChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_PreviousChurch]  DEFAULT ((0)),
	[PreviousChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_members_temp_PreviousChurchOthers]  DEFAULT (''),
	[DeceasedDate] [date] NULL,
	[CreatedDate] [date] NOT NULL CONSTRAINT [DF_tb_members_temp_CreatedDate]  DEFAULT (getdate()),
	[CarIU] [nchar](10) NOT NULL CONSTRAINT [DF_tb_members_temp_CarIU]  DEFAULT (''),
	[MarkSync] [bit] NOT NULL CONSTRAINT [DF_tb_members_temp_MarkSync]  DEFAULT ((0)),
	[ReceiveMailingList] [bit] NOT NULL CONSTRAINT [DF_tb_members_temp_ReceiveMailingList]  DEFAULT ((0)),
 CONSTRAINT [PK_tb_members_temp] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_membersOtherInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_membersOtherInfo](
	[NRIC] [varchar](20) NOT NULL,
	[ElectoralRoll] [date] NULL,
	[CellGroup] [tinyint] NOT NULL CONSTRAINT [DF_tb_memberOtherInfo_CellGroup]  DEFAULT ((0)),
	[Congregation] [tinyint] NOT NULL,
	[MinistryInvolvement] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_MinistryInvolvement]  DEFAULT ('<Ministry></Ministry>'),
	[MinistryInterested] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_MinistryInterested]  DEFAULT ('<Ministry></Ministry>'),
	[TithingInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_TithingInterested]  DEFAULT ((0)),
	[CellgroupInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_CellgroupInterested]  DEFAULT ((0)),
	[ServeCongregationInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_ServeCongregationInterested]  DEFAULT ((0)),
	[Sponsor1] [varchar](20) NOT NULL,
	[Sponsor2] [varchar](100) NOT NULL,
	[Sponsor2Contact] [varchar](100) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_Sponsor2Contact]  DEFAULT (''),
	[MemberDate] [date] NULL,
	[Remarks] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_Remarks]  DEFAULT (''),
	[TransferTo] [varchar](100) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_TransferTo]  DEFAULT (''),
	[TransferToDate] [date] NULL,
 CONSTRAINT [PK_tb_membersOtherInfo] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_membersOtherInfo_temp]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_membersOtherInfo_temp](
	[NRIC] [varchar](20) NOT NULL,
	[ElectoralRoll] [date] NULL,
	[CellGroup] [tinyint] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_CellGroup]  DEFAULT ((0)),
	[Congregation] [tinyint] NOT NULL,
	[MinistryInvolvement] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInvolvement]  DEFAULT ('<Ministry></Ministry>'),
	[MinistryInterested] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInterested]  DEFAULT ('<Ministry></Ministry>'),
	[TithingInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_TithingInterested]  DEFAULT ((0)),
	[CellgroupInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_CellgroupInterested]  DEFAULT ((0)),
	[ServeCongregationInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_ServeCongregationInterested]  DEFAULT ((0)),
	[Sponsor1] [varchar](20) NOT NULL,
	[Sponsor2] [varchar](100) NOT NULL,
	[Sponsor2Contact] [varchar](100) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_Sponsor2Contact]  DEFAULT (''),
	[MemberDate] [date] NULL,
	[Remarks] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_Remarks]  DEFAULT (''),
	[TransferTo] [varchar](100) NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_TransferTo]  DEFAULT (''),
	[TransferToDate] [date] NULL,
 CONSTRAINT [PK_tb_membersOtherInfo_temp] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ministry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_ModulesFunctions]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[Description] [varchar](1000) NOT NULL CONSTRAINT [DF_tb_ModulesFunctions_Description]  DEFAULT (''),
 CONSTRAINT [PK_tb_ModulesFunctions] PRIMARY KEY CLUSTERED 
(
	[functionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_occupation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_parish]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_postalArea]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_postalArea](
	[District] [int] IDENTITY(1,1) NOT NULL,
	[PostalAreaName] [varchar](200) NOT NULL,
	[PostalDigit] [varchar](200) NOT NULL CONSTRAINT [DF_tb_postalArea_PostalDigit]  DEFAULT (''),
 CONSTRAINT [PK_tb_postalArea] PRIMARY KEY CLUSTERED 
(
	[District] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_race]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_religion]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Roles]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Roles_AMF_AccessRights]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Roles_ModulesFunctionsAccessRight]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tb_Roles_Users]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Salutation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_school]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_style]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_Users]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[Password] [varchar](40) NOT NULL CONSTRAINT [DF_tb_Users_Password]  DEFAULT (''),
	[Style] [int] NULL CONSTRAINT [DF_tb_Users_Appointment]  DEFAULT ((0)),
	[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_Users_Deleted]  DEFAULT ((0)),
 CONSTRAINT [PK_tb_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_visitors]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	[Email] [varchar](100) NOT NULL CONSTRAINT [DF_tb_visitors_Email]  DEFAULT (''),
	[Contact] [varchar](15) NOT NULL CONSTRAINT [DF_tb_visitors_Contact]  DEFAULT (''),
	[AddressStreet] [varchar](100) NOT NULL,
	[AddressHouseBlk] [varchar](10) NOT NULL,
	[AddressPostalCode] [int] NULL,
	[AddressUnit] [varchar](10) NOT NULL,
	[Church] [tinyint] NOT NULL CONSTRAINT [DF_tb_visitors_Church]  DEFAULT ((0)),
	[ChurchOthers] [varchar](100) NOT NULL CONSTRAINT [DF_tb_visitors_ChurchOthers]  DEFAULT (''),
	[Congregation] [tinyint] NULL,
	[VisitorType] [tinyint] NOT NULL,
	[ReceiveMailingList] [bit] NOT NULL CONSTRAINT [DF_tb_visitors_ReceiveMailingList]  DEFAULT ((0)),
 CONSTRAINT [PK_tb_visitors] PRIMARY KEY CLUSTERED 
(
	[NRIC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tb_visitorType]    Script Date: 5/7/2016 6:44:01 AM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Email]  DEFAULT ('') FOR [Email]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_SpecialNeeds]  DEFAULT ('') FOR [SpecialNeeds]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Transport]  DEFAULT ((0)) FOR [Transport]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Religion]  DEFAULT ((0)) FOR [Religion]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_ClubGroup]  DEFAULT ((0)) FOR [ClubGroup]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_BusGroupCluster]  DEFAULT ((0)) FOR [BusGroupCluster]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Points]  DEFAULT ((0)) FOR [Points]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD  CONSTRAINT [DF_tb_ccc_kids_Photo]  DEFAULT ('') FOR [Photo]
GO
ALTER TABLE [dbo].[tb_cellgroup] ADD  CONSTRAINT [DF_tb_cellgroup_Unit]  DEFAULT ('') FOR [Unit]
GO
ALTER TABLE [dbo].[tb_cellgroup] ADD  CONSTRAINT [DF_tb_cellgroup_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_EnglishSurname]  DEFAULT ('') FOR [EnglishSurname]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_EnglishGivenName]  DEFAULT ('') FOR [EnglishGivenName]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_ChineseSurname]  DEFAULT ('') FOR [ChineseSurname]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_ChineseGivenName]  DEFAULT ('') FOR [ChineseGivenName]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_Contact]  DEFAULT ('') FOR [Contact]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_Table_1_AddressBlock]  DEFAULT ('') FOR [AddressHouseBlock]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_Table_1_AddressStreetName]  DEFAULT ('') FOR [AddressStreet]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_AddressUnit]  DEFAULT ('') FOR [AddressUnit]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_AddressPostalCode]  DEFAULT ((0)) FOR [AddressPostalCode]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_Photo]  DEFAULT ('') FOR [Photo]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_NextOfKinName]  DEFAULT ('') FOR [NextOfKinName]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_NextOfKinContact]  DEFAULT ('') FOR [NextOfKinContact]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD  CONSTRAINT [DF_tb_HokkienMember_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[tb_members_attachments] ADD  CONSTRAINT [DF_tb_members_attachments_Remarks]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [dbo].[tb_ministry] ADD  CONSTRAINT [DF_tb_ministry_Deleted]  DEFAULT ((0)) FOR [Deleted]
GO
ALTER TABLE [dbo].[tb_course]  WITH CHECK ADD  CONSTRAINT [FK_tb_course_tb_course_agreement] FOREIGN KEY([AdditionalQuestion])
REFERENCES [dbo].[tb_course_agreement] ([AgreementID])
GO
ALTER TABLE [dbo].[tb_course] CHECK CONSTRAINT [FK_tb_course_tb_course_agreement]
GO
ALTER TABLE [dbo].[tb_course_participant]  WITH CHECK ADD  CONSTRAINT [FK_tb_course_participant_tb_course] FOREIGN KEY([courseID])
REFERENCES [dbo].[tb_course] ([courseID])
GO
ALTER TABLE [dbo].[tb_course_participant] CHECK CONSTRAINT [FK_tb_course_participant_tb_course]
GO
ALTER TABLE [dbo].[tb_HokkienAttendance]  WITH CHECK ADD  CONSTRAINT [FK_tb_HokkienAttendance_tb_HokkienWorshipDate] FOREIGN KEY([AttendanceDate])
REFERENCES [dbo].[tb_HokkienWorshipDate] ([WorshipDate])
GO
ALTER TABLE [dbo].[tb_HokkienAttendance] CHECK CONSTRAINT [FK_tb_HokkienAttendance_tb_HokkienWorshipDate]
GO
ALTER TABLE [dbo].[tb_members_attachments]  WITH CHECK ADD  CONSTRAINT [FK_tb_members_attachments_tb_file_type] FOREIGN KEY([FileType])
REFERENCES [dbo].[tb_file_type] ([FileTypeID])
GO
ALTER TABLE [dbo].[tb_members_attachments] CHECK CONSTRAINT [FK_tb_members_attachments_tb_file_type]
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc] FOREIGN KEY([AppModFuncID])
REFERENCES [dbo].[tb_AppModFunc] ([AppModFuncID])
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] CHECK CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc]
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] CHECK CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_Roles]
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions] FOREIGN KEY([functionID])
REFERENCES [dbo].[tb_ModulesFunctions] ([functionID])
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] CHECK CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions]
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] CHECK CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles]
GO
ALTER TABLE [dbo].[tb_Roles_Users]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_Users_tb_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_Users] CHECK CONSTRAINT [FK_tb_Roles_Users_tb_Roles]
GO
ALTER TABLE [dbo].[tb_Roles_Users]  WITH CHECK ADD  CONSTRAINT [FK_tb_Roles_Users_tb_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[tb_Users] ([UserID])
GO
ALTER TABLE [dbo].[tb_Roles_Users] CHECK CONSTRAINT [FK_tb_Roles_Users_tb_Users]
GO
ALTER TABLE [dbo].[tb_visitors]  WITH CHECK ADD  CONSTRAINT [FK_tb_visitors_tb_congregation] FOREIGN KEY([Congregation])
REFERENCES [dbo].[tb_congregation] ([CongregationID])
GO
ALTER TABLE [dbo].[tb_visitors] CHECK CONSTRAINT [FK_tb_visitors_tb_congregation]
GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCellgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_addNewCityKid]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_addNewCourse]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_addNewCourse]
(@Speaker VARCHAR(100),
 @SendReminder BIT,
 @coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT,
 @fee DECIMAL(5, 2),
 @AdditionalQuestion INT,
 @LastRegistration DateTime,
 @MinCompleteAttendance INT)
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_course (Speaker, SendReminder, MinCompleteAttendance, AdditionalQuestion, LastRegistrationDate, Fee, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation)
SELECT @Speaker, @SendReminder, @MinCompleteAttendance, @AdditionalQuestion, @LastRegistration, @fee, @coursename, @startdate, @starttime, @endtime, @incharge, @location

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseMemberParticipant]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipant]
(@NRIC VARCHAR(100),
 @courseid int,
 @AdditionalInformation XML)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
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
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
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
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
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
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseMemberParticipantAndAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipantAndAttendance]
(@NRIC VARCHAR(100),
 @courseid int,
 @today DateTime)
AS
SET NOCOUNT ON;

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
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseVisitorParticipant]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipant]
(@Visitor XML, @course VARCHAR(10),
@FinalResult VARCHAR(10) OUTPUT,
@FinalSalutation VARCHAR(10) OUTPUT,
@FinalEnglishName VARCHAR(50) OUTPUT,
@FinalCourseName VARCHAR(100) OUTPUT,
@AdditionalInformation XML)
AS
SET NOCOUNT ON;


DECLARE @nric VARCHAR(20),
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
@church_others VARCHAR(100), @UserID VARCHAR(50),
@candidate_mailingList VARCHAR(3),
@candidate_congregation TINYINT,
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @Visitor;
	
    SELECT @candidate_mailingList = mailingList, @UserID = EnteredBy, @nric = OriginalNric, @salutation = Salutation,
	@english_name = EnglishName, @gender = Gender, @dob = CONVERT(DATETIME, DOB, 103),
	@nationality = Nationality, @contact = Contact,
	@street_address = AddressStreetName, @blk_house = AddressBlkHouse,
	@postal_code = AddressPostalCode, @unit = AddressUnit,
	@email = Email, @education = Education, @occupation = Occupation,
	@church = Church, @church_others = ChurchOthers, @candidate_congregation = Congregation
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
	mailingList VARCHAR(3) './mailingList',
	Church VARCHAR(3) './Church',
	ChurchOthers VARCHAR(3) './ChurchOthers',
	Congregation TINYINT './Congregation');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
BEGIN
	DECLARE @Result VARCHAR(100) = 'NotFound';
	IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateVistor @Visitor, @Result OUTPUT;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateMemberPartial @Visitor, @Result OUTPUT;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateMemberTempPartial @Visitor, @Result OUTPUT;
	END
	
	IF EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @nric AND courseID = @course)
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @course;
		
		SELECT @FinalResult = 'EXISTS', @FinalSalutation = @salutation, @FinalEnglishName = @english_name, @FinalCourseName = CourseName FROM dbo.tb_course WHERE courseID = @course;		
		return;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_addNewCourseMemberParticipant @nric, @course, @AdditionalInformation
		SELECT @FinalResult = 'OK', @FinalSalutation = @salutation, @FinalEnglishName = @english_name, @FinalCourseName = CourseName FROM dbo.tb_course WHERE courseID = @course;
		return;
	END
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
	
	INSERT INTO dbo.tb_visitors(Congregation, receiveMailingList, Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @candidate_congregation, @candidate_mailingListBoolean, @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
	SELECT @nric, @course, ISNULL(@AdditionalInformation, '<div />');
	
	DECLARE @newVisitorXML XML = (
	SELECT  C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers, ISNULL(G.CongregationName, '') AS CongregationName
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	LEFT OUTER JOIN dbo.tb_congregation AS G on G.CongregationID = A.Congregation
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	DECLARE @temp table(a INT)
	INSERT INTO @temp(a)
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
		
	SELECT @FinalResult = 'OK', @FinalSalutation = ISNULL(D.SalutationName, ''), @FinalEnglishName = B.EnglishName, @FinalCourseName = C.CourseName FROM dbo.tb_course_participant AS A
	INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
	INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
	LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
	WHERE A.NRIC = @nric AND A.courseID = @course
END

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_addNewCourseVisitorParticipantAndAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipantAndAttendance]
(@Congregation VARCHAR(3), @mailingList VARCHAR(3), @nric VARCHAR(10),
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
@church_others VARCHAR(100), @UserID VARCHAR(50),
@today DateTime)
AS
SET NOCOUNT ON;

DECLARE @candidate_mailingListBoolean BIT = 0;
IF(@mailingList = 'ON')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END


IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
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

	INSERT INTO dbo.tb_visitors(Congregation, ReceiveMailingList, Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @Congregation, @candidate_mailingListBoolean, @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID)
	SELECT @nric, @course;
	
	EXEC dbo.usp_UpdateCourseAttendance @course, @NRIC, @today;
	
	DECLARE @newVisitorXML XML = (
	SELECT  A.NRIC,
			C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers, ISNULL(G.CongregationName, '') AS CongregationName
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	LEFT OUTER JOIN dbo.tb_congregation AS G ON G.CongregationID = A.Congregation
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
END

SET NOCOUNT OFF;

			

GO
/****** Object:  StoredProcedure [dbo].[usp_addNewHWSMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_addNewHWSMember]
(@newXML AS XML,
 @Result VARCHAR(10) OUTPUT)
AS
	SET NOCOUNT ON;

	SET @Result = '0';


	DECLARE @UserID VARCHAR(50),
	@EnglishSurname VARCHAR(10),
	@EnglishGivenName VARCHAR(30),
	@ChineseSurname NVARCHAR(2),
	@ChineseGivenName NVARCHAR(3),
	@DOB VARCHAR(10),
	@Contact VARCHAR(10),
	@NOK VARCHAR(50),
	@NOKContact VARCHAR(10),
	@candidate_street_address VARCHAR(100),
	@candidate_postal_code INT,
	@candidate_blk_house VARCHAR(70),
	@candidate_unit VARCHAR(10),
	@candidate_photo VARCHAR(1000),
	@remarks VARCHAR(8000);

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @EnglishSurname = EnglishSurname, @EnglishGivenName = EnglishGivenName, @ChineseSurname = ChineseSurname,
	@ChineseGivenName = ChineseGivenName, @DOB = DOB, @Contact = Contact, @NOK = NOK, @NOKContact = NOKContact,
	@candidate_street_address = candidate_street_address, @candidate_postal_code = candidate_postal_code, 
	@candidate_blk_house = candidate_blk_house, @candidate_unit = candidate_unit, @candidate_photo = candidate_photo, @remarks = remarks
	FROM OPENXML(@idoc, '/new')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	EnglishSurname VARCHAR(10)'./EnglishSurname',
	EnglishGivenName VARCHAR(30) './EnglishGivenName',
	ChineseSurname NVARCHAR(2) './ChineseSurname',
	ChineseGivenName NVARCHAR(3) './ChineseGivenName',
	DOB VARCHAR(10) './DOB',
	Contact VARCHAR(10) './Contact',
	NOK VARCHAR(50) './NOK',
	NOKContact VARCHAR(10) './NOKContact',
	candidate_street_address VARCHAR(100) './candidate_street_address',
	candidate_postal_code INT './candidate_postal_code',
	candidate_blk_house VARCHAR(70) './candidate_blk_house',
	candidate_unit VARCHAR(10) './candidate_unit',
	candidate_photo VARCHAR(1000) './candidate_photo',
	remarks VARCHAR(8000) './remarks');

	if(LEN(@DOB) = 0)
	BEGIN
		SET @DOB = null;
	END

	INSERT INTO [dbo].[tb_HokkienMember] ([EnglishSurname] ,[EnglishGivenName] ,[ChineseSurname] ,[ChineseGivenName] ,[Birthday] ,[Contact]
      ,[AddressHouseBlock] ,[AddressStreet] ,[AddressUnit] ,[AddressPostalCode] ,[Photo] ,[NextOfKinName] ,[NextOfKinContact] ,[Remarks])
	SELECT @EnglishSurname, @EnglishGivenName, @ChineseSurname, @ChineseGivenName, CONVERT(DATE, @DOB, 103), @Contact, @candidate_blk_house, @candidate_street_address,
	@candidate_unit, @candidate_postal_code, @candidate_photo, @NOK, @NOKContact, @remarks

	DECLARE @ID VARCHAR(10);
	SELECT @ID = @@identity;

	DECLARE @newMemberXML XML = (
	SELECT ID, [EnglishSurname] ,[EnglishGivenName] ,[ChineseSurname] ,[ChineseGivenName] ,[Birthday] ,[Contact]
      ,[AddressHouseBlock] ,[AddressStreet] ,[AddressUnit] ,[AddressPostalCode] ,[Photo] ,[NextOfKinName] ,[NextOfKinContact] ,[Remarks]
	FROM [dbo].[tb_HokkienMember] WHERE ID = @ID
	FOR XML PATH, ELEMENTS)


	
	DECLARE @LogID TABLE(ID INT);
	INSERT INTO @LogID(ID)
	EXEC dbo.usp_insertlogging 'I', @UserID, 'HWSMembership', 'New', 1, 'NRIC', @ID, @newMemberXML;			

	SET @Result = 'OK';

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_addNewMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_addNewMember]
(@newXML AS XML,
 @Result VARCHAR(10) OUTPUT)
AS
SET NOCOUNT ON;

SET @Result = '0';

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
@candidate_sponsor2 VARCHAR(100),
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
@previous_church_others VARCHAR(100),
@candidate_mailingList VARCHAR(3),
@candidate_mailingListBoolean BIT = 0;




DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @candidate_mailingList = mailingLIst, @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
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
	Sponsor2 VARCHAR(100) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	mailingList VARCHAR(3) './mailingList',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
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

IF EXISTS (SELECT * FROM dbo.tb_visitors WHERE NRIC = @candidate_nric)
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_visitors WHERE NRIC = @candidate_nric;
END

IF NOT EXISTS( SELECT * FROM dbo.tb_members WHERE NRIC = @candidate_nric)
BEGIN
	DECLARE @SystemMode VARCHAR(100) = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'SystemMode');
	IF(@SystemMode = 'SAMIS')
	BEGIN
		DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @candidate_nric;
		DELETE FROM dbo.tb_members_temp WHERE NRIC = @candidate_nric;
	END
	
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
							BaptismByOthers, ConfirmByOthers , BaptismChurchOthers , ConfirmChurchOthers , PreviousChurchOthers, ReceiveMailingList)
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
			@previous_church_others,
			@candidate_mailingListBoolean;
			
			SET @Result = @@ROWCOUNT;
			
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
			LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
			LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
			LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_parish AS G ON A.ConfirmChurch = G.ParishID
			LEFT OUTER JOIN dbo.tb_parish AS H ON A.BaptismChurch = H.ParishID
			LEFT OUTER JOIN dbo.tb_congregation AS K ON B.Congregation = K.CongregationID
			LEFT OUTER JOIN dbo.tb_parish AS L ON A.PreviousChurch = L.ParishID
			WHERE A.NRIC = @candidate_nric
			FOR XML PATH, ELEMENTS)
			
			DECLARE @LogID TABLE(ID INT);
			INSERT INTO @LogID(ID)
			EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'New', 1, 'NRIC', @candidate_nric, @newMemberXML;			
	END

END		

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_addNewMinistry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_addNewUser]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ApproveMembership]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ApproveMembership]
(@NRICS VARCHAR(MAX))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_members
SELECT [Salutation] ,[EnglishName] ,[ChineseName] ,[DOB] ,[Gender] ,[NRIC]
      ,[Nationality] ,[Dialect] ,[MaritalStatus] ,[MarriageDate] ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit]
      ,[Email] ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate] ,[BaptismBy]
      ,[BaptismByOthers] ,[BaptismChurch] ,[BaptismChurchOthers] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmByOthers] ,[ConfirmChurch] ,[ConfirmChurchOthers]
      ,[TransferReason] ,[Family] ,[Child] ,[CurrentParish] ,[ICPhoto] ,[PreviousChurch] ,[PreviousChurchOthers]
      ,[DeceasedDate] ,[CreatedDate]
      ,[CarIU], ReceiveMailingList FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

INSERT INTO dbo.tb_membersOtherInfo
SELECT * FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
	
DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
DELETE FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SELECT ICPhoto, @@ROWCOUNT AS Result FROM dbo.tb_members WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_checkFileInUsed]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_checkUserLogin]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllBusGroupCluster]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllBusGroupClusterInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllChurchArea]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllChurchArea]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,AreaID) AS AreaID, AreaName FROM tb_ChurchArea;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllChurchAreaInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllClergy]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllClubgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllClubGroupInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllConfigInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllCongregation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllCongregationExcludeSoftDelete]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCongregationExcludeSoftDelete]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,CongregationID) AS CongregationID, CongregationName FROM tb_congregation WHERE Deleted = 0
	

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCongregationInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCongregationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select CongregationID AS ID, CongregationName AS Name from dbo.tb_congregation FOR XML PATH('Type'), ROOT('ChurchCongregation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCountry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllCountryInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCountryInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select CountryID AS ID, CountryName AS Name from dbo.tb_country FOR XML PATH('Type'), ROOT('ChurchCountry'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCourseAdditionalInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCourseAdditionalInfo]

AS
SET NOCOUNT ON;

	Select AgreementID, AgreementType, AgreementHTML FROM dbo.tb_course_agreement
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCourseAdditionalInfoInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCourseAdditionalInfoInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select AgreementID, AgreementType, AgreementHTML from dbo.tb_course_agreement FOR XML PATH('AdditionalInfo'), ROOT('ChurchAdditionalInfo'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCourseReminderRecipients]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCourseReminderRecipients]
AS
SET NOCOUNT ON;

DECLARE @DaysBeforeStart INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'CourseSendReminderDays');
DECLARE @CourseDate DATE = DATEADD(DAY, @DaysBeforeStart, GETDATE());

DECLARE @Table TABLE(CourseID INT);

INSERT INTO @Table(CourseID)
SELECT [courseID]
FROM [dbo].[tb_course] 
WHERE dbo.udf_getStartDate([CourseStartDate]) = @CourseDate AND SendReminder = 1 AND ReminderSent = 0;

SELECT ISNULL(ISNULL(C.Email, D.Email), E.Email) AS Email, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name 
	   ,B.CourseName, F.AreaName, B.CourseStartTime, B.CourseEndTime, B.CourseStartDate
FROM dbo.tb_course_participant AS A
INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
LEFT OUTER JOIN dbo.tb_members AS C ON C.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_members_temp AS D ON D.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_visitors AS E ON E.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_churchArea AS F ON F.AreaID = B.CourseLocation
WHERE A.courseID IN (SELECT courseID FROM @Table);

UPDATE [dbo].[tb_course] SET ReminderSent = 1
WHERE courseID IN(SELECT courseID FROM @Table);

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCourseYears]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCourseYears]

AS
SET NOCOUNT ON;

	  DECLARE @allDate VARCHAR(MAX) = ''
	  SELECT @allDate = @allDate + [CourseStartDate] + ',' FROM [dbo].[tb_course]
      SELECT DISTINCT YEAR(CONVERT(DATE, items, 103)) AS Year FROM [dbo].[udf_Split](@allDate,',')
	

SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [dbo].[usp_getAllDialect]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllDialectInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllDialectInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select DialectID AS ID, DialectName AS Name from dbo.tb_dialect FOR XML PATH('Type'), ROOT('ChurchDialect'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEducation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllEducationInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllEducationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EducationID AS ID, EducationName AS Name from dbo.tb_education FOR XML PATH('Type'), ROOT('ChurchEducation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllEmail]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllEmailInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllExternalDBInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllExternalDBInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select ExternalDBID, ExternalSiteName, ExternalDBIP from dbo.tb_ExternalDB FOR XML PATH('Site'), ROOT('ExternalDB'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	
SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllFamilyType]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllFamilyTypeInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllFileType]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllFileTypeInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllHWSAttendanceDate]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllHWSAttendanceDate]

AS
SET NOCOUNT ON;

	SELECT [WorshipDate] FROM [dbo].[tb_HokkienWorshipDate] order by [WorshipDate] desc;
	
SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_getAllHWSMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllHWSMember]

AS
SET NOCOUNT ON;

	SELECT [ID]
      ,[EnglishSurname]
      ,[EnglishGivenName]
      ,[ChineseSurname]
      ,[ChineseGivenName]
      ,[Birthday]
      ,[Contact]
      ,[AddressHouseBlock]
      ,[AddressStreet]
      ,[AddressUnit]
      ,[AddressPostalCode]
      ,[Photo]
      ,[NextOfKinName]
      ,[NextOfKinContact]
      ,[Remarks]
  FROM [dbo].[tb_HokkienMember] Order by EnglishSurname+EnglishGivenName, ChineseSurname+ChineseGivenName
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllLanguage]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllLanguageInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllLanguageInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select LanguageID AS ID, LanguageName AS Name from dbo.tb_language FOR XML PATH('Type'), ROOT('ChurchLanguage'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllMaritalStatus]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllMaritalStatusInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllMaritalStatusInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select MaritalStatusID AS ID, MaritalStatusName AS Name from dbo.tb_maritalstatus FOR XML PATH('Type'), ROOT('ChurchMaritalStatus'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllModulesFunctions]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllModulesFunctions]
AS
SET NOCOUNT ON;

SELECT CONVERT(XML,(SELECT AppModFuncID, AppModFuncName, [Description] FROM dbo.tb_AppModFunc WHERE AppModFuncID like '%.%.%' FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules'))) AS Modules,
CONVERT(XML,(SELECT functionID, FunctionName, [Description] FROM dbo.tb_ModulesFunctions FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions'))) AS Functions

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllOccupation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllOccupationInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllOccupationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select OccupationID AS ID, OccupationName AS Name from dbo.tb_occupation FOR XML PATH('Type'), ROOT('ChurchOccupation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllParish]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllParishInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllParishInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ParishID AS ID, ParishName AS Name from dbo.tb_parish FOR XML PATH('Type'), ROOT('ChurchParish'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllPostalAreaInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllPostalCode]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllRace]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllRaceInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllReligion]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllReligionInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllRoleInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllSalutation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllSalutationInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllSalutationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select SalutationID AS ID, SalutationName AS Name from dbo.tb_Salutation FOR XML PATH('Type'), ROOT('ChurchSalutation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllSchool]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllSchoolInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllSetting]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllSetting]

AS
SET NOCOUNT ON;

	Select ExternalDBID, ExternalSiteName, ExternalDBIP FROM dbo.tb_ExternalDB ORDER BY ExternalDBID ASC
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllSettingsInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetAllSettingsInXML]
AS
SET NOCOUNT ON;

DECLARE @XML XML = (SELECT
	CONVERT(XML, (SELECT [FileName], base64Content FROM dbo.tb_course_attachment FOR XML PATH('CourseAttachment'), ELEMENTS)) AS AllCourseAttachment,
	CONVERT(XML, (SELECT AgreementID, AgreementType, AgreementHTML FROM dbo.tb_course_agreement FOR XML PATH('ChurchAgreement'), ELEMENTS)) AS AllChurchAgreement,
	CONVERT(XML, (SELECT EmailID, EmailType, EmailContent FROM dbo.tb_emailContent FOR XML PATH('ChurchEmail'), ELEMENTS)) AS AllChurchEmail,
	CONVERT(XML, (SELECT AreaID, AreaName FROM dbo.tb_churchArea FOR XML PATH('ChurchArea'), ELEMENTS)) AS AllChurchArea,
	CONVERT(XML, (SELECT CongregationID, CongregationName, Deleted FROM dbo.tb_congregation FOR XML PATH('Congregation'), ELEMENTS)) AS AllCongregation,
	CONVERT(XML, (SELECT CountryID, CountryName FROM dbo.tb_country FOR XML PATH('Country'), ELEMENTS)) AS AllCountry,
	CONVERT(XML, (SELECT DialectID, DialectName FROM dbo.tb_dialect FOR XML PATH('Dialect'), ELEMENTS)) AS AllDialect,
	CONVERT(XML, (SELECT EducationID, EducationName FROM dbo.tb_education FOR XML PATH('Education'), ELEMENTS)) AS AllEducation,
	CONVERT(XML, (SELECT FileTypeID, FileType AS FileTypeName FROM dbo.tb_file_type FOR XML PATH('FileType'), ELEMENTS)) AS AllFileType,
	CONVERT(XML, (SELECT FamilyTypeID, FamilyType AS FamilyTypeName FROM dbo.tb_familytype FOR XML PATH('FamilyType'), ELEMENTS)) AS AllFamilyType,
	CONVERT(XML, (SELECT LanguageID, LanguageName FROM dbo.tb_language FOR XML PATH('Language'), ELEMENTS)) AS AllLanguage,
	CONVERT(XML, (SELECT MaritalStatusID, MaritalStatusName FROM dbo.tb_maritalstatus FOR XML PATH('MaritalStatus'), ELEMENTS)) AS AllMaritalStatus,
	CONVERT(XML, (SELECT OccupationID, OccupationName FROM dbo.tb_occupation FOR XML PATH('Occupation'), ELEMENTS)) AS AllOccupation,
	CONVERT(XML, (SELECT ParishID, ParishName FROM dbo.tb_parish FOR XML PATH('Parish'), ELEMENTS)) AS AllParish,
	CONVERT(XML, (SELECT SalutationID, SalutationName FROM dbo.tb_Salutation FOR XML PATH('Salutation'), ELEMENTS)) AS AllSalutation,
	CONVERT(XML, (SELECT StyleID, StyleName FROM dbo.tb_style FOR XML PATH('Style'), ELEMENTS)) AS AllStyle,
	CONVERT(XML, (SELECT District, PostalAreaName, PostalDigit FROM dbo.tb_postalArea FOR XML PATH('PostalArea'), ELEMENTS)) AS AllPostalArea,
	CONVERT(XML, (SELECT BusGroupClusterID, BusGroupClusterName FROM dbo.tb_busgroup_cluster FOR XML PATH('BusGroupCluster'), ELEMENTS)) AS AllBusGroupCluster,
	CONVERT(XML, (SELECT ClubGroupID, ClubGroupName FROM dbo.tb_clubgroup FOR XML PATH('ClubGroup'), ELEMENTS)) AS AllClubGroup,
	CONVERT(XML, (SELECT RaceID, RaceName FROM dbo.tb_race FOR XML PATH('Race'), ELEMENTS)) AS AllRace,
	CONVERT(XML, (SELECT ReligionID, ReligionName FROM dbo.tb_religion FOR XML PATH('Religion'), ELEMENTS)) AS AllReligion,
	CONVERT(XML, (SELECT SchoolID, SchoolName FROM dbo.tb_school FOR XML PATH('School'), ELEMENTS)) AS AllSchool,
	CONVERT(XML, (SELECT courseID ,CourseName ,CourseStartDate ,CourseStartTime ,CourseEndTime ,'S00000000' AS CourseInCharge ,CourseLocation ,CourseDay ,Deleted ,Fee, AdditionalQuestion, CONVERT(VARCHAR(10), LastRegistrationDate, 103) AS LastRegistrationDate FROM dbo.tb_course FOR XML PATH('Course'), ELEMENTS)) AS AllCourse
FOR XML PATH(''), ELEMENTS, ROOT('All'));

SELECT @XML as [XML];

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllStaff]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	WHERE A.Deleted = 0;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllStyle]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllStyleInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAllStyleInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select StyleID AS ID, StyleName AS Name from dbo.tb_style FOR XML PATH('Type'), ROOT('ChurchStyle'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getAllTextFieldLengthInXML]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAllUploadedAttachment]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAppConfig]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAppModFuncAccessRights]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getAssignedModulesFunctions]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getAssignedModulesFunctions]
(@RoleID AS INT)
AS
SET NOCOUNT ON;

DECLARE @RoleName VARCHAR(50) = (SELECT RoleName FROM dbo.tb_Roles WHERE RoleID = @RoleID);

SELECT (SELECT CONVERT(XML,ISNULL((SELECT B.AppModFuncID, B.AppModFuncName, B.[Description] FROM dbo.tb_Roles_AMF_AccessRights AS A INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID WHERE RoleID = @RoleID FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules')),'<AllModules />')),
CONVERT(XML, ISNULL((SELECT B.functionID, B.functionName, B.[Description] FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A INNER JOIN dbo.tb_ModulesFunctions AS B ON B.functionID = A.functionID WHERE RoleID = @RoleID FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions')),'<AllFunctions />')), @RoleName AS RoleName FOR XML PATH(''), ELEMENTS, ROOT('All')) AS XML;


SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getCellgroupInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getCityKidInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getCityKidSchedule]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getCourseAdditionalInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getCourseAdditionalInformation]
(@CourseID INT)
AS
SET NOCOUNT ON;

SELECT AgreementHTML, AgreementType FROM dbo.tb_course_agreement WHERE AgreementID = (SELECT AdditionalQuestion FROM dbo.tb_course WHERE courseID = @CourseID)

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseAttachment]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_getCourseAttachment]
(@FileName VARCHAR(50), @base64Content VARCHAR(MAX) OUTPUT)
AS
SET NOCOUNT ON;

SELECT @base64Content = [base64Content] FROM [dbo].[tb_course_attachment] WHERE [FileName] = @FileName;

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseIndividualAttendanceReport]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseIndividualAttendanceReport]
(@FromYear VARCHAR(4), @NumberOfCourse INT, @Church VARCHAR(1), @NRIC VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @CurentParish INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish')
DECLARE @OtherChurchID INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'OtherChurchParish')
DECLARE @AttendedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));
DECLARE @CompletedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));

DECLARE @attendanceTable table (NRIC VARCHAR(20), CourseID INT, CourseName VARCHAR(100));

INSERT INTO @attendanceTable
SELECT NRIC, A.courseID, B.CourseName FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
GROUP BY NRIC, A.courseID, B.CourseName;

INSERT INTO @AttendedTable
SELECT 
  NRIC, COUNT(1),
  STUFF((
    SELECT CourseName + '||'
    FROM @attendanceTable 
    WHERE (NRIC = Results.NRIC) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,0,'') AS NameValues
FROM @attendanceTable AS Results
WHERE courseID IN (
		SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
		CROSS APPLY(
			SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
		) AS A
		WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
	)
GROUP BY NRIC;

DECLARE @CompletedattendanceTable table (NRIC VARCHAR(20), CourseID INT, Attended INT);

INSERT INTO @CompletedattendanceTable
SELECT A.NRIC, A.CourseID, COUNT(1) FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
GROUP BY A.NRIC, A.CourseID;

DELETE FROM @attendanceTable;
INSERT INTO @attendanceTable
SELECT NRIC, A.courseID, B.CourseName FROM @CompletedattendanceTable AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE A.Attended >= B.MinCompleteAttendance;

INSERT INTO @CompletedTable
SELECT 
  NRIC, COUNT(1),
  STUFF((
    SELECT CourseName + '||'
    FROM @attendanceTable 
    WHERE (NRIC = Results.NRIC) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,0,'') AS NameValues
FROM @attendanceTable Results
WHERE courseID IN (
		SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
		CROSS APPLY(
			SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
		) AS A
		WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
	)
GROUP BY NRIC;

IF(LEN(@NRIC) > 0)
BEGIN
	DELETE FROM @AttendedTable WHERE NRIC <> @NRIC;
	DELETE FROM @CompletedTable WHERE NRIC <> @NRIC;
END

ELSE IF(@Church = 'C')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @CurentParish OR G.ParishID <> @CurentParish;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @CurentParish OR G.ParishID <> @CurentParish;
END
ELSE IF(@Church = 'A')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @CurentParish OR G.ParishID = @CurentParish OR F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @CurentParish OR G.ParishID = @CurentParish OR F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
END
ELSE IF(@Church = 'B')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
END
ELSE IF(@Church = 'O')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @OtherChurchID OR G.ParishID <> @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @OtherChurchID OR G.ParishID <> @OtherChurchID;
END

SELECT ISNULL(C.NRIC,'') AS Member, ISNULL(D.NRIC,'') AS TempMember, ISNULL(E.NRIC,'') AS Visitor, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, ISNULL(A.NRIC, B.NRIC) AS NRIC, ISNULL(B.NumberOfCourse, 0) AS CompletedNumberOfCourse, ISNULL(B.CourseName, '') AS CompletedCourseName
	   ,A.NumberOfCourse AS AttendedNumberOfCourse, A.CourseName AS AttendedCourseName, ISNULL(G.ParishName, F.ParishName) AS ChurchName, ISNULL(E.ChurchOthers,'') AS OtherChurchName,
	   ISNULL((CASE WHEN(ISNULL(ISNULL(E.Church, C.CurrentParish), D.CurrentParish) = @CurentParish) THEN (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @CurentParish) 
			 WHEN(ISNULL(ISNULL(E.Church, C.CurrentParish), D.CurrentParish) = @OtherChurchID) THEN 'Others' 
			 ELSE 'Anglican 'END), '')  AS Parish
FROM @CompletedTable AS B
LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
WHERE B.NumberOfCourse >= @NumberOfCourse;

SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
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

SELECT MinCompleteAttendance, LastRegistrationDate, AdditionalQuestion, Fee, CourseDay, courseID, 
       CourseName, CourseStartDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, 
       dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name, A.CourseInCharge, Speaker, SendReminder, ReminderSent
FROM dbo.tb_course AS A
LEFT OUTER JOIN dbo.tb_members AS B on A.CourseInCharge = B.NRIC
LEFT OUTER JOIN dbo.tb_Users AS C on A.CourseInCharge = C.NRIC
LEFT OUTER JOIN dbo.tb_style AS D ON C.Style = D.styleID
LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
WHERE courseID = @courseid

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseParticipantInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
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

SELECT @xml AS Attendance, AdditionalInformation, A.NRIC, ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName) AS EnglishName, courseID, feePaid, materialReceived FROM dbo.tb_course_participant AS A
  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
  WHERE A.courseID = @courseid AND A.NRIC = @nric;


SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseRegistrationStat]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseRegistrationStat]
(@FromYear VARCHAR(4), @FromMonth VARCHAR(100))
AS
SET NOCOUNT ON;

SELECT B.CourseName, COUNT(NRIC) AS Registered  FROM  [dbo].[tb_course] AS B
LEFT OUTER JOIN [dbo].[tb_course_participant] AS A ON A.courseID = B.courseID
WHERE B.courseID IN (
	SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
	CROSS APPLY(
		SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
	) AS A
	WHERE (Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear OR Year([dbo].[udf_getEndDate]([CourseStartDate])) = @FromYear)
	AND Month(A.CourseDate) IN (SELECT items FROM [dbo].[udf_Split](@FromMonth, ','))
)
GROUP BY B.courseID, B.CourseName
ORDER BY B.CourseName

SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseReport]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseReport]
(@courseID INT, @TotalDay INT OUT, @MinAttendance INT OUT, @XML XML OUT, @AttendedAtLeastOnce INT OUT, @AllCompletedCourse INT OUT, @SACCompletedCourse INT OUT, @NonSACCompletedCourse INT OUT, @AnglicanCompletedCourse INT OUT, @NonAnglicanCompletedCourse INT OUT)
AS
SET NOCOUNT ON;

	DECLARE @Table TABLE (NRIC VARCHAR(20), Schedule DATE)
    SET @MinAttendance = (SELECT [MinCompleteAttendance] FROM [dbo].[tb_course] WHERE courseID = @courseID);
	DECLARE @ParishID INT = (SELECT [value] FROM [dbo].[tb_App_Config] WHERE ConfigName = 'currentparish');

	SELECT @TotalDay = COUNT(1) FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',');

	INSERT INTO @Table (NRIC, Schedule)
	SELECT B.Nric, CONVERT(DATETIME, A.ITEMS, 103) 
	FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',') AS A, [dbo].[tb_course_participant] AS B
	WHERE B.courseID = @courseID


	SELECT A.NRIC, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, 
                 ISNULL(ISNULL(C.Gender, D.Gender), E.Gender) AS Gender,
				 ISNULL(F.ParishName, '') AS Church,
				 ISNULL(C.ChurchOthers, '') AS ChurchOthersName,
				 ISNULL(ISNULL(I.CongregationName, J.CongregationName), '') AS Congregation,
				 ISNULL(ISNULL(ISNULL(ISNULL(C.Contact, D.MobileTel), D.HomeTel), E.MobileTel), E.HomeTel) AS Contact,
				 ISNULL(ISNULL(C.Email, D.Email), E.Email) AS Email, 
	A.Schedule, ISNULL(DATEDIFF(DAY, A.Schedule, B.Date), 1) AS Attendance FROM @Table AS A
	LEFT OUTER JOIN [dbo].[tb_course_Attendance] AS B ON B.Date = A.Schedule AND B.CourseID = @courseID AND A.NRIC = B.NRIC
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = ISNULL(ISNULL(C.Church, D.CurrentParish), E.CurrentParish)
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo] AS G ON G.NRIC = D.NRIC
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo_temp] AS H ON H.NRIC = E.NRIC
	LEFT OUTER JOIN [dbo].[tb_congregation] AS I ON I.CongregationID = G.Congregation
	LEFT OUTER JOIN [dbo].[tb_congregation] AS J ON J.CongregationID = H.Congregation
	Order by A.NRIC, A.Schedule ASC

	SET @AttendedAtLeastOnce = (SELECT COUNT(DISTINCT NRIC) AS Attended FROM [dbo].[tb_course_Attendance] WHERE CourseID = @courseID);

	DECLARE @CompletedCourse TABLE(NRIC VARCHAR(20), Attended INT)

	INSERT INTO @CompletedCourse
	SELECT[NRIC] AS Attended, COUNT(1) FROM [dbo].[tb_course_Attendance]
	WHERE CourseID = @courseID	
	GROUP BY NRIC;

	SET @AllCompletedCourse = (SELECT COUNT(1) FROM @CompletedCourse WHERE Attended >= @MinAttendance);

	SET @SACCompletedCourse = (SELECT COUNT(1)
					 FROM @CompletedCourse AS A
		LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
		WHERE ISNULL(F.ParishID, @ParishID) = @ParishID
		AND Attended >= @MinAttendance);


	SET @NonSACCompletedCourse = (SELECT COUNT(1)
					 FROM @CompletedCourse AS A
		LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
		WHERE ISNULL(F.ParishID, @ParishID) <> @ParishID
		AND Attended >= @MinAttendance);

	SET @AnglicanCompletedCourse = (SELECT COUNT(1)
			     FROM @CompletedCourse AS A
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
	WHERE ISNULL(F.ParishID, @ParishID) <> 28
	AND Attended >= @MinAttendance);

	SET @NonAnglicanCompletedCourse = (SELECT COUNT(1)
			     FROM @CompletedCourse AS A
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
	WHERE ISNULL(F.ParishID, @ParishID) = 28
	AND Attended >= @MinAttendance);

	DECLARE @CountAttendanceTable TABLE(MyDate DATE, Attended INT);
	INSERT INTO @CountAttendanceTable
	SELECT [Date], Count(1) AS Attendance FROM [dbo].[tb_course_Attendance] WHERE CourseID = @courseID
	GROUP BY [Date]

	SET @XML = (SELECT CONVERT(DATE, A.items, 103) AS [Date], ISNULL(B.Attended,0) As DailyTotal FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',') AS A
	LEFT OUTER JOIN @CountAttendanceTable AS B ON CONVERT(DATE, A.items, 103) = B.MyDate
	Order By CONVERT(DATE, A.items, 103) FOR XML PATH('Attendance'), ROOT('DailyAttendance'));	

SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [dbo].[usp_getCourseURL]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getCourseURL]
(@CourseID INT, @CourseURL VARCHAR(2000) OUT)
AS
SET NOCOUNT ON;

	SELECT @CourseURL = [URLLink] FROM [dbo].[tb_course] WHERE courseID = @CourseID

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_getDBBackup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getHWSMemberAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getHWSMemberAttendance]
(@Date DATE)
AS
SET NOCOUNT ON;

  SELECT A.[ID]
      ,[EnglishSurname]
      ,[EnglishGivenName]
      ,[ChineseSurname]
      ,[ChineseGivenName]
      ,[Birthday]
      ,[Contact]
      ,[AddressHouseBlock]
      ,[AddressStreet]
      ,[AddressUnit]
      ,[AddressPostalCode]
      ,[Photo]
      ,[NextOfKinName]
      ,[NextOfKinContact]
      ,[Remarks]
  FROM [dbo].[tb_HokkienAttendance] AS A
  INNER JOIN [dbo].[tb_HokkienMember] AS B ON A.ID = B.ID
  where [AttendanceDate] = @Date

	

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_getHWSMemberInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getHWSMemberInformation]
(@ID INT)
AS
SET NOCOUNT ON;

SELECT [ID]
      ,[EnglishSurname]
      ,[EnglishGivenName]
      ,[ChineseSurname]
      ,[ChineseGivenName]
      ,CONVERT(VARCHAR(10), [Birthday], 103) AS DOB
      ,[Contact]
      ,[AddressHouseBlock]
      ,[AddressStreet]
      ,[AddressUnit]
      ,[AddressPostalCode]
      ,[Photo]
      ,[NextOfKinName]
      ,[NextOfKinContact]
      ,[Remarks]
  FROM [DOS].[dbo].[tb_HokkienMember] WHERE ID = @ID;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getListofCellgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getListofCourse]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getListofCourse]
(@public bit, @Year INT = null)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

IF(@public = 1)
BEGIN
	SELECT courseID, CourseName, REPLACE(CourseStartDate, ',', ', ')AS CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name FROM dbo.tb_course AS A
	LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
	WHERE dbo.udf_isCourseStillRunning(CourseStartDate, @today) = 1 AND A.Deleted = 0 AND @today <= LastRegistrationDate
	ORDER BY CourseName ASC;
END
ELSE IF(ISNULL(@Year, -1) > -1)
BEGIN
	SELECT courseID, CourseName, REPLACE(CourseStartDate, ',', ', ')AS CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name FROM dbo.tb_course AS A
	LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
	WHERE dbo.udf_isCourseConductedInYear(CourseStartDate, @Year) = 1 AND A.Deleted = 0
	ORDER BY CourseName ASC
END
ELSE
BEGIN
	SELECT courseID, CourseName, REPLACE(CourseStartDate, ',', ', ')AS CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name FROM dbo.tb_course AS A
	LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
	WHERE dbo.udf_isCourseStillRunning(CourseStartDate, DATEADD(day, -365, @today)) = 1
	ORDER BY CourseName ASC
END

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_getListofCourseParticipants]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getListofMinistry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getListOfTempMembersForApproval]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getListOfTempMembersForApproval]

AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality,
		dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel,
		AddressHouseBlk, AddressPostalCode, AddressStreet, AddressUnit, E.CongregationName, F.OccupationName
	FROM dbo.tb_members_temp AS A
	LEFT OUTER JOIN [dbo].[tb_occupation] AS F ON F.OccupationID = A.Occupation
	INNER JOIN tb_membersOtherInfo_temp AS D ON D.NRIC = A.NRIC
	INNER JOIN [dbo].[tb_congregation] AS E ON E.CongregationID = D.Congregation
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE CurrentParish = @CurrentParish
	ORDER BY Name, A.NRIC

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_getMemberInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getMemberInformation]
(@NRIC VARCHAR(20), @Type VARCHAR(10))
AS
SET NOCOUNT ON;

DECLARE @tNRIC VARCHAR(20) = @NRIC, @tType VARCHAR(10) = @Type;

IF(@tType = 'Actual')
BEGIN
	SELECT ReceiveMailingList, [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
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
	SELECT ReceiveMailingList, [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
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
/****** Object:  StoredProcedure [dbo].[usp_getMemberInformationPrinting]    Script Date: 5/7/2016 6:44:01 AM ******/
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
			A.CreatedDate, 
			ISNULL(CONVERT(XML, (SELECT  
				   ISNULL(A.FamilyType, '') AS FamilyType,  
				   Tbl.Col.value('FamilyEnglishName[1]', 'VARCHAR(50)') AS FamilyEnglishName,  
				   Tbl.Col.value('FamilyChineseName[1]', 'NVARCHAR(50)') AS FamilyChineseName,
				   ISNULL(B.OccupationName,'') AS FamilyOccupation,
				   ISNULL(C.ReligionName, '') AS  FamilyReligion
			FROM   A.Family.nodes('//FamilyList/*') Tbl(Col)
			LEFT OUTER JOIN [dbo].[tb_familytype] AS A ON A.FamilyTypeID = Tbl.Col.value('FamilyType[1]', 'tinyint')
			LEFT OUTER JOIN [dbo].[tb_occupation] AS B ON B.OccupationID = Tbl.Col.value('FamilyOccupation[1]', 'int')
			LEFT OUTER JOIN [dbo].[tb_religion] AS C ON C.ReligionID = Tbl.Col.value('FamilyReligion[1]', 'tinyint')
			FOR XML PATH('Family'), ROOT('FamilyList'))),'<FamilyList />') AS Family,
			ISNULL(CONVERT(XML, (SELECT  
				   Tbl.Col.value('ChildEnglishName[1]', 'VARCHAR(50)') AS ChildEnglishName,  
				   Tbl.Col.value('ChildChineseName[1]', 'NVARCHAR(50)') AS ChildChineseName,
				   Tbl.Col.value('ChildBaptismDate[1]', 'NVARCHAR(100)') AS ChildBaptismDate,
				   Tbl.Col.value('ChildBaptismBy[1]', 'NVARCHAR(100)') AS ChildBaptismBy,
				   ISNULL(A.ParishName,'') AS ChildChurch
			FROM   A.Child.nodes('//ChildList/*') Tbl(Col)
			LEFT OUTER JOIN [dbo].[tb_parish] AS A ON A.ParishID = Tbl.Col.value('ChildChurch[1]', 'int')
			FOR XML PATH('Child'), ROOT('ChildList'))),'<ChildList />') AS Child,
			
			B.ElectoralRoll AS ElectoralRoll, B.MemberDate, A.TransferReason, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers, 
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

--[dbo].[usp_getMemberInformationPrinting] 'S8111010G'


GO
/****** Object:  StoredProcedure [dbo].[usp_getMembersReporting]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getMembersReportingManualSearch]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getMembersTempReportingManualSearch]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getMinistryInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getModuleFunctionsAccessRight]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getPeriodicAttendanceReport]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getPeriodicAttendanceReport]
(@FromYear VARCHAR(4), @ToYear VARCHAR(4), @FromMonth VARCHAR(2), @ToMonth VARCHAR(2))
AS
SET NOCOUNT ON;

DECLARE @StartDate DATE = CONVERT(DATE, '1/' + @FromMonth + '/' + @FromYear, 103);
DECLARE @dtDate VARCHAR(10) = @ToMonth +'/1/' + @ToYear;
DECLARE @EndDate DATE = CONVERT(DATE, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dtDate)+1,0)));
DECLARE @CourseMainTable TABLE(MinCompleteAttendance INT, courseID INT, NumberOfDays INT);
DECLARE @AttendanceMainTable TABLE(courseID INT, NRIC VARCHAR(20), Attendance INT);
DECLARE @AttendanceAttended TABLE(CourseID INT, NumberOfAttendee INT);
DECLARE @AttendanceCompleted TABLE(CourseID INT, NumberOfAttendee INT);

INSERT INTO @CourseMainTable
SELECT [MinCompleteAttendance], courseID, (SELECT COUNT(1) FROM dbo.udf_Split([CourseStartDate], ',')) NumberOfDays FROM [dbo].[tb_course]
WHERE [dbo].[udf_getStartDate]([CourseStartDate]) >= @StartDate 
AND [dbo].[udf_getStartDate]([CourseStartDate]) <= @EndDate
AND [dbo].[udf_getEndDate]([CourseStartDate]) >= @StartDate
AND [dbo].[udf_getEndDate]([CourseStartDate]) <= @EndDate;
  
INSERT INTO @AttendanceMainTable
SELECT A.CourseID, A.NRIC, COUNT(1) AS Attendance FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN @CourseMainTable AS B ON B.CourseID = A.courseID
GROUP BY A.CourseID, A.NRIC ORDER BY A.CourseID

INSERT INTO @AttendanceAttended
SELECT A.CourseID, COUNT(1) FROM @AttendanceMainTable AS A
INNER JOIN @CourseMainTable AS B ON A.courseID = B.courseID
GROUP BY A.CourseID;

INSERT INTO @AttendanceCompleted
SELECT  A.CourseID, COUNT(1) FROM @AttendanceMainTable AS A
INNER JOIN @CourseMainTable AS B ON A.courseID = B.courseID
WHERE Attendance >= MinCompleteAttendance
GROUP BY A.CourseID;

SELECT D.CourseID, (C.CourseName) AS CourseName, ISNULL(A.NumberOfAttendee,0) AS AttendanceCompleted, ISNULL(B.NumberOfAttendee,0) AS AttendanceAttended 
FROM @CourseMainTable AS D
LEFT OUTER JOIN @AttendanceCompleted AS A on D.courseID = A.CourseID
LEFT OUTER JOIN @AttendanceAttended AS B ON D.CourseID = B.CourseID
INNER JOIN [dbo].[tb_course] AS C ON D.CourseID = C.courseID
Order By LEN(C.CourseName) ASC

SET NOCOUNT OFF;

GO
/****** Object:  StoredProcedure [dbo].[usp_getPredcessor]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getRecordForSync]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getRecordForSync]

AS
SET NOCOUNT ON;

UPDATE dbo.tb_course_participant SET MarkSync = 1
UPDATE dbo.tb_members_temp SET MarkSync = 1

DECLARE @XML XML = (SELECT
	CONVERT(XML, (SELECT CourseID, CONVERT(VARCHAR(22), RegistrationDate,103) AS RegistrationDate, 'Unspecified' AS EnteredBy, B.NRIC AS OriginalNRIC, B.NRIC AS NRIC, B.Salutation, EnglishName, Gender, CONVERT(VARCHAR(10), DOB, 103) AS DOB,
		   Congregation, Nationality, AddressStreet AS AddressStreetName, AddressPostalCode, AddressHouseBlk AS AddressBlkHouse,
		   AddressUnit, Contact, Email, Education, Occupation, Church, ChurchOthers, AdditionalInformation, ReceiveMailingList AS mailingList
	FROM dbo.tb_course_participant AS A
	INNER JOIN dbo.tb_visitors AS B ON A.NRIC = B.NRIC WHERE MarkSync = 1
	FOR XML PATH('Update'))) AS AllVisitors,
	
	CONVERT(XML, (SELECT ISNULL(C.CourseID, '-1') AS CourseID, ISNULL(feePaid,0) AS feePaid, ISNULL(materialReceived,0) AS materialReceived,
	       CONVERT(VARCHAR(10), ISNULL(RegistrationDate, ''), 103) AS RegistrationDate, ISNULL(AdditionalInformation, '<empty />') AS AdditionalInformation, 
	      'Unspecified' AS EnteredBy, A.NRIC, Salutation, EnglishName, ChineseName, Gender, CONVERT(VARCHAR(10), DOB, 103) AS DOB,
		   MaritalStatus, CONVERT(VARCHAR(10), MarriageDate, 103) AS MarriageDate, Nationality, Dialect, ICPhoto AS Photo,
		   AddressStreet AS AddressStreetName, AddressPostalCode, AddressHouseBlk AS AddressBlkHouse, AddressUnit, HomeTel, MobileTel,
		   Email, Education, [Language], Occupation, Congregation, BaptismBy, BaptismChurch, CONVERT(VARCHAR(10), BaptismDate, 103) AS BaptismDate,
		   ConfirmBy AS ConfirmationBy, ConfirmChurch AS ConfirmationChurch, CONVERT(VARCHAR(10), ConfirmDate, 103) AS ConfirmationDate,
		   PreviousChurch AS PreviousChurchMembership, TransferReason, CONVERT(XML, Family), CONVERT(XML, Child), ServeCongregationInterested AS InterestedServeCongregation,
		   CellgroupInterested AS InterestedCellgroup, TithingInterested AS InterestedTithing, CONVERT(XML, MinistryInterested),
		   Sponsor1, Sponsor2, Sponsor2Contact, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers, ReceiveMailingList AS mailingList
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC 
	LEFT OUTER JOIN dbo.tb_course_participant AS C ON C.NRIC = A.NRIC WHERE A.MarkSync = 1
	FOR XML PATH('New'))) AS AllMembers
FOR XML PATH('SyncData'))

SELECT @XML AS SyncData

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_getStaffName]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getUserInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getUsersInRole]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_getVisitorInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getVisitorInformation]
(@NRIC VARCHAR(20))
AS
SET NOCOUNT ON;


	SELECT ISNULL(CONVERT(VARCHAR(2), Congregation), '') AS Congregation, ReceiveMailingList AS mailingList, [EnglishName], CONVERT(VARCHAR(5), [Salutation]) AS Salutation
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
/****** Object:  StoredProcedure [dbo].[usp_insertlogging]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_insertloggingNoReturn]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_insertloggingNoReturn] 
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
	SET NOCOUNT ON;
END




GO
/****** Object:  StoredProcedure [dbo].[usp_listOfRoles]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_ManualUpdateAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeAttachment]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeCellgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeCourse]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeCourseParticipant]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeHWSMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_removeHWSMember]
(@ID INT)
AS
SET NOCOUNT ON;

DELETE FROM [dbo].[tb_HokkienMember] WHERE ID = @ID

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_removeMember]    Script Date: 5/7/2016 6:44:01 AM ******/
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

DELETE FROM [dbo].[tb_DOSLogging] WHERE [Reference] = @NRIC;

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_removeMinistry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_removeUser]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	UPDATE dbo.tb_Users SET Deleted = 1 WHERE UserID = @USERID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_resetUserPassword]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_searchCityKidsForUpdate]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%' OR A.Name LIKE '%'+@Name+'%'	
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@NRIC) > 0 AND LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@NRIC) = 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.Name LIKE '%'+@Name+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0 AND LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup) AND A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	ORDER BY Name, NRIC
END


SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_searchMembersForUpdate]    Script Date: 5/7/2016 6:44:01 AM ******/
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
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE (A.NRIC LIKE '%'+@NRIC+'%' OR dbo.udf_SearchName(@Name, EnglishName) = 1)
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE dbo.udf_SearchName(@Name, EnglishName) = 1
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name
END

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_searchName]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_searchName]
(@searchText VARCHAR(100))
 
AS
SET NOCOUNT ON;

SET @searchText = LTRIM(RTRIM(@searchText));

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

SELECT (select TOP 100 ISNULL(B.ICPhoto,'') AS ICPhoto, ISNULL(Name, B.EnglishName) AS Name, ISNULL(B.NRIC, A.NRIC) AS NRIC, ISNULL(ISNULL(A.Email, B.Email),' ') AS Email from dbo.tb_Users AS A
Full JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
WHERE (dbo.udf_SearchName(@searchText, B.EnglishName) = 1 OR dbo.udf_SearchName(@searchText, A.Name) = 1)
ORDER BY ISNULL(Name,B.EnglishName) ASC
FOR XML PATH('found'), Elements, Root('Root')) AS Result


SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_searchTempMembers]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_searchVisitorsForUpdate]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
DECLARE @Course TABLE (
	courseID [int] NOT NULL,
	CourseName [varchar](100) NOT NULL,
	CourseStartDate [varchar](2000) NOT NULL,
	CourseStartTime [time](7) NOT NULL,
	CourseEndTime [time](7) NOT NULL,
	CourseInCharge [varchar](20) NOT NULL,
	CourseLocation [tinyint] NOT NULL,
	Deleted [bit] NOT NULL,
	Fee [decimal](5, 2) NOT NULL)


--
-- Course
--
INSERT INTO @Course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT T2.Loc.value('./courseID[1]','int')
	   ,T2.Loc.value('./CourseName[1]','VARCHAR(100)')
	   ,T2.Loc.value('./CourseStartDate[1]','VARCHAR(2000)')
	   ,T2.Loc.value('./CourseStartTime[1]','TIME')
	   ,T2.Loc.value('./CourseEndTime[1]','TIME')
	   ,T2.Loc.value('./CourseInCharge[1]','VARCHAR(20)')
	   ,T2.Loc.value('./CourseLocation[1]','tinyint')
	   ,T2.Loc.value('./Deleted[1]','BIT')
	   ,T2.Loc.value('./Fee[1]','DECIMAL(5, 2)')
FROM @XML.nodes('/All/AllCourse/*') as T2(Loc)

UPDATE dbo.tb_course SET dbo.tb_course.CourseName = A.CourseName
						 ,dbo.tb_course.CourseStartDate = A.CourseStartDate
						 ,dbo.tb_course.CourseStartTime = A.CourseStartTime
						 ,dbo.tb_course.CourseEndTime = A.CourseEndTime
						 ,dbo.tb_course.CourseInCharge = A.CourseInCharge
						 ,dbo.tb_course.CourseLocation = A.CourseLocation
						 ,dbo.tb_course.Deleted = A.Deleted
						 ,dbo.tb_course.Fee = A.Fee
FROM @Course AS A WHERE dbo.tb_course.courseID = A.courseID		

SET IDENTITY_INSERT dbo.tb_course ON

INSERT INTO dbo.tb_course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee
FROM @Course WHERE courseID NOT IN (SELECT courseID FROM dbo.tb_course)

IF EXISTS(SELECT 1 FROM @Course)
DELETE FROM dbo.tb_course WHERE courseID NOT IN (SELECT courseID FROM @Course);

SET IDENTITY_INSERT dbo.tb_course OFF				
--
-- School
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SchoolID[1]','int'), T2.Loc.value('./SchoolName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSchool/*') as T2(Loc)

UPDATE dbo.tb_school SET dbo.tb_school.SchoolName = A.Value1
FROM @Table AS A WHERE dbo.tb_school.SchoolID = A.ID

SET IDENTITY_INSERT dbo.tb_school ON

INSERT INTO dbo.tb_school(SchoolID, SchoolName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SchoolID FROM dbo.tb_school)

SET IDENTITY_INSERT dbo.tb_school OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_school WHERE SchoolID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Religion
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ReligionID[1]','int'), T2.Loc.value('./ReligionName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllReligion/*') as T2(Loc)

UPDATE dbo.tb_religion SET dbo.tb_religion.ReligionName = A.Value1
FROM @Table AS A WHERE dbo.tb_religion.ReligionID = A.ID

SET IDENTITY_INSERT dbo.tb_religion ON

INSERT INTO dbo.tb_religion(ReligionID, ReligionName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ReligionID FROM dbo.tb_religion)

SET IDENTITY_INSERT dbo.tb_religion OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_religion WHERE ReligionID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Race
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./RaceID[1]','int'), T2.Loc.value('./RaceName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllRace/*') as T2(Loc)

UPDATE dbo.tb_race SET dbo.tb_race.RaceName = A.Value1
FROM @Table AS A WHERE dbo.tb_race.RaceID = A.ID

SET IDENTITY_INSERT dbo.tb_race ON

INSERT INTO dbo.tb_race(RaceID, RaceName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT RaceID FROM dbo.tb_race)

SET IDENTITY_INSERT dbo.tb_race OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_race WHERE RaceID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- ClubGroup
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ClubGroupID[1]','int'), T2.Loc.value('./ClubGroupName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllClubGroup/*') as T2(Loc)

UPDATE dbo.tb_clubgroup SET dbo.tb_clubgroup.ClubGroupName = A.Value1
FROM @Table AS A WHERE dbo.tb_clubgroup.ClubGroupID = A.ID

SET IDENTITY_INSERT dbo.tb_clubgroup ON

INSERT INTO dbo.tb_clubgroup(ClubGroupID, ClubGroupName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ClubGroupID FROM dbo.tb_clubgroup)

SET IDENTITY_INSERT dbo.tb_clubgroup OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_clubgroup WHERE ClubGroupID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table


--
-- BusGroupCluster
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./BusGroupClusterID[1]','int'), T2.Loc.value('./BusGroupClusterName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllBusGroupCluster/*') as T2(Loc)

UPDATE dbo.tb_busgroup_cluster SET dbo.tb_busgroup_cluster.BusGroupClusterName = A.Value1
FROM @Table AS A WHERE dbo.tb_busgroup_cluster.BusGroupClusterID = A.ID

SET IDENTITY_INSERT dbo.tb_busgroup_cluster ON

INSERT INTO dbo.tb_busgroup_cluster(BusGroupClusterID, BusGroupClusterName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT BusGroupClusterID FROM dbo.tb_busgroup_cluster)

SET IDENTITY_INSERT dbo.tb_busgroup_cluster OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table


--
-- PostalArea
--
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./District[1]','int'), T2.Loc.value('./PostalAreaName[1]','VARCHAR(1000)'), T2.Loc.value('./PostalDigit[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllPostalArea/*') as T2(Loc)

UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.Value1, dbo.tb_postalArea.PostalDigit = A.Value2
FROM @Table AS A WHERE dbo.tb_postalArea.District = A.ID

SET IDENTITY_INSERT dbo.tb_postalArea ON

INSERT INTO dbo.tb_postalArea(District, PostalAreaName, PostalDigit)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT District FROM dbo.tb_postalArea)

SET IDENTITY_INSERT dbo.tb_postalArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Style
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./StyleID[1]','int'), T2.Loc.value('./StyleName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllStyle/*') as T2(Loc)

UPDATE dbo.tb_style SET dbo.tb_style.StyleName = A.Value1
FROM @Table AS A WHERE dbo.tb_style.StyleID = A.ID

SET IDENTITY_INSERT dbo.tb_style ON

INSERT INTO dbo.tb_style(StyleID, StyleName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT StyleID FROM dbo.tb_style)

SET IDENTITY_INSERT dbo.tb_style OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_style WHERE StyleID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Salutation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SalutationID[1]','int'), T2.Loc.value('./SalutationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSalutation/*') as T2(Loc)

UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = A.Value1
FROM @Table AS A WHERE dbo.tb_Salutation.SalutationID = A.ID

SET IDENTITY_INSERT dbo.tb_Salutation ON

INSERT INTO dbo.tb_Salutation(SalutationID, SalutationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SalutationID FROM dbo.tb_Salutation)

SET IDENTITY_INSERT dbo.tb_Salutation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_Salutation WHERE SalutationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Parish
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ParishID[1]','int'), T2.Loc.value('./ParishName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllParish/*') as T2(Loc)

UPDATE dbo.tb_parish SET dbo.tb_parish.ParishName = A.Value1
FROM @Table AS A WHERE dbo.tb_parish.ParishID = A.ID

SET IDENTITY_INSERT dbo.tb_parish ON

INSERT INTO dbo.tb_parish(ParishID, ParishName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ParishID FROM dbo.tb_parish)

SET IDENTITY_INSERT dbo.tb_parish OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_parish WHERE ParishID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Occupation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./OccupationID[1]','int'), T2.Loc.value('./OccupationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllOccupation/*') as T2(Loc)

UPDATE dbo.tb_occupation SET dbo.tb_occupation.OccupationName = A.Value1
FROM @Table AS A WHERE dbo.tb_occupation.OccupationID = A.ID

SET IDENTITY_INSERT dbo.tb_occupation ON

INSERT INTO dbo.tb_occupation(OccupationID, OccupationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT OccupationID FROM dbo.tb_occupation)

SET IDENTITY_INSERT dbo.tb_occupation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_occupation WHERE OccupationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- MaritalStatus
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./MaritalStatusID[1]','int'), T2.Loc.value('./MaritalStatusName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllMaritalStatus/*') as T2(Loc)

UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = A.Value1
FROM @Table AS A WHERE dbo.tb_maritalstatus.MaritalStatusID = A.ID

SET IDENTITY_INSERT dbo.tb_maritalstatus ON

INSERT INTO dbo.tb_maritalstatus(MaritalStatusID, MaritalStatusName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT MaritalStatusID FROM dbo.tb_maritalstatus)

SET IDENTITY_INSERT dbo.tb_maritalstatus OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_maritalstatus WHERE MaritalStatusID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Language
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./LanguageID[1]','int'), T2.Loc.value('./LanguageName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllLanguage/*') as T2(Loc)

UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = A.Value1
FROM @Table AS A WHERE dbo.tb_language.LanguageID = A.ID

SET IDENTITY_INSERT dbo.tb_language ON

INSERT INTO dbo.tb_language(LanguageID, LanguageName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT LanguageID FROM dbo.tb_language)

SET IDENTITY_INSERT dbo.tb_language OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_language WHERE LanguageID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- FamilyType
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FamilyTypeID[1]','int'), T2.Loc.value('./FamilyTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFamilyType/*') as T2(Loc)

UPDATE dbo.tb_familytype SET dbo.tb_familytype.FamilyType = A.Value1
FROM @Table AS A WHERE dbo.tb_familytype.FamilyTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_familytype ON

INSERT INTO dbo.tb_familytype(FamilyTypeID, FamilyType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FamilyTypeID FROM dbo.tb_familytype)

SET IDENTITY_INSERT dbo.tb_familytype OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_familytype WHERE FamilyTypeID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- FileType
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FileTypeID[1]','int'), T2.Loc.value('./FileTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFileType/*') as T2(Loc)

UPDATE dbo.tb_file_type SET dbo.tb_file_type.FileType = A.Value1
FROM @Table AS A WHERE dbo.tb_file_type.FileTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_file_type ON

INSERT INTO dbo.tb_file_type(FileTypeID, FileType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FileTypeID FROM dbo.tb_file_type)

SET IDENTITY_INSERT dbo.tb_file_type OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_file_type WHERE FileTypeID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Church Area
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./AreaID[1]','int'), T2.Loc.value('./AreaName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllChurchArea/*') as T2(Loc)

UPDATE dbo.tb_churchArea SET dbo.tb_churchArea.AreaName = A.Value1
FROM @Table AS A WHERE dbo.tb_churchArea.AreaID = A.ID

SET IDENTITY_INSERT dbo.tb_churchArea ON

INSERT INTO dbo.tb_churchArea(AreaID, AreaName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT AreaID FROM dbo.tb_churchArea)

SET IDENTITY_INSERT dbo.tb_churchArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_churchArea WHERE AreaID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Congregation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CongregationID[1]','int'), T2.Loc.value('./CongregationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCongregation/*') as T2(Loc)

UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = A.Value1
FROM @Table AS A WHERE dbo.tb_congregation.CongregationID = A.ID

SET IDENTITY_INSERT dbo.tb_congregation ON

INSERT INTO dbo.tb_congregation(CongregationID, CongregationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CongregationID FROM dbo.tb_congregation)

SET IDENTITY_INSERT dbo.tb_congregation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Country
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CountryID[1]','int'), T2.Loc.value('./CountryName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCountry/*') as T2(Loc)

UPDATE dbo.tb_country SET dbo.tb_country.CountryName = A.Value1
FROM @Table AS A WHERE dbo.tb_country.CountryID = A.ID

SET IDENTITY_INSERT dbo.tb_country ON

INSERT INTO dbo.tb_country(CountryID, CountryName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CountryID FROM dbo.tb_country)

SET IDENTITY_INSERT dbo.tb_country OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_country WHERE CountryID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Dialect
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./DialectID[1]','int'), T2.Loc.value('./DialectName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllDialect/*') as T2(Loc)

UPDATE dbo.tb_dialect SET dbo.tb_dialect.DialectName = A.Value1
FROM @Table AS A WHERE dbo.tb_dialect.DialectID = A.ID

SET IDENTITY_INSERT dbo.tb_dialect ON

INSERT INTO dbo.tb_dialect(DialectID, DialectName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT DialectID FROM dbo.tb_dialect)

SET IDENTITY_INSERT dbo.tb_dialect OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_dialect WHERE DialectID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Education
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./EducationID[1]','int'), T2.Loc.value('./EducationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllEducation/*') as T2(Loc)

UPDATE dbo.tb_education SET dbo.tb_education.EducationName = A.Value1
FROM @Table AS A WHERE dbo.tb_education.EducationID = A.ID

SET IDENTITY_INSERT dbo.tb_education ON

INSERT INTO dbo.tb_education(EducationID, EducationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT EducationID FROM dbo.tb_education)

SET IDENTITY_INSERT dbo.tb_education OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_education WHERE EducationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_AdditionalInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_AdditionalInformation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(MAX))
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./AgreementID[1]','int'), T2.Loc.value('./AgreementType[1]','VARCHAR(1000)'), T2.Loc.value('./AgreementHTML[1]','VARCHAR(MAX)')
FROM @XML.nodes('/All/AllChurchAgreement/*') as T2(Loc)

UPDATE dbo.tb_course_agreement SET dbo.tb_course_agreement.AgreementType = A.Value1, dbo.tb_course_agreement.AgreementHTML = A.Value2
FROM @Table AS A WHERE dbo.tb_course_agreement.AgreementID = A.ID

SET IDENTITY_INSERT dbo.tb_course_agreement ON

INSERT INTO dbo.tb_course_agreement(AgreementID, AgreementType, AgreementHTML)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT AgreementID FROM dbo.tb_course_agreement)

SET IDENTITY_INSERT dbo.tb_course_agreement OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_course_agreement WHERE AgreementID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Area]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Area]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./AreaID[1]','int'), T2.Loc.value('./AreaName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllChurchArea/*') as T2(Loc)

UPDATE dbo.tb_churchArea SET dbo.tb_churchArea.AreaName = A.Value1
FROM @Table AS A WHERE dbo.tb_churchArea.AreaID = A.ID

SET IDENTITY_INSERT dbo.tb_churchArea ON

INSERT INTO dbo.tb_churchArea(AreaID, AreaName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT AreaID FROM dbo.tb_churchArea)

SET IDENTITY_INSERT dbo.tb_churchArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_churchArea WHERE AreaID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_BusGroupCluster]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_BusGroupCluster]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./BusGroupClusterID[1]','int'), T2.Loc.value('./BusGroupClusterName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllBusGroupCluster/*') as T2(Loc)

UPDATE dbo.tb_busgroup_cluster SET dbo.tb_busgroup_cluster.BusGroupClusterName = A.Value1
FROM @Table AS A WHERE dbo.tb_busgroup_cluster.BusGroupClusterID = A.ID

SET IDENTITY_INSERT dbo.tb_busgroup_cluster ON

INSERT INTO dbo.tb_busgroup_cluster(BusGroupClusterID, BusGroupClusterName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT BusGroupClusterID FROM dbo.tb_busgroup_cluster)

SET IDENTITY_INSERT dbo.tb_busgroup_cluster OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_ClubGroup]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_ClubGroup]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ClubGroupID[1]','int'), T2.Loc.value('./ClubGroupName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllClubGroup/*') as T2(Loc)

UPDATE dbo.tb_clubgroup SET dbo.tb_clubgroup.ClubGroupName = A.Value1
FROM @Table AS A WHERE dbo.tb_clubgroup.ClubGroupID = A.ID

SET IDENTITY_INSERT dbo.tb_clubgroup ON

INSERT INTO dbo.tb_clubgroup(ClubGroupID, ClubGroupName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ClubGroupID FROM dbo.tb_clubgroup)

SET IDENTITY_INSERT dbo.tb_clubgroup OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_clubgroup WHERE ClubGroupID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Congregation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Congregation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000), Deleted BIT)

INSERT INTO @Table(ID, Value1, Deleted)
SELECT T2.Loc.value('./CongregationID[1]','int'), T2.Loc.value('./CongregationName[1]','VARCHAR(1000)'), T2.Loc.value('./Deleted[1]','BIT')
FROM @XML.nodes('/All/AllCongregation/*') as T2(Loc)

UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = A.Value1, dbo.tb_congregation.Deleted = A.Deleted
FROM @Table AS A WHERE dbo.tb_congregation.CongregationID = A.ID

select * FROM @Table

SET IDENTITY_INSERT dbo.tb_congregation ON

INSERT INTO dbo.tb_congregation(CongregationID, CongregationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CongregationID FROM dbo.tb_congregation)

SET IDENTITY_INSERT dbo.tb_congregation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Country]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Country]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CountryID[1]','int'), T2.Loc.value('./CountryName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCountry/*') as T2(Loc)

UPDATE dbo.tb_country SET dbo.tb_country.CountryName = A.Value1
FROM @Table AS A WHERE dbo.tb_country.CountryID = A.ID

SET IDENTITY_INSERT dbo.tb_country ON

INSERT INTO dbo.tb_country(CountryID, CountryName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CountryID FROM dbo.tb_country)

SET IDENTITY_INSERT dbo.tb_country OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_country WHERE CountryID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Course]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Course]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Course TABLE (
	courseID [int] NOT NULL,
	CourseName [varchar](100) NOT NULL,
	CourseStartDate [varchar](2000) NOT NULL,
	CourseStartTime [time](7) NOT NULL,
	CourseEndTime [time](7) NOT NULL,
	CourseInCharge [varchar](20) NOT NULL,
	CourseLocation [tinyint] NOT NULL,
	Deleted [bit] NOT NULL,
	Fee [decimal](5, 2) NOT NULL,
	AdditionalQuestion INT NOT NULL,
	LastRegistrationDate DATE NOT NULL)

DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;

INSERT INTO @Course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee, AdditionalQuestion, LastRegistrationDate)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee, AdditionalQuestion, CONVERT(DATETIME, LastRegistrationDate, 103)
	FROM OPENXML(@idoc, '/All/AllCourse/*')
	WITH (
		courseID int'./courseID',
		CourseName VARCHAR(100)'./CourseName',
		CourseStartDate VARCHAR(2000)'./CourseStartDate',
		CourseStartTime TIME'./CourseStartTime',
		CourseEndTime TIME'./CourseEndTime',
		CourseInCharge VARCHAR(20)'./CourseInCharge',
		CourseLocation tinyint'./CourseLocation',
		Deleted BIT'./Deleted',
		Fee DECIMAL(5, 2)'./Fee',
		AdditionalQuestion INT './AdditionalQuestion',
		LastRegistrationDate VARCHAR(10) './LastRegistrationDate')

UPDATE dbo.tb_course SET dbo.tb_course.CourseName = A.CourseName
						 ,dbo.tb_course.CourseStartDate = A.CourseStartDate
						 ,dbo.tb_course.CourseStartTime = A.CourseStartTime
						 ,dbo.tb_course.CourseEndTime = A.CourseEndTime
						 ,dbo.tb_course.CourseInCharge = A.CourseInCharge
						 ,dbo.tb_course.CourseLocation = A.CourseLocation
						 ,dbo.tb_course.Deleted = A.Deleted
						 ,dbo.tb_course.Fee = A.Fee
						 ,dbo.tb_course.AdditionalQuestion = A.AdditionalQuestion
						 ,dbo.tb_course.LastRegistrationDate = A.LastRegistrationDate
FROM @Course AS A WHERE dbo.tb_course.courseID = A.courseID		

SET IDENTITY_INSERT dbo.tb_course ON

INSERT INTO dbo.tb_course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee, AdditionalQuestion, LastRegistrationDate)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee, AdditionalQuestion, LastRegistrationDate
FROM @Course WHERE courseID NOT IN (SELECT courseID FROM dbo.tb_course)

IF EXISTS(SELECT 1 FROM @Course)
DELETE FROM dbo.tb_course WHERE courseID NOT IN (SELECT courseID FROM @Course);

SET IDENTITY_INSERT dbo.tb_course OFF				

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_CourseAttachment]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_CourseAttachment]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE([FileName] VARCHAR(50), base64Content VARCHAR(MAX))

INSERT INTO @Table([FileName], base64Content)
SELECT T2.Loc.value('./FileName[1]','VARCHAR(50)'), T2.Loc.value('./base64Content[1]','VARCHAR(MAX)')
FROM @XML.nodes('/All/AllCourseAttachment/*') as T2(Loc)

UPDATE dbo.tb_course_attachment SET dbo.tb_course_attachment.base64Content = A.base64Content
FROM @Table AS A WHERE dbo.tb_course_attachment.[FileName] = A.[FileName]

INSERT INTO dbo.tb_course_attachment([FileName], base64Content)
SELECT [FileName], base64Content FROM @Table
WHERE [FileName] NOT IN (SELECT [FileName] FROM dbo.tb_course_attachment)

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_course_attachment WHERE [FileName] NOT IN (SELECT [FileName] FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Dialect]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Dialect]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./DialectID[1]','int'), T2.Loc.value('./DialectName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllDialect/*') as T2(Loc)

UPDATE dbo.tb_dialect SET dbo.tb_dialect.DialectName = A.Value1
FROM @Table AS A WHERE dbo.tb_dialect.DialectID = A.ID

SET IDENTITY_INSERT dbo.tb_dialect ON

INSERT INTO dbo.tb_dialect(DialectID, DialectName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT DialectID FROM dbo.tb_dialect)

SET IDENTITY_INSERT dbo.tb_dialect OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_dialect WHERE DialectID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Education]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Education]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./EducationID[1]','int'), T2.Loc.value('./EducationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllEducation/*') as T2(Loc)

UPDATE dbo.tb_education SET dbo.tb_education.EducationName = A.Value1
FROM @Table AS A WHERE dbo.tb_education.EducationID = A.ID

SET IDENTITY_INSERT dbo.tb_education ON

INSERT INTO dbo.tb_education(EducationID, EducationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT EducationID FROM dbo.tb_education)

SET IDENTITY_INSERT dbo.tb_education OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_education WHERE EducationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_EmailContent]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_EmailContent]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(MAX))
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./EmailID[1]','int'), T2.Loc.value('./EmailType[1]','VARCHAR(1000)'), T2.Loc.value('./EmailContent[1]','VARCHAR(MAX)')
FROM @XML.nodes('/All/AllChurchEmail/*') as T2(Loc)

UPDATE dbo.tb_emailContent SET dbo.tb_emailContent.EmailType = A.Value1, dbo.tb_emailContent.EmailContent = A.Value2
FROM @Table AS A WHERE dbo.tb_emailContent.EmailID = A.ID

SET IDENTITY_INSERT dbo.tb_emailContent ON

INSERT INTO dbo.tb_emailContent(EmailID, EmailType, EmailContent)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT EmailID FROM dbo.tb_emailContent)

SET IDENTITY_INSERT dbo.tb_emailContent OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_emailContent WHERE EmailID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_FamilyType]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_FamilyType]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FamilyTypeID[1]','int'), T2.Loc.value('./FamilyTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFamilyType/*') as T2(Loc)

UPDATE dbo.tb_familytype SET dbo.tb_familytype.FamilyType = A.Value1
FROM @Table AS A WHERE dbo.tb_familytype.FamilyTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_familytype ON

INSERT INTO dbo.tb_familytype(FamilyTypeID, FamilyType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FamilyTypeID FROM dbo.tb_familytype)

SET IDENTITY_INSERT dbo.tb_familytype OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_familytype WHERE FamilyTypeID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_FileType]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_FileType]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FileTypeID[1]','int'), T2.Loc.value('./FileTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFileType/*') as T2(Loc)

UPDATE dbo.tb_file_type SET dbo.tb_file_type.FileType = A.Value1
FROM @Table AS A WHERE dbo.tb_file_type.FileTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_file_type ON

INSERT INTO dbo.tb_file_type(FileTypeID, FileType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FileTypeID FROM dbo.tb_file_type)

SET IDENTITY_INSERT dbo.tb_file_type OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_file_type WHERE FileTypeID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Language]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Language]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./LanguageID[1]','int'), T2.Loc.value('./LanguageName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllLanguage/*') as T2(Loc)

UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = A.Value1
FROM @Table AS A WHERE dbo.tb_language.LanguageID = A.ID

SET IDENTITY_INSERT dbo.tb_language ON

INSERT INTO dbo.tb_language(LanguageID, LanguageName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT LanguageID FROM dbo.tb_language)

SET IDENTITY_INSERT dbo.tb_language OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_language WHERE LanguageID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_MaritalStatus]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_MaritalStatus]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./MaritalStatusID[1]','int'), T2.Loc.value('./MaritalStatusName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllMaritalStatus/*') as T2(Loc)

UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = A.Value1
FROM @Table AS A WHERE dbo.tb_maritalstatus.MaritalStatusID = A.ID

SET IDENTITY_INSERT dbo.tb_maritalstatus ON

INSERT INTO dbo.tb_maritalstatus(MaritalStatusID, MaritalStatusName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT MaritalStatusID FROM dbo.tb_maritalstatus)

SET IDENTITY_INSERT dbo.tb_maritalstatus OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_maritalstatus WHERE MaritalStatusID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Occupation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Occupation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./OccupationID[1]','int'), T2.Loc.value('./OccupationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllOccupation/*') as T2(Loc)

UPDATE dbo.tb_occupation SET dbo.tb_occupation.OccupationName = A.Value1
FROM @Table AS A WHERE dbo.tb_occupation.OccupationID = A.ID

SET IDENTITY_INSERT dbo.tb_occupation ON

INSERT INTO dbo.tb_occupation(OccupationID, OccupationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT OccupationID FROM dbo.tb_occupation)

SET IDENTITY_INSERT dbo.tb_occupation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_occupation WHERE OccupationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Parish]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Parish]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ParishID[1]','int'), T2.Loc.value('./ParishName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllParish/*') as T2(Loc)

UPDATE dbo.tb_parish SET dbo.tb_parish.ParishName = A.Value1
FROM @Table AS A WHERE dbo.tb_parish.ParishID = A.ID

SET IDENTITY_INSERT dbo.tb_parish ON

INSERT INTO dbo.tb_parish(ParishID, ParishName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ParishID FROM dbo.tb_parish)

SET IDENTITY_INSERT dbo.tb_parish OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_parish WHERE ParishID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_PostalArea]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_PostalArea]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./District[1]','int'), T2.Loc.value('./PostalAreaName[1]','VARCHAR(1000)'), T2.Loc.value('./PostalDigit[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllPostalArea/*') as T2(Loc)

UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.Value1, dbo.tb_postalArea.PostalDigit = A.Value2
FROM @Table AS A WHERE dbo.tb_postalArea.District = A.ID

SET IDENTITY_INSERT dbo.tb_postalArea ON

INSERT INTO dbo.tb_postalArea(District, PostalAreaName, PostalDigit)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT District FROM dbo.tb_postalArea)

SET IDENTITY_INSERT dbo.tb_postalArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Race]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Race]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./RaceID[1]','int'), T2.Loc.value('./RaceName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllRace/*') as T2(Loc)

UPDATE dbo.tb_race SET dbo.tb_race.RaceName = A.Value1
FROM @Table AS A WHERE dbo.tb_race.RaceID = A.ID

SET IDENTITY_INSERT dbo.tb_race ON

INSERT INTO dbo.tb_race(RaceID, RaceName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT RaceID FROM dbo.tb_race)

SET IDENTITY_INSERT dbo.tb_race OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_race WHERE RaceID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Religion]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Religion]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ReligionID[1]','int'), T2.Loc.value('./ReligionName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllReligion/*') as T2(Loc)

UPDATE dbo.tb_religion SET dbo.tb_religion.ReligionName = A.Value1
FROM @Table AS A WHERE dbo.tb_religion.ReligionID = A.ID

SET IDENTITY_INSERT dbo.tb_religion ON

INSERT INTO dbo.tb_religion(ReligionID, ReligionName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ReligionID FROM dbo.tb_religion)

SET IDENTITY_INSERT dbo.tb_religion OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_religion WHERE ReligionID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Salutation]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Salutation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SalutationID[1]','int'), T2.Loc.value('./SalutationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSalutation/*') as T2(Loc)

UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = A.Value1
FROM @Table AS A WHERE dbo.tb_Salutation.SalutationID = A.ID

SET IDENTITY_INSERT dbo.tb_Salutation ON

INSERT INTO dbo.tb_Salutation(SalutationID, SalutationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SalutationID FROM dbo.tb_Salutation)

SET IDENTITY_INSERT dbo.tb_Salutation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_Salutation WHERE SalutationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_School]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_School]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SchoolID[1]','int'), T2.Loc.value('./SchoolName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSchool/*') as T2(Loc)

UPDATE dbo.tb_school SET dbo.tb_school.SchoolName = A.Value1
FROM @Table AS A WHERE dbo.tb_school.SchoolID = A.ID

SET IDENTITY_INSERT dbo.tb_school ON

INSERT INTO dbo.tb_school(SchoolID, SchoolName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SchoolID FROM dbo.tb_school)

SET IDENTITY_INSERT dbo.tb_school OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_school WHERE SchoolID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncAllSettings_Style]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Style]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./StyleID[1]','int'), T2.Loc.value('./StyleName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllStyle/*') as T2(Loc)

UPDATE dbo.tb_style SET dbo.tb_style.StyleName = A.Value1
FROM @Table AS A WHERE dbo.tb_style.StyleID = A.ID

SET IDENTITY_INSERT dbo.tb_style ON

INSERT INTO dbo.tb_style(StyleID, StyleName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT StyleID FROM dbo.tb_style)

SET IDENTITY_INSERT dbo.tb_style OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_style WHERE StyleID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_SyncVisitorAndMembers]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SyncVisitorAndMembers]
(@XML XML)
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;
BEGIN TRY
        
        DECLARE @idoc int;
        EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
        DECLARE @NewMemberTable TABLE(NewMemberXML XML, ID INT IDENTITY(1,1));
        DECLARE @NewCETable TABLE(NewCEXML XML, ID INT IDENTITY(1,1));
        DECLARE @Count INT;
        DECLARE @Index INT = 1;
        DECLARE @NRICDoneTable TABLE(NRIC VARCHAR(20), [Type] VARCHAR(7), [XML] XML, Successful BIT, PhotoFile VARCHAR(1000));
        
        DECLARE @CourseID INT;
        DECLARE @RegistrationDate DATE;
        DECLARE @AdditionalInformation XML;
        
        DECLARE @ResID INT;
        
        INSERT INTO @NewMemberTable (NewMemberXML)
        SELECT NewMember FROM OPENXML(@idoc, '/SyncData/AllMembers/*') WITH (NewMember XML '.');

        INSERT INTO @NewCETable (NewCEXML)
        SELECT NewMember FROM OPENXML(@idoc, '/SyncData/AllVisitors/*') WITH (NewMember XML '.');

        SET @Count = (SELECT COUNT(1) FROM @NewMemberTable);
        WHILE(@Index <= @Count)
        BEGIN
                DECLARE @NewXML XML = (SELECT NewMemberXML FROM @NewMemberTable WHERE ID = @Index);
                DECLARE @NRIC VARCHAR(20);

                DECLARE @feePaid BIT;
                DECLARE @materialReceived BIT;          
                
                DECLARE @ydoc int;
                EXEC sp_xml_preparedocument @ydoc OUTPUT, @NewXML;
                
                SELECT @CourseID = CourseID, @feePaid = feePaid, @NRIC = NRIC, @materialReceived = materialReceived,
                @RegistrationDate = CONVERT(DATETIME, RegistrationDate, 103), @AdditionalInformation = AdditionalInformation
                FROM OPENXML(@ydoc, '/New') WITH 
                (NRIC VARCHAR(20) './NRIC',
                 CourseID INT './CourseID',
                 feePaid BIT './feePaid',
                 materialReceived BIT './materialReceived',
                 RegistrationDate VARCHAR(10) './RegistrationDate',
                 AdditionalInformation XML './AdditionalInformation');
                
                IF EXISTS(SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
                OR EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)         
                BEGIN
						IF EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)
						BEGIN
							DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @NRIC;
							DELETE FROM dbo.tb_members_temp WHERE NRIC = @NRIC;

							DECLARE @Rest VARCHAR(10) = '0';
							EXEC @ResID = dbo.usp_addNewMember @NewXML, @Rest OUTPUT
						END

                        IF(@CourseID <> -1)
                        BEGIN
                                INSERT INTO dbo.tb_course_participant(NRIC, courseID, RegistrationDate, AdditionalInformation)
                                SELECT @NRIC, @CourseID, @RegistrationDate, @AdditionalInformation
                        END
                        
                        INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                        SELECT @NRIC, 'New', @NewXML, 1;
                END
                ELSE
                BEGIN
                        DELETE FROM dbo.tb_visitors WHERE NRIC = @NRIC;
                        DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @NRIC;
                        DELETE FROM dbo.tb_members_temp WHERE NRIC = @NRIC;
                        
                        DECLARE @Res VARCHAR(10) = '0';
                        EXEC @ResID = dbo.usp_addNewMember @NewXML, @Res OUTPUT
                        IF(@Res = '1')
                        BEGIN
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @NRIC, 'New', @NewXML, 1;
                                
                                IF(@CourseID <> -1)
                                BEGIN
                                        INSERT INTO dbo.tb_course_participant(NRIC, courseID, RegistrationDate, AdditionalInformation)
                                        SELECT @NRIC, @CourseID, @RegistrationDate, @AdditionalInformation
                                END             
                        END
                        ELSE
                        BEGIN
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @NRIC, 'New', @NewXML, 0;
                        END
                END
                
                
                SET @Index = @Index + 1;
        END

        SET @Index = 1;
        SET @Count = (SELECT COUNT(1) FROM @NewCETable);
        DECLARE @TABLE TABLE(Result1 VARCHAR(10), Result2 VARCHAR(10), Result3 VARCHAR(10), Result4 VARCHAR(10))
        
        WHILE(@Index <= @Count)
        BEGIN
                DECLARE @VisitorXML XML = (SELECT NewCEXML FROM @NewCETable WHERE ID = @Index);
                DECLARE @VisitorNRIC VARCHAR(20);               
                
                DECLARE @xdoc int;
                EXEC sp_xml_preparedocument @xdoc OUTPUT, @VisitorXML;
                
                SELECT @AdditionalInformation = AdditionalInformation, @RegistrationDate = CONVERT(DATETIME, RegistrationDate, 103), @VisitorNRIC = NRIC, @CourseID = CourseID FROM OPENXML(@xdoc, '/Update') WITH 
                (NRIC VARCHAR(20) './NRIC',
                 CourseID INT './CourseID',
                 RegistrationDate VARCHAR(10) './RegistrationDate',
                 AdditionalInformation XML './AdditionalInformation');
                
                IF EXISTS(SELECT 1 FROM dbo.tb_members WHERE NRIC = @VisitorNRIC)
                BEGIN
                        DECLARE @Temp1 VARCHAR(100) = 'NotFound';
                        EXEC @ResID = dbo.usp_updateMemberPartial @VisitorXML, @Temp1 OUTPUT;
                        IF(@Temp1 <> 'NotFound')
                        BEGIN
                                IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @VisitorNRIC AND courseID = @CourseID)
                                BEGIN
                                        INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
                                        SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
                                END
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
                        END
                        ELSE
                        BEGIN
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
                        END                                             
                END
                ELSE IF EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @VisitorNRIC)
                BEGIN
                        DECLARE @Temp2 VARCHAR(100) = 'NotFound';
                        EXEC @ResID = dbo.usp_updateMemberTempPartial @VisitorXML, @Temp2 OUTPUT;
                        
                        IF(@Temp2 <> 'NotFound')
                        BEGIN
                                IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @VisitorNRIC AND courseID = @CourseID)
                                BEGIN
                                        INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
                                        SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
                                END
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
                        END
                        ELSE
                        BEGIN
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
                        END                     
                END
                ELSE IF EXISTS(SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @VisitorNRIC)
                BEGIN
                        DECLARE @Result VARCHAR(100) = 'NotFound';
                        EXEC @ResID = dbo.usp_updateVistor @VisitorXML, @Result OUTPUT;
                        
                        IF(@Result <> 'NotFound')
                        BEGIN
                                IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @VisitorNRIC AND courseID = @CourseID)
                                BEGIN
                                        INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
                                        SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
                                END
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
                        END
                        ELSE
                        BEGIN
                                INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                                SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
                                
                                INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
                                SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
                        END                     
                END
                ELSE
                BEGIN
                        DECLARE @FResult VARCHAR(10), @SAR VARCHAR(10), @Name VARCHAR(50), @CourseName VARCHAR(100)
                        EXEC @ResID = dbo.usp_addNewCourseVisitorParticipant @VisitorXML, @CourseID, @FResult OUTPUT, @SAR OUTPUT, @Name OUTPUT, @CourseName OUTPUT, @AdditionalInformation
                        
                        INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
                        SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
                END
                
                SET @Index = @Index + 1;
        END

        UPDATE @NRICDoneTable SET PhotoFile = B.ICPhoto
        FROM @NRICDoneTable AS A
        INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC  
        
        SELECT NRIC, [Type], [XML], Successful, PhotoFile FROM @NRICDoneTable
        COMMIT TRANSACTION;
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
        ROLLBACK TRANSACTION;   
        EXEC dbo.usp_insertloggingNoReturn N'E', N'SQLERROR', N'usp_SyncVisitorAndMembers', N'SQLERROR', 1, N'SQLERROR', N'SQLERROR', @ErrorMSG
        
END CATCH;
        

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateAdditionalInfo]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateAdditionalInfo]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (AgreementID VARCHAR(10), AgreementType VARCHAR(100), AgreementHTML VARCHAR(MAX))
	INSERT INTO @table(AgreementID, AgreementType, AgreementHTML)
	Select AgreementID, AgreementType, AgreementHTML
	from OpenXml(@xdoc, '/ChurchAdditionalInfo/*')
	with (
	AgreementID VARCHAR(10) './AgreementID',
	AgreementType VARCHAR(100) './AgreementType',
	AgreementHTML VARCHAR(MAX) './AgreementHTML');		
	
	UPDATE dbo.tb_course_agreement SET AgreementHTML = A.AgreementHTML, AgreementType = A.AgreementType
	FROM @table AS A
	WHERE A.AgreementID = dbo.tb_course_agreement.AgreementID
	
	SELECT 'Additional Information updated.' AS Result

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateAssignedModulesFunctions]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateAssignedModulesFunctions]
(@XML AS XML, @Verifier VARCHAR(50))
AS
BEGIN

BEGIN TRY
SET NOCOUNT ON;


DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
	
DECLARE @RequestTable TABLE(ID INT IDENTITY(1,1), RoleID VARCHAR(10), RoleName VARCHAR(50), RoleDeleted BIT, AllModules XML, AllFunctions XML)	
	
INSERT INTO @RequestTable(RoleID, RoleName, RoleDeleted, AllModules, AllFunctions)
Select RoleID, RoleName, RoleDeleted, AllModules, AllFunctions
from OpenXml(@idoc, '/All/*') with (
	RoleID VARCHAR(10) './RoleID',
	RoleName VARCHAR(50) './RoleName',
	RoleDeleted BIT './RoleDeleted',
	AllModules XML './AllModules',
	AllFunctions XML './AllFunctions'
)

DECLARE @NewRole TABLE(RoleID INT, RoleName VARCHAR(50), AllModules XML, ALLFunctions XML)
DECLARE @ExistingRole TABLE(RoleID INT, OriginalRoleName VARCHAR(50), RoleName VARCHAR(50), Deleted BIT, AddedModules XML, RemovedModules XML, AddedFunctions XML, RemovedFunctions XML, [Status] VARCHAR(100))

DECLARE @X INT = 1;
DECLARE @COUNT INT = (SELECT COUNT(1) FROM @RequestTable)
WHILE(@COUNT >= @X)
BEGIN
	DECLARE @RoleID VARCHAR(10), @RoleName VARCHAR(50), @RoleDeleted BIT, @AllModules XML, @AllFunctions XML;
	DECLARE @OrigRoleName VARCHAR(50);	
	SELECT @RoleID = RoleID, @RoleName = RoleName, @RoleDeleted = RoleDeleted, @AllModules = AllModules, @AllFunctions = AllFunctions FROM	@RequestTable WHERE ID = @X;
	SELECT @OrigRoleName = RoleName FROM dbo.tb_Roles WHERE CONVERT(VARCHAR(10), RoleID) = @RoleID
	IF(@RoleID LIKE 'New%.%')
	BEGIN		
		INSERT INTO dbo.tb_Roles (RoleName)
		SELECT @RoleName;		
		SELECT @RoleID = SCOPE_IDENTITY();
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllModules;		
		INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
		Select @RoleID, ModuleID		
		from OpenXml(@idoc, '/AllModules/*') with (
			ModuleID VARCHAR(10) './ModuleID'
		);
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllFunctions;
		INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight(RoleID, FunctionID)
		Select @RoleID, FunctionID		
		from OpenXml(@idoc, '/AllFunctions/*') with (
			FunctionID VARCHAR(10) './FunctionID'
		);
		
		INSERT INTO @NewRole(RoleID, RoleName, AllModules, ALLFunctions)
		SELECT @RoleID, @RoleName, @AllModules.query('//AllModules/*'), @AllFunctions.query('//AllFunctions/*');
	END
	ELSE IF(@RoleDeleted = 1)
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.tb_Roles_Users WHERE RoleID = @RoleID)
		BEGIN
			INSERT INTO @ExistingRole (RoleID, RoleName, Deleted, [Status])
			SELECT @RoleID, @RoleName, @RoleDeleted, 'Unable to delete. Users exists in rows.';
		END
		ELSE
		BEGIN
			DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID;
			DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID;
			DELETE FROM dbo.tb_Roles WHERE RoleID = @RoleID;
			INSERT INTO @ExistingRole (RoleID, RoleName, Deleted, [Status])
			SELECT @RoleID, @RoleName, @RoleDeleted, 'Role deleted.';
		END
	END
	ELSE
	BEGIN
		DECLARE @AddedModules XML, @RemovedModules XML, @AddedFunctions XML, @RemovedFunctions XML;
		IF(@OrigRoleName <> @RoleName)
		BEGIN
			UPDATE dbo.tb_Roles SET RoleName = @RoleName WHERE CONVERT(VARCHAR(10), RoleID) = @RoleID;			
		END
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllModules;
		
		SET @AddedModules = (
			Select ModuleID, ModuleName
			from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID', ModuleName VARCHAR(50) './ModuleName')
			WHERE ModuleID NOT IN (SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID)
			FOR XML PATH('Module'), ELEMENTS);
		
		INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
		Select @RoleID, ModuleID
		from OpenXml(@idoc, '/AllModules/*') with (
			ModuleID VARCHAR(10) './ModuleID', ModuleName VARCHAR(50) './ModuleName')
		WHERE ModuleID NOT IN (SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID);
			
		SET @RemovedModules = (	
			SELECT A.AppModFuncID AS ModuleID, B.AppModFuncName AS ModuleName FROM dbo.tb_Roles_AMF_AccessRights AS A
			INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID
			WHERE A.AppModFuncID NOT IN (
				Select ModuleID from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID')
			) AND RoleID = @RoleID
			FOR XML PATH('Module'), ELEMENTS);
		
		DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID AND AppModFuncID IN (
			SELECT A.AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights AS A
			INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID
			WHERE A.AppModFuncID NOT IN (
				Select ModuleID from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID')
			) AND RoleID = @RoleID
		);
			
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllFunctions;
		
		SET @AddedFunctions = (
			Select FunctionID, FunctionName
			from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID', FunctionName VARCHAR(50) './FunctionName')
			WHERE FunctionID NOT IN (SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID)
			FOR XML PATH('Function'), ELEMENTS);
		
		INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight(RoleID, functionID)
		Select @RoleID, FunctionID
		from OpenXml(@idoc, '/AllFunctions/*') with (
			FunctionID VARCHAR(10) './FunctionID', FunctionName VARCHAR(50) './FunctionName')
		WHERE FunctionID NOT IN (SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID);
					
		SET @RemovedFunctions = (	
			SELECT A.FunctionID, B.FunctionName FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A
			INNER JOIN dbo.tb_ModulesFunctions AS B ON A.FunctionID = B.FunctionID
			WHERE A.FunctionID NOT IN (
				Select FunctionID from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID')) AND RoleID = @RoleID
			FOR XML PATH('Function'), ELEMENTS);
		
		DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID AND FunctionID IN (
			SELECT A.FunctionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A
			INNER JOIN dbo.tb_ModulesFunctions AS B ON A.FunctionID = B.FunctionID
			WHERE A.FunctionID NOT IN (
				Select FunctionID from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID')) AND RoleID = @RoleID
		)
						
		INSERT INTO @ExistingRole(RoleID, OriginalRoleName, RoleName, Deleted, AddedModules, RemovedModules, AddedFunctions, RemovedFunctions)
		SELECT @RoleID, @OrigRoleName, @RoleName, 0, @AddedModules, @RemovedModules, @AddedFunctions, @RemovedFunctions
		
	END	
		
	SET @X = @X + 1;
END

DECLARE @LogID INT;
DECLARE @Changes XML = (
	SELECT 
		CONVERT(XML,(SELECT RoleID, OriginalRoleName, RoleName, Deleted, AddedModules, RemovedModules, AddedFunctions, RemovedFunctions, [Status] FROM @ExistingRole
		FOR XML PATH('Role'), ELEMENTS)) AS UpdateRole,
		CONVERT(XML,(SELECT RoleID, RoleName, AllModules, ALLFunctions FROM @NewRole
		FOR XML PATH('Role'), ELEMENTS)) AS NewRole
	FOR XML PATH('AllRoles'), ELEMENTS);
	
SELECT 'Roles updated' AS Result;
EXEC @LogID = dbo.usp_insertlogging 'I', @Verifier, 'usp_UpdateAssignedModulesFunctions', 'ModuleFunctionChanges', 1, 'NRIC', '', @Changes;


	
	
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
	
	EXEC dbo.usp_insertlogging 'E', 'SQLERROR', '<SQLERROR />', 'usp_UpdateAssignedModulesFunctions', '<SQLERROR />', 1, 0, @ErrorMSG;
	SET NOCOUNT OFF;
	
END CATCH

END




GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateBusGroupCluster]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCellgroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateChurchArea]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_updateCityKid]    Script Date: 5/7/2016 6:44:01 AM ******/
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

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_race) = 0)
BEGIN
	SET @candidate_race = '0'
END

IF(LEN(@candidate_school) = 0)
BEGIN
	SET @candidate_school = '0'
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCityKidsAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_updateCityKidSchedule]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCityKidsPoints]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateClubGroup]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateConfig]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCongregation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
		
		UPDATE dbo.tb_congregation SET Deleted = 1 WHERE CongregationID NOT IN (SELECT CongregationID FROM @table)

		SELECT 'Unable to delete(Soft delete instead), congregation still in used.' AS Result;
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCountry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourse]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateCourse]
(@Speaker VARCHAR(100),
 @SendReminder BIT,
 @courseid INT,
 @coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT,
 @AdditionalInformation INT,
 @LastRegistrationDate DATETIME,
 @MinCompleteAttendance INT)
AS
SET NOCOUNT ON;

UPDATE dbo.tb_course SET Speaker = @Speaker, SendReminder = @SendReminder, CourseName = @coursename, CourseStartDate = @startdate,
	   CourseStartTime = @starttime, CourseEndTime = @endtime, CourseInCharge = @incharge, CourseLocation = @location,
       AdditionalQuestion = @AdditionalInformation, LastRegistrationDate = @LastRegistrationDate, MinCompleteAttendance = @MinCompleteAttendance
       WHERE courseID = @courseid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;



GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourseAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
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
			
			  SELECT 'Welcome <label style="color:lime; font-size:xx-large;border-bottom-style: solid; border-bottom-width: 5px">' + @name + '</label>, thank you for attending, ' + @coursename AS Result;
		END
		ELSE
		BEGIN
			  SELECT @name = ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName), @coursename = E.CourseName FROM dbo.tb_course_participant AS A
			  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
			  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
			  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
			  INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
			  WHERE A.courseID = @courseid AND A.NRIC = @nric
			
			  SELECT 'Welcome <label style="color:lime; font-size:xx-large;border-bottom-style: solid; border-bottom-width: 5px">' + @name + '</label>, your attendance registered, ' + @coursename AS Result;
		END
	END
	ELSE IF EXISTS(SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @nric, @courseid;
		
		INSERT INTO dbo.tb_course_Attendance(NRIC, CourseID, Date)
		SELECT @nric, @courseid, GETDATE();
		
		SELECT @name = B.EnglishName, @coursename = E.CourseName FROM dbo.tb_course_participant AS A
	    LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
	    INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
	    WHERE A.courseID = @courseid AND A.NRIC = @nric
	
	    SELECT 'Welcome <label style="color:lime; font-size:xx-large;border-bottom-style: solid; border-bottom-width: 5px">' + @name + '</label>, thank you for attending, ' + @coursename AS Result;
		
	END
	ELSE IF EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @nric, @courseid;
		
		INSERT INTO dbo.tb_course_Attendance(NRIC, CourseID, Date)
		SELECT @nric, @courseid, GETDATE();
		
		SELECT @name = B.EnglishName, @coursename = E.CourseName FROM dbo.tb_course_participant AS A
	    LEFT OUTER JOIN dbo.tb_members_temp AS B ON A.NRIC = B.NRIC
	    INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
	    WHERE A.courseID = @courseid AND A.NRIC = @nric
	
	    SELECT 'Welcome <label style="color:lime; font-size:xx-large;border-bottom-style: solid; border-bottom-width: 5px">' + @name + '</label>, thank you for attending, ' + @coursename AS Result;
	END
	ELSE IF EXISTS(SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @nric, @courseid;
		
		INSERT INTO dbo.tb_course_Attendance(NRIC, CourseID, Date)
		SELECT @nric, @courseid, GETDATE();
		
		SELECT @name = B.EnglishName, @coursename = E.CourseName FROM dbo.tb_course_participant AS A
	    LEFT OUTER JOIN dbo.tb_visitors AS B ON A.NRIC = B.NRIC
	    INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
	    WHERE A.courseID = @courseid AND A.NRIC = @nric
	
	    SELECT 'Welcome <label style="color:lime; font-size:xx-large;border-bottom-style: solid; border-bottom-width: 5px">' + @name + '</label>, thank you for attending, ' + @coursename AS Result;
	END
	ELSE
	BEGIN
		SELECT '<label style="color:red;font-size:xx-large;">Sorry you are not registered.</label>' AS Result;
	END
END
ELSE
BEGIN
	SELECT @coursename = CourseName FROM dbo.tb_course WHERE courseID = @courseid
	SELECT '<label style="color:red;font-size:xx-large;">Sorry, there no class for, ' + @coursename + ' on ' + CONVERT(VARCHAR(10), @DATE,103) + '</label>'AS Result;
END

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateCourseParticipantInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateDialect]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateEducation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateEmail]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateExternalDB]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateExternalDB]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ExternalDBID INT, ExternalDBName VARCHAR(200), ExternalDBIP VARCHAR(200))
	DECLARE @newtable AS TABLE (ExternalDBID INT, ExternalDBName VARCHAR(200), ExternalDBIP VARCHAR(200))
	
	INSERT INTO @table(ExternalDBID, ExternalDBName, ExternalDBIP)
	Select ExternalDBID, ExternalDBName, ExternalDBIP
	from OpenXml(@xdoc, '/ChurchExternalDB/*')
	with (
	ExternalDBID VARCHAR(10) './ExternalDBID',
	ExternalDBIP VARCHAR(200) './ExternalDBIP',
	ExternalDBName VARCHAR(200) './ExternalDBName') WHERE ExternalDBID <> 'New';		
	
	UPDATE dbo.tb_ExternalDB SET dbo.tb_ExternalDB.ExternalDBIP = A.ExternalDBIP, dbo.tb_ExternalDB.ExternalSiteName = A.ExternalDBName
	FROM @table AS A
	WHERE A.ExternalDBID = dbo.tb_ExternalDB.ExternalDBID 
	
	DELETE FROM dbo.tb_ExternalDB WHERE ExternalDBID NOT IN (SELECT ExternalDBID FROM @table)
	
	INSERT INTO dbo.tb_ExternalDB(ExternalSiteName, ExternalDBIP)
	Select ExternalDBName, ExternalDBIP
	from OpenXml(@xdoc, '/ChurchExternalDB/*')
	with (
	ExternalDBID VARCHAR(10) './ExternalDBID',
	ExternalDBIP VARCHAR(200) './ExternalDBIP',
	ExternalDBName VARCHAR(200) './ExternalDBName') WHERE ExternalDBID = 'New';
	
	SELECT 'External DB updated.' AS Result

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateFamilyType]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateFileType]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateHWSAttendance]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateHWSAttendance]
(@ID INT)
AS
SET NOCOUNT ON;

IF NOT EXISTS(SELECT 1 FROM [dbo].[tb_HokkienWorshipDate] WHERE [WorshipDate] = CONVERT(DATE, GETDATE()))
BEGIN
	INSERT INTO [dbo].[tb_HokkienWorshipDate]
	SELECT CONVERT(DATE, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[tb_HokkienAttendance] WHERE ID = @ID AND AttendanceDate = CONVERT(DATE, GETDATE()))
BEGIN
	INSERT INTO [dbo].[tb_HokkienAttendance]
	SELECT @ID, CONVERT(DATE, GETDATE())
END

SELECT [EnglishSurname], [EnglishGivenName], [ChineseSurname], [ChineseGivenName] FROM [dbo].[tb_HokkienMember] WHERE ID = @ID;

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_updateHWSMember]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_updateHWSMember]
(@updateXML XML)
AS
SET NOCOUNT ON;


DECLARE @UserID VARCHAR(50), @ID VARCHAR(5),
	@EnglishSurname VARCHAR(10),
	@EnglishGivenName VARCHAR(30),
	@ChineseSurname NVARCHAR(2),
	@ChineseGivenName NVARCHAR(3),
	@DOB VARCHAR(10),
	@Contact VARCHAR(10),
	@NOK VARCHAR(50),
	@NOKContact VARCHAR(10),
	@candidate_street_address VARCHAR(100),
	@candidate_postal_code INT,
	@candidate_blk_house VARCHAR(70),
	@candidate_unit VARCHAR(10),
	@candidate_photo VARCHAR(1000),
	@remarks VARCHAR(8000);

	DECLARE @Orig_UserID VARCHAR(50),
	@Orig_EnglishSurname VARCHAR(10),
	@Orig_EnglishGivenName VARCHAR(30),
	@Orig_ChineseSurname NVARCHAR(2),
	@Orig_ChineseGivenName NVARCHAR(3),
	@Orig_DOB VARCHAR(10),
	@Orig_Contact VARCHAR(10),
	@Orig_NOK VARCHAR(50),
	@Orig_NOKContact VARCHAR(10),
	@Orig_candidate_street_address VARCHAR(100),
	@Orig_candidate_postal_code INT,
	@Orig_candidate_blk_house VARCHAR(70),
	@Orig_candidate_unit VARCHAR(10),
	@Orig_candidate_photo VARCHAR(1000),
	@Orig_remarks VARCHAR(8000);

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;

	SELECT @ID = ID, @UserID = EnteredBy, @EnglishSurname = EnglishSurname, @EnglishGivenName = EnglishGivenName, @ChineseSurname = ChineseSurname,
	@ChineseGivenName = ChineseGivenName, @DOB = DOB, @Contact = Contact, @NOK = NOK, @NOKContact = NOKContact,
	@candidate_street_address = candidate_street_address, @candidate_postal_code = candidate_postal_code, 
	@candidate_blk_house = candidate_blk_house, @candidate_unit = candidate_unit, @candidate_photo = candidate_photo, @remarks = remarks
	FROM OPENXML(@idoc, '/new')
	WITH (
	ID VARCHAR(5) './ID',
	EnteredBy VARCHAR(50)'./EnteredBy',
	EnglishSurname VARCHAR(10)'./EnglishSurname',
	EnglishGivenName VARCHAR(30) './EnglishGivenName',
	ChineseSurname NVARCHAR(2) './ChineseSurname',
	ChineseGivenName NVARCHAR(3) './ChineseGivenName',
	DOB VARCHAR(10) './DOB',
	Contact VARCHAR(10) './Contact',
	NOK VARCHAR(50) './NOK',
	NOKContact VARCHAR(10) './NOKContact',
	candidate_street_address VARCHAR(100) './candidate_street_address',
	candidate_postal_code INT './candidate_postal_code',
	candidate_blk_house VARCHAR(70) './candidate_blk_house',
	candidate_unit VARCHAR(10) './candidate_unit',
	candidate_photo VARCHAR(1000) './candidate_photo',
	remarks VARCHAR(8000) './remarks');

	SELECT @Orig_EnglishSurname = EnglishSurname, @Orig_EnglishGivenName = EnglishGivenName, @Orig_ChineseSurname = ChineseSurname,
	@Orig_ChineseGivenName = ChineseGivenName, @Orig_DOB = CONVERT(VARCHAR(10), Birthday, 103), @Orig_Contact = Contact, @Orig_NOK = NextOfKinName, @Orig_NOKContact = NextOfKinContact,
	@Orig_candidate_street_address = AddressStreet, @Orig_candidate_postal_code = AddressPostalCode, 
	@Orig_candidate_blk_house = AddressHouseBlock, @Orig_candidate_unit = AddressUnit, @Orig_candidate_photo = Photo, @Orig_remarks = remarks
	FROM [dbo].[tb_HokkienMember] WHERE @ID = @ID;

	IF(@Orig_EnglishSurname <> @EnglishSurname)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Surname', @Orig_EnglishSurname, @EnglishSurname);
	END

	IF(@Orig_EnglishGivenName <> @EnglishGivenName)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Given Name', @Orig_EnglishGivenName, @EnglishGivenName);
	END

	IF(@Orig_ChineseSurname <> @ChineseSurname)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Surname', @Orig_ChineseSurname, @ChineseSurname);
	END

	IF(@Orig_ChineseGivenName <> @ChineseGivenName)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Given Name', @Orig_ChineseGivenName, @ChineseGivenName);
	END

	IF(@Orig_Contact <> @Contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Contact', @Orig_Contact, @Contact);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Blk House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Street Address', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('House Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Photo', @Orig_candidate_photo, @candidate_photo);
	END

	IF(@Orig_NOK <> @NOK)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next of Kin', @Orig_NOK, @NOK);
	END

	IF(@Orig_NOKContact <> @NOKContact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next of Kin Contact', @Orig_NOKContact, @NOKContact);
	END

	IF(@Orig_remarks <> @remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_remarks, @remarks);
	END

	
	IF(ISNULL(@Orig_DOB,'') <> ISNULL(@DOB,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Birthday', @Orig_DOB, @DOB);
		if(LEN(@DOB) = 0)
		BEGIN
			SET @DOB = null;
		END
	END

	DECLARE @returnTable TABLE (
		FromTo XML);

	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);

		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);

		UPDATE [dbo].[tb_HokkienMember] SET [EnglishSurname] = @EnglishSurname, [EnglishGivenName] = @EnglishGivenName, [ChineseSurname] = @ChineseSurname,
		[ChineseGivenName] = @ChineseGivenName, [Birthday] = CONVERT(DATE, @DOB, 103), [Contact] = @Contact, [AddressHouseBlock] = @candidate_blk_house,
		[AddressStreet] = @candidate_street_address, [AddressUnit] = @candidate_unit, [AddressPostalCode] = @candidate_postal_code, [Photo] = @candidate_photo,
		[NextOfKinName] = @NOK, [NextOfKinContact] = @NOKContact, [Remarks] = @remarks
		WHERE ID = @ID;

		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'HWSMembership', 'Update', 1, 'NRIC', @ID, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END

SET NOCOUNT OFF;




GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateLanguage]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateMaritalStatus]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_updateMember]    Script Date: 5/7/2016 6:44:01 AM ******/
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
@Fileremarks VARCHAR(1000),
@candidate_mailingList VARCHAR(3),
@candidate_mailingListBoolean BIT = 0;


	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_mailingList = mailingLIst, @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
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
	mailingList VARCHAR(3) './mailingList',
	TransferToDate VARCHAR(100) './TransferToDate');

IF(@candidate_mailingList = 'ON')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_marital_status) = 0)
BEGIN
	SET @candidate_marital_status = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF(LEN(@candidate_congregation) = 0)
BEGIN
	SET @candidate_congregation = '0'
END

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
	DECLARE @Orig_candidate_mailingList VARCHAR(3)
	
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
																																

	SELECT  @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
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

	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
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
							PreviousChurchOthers = @previous_church_others,
							ReceiveMailingList = @candidate_mailingListBoolean
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
/****** Object:  StoredProcedure [dbo].[usp_updateMemberPartial]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_updateMemberPartial]
(@updateXML XML, @Result VARCHAR(10) OUTPUT)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_salutation VARCHAR(4),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_occupation VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_mobile_tel VARCHAR(15),
@candidate_mailingList VARCHAR(3),
@candidate_congregation TINYINT,
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_congregation = Congregation, @candidate_mailingList = mailingLIst, @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_nationality = Nationality,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(20)'./EnteredBy',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	Nationality VARCHAR(3) './Nationality',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	MobileTel VARCHAR(15) './Contact',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	mailingList VARCHAR(3) './mailingList',
	Congregation TINYINT './Congregation',
	Occupation VARCHAR(3) './Occupation');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_members WHERE NRIC = @candidate_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)	
	DECLARE @Orig_candidate_mailingList VARCHAR(3)
	DECLARE @Orig_candidate_congregation VARCHAR(3)


	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	SELECT @Orig_candidate_congregation = Congregation FROM dbo.tb_membersOtherInfo WHERE NRIC = @candidate_nric;
	
	SELECT  @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_mobile_tel = MobileTel
	FROM dbo.tb_members AS A
	WHERE A.NRIC = @candidate_nric
	
	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Congregation(Indicated)', (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @Orig_candidate_congregation), (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @candidate_congregation));		
	END
	
	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
	END

	IF(@Orig_candidate_salutation <> @candidate_salutation AND @candidate_salutation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));
		SET @Orig_candidate_salutation = @candidate_salutation;
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name AND LEN(@candidate_english_name) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name(Indicated)', @Orig_candidate_english_name, @candidate_english_name);
		SET @Orig_candidate_english_name = @candidate_english_name;
	END

	IF(@Orig_candidate_unit <> @candidate_unit AND LEN(@candidate_unit) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
		SET @Orig_candidate_unit = @candidate_unit;
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house AND LEN(@candidate_blk_house) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
		SET @Orig_candidate_blk_house = @candidate_blk_house;
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address AND LEN(@candidate_street_address) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
		SET @Orig_candidate_street_address = @candidate_street_address;
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code AND @candidate_postal_code <> 0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
		SET @Orig_candidate_postal_code = @candidate_postal_code;
	END
	
	IF(@Orig_candidate_nationality <> @candidate_nationality AND @candidate_nationality <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
		SET @Orig_candidate_nationality = @candidate_nationality;
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation AND @candidate_occupation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
		SET @Orig_candidate_occupation = @candidate_occupation;
	END

	IF(@Orig_candidate_dob <> @candidate_dob AND @candidate_dob <> CONVERT(DATETIME, '', 103))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
		SET @Orig_candidate_dob = @candidate_dob;
	END

	IF(@Orig_candidate_gender <> @candidate_gender AND LEN(@candidate_gender) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
		SET @Orig_candidate_gender = @candidate_gender;
	END

	IF(@Orig_candidate_email <> @candidate_email AND LEN(@candidate_email) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
		SET @Orig_candidate_email = @candidate_email;
	END

	IF(@Orig_candidate_education <> @candidate_education AND @candidate_education <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));
		SET @Orig_candidate_education = @candidate_education;
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel AND LEN(@candidate_mobile_tel) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
		SET @Orig_candidate_mobile_tel = @candidate_mobile_tel;
	END

	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		--UPDATE tb_membersOtherInfo SET Congregation = @candidate_congregation WHERE NRIC = @candidate_nric;
		
		UPDATE tb_members SET   Salutation = @Orig_candidate_salutation,
							--EnglishName = @Orig_candidate_english_name,
							AddressUnit = @Orig_candidate_unit,
							AddressHouseBlk = @Orig_candidate_blk_house,
							Nationality = @Orig_candidate_nationality,
							Occupation = @Orig_candidate_occupation,
							DOB = @Orig_candidate_dob,
							Gender = @Orig_candidate_gender,
							AddressStreet = @Orig_candidate_street_address,
							AddressPostalCode = @Orig_candidate_postal_code,
							Email = @Orig_candidate_email,
							Education = @Orig_candidate_education,
							MobileTel = @Orig_candidate_mobile_tel,
							ReceiveMailingList = @candidate_mailingListBoolean							
		WHERE NRIC = @candidate_nric;
			
		SET @Result = 'Updated';
		
		DECLARE @LogID INT;
		EXEC @LogID = dbo.usp_insertloggingNoReturn 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SET @Result = 'NoChange';
	END
END
ELSE
BEGIN		
	SET @Result = 'NotFound';
END

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_updateMemberTempPartial]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_updateMemberTempPartial]
(@updateXML XML, @Result VARCHAR(10) OUTPUT)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_salutation VARCHAR(4),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_occupation VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_mobile_tel VARCHAR(15),
@candidate_mailingList VARCHAR(3),
@candidate_congregation TINYINT,
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_congregation = Congregation, @candidate_mailingList = mailingList, @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_nationality = Nationality,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(20)'./EnteredBy',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	Nationality VARCHAR(3) './Nationality',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	MobileTel VARCHAR(15) './Contact',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	mailingList VARCHAR(3) './mailingList',
	Congregation TINYINT './Congregation',
	Occupation VARCHAR(3) './Occupation');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @candidate_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)	
	DECLARE @Orig_candidate_mailingList VARCHAR(3)
	DECLARE @Orig_candidate_congregation VARCHAR(3)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
			
	SELECT @Orig_candidate_congregation = Congregation FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @candidate_nric;
	
	SELECT  @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_mobile_tel = MobileTel
	FROM dbo.tb_members_temp AS A
	WHERE A.NRIC = @candidate_nric;
	
	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Congregation(Indicated)', (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @Orig_candidate_congregation), (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @candidate_congregation));		
	END

	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
	END

	IF(@Orig_candidate_salutation <> @candidate_salutation AND @candidate_salutation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));
		SET @Orig_candidate_salutation = @candidate_salutation;
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name AND LEN(@candidate_english_name) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name(Indicated)', @Orig_candidate_english_name, @candidate_english_name);
		SET @Orig_candidate_english_name = @candidate_english_name;
	END

	IF(@Orig_candidate_unit <> @candidate_unit AND LEN(@candidate_unit) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
		SET @Orig_candidate_unit = @candidate_unit;
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house AND LEN(@candidate_blk_house) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
		SET @Orig_candidate_blk_house = @candidate_blk_house;
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address AND LEN(@candidate_street_address) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
		SET @Orig_candidate_street_address = @candidate_street_address;
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code AND @candidate_postal_code <> 0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
		SET @Orig_candidate_postal_code = @candidate_postal_code;
	END
	
	IF(@Orig_candidate_nationality <> @candidate_nationality AND @candidate_nationality <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
		SET @Orig_candidate_nationality = @candidate_nationality;
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation AND @candidate_occupation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
		SET @Orig_candidate_occupation = @candidate_occupation;
	END

	IF(@Orig_candidate_dob <> @candidate_dob AND @candidate_dob <> CONVERT(DATETIME, '', 103))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
		SET @Orig_candidate_dob = @candidate_dob;
	END

	IF(@Orig_candidate_gender <> @candidate_gender AND LEN(@candidate_gender) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
		SET @Orig_candidate_gender = @candidate_gender;
	END

	IF(@Orig_candidate_email <> @candidate_email AND LEN(@candidate_email) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
		SET @Orig_candidate_email = @candidate_email;
	END

	IF(@Orig_candidate_education <> @candidate_education AND @candidate_education <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));
		SET @Orig_candidate_education = @candidate_education;
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel AND LEN(@candidate_mobile_tel) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
		SET @Orig_candidate_mobile_tel = @candidate_mobile_tel;
	END

	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		--UPDATE tb_membersOtherInfo_temp SET Congregation = @candidate_congregation WHERE NRIC = @candidate_nric;
		
		UPDATE dbo.tb_members_temp SET   Salutation = @Orig_candidate_salutation,
							--EnglishName = @Orig_candidate_english_name,
							AddressUnit = @Orig_candidate_unit,
							AddressHouseBlk = @Orig_candidate_blk_house,
							Nationality = @Orig_candidate_nationality,
							Occupation = @Orig_candidate_occupation,
							DOB = @Orig_candidate_dob,
							Gender = @Orig_candidate_gender,
							AddressStreet = @Orig_candidate_street_address,
							AddressPostalCode = @Orig_candidate_postal_code,
							Email = @Orig_candidate_email,
							Education = @Orig_candidate_education,
							MobileTel = @Orig_candidate_mobile_tel,
							ReceiveMailingList = @candidate_mailingListBoolean
							
		WHERE NRIC = @candidate_nric
			
		SET @Result = 'Updated';
		
		DECLARE @LogID INT;
		EXEC @LogID = dbo.usp_insertloggingNoReturn 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SET @Result = 'NoChange';
	END
END
ELSE
BEGIN		
	SET @Result = 'NotFound';
END

SET NOCOUNT OFF;


GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateMinistry]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateNewMember]    Script Date: 5/7/2016 6:44:01 AM ******/
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

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_marital_status) = 0)
BEGIN
	SET @candidate_marital_status = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF(LEN(@candidate_congregation) = 0)
BEGIN
	SET @candidate_congregation = '0'
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateOccupation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateParish]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdatePostal]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateRace]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateReligion]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateRoles]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateRoles_bk]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateRolesUserID]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateSalutation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateSchool]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateStyle]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_updateTempMember]    Script Date: 5/7/2016 6:44:01 AM ******/
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
@Fileremarks VARCHAR(1000),
@candidate_mailingList VARCHAR(3),
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_mailingList = mailingLIst, @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
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
	mailingList VARCHAR(3) './mailingList',
	TransferToDate VARCHAR(100) './TransferToDate');

IF(@candidate_mailingList = 'ON')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_marital_status) = 0)
BEGIN
	SET @candidate_marital_status = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF(LEN(@candidate_congregation) = 0)
BEGIN
	SET @candidate_congregation = '0'
END








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
	DECLARE @Orig_candidate_mailingList VARCHAR(3)
	
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
																																

	SELECT  @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
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
	
	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
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
							PreviousChurchOthers = @previous_church_others,
							ReceiveMailingList = @candidate_mailingListBoolean
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserInformation]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_UpdateUserPassword]    Script Date: 5/7/2016 6:44:01 AM ******/
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
/****** Object:  StoredProcedure [dbo].[usp_updateVistor]    Script Date: 5/7/2016 6:44:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_updateVistor]
(@updateXML XML,
@Result VARCHAR(20) OUTPUT)
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
@candidate_churchOthers VARCHAR(100),
@candidate_mailingList VARCHAR(3),
@candidate_congregation TINYINT,
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_mailingList =mailingList, @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = DOB,
	@candidate_nationality = Nationality, @candidate_contact = Contact,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation,
	@candidate_church = Church, @candidate_churchOthers = ChurchOthers, @candidate_congregation = Congregation
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
	mailingList VARCHAR(3) './mailingList',
	Church VARCHAR(3) './Church',
	Congregation TINYINT './Congregation',
	ChurchOthers VARCHAR(100) './ChurchOthers');	

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

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
	DECLARE @Orig_candidate_mailingList VARCHAR(3)
	DECLARE @Orig_candidate_congregation VARCHAR(3)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));																									

	SELECT  @Orig_candidate_congregation = Congregation, @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = ISNULL(CONVERT(VARCHAR(15),DOB,103),''), @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_contact = Contact, @Orig_candidate_church = CONVERT(VARCHAR(3),Church), @Orig_candidate_church_others = ChurchOthers
	FROM dbo.tb_visitors AS A
	WHERE A.NRIC = @candidate_original_nric;
	
	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
	END

	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Congregation', (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @Orig_candidate_congregation), (SELECT CongregationName FROM dbo.tb_congregation WHERE CongregationID = @candidate_congregation));		
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
							ChurchOthers = @candidate_churchOthers,
							ReceiveMailingList = @candidate_mailingListBoolean,
							Congregation = @candidate_congregation
		WHERE NRIC = @candidate_original_nric
		
		SET @Result = 'Updated';
		
		DECLARE @LogID TABLE(ID INT);
		INSERT INTO @LogID(ID)
		EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'UpdateVisitor', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SET @Result = 'NoChange';
	END
END
ELSE
BEGIN		
	SET @Result = 'NotFound';
END

SET NOCOUNT OFF;


GO
