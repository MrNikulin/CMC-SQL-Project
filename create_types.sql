USE [grocery_store]
GO

-- Type for store order's positions
IF EXISTS
   (SELECT [DOMAIN_NAME] FROM INFORMATION_SCHEMA.DOMAINS
    WHERE [DOMAIN_SCHEMA] = 'dbo' AND [DOMAIN_NAME] = 'orders_positions_t')
  EXEC sp_droptype [orders_positions_t]
GO

CREATE TYPE orders_positions_t AS TABLE (Order_ID int, Good_ID int, GoodAmount int);  
GO
