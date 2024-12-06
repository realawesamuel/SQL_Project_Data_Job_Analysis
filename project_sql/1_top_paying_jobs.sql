/*
    Question: WHat are the top 10 highest paying jobs for Data Analyst,
    who work remotely and find out what company they work for
*/


--In this query I want to get the highest paying jobs for Data Analyst and the job most be remote
SELECT  
    job_id,
    job_title,
    job_title_short,
    cd.name, --I used ALIAS to shorten the name of the table so I can use it easily
    job_location, --If the job is Anywhere that means it is remote
    job_schedule_type,
    salary_year_avg, -- Yearly salary
    job_posted_date

FROM
    job_postings_fact AS jpf -- I am creating an Alias for job_postings_fact table; the new name of the table is jpf
    LEFT JOIN -- I used LEFT JOIN to join this 2 tables together
    company_dim AS cd -- I am also creating an Alias for this table and changing the name from company_dim to cd
    ON
    jpf.company_id = cd.company_id -- This is the column that connects this 2 table together so I can use it to get information from company_dim table

WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL --There as to be value in the cell

ORDER BY 
    salary_year_avg DESC -- Highest to lowest value

LIMIT
    10

