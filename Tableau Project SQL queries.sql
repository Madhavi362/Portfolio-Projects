/*

Queries used for Tableau Project

*/

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from Portfolio_DA..CovidDeaths
--where location like '%India%'
where continent is not null
--group by date
order by 1,2


-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2



-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe




select location,sum(new_deaths) as Total_Death_Count
from Portfolio_DA..CovidDeaths
--where location like '%India%'
where continent is  null
and location not in ('World','European Union','International','High income','Upper middle income','Lower middle income','Low income')
group by location
order by Total_Death_Count desc



select location, population, MAX(total_cases) as HighestInfectionount, Max(total_cases/population)*100 as PercentPopulationInfected
from Portfolio_DA..CovidDeaths
--where location like '%India%'
group by location,population
order by PercentPopulationInfected desc




select location, population, date, MAX(total_cases)as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
from Portfolio_DA..CovidDeaths
--where location like '%India%'
group by location, population, date
order by PercentPopulationInfected desc
