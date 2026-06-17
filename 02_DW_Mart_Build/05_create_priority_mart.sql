drop schema if exists priority_mart cascade;

create schema priority_mart;

select '===Loading Roles for Priority Mart table===' as info;
create table priority_mart.priority_roles(
    role_id integer primary key,
    role_name varchar,
    priority_lvl integer
);

insert into priority_mart.priority_roles(role_id, role_name, priority_lvl)
values 
(1, 'Data Engineer', 2),
(2, 'Senior Data Engineer',1),
(3, 'Software Engineer', 3);


select * from priority_mart.priority_roles;



--creating priority roles snapshot

create or replace table priority_mart.priority_jobs_snapshot(
    job_id integer primary key,
    job_title_short varchar,
    company_name varchar,
    job_posted_date timestamp,
    salary_year_avg double,
    priority_lvl integer,
    updated_at timestamp
);

insert into priority_mart.priority_jobs_snapshot 
(job_id,job_title_short,company_name,job_posted_date,salary_year_avg,priority_lvl,updated_at)
select 
jpf.job_id,
jpf.job_title_short,
cd.name,
jpf.job_posted_date,
jpf.salary_year_avg,
pr.priority_lvl,
current_timestamp
from job_postings_fact as jpf 
join company_dim as cd 
on jpf.company_id=cd.company_id
join priority_mart.priority_roles as pr 
on jpf.job_title_short=pr.role_name;



select '===Data validating=== priority jobs snapshot' as info;

select job_title_short,
count(job_title_short),
min(priority_lvl) as minimum_priority,
min(updated_at) as first_update
from priority_mart.priority_jobs_snapshot
group by job_title_short;
