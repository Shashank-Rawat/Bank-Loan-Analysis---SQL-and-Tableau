use [Bank Loan DB]
go
----------------------------------------

Select * from Bank_loan_data
go

--**************************************
--Key Performance Indicators (KPIs)
--**************************************
-------------------------------------------------------------------------------------------------------------------------
-- Total Loan Applications.

select COUNT(id) as [Total Applications] from Bank_loan_data;
go

-- MTD Loan Applications.

select COUNT(id) as [Total Applications_MTD] from Bank_loan_data
where month(issue_date) = 12 and YEAR(issue_date) = 2021;
go

-- Month-over-month Loan Applications:
select COUNT(id) as [Total_Applications_Previous_month] from Bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date)= 11;
go

------------------------------------------------------------------------------------------------------------------------

-- Total Funded Amount:

select format(SUM(loan_amount),'$ #,##0','en-US') as [Total Funded Amount]  from Bank_loan_data
go

-- Month to date funded amount

select format(SUM(loan_amount),'$ #,##0','en-US') as [Total Funded Amount_MTD] from Bank_loan_data
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;
go

-- month over month funded amount:
SELECT 
    FORMAT(SUM(loan_amount), '$ #,##0', 'en-US') AS [Total Funded Amount (Previous_month)]
FROM 
    Bank_loan_data
WHERE 
    MONTH(issue_date) = 11 
    AND YEAR(issue_date) = 2021;
GO

------------------------------------------------------------------------------------------------------------------------
--Total Amount Received:

select FORMAT(sum(total_payment),'$ #,##0','en-US') as [Total Payment Recieved ] from bank_loan_data
go

-- Total Amount recieved MTD

select FORMAT(sum(total_payment),'$ #,##0','en-US') as [Total Payment Recieved MTD] from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 12
go

-- Total Amount Recieved MoM:
select FORMAT(sum(total_payment),'$ #,##0','en-US') as [Total Payment Recieved MoM] from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 11
go

------------------------------------------------------------------------------------------------------------------------
--Average Intrest Rate:

select ROUND(AVG(int_rate),4)*100 as [Average Interest Rate] from bank_loan_data
go

-- Average Interest Rate MTD: 

select ROUND(AVG(int_rate),4)*100as [Average Interest Rate MTD] from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 12
go

-- Average Interest Rate MoM:
select ROUND(AVG(int_rate),4)*100 as [Average Interest Rate MoM]  from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 11
go

------------------------------------------------------------------------------------------------------------------------
--Average Debt to intrest ratio:

select ROUND(AVG(dti),4)*100 as [Average DTI] from bank_loan_data
go

-- Average Debt to intrest ratio MTD: 

select ROUND(AVG(dti),4)*100  as [Average DTI MTD] from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 12
go

-- Average Debt to intrest ratio MoM:
select ROUND(AVG(dti),4)*100  as [Average DTI MoM]  from bank_loan_data
where YEAR(issue_date) = 2021 and MONTH(issue_date) = 11
go

----------------------------------------------------------------------------------------------------------------------------
--**************************************************************************************************************************
--Good Loans KPIs
--**************************************************************************************************************************
Select distinct loan_status from Bank_loan_data


-- Good Loan Application Percentage:
select ROUND(COUNT(case when loan_status ='Fully Paid' OR loan_status ='Current' then id end)*100 /count(id),4) as [Good Loan Application Percentage]
from Bank_loan_data;
go

-- Good laon Applications
select COUNT(id) as [Total Good Laon Applications] from Bank_loan_data
where loan_status= 'Fully Paid' or loan_status = 'Current'
go

-- Good Loan Funded Amount:
select Format((SUM(loan_amount)),'$ #,##0', 'es-Us') as [Total Amount Disburshed for Good Loans] from Bank_loan_data
where loan_status= 'Fully Paid' or loan_status = 'Current'
go

-- Good Loan Total Received Amount: 
select Format((SUM(loan_amount)),'$ #,##0', 'es-Us')  as [Total Amount Received for Good Loans] from Bank_loan_data
where loan_status= 'Fully Paid' or loan_status = 'Current'
go

--**************************************************************************************************************************
--Bad Loans KPIs
--**************************************************************************************************************************

-- Bad Loan Application Percentage:
select ROUND(COUNT(case when loan_status ='Charged Off' then id end)*100 /count(id),4) as [Bad Loan Application Percentage]
from Bank_loan_data;
go

-- Bad laon Applications
select COUNT(id) as [Total Bad Laon Applications] from Bank_loan_data
where loan_status= 'Charged Off';
go

-- Bad Loan Funded Amount:
select Format((SUM(loan_amount)),'$ #,##0', 'es-Us') as [Total Amount Disburshed for Bad Loans] from Bank_loan_data
where loan_status= 'Charged Off';
go

-- Bad Loan Total Received Amount: 
select Format((SUM(loan_amount)),'$ #,##0', 'es-Us') as [Total Amount Received for Bad Loans] from Bank_loan_data
where loan_status= 'Charged Off';
go


--------------------------------------------------------------------------------------------------------------------------
--**************************************************************************************************************************
--                LOAN STATUS: 
--**************************************************************************************************************************
-- Loan Status Analysis
SELECT
        loan_status,
        COUNT(id) AS [Total Loan Application],
        SUM(total_payment) AS [Total Amount Received],
        SUM(loan_amount) AS [Total Amount Disbursed],
        AVG(int_rate * 100) AS [Interest Rate],
        AVG(dti * 100) AS DTI
    FROM
        bank_loan_data
    GROUP BY
        loan_status
	go

--MTD Loan status Analysis
SELECT 
	loan_status, 
	SUM(total_payment) AS [MTD Total Amount Received], 
	SUM(loan_amount) AS [MTD Total Amount Disbursed]
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status
go


--------------------------------------------------------------------------------------------------------------------------
--**************************************************************************************************************************
--                BANK LOAN REPORT/ OVERVIEW: 
--**************************************************************************************************************************
--Monthly overview. 
SELECT 
	MONTH(issue_date) AS [Month Number], 
	DATENAME(MONTH, issue_date) AS [Month name], 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)
go


--Statewise Overview:
SELECT 
	address_state AS State, 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state
go

--term wise overview: 
SELECT 
	term AS Term, 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY term
ORDER BY term
go

-- Employee Length wise Overview:
SELECT 
	emp_length AS [Employee Length], 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length
go

--	Purpose wise Overview: 
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose
go

-- Home ownership Overview:
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS [Total Loan Applications],
	SUM(loan_amount) AS [Total Funded Amount],
	SUM(total_payment) AS [Total Amount Received]
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership
go

--



