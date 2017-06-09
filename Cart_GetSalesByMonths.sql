CREATE PROC [dbo].[Cart_GetSalesByMonths]
			@ProductId int
			,@Year int

AS
/*  TEST  CODE
declare @ProductId int = 16
		,@Year int = 2017

execute dbo.Cart_GetSalesByMonths
		@ProductId
		,@Year
*/

BEGIN

		SELECT
		  ProductId,
		  NumberOfSales,
		  Revenue,
		  [Month],
		  [Year],
		  Title,
		  ProductType
		FROM 
		(SELECT
		  ProductId,
		  SUM(Quantity) AS NumberOfSales,
		  SUM(Cost) AS Revenue,
		  MONTH(CreatedDate) AS [Month],
		  YEAR(CreatedDate) AS [Year]
		FROM dbo.Cart
			WHERE ProductId = @ProductId
				AND YEAR(CreatedDate) = @Year
			GROUP BY ProductId,
				 MONTH(CreatedDate),
				 YEAR(CreatedDate)) AS sub
		INNER JOIN dbo.Product AS p
		  ON sub.ProductId = p.Id

END
