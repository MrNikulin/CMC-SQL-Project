USE [grocery_store]
GO

--- Checking if stored procedures already exist, if so drop them
IF OBJECT_ID('ClearTables') IS NOT NULL             -- изменить!!!
	DROP PROCEDURE [ClearTables]
IF OBJECT_ID('AddNewResource') IS NOT NULL
	DROP PROCEDURE [AddNewResource]
IF OBJECT_ID('UpdateContent') IS NOT NULL
	DROP PROCEDURE [UpdateContent]
IF OBJECT_ID('GetDataByKeyWords') IS NOT NULL
	DROP PROCEDURE [GetDataByKeyWords]
IF OBJECT_ID('GetFullInfo') IS NOT NULL
	DROP PROCEDURE [GetFullInfo]
IF OBJECT_ID('GetFromTempData') IS NOT NULL
	DROP PROCEDURE [GetFromTempData]
IF OBJECT_ID('SortDataByLastUpdate') IS NOT NULL
	DROP PROCEDURE [SortDataByLastUpdate]
IF OBJECT_ID('dbo.CreateTempTable') IS NOT NULL
	DROP PROCEDURE [CreateTempTable]
GO

-- Creating stored procedure ClearTables
--		This stored procedure simply clears all the tables from loaded date
CREATE PROCEDURE [ClearTables]
AS
BEGIN
	IF EXISTS 
		(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
         WHERE [CONSTRAINT_SCHEMA] = 'dbo' AND [CONSTRAINT_NAME] = 'FK_URL_ID'
				                          AND [CONSTRAINT_TYPE] = 'FOREIGN KEY')
	  ALTER TABLE [dbo].[Catalog] DROP CONSTRAINT [FK_URL_ID]
	IF EXISTS 
		(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
         WHERE [CONSTRAINT_SCHEMA] = 'dbo' AND [CONSTRAINT_NAME] = 'FK_Section_ID'
				                          AND [CONSTRAINT_TYPE] = 'FOREIGN KEY')
	  ALTER TABLE [dbo].[Catalog] DROP CONSTRAINT [FK_Section_ID]

	TRUNCATE TABLE [dbo].[Catalog]
	TRUNCATE TABLE [dbo].[URL]
	TRUNCATE TABLE [dbo].[Section]

	ALTER TABLE [dbo].[Catalog]
		ADD CONSTRAINT [FK_URL_ID]
			FOREIGN KEY([URL_ID]) REFERENCES [dbo].[URL]([URL_ID])
	ALTER TABLE [dbo].[Catalog]
		ADD CONSTRAINT [FK_Section_ID]
			FOREIGN KEY ([Section_ID]) REFERENCES [dbo].[Section]([Section_ID])
END
GO

--- Creating stored procedure AddNewResource
---		This stroed procedure add new internet resource in the catalog
CREATE PROCEDURE [AddNewResource]
(
	@resourceName [nvarchar](MAX),
	@resourceURL [dbo].[URL_t],
	@content TEXT,
	@sectionName [nvarchar](MAX),
	@descript [nvarchar](4000),
	@keywords [nvarchar](4000),
	@contacts [dbo].[contacts_t]	
)
AS
BEGIN
	--- Insert into Section table if there is not record with SectionName LIKE @sectionName
	IF (SELECT SectionName FROM [dbo].[Section] WHERE SectionName LIKE @sectionName) IS NULL
		INSERT INTO [dbo].[Section] (SectionName) VALUES (@sectionName)

	--- Insert into URL table
	IF (SELECT URL_ID FROM [dbo].[URL] WHERE URL LIKE @resourceURL) IS NULL
		INSERT INTO [dbo].[URL] (Name, URL, Content, ChangeDate) 
			VALUES (@resourceName, @resourceURL, @content, GETDATE())

	--- Insert into Catalog table
	DECLARE @sectionID [int]
	DECLARE @URLID [int]

	SET @sectionID = (SELECT Section_ID FROM [dbo].[Section]
						WHERE SectionName LIKE @sectionName)
	SET @URLID = (SELECT URL_ID FROM [dbo].[URL]
						WHERE URL LIKE @resourceURL)
	
	INSERT INTO [dbo].[Catalog] (URL_ID, Section_ID, Descript, Contacts) 
		VALUES (@URLID, @sectionID, @descript, @contacts)
END
GO

--- Creating stored procedure UpdateContent
---		This procedure update content of the internet resource
CREATE PROCEDURE [UpdateContent]
(
	@newContent TEXT,
	@conturl [dbo].[URL_t]
)
AS
BEGIN
	UPDATE [dbo].[URL] SET Content = @newContent WHERE URL = @conturl
	--- start trigger and change date of the last update
END
GO

--- Creating temporaty table
CREATE PROCEDURE [CreateTempTable]
AS
BEGIN
	IF OBJECT_ID('tempdb..##TemporaryData') IS NOT NULL
		DROP TABLE ##TemporaryData
	CREATE TABLE ##TemporaryData (
						Name nvarchar(MAX) NOT NULL,
						[Last Update] Date NOT NULL,
						URL TEXT NOT NULL,
						Description nvarchar(4000) NOT NULL,
						Contacts TEXT NOT NULL,
						[Section Name] nvarchar(MAX) NOT NULL,
						[URL_ID] [int]
					)
END
GO

--- Creating stored procedure GetDataByKeyWords
---		This procedure select data about internet resources which description
---		contains few of key words
CREATE PROCEDURE [GetDataByKeyWords]
(
	@keywordsLst [nvarchar](4000),
	@isfull [int]
)
AS
BEGIN
	EXEC CreateTempTable
	INSERT INTO [tempdb].[##TemporaryData]
	SELECT 
		u.[Name] AS [Name], 
		u.[ChangeDate] AS [Last Update],
		u.[URL] AS [URL], 
		cat.[Descript] AS Descript, 
		cat.[Contacts] AS Contacts,
		sec.[SectionName] AS [Section Name],
		cat.[URL_ID] AS URL_ID
	FROM
		[dbo].[URL] AS u
	INNER JOIN 
		[dbo].[Catalog] AS cat
		ON u.[URL_ID] = cat.[URL_ID]
	INNER JOIN 
		[dbo].[Section] AS sec
		ON sec.[Section_ID] = cat.[Section_ID]
	WHERE FREETEXT(cat.[Descript], @keywordsLst)
	
	IF @isfull = 1
		SELECT * FROM [tempdb].[##TemporaryData]
	ELSE
		SELECT td.[Name], td.[URL] FROM [tempdb].[##TemporaryData] AS td
END
GO

--- Creating sroted procedure GetFullInfo
CREATE PROCEDURE [GetFullInfo]
AS
BEGIN
	SELECT * FROM dbo.Catalog AS c
	INNER JOIN dbo.URL AS u ON c.URL_ID = u.URL_ID
END
GO

--- Creating stored procedure GetFromTempData
---		This stored procedure allows users to narrow information 
---		which they got from their last query
CREATE PROCEDURE [GetFromTempData]
(
	@keywordsLst nvarchar(400),
	@isfull [int]
)
AS
BEGIN
	SELECT 
		u.[Name] AS [Name], 
		u.[ChangeDate] AS [Last Update],
		u.[URL] AS [URL], 
		cat.[Descript] AS [Descript], 
		cat.[Contacts] AS [Contacts],
		sec.[SectionName] AS [Section Name],
		cat.[URL_ID] AS [URL_ID]
	INTO #tempdb
	FROM
		[dbo].[URL] AS u
	INNER JOIN 
		[dbo].[Catalog] AS cat
		ON u.[URL_ID] = cat.[URL_ID]
	INNER JOIN 
		[dbo].[Section] AS sec
		ON sec.[Section_ID] = cat.[Section_ID]
	INNER JOIN 
		[tempdb].[##TemporaryData] AS td
		ON u.[URL_ID] = td.[URL_ID]
	--WHERE FREETEXT(kw.KeyWordsLst, @keywordsLst)
	WHERE FREETEXT(cat.[Descript], @keywordsLst)

	EXEC CreateTempTable
	INSERT INTO [tempdb].[##TemporaryData]
	SELECT *
	FROM #tempdb as td
	IF OBJECT_ID('tempdb..#tempd') IS NOT NULL
		DROP TABLE #tempdb
	
	IF @isfull = 1
		SELECT * FROM [tempdb].[##TemporaryData]
	ELSE
		SELECT td.[Name], td.[URL] FROM [tempdb].[##TemporaryData] AS td

END
GO

--- Creating stored procedure SortDataByLastUpdate
---		This stored procedure allows users to sort data by last update
CREATE PROCEDURE [SortDataByLastUpdate]
(
	@invert [int]	
)
AS
BEGIN
	IF OBJECT_ID('tempdb..##TemporaryData') IS NOT NULL
	BEGIN
		IF (@invert = 0)
		BEGIN
			SELECT *
			FROM [tempdb].[##TemporaryData] AS td
			ORDER BY td.[Last Update]
		END
		IF (@invert = 1)
		BEGIN
			SELECT *
			FROM [tempdb].[##TemporaryData] AS td
			ORDER BY td.[Last Update] DESC
		END
	END
END
GO