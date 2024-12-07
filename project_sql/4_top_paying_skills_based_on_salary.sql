/*
    Question: What are the top skills based on salary on the 5 most in demand skills
    It helps us know the skills that are more rewarding
*/

SELECT
    skills,--This column is from the skills_dim table
    ROUND(AVG(salary_year_avg),0) AS average_salary -- I used round to remove the decimal numbers and Alias to change the name of the column

FROM
    job_postings_fact AS jpf 
    INNER JOIN 
    skills_job_dim AS sjd
    ON
    jpf.job_id = sjd.job_id
    INNER JOIN
    skills_dim AS sd
    ON
    sjd.skill_id = sd.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    AND
    (
        skills IN ('sql','python','excel','tableau','power bi')--I used this to filter for the jobs that are in high demand to see the average salary
    )

GROUP BY
    skills

ORDER BY
    average_salary DESC

LIMIT
    10