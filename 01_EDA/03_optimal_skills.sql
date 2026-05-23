/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

select 
    sd.skills,
    round(median(jpf.salary_year_avg),2) as pay,
    round(ln(count(jpf.job_id)),2) as ln_demand,
    round(ln_demand*pay/1000000,2) as optimal_score
from job_postings_fact as jpf
join skills_job_dim as sjd on jpf.job_id=sjd.job_id
join skills_dim as sd on sjd.skill_id=sd.skill_id
where 
    jpf.job_title_short='Data Engineer'
    and jpf.job_work_from_home=true
    and jpf.salary_year_avg is not null
group by sd.skills
having count(sjd.skill_id)> 100
order by optimal_score desc
limit 25;


/*
Here's a breakdown of the most optimal skills for Data Engineers, based on both high demand and high salaries:

Top Skills by Optimal Score:
- Terraform leads the list with a $184K median salary and 193 postings, resulting in the highest overall "optimal score".
- Python and SQL dominate demand (over 1100 postings each), with strong median salaries of $135K and $130K, respectively.
- AWS (783 postings, $137K median), Spark (503 postings, $140K median), and Airflow (386 postings, $150K median) are all highly sought-after cloud and big data technologies.
- Kafka offers high compensation ($145K median) and solid demand (292 postings).
- Tools like Snowflake, Azure, and Databricks each have 250–475 postings and median salaries between $128–$137K.

DevOps & Engineering Tools:
- Airflow ($150K), Kubernetes ($150.5K), and Docker ($135K) stand out for their mix of demand and top median salaries.
- Git ($140K/208 postings) and Github ($135K/127 postings) have broad utility and competitive compensation.

Noteworthy Languages:
- Java (303 postings, $135K median) and Scala (247 postings, $137K median) remain strong choices for well-paid data engineering roles.
- Go ($140K/113 postings) is another programming language with excellent compensation.

Databases & Cloud:
- Redshift ($130K/274 postings), GCP ($136K/196 postings), Hadoop ($135K/198 postings), NoSQL ($134.4K/193 postings), and MongoDB ($135.8K/136 postings) add to a well-rounded data engineering skill set.
- R, Pyspark, and BigQuery each deliver competitive salaries and meet the threshold for demand.

Summary:
Skills that consistently appear near the top balance a strong combination of market demand (job security) and financial benefit. Python, SQL, AWS, Spark, Airflow, and Terraform are particularly strategic for both immediate opportunities and longer-term career growth in data engineering.

┌────────────┬───────────┬───────────┬───────────────┐
│   skills   │    pay    │ ln_demand │ optimal_score │
│  varchar   │  double   │  double   │    double     │
├────────────┼───────────┼───────────┼───────────────┤
│ terraform  │  184000.0 │      5.26 │          0.97 │
│ python     │  135000.0 │      7.03 │          0.95 │
│ sql        │  130000.0 │      7.03 │          0.91 │
│ aws        │ 137320.31 │      6.66 │          0.91 │
│ airflow    │  150000.0 │      5.96 │          0.89 │
│ spark      │  140000.0 │      6.22 │          0.87 │
│ kafka      │  145000.0 │      5.68 │          0.82 │
│ snowflake  │  135500.0 │      6.08 │          0.82 │
│ azure      │  128000.0 │      6.16 │          0.79 │
│ java       │  135000.0 │      5.71 │          0.77 │
│ scala      │ 137290.48 │      5.51 │          0.76 │
│ kubernetes │  150500.0 │      4.99 │          0.75 │
│ git        │  140000.0 │      5.34 │          0.75 │
│ databricks │  132750.0 │      5.58 │          0.74 │
│ redshift   │  130000.0 │      5.61 │          0.73 │
│ gcp        │  136000.0 │      5.28 │          0.72 │
│ hadoop     │  135000.0 │      5.29 │          0.71 │
│ nosql      │  134415.0 │      5.26 │          0.71 │
│ pyspark    │  140000.0 │      5.02 │           0.7 │
│ mongodb    │  135750.0 │      4.91 │          0.67 │
│ docker     │  135000.0 │      4.97 │          0.67 │
│ r          │  134775.0 │      4.89 │          0.66 │
│ go         │  140000.0 │      4.73 │          0.66 │
│ bigquery   │  135000.0 │      4.81 │          0.65 │
│ github     │  135000.0 │      4.84 │          0.65 │
└────────────┴───────────┴───────────┴───────────────┘
*/