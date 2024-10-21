/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type AS job_type,
    salary_year_avg,
    DATE(job_posted_date) as date_posted,
    c.name AS company_name
FROM job_postings_fact j
LEFT JOIN company_dim c
ON j.company_id = c.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
