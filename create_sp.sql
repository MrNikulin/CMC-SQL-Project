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
			FOREIGN KEY ([Order_ID]) REFERENCES [dbo].[Orders]([Order_ID])
	ALTER TABLE [dbo].[Orders_Goods]
		ADD CONSTRAINT [FK_Good_ID]
			FOREIGN KEY ([Good_ID]) REFERENCES [dbo].[Goods]([Good_ID])
	ALTER TABLE [dbo].[Goods]
		ADD CONSTRAINT [FK_Supplier_ID]
			FOREIGN KEY ([Supplier_ID]) REFERENCES [dbo].[Suppliers]([Supplier_ID])
END
GO

--- Creating stored procedure ShowAllGoods
---		This procedure select all goods from data base
CREATE PROCEDURE [ShowAllGoods]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods]
END
GO

--- Creating stored procedure GoodsInStock
---		This procedure select goods that are in stock
CREATE PROCEDURE [GoodsInStock]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods] g
	WHERE g.[Quantity] > 0
END
GO

--- Creating stored procedure GoodsNotInStock
---		This procedure select goods that are not in stock
CREATE PROCEDURE [GoodsNotInStock]
AS
BEGIN
	SELECT *
	FROM [dbo].[Goods] g
	WHERE g.[Quantity] = 0
END
GO

--- Creating stored procedure GoodsFromSupplier
---		This procedure select goods supplied by given supplier
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
