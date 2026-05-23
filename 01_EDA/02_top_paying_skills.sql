/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/
select 
    sjd.skill_id,
    sd.skills,
    count(jpf.job_id) as demand,
    round(median(jpf.salary_year_avg),2) as pay
from job_postings_fact as jpf
join skills_job_dim as sjd on jpf.job_id=sjd.job_id
join skills_dim as sd on sjd.skill_id=sd.skill_id
where 
    jpf.job_title_short='Data Engineer'
    and jpf.job_work_from_home=true
group by sjd.skill_id,sd.skills
having count(sjd.skill_id)>=100
order by pay desc
limit 25;

/*
Here's a breakdown of the highest-paying skills for Data Engineers:

Key Insights:
- Rust remains the top-paying skill at $210K median salary, though demand is still relatively limited (232 postings).
- Terraform and Golang both have high median salaries at $184K, with strong demand (Terraform: 3,248 postings; Golang: 912 postings).
- Other notable skills with both high pay and moderate-to-high frequency include:
  - Spring: $175.5K median salary (364 postings)
  - Neo4j: $170K median salary (277 postings)
  - GDPR: $169.6K median salary (582 postings)
  - GraphQL: $167.5K median salary (445 postings)
  - Kubernetes: $150.5K median salary (4,202 postings)
  - Airflow: $150K median salary (9,996 postings)
- Bitbucket, Ruby, Redis, Ansible, and Jupyter all appear in the top 25 for pay, each with hundreds of postings.
- Most skills on the list are no longer extreme statistical outliers with just a handful of postings; instead, many show consistently strong demand.

Takeaway: While the very top-paying skill (Rust) still has less demand than major cloud and data tools, most of the top-paying skills have both solid salaries and significant demand. This suggests that learning tools like Terraform, Golang, Spring, Neo4j, and especially core data engineering tools (Airflow, Kubernetes) provides a strong balance between compensation and marketability.

┌──────────┬────────────┬────────┬───────────┐
│ skill_id │   skills   │ demand │    pay    │
│  int32   │  varchar   │ int64  │  double   │
├──────────┼────────────┼────────┼───────────┤
│       32 │ rust       │    232 │  210000.0 │
│       34 │ golang     │    912 │  184000.0 │
│      217 │ terraform  │   3248 │  184000.0 │
│      103 │ spring     │    364 │  175500.0 │
│       64 │ neo4j      │    277 │  170000.0 │
│      112 │ gdpr       │    582 │  169615.5 │
│      253 │ zoom       │    127 │  168437.5 │
│      116 │ graphql    │    445 │  167500.0 │
│       11 │ mongo      │    265 │  162250.0 │
│      140 │ fastapi    │    204 │  157500.0 │
│      145 │ django     │    265 │  155000.0 │
│      224 │ bitbucket  │    478 │  155000.0 │
│        5 │ crystal    │    129 │  154223.5 │
│      211 │ atlassian  │    249 │  151500.0 │
│       27 │ c          │    444 │  151500.0 │
│       30 │ typescript │    388 │  151000.0 │
│      213 │ kubernetes │   4202 │  150500.0 │
│      104 │ airflow    │   9996 │  150000.0 │
│       10 │ ruby       │    368 │  150000.0 │
│      139 │ ruby       │    368 │  150000.0 │
│      150 │ node       │    179 │  150000.0 │
│       20 │ css        │    262 │  150000.0 │
│       61 │ redis      │    605 │  149000.0 │
│      220 │ ansible    │    475 │ 148798.25 │
│       82 │ vmware     │    136 │ 148798.25 │
└──────────┴────────────┴────────┴───────────┘
  25 rows                          4 columns
*/

