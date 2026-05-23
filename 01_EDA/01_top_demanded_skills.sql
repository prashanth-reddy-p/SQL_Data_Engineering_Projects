/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? 
    Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/

select 
    sjd.skill_id, 
    sd.skills,
    sd.type,
    count(jpf.job_id) as popularity,
    round((popularity/(select count(*) from job_postings_fact
    where job_title_short='Data Engineer'
    and job_work_from_home=true))*100,2) as popularity_percentage
from job_postings_fact as jpf
join skills_job_dim as sjd on jpf.job_id=sjd.job_id
join skills_dim as sd on sjd.skill_id=sd.skill_id
where 
    jpf.job_title_short='Data Engineer'
    and job_work_from_home=true
group by 
    sjd.skill_id, sd.skills, sd.type
order by 
    popularity desc
limit 10;

select count(*) from job_postings_fact
where job_title_short='Data Engineer'
and job_work_from_home=true;
/*
Here's the breakdown of the most demanded skills for data engineers:
SQL and Python are by far the most in-demand skills, with around 29,000 job postings each - nearly double the next closest skill.
Cloud platforms round out the top skills, with AWS leading at ~18,000 postings, followed by Azure at ~14,000.
Apache Spark completes the top 5 with nearly 13,000 postings, highlighting the importance of big data processing skills.

Key takeaways:
- SQL and Python remain the foundational skills for data engineers
- Cloud platforms (AWS, Azure) are critical for modern data engineering
- Big data tools like Spark continue to be highly valued
- Data pipeline tools (Airflow, Snowflake, Databricks) show growing demand
- Java and GCP round out the top 10 most requested skills


┌──────────┬────────────┬─────────────┬────────────┬───────────────────────┐
│ skill_id │   skills   │    type     │ popularity │ popularity_percentage │
│  int32   │  varchar   │   varchar   │   int64    │        double         │
├──────────┼────────────┼─────────────┼────────────┼───────────────────────┤
│        0 │ sql        │ programming │      29221 │                 66.63 │
│        1 │ python     │ programming │      28776 │                 65.62 │
│       77 │ aws        │ cloud       │      17823 │                 40.64 │
│       74 │ azure      │ cloud       │      14143 │                 32.25 │
│       92 │ spark      │ libraries   │      12799 │                 29.19 │
│      104 │ airflow    │ libraries   │       9996 │                 22.79 │
│       73 │ snowflake  │ cloud       │       8639 │                  19.7 │
│       75 │ databricks │ cloud       │       8183 │                 18.66 │
│       12 │ java       │ programming │       7267 │                 16.57 │
│       78 │ gcp        │ cloud       │       6446 │                  14.7 │
└──────────┴────────────┴─────────────┴────────────┴───────────────────────
*/


