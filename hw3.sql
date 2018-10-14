/*
 * Will Fraisl
 * hw3.sql
 */

 -- dropping tables
DROP TABLE IF EXISTS company_area;
DROP TABLE IF EXISTS funding;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS investors;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS company_info;

-- adding tables
CREATE TABLE company_info ( -- basic company information
	company_id INT UNSIGNED NOT NULL,   -- unique identifier of the company
	company_name CHAR(50) NOT NULL,     -- name of the company
	location CHAR(50),                  -- city where the company is based
	year_founded INT UNSIGNED,          -- year that the company was founded
	founder CHAR(50),                   -- name of the person who founded the company
	PRIMARY KEY (company_id)
) ENGINE = InnoDB;
CREATE TABLE company_area ( -- area that a company is part of eg. retail or mobile
	company_id INT UNSIGNED NOT NULL,   -- unique identifier of the company
	area CHAR(50),                      -- area that a company is part
	PRIMARY KEY (company_id, area),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE funding (  -- information of company's funding
	company_id INT UNSIGNED NOT NULL,   -- unique identifier of the company
	funding_stage CHAR(50),             -- funding stage eg. seed, series a
	funding_type CHAR(50),              -- eg. private, startup
	money_raised DECIMAL UNSIGNED,      -- dollar amount raised
	year_of_funding INT UNSIGNED,       -- year that the comapany was funded
	PRIMARY KEY (company_id, funding_stage, funding_type, money_raised, year_of_funding),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE employees (    -- all companies employee database
	company_id INT UNSIGNED NOT NULL,       -- unique identifier of the company
	employee_number INT UNSIGNED NOT NULL,  -- unique number of employee per company
	employee_name CHAR(50),                 -- name of employee
	title CHAR(50),                         -- title of position held by employee
	start_date DATE,                        -- date that employee started working
	end_date DATE,                          -- date that employee stopped working
	PRIMARY KEY (company_id, employee_number),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE investors (    -- information about investors of companies
	company_id INT UNSIGNED NOT NULL,               -- unique identifier of the company
	investor_name CHAR(50),                         -- name of investor or investor group
	year_of_investment INT UNSIGNED,                -- year that investment was made
	amount_invested DECIMAL UNSIGNED,               -- dollar amount inested
	investor_type ENUM('Individual','VC Firm'),     -- type of investment: Indiviual or VC Firm
	PRIMARY KEY (company_id, investor_name, year_of_investment),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE people (   -- all people in rest of database
	name CHAR(50),                  -- name of person
	school CHAR(50),                -- university that person attended
	degree_earned CHAR(50),         -- degree that they earned at university
	year_graduated INT UNSIGNED,    -- year that they graduated from university
	PRIMARY KEY (name)
) ENGINE = InnoDB;

-- filling database with values
INSERT INTO company_info VALUES
	(1,'Happy Company','Spokane',2001,'Joe Smith'),
	(2,'Sad Company','Seattle',2001,'Justin John'),
	(3,'Content Company','San Jose',2003,'Marcy Jim'),
	(4,'Joyful Company','Los Angeles',2015,'Joe Smith');
INSERT INTO company_area VALUES
	(1,'Retail'),
	(1,'Games'),
	(2,'Retail'),
	(2,'Advertising'),
	(3,'Mobile'),
    (4,'Other');
INSERT INTO funding VALUES
	(1,'Series C','Private',100.00,2010),
	(3,'Series C','Private',94.00,2008);
INSERT INTO employees VALUES
	(1,1,'Joe Smith','Software Engineer','2001-01-03','2006-03-07'),
	(4,345,'Joe Smith','President','2015-07-20',NULL),
	(2,583,'Steve Sanders','IT','2009-04-08',NULL),
	(2,573,'Alice Scott','CEO','2010-09-14',NULL),
	(2,969,'Susan Carter','Sales','2008-03-06','2013-07-02');
INSERT INTO investors VALUES
	(4,'XYZ Investors',2009,3.00,'VC Firm'),
    (4,'Big Investors',2013,100000000.00,'VC Firm'),
	(2,'Herb John',2011,49.00,'Individual'),
    (2,'Daisy Porter',2015,57.00,'Individual');
INSERT INTO people VALUES
	('Joe Smith','Gonzaga University','BS',2001),
	('Justin John','Gonzaga University','BA',2004),
	('Marcy Jim','Saint Marys','BS',1999),
	('Steve Sanders',NULL,NULL,NULL),
	('Alice Scott','LMU','BS',2005),
	('Susan Carter','LMU','BS',2002),
	('Herb John','BYU',NULL,NULL);

-- showing results of filling tables
/*
SHOW TABLES;
SELECT * FROM company_info;
SELECT * FROM company_area;
SELECT * FROM funding;
SELECT * FROM employees;
SELECT * FROM investors;
SELECT * FROM people;
*/

-- queries
-- 1
/* Find the name and location (US city) of all companies founded in a specific year. */
SELECT company_name, location
FROM company_info
WHERE year_founded = 2001;

-- 2
/* Find all companies in a particular area. An area is just a tag like “Retail”, “Mobile”, “Education”,
“Advertising”, “Games”, and so on. Note that any particular company can be
associated with one or more areas. */
SELECT i.company_name
FROM company_info i, company_area a
WHERE area = 'Retail'
    AND i.company_id = a.company_id;

-- 3
/* Find all of the companies that an individual has been a founder of. For each such company,
find the position they held as founder and the year they left the company (if they have left). */
SELECT i.company_name, e.title, e.end_date
FROM company_info i, employees e
WHERE i.founder = 'Joe Smith'
    AND i.company_id = e.company_id;

-- 4
/* Find all of the employees of a company within a range of years (e.g., between 2012 and 2016).
For each employee, find the employee’s name and the position they last held in the company. */
SELECT e.employee_name, e.title
FROM company_info i, employees e
WHERE i.company_id = e.company_id
    AND e.start_date < '2016-01-01'
    AND (e.end_date > '2012-01-01'
    OR e.end_date is NULL);

-- 5
/* Find the names of all the individuals stored in the database based on the name of the last
school they attended. For each individual, find their name and the last degree they earned
at the school. */
SELECT name, degree_earned
FROM people
WHERE school = 'Gonzaga University';

-- 6
/* For a particular company, find all of the individuals that have invested in the company and
the amount and year of the investments. */
SELECT i.investor_name, i.amount_invested, i.year_of_investment
FROM company_info c, investors i
WHERE c.company_name = 'Sad Company'
    AND c.company_id = i.company_id
    AND i.investor_type = 'Individual';

-- 7
/* For a particular company, find all of the companies (e.g., venture-capital firms) that have
invested in the company and the amount and year of the investments. */
SELECT i.investor_name, i.amount_invested, i.year_of_investment
FROM company_info c, investors i
WHERE c.company_name = 'Joyful Company'
    AND c.company_id = i.company_id
    AND i.investor_type = 'VC Firm';

-- 8
/* Find all of the areas of the companies that a particular individual has worked for. */
SELECT DISTINCT a.area
FROM company_info i, employees e, company_area a
WHERE e.employee_name = 'Joe Smith'
    AND e.company_id = i.company_id
    AND e.company_id = a.company_id;

-- 9
/* Find the names of all of the companies in at least two different areas. */
SELECT DISTINCT i.company_name
FROM company_info i, company_area a1, company_area a2
WHERE i.company_id = a1.company_id
    AND a1.company_id = a2.company_id
    AND a1.area != a2.area;

-- 10
/* Find pairs of employees that worked at the same company together. For each pair, give the
names of both employees and the name of the company they worked at together. */
SELECT DISTINCT e1.employee_name, e2.employee_name, i.company_name
FROM company_info i, employees e1, employees e2
WHERE e1.company_id = e2.company_id
    AND e1.company_id = i.company_id
    AND e1.employee_name < e2.employee_name;