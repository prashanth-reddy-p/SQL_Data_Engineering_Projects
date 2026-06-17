drop schema if exists skills_mart cascade;
create schema skills_mart;
create or replace table skills_mart.dim_skills(
    skill_id integer primary key,
    type varchar,
    skills varchar
);
insert into skills_mart.dim_skills(skill_id,type,skills)
select sd.skill_id,sd.type, sd.skills
from skills_dim as sd;


create or replace table skills_mart.dim_date_month(
month_start_date date primary key,
year integer,
month integer,
quarter integer,
quarter_name varchar,
year_quarter varchar
);

insert into skills_mart.dim_date_month (month_start_date,
year,
month,
quarter ,
quarter_name ,
year_quarter )
select distinct date_Trunc('month',job_posted_date):: date as month_start_date,
extract(year from job_posted_date) as year,
extract(month from job_posted_date) as month,
extract(quarter from job_posted_date) as quarter,
'Q-' || quarter::varchar as quarter_name,
year::varchar || '-Q' || quarter::varchar as year_quarter
from job_postings_fact
order by month_start_date;

create table skills_mart.fact_skill_demand_monthly(
    skill_id    integer,
    month_start_date  date,
    job_title_short varchar,
    postings_count integer,
    remote_postings_count integer,
    health_insurance_postings_count integer,
    no_degree_required_postings_count integer,
    primary key (skill_id, month_start_date, job_title_short),
    foreign key (skill_id) references skills_mart.dim_skills(skill_id),
    foreign key (month_start_date) references skills_mart.dim_date_month(month_start_date)
);
insert into skills_mart.fact_skill_demand_monthly(skill_id,
    month_start_date,
    job_title_short ,
    postings_count ,
    remote_postings_count ,
    health_insurance_postings_count,
    no_degree_required_postings_count)


with job_postings_prep as(
select 
sjd.skill_id,
date_Trunc('month',job_posted_date)::date as month_start_date,
jpf.job_title_short,
case 
when job_health_insurance =True then 1 else 0
end as has_health_insurance,
case 
when job_work_from_home =True then 1 else 0
end as is_remote,
case
when job_no_degree_mention=True then 1 else 0
end as no_degree_required
from job_postings_fact as jpf join skills_job_dim as sjd 
on jpf.job_id=sjd.job_id)

select
 skill_id,
 month_start_date,
 job_title_short, 
 count(*),
 sum(is_remote) as remote_postings_count,
 sum(has_health_insurance) as health_insurance_postings_count,
 sum(no_degree_required) as no_degree_required_postings_count
from job_postings_prep
group by all
order by skill_id,month_start_date,job_title_short;




-- Data Validation--

select 'skill_dimension' as table_name, count(*) as record_count from skills_mart.dim_skills
union all
select 'Date month Dimension', count(*) from skills_mart.dim_date_month,
union all
select 'Skill Demand Fact', count(*) from skills_mart.fact_skill_demand_monthly;