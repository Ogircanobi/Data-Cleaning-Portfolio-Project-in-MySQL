-- DATA CLEANING

SELECT * 
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any Columns or Rows

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location 
,industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company, location 
,industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2;


-- Standardizing Data
-- USING TRIM to remove white space
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- UPDATE Industry names, combine similar ones
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; 
-- updating all Crypto Currency companies as Crypto
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- UPDATE locations if needed

-- Unite States ends with a '.'
SELECT DISTINCT country
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1; 
-- Trim can remove the period
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
order by 1; 

UPDATE layoffs_staging2
SET country  = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'; 

-- Converting date data type from string to date
SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Null values 

-- First set empty spaces to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '' ;


SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 t1
JOIN  layoffs_staging2 t2
	on t1.company = t2.company
    AND t1.location = t2.location
WHERE ( t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN  layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- DELETE rows where total laid off and percentage laid off is blank

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off is NULL;

-- DROP row_num column from table
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;























