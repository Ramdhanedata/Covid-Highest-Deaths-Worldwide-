select * 
from deaths;
-- 

select * 
from weekly_deaths 
order by country desc ;
--

-- the data that we are going to work on 
select location , continent , date , population, new_cases , total_cases , total_deaths , new_deaths 
from deaths 
where continent like 'Africa'
order by location desc ;


-- showing Total cases vs total deaths 
select total_cases , total_deaths, (total_deaths / total_cases)*100 as deaths_percentage
from deaths
order by total_deaths desc;


-- countries with the hiegher infection rate compare to population 
select location,population,
       max(total_cases) / max(population) * 100 as Highest_infection_rate,
       max(total_deaths) / max(population) * 100 as death_rate_percent
from deaths
group by location, population
order by Highest_infection_rate desc;


-- showing highest deaths count per location 
select location , population , max(total_deaths) as highest_death_count
from deaths 
group by location, population 
order by highest_death_count desc;

-- showing highest deaths count per continent 
select continent , count(total_deaths) as death_count
from deaths 
group by continent
order by death_count desc;


-- showing Highest deaths rate per location 
select location , population , max(total_deaths)/max(population)*100 as highest_death_rate 
from deaths 
group by location, population 
order by highest_death_rate desc;



-- showing the continent with the highest deaths count per population 
SELECT continent,
       count(population) as total_population ,
       count(total_deaths) as total_deaths ,
       sum(total_deaths) / sum(population) as death_per_population 
from deaths
where continent is not null 
group by continent
order by death_per_population DESC
limit 1;



-- Total death per cases golobaly 
select continent , sum(total_cases)as Total_cases, sum(total_deaths)as Total_death,
sum(Total_cases)/ sum(Total_deaths) as Global_death
from deaths 
where continent is not null
group by continent 
order by Global_death;


-- global numbers 
select sum(new_cases)as total_cases, 
sum(new_deaths)as total_deaths ,
sum(new_cases)/sum(new_deaths)*100  as deaths_percentage 
from deaths 
where continent is not null 
order by  deaths_percentage ;


-- join our two tables 
select * 
from deaths d
join weekly_deaths w
using (population);


-- Total population per vaccination 
select d.continent , d.location , d.date, w.population , w.vaccinated 
from deaths d
join weekly_deaths w
using (population)
where continent is not null
order by continent desc;


-- group by continent & country 
select d.continent,d.location as country,
count(w.population) as population,        
count(w.vaccinated) as vaccinated       
from deaths d
left join weekly_deaths w 
using (date)
where d.continent is not null
group by d.continent, d.location
order by d.continent desc;



create table ppl_vaccine
( continent varchar (30), location varchar (30), date datetime , population int , new_vaccinated int , sum_of_ppl_vaccinated int);

-- -----------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------

drop table ppl_vaccine

CREATE TABLE ppl_vaccine (
  continent VARCHAR(30),
  location VARCHAR(30),
  date DATETIME,
  population INT,
  new_vaccinated INT,
  sum_of_ppl_vaccinated INT
);

INSERT INTO ppl_vaccine (
  continent,
  location,
  date,
  population,
  new_vaccinated,
  sum_of_ppl_vaccinated
)
SELECT
  d.continent,
  d.location,
  NULL AS date,
  COUNT(w.population) AS population,
  NULL AS new_vaccinated,
  COUNT(w.vaccinated) AS sum_of_ppl_vaccinated
FROM deaths d
LEFT JOIN weekly_deaths w 
USING (date)
WHERE d.continent IS NOT NULL
GROUP BY d.continent, d.location
ORDER BY d.continent DESC;












