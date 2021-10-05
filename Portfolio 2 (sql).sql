use [AdventureWorks2012]

-- Task 1: Retrieve information about the products with color values except null, Red, silver/black, white and 
--list price between £75 and £750. Rename the column StandardCost to price. Also, sort the result in descending 
--order by list price 
			--SOLUTION
SELECT 
[Name],
[Color],
[StandardCost] AS PRICE,
[ListPrice]
FROM 
[Production].[Product]
WHERE [Color] NOT IN ( 'NULL','RED','SILVER/BLACK','WHITE')
AND  [ListPrice] BETWEEN 75 AND 750
ORDER BY 4 DESC


-- TASK 2: Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and 
--female employees born between 1972 and 1975 and hire date between 2001 and 2002. 
			-- SOLUTION
SELECT
[JobTitle],
[BirthDate],
[Gender],
[HireDate]
FROM [HumanResources].[Employee]
WHERE [Gender] = 'M'
AND YEAR([BirthDate]) BETWEEN 1962 AND 1970
AND YEAR([HireDate]) > 2001
OR
[Gender] = 'F' AND YEAR([BirthDate]) BETWEEN 1972 AND 1975
AND YEAR([HireDate]) BETWEEN 2001 AND 2002


-- TASK 3: Create a list of 10 most expensive products that have a product number beginning with ‘BK’. 
--Include only the product ID, Name and colour.
				-- SOLUTION
SELECT TOP 10
[ProductID],
[Name],
[ProductNumber],
[Color]
FROM [Production].[Product]
WHERE [ProductNumber] LIKE ('BK%')

--Question 4: Create a list of all contact persons, where the first 4 characters of the last name are the same as 
--the first four characters of the email address. Also, for all contacts whose first name and the last name begin with 
--the same characters, create a new column called full name combining first name and the last name only. Also 
--provide the length of the new column full name. 
					--SOLUTION

SELECT 
P.[FirstName],
P.[LastName],
E.[EmailAddress],

CONCAT([FirstName],' ', [LastName]) AS FULL_NAME,
LEN([FirstName]+[LastName]) AS NAME_LENGTH

FROM [Person].[Person] AS P
INNER JOIN
[Person].[EmailAddress] AS E
ON
P.BusinessEntityID
= E.BusinessEntityID

WHERE 
LEFT([LastName],4) = LEFT([EmailAddressID],4)
AND 
LEFT([FirstName],1) = LEFT([LastName],1);


-- TASK 5: Return all product subcategories that take an average of 3 days or longer to manufacture
					-- SOLUTION
SELECT 

AVG([DaysToManufacture]) AS AVERAGE_DAYSTOMANUFACTURE
FROM [Production].[Product] AS PP
HAVING
AVG([DaysToManufacture]) >= 3


-- TASK 6: Create a list of product segmentation by defining criteria that places each item in a predefined 
--segment as follows. If price gets less than £200 then low value. If price is between £201 and £750 then mid 
--value. If between £750 and £1250 then mid to high value else higher value. Filter the results only for black, silver 
--and red color products
							--SOLUTION
SELECT
[Name],
[Size],
[Color],
[ListPrice],
CASE
			WHEN [ListPrice] <= 200 THEN 'LOW_VALUE'
			WHEN [ListPrice] BETWEEN 201 AND 750 THEN 'MID_VALUE'
			WHEN [ListPrice] BETWEEN 751 AND 1250 THEN 'MIDTO_HIGHVALUE'
			ELSE 'HIGHER_VALUE'
		END AS 'PRICE_SEGMENTATION'
FROM [Production].[Product]
				WHERE [Color] IN ('BLACK','SILVER','RED')
				ORDER BY 4 DESC

-- TASK 7: How many Distinct Job title are present in the Employee table
				--SOLUTION
SELECT COUNT (DISTINCT[JobTitle]) AS UNIQUE_JOBTITLE
FROM [HumanResources].[Employee]

-- TASK 8: Use employee table and calculate the ages of each employee at the time of hiring
					--SOLUTION
SELECT 
[Gender],
[MaritalStatus],
[BirthDate],
[HireDate],
DATEDIFF(YEAR,[BirthDate],[HireDate]) AS AGE@EMPLOYMENT
FROM [HumanResources].[Employee]

-- TASK 9: How many employees will be due a long service award in the next 5 years, if long service is 20 years? 
				--SOLUTION
SELECT
COUNT(DATEDIFF(YY,[HireDate],DATEADD(YY,5,GETDATE()))) AS LONG_SERVICEAWARD
FROM [HumanResources].[Employee]
WHERE (DATEDIFF(YY,[HireDate],DATEADD(YY,5,GETDATE()))) >=20

-- TASK 10: How many more years does each employee have to work before reaching retirement, if retirement age is 65?
				         -- SOLUTION
SELECT
[JobTitle],
65-DATEDIFF(YY,[BirthDate],GETDATE()) AS AGE_LEFT_TO_WORK
FROM 
[HumanResources].[Employee]
WHERE 
65-DATEDIFF(YY,[BirthDate],GETDATE()) > 0


--TASK 11: Implement new price policy on the product table base on the colour of the item If white increase 
--price by 8%, If yellow reduce price by 7.5%, If black increase price by 17.2% . If multi, silver, silver/black or blue 
--take the square root of the price and double the value. Column should be called Newprice. For each item, also 
--calculate commission as 37.5% of newly computed list price.
								-- SOLUTION
SELECT 
[Name],
[Color],
[ListPrice],
CASE			
		WHEN [Color] = 'WHITE' THEN CAST([ListPrice]*1.08 AS DECIMAL(18,3))
		WHEN [Color] = 'YELLOW' THEN CAST( [ListPrice]*0.925 AS DECIMAL(18,3))
		WHEN [Color] = 'BLACK' THEN CAST( [ListPrice]* 1.172 AS DECIMAL(18,3))
		WHEN [Color] IN ('MULTI','SILVER','SILVER/BLACK','BLUE') THEN
		CAST(SQRT([ListPrice])*2 AS DECIMAL(18,3))
		ELSE [ListPrice]
		END AS NEWPRICE,

CASE
		
		WHEN [Color] = 'WHITE' THEN CAST([ListPrice]*1.08 *0.375 AS DECIMAL(18,3))
		WHEN [Color] = 'YELLOW' THEN CAST( [ListPrice]*0.925 *0.375 AS DECIMAL(18,3))
		WHEN [Color] = 'BLACK' THEN CAST( [ListPrice]* 1.172 *0.375 AS DECIMAL(18,3))
		WHEN [Color] IN ('MULTI','SILVER','SILVER/BLACK','BLUE') THEN
		CAST(SQRT([ListPrice])*2 *0.375 AS DECIMAL(18,3))
		ELSE CAST([ListPrice] * 0.375 AS DECIMAL(18,3))
		END AS NEWCOMMISSION

		FROM [Production].[Product]
		WHERE [Color] IS NOT NULL

--TASK 12: Print the information about all the Sales.Person and their sales quota. For every Sales person you 
--should provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work
					--SOLUTION
SELECT 
[FirstName]+' '+ [LastName] AS SALES_PERSON,
[HireDate],
[SickLeaveHours],
[CountryRegionCode],
[SalesQuota]
FROM [Sales].[SalesPerson] AS S
INNER JOIN
[Person].[Person] AS P
ON P.BusinessEntityID 
= S.BusinessEntityID

INNER JOIN
[HumanResources].[Employee] AS H
ON S.BusinessEntityID
=H.BusinessEntityID

LEFT JOIN
[Sales].[SalesTerritory] AS T
ON
T.TerritoryID
=S.TerritoryID

-- TASK 13: Using adventure works, write a query to extract the following information: Product name • Product 
--category name • Product subcategory name • Sales person • Revenue • Month of transaction • Quarter of 
--transaction • Region
				--SOLUTION
SELECT Product.Name AS [ProductName],
 ProductCategory.Name AS [ProductCategory],
 ProductSubcategory.Name AS [ProductSubcategory],
 CONCAT(FirstName, ' ', LastName) AS [SalesPersonName],
 LineTotal AS [Revenue],
 DATENAME(mm,OrderDate) AS [MonthOfTransaction],
 DATEPART(qq,OrderDate) AS [QuarterOfTransaction],
 CASE
 WHEN UPPER(SalesTerritory.Name) = UPPER(CountryRegion.Name)
THEN CountryRegion.Name
 ELSE CONCAT(SalesTerritory.Name, ' of ', CountryRegion.Name)
 END AS [SalesRegion]
FROM Sales.SalesOrderHeader
 INNER JOIN Sales.SalesOrderDetail
 ON Sales.SalesOrderHeader.SalesOrderID
 = Sales.SalesOrderDetail.SalesOrderID
 INNER JOIN Production.Product
 ON Sales.SalesOrderDetail.ProductID
 = Production.Product.ProductID
 LEFT JOIN Production.ProductSubcategory
 ON Production.Product.ProductSubcategoryID
 = Production.ProductSubcategory.ProductSubcategoryID
 LEFT JOIN Production.ProductCategory
 ON Production.ProductSubcategory.ProductCategoryID
 = Production.ProductCategory.ProductCategoryID
 INNER JOIN Person.Person
 ON Sales.SalesOrderHeader.SalesPersonID
 = Person.Person.BusinessEntityID
 INNER JOIN Sales.SalesTerritory
 ON Sales.SalesOrderHeader.TerritoryID
 = Sales.SalesTerritory.TerritoryID
 INNER JOIN Person.CountryRegion
 ON Sales.SalesTerritory.CountryRegionCode
 = Person.CountryRegion.CountryRegionCode;

 -- TASK 14: Display the information about the details of an order i.e. order number, order date, amount of order, 
--which customer gives the order and which salesman works for that customer and how much commission he gets 
--for an order.
					--SOLUTION
SELECT
A.SalesOrderID,
A.OrderDate,
A.TotalDue,
OnlineOrderFlag,
C.Name AS CustomerName,
FirstName + ' ' + LastName AS SalesPerson

FROM Sales.SalesOrderHeader AS A
LEFT JOIN 
Sales.Customer AS B
ON B.CustomerID 
= A.CustomerID

LEFT JOIN 
Sales.Store AS C
ON B.StoreID 
= C.BusinessEntityID

LEFT JOIN
Person.Person AS D
ON D.BusinessEntityID 
= A.SalesPersonID

-- TASK 15: For all the products calculate • Commission as 14.790% of standard cost, • Margin, if standard 
--cost is increased or decreased as follows: o Black: +22%, o Red: -12% o Silver: +15% o Multi: +5% o White: Two 
--times original cost divided by the square root of cost o For other colors, standard cost remains the same
				-- SOLUTION

SELECT
[Name],
[Color],
[StandardCost],
ListPrice,
CAST([StandardCost]*0.14790 AS DECIMAL(18,2)) AS Commission
,CASE
		WHEN [Color]='Black' THEN Listprice-([StandardCost]*1.22)
		WHEN [Color]='Red' THEN Listprice-([StandardCost] * 0.88)
		WHEN [Color]='Silver' THEN Listprice-
([StandardCost]*1.15)
		WHEN [Color]='Multi' THEN Listprice-([StandardCost]*0.05)
		WHEN [Color]='White' THEN Listprice-
(([StandardCost]*2)/(SQRT([StandardCost]*0.14790)))
ELSE [StandardCost]
END AS 'Margin'
FROM[Production].[Product]
WHERE Standardcost <> 0;