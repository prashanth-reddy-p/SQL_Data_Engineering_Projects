drop schema if exists flat_mart cascade;
create schema flat_mart;

select 'Loading Flat Mart' as info;
create or replace table flat_mart.job_postings as 
select 
jpf.job_id,
-- jpf.job_title_short,
-- jpf.job_title,
-- jpf.job_location,
-- jpf.job_via,
-- jpf.job_schedule_type,
-- jpf.job_work_from_home,
-- jpf.search_location,
-- jpf.job_posted_date,
-- jpf.job_no_degree_mention,
-- jpf.job_health_insurance,
-- jpf.job_country,
-- jpf.salary_rate,
-- jpf.salary_year_avg,
-- jpf.salary_hour_avg,
cd.company_id,
cd.name as company_name,
array_agg(
    struct_pack(
        skills:=sd.skills,
        type:=sd.type)
) as skills_type
from job_postings_fact as jpf 
left join skills_job_dim as sjd 
on jpf.job_id=sjd.job_id
left join skills_dim as sd 
on sd.skill_id=sjd.skill_id
left join company_dim as cd 
on cd.company_id=jpf.company_id
group by all;


select 'Flat Mart Job Postings', count(*) as record_count from flat_mart.job_postings;

select '=== Flat mart info ===' as info;
select * from flat_mart.job_postings
limit 10;
show tables;