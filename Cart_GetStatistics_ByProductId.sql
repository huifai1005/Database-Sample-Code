CREATE PROC [dbo].[Cart_GetStatistics_ByProductId]
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
