/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


select * 
from Portfolio_DA..CovidDeaths 
where continent is not null
order by 3,4

select 
location,date,total_cases,new_cases,total_deaths,population
from Portfolio_DA..CovidDeaths
where continent is not null
order by 1,2

-- Select Data that we are going to be starting with


select 
location,date,total_cases,total_deaths,
(Cast(total_deaths as bigint)/cast(total_cases as bigint))*100 as Death_Percentage
from Portfolio_DA..CovidDeaths
where location like '%India%'
and continent is not null
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select 
location, date, total_cases,population,(cast(total_cases as bigint)/population)*100 as Percent_Population
from Portfolio_DA..CovidDeaths
--where location like '%India%'
--and continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid


select 
location, population,MAX( CAST(total_cases as bigint)) as HighInfectCount,
MAX(CAST(total_cases as bigint)/population) *100 as PercentPopulationInfected
from Portfolio_DA..CovidDeaths
--where location like '%India%'
--and continent is not null
group by location,population
order by PercentPopulationInfected desc

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%India%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population


select location ,MAX(CAST(total_deaths as bigint)) as TotalDeathCount
from Portfolio_DA..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



select 
continent ,MAX(CAST(total_deaths as bigint)) as TotalDeathCount
from Portfolio_DA..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select 
location ,MAX(CAST(total_deaths as bigint)) as TotalDeathCount
from Portfolio_DA..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



-- GLOBAL NUMBERS


select 
sum(new_cases) as total_cases,
sum(cast(new_deaths as bigint)) as total_deaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 as DeathPercentage
from Portfolio_DA..CovidDeaths
--where location like '%%'
where continent is not null
group by date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from Portfolio_DA..CovidDeaths as dea
join Portfolio_DA..CovidVaccinations as vac
     ON dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query


with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from Portfolio_DA..CovidDeaths as dea
join Portfolio_DA..CovidVaccinations as vac
     ON dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from Portfolio_DA..CovidDeaths as dea
join Portfolio_DA..CovidVaccinations as vac
     ON dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated;



-- Creating View to store data for later visualizations


Drop view if exists PercentPopulationVaccinated ;


create view
dbo.PercentPopulationVaccinated as
select 
dea.continent, 
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from Portfolio_DA..CovidDeaths as dea
join Portfolio_DA..CovidVaccinations as vac
     ON dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

show view PercentPopulationVaccinated



