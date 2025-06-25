SELECT *
FROM [dbo].[BlinkIT_ Data]

--Updating 
UPDATE [BlinkIT_ Data]
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

--Total Sales by Year
SELECT CAST(SUM (Sales) / 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM [BlinkIT_ Data]
WHERE Outlet_Establishment_Year = 2022

-- Average Sales by Year
SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM [BlinkIT_ Data]
WHERE Outlet_Establishment_Year = 2022

--Total counts by Year
SELECT COUNT(*) AS Number_of_Items
FROM [dbo].[BlinkIT_ Data]
WHERE Outlet_Establishment_Year = 2022

--Average rating by Year
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM [dbo].[BlinkIT_ Data]

--Sales, Average, Rating by Item_Fat_Content
SELECT Item_Fat_Content, 
    CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)) AS Total_sales_thousands,
	CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	COUNT(*) AS Number_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM[dbo].[BlinkIT_ Data]
--WHERE Outlet_Establishment_Year = 2022
GROUP BY Item_Fat_Content
ORDER BY Total_sales_thousands DESC

--Sales, Average, Rating by Item_Type
SELECT TOP 5 Item_Type, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
	CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	COUNT(*) AS Number_of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM [dbo].[BlinkIT_ Data]
GROUP BY Item_Type
ORDER BY Total_sales DESC
 
 --Sales, Average, Rating by Outlet_Location_Type
SELECT Outlet_Location_Type,
   ISNULL([Low Fat], 0) AS Low_Fat,   --Column Generation
    ISNULL([Regular], 0) AS Regular
FROM
(
 SELECT Outlet_Location_Type, Item_Fat_Content,
      CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales
 FROM [dbo].[BlinkIT_ Data]
 GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS  SourceTable
PIVOT   --Transform Rows to Column nd Vice Versa
(
  SUM(Total_sales)
  FOR Item_Fat_Content IN ([Low Fat], [Regular])
)AS Pivot_Table
ORDER BY Outlet_Location_Type

--Sales, Average, Rating by Outlet_Establishment_Year
SELECT Outlet_Establishment_Year,
      CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
	  CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	  COUNT(*) AS Number_of_Items,
	  CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
 FROM [dbo].[BlinkIT_ Data]
 GROUP BY Outlet_Establishment_Year
 ORDER BY Outlet_Establishment_Year


 --Percentage of Sales by Outlet Size
SELECT Outlet_Size, 
   CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
   CAST((SUM(Sales) * 100/ SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM [dbo].[BlinkIT_ Data]
GROUP BY Outlet_Size
ORDER BY Outlet_Size DESC

--Sales by Outlet Location Type
SELECT Outlet_Location_Type,
      CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
	  CAST((SUM(Sales) * 100/ SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	  CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	  COUNT(*) AS Number_of_Items,
	  CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
 FROM [dbo].[BlinkIT_ Data]
 GROUP BY Outlet_Location_Type
 ORDER BY Outlet_Location_Type


 --Sales, Average, Rating Outlet Type
 SELECT Outlet_Type,
      CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_sales,
	  CAST((SUM(Sales) * 100/ SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	  CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	  COUNT(*) AS Number_of_Items,
	  CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
 FROM [dbo].[BlinkIT_ Data]
 GROUP BY Outlet_Type
 ORDER BY Total_sales DESC
