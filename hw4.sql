/*
 * Will Fraisl
 * Homework 4
 * 10/2/18
 */

-- dropping tables
DROP TABLE IF EXISTS border;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS province;
DROP TABLE IF EXISTS country;

-- creating tables
CREATE TABLE country (  -- basic country information
    code CHAR(50),          -- short country code eg. US
    country_name CHAR(50),  -- full country name
    gdp INT,                -- gross domestic product per capita
    inflation DECIMAL(3,1),      -- infation rates for country
    PRIMARY KEY (code)
) Engine = InnoDB;

CREATE TABLE province ( -- basic province information
    province_name CHAR(50), -- name of the province
    country CHAR(50),       -- country code that province is located in
    area INT,               -- area in km^2 of province
    PRIMARY KEY (province_name, country),
    FOREIGN KEY (country) REFERENCES country(code) 
) Engine = InnoDB;

CREATE TABLE city ( -- information about a city
    city_name CHAR(50), -- name of city
    province CHAR(50),  -- name of province that city is located in
    country CHAR(50),   -- country code that city is located in
    population INT,     -- population of city
    PRIMARY KEY (city_name, province, country),
    FOREIGN KEY (province, country) REFERENCES province(province_name, country)
)Engine = InnoDB;

CREATE TABLE border (   -- information about a border between 2 countries
    country1 CHAR(50),  -- first country code that shares border
    country2 CHAR(50),  -- second country code that shares border
    border_length INT,  -- length of border that country1 and country2 share in km
    PRIMARY KEY (country1, country2),
    FOREIGN KEY (country1) REFERENCES country(code),
    FOREIGN KEY (country2) REFERENCES country(code)
) Engine = InnoDB;

-- filling tables
INSERT INTO country VALUES
    ('US','United States of America',57466,1.9),
    ('MEX','Mexico',8201,4.5),
    ('CAN','Canada',42157,2.2);

INSERT INTO province VALUES
    ('California','US',423970),
    ('Washington','US',184830),
    ('Jalisco','MEX',78599),
    ('Ontario','CAN',1076000);

INSERT INTO city VALUES
    ('San Jose','California','US',1025000),
    ('San Francisco','California','US',870887),
    ('Los Angeles','California','US',3976000),
    ('Seattle','Washington','US',704352),
    ('Guadalajara','Jalisco','MEX',1495000),
    ('Toronto','Ontario','CAN',2809000);

INSERT INTO border VALUES
    ('US','MEX',3144),
    ('US','CAN',8891);

-- showing tables
SHOW TABLES;
SELECT * FROM country;
SELECT * FROM province;
SELECT * FROM city;
SELECT * FROM border;

-- queries

-- 2
/* Write an SQL query that finds the names of all countries with low inflation and high gdp. You
can give specific values for these to fit your data. */
SET @high_gdp = 40000;
SET @low_inflation = 3.0;
SELECT country_name, inflation, gdp
FROM country
WHERE inflation < @low_inflation
    AND gdp > @high_gdp;

-- 3
/* Write an SQL query that finds the set of all province names and areas that have at least one
city with a population greater than 1000. */
SELECT p.province_name, p.area
FROM province p, city c
WHERE p.province_name = c.province
    AND p.country = c.country
    AND c.population > 1000;

-- 4
/* Write an SQL query that finds the total area of all of the provinces. */
SELECT SUM(area)
FROM province;

-- 5
/* Write an SQL query that finds the total area of the provinces within a specific country. You
choose which country. Note that you don’t need to define all provinces of the country you chose. */
SET @country = 'US';
SELECT p.province_name, p.area
FROM province p, country c
WHERE c.code = @country
    AND c.code = p.country;

-- 6
/* Write an SQL query that finds the mininim, maximum, and average of both gdp and inflation
of all countries in your database. */
SELECT MIN(gdp), MAX(gdp), AVG(gdp), MIN(inflation), MAX(inflation), AVG(inflation)
FROM country;

-- 7
/* Write an SQL query that finds the number of cities within a specific country. You choose which
country. Note that like for provinces, you don’t have to define all the cities within a country. */
SET @country = 'US';
SELECT COUNT(*)
FROM city c, country co
WHERE co.code = @country
    AND co.code = c.country;

-- 8
/* Write an SQL query that finds the number of countries that a specific country borders and its
corresponding average border length. You choose which country. */
SET @country = 'US';
SELECT COUNT(*), AVG(border_length)
FROM border
WHERE country1 = @country
    OR country2 = @country;


-- 9
/* Write an SQL query that finds the average population of cities that are within the same province
and country as a given city. Do not include the given city’s population in the average population
calculation. */
SET @city = 'San Jose';
SELECT AVG(c2.population)
FROM city c1, city c2
WHERE c1.city_name = @city
    AND c1.city_name != c2.city_name
    AND c1.province = c2.province
    AND c1.country = c2.country;

-- 10
/* Write an SQL query that finds the names of countries with both a lower gdp and higher inflation
rate than a country it borders. */
SELECT c1.country_name
FROM country c1, country c2, border b
WHERE c1.gdp < c2.gdp
    AND c1.inflation > c2.inflation
    AND (b.country1 = c1.code
    AND b.country2 = c2.code
    OR b.country1 = c2.code
    AND b.country2 = c1.code);