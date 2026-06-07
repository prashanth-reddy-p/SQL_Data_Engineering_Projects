--source table

create or replace temp table src_priority_jobs as 
    select jpf.job_id,
        jpf.job_title_short,
        cd.name,
        jpf.job_posted_date,
        jpf.salary_year_avg,
        pr.priority_lvl,
        current_timestamp as updated_at
    from data_jobs.job_postings_fact as jpf
    left join data_jobs.company_dim as cd
    on jpf.company_id=cd.company_id
    inner join staging.priority_roles as pr
    on jpf.job_title_short=pr.role_name
;

-- --target table
-- --update
-- update priority_jobs_snapshot as tgt 
-- set priority_lvl=src_priority_jobs.priority_lvl,
-- updated_at=current_timestamp
-- from src_priority_jobs
-- where tgt.job_id=src_priority_jobs.job_id
-- and tgt.priority_lvl is distinct from src_priority_jobs.priority_lvl;


-- --Insert 

-- insert into priority_jobs_snapshot 
--     select job_id,
--     job_title_short,
--     name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     current_timestamp
--     from src_priority_jobs as src
--     where not exists (
--         select 1 
--         from priority_jobs_snapshot as tgt
--         where src.job_id=tgt.job_id)
-- ;



merge into priority_jobs_snapshot as tgt
using src_priority_jobs as src
on tgt.job_id=src.job_id

when matched and tgt.priority_lvl is distinct from src.priority_lvl then
update set 
priority_lvl=src.priority_lvl,
updated_at=src.updated_at

when not matched then
insert values(src.job_id,
    src.job_title_short,
    src.name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at)
when not matched by source then delete;



a

select * from src_priority_jobs;