/*
 * Will Fraisl
 * Homework 10
 * 10/2/18
 */

-- dropping tables
DROP TABLE IF EXISTS border;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS province;
DROP TABLE IF EXISTS country;

-- creating tables
CREATE TABLE country
(
    -- basic country information
    code CHAR(50),
    -- short country code eg. US
    country_name CHAR(50),
    -- full country name
    gdp INT,
    -- gross domestic product per capita
    inflation DECIMAL(3,1),
    -- infation rates for country
    PRIMARY KEY (code)
)
Engine = InnoDB;

CREATE TABLE province
(
    -- basic province information
    province_name CHAR(50),
    -- name of the province
    country CHAR(50),
    -- country code that province is located in
    area INT,
    -- area in km^2 of province
    PRIMARY KEY (province_name, country),
    FOREIGN KEY (country) REFERENCES country(code)
)
Engine = InnoDB;

CREATE TABLE city
(
    -- information about a city
    city_name CHAR(50),
    -- name of city
    province CHAR(50),
    -- name of province that city is located in
    country CHAR(50),
    -- country code that city is located in
    population INT,
    -- population of city
    PRIMARY KEY (city_name, province, country),
    FOREIGN KEY (province, country) REFERENCES province(province_name, country)
)
Engine = InnoDB;

CREATE TABLE border
(
    -- information about a border between 2 countries
    country1 CHAR(50),
    -- first country code that shares border
    country2 CHAR(50),
    -- second country code that shares border
    border_length INT,
    -- length of border that country1 and country2 share in km
    PRIMARY KEY (country1, country2),
    FOREIGN KEY (country1) REFERENCES country(code),
    FOREIGN KEY (country2) REFERENCES country(code)
)
Engine = InnoDB;

-- filling tables
INSERT INTO country
VALUES
    ('US', 'United States of America', 57466, 1.9),
    ('MEX', 'Mexico', 8201, 4.5),
    ('CAN', 'Canada', 42157, 2.2);

INSERT INTO province
VALUES
    ('California', 'US', 423970),
    ('Washington', 'US', 184830),
    ('Jalisco', 'MEX', 78599),
    ('Ontario', 'CAN', 1076000);

INSERT INTO city
VALUES
    ('San Jose', 'California', 'US', 1025000),
    ('San Francisco', 'California', 'US', 870887),
    ('Los Angeles', 'California', 'US', 3976000),
    ('Seattle', 'Washington', 'US', 704352),
    ('Guadalajara', 'Jalisco', 'MEX', 1495000),
    ('Toronto', 'Ontario', 'CAN', 2809000);

INSERT INTO border
VALUES
    ('US', 'MEX', 3144),
    ('US', 'CAN', 8891);