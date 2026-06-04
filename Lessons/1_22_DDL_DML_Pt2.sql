-- .read Lessons/1_22_DDL_DML_Pt2.sql
drop table if exists staging.job_postings_flat;
create or replace table  jobs_mart.staging.job_postings_flat as 
select *
from data_jobs.job_postings_fact jpf 
join data_jobs.company_dim cd 
on jpf.company_id=cd.company_id;

use jobs_mart;
select * from staging.job_postings_flat;


create  or replace view priority_jobs_flat_view as
select jpf.*, pr.priority_lvl
from staging.job_postings_flat jpf
join staging.priority_roles pr 
on jpf.job_title_short=pr.role_name
where priority_lvl=1;



select job_title_short,
    count(*) as job_count
from priority_jobs_flat_view
group by job_title_short
order by job_count desc;

select table_name, *
from information_schema.tables
where table_catalog='jobs_mart';

create temporary  table senior_jobs_flat_temp as 
select * 
from priority_jobs_flat_view
where job_title_short='Senior Data Engineer';


select count(*) from staging.priority_roles;
select count(*) from staging.job_postings_flat;
select count(*) from priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;
