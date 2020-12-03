--*************************************************************************--
-- Title: Assignment07
-- Author: John Lor
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2020-12-2
--**************************************************************************--

/********************************* Questions and Answers *********************************/
-- Question 1 (5 pts): What function can you use to show a list of Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the product!

Select
	ProductName
	,FORMAT(UnitPrice, 'C', 'en-us') as UnitPrice
From vProducts
Order by ProductName
go
;

-- Question 2 (10 pts): What function can you use to show a list of Category and Product names, 
-- and the price of each product, with the price formatted as US dollars?
-- Order the result by the Category and Product!

Select
	CategoryName
	,ProductName
	,FORMAT(UnitPrice, 'C', 'en-us') as UnitPrice
From vCategories
	Inner Join vProducts
		on vCategories.CategoryID = vProducts.CategoryID
Order by
	CategoryName
	,ProductName
go
;

-- Question 3 (10 pts): What function can you use to show a list of Product names, 
-- each Inventory Date, and the Inventory Count, with the date formatted like "January, 2017?" 
-- Order the results by the Product, Date, and Count!

Select
	ProductName
	,DATENAME(MM, InventoryDate) + ', ' + DATENAME(YY, InventoryDate) as InventoryDate
	,[Count]
From vProducts
	Inner Join vInventories
		on vProducts.ProductID = vInventories.ProductID
Order by
	ProductName
	,CAST(InventoryDate as date)
	,[Count]
go
;

-- Question 4 (10 pts): How can you CREATE A VIEW called vProductInventories 
-- That shows a list of Product names, each Inventory Date, and the Inventory Count, 
-- with the date FORMATTED like January, 2017? Order the results by the Product, Date,
-- and Count!

Create View vProductInventories as
Select Top 100000
	ProductName
	,DATENAME(MM, InventoryDate) + ', ' + DATENAME(YY, InventoryDate) as InventoryDate
	,[Count]
From vProducts
	Inner Join vInventories
		on vProducts.ProductID = vInventories.ProductID
Order by
	ProductName
	,CAST(InventoryDate as date)
	,[Count]
go
;

Select * From vProductInventories;
go
;

-- Question 5 (15 pts): How can you CREATE A VIEW called vCategoryInventories 
-- that shows a list of Category names, Inventory Dates, 
-- and a TOTAL Inventory Count BY CATEGORY, with the date FORMATTED like January, 2017?

Create View vCategoryInventories as
Select Top 100000
	CategoryName
	,DATENAME(MM, InventoryDate) + ', ' + DATENAME(YY, InventoryDate) as InventoryDate
	,SUM([Count]) as CategoryCount
From vCategories
	Inner Join vProducts
		on vProducts.CategoryID = vCategories.CategoryID
	Inner Join vInventories
		on vProducts.ProductID = vInventories.ProductID
Group by
	CategoryName
	,InventoryDate
Order by
	CategoryName
	,CAST(InventoryDate as date)
go
;

Select * From vCategoryInventories;
go
;

-- Question 6 (10 pts): How can you CREATE ANOTHER VIEW called 
-- vProductInventoriesWithPreviousMonthCounts to show 
-- a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month
-- Count? Use a functions to set any null counts or 1996 counts to zero. Order the
-- results by the Product, Date, and Count. This new view must use your
-- vProductInventories view!

Create View vProductInventoriesWithPreviousMonthCounts as
Select Top 100000
	ProductName
	,InventoryDate
	,[Count]
	,PreviousMonthCount = IIF(InventoryDate Like ('January%'), 0, IsNull(Lag([Count]) Over (Order By ProductName, Year(InventoryDate)), 0) )
From vProductInventories
Order by
	ProductName, CAST(InventoryDate as date), [Count], PreviousMonthCount
go
;

Select * From vProductInventoriesWithPreviousMonthCounts;
go
;

-- Question 7 (15 pts): How can you CREATE one more VIEW 
-- called vProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month 
-- Count and a KPI that displays an increased count as 1, 
-- the same count as 0, and a decreased count as -1? Order the results by the Product, Date, and Count!

Create View vProductInventoriesWithPreviousMonthCountsWithKPIs as
Select Top 100000
	ProductName
	,InventoryDate
	,[Count]
	,PreviousMonthCount
	,KPI = Case
		When [Count] < PreviousMonthCount then -1
		When [Count] = PreviousMonthCount then 0
		When [Count] > PreviousMonthCount then 1
		End
From vProductInventoriesWithPreviousMonthCounts
Order by
	ProductName
	,CAST(InventoryDate as date)
	,[Count]
go
;

Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
go
;
-- Question 8 (25 pts): How can you CREATE a User Defined Function (UDF) 
-- called fProductInventoriesWithPreviousMonthCountsWithKPIs
-- to show a list of Product names, Inventory Dates, Inventory Count, the Previous Month
-- Count and a KPI that displays an increased count as 1, the same count as 0, and a
-- decreased count as -1 AND the result can show only KPIs with a value of either 1, 0,
-- or -1? This new function must use you
-- ProductInventoriesWithPreviousMonthCountsWithKPIs view!
-- Include an Order By clause in the function using this code: 
-- Year(Cast(v1.InventoryDate as Date))
-- and note what effect it has on the results.

Create Function fProductInventoriesWithPreviousMonthCountsWithKPIs (@KPIValue int)
Returns Table as
Return Select
	ProductName
	,InventoryDate
	,[Count]
	,PreviousMonthCount
	,KPI
From vProductInventoriesWithPreviousMonthCountsWithKPIs
Where KPI = @KPIValue
go
;

Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
go
;

/***************************************************************************************/