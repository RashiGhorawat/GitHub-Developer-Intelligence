-- Disable foreign key checks before refreshing the warehouse
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE Fact_Repo_Metrics;
TRUNCATE TABLE Dim_Date;
TRUNCATE TABLE Dim_Repository;
TRUNCATE TABLE Dim_Owner;
TRUNCATE TABLE Dim_Language;

SET FOREIGN_KEY_CHECKS = 1;

-- Load unique programming languages
INSERT INTO Dim_Language (Language_Name)
SELECT DISTINCT language
FROM repositories
WHERE language IS NOT NULL;

-- Load unique repository owners
INSERT INTO Dim_Owner (Owner_Name)
SELECT DISTINCT owner
FROM repositories;

-- Load unique repositories
INSERT INTO Dim_Repository (Repo_Name)
SELECT DISTINCT name
FROM repositories;

-- Load date dimension
INSERT INTO Dim_Date
(
    Full_Date,
    Year,
    Month,
    Quarter
)
SELECT DISTINCT
    DATE(STR_TO_DATE(created_at,'%Y-%m-%dT%H:%i:%sZ')),
    YEAR(STR_TO_DATE(created_at,'%Y-%m-%dT%H:%i:%sZ')),
    MONTH(STR_TO_DATE(created_at,'%Y-%m-%dT%H:%i:%sZ')),
    CONCAT('Q', QUARTER(STR_TO_DATE(created_at,'%Y-%m-%dT%H:%i:%sZ')))
FROM repositories;

-- Load fact table
INSERT INTO Fact_Repo_Metrics
(
    Repo_ID,
    Language_ID,
    Owner_ID,
    Date_ID,
    Stars,
    Forks
)
SELECT
    dr.Repo_ID,
    dl.Language_ID,
    doo.Owner_ID,
    dd.Date_ID,
    r.stars,
    r.forks
FROM repositories r
JOIN Dim_Repository dr
    ON r.name = dr.Repo_Name
JOIN Dim_Language dl
    ON r.language = dl.Language_Name
JOIN Dim_Owner doo
    ON r.owner = doo.Owner_Name
JOIN Dim_Date dd
    ON DATE(STR_TO_DATE(r.created_at,'%Y-%m-%dT%H:%i:%sZ')) = dd.Full_Date;