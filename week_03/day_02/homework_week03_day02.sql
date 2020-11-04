-- MVP

-- 1. Get a table of all employees details, together 
-- with their local_account_no and local_sort_code, if they have them. --

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS p 
ON e.pay_detail_id = p.id;


-- 2. Amend your query from question 1 above to also
-- return the name of the team that each employee belongs to.

SELECT 
	e.*,
	p.local_account_no,
	p.local_sort_code
FROM (employees AS e LEFT JOIN pay_details AS p 
ON e.pay_detail_id = p.id) 
LEFT JOIN teams AS t 
ON e.team_id = t.id;

-- 3. Find the first name, last name and team name of employees 
-- who are members of teams for which the charge cost is greater 
-- than 80. Order the employees alphabetically by last name.

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost 
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id 
WHERE CAST(t.charge_cost AS INT) > 80 
ORDER BY last_name;


-- 4. Breakdown the number of employees in each of the teams, 
-- including any teams without members. Order the table by increasing 
-- size of team.

SELECT 
	t.name AS team_name,
	COUNT(e.id) AS employee_number
FROM teams AS t LEFT JOIN employees AS e
ON t.id = e.team_id 
GROUP BY t.name;

-- 5. The effective_salary of an employee is defined as their fte_hours multiplied
-- by their salary. Get a table for each employee showing their id, first_name, last_name,
-- fte_hours, salary and effective_salary, along with a running total of effective_salary 
-- with employees placed in ascending order of effective_salary.
 
SELECT 
	e.id,
	e.first_name,
	e.last_name,
	e.fte_hours,
	e.salary,
	(e.fte_hours * e.salary) AS effective_salary,
	SUM(e.fte_hours * e.salary) OVER (ORDER BY e.fte_hours * e.salary) AS Running_total
FROM employees AS e;

-- 6. The total_day_charge of a team is defined as the charge_cost of the team multiplied by
-- the number of employees in the team. Calculate the total_day_charge for each team.

WITH blobs(id, team_name, num_per_team) AS (
SELECT
	t.id,
	t.name AS team_name,
	COUNT(e.id) OVER (PARTITION BY t.id) AS num_per_team
FROM teams AS t LEFT JOIN employees AS e
	ON t.id = e.team_id 
)
SELECT 
	t.name AS team_name,
	blobs.num_per_team,
	t.charge_cost,
	(CAST(t.charge_cost AS INT) * blobs.num_per_team) AS total_day_charge
FROM teams AS t LEFT JOIN blobs
	ON t.id = blobs.id
GROUP BY t.name, blobs.num_per_team, t.charge_cost;



-- 7. How would you amend your query from question 6 above to show only those
-- teams with a total_day_charge greater than 5000? --

WITH blobs(id, team_name, num_per_team) AS (
SELECT
	t.id,
	t.name AS team_name,
	COUNT(e.id) OVER (PARTITION BY t.id) AS num_per_team
FROM teams AS t LEFT JOIN employees AS e
	ON t.id = e.team_id 
)
SELECT 
	t.name AS team_name,
	blobs.num_per_team,
	t.charge_cost,
	(CAST(t.charge_cost AS INT) * blobs.num_per_team) AS total_day_charge
FROM teams AS t LEFT JOIN blobs
	ON t.id = blobs.id
GROUP BY t.name, blobs.num_per_team, t.charge_cost
HAVING (CAST(t.charge_cost AS INT) * blobs.num_per_team) > 5000;

	

	


	

	


