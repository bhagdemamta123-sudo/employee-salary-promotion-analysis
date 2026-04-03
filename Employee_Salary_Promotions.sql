CREATE TABLE employee_1(
employeenumber INT PRIMARY KEY,
age INT,
department VARCHAR(100),
education INT,
educationfield VARCHAR(100),
gender VARCHAR(20),
jobrole VARCHAR(100),
jobsatisfaction INT,
monthlyincome INT,
performancerating INT,
totalworkingyears INT,
yearsatcompany INT,
yearssincelastpromotion INT
);

SELECT * FROM employee_1;

-- import the data from CSV
COPY employee_1
FROM 'D:\SQL\HR-Employee-salary.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*) FROM employee_1;

--Data Cleaning
--Check Null Values
SELECT * FROM employee_1
WHERE employeenumber IS NULL
	OR age IS NULL
	OR department IS NULL
	OR monthlyincome IS NULL;

--Check duplicate value
SELECT employeenumber, COUNT(*)
FROM employee_1
GROUP BY employeenumber
HAVING COUNT(*)>1;

--Check Salary Outliers
SELECT MIN(monthlyincome), MAX(monthlyincome)
FROM employee_1;

--Standardize Text Values
SELECT DISTINCT department, EducationField
FROM employee_1;

--Check Promotion Year Values
SELECT * FROM employee_1
WHERE yearssincelastpromotion < 0;

-- Basic Analysis
--Count Total Employees
SELECT COUNT(*)
FROM employee_1;

--Average Salary
SELECT AVG(monthlyincome)
FROM employee_1;

--Salary by Department
SELECT department, 
AVG(monthlyincome) AS avg_salary
FROM employee_1
GROUP BY department
ORDER BY avg_salary DESC;

--Top 10 Highest Paid Employees
SELECT * FROM employee_1
ORDER BY monthlyincome DESC LIMIT 5;

--Employees Waiting Long for Promotion
SELECT * FROM employee_1
WHERE yearssincelastpromotion >= 5;

--Advance SQL Queries
--Salary Rank by department
SELECT employeenumber, department, monthlyincome,
RANK() OVER(PARTITION BY department ORDER BY monthlyincome DESC) 
AS salaryrank FROM employee_1;

--Promotion Gap Analysis
SELECT department,
AVG(yearssincelastpromotion) AS avgpromotionyear
FROM employee_1
GROUP BY department;

--Average Salary by Job Role
SELECT jobrole,
ROUND(AVG(monthlyincome),2) AS avgsalary
FROM employee_1
GROUP BY jobrole
ORDER BY avgsalary DESC;

--Employees Eligible for Promotion
SELECT employeenumber, jobrole, yearsatcompany, yearssincelastpromotion
FROM employee_1
WHERE yearsatcompany > 5
AND yearssincelastpromotion >= 3
ORDER BY yearssincelastpromotion DESC;

--Salary Difference from Department Average
SELECT employeenumber, department, monthlyincome,
AVG(monthlyincome) OVER(PARTITION BY department) AS salary_difference
FROM employee_1;

--Performance Rating Distribution
SELECT performancerating,
	COUNT(*) AS employee_count
FROM employee_1
GROUP BY performancerating 
ORDER BY performancerat

--Top 3 Highest Paid Employees in Each Department
SELECT * FROM (
	SELECT employeenumber, department, monthlyincome,
	ROW_NUMBER() OVER(PARTITION BY department ORDER BY monthlyincome DESC) AS rank 
	FROM employee_1
)t
WHERE rank <=3

--Salary Growth Potential Analysis
SELECT employeenumber, performancerating, monthlyincome
FROM employee_1
WHERE performancerating >= 4
AND monthlyincome< (
	SELECT AVG(monthlyincome) FROM employee_1 
) limit 3;