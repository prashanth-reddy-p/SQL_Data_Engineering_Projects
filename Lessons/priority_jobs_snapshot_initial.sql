create or replace table priority_jobs_snapshot (
    job_id integer primary key,
    job_title_short varchar(30),
    company_name varchar(40),
    job_posted_date Timestamp,
    salary_year_avg double,
    priority_lvl integer,
    updated_at timestamp
);

insert into priority_jobs_snapshot 
    select jpf.job_id,
    jpf.job_title_short,
    cd.name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    current_timestamp
    from data_jobs.job_postings_fact as jpf
    left join data_jobs.company_dim as cd
    on jpf.company_id=cd.company_id
    inner join staging.priority_roles as pr
    on jpf.job_title_short=pr.role_name
;


select job_title_short,median(salary_year_avg), count(job_id),priority_lvl
 from priority_jobs_snapshot
 group by job_title_short,priority_lvl
 order by priority_lvl desc
 ;