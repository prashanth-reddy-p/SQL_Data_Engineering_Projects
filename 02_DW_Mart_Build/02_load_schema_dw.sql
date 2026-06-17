select '=== loading company dim table===' as info;
insert into company_dim(company_id,name) 
select company_id,name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv');


select '=== loading skills dim table===' as info;
insert into skills_dim
select * from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv');


select '=== loading job postings fact table===' as info;
insert into job_postings_fact
select * from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv');

select '=== loading skills job dim table===' as info;
INSERT INTO skills_job_dim (skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv');

