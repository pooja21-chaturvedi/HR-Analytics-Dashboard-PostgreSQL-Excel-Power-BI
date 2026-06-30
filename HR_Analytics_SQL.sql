CREATE TABLE department (
    department_id VARCHAR(8) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE job (
    role_id VARCHAR(7) PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL
);

CREATE TABLE location (
    location_id VARCHAR(8) PRIMARY KEY,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
    employee_id VARCHAR(10) PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100)  NOT NULL,
    department_id VARCHAR(10) NOT NULL,
    role_id VARCHAR(10) NOT NULL,
    location_id VARCHAR(10) NOT NULL,

    CONSTRAINT fk_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id),

    CONSTRAINT fk_job
        FOREIGN KEY (role_id)
        REFERENCES job(role_id),

    CONSTRAINT fk_location
        FOREIGN KEY (location_id)
        REFERENCES location(location_id)
);

CREATE TABLE attendance (
    attendance_id VARCHAR(10) PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    attendance_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    working_hours DECIMAL(4,2),

    CONSTRAINT fk_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id)
);

CREATE TABLE performance (
    review_id VARCHAR(10) PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    review_date DATE NOT NULL,
    performance_rating DECIMAL(3,2) NOT NULL,
    bonus_percentage DECIMAL(5,2),

    CONSTRAINT fk_performance_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id)
);

CREATE TABLE sale (
    salary_record_id VARCHAR(10) PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    effective_date DATE NOT NULL,
    monthly_salary DECIMAL(10,2) NOT NULL,
    salary_hike_percentage DECIMAL(5,2),

    CONSTRAINT fk_salary_employee
        FOREIGN KEY (employee_id)
        REFERENCES employee(employee_id)
);

-- Employee Table
SELECT * FROM employee;

-- Department Table
SELECT * FROM department;

-- Job Table
SELECT * FROM job;

-- Location Table
SELECT * FROM location;

-- Attendance Table
SELECT * FROM attendance;

-- Performance Table
SELECT * FROM performance;

-- Sale Table
SELECT * FROM sale;

--Q1. Total Employees?
SELECT COUNT(*) AS total_employees
FROM employee;

--Q2. Employees in Each Department?
SELECT d.department_name,
COUNT(e.employee_id) AS total_employees
FROM department d
LEFT JOIN employee e
ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY total_employees DESC;

--Q3. Employees by Job Role?
SELECT j.role_name,
COUNT(*) AS total_employees
FROM employee e
JOIN job j
ON e.role_id = j.role_id
GROUP BY j.role_name
ORDER BY total_employees DESC;

--Q4. Employees by City?
SELECT l.city,
COUNT(*) AS total_employees
FROM employee e
JOIN location l
ON e.location_id=l.location_id
GROUP BY l.city
ORDER BY total_employees DESC;

--Q5. Average Sale by Department?
SELECT d.department_name,
ROUND(AVG(s.monthly_salary),2) AS avg_salary
FROM sale s
JOIN employee e
ON s.employee_id=e.employee_id
JOIN department d
ON e.department_id=d.department_id
GROUP BY d.department_name
ORDER BY avg_salary DESC;

--Q6. Highest Paid Employee?
SELECT e.employee_name,s.monthly_salary
FROM employee e
JOIN sale s
ON e.employee_id=s.employee_id
ORDER BY s.monthly_salary DESC
LIMIT 1;

--Q7. Top 10 Highest Paid Employees?
SELECT e.employee_name, s.monthly_salary
FROM employee e
JOIN sale s
ON e.employee_id=s.employee_id
ORDER BY s.monthly_salary DESC
LIMIT 10;

--Q8. Average Sale by Job Role?
SELECT j.role_name,
ROUND(AVG(s.monthly_salary),2) AS avg_salary
FROM sale s
JOIN employee e
ON s.employee_id=e.employee_id
JOIN job j
ON e.role_id=j.role_id
GROUP BY j.role_name
ORDER BY avg_salary DESC;

--Q9. Highest Sale by Department?
SELECT d.department_name,
MAX(s.monthly_salary) AS highest_salary
FROM sale s
JOIN employee e
ON s.employee_id=e.employee_id
JOIN department d
ON e.department_id=d.department_id
GROUP BY d.department_name;

-- Q10. What is the average performance rating by department?
SELECT d.department_name,
ROUND(AVG(p.performance_rating),2) AS avg_rating
FROM performance p
JOIN employee e
ON p.employee_id = e.employee_id
JOIN department d
ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_rating DESC;


-- Q11. Who are the Top 10 performers in the organization?
SELECT e.employee_name,p.performance_rating
FROM performance p
JOIN employee e
ON p.employee_id = e.employee_id
ORDER BY p.performance_rating DESC
LIMIT 10;


-- Q12. What is the average bonus percentage by department?
SELECT d.department_name,
ROUND(AVG(p.bonus_percentage),2) AS avg_bonus
FROM performance p
JOIN employee e
ON p.employee_id = e.employee_id
JOIN department d
ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_bonus DESC;


-- Q13. What is the attendance percentage of each employee?
SELECT e.employee_name,
ROUND(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2)
AS attendance_percentage
FROM attendance a
JOIN employee e
ON a.employee_id = e.employee_id
GROUP BY e.employee_name
ORDER BY attendance_percentage DESC;


-- Q14. Which employees have the lowest attendance percentage?
SELECT e.employee_name,
ROUND( SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0/ COUNT(*),2
    ) AS attendance_percentage
FROM attendance a
JOIN employee e
ON a.employee_id = e.employee_id
GROUP BY e.employee_name
ORDER BY attendance_percentage ASC
LIMIT 10;


-- Q15. What are the average working hours of employees?
SELECT
    ROUND(AVG(working_hours),2) AS average_working_hours
FROM attendance;


-- Q16. What are the average working hours by department?
SELECT d.department_name,
ROUND(AVG(a.working_hours),2) AS avg_working_hours
FROM attendance a
JOIN employee e
ON a.employee_id = e.employee_id
JOIN department d
ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_working_hours DESC;


-- Q17. Compare employee sale with performance rating.
SELECT e.employee_name, s.monthly_salary, p.performance_rating
FROM employee e
JOIN sale s
ON e.employee_id = s.employee_id
JOIN performance p
ON e.employee_id = p.employee_id
ORDER BY s.monthly_salary DESC;


-- Q18. Which employees received the highest bonus percentage?
SELECT e.employee_name, p.bonus_percentage
FROM performance p
JOIN employee e
ON p.employee_id = e.employee_id
ORDER BY p.bonus_percentage DESC
LIMIT 10;


-- Q19. What is the average salary by city?
SELECT l.city,
ROUND(AVG(s.monthly_salary),2) AS avg_salary
FROM sale s
JOIN employee e
ON s.employee_id = e.employee_id
JOIN location l
ON e.location_id = l.location_id
GROUP BY l.city
ORDER BY avg_salary DESC;


-- Q20. Which department has the highest average performance rating?
SELECT d.department_name,
ROUND(AVG(p.performance_rating),2) AS avg_rating
FROM performance p
JOIN employee e
ON p.employee_id = e.employee_id
JOIN department d
ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_rating DESC
LIMIT 1;


-- Q21. Rank employees based on their salary.
SELECT e.employee_name,s.monthly_salary,
 RANK() OVER (ORDER BY s.monthly_salary DESC) AS salary_rank
FROM employee e
JOIN sale s
ON e.employee_id = s.employee_id;


-- Q22. Rank employees based on performance rating.
SELECT e.employee_name, p.performance_rating,
DENSE_RANK() OVER (ORDER BY p.performance_rating DESC) AS performance_rank
FROM employee e
JOIN performance p
ON e.employee_id = p.employee_id;


-- Q23. Which employees earn above the company's average salary?
SELECT e.employee_name, s.monthly_salary
FROM employee e
JOIN sale s
ON e.employee_id = s.employee_id
WHERE s.monthly_salary >
(
    SELECT AVG(monthly_salary)
    FROM sale
)
ORDER BY s.monthly_salary DESC;


-- Q24. Which employees have more than one salary record?
SELECT employee_id,
COUNT(*) AS total_salary_records
FROM sale
GROUP BY employee_id
HAVING COUNT(*) > 1
ORDER BY total_salary_records DESC;


-- Q25. Generate a complete HR employee report.
SELECT e.employee_id,e.employee_name,d.department_name,j.role_name,
    l.city,s.monthly_salary,p.performance_rating,p.bonus_percentage
FROM employee e
JOIN department d
ON e.department_id = d.department_id
JOIN job j
ON e.role_id = j.role_id
JOIN location l
ON e.location_id = l.location_id
JOIN sale s
ON e.employee_id = s.employee_id
JOIN performance p
ON e.employee_id = p.employee_id
ORDER BY e.employee_name;
































   
