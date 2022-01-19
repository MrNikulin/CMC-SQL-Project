USE [grocery_store]
GO

BEGIN TRY
    BEGIN TRAN

	--EXEC ShowAllGoods
	--EXEC GoodsInStock
	--EXEC GoodsNotInStock
	--EXEC GoodsFromSupplier 103
	--EXEC InsertOrUpdateGood 111, 'American cheesecake', 4, 30, 100
	--EXEC InsertOrUpdateGood 111, 'American cheesecake', 4, 25, 100
	--EXEC DeleteFromGoods 111
	--EXEC InsertOrUpdateSupplier 105, 'OOO','Petrovka 4', '8-800-555-35-25' 
	--EXEC InsertOrUpdateSupplier 105, 'OOO','Nikolskaya 8', '8-800-555-35-25' 
	--EXEC DeleteFromSuppliers 105

    COMMIT TRAN
END TRY
BEGIN CATCH
    ROLLBACK TRAN
END CATCH
