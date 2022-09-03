-- PrimerProyecto..CovidDeaths$
-- PrimerProyecto..CovidVaccinates$

-- DATOS DE COVID MUNDIALES

-- Total de casos, Total de muertes y porcentaje de muerte si estas contagiado.
Select
	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as ProbabilidadMuerte
From PrimerProyecto..CovidDeaths$
where continent is not null
order by 1,2


-- Total de muertes por continente
Select 
	location, 
	SUM(cast(new_deaths as int)) as MuertesTotales
From 
	PrimerProyecto..CovidDeaths$
Where continent is null 
	and location not in ('World', 'European Union', 'International')
	and location not like '%income%'
Group by location
order by MuertesTotales desc


-- Comparamos la poblacion total con los infectados totales de cada pais
-- Además, sacamos el porcentaje de la poblacion infectada.
Select 
	Location, 
	Population, 
	MAX(total_cases) as TotalInfectados,  
	Max((total_cases/population))*100 as PorcentajePoblacionInfectada
From 
	PrimerProyecto..CovidDeaths$
Group by Location, Population
order by PorcentajePoblacionInfectada desc


-- Mayor Porcentaje de infectados por fecha


Select 
	Location, 
	Population,
	date, 
	MAX(total_cases) as TotalInfectados,  
	Max((total_cases/population))*100 as PorcentajePoblacionInfectada
From 
	PrimerProyecto..CovidDeaths$
Group by Location, Population, date
order by PorcentajePoblacionInfectada desc


-- Contador por fecha de cada país en poblacion vacunada

Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	MAX(vac.total_vaccinations) as GenteVacunada
From PrimerProyecto..CovidDeaths$ dea
Join PrimerProyecto..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3