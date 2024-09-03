-- Exploratory Data Analysis


SELECT *
FROM layoffs_staging2;

SELECT company, MAX(total_laid_off)
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT COUNTRY, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY 1
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,1,7 ) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7 ) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC;


WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7 ) AS `MONTH` , SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7 ) IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER (ORDER BY `MONTH`) AS RollingTotal
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;



WITH Company_year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_year_rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5; 


SELECT industry, YEAR(`date`), SUM(total_laid_off) AS total_offs
FROM layoffs_staging2
WHERE industry != 'Other'
GROUP BY industry, YEAR(`date`)
ORDER BY 3 DESC;





