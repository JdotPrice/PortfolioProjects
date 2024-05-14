--View for rolling deaths per case, all countries

CREATE VIEW [dbo].[Rolling_Country_Death_Rates]
AS
SELECT location AS Country
	   , Date
	   , total_cases AS [Cases to Date]
	   , total_deaths AS [Deaths to Date]
	   , CAST(ROUND(total_deaths * 1.0 / total_cases * 100, 3) AS DECIMAL(10, 3)) AS [Death Rate to Date]
FROM dbo.Covid_Data
WHERE (continent IS NOT NULL)

--View for rolling infections against population, all countries

CREATE VIEW [dbo].[Rolling_Country_Infection_Rate]
AS
SELECT location AS Country
	   , Date
	   , Population
	   , total_cases AS [Cases to Date]
	   , CAST(ROUND(total_cases * 1.0 / population * 100, 3) AS DECIMAL(10, 3)) AS [Infection Rate to Date]
FROM dbo.Covid_Data
WHERE (continent IS NOT NULL)

--View for total infection and death rates by continent as of May 2nd, 2024

CREATE VIEW [dbo].[Total_Continent_Infection_and_Death_Rates]
AS
SELECT location
	   , '2024-05-02' AS Date
	   , population
	   , MAX(total_cases) AS 'Total Cases'
	   , MAX(total_deaths) AS 'Total Deaths'
	   , CAST(ROUND(MAX(total_cases) * 1.0 / population * 100, 3) AS DECIMAL(10, 3)) AS 'Total Infection Rate'
	   , CAST(ROUND(MAX(total_deaths) * 1.0 / MAX(total_cases) * 100, 3) AS DECIMAL(10, 3)) AS 'Total Death Rate'
FROM dbo.Covid_Data
WHERE (continent IS NULL) 
AND (total_cases IS NOT NULL) 
AND (location NOT IN ('Low income', 'High income', 'Upper middle income', 'Lower middle income', 'European Union'))
GROUP BY location, population

--View for total death rates by country as of May 2nd, 2024


CREATE VIEW [dbo].[Total_Country_Death_Rates]
AS
SELECT location AS Country
	   ,'2024-05-02' as Date
	   , MAX(total_cases) AS 'Total Cases'
	   , MAX(total_deaths) AS 'Total Deaths'
	   , CAST(ROUND(((MAX(total_deaths) * 1.0 / MAX(total_cases)) * 100), 3) AS DECIMAL(10, 3))  AS 'Total Death Rate'
FROM dbo.[Covid_Data]
WHERE (continent IS NOT NULL) 
AND (total_cases IS NOT NULL)
GROUP BY location

--View for total infection rates by country as of May 2nd, 2024


CREATE VIEW [dbo].[Total_Country_Infection_Rate]
AS
SELECT location AS Country
	   , '2024-05-02' AS 'Date'
	   , population AS 'Population'
	   , MAX(total_cases) AS 'Total Cases'
	   , CAST(ROUND(MAX(total_cases) * 1.0 / population * 100, 3) AS DECIMAL(10, 3)) AS 'Total Infection Rate'
FROM dbo.Covid_Data
WHERE (continent IS NOT NULL) 
AND (total_cases IS NOT NULL)
GROUP BY location, population

--Rolling vaccinations, all countries
--Note that new_vaccinations refers to vaccination doses prescribed by vaccination protocol, NOT new people receiving their first dose
	--Will sometimes exceed total population

SELECT location
	  ,date
	  ,population
	  ,new_vaccinations
	  ,SUM(new_vaccinations) OVER (PARTITION BY Location ORDER BY location, date) AS Rolling_Vaccinations
FROM Covid_Portfolio_Project..Covid_Data
WHERE continent IS NOT NULL
ORDER BY location, date

--Use CTE for rolling vaccination rate against population, all countries
--Note that new_vaccinations refers to vaccination doses prescribed by vaccination protocol, NOT new people receiving their first dose
	--Will sometimes exceed total population causing greater than 100% Vaccination_Rate

WITH VaxPerPop (location, date, population, new_vaccinations, Rolling_Vaccinations) as 
(
SELECT location
	  ,date
	  ,population
	  ,new_vaccinations
	  ,SUM(new_vaccinations) OVER (PARTITION BY Location ORDER BY location, date) as Rolling_Vaccinations
FROM Covid_Portfolio_Project..Covid_Data
WHERE continent IS NOT NULL)

SELECT *, CAST(ROUND((Rolling_Vaccinations * 1.0 / Population) * 100, 3) AS DECIMAL (10,3)) as Vaccination_Rate
from VaxPerPop
ORDER BY location, date