-- Display the top repositories based on stars

DELIMITER $$

CREATE PROCEDURE GetTopRepositories()
BEGIN
    SELECT
        dr.Repo_Name,
        f.Stars,
        f.Forks
    FROM Fact_Repo_Metrics f
    JOIN Dim_Repository dr
        ON f.Repo_ID = dr.Repo_ID
    ORDER BY f.Stars DESC
    LIMIT 10;
END $$

DELIMITER ;


-- Display repository statistics by programming language

DELIMITER $$

CREATE PROCEDURE GetLanguageSummary()
BEGIN
    SELECT
        dl.Language_Name,
        COUNT(*) AS Repository_Count,
        SUM(f.Stars) AS Total_Stars,
        SUM(f.Forks) AS Total_Forks
    FROM Fact_Repo_Metrics f
    JOIN Dim_Language dl
        ON f.Language_ID = dl.Language_ID
    GROUP BY dl.Language_Name
    ORDER BY Total_Stars DESC;
END $$

DELIMITER ;


-- Run the procedures

CALL GetTopRepositories();

CALL GetLanguageSummary();