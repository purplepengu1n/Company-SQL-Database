--Samantha Palmerton
--1/22/2024
--Company Database self-study project
--Creating a Company Database using MySQL to create the actual DB and using PopSQL to create the scheme, insert information, and run queries


CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT, --foreign key
    branch_id INT --foreign key
);

CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT, --foreign key
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL --put when creating foreign key
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
emp_id INT,
client_id INT,
total_sales INT,
PRIMARY KEY(emp_id, client_id),
FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
); --consists of a composite key since employee and client id are being used together

CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

--all tables created for the company database schema

--creating corporate branch employee info
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09'); --insert corporate branch

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100; --update david entry to say he works for the corporate branch

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

--creating scranton branch employee info
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL); --inserting manager of scranton branch

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06'); --inserting scranton branch info

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);
--inserted employee info for scranton branch


--creating stamford branch employee info
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL); --manager of stamford branch

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13'); --inserting actual stamford branch

UPDATE employee
SET branch_id = 3
WHERE emp_id - 106; 

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

--creating branch supplier info
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

--creating client table info
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

--creating works_with table info
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

--QUERIES:

--find all employees
SELECT *
FROM employee;

--find all clients
SELECT *
FROM client;

--find all employees ordered by salary descending
SELECT *
FROM employee
ORDER BY salary DESC;

--find all employees ordered by sex and then name
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

--find the first 5 employees in the table
SELECT * 
FROM employee
LIMIT 5;

--find first and last names of all employees
SELECT first_name, last_name
FROM employee;

--find the forename and surname of all employees (renaming columns)
SELECT first_name AS forename, last_name AS surname
FROM employee;

--using distinct to see distinct branch_ids that employees have (seeing particular values stored in a column)
SELECT DISTINCT branch_id
FROM employee;

--FUNCTIONS

--find the number of employees
SELECT COUNT(emp_id)
FROM employee;

--find the number of women employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';

--find the average of all men employee's salaries
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

--find the sum of all employee salaries to see how much the company spends on paying employees
SELECT SUM(salary)
FROM employee;

--find out how many men and women there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

--find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

--using wildcards and LIKE

--find any clients who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC'; --% means any characters that come before that and ends in LLC

--find any branch suppliers who are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%'; --matches if the supplier name has the word label in it somewhere

--find any employee born in october
SELECT *
FROM employee
WHERE birth_day LIKE '____-10%'; --the _ represents any single character, matches with any 4 characters, a hyphen, and 10

--find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

--union queries

--find a list of employee and branch names
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch;--shows a list of the employee names and the 3 branch names at the bottom

-- find a list of all clients & branch suppliers' names & branch ids
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

--find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

--using joins

INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL); --adding this to showcase the use of joins

--find all branches and the names of their managers using an inner join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

--using a right join
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

--using nested queries

--find names of all employees who have sold over 30k to a single client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);

--find all clients who are handled by the branch that michael manages, assume you know michael's ID
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
    LIMIT 1
);

--using triggers

--creating this table to illustrate triggers
CREATE TABLE trigger_test (
    message VARCHAR(100)
);

--this scripting for the trigger would go into MySQL since you cant set delimiters in PopSQL but I'll still be showing the trigger script here
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee 
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END $$
DELIMITER ; --changing the delimiter back
--this trigger would insert "added new employee" into the trigger test table every time a new entry is inserted into the employee table

--inserting new value in employee to cause the trigger
INSERT INTO employee 
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

--showing "added new employee" in the trigger_test table
SELECT * FROM trigger_test;

--using conditionals in a trigger script
--this also would go into MySQL
DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee 
    FOR EACH ROW BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES('added male employee');
        ELSEIF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES('added female employee');
        ELSE
            INSERT INTO trigger_test VALUES('added other employee');
        END IF;
    END $$
DELIMITER ; --changing the delimiter back 
--goes down the list of conditionals to insert data if one of the conditions is true

INSERT INTO employee 
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);
--inserting pam into employee

--will show "added female employee" into trigger_test
SELECT * FROM trigger_test;