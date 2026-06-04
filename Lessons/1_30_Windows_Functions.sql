select job_title_short,
round(avg(salary_hour_avg),2)
from job_postings_fact
where salary_hour_avg is not null
group by job_title_short
order by random()
limit 10;

select job_title_short,
salary_hour_avg,
round(avg(salary_hour_avg) over(
    partition by job_title_short
),2) as avg_salary
from job_postings_fact
where salary_hour_avg is not null
limit 30;


select jpf.job_title_short, 
jpf.company_id,
cd.name,
jpf.salary_hour_avg,
rank() over(
    order by jpf.salary_hour_avg desc
)
from job_postings_fact as jpf
join company_dim  cd on
jpf.company_id=cd.company_id
where jpf.salary_hour_avg is not null
limit 10;


-- windows functions using partition by and order by
create or replace temp view salary_hour_avg_wf as (select job_title_short,
salary_hour_avg,
avg(salary_hour_avg) over(
    partition by job_title_short
    order by salary_hour_avg desc
) as avg_salary
from job_postings_fact
where salary_hour_avg is not null);


select job_title_short,
job_posted_date,
salary_hour_avg,
min(salary_hour_avg) over(
    partition by job_title_short
    order by job_posted_date
     rows BETWEEN UNBOUNDED PRECEDING
          AND CURRENT ROW
)
from job_postings_fact
where salary_hour_avg is not null
and job_title_short='Data Engineer'
--order by job_posted_date asc
limit 20;