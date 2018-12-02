DROP TABLE IF EXISTS employee;

CREATE TABLE employee(
    employee_id INT,
    salary INT,
    title VARCHAR(50),
    PRIMARY KEY (employee_id),
    INDEX (title, salary)
) Engine = InnoDB;