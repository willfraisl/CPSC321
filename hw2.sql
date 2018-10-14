/*
 * Will Fraisl
 * hw2.sql
 */
DROP TABLE IF EXISTS company_area;
DROP TABLE IF EXISTS funding;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS investors;
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS company_info;
CREATE TABLE company_info (
	company_id INT UNSIGNED NOT NULL,
	company_name CHAR(50) NOT NULL,
	location CHAR(50),
	year_founded INT UNSIGNED,
	founder CHAR(50),
	PRIMARY KEY (company_id)
) ENGINE = InnoDB;
CREATE TABLE company_area (
	company_id INT UNSIGNED NOT NULL,
	area CHAR(50),
	PRIMARY KEY (company_id, area),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE funding (
	company_id INT UNSIGNED NOT NULL,
	funding_stage CHAR(50),
	funding_type CHAR(50),
	money_raised DECIMAL UNSIGNED,
	year_of_funding INT UNSIGNED,
	PRIMARY KEY (company_id, funding_stage, funding_type, money_raised, year_of_funding),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE employees (
	company_id INT UNSIGNED NOT NULL,
	employee_number INT UNSIGNED NOT NULL,
	employee_name CHAR(50),
	title CHAR(50),
	start_date DATE,
	end_date DATE,
	PRIMARY KEY (company_id, employee_number),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE investors (
	company_id INT UNSIGNED NOT NULL,
	investor_name CHAR(50),
	year_of_investment INT UNSIGNED,
	amount_invested DECIMAL UNSIGNED,
	investor_type CHAR(50),
	PRIMARY KEY (company_id, investor_name, year_of_investment),
	FOREIGN KEY (company_id) REFERENCES company_info(company_id)
) ENGINE = InnoDB;
CREATE TABLE people (
	name CHAR(50),
	school CHAR(50),
	degree_earned CHAR(50),
	year_graduated INT UNSIGNED,
	PRIMARY KEY (name)
) ENGINE = InnoDB;
INSERT INTO company_info VALUES
	(1,'Happy Company','Spokane, WA',2001,'Joe Smith'),
	(2,'Sad Company','Seattle, WA',2001,'Justin John'),
	(3,'Content Company','San Jose, CA',2003,'Marcy Jim'),
	(4,'Joyful Company','Los Angeles',2015,'Joe Smith');
INSERT INTO company_area VALUES
	(1,'Retail'),
	(1,'Games'),
	(2,'Retail'),
	(2,'Advertising'),
	(3,'Mobile');
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
	(2,'XYZ Investors',2009,3.00,'VC Firm'),
	(2,'Herb John',2011,49.00,'Individual');
INSERT INTO people VALUES
	('Joe Smith','Gonzaga University','BS',2001),
	('Justin John','Gonzaga University','BA',2004),
	('Marcy Jim','Saint Marys','BS',1999),
	('Steve Sanders',NULL,NULL,NULL),
	('Alice Scott','LMU','BS',2005),
	('Susan Carter','LMU','BS',2002),
	('Herb John','BYU',NULL,NULL);
SHOW TABLES;
SELECT * FROM company_info;
SELECT * FROM company_area;
SELECT * FROM funding;
SELECT * FROM employees;
SELECT * FROM investors;
SELECT * FROM people;
