# Global Layoff Data Analysis Project

## Project Overview

This project involves transforming raw layoff data from the COVID-19 pandemic into a more usable format using MySQL. The goal was to clean and standardize the data, making it suitable for in-depth analysis to uncover meaningful insights about global layoffs during the pandemic.

## Table of Contents
1. [Introduction](#introduction)
2. [Data Cleaning Process](#data-cleaning-process)
    - [Remove Duplicates](#remove-duplicates)
    - [Standardize Data](#standardize-data)
    - [Handle Null Values](#handle-null-values)
    - [Remove Unnecessary Columns or Rows](#remove-unnecessary-columns-or-rows)
3. [Technologies Used](#technologies-used)
4. [Getting Started](#getting-started)
5. [Conclusion](#conclusion)

## Introduction

In this project, I utilized MySQL to transform and clean raw layoff data from the pandemic. The process involved removing duplicates, standardizing data formats, handling null values, and eliminating unnecessary columns or rows. This project demonstrates my ability to handle real-world data and prepare it for detailed analysis.

## Data Cleaning Process

### Remove Duplicates

1. **Create a Staging Table:**
   ```sql
   CREATE TABLE layoffs_staging LIKE layoffs;
   INSERT INTO layoffs_staging SELECT * FROM layoffs;
   ```

2. **Identify and Remove Duplicates:**
   ```sql
   WITH duplicate_cte AS (
       SELECT *, ROW_NUMBER() OVER(
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
       FROM layoffs_staging
   )
   DELETE FROM layoffs_staging2 WHERE row_num > 1;
   ```

### Standardize Data

1. **Remove Whitespace:**
   ```sql
   UPDATE layoffs_staging2 SET company = TRIM(company);
   ```

2. **Update Industry Names:**
   ```sql
   UPDATE layoffs_staging2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%';
   ```

3. **Update Locations:**
   ```sql
   UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country) WHERE country LIKE 'United States%';
   ```

4. **Convert Date Format:**
   ```sql
   UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');
   ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
   ```

### Handle Null Values

1. **Set Empty Strings to NULL:**
   ```sql
   UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';
   ```

2. **Fill NULL Values from Other Rows:**
   ```sql
   UPDATE layoffs_staging2 t1 JOIN layoffs_staging2 t2
   ON t1.company = t2.company
   SET t1.industry = t2.industry
   WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
   ```

### Remove Unnecessary Columns or Rows

1. **Delete Rows with NULL Layoff Data:**
   ```sql
   DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
   ```

2. **Drop Temporary Columns:**
   ```sql
   ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
   ```

## Technologies Used

- **MySQL**: Used for data storage, querying, and transformation.
- **SQL**: For writing and executing database queries.

## Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/layoff-data-analysis.git
   ```

2. **Set Up the Database:**
   - Import the `layoffs` table into your MySQL server.
   - Run the SQL script provided to create and clean the `layoffs_staging` and `layoffs_staging2` tables.

3. **Run the Queries:**
   - Execute the queries in the provided SQL script to clean and standardize the data.

## Conclusion

This project demonstrates my proficiency in using MySQL for data cleaning and transformation. By converting raw data into a structured and standardized format, I enabled comprehensive analysis and insight generation. This project highlights my ability to work with large datasets, apply SQL techniques, and prepare data for further analytical processes.

