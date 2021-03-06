CREATE  [dbo].[Cart_GetAddonSales_ByLGProductId]
			@ProductId int
			,@StartDate datetime2(7)
			,@EndDate datetime2(7)

AS
/* TEST CODE

	DECLARE @ProductId int = 16
		,@StartDate datetime2(7) = '2016-01-11 00:00:00'
		,@EndDate datetime2(7) = '2016-12-31 23:59:59' 

	EXECUTE dbo.Cart_GetAddonSales_ByLGProductId
		@ProductId
		,@StartDate
		,@EndDate
*/
BEGIN

	SELECT SUM(c.Quantity) AS NumberOfSold, 
		   ph.HealthProductId, 
		   p.Title, 
		   p.ProductType, 
		   SUM(c.Quantity * p.BasePrice) AS TotalRevenue 
	FROM   dbo.Cart AS c 
		   INNER JOIN dbo.ProductHealthMap AS ph 
				   ON c.ProductId = ph.LGProductId
		   INNER JOIN dbo.Product AS p 
				   ON p.Id = ph.HealthProductId
	WHERE  c.CreatedDate BETWEEN @StartDate AND @EndDate 
		   AND c.ProductId = @ProductId 
	GROUP  BY p.Title, 
			  ph.HealthProductId, 
			  p.ProductType 

END
