
USE github_analytics;

-- Raw GitHub repository data
CREATE TABLE repositories (
    name VARCHAR(200),
    language VARCHAR(50),
    stars INT,
    forks INT,
    owner VARCHAR(100),
    created_at VARCHAR(50)
);

-- Language dimension
CREATE TABLE Dim_Language (
    Language_ID INT AUTO_INCREMENT PRIMARY KEY,
    Language_Name VARCHAR(50)
);

-- Owner dimension
CREATE TABLE Dim_Owner (
    Owner_ID INT AUTO_INCREMENT PRIMARY KEY,
    Owner_Name VARCHAR(100)
);

-- Repository dimension
CREATE TABLE Dim_Repository (
    Repo_ID INT AUTO_INCREMENT PRIMARY KEY,
    Repo_Name VARCHAR(200)
);

-- Date dimension
CREATE TABLE Dim_Date (
    Date_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Date DATE,
    Year INT,
    Month INT,
    Quarter VARCHAR(2)
);

-- Fact table
CREATE TABLE Fact_Repo_Metrics (
    Repo_ID INT,
    Language_ID INT,
    Owner_ID INT,
    Date_ID INT,
    Stars INT,
    Forks INT,

    FOREIGN KEY (Repo_ID) REFERENCES Dim_Repository(Repo_ID),
    FOREIGN KEY (Language_ID) REFERENCES Dim_Language(Language_ID),
    FOREIGN KEY (Owner_ID) REFERENCES Dim_Owner(Owner_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID)
);