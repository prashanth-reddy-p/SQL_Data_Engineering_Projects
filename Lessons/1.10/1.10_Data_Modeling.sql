SELECT job_id, job_title_short, salary_year_avg, company_id
from data_jobs.job_postings_fact
order by salary_year_avg desc
limit 10;

select * from information_schema.columns
where table_catalog='data_jobs';

desc information_schema;
show information_schema.tables;