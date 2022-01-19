USE [grocery_store]

-- Deleting all old data
EXEC [dbo].[ClearTables]

SET NOCOUNT ON
GO

SET DATEFORMAT dmy
GO

INSERT INTO [dbo].[Suppliers] VALUES(100, 'Frau Brotchen', 'Veskovsky lane 4, Moscow', '8-499-251-43-91')
INSERT INTO [dbo].[Suppliers] VALUES(101, 'Daily bread', 'Nikolskaya street 8/1, Moscow', '8-495-966-14-10')
INSERT INTO [dbo].[Suppliers] VALUES(102, 'Zhuravlyovs little bakery', 'Avtozavodskaya 8, Moscow','8-800-775-36-25')
INSERT INTO [dbo].[Suppliers] VALUES(103, 'Konigsbacker', 'Stremyanny lane 26, Moscow', '8-965-127-17-57')
INSERT INTO [dbo].[Suppliers] VALUES(104, 'Bagel', 'Nikolskaya street 10, Moscow', '8-495-970-09-39')

INSERT INTO [dbo].[Goods] VALUES(100, 'Hungarian cheesecake', 1, 30, 100)
INSERT INTO [dbo].[Goods] VALUES(101, 'Snail with apple and strawberry', 1, 30, 100)
INSERT INTO [dbo].[Goods] VALUES(102, 'Honey cake', 1, 28, 101)
INSERT INTO [dbo].[Goods] VALUES(103, 'Achma with meat', 1, 29, 101)
INSERT INTO [dbo].[Goods] VALUES(104, 'Strudel with bacon', 2, 30, 102)
INSERT INTO [dbo].[Goods] VALUES(105, 'Pie with cranberries', 2, 37, 102)
INSERT INTO [dbo].[Goods] VALUES(106, 'Croissant with lemon', 2, 30, 103)
INSERT INTO [dbo].[Goods] VALUES(107, 'Apple Pie', 2, 35, 103)
INSERT INTO [dbo].[Goods] VALUES(108, 'Cheese Pie', 3, 32, 104)
INSERT INTO [dbo].[Goods] VALUES(109, 'Sand pretzel', 3, 0, 104)
INSERT INTO [dbo].[Goods] VALUES(110, 'Banana-curd horn', 3, 31, 104)

INSERT INTO [dbo].[Orders] VALUES(1)
INSERT INTO [dbo].[Orders] VALUES(2)
INSERT INTO [dbo].[Orders] VALUES(3)
INSERT INTO [dbo].[Orders] VALUES(4)
INSERT INTO [dbo].[Orders] VALUES(5)
INSERT INTO [dbo].[Orders] VALUES(6)
INSERT INTO [dbo].[Orders] VALUES(7)
INSERT INTO [dbo].[Orders] VALUES(8)
INSERT INTO [dbo].[Orders] VALUES(9)
INSERT INTO [dbo].[Orders] VALUES(10)
INSERT INTO [dbo].[Orders] VALUES(11)

INSERT INTO [dbo].[Orders_Goods] VALUES(1, 108, 1)
INSERT INTO [dbo].[Orders_Goods] VALUES(1, 105, 2)
INSERT INTO [dbo].[Orders_Goods] VALUES(2, 106, 1)
INSERT INTO [dbo].[Orders_Goods] VALUES(3, 103, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(4, 110, 5)
INSERT INTO [dbo].[Orders_Goods] VALUES(4, 108, 2)
INSERT INTO [dbo].[Orders_Goods] VALUES(4, 104, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(4, 107, 1)
INSERT INTO [dbo].[Orders_Goods] VALUES(5, 103, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(5, 104, 4)
INSERT INTO [dbo].[Orders_Goods] VALUES(5, 108, 1)
INSERT INTO [dbo].[Orders_Goods] VALUES(6, 102, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(6, 105, 5)
INSERT INTO [dbo].[Orders_Goods] VALUES(7, 107, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(8, 102, 3)
INSERT INTO [dbo].[Orders_Goods] VALUES(9, 107, 4)
INSERT INTO [dbo].[Orders_Goods] VALUES(10, 105, 2)
INSERT INTO [dbo].[Orders_Goods] VALUES(10, 102, 5)


SET NOCOUNT OFF
GO
