/* -- Data Cleaning, cleaning Maven Telecommunication Dataset 

   -- Querying database to validate the metadata in the data dictionary to make sure of
      data completeness, accuracy, consistency and overall data integrity.        */
   
   -- Checking for duplicate records --  

SELECT Customer_ID,
       COUNT(Customer_ID)
 FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
 GROUP BY Customer_ID
 HAVING COUNT(Customer_ID) > 1
 
 
 
 --  validating we only have two genders type in the Gender column  --

SELECT DISTINCT Gender
 FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` 
 
 
 
 -- validating data entries in the Married column --

SELECT DISTINCT Married
 FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` 
 
 
 
 -- validating data entries in the Contract column --

SELECT DISTINCT Contract
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- validating data entries in Phone Service column --

SELECT DISTINCT Phone_Service
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- validating data entries in Offer types column --

SELECT DISTINCT Offer
 FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` 
 
 
 
 /*-- validating data entries in  Multiple Lines column --
 
 IS NULL is one of the distincts input in multiple line column, need to update all NULL values to "No",
 since customer don't subcribe for phone service  */

SELECT DISTINCT Multiple_Lines
 FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` 
 
UPDATE `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
SET Multiple_Lines = FALSE
  WHERE Multiple_Lines IS NULL
  
  
  
  -- checking data entries in Internet_Type column --

SELECT DISTINCT Internet_Type
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- checking data entries in Payment_Method column --

SELECT DISTINCT Payment_Method
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- checking data entries in Customer_Status column --

SELECT DISTINCT Customer_Status
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- checking data entries in Churn_Category column --

SELECT DISTINCT Churn_Category
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  
  
  
  -- checking data entries in Average monthly GB download column --

SELECT Avg_Monthly_GB_Download
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` AS telecomm_data
  WHERE Internet_Service IS FALSE


/* All average monthly gb download for customer that didn't subcribe for internet service
return FALSE, according to the data dictionary should be 0 
 --Updating all NULL values in the Avg_Monthly_GB_Download to '0' */ 

 UPDATE `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
 SET Avg_Monthly_GB_Download = 0
 WHERE Internet_Service IS FALSE
 
 
 
 /*      -- Validating Total Revenue Calculation --
 
I calculated total revenue with the formula in the data dictionary and compare with
Total_Revenue column for accuracy */

-- creating a temporary table for self calculated total_revenue --

WITH Total_Revenue_Check AS 
(
SELECT Customer_ID, Total_Revenue,
ROUND(Total_Charges + Total_Extra_Data_Charges + Total_Long_Distance_Charges - Total_Refunds,2)  AS Total_Revenue_2
  FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`
  GROUP BY Customer_ID, Total_Revenue, Total_Charges,Total_Extra_Data_Charges,Total_Long_Distance_Charges,Total_Refunds
) 
SELECT churndata.Total_Revenue,
       Total_Revenue_Check.Total_Revenue_2
FROM Total_Revenue_Check
 INNER JOIN `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data` AS churndata
 ON Total_Revenue_Check.Customer_ID = churndata.Customer_ID
WHERE Total_Revenue_Check.Total_Revenue_2 != churndata.Total_Revenue
  
  
