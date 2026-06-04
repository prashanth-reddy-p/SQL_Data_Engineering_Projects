-- Scenario 1 - subquery in 'select'
-- Show each job's salary next to the overall market median:

select job_title_short, salary_year_avg, (
    select median(salary_year_avg)
    from staging.job_postings_flat) as median_salary
from staging.job_postings_flat
where salary_year_avg is not null
limit 10;

-- Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating:
select job_title_short, salary_year_avg, (
    select median(salary_year_avg)
    from staging.job_postings_flat
    where job_work_from_home = true
    ) as median_salary
from staging.job_postings_flat
where salary_year_avg is not null
and job_work_from_home = true
limit 10;

select job_title_short, salary_year_avg, (
    select median(salary_year_avg)
    from staging.job_postings_flat
    where job_work_from_home = true
    ) as median_salary
from (select job_title_short, salary_year_avg
from staging.job_postings_flat 
where job_work_from_home = true)
where salary_year_avg is not null
limit 10;

-- Scenario 3 - Subquery in 'Having'
-- Keep only job titles whose median salary is anove the overall median:
select job_title_short, median(salary_year_avg), (
    select median(salary_year_avg)
    from staging.job_postings_flat
    where job_work_from_home = true
    ) as median_salary
from (select job_title_short, salary_year_avg
from staging.job_postings_flat 
where job_work_from_home = true)
where salary_year_avg is not null
group by job_title_short
having median(salary_year_avg) > (select median (salary_year_avg)
from staging.job_postings_flat where job_work_from_home=True)
limit 10;


-- CTE Example
-- Compare how much more (or less) remote roles pay compared to onsite for each job title
-- Use CTE to calculate the median salary by title and work arrangement, then compare those medians.

with title_median as (select job_title_short, median(salary_year_avg) as median_salary, job_work_from_home
from staging.job_postings_flat
group by job_title_short,job_work_from_home
order by job_title_short)

select o.job_title_short,r.median_salary, o.median_salary, r.median_salary-o.median_salary as remote_premium
from title_median as r
join title_median as o
on r.job_title_short=o.job_title_short
where r.job_work_from_home=true
and o.job_work_from_home=false;
