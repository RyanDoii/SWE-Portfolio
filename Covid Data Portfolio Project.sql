--SELECT * 
--FROM PortfolioProjects2..CovidDeaths

--SELECT * 
--FROM PortfolioProjects2..CovidVaccinations

-- Selecting Data to be used

Select Location, date, total_cases, new_cases,total_deaths,population
From PortfolioProjects2..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProjects2..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows population that has gotten covid
Select Location, date, population, total_cases, (total_cases/population)*100 as CovidPopulation
From PortfolioProjects2..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects2..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected DESC

-- Showing Countries with Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProjects2..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProjects2..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers
Select SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 As DeathPercentage
From PortfolioProjects2..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2


-- Looking at total population vs vaccinations
With PopvsVac(continent,location,date,population, new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProjects2..CovidDeaths dea 
Join PortfolioProjects2..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select * , (RollingPeopleVaccinated/population)*100
From PopvsVac

----Temporary Table

Create Table #PercentPopulationVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProjects2..CovidDeaths dea 
   Join PortfolioProjects2..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Select * , (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating View for later visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProjects2..CovidDeaths dea 
Join PortfolioProjects2..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null