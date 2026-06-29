-- View to display repository details with language and owner information

CREATE VIEW vw_top_repositories AS

SELECT
    dr.Repo_Name,
    dl.Language_Name,
    doo.Owner_Name,
    f.Stars,
    f.Forks
FROM Fact_Repo_Metrics f
JOIN Dim_Repository dr
    ON f.Repo_ID = dr.Repo_ID
JOIN Dim_Language dl
    ON f.Language_ID = dl.Language_ID
JOIN Dim_Owner doo
    ON f.Owner_ID = doo.Owner_ID;


-- View to summarize repository statistics by programming language

CREATE VIEW vw_language_summary AS

SELECT
    dl.Language_Name,
    COUNT(*) AS Repository_Count,
    SUM(f.Stars) AS Total_Stars,
    SUM(f.Forks) AS Total_Forks,
    ROUND(AVG(f.Stars), 2) AS Average_Stars
FROM Fact_Repo_Metrics f
JOIN Dim_Language dl
    ON f.Language_ID = dl.Language_ID
GROUP BY dl.Language_Name;


-- Top 10 repositories by stars

SELECT *
FROM vw_top_repositories
ORDER BY Stars DESC
LIMIT 10;


-- Language summary ordered by total stars

SELECT *
FROM vw_language_summary
ORDER BY Total_Stars DESC;