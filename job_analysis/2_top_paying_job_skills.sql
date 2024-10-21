/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
    helping job seekers understand which skills to develop that align with top salaries
*/


WITH top_paying_jobs AS(
    SELECT job_id,
        job_title,
        salary_year_avg,
        DATE(job_posted_date) as date_posted,
        c.name AS company_name
    FROM job_postings_fact j
        LEFT JOIN company_dim c ON j.company_id = c.company_id
    WHERE job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT j.*,
    s.skills
FROM top_paying_jobs j
    INNER JOIN skills_job_dim c ON j.job_id = c.job_id
    INNER JOIN skills_dim s ON c.skill_id = s.skill_id
ORDER BY
    salary_year_avg DESC;

/*
Here's the breakdown of the most demanded skills for data analysts in 2023, based on job listings.
- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
*/

-- We can extract the results in a csv file top_paying_job_skills.csv