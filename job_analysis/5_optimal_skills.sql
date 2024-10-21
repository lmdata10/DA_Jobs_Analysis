/*
Question:
What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and afsociated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for 
    career development in data analysis
*/

-- First Approach is going to be using CTEs to understand it better
WITH cte1 AS (
    SELECT s.skill_id,
        s.skills,
        COUNT(sj.job_id) AS demand_count
    FROM job_postings_fact jp
        INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
        INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY s.skill_id
),
cte2 AS (
    SELECT sj.skill_id,
    ROUND(AVG(jp.salary_year_avg), 2) as avg_salary
    FROM job_postings_fact jp
        INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
        INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY sj.skill_id
)

SELECT a.skill_id,
    a.skills,
    demand_count,
    avg_salary
FROM cte1 a
    INNER JOIN cte2 b ON a.skill_id = b.skill_id
WHERE demand_count>10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;

-- Optimized Approach

SELECT s.skill_id,
    s.skills,
    COUNT(sj.job_id) AS demand_count,
    ROUND(AVG(jp.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact jp
    INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY s.skill_id
HAVING COUNT(sj.job_id) > 10
ORDER BY avg_salary DESC,
    demand_count DESC
LIMIT 25;