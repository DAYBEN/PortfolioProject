SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    coviddeaths
ORDER BY 1,2 desc;
#Looking at total Cases vs total Deaths
#Shows the likelihood of dying if you contract covid in your country

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths/total_cases)* 100 DeathPercentage    
FROM
    coviddeaths
ORDER BY 1,2 desc;

#Looking at Total Cases vs Population
#show what percentage of the population got Covid in Africa

SELECT 
    location,
    date,
    total_cases,
    Population,
    (total_cases/population)* 100 DeathPercentage
    
FROM
    coviddeaths
    where location like 'Afri%'
ORDER BY 5 desc;

#Looking at Countries with higest Infection Rate compared to Population
SELECT 
    location,
    population,
    Max(cast(total_cases as decimal)) as HighestInfection,
   Max((total_cases/population))* 100  PercentagePopulationInfected
FROM
    coviddeaths
    group by location, population
    order by  4 desc;
    
    #Showing Countries with Highest Death Count per Population
    
    SELECT 
    location,
    max(cast(total_deaths as decimal )) as TotalDeathCount
   FROM
    coviddeaths
    where continent != ''
    group by location
ORDER BY 2 desc;
# LET BREAK THING BY CONTINENT BY CONTINENT
#Showing continent with the highest death count per population

Select
  continent,
    max(cast(total_deaths as decimal )) as TotalDeathCount
   FROM
    coviddeaths
    where continent !=''
    group by continent
ORDER BY 2 desc;

#GLOBAL

SELECT 
    sum(New_cases),
    sum(new_deaths),
    sum(new_deaths)/sum(New_cases)*100 as NewDeathPercentage
FROM
    coviddeaths
   # group by date
ORDER BY 1 desc;
# Looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by location, date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by 3 desc ;

#USE CTE

with PopvsVac 
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by location, date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by 3 desc )
select *, (RollingPeopleVaccinated/Population)*100 from PopvsVac ;

#Temp Table
Drop table if exists PerPopVac;
create temporary table PerPopVac
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by location, date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by 3 desc;
select * from PerPopVac;

#Creatting View to store date for later Visualizations

create view PerPopVac as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location order by location, date)
as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac on dea.location = vac.location
and dea.date = vac.date
where dea.continent != ''
order by 3 desc;

select * from PerPopVac ;



