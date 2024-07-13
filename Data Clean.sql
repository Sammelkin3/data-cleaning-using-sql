-- Create Database
-- 1.Remove dublicates
-- 2.Standardize data
-- 3. Null or Blank values
-- 4. Remove any columns or row

-- 1.Remove Dublicates

select * from layoffs;

-- New exist table create

create table layoffs_stagging
like layoffs;

select*from layoffs_stagging;

insert layoffs_stagging 
select * from layoffs;

-- window func using with new column create

select *,
Row_Number() over(partition by company, industry, total_laid_off, percentage_laid_off, 'date')as row_num
from layoffs_stagging;

-- CTE create through dublicate values find

with dublicate_cte as
(
select *,
Row_Number() over(partition by company, location, industry,
 total_laid_off, percentage_laid_off, 'date', stage, country,
 funds_raised_millions)as row_num
from layoffs_stagging
)
select *
from dublicate_cte 
where row_num>1;

-- select *
-- from layoffs_stagging
-- where company='casper';

-- deleted the dublicate values

with dublicate_cte as
(
select *,
Row_Number() over(partition by company, location, industry,
 total_laid_off, percentage_laid_off, 'date', stage, country,
 funds_raised_millions)as row_num
from layoffs_stagging
)
delete
from dublicate_cte 
where row_num>1;

-- Create the Statement. Because you have create the new colum of row_num. so that insert through statement.

CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Create Statement Using another Table Create

select * from layoffs_stagging2;

-- layoffs_stagging table through new table of layoffs_stagging2 create

insert into layoffs_stagging2
select *,
Row_Number() over(partition by company, location, industry,
 total_laid_off, percentage_laid_off, 'date', stage, country,
 funds_raised_millions)as row_num
from layoffs_stagging;

select * from layoffs_stagging2
where row_num>1;

-- another way of deleted dublicate values 

DELETE from layoffs_stagging2
where row_num>1;

-- check the dublicate values

select * from layoffs_stagging2
where row_num>2;

-- Standardizing Data

-- unwanted spaces remove using trim function

select  distinct(trim(company))
from layoffs_stagging2;

select company, trim(company)
from layoffs_stagging2;

-- update the trim func output

update layoffs_stagging2
set company = trim(company);

select industry
from layoffs_stagging2;

select *
from layoffs_stagging2
where industry like 'crypto%';

update layoffs_stagging2
set industry='crypto'
where industry like 'crypto%';
-- industry values assining asc order

select distinct industry
from layoffs_stagging2
order by 1;

select *
from layoffs_stagging2
where country like'united states.%';

-- dublicate values remove for distinct func & trailling used . removed

select distinct country, 
trim(trailing '.' from country)
from layoffs_stagging2;

update layoffs_stagging2
set country=trim(trailing '.' from country)
where country like 'United States';

select distinct country
from layoffs_stagging2;

-- change the date(text) convert date(date)

select `date`
from layoffs_stagging2;

-- STR_TO_DATE used date(txt) convert date(date)

select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs_stagging2;

-- update the date

update layoffs_stagging2
set `date` =STR_TO_DATE(`date`, '%m/%d/%Y');

select `date`
from layoffs_stagging2;

alter table layoffs_stagging2
modify column `date` date;

select * from layoffs_stagging2;

-- 3. Null or Blank values

-- find the null or blank values

select *
from layoffs_stagging2
where industry is null
or industry='';

-- select *
-- from layoffs_stagging2
-- where company='airbnb';

-- self join used

select t1.industry,t2.industry
from layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company=t2.company
    and t1.location=t2.location
where(t1.industry is null or t1.industry='')
and t2.industry is not null;

-- blank values set the null

update layoffs_stagging2 t1
join layoffs_stagging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null; 

-- null values set blank 

update layoffs_stagging2
set industry=null
where industry='';

select *
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoffs_stagging2
where total_laid_off is null
and percentage_laid_off is null;

-- 4.Drop a column

alter table layoffs_stagging2
drop column row_num;

select * from layoffs_stagging2;
