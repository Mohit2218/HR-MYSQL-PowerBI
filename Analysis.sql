-- QUESTIONS

-- 1.What is the gender breakdown for employees?
SELECT gender,COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate = '0000-00-00'
GROUP BY gender; 

-- 2.What is the race/ethnicity breakdown of employees?
SELECT race,COUNT(*) AS distribution
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY race
ORDER BY distribution DESC;

-- 3.What is the age distribution of employees?
SELECT min(age) AS youngest, max(age) AS oldest
FROM hr
WHERE age >=18 AND termdate ='0000-00-00';

SELECT 
	CASE 
		WHEN age >=18 AND age <= 24 THEN '18-24'
		WHEN age >=25 AND age <= 34 THEN '25-34'
		WHEN age >=35 AND age <= 44 THEN '35-44'
		WHEN age >=45 AND age <= 54 THEN '45-54'
		WHEN age >=55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group,
	COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE 
		WHEN age >=18 AND age <= 24 THEN '18-24'
		WHEN age >=25 AND age <= 34 THEN '25-34'
		WHEN age >=35 AND age <= 44 THEN '35-44'
		WHEN age >=45 AND age <= 54 THEN '45-54'
		WHEN age >=55 AND age <= 64 THEN '55-64'
		ELSE '65+'
	END AS age_group,gender,
	COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY age_group,gender
ORDER BY age_group,gender;

-- 4.How many employees work at headquarters  VS remote?
SELECT location,COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY location;

-- 5.What is the average length of employment for employees who have been terminated?
SELECT
	ROUND(AVG(datediff(termdate,hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >=18;

-- 6.How does gender distribution vary across departments?
SELECT gender,department,COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY department,gender
ORDER BY department;

-- 7.What is the distribution of job titles across the company?
SELECT jobtitle,COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8.Which department has highest termination rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <=CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age>=18
    GROUP BY department
)AS subquery
ORDER BY termination_rate DESC;

-- 9.What is the distribution of employees across locations cities and states?
SELECT location_state,COUNT(*) AS count
FROM hr
WHERE age >=18 AND termdate ='0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10.How has employee count changed over time based on hire and term dates?
SELECT 
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires*100,2) AS percent_change
FROM(
	SELECT YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate<=curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age>=18
    GROUP BY YEAR(hire_date)
)AS subquery
ORDER BY year ASC;

-- 11.What is the tenure distribution for each department
SELECT department, round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate<=curdate() AND termdate <> '0000-00-00' AND age>=18
GROUP BY department;