select * from PortfolioProject..Covid_deaths
order by 3,4;

select * from PortfolioProject..CovidVacinnations
order by 3,4;

-- Updating the date to a simple format

select Date, CONVERT(date,date) 
from PortfolioProject..Covid_deaths;

Alter table portfolioProject..covid_deaths
add NewDate date;

Update PortfolioProject..Covid_deaths
set NewDate = CONVERT(date,date); 
	--table information is updated
	
select NewDate, CONVERT(date,date) as Date
from PortfolioProject..Covid_deaths;
----------------------------------------------------------
-- Continent, Location, Date, New deaths, New cases, New Vaccinations and Population of India

select dea.location, dea.NewDate,
Isnull(dea.new_deaths,0) as NewDeaths, isnull(dea.new_cases,0) as NewCases,
isnull(vac.new_vaccinations_smoothed,0) as New_Vaccinations, 
dea.population
from PortfolioProject..Covid_deaths dea
join PortfolioProject..CovidVacinnations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
and dea.location like '%India%'
order by 2,3;

-- Creating view for the above the query
create view India_info as
select dea.continent, dea.location, dea.NewDate,
Isnull(dea.new_deaths,0) as NewDeaths, isnull(dea.new_cases,0) as NewCases,
isnull(vac.new_vaccinations_smoothed,0) as New_Vaccinations, 
dea.population
from PortfolioProject..Covid_deaths dea
join PortfolioProject..CovidVacinnations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null 
and dea.location like '%India%';
	--View for selecting data for India is created.

select * from India_info
order by 2,3;
---------------------------------------------------------------------

-- Max death count for each continent, in descending order

select continent, Max(cast(total_deaths as int)) as DeathCount
from PortfolioProject..Covid_deaths 
where continent is not null 
group by continent
order by DeathCount desc;
---------------------------------------------------------------------

-- Max death count for each country/location, in descending order

select location, Max(cast(total_deaths as int)) as DeathCount
from PortfolioProject..Covid_deaths 
where continent is not null
group by location
order by DeathCount desc;
---------------------------------------------------------------------

-- Max infected cases for each continent in descending order

select continent, Max(cast(total_cases as int)) as InfectedCount
from PortfolioProject..Covid_deaths 
where continent is not null 
group by continent
order by InfectedCount desc;
---------------------------------------------------------------------

-- Max infected cases for each location/region in descending order

select location, Max(cast(total_cases as int)) as InfectedCount
from PortfolioProject..Covid_deaths 
where continent is not null
group by location
order by InfectedCount desc;
---------------------------------------------------------------------

-- Total vaccinations for each continent in descending order

select continent, sum(convert(bigint, new_vaccinations_smoothed)) as VaccinationCount
from PortfolioProject..CovidVacinnations 
where continent is not null
group by continent
order by VaccinationCount desc;
---------------------------------------------------------------------

-- Total vaccinations for each location/region in descending order

select location, sum(convert(bigint, new_vaccinations_smoothed)) as VaccinationCount
from PortfolioProject..CovidVacinnations 
where continent is not null
group by location
order by VaccinationCount desc;
---------------------------------------------------------------------

/* Death percentage per population and death percentage per infected cases
	for each location */

select location,Max(cast(total_deaths as int)) as DeathCount,
Max(cast(total_cases as int)) as InfectedCount, population,
cast(Max(cast(total_deaths as int))*100/population as decimal(10,2)) as  'Death%ofPopulation',
cast(Max(cast(total_deaths as float))*100/Max(cast(total_cases as float)) as decimal(10,2)) 
as 'Death%ofInfected' 
from PortfolioProject..Covid_deaths 
where continent is not null
group by location, population
order by 2 desc;
---------------------------------------------------------------------

-- Infected percentage per population for each location (max cases / population)

select location, Max(cast(total_cases as bigint)) as InfectedCount, population,
(Max(cast(total_cases as bigint))*100)/population as InfectedPercentage
from PortfolioProject..Covid_deaths 
where continent is not null
group by location, population
order by 3 desc;
---------------------------------------------------------------------

-- Percentage of vaccination per population for each location

select dea.location, max(convert(bigint,vac.total_vaccinations)) as TotalVaccination, 
dea.population, 
cast(max(cast(vac.total_vaccinations as bigint))*100/dea.population as decimal(10,2))
as 'Vaccination%'
from PortfolioProject..Covid_deaths dea
join PortfolioProject..CovidVacinnations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
group by dea.location, dea.population
order by 3 desc;
---------------------------------------------------------------------

-- Total death and total cases for each continent

select continent, sum(cast(new_deaths as int)) as DeathCount, sum(new_cases) as TotalCases
from PortfolioProject..Covid_deaths 
where continent is not null  
group by continent
order by 3 desc;
---------------------------------------------------------------------

