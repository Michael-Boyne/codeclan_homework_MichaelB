--- 1 MVP Questions ---

--- 1. Find all the employees who work in the ‘Human Resources’ department. ---

SELECT *
FROM employees 
WHERE department = 'Human Resources';

--- 2. Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department. ---

SELECT first_name,
	last_name,
	country 
FROM employees 
WHERE department = 'Legal';

--- 3. Count the number of employees based in Portugal. --- 

SELECT country,
	COUNT(id) AS num_employees
FROM employees
WHERE country = 'Portugal'
GROUP BY country;
	
	
--- 4. Count the number of employees based in either Portugal or Spain. ---

SELECT 
  COUNT(id) AS num_employees_Portugal_Spain
FROM employees
WHERE country IN ('Portugal', 'Spain')

--- 5. Count the number of pay_details records lacking a local_account_no. --- 

SELECT
	COUNT(id) 
FROM pay_details 
WHERE local_account_no IS NULL;

--- 6. Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last). ---

SELECT  
	first_name,
	last_name
FROM employees 
ORDER BY last_name DESC NULLS LAST;

--- 7. How many employees have a first_name beginning with ‘F’? ---

SELECT
	COUNT(id)
FROM employees 
WHERE first_name LIKE 'F%';

--- 8. Count the number of pension enrolled employees not based in either France or Germany. ---

SELECT
	COUNT(id)
FROM employees 
WHERE country NOT IN ('France', 'Germany') AND pension_enrol = TRUE


--- 9. Obtain a count by department of the employees who started work with the corporation in 2003. --- 

SELECT 
  department, 
  COUNT(id) AS num_employees_started_2003
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department
	
--- 10. Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours. ---
	
SELECT 
	department,
	fte_hours,
	COUNT(id) AS num_employees 
FROM employees 
WHERE fte_hours BETWEEN 0 AND 1
GROUP BY department, fte_hours
ORDER BY department ASC NULLS LAST, fte_hours ASC NULLS LAST;

--- 11. Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department. ---

SELECT department, 
	COUNT(id) AS num_employees_no_first
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY COUNT(id) DESC NULLS LAST, department ASC NULLS LAST;
	
--- 12. [Tough!] Find the proportion of employees in each department who are grade 1. ---

SELECT 
  department, 
  SUM(CAST(grade = '1' AS INT)) / CAST(COUNT(id) AS REAL) AS prop_grade_1 
FROM employees 
GROUP BY department;

--- Extension ---

--- 1. Do a count by year of the start_date of all employees, ordered most recent year last. ---

SELECT 
	department,
	
	

