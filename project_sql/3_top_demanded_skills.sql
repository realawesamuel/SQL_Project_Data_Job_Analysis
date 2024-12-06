/*
    Question: What is the 5 most in demand skill for Data Analyst. 

*/


SELECT
    sd.skills,--This is a column in the skills_dim table
    COUNT(jpf.job_id) AS number_of_applications--To know the total number of jobs
    

FROM
    job_postings_fact AS jpf 
    INNER JOIN -- I used inner join so I can select data that match in both table
    skills_job_dim AS sjd 
    ON
    jpf.job_id = sjd.job_id
    INNER JOIN
    skills_dim AS sd
    ON 
    sjd.skill_id = sd.skill_id

WHERE
    job_title_short = 'Data Analyst'-- I am filtering for Data analyst job

GROUP BY
    skills--I have to use a group by function because I used an agregate function in the SELECT statement

ORDER BY
    number_of_applications DESC--I ordered the number of applications with skill name from highest to lowest

LIMIT
    5