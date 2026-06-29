# GitHub Developer Intelligence

A Power BI dashboard built on GitHub repository data collected through the GitHub REST API. This project analyzes repository popularity, programming language trends, and owner performance using Python, MySQL, SQL, and Power BI.

## Project Overview

The project uses data from 3,018 public GitHub repositories across 15 programming languages. The data was collected using the GitHub REST API, processed with Python, stored in MySQL, and visualized in Power BI.

## Data Pipeline

```
GitHub REST API
      │
      ▼
Python ETL
      │
      ▼
MySQL Database
      │
      ▼
Power BI Dashboard
```

## Dashboard Pages

### Executive Overview

- Repository statistics
- Top repositories by stars
- Top owners by stars
- Repository and owner KPIs

### Language Intelligence

- Stars by programming language
- Average stars per repository
- Repository trends over time
- Repository distribution by language

### Repository Performance

- Top repositories by forks
- Repository creation trend
- Stars vs. forks analysis

### Owner Intelligence

- Top owners by stars
- Top owners by forks
- Repository count by owner
- Average stars per repository

## Technologies Used

- Python
- GitHub REST API
- Pandas
- MySQL
- SQL
- Power BI
- DAX

## Dataset

| Metric | Value |
|---------|------:|
| Repositories | 3,018 |
| Languages | 15 |
| Owners | 2,482 |
| Stars | 77M |
| Forks | 12M |

## Repository Structure

```
GitHub-Developer-Intelligence/
│
├── data/
├── powerbi/
├── python/
├── sql/
├── screenshots/
└── README.md
```

## Dashboard

### Executive Overview

![Executive Overview](screenshots/executive%20overview.png)

### Language Intelligence

![Language Intelligence](screenshots/language%20intelligence.png)

### Repository Performance

![Repository Performance](screenshots/repositories%20performance.png)

### Owner Intelligence

![Owner Intelligence](screenshots/owner%20intelligence.png)

## Running the Project

1. Clone the repository.
2. Run the Python ETL script to collect repository data.
3. Import the SQL scripts into MySQL.
4. Open the Power BI report (.pbix) to explore the dashboard.

## Author

Rashi Ghorawat
