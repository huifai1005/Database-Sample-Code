DECLARE @UserId nvarchar(128),
  @Quantity int,
  @ProductId int,
  @ProductIds dbo.IntIdTable

DECLARE insert_cursor CURSOR FOR
SELECT
Id
FROM dbo.AspNetUsers

OPEN insert_cursor

FETCH NEXT FROM insert_cursor INTO @UserId

WHILE @@FETCH_STATUS = 0
BEGIN
FETCH NEXT FROM insert_cursor INTO @UserId

/*--------------------------assign a random address -----------------------------------*/
DECLARE @Line1 nvarchar(100),
    @Line2 nvarchar(100),
    @City nvarchar(100),
    @State nvarchar(2),
    @PostalCode int
DECLARE @AddressId int

SELECT TOP 1
@AddressId = Id,
@Line1 = Line1,
@Line2 = Line2,
@City = City,
@State = [State],
@PostalCode = PostalCode
FROM dbo.[Address]
ORDER BY NEWID()

/*insert into dbo.[Address] (Line1,Line2,City,[State],PostalCode,Active,CreatedBy,ModifiedBy) values(@Line1,@Line2,@City,@State,@PostalCode,1,@UserId,@UserId)
	set @AddressId = SCOPE_IDENTITY()*/

/*--------------------------assign a random frequency -----------------------------------*/

DECLARE @Frequency int = ABS(CHECKSUM(NEWID()) % 19) + 1 /* set a random frequency from 1-20 that a customer will shop */
FETCH NEXT FROM insert_cursor INTO @UserId

WHILE (@Frequency > 0)
BEGIN
SET @Frequency = @Frequency - 1

DECLARE @Date datetime2(7) = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 356), '2016-01-01')/*generate a random date*/
DECLARE @CartId int


/*each customer randomly picks one lash girl product of type 1*/
SELECT TOP 1
@ProductId = Id
FROM dbo.Product
WHERE ProductType = 1
AND IsDeleted = 0
ORDER BY NEWID()

SET @ProductId = 165

SET @Quantity = ABS(CHECKSUM(NEWID()) % 2) /*decide to buy or not*/

DECLARE @Cost decimal(18, 2)
SELECT
@Cost = BasePrice
FROM dbo.Product/*get current price*/
WHERE Id = @ProductId


/*if the customer decides to buy, continues to pick healthy products*/
IF (@Quantity = 1)
BEGIN

INSERT INTO dbo.Cart
  VALUES (@UserId, @ProductId, @Quantity, @Cost, @Date, @Date)
SET @CartId = SCOPE_IDENTITY()

INSERT INTO dbo.Cart_Address (CartId, AddressId)
  VALUES (@CartId, @AddressId)

DECLARE @buy int  /* random number of 0 or 1 that if the customer want to buy or not */

/*the customer randomly picks a first healthy product of type 2 with random quantity from 1-5*/
SELECT TOP 1
  @ProductId = Id
FROM dbo.Product
WHERE ProductType = 2
ORDER BY NEWID()

INSERT INTO @ProductIds ([Data])
  VALUES (@ProductId)/*insert the picked productId to prevent reselecting for the next product*/

SET @buy = ABS(CHECKSUM(NEWID()) % 2) /* random number of 0 or 1*/
SET @Quantity = (ABS(CHECKSUM(NEWID()) % 5) + 1) * @buy

SELECT
  @Cost = BasePrice
FROM dbo.Product
WHERE Id = @ProductId

IF (@Quantity > 0)
BEGIN
  INSERT INTO dbo.Cart
    VALUES (@UserId, @ProductId, @Quantity, @Cost, @Date, @Date)
  SET @CartId = SCOPE_IDENTITY()
  INSERT INTO dbo.Cart_Address (CartId, AddressId)
    VALUES (@CartId, @AddressId)
END


/*for second healthy product*/
SELECT TOP 1
  @ProductId = Id
FROM dbo.Product
WHERE ProductType = 2
AND Id NOT IN (SELECT
  [Data]
FROM @ProductIds)
ORDER BY NEWID()

INSERT INTO @ProductIds ([Data])
  VALUES (@ProductId)

SET @buy = ABS(CHECKSUM(NEWID()) % 2)
SET @Quantity = (ABS(CHECKSUM(NEWID()) % 5) + 1) * @buy

SELECT
  @Cost = BasePrice
FROM dbo.Product
WHERE Id = @ProductId


IF (@Quantity > 0)
BEGIN
  INSERT INTO dbo.Cart
    VALUES (@UserId, @ProductId, @Quantity, @Cost, @date, @date)
  SET @CartId = SCOPE_IDENTITY()
  INSERT INTO dbo.Cart_Address (CartId, AddressId)
    VALUES (@CartId, @AddressId)
END

/*for third healthy product*/
SELECT TOP 1
  @ProductId = Id
FROM dbo.Product
WHERE ProductType = 2
AND Id NOT IN (SELECT
  [Data]
FROM @ProductIds)
ORDER BY NEWID()

SET @buy = ABS(CHECKSUM(NEWID()) % 2)
SET @Quantity = (ABS(CHECKSUM(NEWID()) % 5) + 1) * @buy

SELECT
  @Cost = BasePrice
FROM dbo.Product
WHERE Id = @ProductId

IF (@Quantity > 0)
BEGIN
  INSERT INTO dbo.Cart
    VALUES (@UserId, @ProductId, @Quantity, @Cost, @date, @date)
  SET @CartId = SCOPE_IDENTITY()
  INSERT INTO dbo.Cart_Address (CartId, AddressId)
    VALUES (@CartId, @AddressId)
END

DELETE FROM @ProductIds

END
END
END

CLOSE insert_cursor
DEALLOCATE insert_cursor
