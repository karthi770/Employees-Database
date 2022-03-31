USE employees;
#Task 1 No.of Male employees and female employees from the year 1990 to 2002
SELECT Year(d.from_date) AS calender_year, e.gender, COUNT(e.emp_no) AS no_of_employees
FROM t_employees e
JOIN
t_dept_emp d ON e.emp_no = d.emp_no
GROUP BY calender_year, e.gender
HAVING calender_year >='1990';

#Task 2 No.of Male managers and female managers from the year 1990 to 2002 and their active years
SELECT d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calender_year,
CASE
WHEN year(from_date) <= e.calender_year AND year(to_date) >= e.calender_year THEN '1'
ELSE '0'
END AS active
FROM
(SELECT Year(hire_date) AS calender_year
FROM t_employees
GROUP BY calender_year) e
CROSS JOIN
t_dept_manager dm
JOIN
t_departments d ON d.dept_no = dm.dept_no
JOIN
t_employees ee ON ee.emp_no = dm.emp_no
ORDER BY dm.emp_no, calender_year;

#Task 3 Average salary of Male employees vs female employees from the year 1990 to 2002
SELECT e.gender, d.dept_name, AVG(s.salary) AS salary, YEAR(s.from_date) AS calender_year 
FROM t_employees e
CROSS JOIN
t_departments d
JOIN
t_salaries s ON s.emp_no = e.emp_no
GROUP BY e.gender, d.dept_name, calender_year
HAVING calender_year <= '2002'
ORDER BY d.dept_name;

#Task 4 Average salary of Male employees and female employees within a salary range
DELIMITER $$ 
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT AVG(s.salary) AS Salary, e.gender, d.dept_name 
FROM
t_salaries s
JOIN
t_employees e ON e.emp_no = s.emp_no
JOIN
t_dept_emp de ON de.emp_no = e.emp_no
JOIN
t_departments d ON de.dept_no = d.dept_no
WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY e.gender, d.dept_no;
END $$
DELIMITER ;
CALL filter_salary (50000, 90000);
DROP PROCEDURE filter_salary;




