USE [grocery_store]
GO

-- Drop tables, if they already exist
IF OBJECT_ID('dbo.Orders_Goods') IS NOT NULL
    DROP TABLE [dbo].[Orders_Goods]
IF OBJECT_ID('dbo.Orders') IS NOT NULL
    DROP TABLE [dbo].[Orders]
IF OBJECT_ID('dbo.Goods') IS NOT NULL
    DROP TABLE [dbo].[Goods]
IF OBJECT_ID('dbo.Suppliers') IS NOT NULL
    DROP TABLE [dbo].[Suppliers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Creating Suppliers table
CREATE TABLE [dbo].[Suppliers](
	[Supplier_ID] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
    [PhoneNumber] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_Supplier_ID] PRIMARY KEY ([Supplier_ID])
) ON [PRIMARY] 
GO


-- Creating Goods table
CREATE TABLE [dbo].[Goods](
	[Good_ID] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
    [Shelf_ID] [int] NOT NULL,
    [Quantity] [int] NOT NULL,
    [Supplier_ID] [int] NOT NULL,
	CONSTRAINT [PK_Good_ID] PRIMARY KEY ([Good_ID]),
	CONSTRAINT [FK_Supplier_ID] FOREIGN KEY ([Supplier_ID])
		REFERENCES [dbo].[Suppliers]([Supplier_ID])
		ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [PRIMARY]
GO


-- Creating Orders table
CREATE TABLE [dbo].[Orders](
	[Order_ID] [int] NOT NULL,
	CONSTRAINT [PK_Order_ID] PRIMARY KEY ([Order_ID])
) ON [PRIMARY] 
GO


-- Creating Orders_Goods table
CREATE TABLE [dbo].[Orders_Goods](
	[Order_ID] [int] NOT NULL,
    [Good_ID] [int] NOT NULL,
    [GoodAmount] [int] NOT NULL,
	CONSTRAINT [PK_Order_ID_Good_ID] PRIMARY KEY ([Order_ID, Good_ID]),
	CONSTRAINT [FK_Order_ID] FOREIGN KEY ([Order_ID])
		REFERENCES [dbo].[Orders]([Order_ID])
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT [FK_Good_ID] FOREIGN KEY ([Good_ID])
		REFERENCES [dbo].[Goods]([Good_ID])
		ON DELETE CASCADE
        ON UPDATE CASCADE
) ON [PRIMARY] 
GO
