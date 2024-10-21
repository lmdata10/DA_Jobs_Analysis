# Decoding the Data Analyst Job Market 🕵️‍♂️💼

Hey there, fellow data enthusiasts! 👋 Ever wondered what it takes to land those juicy data analyst roles? Well, buckle up because we're about to embark on a wild ride through the data job market! 🎢

🔍 Curious about the SQL queries? Check them out in the [job_analysis folder](/job_analysis/)

## What's This All About? 🤔

I've been on a mission to crack the code of the data analyst job market. Why? Because I'm tired of seeing talented folks like me struggle to find their dream jobs, and I bet you are too! So, I rolled up my sleeves and dug into some seriously cool data from Luke Barousse's [SQL Course](https://lukebarousse.com/sql). 

### The key questions I aimed to answer through my SQL queries:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?


# Tools I Used
For this deep dive into the data analyst job market, I utilized several essential tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and extract key insights.
- **PostgreSQL:** The database management system I used to handle job posting data.
- **Visual Studio Code:** My go-to tool for managing the database and executing SQL queries.
- **Git & GitHub:** Critical for version control, sharing SQL scripts, and ensuring collaboration and project tracking.

# The Analysis
I crafted SQL queries to explore specific aspects of the data analyst job market. Here’s how each question was approached:

### 1. Top-Paying Data Analyst Jobs
To identify the highest-paying data analyst roles, I filtered positions based on average yearly salary and focused on remote jobs. Here's a look at the top-paying opportunities in 2023:

```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](assets/1_top_paying_roles.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts; took help from ChatGPT to generate this bar graph using my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is the most required skill, appearing in 8 out of the top 10 highest-paying roles.
- **Python** follows closely, being listed in 7 out of the top 10.
- **Tableau** also appears frequently, highlighting the need for data visualization skills with a bold count of 6.
Other important skills include **R**, **Snowflake**, **Pandas**, and **Excel**, which vary in their importance depending on the job.

![Top Paying Skills](assets/2_top_paying_roles_skills.png)
*Bar graph showing the frequency of skills in the top 10 highest-paying data analyst jobs; created based on my SQL query results.*

### 3. In-Demand Skills for Data Analysts

Next, I analyzed the most frequently requested skills in job postings to identify the highest-demand skills in the market.

```sql
SELECT skills,
    COUNT (sj.job_id) AS demand_count
FROM job_postings_fact jp
    INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
Key Findings
- **SQL** and **Excel** dominate the data analyst job market, both being highly sought-after by employers.
- **Python** and **Tableau**rank high, emphasizing the need for programming skills and data visualization tools.
- **Power BI's** frequent appearance in the analysis is a testament to its strong presence and growth in the enterprise and data visualization market. 

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
I then explored the average salaries associated with specific skills to determine which skills command the highest pay.

```sql
SELECT skills,
    ROUND(AVG(salary_year_avg), 2) as avg_salary
FROM job_postings_fact jp
    INNER JOIN skills_job_dim sj ON jp.job_id = sj.job_id
    INNER JOIN skills_dim s ON sj.skill_id = s.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```
Key Findings:
- **PySpark** leads with an average salary of **$208,000**, reflecting the demand for big data skills.
- **Couchbase**, **DataRobot**, and **Elasticsearch** are also among the top-paying skills, indicating the importance of machine learning and cloud computing expertise.
- **Jupyter** and **Pandas** emphasize the value of Python libraries for data processing and analysis.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Finally, I combined demand and salary data to identify the most optimal skills for data analysts to focus on. These skills offer both high demand and high salaries, making them strategic to learn.

```sql
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
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

*Table of the most optimal skills for data analyst sorted by salary*

Key Findings: 
- **In-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Cloud platforms like Snowflake, Azure, AWS, and BigQuery are becoming increasingly vital in data analytics, with strong demand and higher average salaries. These technologies are powering the shift to cloud-based solutions and big data analytics, making them key players in the modern data landscape.
- **Business Intelligence and Visualization Tools:** Tools like Tableau and Looker are in demand, with 230 and 49 job postings respectively. Their average salaries hover around $99,288 for Tableau and $103,795 for Looker, underscoring the critical role of business intelligence and visualization in translating raw data into actionable insights that drive decision-making.
- **Database Technologies:** Skills in both traditional (like Oracle and SQL Server) and NoSQL databases are highly sought after, with average salaries ranging from $97,786 to $104,534. This highlights the ongoing need for expertise in data storage, retrieval, and management, which remains foundational to effective data analysis and infrastructure.


# 📖 What I Learned

This project has significantly improved my SQL skills and analytical abilities:

- **Complex Query Development:** I've become proficient in advanced SQL techniques, including table joins and using WITH clauses for temporary tables.
- **Data Aggregation:** I'm now comfortable using GROUP BY statements and aggregate functions like COUNT() and AVG() to summarize data effectively.
- **Practical Problem-Solving:** I've enhanced my ability to translate real-world questions into meaningful SQL queries, improving my analytical thinking.

# 💡 Insights

After analyzing the data, here are the main insights I discovered:

1. **Remote Work Compensation:** Top-tier remote data analyst positions offer impressive salaries, with some reaching up to $650,000 annually.
2. **SQL Importance:** Advanced SQL skills are crucial for high-paying data analyst roles, making it a key skill for career advancement.
3. **In-Demand Skills:** SQL is the most sought-after skill in the data analyst job market, essential for job seekers in this field.
4. **Specialized Skills Value:** Niche skills like SVN and Solidity are associated with higher average salaries, showing the value of specialized knowledge.
5. **Optimal Skill Set:** SQL stands out as a highly valuable skill, offering both high demand and competitive salaries.

## 🧐 Concluding Thoughts

This project has not only improved my technical skills but also provided valuable insights into the data analyst job market. The findings offer guidance for skill development and job search strategies. For those aspiring to succeed in data analysis, focusing on high-demand, high-salary skills appears to be a solid approach.
The analysis underscores the importance of continuous learning in this field. As technology and market needs evolve, staying adaptable and expanding one's skill set remains crucial for long-term success in data analytics.
