--What's a customer profile for a churned customer --

SELECT 
        CASE 
        WHEN Number_of_Dependents = 0 THEN 'Yes'
        ELSE 'No'
        END AS Dependents,
ROUND(COUNT(Number_of_Dependents) * 100 / SUM(COUNT(Number_of_Dependents)) OVER(), 1) AS churn_percentage

FROM `customer-churn-analysis-381016.maven_telecomm_data.telecom_customerchurn_data`

WHERE Customer_Status = "Churned"

GROUP BY Dependents