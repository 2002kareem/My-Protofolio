CREATE DATABASE Telco_Churn_DB
GO

--   Number Of Columns in each Table
SELECT COUNT(*) AS Total_Fact_Records FROM [Fact Telco]
SELECT COUNT(*) AS Total_Customer_Records FROM [Dim Accounts]
SELECT COUNT(*) AS Total_Accounts_Records FROM [Dim Customer]
GO



-- Describe Of Customer Payment
SELECT
    AVG(MonthlyCharges) AS Avg_Monthly_Charges,
    MAX(MonthlyCharges) AS Max_Monthly_Charges,
    MIN(MonthlyCharges) AS Min_Monthly_Charges,
    AVG(Total_Charges) AS Avg_Total_Charges,
    AVG(tenure) AS Avg_Tenure_Months
FROM [Fact Telco]
GO



-- Number Of Churned Customers From Total Customers 
SELECT
    SUM(CASE WHEN Churn = 'True' THEN 1 ELSE 0 END) AS Total_Churned,
    COUNT(*) AS Total_Customers,
    (CAST(SUM(CASE WHEN Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) * 100 AS Churn_Rate_Percentage
FROM [Fact Telco]
GO



--Number Of Churned Customer By PaymentMethod
SELECT
    DC.PaymentMethod,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Count,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate
FROM [Fact Telco] FT
JOIN [Dim Customer] DC 
ON FT.customerID = DC.customerID
GROUP BY DC.PaymentMethod
ORDER BY Churn_Rate DESC
GO





-- Number Of Churned Customer By InternetService
SELECT
    DA.InternetService,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Count,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate
FROM [Fact Telco] FT
JOIN [Dim Accounts] DA 
ON FT.customerID = DA.customerID
GROUP BY DA.InternetService
ORDER BY Churn_Rate DESC
GO



--Avrage Tenure and Avrage Monthly Charges for Churned Customers and Still Customers
SELECT
    Churn,
    AVG(tenure) AS Avg_Tenure,
    AVG(MonthlyCharges) AS Avg_Monthly_Charges,
    COUNT(customerID) AS Customer_Count
FROM [Fact Telco]
GROUP BY Churn
GO






-- Churned By Age And Contract
SELECT
    DC.SeniorCitizen,
    DA.Contract,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Count,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate
FROM [Fact Telco] FT
JOIN [Dim Customer] DC 
ON FT.customerID = DC.customerID
JOIN [Dim Accounts] DA 
ON FT.customerID = DA.customerID
GROUP BY DC.SeniorCitizen, DA.Contract
ORDER BY DC.SeniorCitizen DESC, Churn_Rate DESC
GO


--Group By Tenure
SELECT
    CASE
        WHEN FT.tenure <= 6 THEN '0-6 Months'
        WHEN FT.tenure BETWEEN 7 AND 12 THEN '7-12 Months'
        WHEN FT.tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN FT.tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END AS Tenure_Group,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Count,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate_Percentage
FROM [Fact Telco] FT
GROUP BY
    CASE
        WHEN FT.tenure <= 6 THEN '0-6 Months'
        WHEN FT.tenure BETWEEN 7 AND 12 THEN '7-12 Months'
        WHEN FT.tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN FT.tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END
ORDER BY MIN(FT.tenure) 
GO



--Churned By Servces 
SELECT
    DA.InternetService,
    DA.OnlineSecurity,
    DA.TechSupport,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Customers,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate
FROM [Fact Telco] FT
JOIN [Dim Accounts] DA ON FT.customerID = DA.customerID
GROUP BY DA.InternetService, DA.OnlineSecurity, DA.TechSupport
ORDER BY Churn_Rate DESC
GO



--Total Lost Revenue By Churn
SELECT
    SUM(CASE WHEN Churn = 'True' THEN Total_Charges ELSE 0 END) AS Total_Revenue_Lost,
    SUM(CASE WHEN Churn = 'False' THEN Total_Charges ELSE 0 END) AS Total_Revenue_Retained,
    AVG(CASE WHEN Churn = 'True' THEN MonthlyCharges ELSE NULL END) AS Avg_Monthly_Charge_of_Churned
FROM [Fact Telco]
GO







--Seniors
SELECT
    DC.SeniorCitizen,
    DC.Partner,
    DC.Dependents,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Customers,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate
FROM [Fact Telco] FT
JOIN [Dim Customer] DC 
ON FT.customerID = DC.customerID
GROUP BY DC.SeniorCitizen, DC.Partner, DC.Dependents
ORDER BY DC.SeniorCitizen DESC, Churn_Rate DESC
GO



-- Service & Contract 
SELECT
    DA.InternetService,
    DA.Contract,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Customers,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate_Percentage,
    AVG(FT.MonthlyCharges) AS Avg_Monthly_Charges
FROM [Fact Telco] FT
JOIN [Dim Accounts] DA 
ON FT.customerID = DA.customerID
GROUP BY DA.InternetService, DA.Contract
ORDER BY DA.InternetService, Churn_Rate_Percentage DESC
GO





--Mony By Services
SELECT
    FT.Churn,
    DA.OnlineSecurity,
    DA.TechSupport,
    AVG(FT.MonthlyCharges) AS Avg_Monthly_Charges,
    AVG(FT.tenure) AS Avg_Tenure,
    COUNT(FT.customerID) AS Customer_Count
FROM [Fact Telco] FT
JOIN [Dim Accounts] DA 
ON FT.customerID = DA.customerID
GROUP BY FT.Churn, DA.OnlineSecurity, DA.TechSupport
ORDER BY FT.Churn DESC,
Avg_Monthly_Charges DESC
GO





-- Demographics & Payment_Method
SELECT
    DC.gender,
    DC.SeniorCitizen,
    DC.PaymentMethod,
    SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS Churned_Count,
    COUNT(FT.customerID) AS Total_Customers,
    (CAST(SUM(CASE WHEN FT.Churn = 'True' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(FT.customerID)) * 100 AS Churn_Rate_Percentage
FROM [Fact Telco] FT
JOIN [Dim Customer] DC 
ON FT.customerID = DC.customerID
GROUP BY DC.gender, DC.SeniorCitizen, DC.PaymentMethod
ORDER BY DC.SeniorCitizen DESC
, Churn_Rate_Percentage DESC
GO


--All Data
SELECT
    FT.customerID,
    FT.MonthlyCharges,
    FT.Total_Charges,
    FT.tenure,
    FT.Churn,
    DC.gender,
    DC.SeniorCitizen,
    DC.Partner,
    DC.Dependents,
    DC.PaymentMethod,
    DA.Contract,
    DA.InternetService,
    DA.OnlineSecurity,
    DA.TechSupport
FROM [Fact Telco] FT
JOIN [Dim Customer] DC 
ON FT.customerID = DC.customerID
JOIN [Dim Accounts] DA 
ON FT.customerID = DA.customerID
ORDER BY FT.customerID
GO