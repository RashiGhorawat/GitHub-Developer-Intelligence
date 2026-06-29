

-- 1. Repository count, total stars, total forks and average stars by language

SELECT
    dl.Language_Name,
    COUNT(*) AS Repository_Count,
    SUM(f.Stars) AS Total_Stars,
    SUM(f.Forks) AS Total_Forks,
    ROUND(AVG(f.Stars),2) AS Average_Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Language dl
    ON f.Language_ID = dl.Language_ID
GROUP BY dl.Language_Name
ORDER BY Total_Stars DESC;


-- 2. Top 10 repositories based on stars

SELECT
    dr.Repo_Name,
    f.Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID
ORDER BY f.Stars DESC
LIMIT 10;


-- 3. Top 10 repository owners by total stars

SELECT
    doo.Owner_Name,
    SUM(f.Stars) AS Total_Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Owner doo
    ON f.Owner_ID = doo.Owner_ID
GROUP BY doo.Owner_Name
ORDER BY Total_Stars DESC
LIMIT 10;


-- 4. Rank repositories by stars

SELECT
    dr.Repo_Name,
    f.Stars,
    RANK() OVER (ORDER BY f.Stars DESC) AS Repository_Rank
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID;


-- 5. Dense rank repositories by stars

SELECT
    dr.Repo_Name,
    f.Stars,
    DENSE_RANK() OVER (ORDER BY f.Stars DESC) AS Dense_Rank
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID;


-- 6. Divide repositories into four star-based groups

SELECT
    dr.Repo_Name,
    f.Stars,
    NTILE(4) OVER (ORDER BY f.Stars DESC) AS Quartile
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID;


-- 7. Calculate total stars earned by each language using a CTE

WITH LanguageStars AS
(
    SELECT
        dl.Language_Name,
        SUM(f.Stars) AS Total_Stars
    FROM Fact_Repo_Metrics f
    JOIN Dim_Language dl
        ON f.Language_ID = dl.Language_ID
    GROUP BY dl.Language_Name
)

SELECT *
FROM LanguageStars
ORDER BY Total_Stars DESC;


-- 8. Languages having more than 50 repositories

SELECT
    dl.Language_Name,
    COUNT(*) AS Repository_Count
FROM Fact_Repo_Metrics f
JOIN Dim_Language dl
    ON f.Language_ID = dl.Language_ID
GROUP BY dl.Language_Name
HAVING COUNT(*) > 50;


-- 9. Repositories having more stars than the overall average

SELECT
    dr.Repo_Name,
    f.Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID
WHERE f.Stars >
(
    SELECT AVG(Stars)
    FROM Fact_Repo_Metrics
);


-- 10. Repository creation trend by year

SELECT
    d.Year,
    COUNT(*) AS Repository_Count
FROM Fact_Repo_Metrics f
JOIN Dim_Date d
    ON f.Date_ID = d.Date_ID
GROUP BY d.Year
ORDER BY d.Year;


-- 11. Repository creation trend by quarter

SELECT
    d.Year,
    d.Quarter,
    COUNT(*) AS Repository_Count
FROM Fact_Repo_Metrics f
JOIN Dim_Date d
    ON f.Date_ID = d.Date_ID
GROUP BY d.Year, d.Quarter
ORDER BY d.Year, d.Quarter;


-- 12. Average stars received by each programming language

SELECT
    dl.Language_Name,
    ROUND(AVG(f.Stars),2) AS Average_Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Language dl
    ON f.Language_ID = dl.Language_ID
GROUP BY dl.Language_Name
ORDER BY Average_Stars DESC;