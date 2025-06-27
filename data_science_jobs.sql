CREATE DATABASE data_jobs;
CREATE TABLE data_science_jobs(
        job_title TEXT,	
        salary_estimate TEXT,
        job_description TEXT,
        rating TEXT,
        company_name TEXT,
        location TEXT,
        headquarters TEXT,
        size TEXT,
        founded TEXT,
        type_of_ownership TEXT,
        industry TEXT,
        sector TEXT,
        revenue TEXT,
        competitors TEXT
	);

-- DATASET IMPORTING --
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\data science job.csv'
INTO TABLE data_science_jobs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;    -- TO TURN OFF SAFE UPDATE MODE

-- DATA CLEANING --
UPDATE data_science_jobs 
SET
    job_title = CASE
        WHEN job_title IS NULL OR TRIM(job_title) = '' THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(TRIM(LEADING '.' FROM job_title), '(', 1), ',', 1)), 1)),
            LOWER(SUBSTRING(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(TRIM(LEADING '.' FROM job_title), '(', 1), ',', 1)), 2))
        )
    END,

    location = CASE
        WHEN location IS NULL OR TRIM(location) = '' THEN 'Unknown'
        ELSE CONCAT(
            UPPER(LEFT(
                TRIM(
                    REGEXP_REPLACE(
                        SUBSTRING_INDEX(SUBSTRING_INDEX(TRIM(LEADING '.' FROM location), '(', 1), ',', 1),
                        '[^a-zA-Z ]', ''
                    )
                ), 1)
            ),
            LOWER(SUBSTRING(
                TRIM(
                    REGEXP_REPLACE(
                        SUBSTRING_INDEX(SUBSTRING_INDEX(TRIM(LEADING '.' FROM location), '(', 1), ',', 1),
                        '[^a-zA-Z ]', ''
                    )
                ), 2)
            )
        )
    END,
    headquarters = CASE
        WHEN headquarters IS NULL OR TRIM(headquarters) = '' OR headquarters = '-1'THEN 'Unknown'
        ELSE TRIM(headquarters)
    END,
    salary_estimate = CASE
        WHEN salary_estimate IS NULL OR TRIM(salary_estimate) = '' THEN 'Not Disclosed'
        ELSE TRIM(
           REGEXP_REPLACE(
              REPLACE(salary_estimate, 'Employer Provided Salary:', ''),
              '\\([^)]*\\)', ''
              )
			)
    END,
    rating = CASE
        WHEN rating IS NULL OR rating = '' OR rating NOT REGEXP '^[0-9]+(\\.[0-9]+)?$' THEN '0.0'
        ELSE TRIM(rating)
    END,
    founded = CASE
        WHEN founded IS NULL OR TRIM(founded) = '' OR founded NOT REGEXP '^[0-9]{4}$' THEN NULL
        ELSE founded
    END,
    size = TRIM(
          CASE 
             WHEN size IS NULL OR TRIM(size) = '' OR size = '-1' THEN 'Unknown'
             ELSE REPLACE(
                        REPLACE(LOWER(size), 'employees', ''),
					'to', '-')
			END
            ),
    type_of_ownership = TRIM(
             CASE
        WHEN type_of_ownership IS NULL OR TRIM(type_of_ownership) = '' OR type_of_ownership = '-1' THEN 'Unknown'
        ELSE TRIM(type_of_ownership)
    END
    ),
    industry = CASE
        WHEN industry IS NULL OR TRIM(industry) = '' OR industry = '-1' THEN 'Unknown'
        ELSE TRIM(industry)
    END,
  sector = CASE
        WHEN sector IS NULL OR TRIM(sector) = '' OR SECTOR = '-1' THEN 'Unknown'
        ELSE TRIM(sector)
    END,
  revenue = CASE
        WHEN revenue IS NULL OR TRIM(revenue) = '' THEN 'Unknown'
        ELSE CONCAT(
                REPLACE(
					  REPLACE(
                        REPLACE(
                           REPLACE(
                             REPLACE(
                               LOWER(TRIM(revenue)), 
                               '()', ''
                               ),
                              '$', ''
                              ), 
                            'to', '-'  
                    ), 'million', 'M'
                    ),
                    'billion', 'B'
			))
   END,
    competitors = CASE
        WHEN competitors IS NULL OR TRIM(competitors) = '' OR competitors = '-1' THEN 'None Listed'
        ELSE TRIM(competitors)
    END
WHERE 1 = 1;


SELECT 
    company_name,
    SUBSTRING_INDEX(company_name, '\n', 1) AS cleaned_company_name
FROM data_science_jobs;

UPDATE data_science_jobs
SET company_name = TRIM(SUBSTRING_INDEX(company_name, '\n', 1))
WHERE company_name IS NOT NULL;


SELECT * 
FROM data_science_jobs; 

ALTER TABLE data_science_jobs
ADD COLUMN has_sql BOOLEAN,
ADD COLUMN python BOOLEAN,
ADD COLUMN excel BOOLEAN,
ADD COLUMN tableau BOOLEAN,
ADD COLUMN r BOOLEAN,
ADD COLUMN powerbi BOOLEAN,
ADD COLUMN job_level VARCHAR(50),
ADD COLUMN work_type VARCHAR(50),
ADD COLUMN min_salary INT,
ADD COLUMN max_salary INT,
ADD COLUMN avg_salary INT;

-- UPDATING THE NEW COLUMNS-- 1: SKILLS
UPDATE data_science_jobs
SET 
    has_sql = CASE WHEN LOWER(job_description) LIKE '%sql%' THEN TRUE ELSE FALSE END,
    python =  CASE WHEN LOWER(job_description) LIKE '%python%' THEN TRUE ELSE FALSE END,
    excel =  CASE WHEN LOWER(job_description) LIKE '%excel%' THEN TRUE ELSE FALSE END,
    tableau =  CASE WHEN LOWER(job_description) LIKE '%tableau%' THEN TRUE ELSE FALSE END,
    r =  CASE WHEN LOWER(job_description) LIKE '% r%' OR LOWER(job_description) LIKE '% r,' THEN TRUE ELSE FALSE END,
    powerbi =  CASE WHEN LOWER(job_description) LIKE '%powerbi%' THEN TRUE ELSE FALSE END;
    
    -- JOB LEVEL-- 
    UPDATE data_science_jobs
    SET job_level = CASE
       WHEN LOWER(job_description) REGEXP '(^| )junior|jr\\b' THEN 'Junior'
       WHEN LOWER(job_description) REGEXP '(^| )senior|sr\\b' THEN 'Senior'
	   WHEN LOWER(job_description) REGEXP '(^| )lead|principal|manager|hr' THEN 'Lead'
       ELSE 'Mid-Level'
    END;  
    
    -- JOB TITLE CATEGORY 
    ALTER TABLE data_science_jobs 
    ADD COLUMN job_category VARCHAR(50);
    
    UPDATE data_science_jobs
    SET job_category = CASE
       WHEN job_title LIKE '%scientist%' THEN 'Data Scientist'
	   WHEN job_title LIKE '%data engineer%' THEN 'Data Engineer'
	   WHEN job_title LIKE '%analyst%' THEN 'Data Analyst'
	   WHEN job_title LIKE '%machine learning%' THEN 'ML Engineer'
       ELSE 'Other'
	END;
    
    -- WORK TYPE-- 
  UPDATE data_science_jobs
  SET work_type = CASE 
      WHEN LOWER(job_description) REGEXP 'hybrid|flexible|partially remote' OR 
	  LOWER(location) REGEXP 'hybrid|flexible|partially remote' THEN 'Hybrid'
	  WHEN LOWER(job_description) REGEXP 'remote|work from home|wfh|fully remote' OR 
	  LOWER(location) REGEXP 'remote|work from home|wfh|fully remote' THEN 'Remote'
	  WHEN LOWER(job_description) REGEXP 'onsite|on-site|in[- ]?office|office only' OR 
	  LOWER(location) REGEXP 'onsite|on-site|in[- ]?office|office only' THEN 'Onsite'
	  ELSE 'Unknown'
END;
  
-- SALARY COLUMNS--
UPDATE data_science_jobs
SET 
   min_salary = CAST(REPLACE(REPLACE(SUBSTRING_INDEX(salary_estimate, '-', 1), '$', ''), 'K', '') AS UNSIGNED) * 1000,
   max_salary = CAST(REPLACE(REPLACE(SUBSTRING_INDEX(salary_estimate, '-', -1), '$', ''), 'K', '') AS UNSIGNED) * 1000
WHERE salary_estimate IS NOT NULL AND salary_estimate LIKE '%-%';
    
-- SALARY AVERAGE
UPDATE data_science_jobs
SET avg_salary = ROUND(min_salary + max_salary) / 2
WHERE min_salary IS NOT NULL AND max_salary IS NOT NULL
;

