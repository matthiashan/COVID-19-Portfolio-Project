-- Create the covid.cases table

CREATE TABLE `covid`.`cases` (
`iso_code` VARCHAR(45) DEFAULT NULL,
`continent` VARCHAR(45) NULL,
`location` VARCHAR(45) NULL,
`date` DATE NULL,
`population` BIGINT NULL,
`total_cases` BIGINT NULL,
`new_cases` INT NULL,
`new_cases_smoothed` FLOAT(10,3),
`total_deaths` INT NULL,
`new_deaths` INT NULL,
`new_deaths_smoothed` FLOAT(10,3),
`total_cases_per_million` FLOAT(10,3),
`new_cases_per_million` FLOAT(10,3),
`new_cases_smoothed_per_million` FLOAT(10,3),
`total_deaths_per_million`  FLOAT(10,3),
`new_deaths_per_million` FLOAT(10,3),
`new_deaths_smoothed_per_million` FLOAT(10,3),
`reproduction_rate` FLOAT(10,4),
`icu_patients` INT NULL,
`icu_patients_per_million` FLOAT(10,3),
`hosp_patients` INT NULL,
`hosp_patients_per_million` FLOAT(10,3),
`weekly_icu_admissions` INT NULL,
`weekly_icu_admissions_per_million` FLOAT(10,3),
`weekly_hosp_admissions` INT NULL,
`weekly_hosp_admissions_per_million` FLOAT(10,3));

-- 
set global local_infile = 1;
show global variables like 'local_infile';
show variables like 'secure_file_priv';

-- Load data into covid.cases table
LOAD DATA LOCAL INFILE '/Users/matty/Downloads/Data Analyst Portfolio Project/Project 1 - SQL Data Exploration/cases CLEAN.csv'
INTO TABLE covid.cases
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Create the covid.vaccinations table

CREATE TABLE `covid`.`vaccinations` (
`iso_code` VARCHAR(45) NULL,
`continent` VARCHAR(45) NULL,
`location` VARCHAR(45) NULL,
`date` DATE NULL,
`population` BIGINT NULL, 
`new_tests` INT NULL,
`total_tests` INT NULL,
`total_tests_per_thousand` FLOAT(10,5),
`new_tests_per_thousand` FLOAT(10,5),
`new_tests_smoothed` INT NULL,
`new_tests_smoothed_per_thousand` FLOAT(10,5),
`positive_rate` FLOAT(10,5),
`tests_per_case` FLOAT(12,6),
`tests_units` VARCHAR(45),
`total_vaccinations` BIGINT NULL,
`people_vaccinated` BIGINT NULL,
`people_fully_vaccinated` BIGINT NULL,
`total_boosters` INT NULL,
`new_vaccinations` INT NULL,
`new_vaccinations_smoothed` INT NULL,
`total_vaccinations_per_hundred` FLOAT(10,5),
`people_vaccinated_per_hundred` FLOAT(10,5),
`people_fully_vaccinated_per_hundred` FLOAT(10,5),
`total_boosters_per_hundred` FLOAT(10,5),
`new_vaccinations_smoothed_per_million` INT NULL,
`new_people_vaccinated_smoothed` INT NULL,
`new_people_vaccinated_smoothed_per_hundred`FLOAT(10,5));

-- Load data into covid.vaccinations table
LOAD DATA LOCAL INFILE '/Users/matty/Downloads/Data Analyst Portfolio Project/Project 1 - SQL Data Exploration/vaccinations CLEAN.csv'
INTO TABLE covid.vaccinations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;