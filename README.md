# Introduction
Dive into the data job market with a focus on data analyst roles. This project explores high-paying positions, in-demand skills, and the intersections where strong demand meets high salary in data analytics.

SQL Queries Available: Explore them: [project_sql folder](/project_sql/)
# Background
Driven by a desire to navigate the data analyst job market more effectively, this project was created to identify top-paid and in-demand skills, making it easier for others to find optimal job opportunities.

### The questions I aimed to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?

2. What skills are required for these top-paying jobs?

3. What skills are most in demand for data analysts?

4. Which skills are associated with higher salaries?

5. What are the most optimal skills to learn?
# Tools I used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL**: The backbone of my analysis, allowing me to query the database and uncover critical insights.

- **PostgreSQL**: The chosen database management system, ideal for handling job posting data.

- **Visual Studio Code**: My preferred tool for database management and executing SQL queries.

- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, specifically focusing on remote jobs. This query highlights the lucrative opportunities in the field.

```sql
SELECT  
    job_id,
    job_title,
    job_title_short,
    cd.name, 
    job_location, 
    job_schedule_type,
    salary_year_avg, 
    job_posted_date

FROM
    job_postings_fact AS jpf 
    LEFT JOIN 
    company_dim AS cd company_dim to cd
    ON
    jpf.company_id = cd.company_id 

WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    salary_year_avg IS NOT NULL 

ORDER BY 
    salary_year_avg DESC 

LIMIT
    10
```
Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range**: The top 10 paying data analyst roles span from $184,000 to $650,000, indicating substantial salary potential in the field.
- **Diverse Employers**: Companies such as SmartAsset, Meta, and AT&T are offering high salaries, showcasing a broad interest across different industries.
- **Variety of Job Titles**: There is a high diversity in job titles, ranging from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](assets\1_top_paying_roles.png)
*To create a bar chart visualizing the salary distribution for the top 10 highest-paying data analyst jobs, I exported the results of the SQL query to Excel. This approach allows for an effective way to display and analyze the data, providing a clear visual representation of the average yearly salaries for these top positions.*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs --This is a CTE that I used and it contains the information of the top 10 highest paid Data Analyst
(
    SELECT
        job_id,
        job_title,
        job_location,
        name,
        salary_year_avg,
        job_posted_date


    FROM
        job_postings_fact AS jpf
        LEFT JOIN
        company_dim AS cd
        ON
        jpf.company_id = cd.company_id

    WHERE
        job_title_short = 'Data Analyst'
        AND
        job_location = 'Anywhere'
        AND
        salary_year_avg IS NOT NULL

    ORDER BY
        salary_year_avg DESC

    LIMIT
        10
)-- This query is no different from the first query, I just made litle adjustment

SELECT
    tpj.*,-- To select all the column that I created in the CTE
    skills -- Column to get the skills from the skills_dim table

FROM
    top_paying_jobs AS tpj 
    INNER JOIN -- I used an INNER JOIN because I want to select all data that match both tables
    skills_job_dim AS sjd 
    ON
    tpj.job_id = sjd.job_id
    INNER JOIN
    skills_dim AS sd 
    ON
    sjd.skill_id = sd.skill_id

ORDER BY
    tpj.salary_year_avg DESC

```
Here’s the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a strong presence, being required in 8 of the top 10 highest paying data analyst jobs.
- **Python** follows with a solid count of 7.
- **Tableau** is also highly sought after, with a count of 6. **R**, **Snowflake**, **Pandas**, and **Excel** are also in demand.
![Top Paying Skills](assets\2_top_paying_skills.png)
*Bar chart visualizing the count of skills for the top 10 paying jobs for Data Analyst; Chart generated from Excel*

### 3 In-Demand Skills for Data Analysts


This query helped identify the skills most frequently requested in job postings, highlighting areas with high demand and guiding focus accordingly.

```sql
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023:

- **SQL** and  **Excel** remain fundamental, underscoring the importance of strong foundational skills in data processing and spreadsheet manipulation.

- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, highlighting the growing need for technical skills in data storytelling and decision support.

| Skill        | Number of Applications |
|--------------|------------------------|
| SQL          | 92,628                 |
| Excel        | 67,031                 |
| Python       | 57,326                 |
| Tableau      | 46,554                 |
| Power BI     | 39,468                 |

*Overview of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Bassed on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql

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
```
Here's a breakdown of the results of the most demand skill based on salary:
- **Python** offers the highest average salary among the top 5 skills, reflecting its critical role in data analysis and machine learning applications.
- **Tableau** follows with a slightly lower average salary, yet remains highly valuable for data visualization and business intelligence.
- **SQL and Power BI** provide solid average salaries, indicating strong demand for data processing and reporting skills.
- **Excel** still holds a respectable position with a notable average salary, underscoring its continued importance in data manipulation and analysis.

| Skill        | Average Salary($) |
|--------------|------------------------|
| Python       | 101,512                |
| Tableau      | 97,978                 |
| SQL          | 96,435                 |
| Power BI     | 92,324                 |
| Excel        | 86,419                 |

*Table of the average salary for the top 5 in demand skills*

### 5. Most Optimal Skills to Learn

By integrating insights from demand and salary data, this query aimed to identify skills that are both highly sought after and offer high salaries, providing a strategic direction for skill development.

```sql

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

LIMIT
    10
```

| Skill         | Number of Applications | Average Salary ($) |
|---------------|------------------------|--------------------|
| SQL           | 92,628                 | 96,435              |
| Excel         | 67,031                 | 86,419              |
| Python        | 57,326                 | 101,512             |
| Tableau       | 46,554                 | 97,978              |
| Power BI      | 39,468                 | 92,324              |
| R             | 30,075                 | 98,708              |
| SAS           | 28,068                 | 93,707              |
| PowerPoint    | 13,848                 | 88,316              |
| Word          | 13,591                 | 82,941              |
| SAP           | 11,297                 | 92,446              |

*Table of the most optimal skill for Data Analyst*

### **Here's the breakdown of the most optimal skills for Data Analysts:**

- **Python** leads with the highest average salary at $101,512, indicating strong demand and premium pay for this skill, especially in data analysis and machine learning roles.
- **SQL** follows with an average salary of $96,435, showing its importance as a foundational skill in data processing and database management.
- **Tableau** and **Power BI** are close behind with average salaries of $97,978 and $92,324, respectively, reflecting high demand for data visualization skills.
- **R** and **SAS** also show competitive average salaries ($98,708 and $93,707, respectively), emphasizing their roles in statistical analysis and data manipulation.
- **Excel** maintains a solid average salary of $86,419, underlining its continued relevance in data management and analysis.
- **PowerPoint** and **Word** have lower average salaries compared to other skills listed, which might reflect their more traditional or general use in office environments.
- **SAP** holds a respectable average salary of $92,446, highlighting its importance in enterprise resource planning (ERP) systems.


# What I learned
Throughout this journey, I have significantly advanced my SQL skills:

- **Complex Query Crafting:** I have developed expertise in constructing sophisticated SQL queries, including merging multiple tables and utilizing the WITH clause for efficient temporary data handling.

- **Data Aggregation:**  I am proficient in using GROUP BY and applying aggregate functions such as COUNT() and AVG() to effectively summarize and analyze data.

- **Analytical Wizardry:** I have refined my ability to transform analytical questions into actionable, insightful SQL queries, enhancing my problem-solving skills in real-world scenarios.
# Conclusions

### Insights

From the analysis, several key insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest paying data analyst jobs that allow remote work offer a broad salary range, with the highest reaching $650,000.
2. **Skills for Top-Paying Jobs**: High-paying data analyst roles demand advanced proficiency in SQL, highlighting its critical role in securing a high salary.
3. **Most In-Demand Skills**: SQL is the most sought-after skill in the data analyst job market, emphasizing its importance for job seekers.
4. **Skills with High Salaries**: Programming is crucial for maximizing earning potential in data analysis. Although Excel remains relevant, its average salary is lower due to the lower barrier to entry compared to other programming skills.
5. **Optimal Skills for Job Market Value**: SQL stands out due to its high demand and strong average salary, making it one of the most optimal skills for data analysts to acquire to enhance their market value.

### Closing Thoughts

This project significantly enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a strategic guide for prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration underscores the importance of continuous learning and adaptation to emerging trends in the field of data analytics.






