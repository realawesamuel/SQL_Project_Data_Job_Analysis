/*
    Question: What are the optimal skill to learn
    Conditions
        1. It is in high demand 
        2. It is high Paying
    Since I have already done for the skills that are in high demand and are high paying 
    I can just use them as CTE
*/

WITH top_paying_skill AS --This a CTE containing queries from the fourth question
(
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

    GROUP BY
        skills

)
,top_demanded_skills AS--This is also a CTE containing queies from my third question
/*
    It is important to note that I used ',' to seperate the 2 CTE because SQL won't allow you calling 2 CTE
*/
(
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
)

SELECT
    top_paying_skill.skills,--This is the column of the skills gotten from top_paying_skill CTE 
    top_demanded_skills.number_of_applications,--This is the column of the number of application gotten from top_demanded_skill CTE 
    top_paying_skill.average_salary--This is the column of the average salary based on skill gotten from top_paying_skill CTE 

FROM
    top_paying_skill
    INNER JOIN
    top_demanded_skills
    ON
    top_paying_skill.skills = top_demanded_skills.skills

ORDER BY
    top_demanded_skills.number_of_applications DESC,--I first ordered by number_of_applications 
    top_paying_skill.average_salary--Then I ordered by the salary based on skill