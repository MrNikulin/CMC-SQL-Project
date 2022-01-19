USE [grocery_store]
GO

--- Checking if stored procedures already exist, if so drop them
IF OBJECT_ID('ClearTables') IS NOT NULL
	DROP PROCEDURE [ClearTables]
IF OBJECT_ID('ShowAllGoods') IS NOT NULL
	DROP PROCEDURE [ShowAllGoods]
IF OBJECT_ID('GoodsInStock') IS NOT NULL
	DROP PROCEDURE [GoodsInStock]
IF OBJECT_ID('GoodsNotInStock') IS NOT NULL
	DROP PROCEDURE [GoodsNotInStock]
IF OBJECT_ID('GoodsFromSupplier') IS NOT NULL
	DROP PROCEDURE [GoodsFromSupplier]
GO

-- Creating stored procedure ClearTables
--		This stored procedure clears all the tables from loaded date
CREATE PROCEDURE [ClearTables]
AS
BEGIN
	IF EXISTS 
		(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
         WHERE [CONSTRAINT_SCHEMA] = 'dbo' AND [CONSTRAINT_NAME] = 'FK_Order_ID'
				                          AND [CONSTRAINT_TYPE] = 'FOREIGN KEY')
	  ALTER TABLE [dbo].[Orders_Goods] DROP CONSTRAINT [FK_Order_ID]
	IF EXISTS 
		(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
         WHERE [CONSTRAINT_SCHEMA] = 'dbo' AND [CONSTRAINT_NAME] = 'FK_Good_ID'
				                          AND [CONSTRAINT_TYPE] = 'FOREIGN KEY')
	  ALTER TABLE [dbo].[Orders_Goods] DROP CONSTRAINT [FK_Good_ID]
	IF EXISTS 
		(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
         WHERE [CONSTRAINT_SCHEMA] = 'dbo' AND [CONSTRAINT_NAME] = 'FK_Supplier_ID'
				                          AND [CONSTRAINT_TYPE] = 'FOREIGN KEY')
	  ALTER TABLE [dbo].[Goods] DROP CONSTRAINT [FK_Supplier_ID]

	TRUNCATE TABLE [dbo].[Orders_Goods]
	TRUNCATE TABLE [dbo].[Orders]
	TRUNCATE TABLE [dbo].[Goods]
	TRUNCATE TABLE [dbo].[Suppliers]

	ALTER TABLE [dbo].[Orders_Goods]
		ADD CONSTRAINT [FK_Order_ID]
			FOREIGN KEY ([Order_ID]) REFERENCES [dbo].[Orders]([Order_ID]) ON DELETE CASCADE ON UPDATE CASCADE
	ALTER TABLE [dbo].[Orders_Goods]
		ADD CONSTRAINT [FK_Good_ID]
			FOREIGN KEY ([Good_ID]) REFERENCES [dbo].[Goods]([Good_ID]) ON DELETE CASCADE ON UPDATE CASCADE
	ALTER TABLE [dbo].[Goods]
		ADD CONSTRAINT [FK_Supplier_ID]
			FOREIGN KEY ([Supplier_ID]) REFERENCES [dbo].[Suppliers]([Supplier_ID]) ON DELETE CASCADE ON UPDATE CASCADE
END
GO

--- Creating stored procedure ShowAllGoods
---		This procedure selects all goods from database
CREATE PROCEDURE [ShowAllGoods]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods]
END
GO

--- Creating stored procedure GoodsInStock
---		This procedure selects goods that are in stock
CREATE PROCEDURE [GoodsInStock]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods] g
	WHERE g.[Quantity] > 0
END
GO

--- Creating stored procedure GoodsNotInStock
---		This procedure selects goods that are not in stock
CREATE PROCEDURE [GoodsNotInStock]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods] g
	WHERE g.[Quantity] = 0
END
GO

--- Creating stored procedure GoodsFromSupplier
---		This procedure selects goods supplied by given supplier
CREATE PROCEDURE [GoodsFromSupplier]
(
	@Supplier_ID [int]
)
AS
BEGIN
	SELECT 
		g.[Good_ID],
		g.[Name]
	FROM [dbo].[Goods] g
	WHERE g.[Supplier_ID] = @Supplier_ID
END
GO

--- Creating stored procedure InsertOrUpdateGood
---		This procedure inserts new good into database or updates it if given good already exists
CREATE PROCEDURE [InsertOrUpdateGood]
(
	@Good_ID [int],
	@Name NVARCHAR(max),
	@Shelf_ID [int],
	@Quantity [int],
	@Supplier_ID [int]
)
AS
BEGIN
	IF EXISTS
	   (SELECT * FROM [dbo].[Goods] AS g
	    WHERE g.[Good_ID] = @Good_ID)
	  BEGIN
		UPDATE
			Goods
		SET
			[Name] = @Name,
			[Shelf_ID] = @Shelf_ID,
			[Quantity] = @Quantity,
			[Supplier_ID] = @Supplier_ID
		WHERE
			[Good_ID] = @Good_ID
	  END
	ELSE
	  INSERT INTO [dbo].[Goods]
	  VALUES (@Good_ID, @Name, @Shelf_ID, @Quantity, @Supplier_ID)
END
GO

--- Creating stored procedure DeleteFromGoods
---		This stored procedure deletes data about some good
CREATE PROCEDURE [DeleteFromGoods]
(
	@Good_ID [int]
)
AS
BEGIN
	DELETE FROM Goods
	WHERE [Good_ID] = @Good_ID
END
GO

--- Creating stored procedure InsertOrUpdateSupplier
---		This procedure inserts new supplier into database or updates it if given supplier already exists
CREATE PROCEDURE [InsertOrUpdateSupplier]
(
	@Supplier_ID [int],
	@Name NVARCHAR(max),
	@Address NVARCHAR(max),
	@PhoneNumber NVARCHAR(max)
)
AS
BEGIN
	IF EXISTS
	   (SELECT * FROM [dbo].[Suppliers] AS s
	    WHERE s.[Supplier_ID] = @Supplier_ID)
	  BEGIN
		UPDATE
			Suppliers
		SET
			[Name] = @Name,
			[Address] = @Address,
			[PhoneNumber] = @PhoneNumber
		WHERE
			[Supplier_ID] = @Supplier_ID
	  END
	ELSE
	  INSERT INTO [dbo].[Suppliers]
	  VALUES (@Supplier_ID, @Name, @Address, @PhoneNumber)
END
GO

--- Creating stored procedure DeleteFromSuppliers
---		This stored procedure deletes data about some supplier
CREATE PROCEDURE [DeleteFromSuppliers]
(
	@Supplier_ID [int]
)
AS
BEGIN
	DELETE FROM Suppliers
	WHERE [Supplier_ID] = @Supplier_ID
END
GO
