-- Checking the tables to see if they imported correctly --
SELECT *
FROM covid.cases
WHERE continent IS NOT NULL -- Because where the continent is NULL, we get the continent appearing in the location field.
ORDER BY 3,4;
--
SELECT *
FROM covid.vaccinations
ORDER BY 3,4;


-- Select the data that we are going to use --
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid.cases
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Looking at Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) AS percentage_deaths
FROM covid.cases
WHERE continent IS NOT NULL;


-- Looking at Total Cases vs Total Deaths in Canada
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100, 2) AS percentage_deaths
FROM covid.cases
WHERE location like '%Canada%';
-- Shows the likelihood of dying from COVID-19 infection in Canada --


-- Looking at Total Cases vs. Population
SELECT location, date, total_cases, population, round((total_cases/population)*100, 2) AS casesperpopulation
FROM covid.cases
WHERE continent IS NOT NULL;


-- Looking at Total Cases vs. Total Population in Canada
SELECT location, date, total_cases, population, round((total_cases/population)*100, 2) AS Population_Canada
FROM covid.cases
WHERE location like '%Canada%';
-- As of early March 2022, 8.79% of the entire Canadian population has officially contracted COVID-19 --


-- Countries with the highest infection rates compared to the population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(round((total_cases/population)*100, 2)) AS infection_rate
FROM covid.cases
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infection_rate DESC;
-- We need to take the MAX aka the highest number of total cases in each country and the highest infection rate per country


-- Countries with the highest death count
SELECT location, MAX(total_deaths) as total_death_count
FROM covid.cases
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;


-- Countries with the highest death rates compared to the population
SELECT location, population, MAX(total_deaths) AS highest_death_count, MAX(round((total_deaths/population)*100, 2)) AS death_rate
FROM covid.cases
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_rate DESC;
-- Peru has the highest death rate from COVID-19 infections.


-- Breaking down the death count by continent
SELECT continent, MAX(total_deaths) as total_death_count
FROM covid.cases
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;
-- The issue here is that the continents only show the highest death count of the country within the continent that has the highest death count rather than all of the countries
SELECT location, MAX(total_deaths) as total_death_count
FROM covid.cases
WHERE continent IS NULL AND location NOT LIKE '%income%'
GROUP BY location
ORDER BY total_death_count DESC;
-- Remember that the location included the continents as well.  So we can select the location where the continent is null(and therefore will appear in the location field)
-- Income seems to be added to the location for some reason so we remove it using the NOT LIKE statement.


-- Global Numbers --
SELECT  date, 
		SUM(new_cases) AS totalnewcases, 
        SUM(new_deaths) AS totalnewdeaths, 
        round((SUM(new_deaths)/SUM(new_cases))*100,2) AS percentage_deaths
FROM covid.cases
WHERE continent IS NOT NULL
GROUP BY date;
-- This will give the total number of new cases and new deaths globally per day as well as the percentage of deaths related to cases on each particular day.

SELECT  SUM(new_cases) AS totalnewcases, 
        SUM(new_deaths) AS totalnewdeaths, 
        round((SUM(new_deaths)/SUM(new_cases))*100,2) AS percentage_deaths
FROM covid.cases
WHERE continent IS NOT NULL;
-- This will give the total number of cases, deaths and the percentage up to last recorded date.


-- Joining the two tables together --
SELECT *
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date;
 

-- Display New Vaccinations that are grouped by Country and Date
SELECT c.continent,
	   c.location,
       c.date,
       c.population,
       v.new_vaccinations
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date
WHERE c.continent IS NOT NULL AND c.location NOT LIKE '%income%';

-- Get the total number of vaccinations separated by country and date which is also the rolling count of new vaccinations
SELECT c.continent,
	   c.location,
       c.date,
       c.population,
       v.new_vaccinations,
       SUM(v.new_vaccinations) OVER(Partition by c.location ORDER BY c.location, c.date) AS rollingvaccinationcount-- This will give add the vaccinations from the previous day to the new total
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date
WHERE c.continent IS NOT NULL AND c.location NOT LIKE '%income%';

-- Get the number of people who are vaccinated in each country as well as the percentage of the population who are vaccinated using a CTE --
WITH PopvsVac (continent, location, date, population, new_vaccinations, rollingvaccinationcount)
AS
(
SELECT c.continent,
	   c.location,
       c.date,
       c.population,
       v.new_vaccinations,
       SUM(v.new_vaccinations) OVER(Partition by c.location ORDER BY c.location, c.date) AS rollingvaccinationcount
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date
WHERE c.continent IS NOT NULL AND c.location NOT LIKE '%income%'
ORDER BY 2, 3
)
SELECT *, (rollingvaccinationcount/population)*100
FROM PopvsVac;

-- Get the number of people who are vaccinated in each country as well as the percentage of the population who are vaccinated using a Temp Table --
DROP TABLE IF EXISTS PercentPopulationVaccinated;

CREATE TABLE PercentPopulationVaccinated
(
continent NVARCHAR(255),
location NVARCHAR(255),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
rollingvaccinationcount NUMERIC
);
INSERT INTO PercentPopulationVaccinated
SELECT c.continent,
	   c.location,
       c.date,
       c.population,
       v.new_vaccinations,
       SUM(v.new_vaccinations) OVER(Partition by c.location ORDER BY c.location, c.date) AS rollingvaccinationcount
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date
WHERE c.continent IS NOT NULL AND c.location NOT LIKE '%income%';

SELECT *, (rollingvaccinationcount/population)*100
FROM PercentPopulationVaccinated;


-- Create a view to store data for visualization --
CREATE VIEW PercentPopulationVaccinatedView AS
SELECT c.continent,
	   c.location,
       c.date,
       c.population,
       v.new_vaccinations,
       SUM(v.new_vaccinations) OVER(Partition by c.location ORDER BY c.location, c.date) AS rollingvaccinationcount
FROM covid.cases AS c
JOIN covid.vaccinations AS v
	ON c.location = v.location
    AND c.date = v.date
WHERE c.continent IS NOT NULL AND c.location NOT LIKE '%income%';

SELECT *
FROM percentpopulationvaccinatedview;
