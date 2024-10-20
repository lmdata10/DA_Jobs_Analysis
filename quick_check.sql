SELECT * FROM job_postings_fact
LIMIT 10;

-- 1
SELECT
	job_schedule_type as job_type,
	ROUND(AVG(salary_hour_avg),2) as Avg_hourly_salary,
	ROUND(AVG(salary_year_avg),2) as Avg_yearly_salary
FROM job_postings_fact
WHERE job_posted_date > 'June 1, 2023'
GROUP BY job_type;



-- 2
/*adjusting the job_posted_date to be in 'America/New_York' time zone
before extracting (hint) the month*/

UPDATE 
	job_postings_fact
SET 
	job_posted_date = job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York';
SELECT 
	job_posted_date 
FROM 
	job_postings_fact;  

--count the number of job postings for each month in 2023
SELECT 
	COUNT(job_id) as job_count,
	EXTRACT (MONTH FROM job_posted_date) AS date_month
FROM 
	job_postings_fact
GROUP BY 
	date_month
ORDER BY 
	date_month;

-- 3
-- checking for quarters

SELECT
	EXTRACT(QUARTER FROM job_posted_date) AS quarter
FROM 
	job_postings_fact;

-- solving using a subquery.

SELECT
	c.name,
	j.job_health_insurance,
	EXTRACT(QUARTER FROM j.job_posted_date) AS quarter
FROM
	job_postings_fact j
JOIN 
	company_dim c
ON 
	j.company_id = c.company_id
WHERE 
	job_health_insurance = TRUE
AND 
	EXTRACT(QUARTER FROM j.job_posted_date) = 2;
