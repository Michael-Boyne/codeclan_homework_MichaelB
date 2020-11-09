-- 1. Are there any pay_details records lacking both a local_account_no and iban number? --

SELECT 
	local_account_no,
	iban
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;

-- 2. Get a table of employees first_name, last_name and country, ordered alphabetically 
-- first by country and then by last_name (put any NULLs last). --

SELECT 
	employees,
	first_name,
	last_name,
	country
FROM employees 
ORDER BY country ASC NULLS LAST, last_name ASC NULLS LAST;

-- 3. Find the details of the top ten highest paid employees in the corporation. --

SELECT *
FROM employees 
ORDER BY salary desc NULLS LAST
LIMIT(10);

-- 4. Find the first_name, last_name and salary of the lowest paid employee in Hungary. --

SELECT 
	first_name,
	last_name,
	salary,
	country
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST
LIMIT(1);

-- 5. Find all the details of any employees with a ‘yahoo’ email address? --

SELECT *
FROM employees 
WHERE email LIKE '%@yahoo%';


-- 6. Provide a breakdown of the numbers of employees enrolled, not enrolled, and with 
-- unknown enrollment status in the corporation pension scheme. --

SELECT 
	COUNT(id) AS num_emp, 
	pension_enrol 
FROM employees 
GROUP BY pension_enrol;

-- 7. What is the maximum salary among those employees in the ‘Engineering’ department
-- who work 1.0 full-time equivalent hours (fte_hours)? --

SELECT 
	MAX(salary)
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1.0;

-- 8. Get a table of country, number of employees in that country, and the average salary
-- of employees in that country for any countries in which more than 30 employees are 
-- based. Order the table by average salary descending. --

SELECT 
	country,
	Count(id) AS number_employees,
	AVG(salary)
	FROM employees
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY AVG(salary)DESC;

-- 9. Return a table containing each employees first_name, last_name, full-time equivalent 
-- hours (fte_hours), salary, and a new column effective_yearly_salary which should contain 
-- fte_hours multiplied by salary. --

SELECT
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_salary
FROM employees;

-- 10. Find the first name and last name of all employees who lack a local_tax_code. --

SELECT 
	e.first_name,
	e.last_name
FROM employees AS e LEFT JOIN pay_details AS p 
ON e.pay_detail_id = p.id 
WHERE local_tax_code IS NULL;

-- 11. The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours,
-- where charge_cost depends upon the team to which the employee belongs. Get a table showing 
-- expected_profit for each employee. --

SELECT 
	e.id,
	e.first_name,
	e.last_name,
	(48 * 35 * CAST(t.charge_cost AS INT) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t 
ON e.team_id = t.id 
ORDER BY e.last_name ASC NULLS LAST;

	
-- 12. [Tough] Get a list of the id, first_name, last_name, salary and fte_hours of employees in the
-- largest department. Add two extra columns showing the ratio of each employee’s salary to that 
-- department’s average salary, and each employee’s fte_hours to that department’s average fte_hours.

WITH bananas(department, avg_salary, avg_fte_hours) AS (
SELECT 
	department,
	AVG(salary) AS avg_salary,
	AVG(fte_hours) AS avg_fte_hours
FROM employees 
GROUP BY department 
ORDER BY COUNT(id) DESC NULLS LAST
LIMIT 1
)
SELECT 
	e.id, 
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours,
	(e.salary / b.avg_salary) AS salary_ratio,
	(e.fte_hours / b.avg_fte_hours) AS hours_ratio
FROM employees AS e CROSS JOIN bananas AS b
WHERE e.department = b.department;

-- OR

SELECT 
	id, 
	first_name, 
	last_name, 
	salary,
	fte_hours,
	department,
	salary/AVG(salary) OVER () AS ratio_avg_salary,
	fte_hours/AVG(fte_hours) OVER () AS ratio_fte_hours
FROM employees
WHERE department = (
	SELECT
	department
FROM employees 
GROUP BY department
ORDER BY COUNT(id) DESC
LIMIT 1);


-- 2 Extension Questions

-- 1. Return a table of those employee first_names shared by more than one employee,
-- together with a count of the number of times each first_name occurs. Omit employees
-- without a stored first_name from the table. Order the table descending by count, and
-- then alphabetically by first_name. --


-- 2. Have a look again at your table for core question 6. It will likely contain a blank cell
-- for the row relating to employees with ‘unknown’ pension enrollment status. This is 
-- ambiguous: it would be better if this cell contained ‘unknown’ or something similar. 
-- Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), 
-- or a CASE statement?

SELECT 
	COUNT(id) AS num_emp, 
	COALESCE(CAST(pension_enrol AS VARCHAR), NULL, 'unknown')
FROM employees 
GROUP BY pension_enrol;

-- 3. Find the first name, last name, email address and start date of all the employees
-- who are members of the ‘Equality and Diversity’ committee. Order the member employees 
-- by their length of service in the company, longest first.--

SELECT 
	e.first_name,
	e.last_name,
	e.email,
	e.start_date,
	ec.employee_id
FROM (employees_committees AS ec LEFT JOIN employees AS e 
ON ec.employee_id = e.id) 
LEFT JOIN committees AS c 
ON ec.committee_id = c.id 
WHERE c.name = 'Equality and Diversity'
ORDER BY e.start_date ASC NULLS LAST;













