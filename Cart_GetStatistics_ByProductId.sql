USE [C32_LashGirl]
GO
/****** Object:  StoredProcedure [dbo].[Cart_GetStatistics_ByProductId]    Script Date: 6/9/2017 1:06:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[Cart_GetStatistics_ByProductId]
			@ProductId int
			,@StartDate datetime2(7)
			,@EndDate datetime2(7)
AS

/* TEST CODE 

Declare @ProductId int = 16
			,@StartDate datetime2(7) = '2016-01-11 00:00:00'
			,@EndDate datetime2(7) = '2016-12-31 23:59:59' 

	EXECUTE dbo.Cart_GetStatistics_ByProductId
			@ProductId
			,@StartDate
			,@EndDate



*/

BEGIN
	SELECT SUM(c.Quantity) AS NumberOfSold
			,c.ProductId
			,p.Title
			,p.BasePrice
			,p.ProductType
			,SUM(c.Quantity * p.BasePrice) AS TotalRevenue
		FROM dbo.Cart AS c 
				INNER JOIN dbo.Product AS p 
					ON c.ProductId = p.Id 
		WHERE c.CreatedDate BETWEEN @StartDate AND @EndDate
			AND c.ProductId = @ProductId
			GROUP BY c.ProductId,p.Title,p.BasePrice,p.ProductType
			ORDER BY ProductType,NumberOfSold
END