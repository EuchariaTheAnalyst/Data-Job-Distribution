# Data-Job-Distribution
MySQL and Excel Project

An end-to-end data analytics project using **MySQL** for data wrangling and **Excel** for dashboard visualization. This project analyzes **672 real job postings** scraped from Glassdoor, with the goal of uncovering trends in salary, skills demand, job levels, work types, and more.

---

**TABLE OF CONTENT**

1. [Objective](#Objective)
2. [Tools & Technologies](#Tools-&-Technologies)
3. [Data Cleaning in MySQL](#Data-Cleaning-in-MySQL)
4. [Feature Engineering](#Feature-Engineering)
5. [Dashboard Visualization in Excel](#Dashboard-Visualization-in-Excel)
6. [Key Insights](#Key-Insights)
7. [Dashboard](#Dashboard)
8. [Conclusion](#Conclusion)

---

##  Objective

To clean and analyze real-world data  job postings and build a dynamic Excel dashboard that delivers strategic labor market insights. This project demonstrates how raw, inconsistent job data can be transformed into a decision-support tool for recruiters, job seekers, and analysts.

---

## Tools & Technologies

| Task                         | Tool            |
|------------------------------|------------------|
| Data Cleaning & Transformation | MySQL            |
| Feature Engineering           | MySQL            |
| Data Analysis & Visualization | Microsoft Excel  |
| Dataset Source                | Glassdoor         |

---

##  Data Cleaning in MySQL 

The original dataset had multiple inconsistencies:
- Salary estimates with varying formats: `$137k-$171k(est.)`, ranges, and symbols
- Company names embedded with ratings
- 70%+ missing or unclear work types
- Text-heavy job descriptions without structure

**Key cleaning steps included:**
- Removing symbols and standardizing salary to numeric ranges
- Splitting `company_name` from ratings
- Classifying `job_type` (remote, onsite, hybrid) using job description logic
- Flagging skills (R, SQL, Python, Excel, etc.) as boolean values from job descriptions
- Parsing job titles to extract experience level and job category
- Cleaning `revenue`, `industry`, `sector`, `size`, and `competitors` columns

---

##  Feature Engineering

Created new, analysis-ready columns:
- `avg_salary` → average of min/max salary extracted from messy text
- `job_seniority` → junior, lead, mid-level or senior based on job title keywords
- `job_category` → categorized job titles (e.g., Data Scientist, Data Analyst, ML Engineer, Data Engineer)
- `job_type` → remote, hybrid, onsite (based on location + description)
- Boolean flags: `has_r`, `has_sql`, `has_python`, `has_excel`, `has_powerbi`, etc.
- `company_rating` → separated from `company_name`
- Cleaned `revenue`, `size`, and `industry` fields for consistency

---

##  Dashboard Visualization in Excel

Built an interactive dashboard in Excel with:
- Dynamic filters (slicers) by job level, organization, work type, rating
- Star-based visual for average company ratings
- PivotTables and custom formulas for metrics

###  KPIs Displayed:
- Total Job Postings  
- Average Salary  
- Average Company Rating  
- Top In-Demand Skill

###  Visuals Included:
- **Bar Chart** – Top-paying countries & Top hiring companies  
- **Donut Charts** – Work type, job level, job category  
- **Clustered Bar** – Skill demand by job level  
- **Map** – Average salaries by state

---

##  Key Insights

- R, Python, and SQL are the most in-demand skills across all job levels  
- Senior roles tend to offer higher average salaries and favor onsite work  
- Remote roles are more common in tech-focused regions  
- Most jobs fall into the “Data Scientist” and “ML Engineer” categories

---

##  Dashboard

<img width="797" alt="Image" src="https://github.com/user-attachments/assets/bd17bdba-d6c6-409e-944f-03d0474e6e57" />

[DASHBOARD](https://1drv.ms/x/c/5229c7255eb7350e/EYXoIfAQo0tFiPnbSmSqcgwBKPb-9lO2ARZ3LghXggRW3w)

---

## Conclusion

This dashboard was built not just as a data project, but as a tool to help job seekers and career coaches better understand the realities of the data  job market.

By analyzing this project, it surfaces key insights such as:

- Which skills are truly in demand (e.g. R, SQL, Python, Excel)

- What roles offer higher salaries and which regions pay more

- How work types are distributed:  remote, hybrid, onsite

- What employers expect at different experience levels

For anyone pursuing a career in data, this dashboard can serve as a guide, showing where to focus learning, how to position yourself, and what trends to watch in a fast-changing industry.
