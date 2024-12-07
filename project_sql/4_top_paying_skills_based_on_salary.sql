/*
    Question: What are the top skills based on salary on the 5 most in demand skills
    It helps us know the skills that are more rewarding
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary

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
        skills IN ('sql','python','excel','tableau','power bi')
    )

GROUP BY
    skills

ORDER BY
    average_salary DESC

LIMIT
    10