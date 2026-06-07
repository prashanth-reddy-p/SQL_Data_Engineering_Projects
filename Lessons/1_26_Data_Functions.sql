select column_name from information_schema.columns
where table_catalog='data_jobs';

select job_posted_date,
job_posted_date :: date as date,
job_posted_date :: time as time
from job_postings_fact
limit 10;
select
extract(month from job_posted_date) as month,
extract(year from job_posted_date) as year,
count(job_id)
from job_postings_fact
where job_title_short='Data Engineer'
group by month, year
order by month;
desc job_postings_fact;

select job_posted_date, date_trunc('year', job_posted_date) as date_
from job_postings_fact
limit 10;


select '2026-05-31 15:13:00-04' :: timestamptz AT time zone 'IST';

select current_timestamp AT time zone 'UTC';

select job_posted_date, job_posted_date AT time zone 'IST', job_posted_date at time zone 'CST'
 from job_postings_fact
limit 10;


select unnest([1,2,3,4,5,1,2,3])
union all
select unnest([3,4,5,1,2]);


create or replace temp table jobs_2023 as 
select *
from job_postings_fact
where extract(year from job_posted_date)=2023;

create or replace temp table jobs_2025 as 
select * 
from job_postings_fact
where extract(year from job_posted_date) =2024;

select * from jobs_2023
intersect
select * from jobs_2025;