/*
 * Will Fraisl
 */

-- dropping tables
DROP VIEW IF EXISTS assoc_borders;
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
    ('Ontario','CAN',1076000),
    ('Quebec','CAN',1667000);

INSERT INTO city VALUES
    ('San Jose','California','US',1025000),
    ('San Francisco','California','US',870887),
    ('Los Angeles','California','US',3976000),
    ('Saratoga','California','US',30767),
    ('Los Gatos','California','US',30545),
    ('Kenmore','Washington','US',20460),
    ('Seattle','Washington','US',704352),
    ('Guadalajara','Jalisco','MEX',1495000),
    ('Toronto','Ontario','CAN',2809000),
    ('Kenmore','Ontario','CAN',501),
    ('Montreal','Quebec','CAN',1741000);

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

-- 1
/* The goal is to find provinces that contain cities that have a population greater than 1000
people and display their name and area. */
SELECT DISTINCT p.province_name, p.area
FROM province p JOIN city c ON (c.province = p.province_name)
WHERE c.population > 1000;

-- 2
/* Find 2 cities with the same name in different countries and show the city with the
greater population along with its country. */
SELECT c1.city_name, c1.country
FROM city c1 JOIN city c2 USING (city_name)
WHERE c1.country != c2.country AND c1.population > c2.population;

-- 3
/* Write an SQL query that finds the GDP, inflation, and total population of each country. Let a
country’s population be the total population of all cities in that country. */
SELECT c.country_name, c.gdp, c.inflation, SUM(ci.population)
FROM country c JOIN city ci ON (c.code = ci.country)
GROUP BY ci.country;

-- 4
/* Write an SQL query to find the name, area, and total population of provinces with a population
over 1,000,000 people. Let the population of a province be the total population of each city in the
province. */
SELECT p.province_name, p.area, SUM(c.population)
FROM province p JOIN city c ON (p.province_name = c.province)
GROUP BY c.province
HAVING SUM(c.population > 1000000);

-- 5
/* Write an SQL query that orders countries by their size in terms of the number of cities they
have. */
SELECT c.country_name, COUNT(*)
FROM country c JOIN city ci ON (c.code = ci.country)
GROUP BY ci.country
ORDER BY COUNT(*) DESC;

-- 6
/* Write an SQL query that orders countries by their total area. Let a country’s area be the sum
of each of its provinces’ areas. */
SELECT c.country_name, SUM(p.area)
FROM country c JOIN province p ON (c.code = p.country)
GROUP BY p.country
ORDER BY SUM(p.area) DESC;

-- 7
/* Write an SQL query that finds countries containing one or more provinces with at least 5 cities.
Your query should report the name of each country at most once. */
SELECT DISTINCT c.country_name
FROM country c JOIN city ci ON (c.code = ci.country)
GROUP BY ci.province
HAVING COUNT(*) >= 5;

-- 8
/* Write a view called assoc borders that “completes” the borders relation such that if a row (c1,
c2, len) is in borders, then both (c1, c2, len) and (c2, c1, len) is in assoc borders. In other
words, the assoc borders relation is the associative version of the borders relation. */
CREATE VIEW assoc_borders AS
(SELECT * FROM border)
UNION
(SELECT country2, country1, border_length
FROM border);

SELECT * FROM assoc_borders;

-- 9
/* Write an SQL query that finds for each country, the average GDP and inflation of each of its
bordering countries. Your query should return the countries ordered by (from lowest to highest)
the average GDP followed by the average inflation of their bordering countries. Note you should
use your assoc borders relation in your query. */
SELECT a.country1, AVG(c.gdp), AVG(c.inflation)
FROM assoc_borders a JOIN country c ON(a.country2 = c.code)
GROUP BY a.country1
ORDER BY AVG(c.gdp), AVG(c.inflation);