USE product_sales
select count(*) from Product_data
select count(*) from product_sales
select count(*) from discount_data
SELECT * FROM Product_data
SELECT * FROM product_sales
SELECT * FROM discount_data
-----------------------------------------------------------------------
WITH CTE AS (
	SELECT 
		D.Product , 
		D.Category , 
		D.Brand , 
		D.Description , 
		D.Sale_Price , 
		D.Cost_Price , 
		D.Image_url , 
		S.Date , 
		S.Customer_Type , 
		S.Discount_Band , 
		S.Units_Sold ,
		(D.Sale_Price * S.Units_Sold) AS Revenue , 
		(D.Cost_Price * S.Units_Sold) AS Total_Cost , 
		FORMAT(S.Date , 'MMMM') AS Month , 
		FORMAT(S.Date , 'yyyy') AS Year , 
		FORMAT(S.Date , 'dd') AS Day
	FROM Product_data D
	JOIN product_sales S 
	ON D.Product_ID = S.Product
	)

SELECT * , 
(1 - DI.discount * 1.10/100) * C.Revenue  AS Discount_Revenue
FROM CTE C 
JOIN discount_data DI
ON C.discount_band = DI.Discount_Band	AND C.Month = DI.Month
