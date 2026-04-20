# 🚴 AdventureWorks Sales Analytics — End-to-End Capstone Project

A complete end-to-end data analytics project analyzing AdventureWorks bicycle sales across 3 years using a full 4-tool pipeline: **Python → SQL → Excel → Power BI**.

---

## 📌 Project Overview

AdventureWorks is a fictional bicycle manufacturer used as a Microsoft sample dataset. This project simulates a real analyst workflow — taking raw sales data through cleaning, SQL analysis, Excel reporting, and an executive Power BI dashboard.

**Business Questions Answered:**
- How has revenue grown from 2020 to 2022?
- Which regions, products and customer segments drive the most revenue?
- What is the return rate and which products are returned most?
- How do customer demographics (occupation, income) correlate with spending?
- What seasonal and quarterly trends exist in the data?

---

## 📊 Key Findings

| Metric | Value |
|---|---|
| Total Revenue (2020–2022) | $24,914,586 |
| Total Orders | 25,164 |
| Total Returns | 1,828 |
| Return Rate | 7.26% |
| Top Region | Australia ($7.4M) |
| Top Product | Mountain-200 Black, 46 ($1.24M) |
| Top Customer Segment | Professionals ($8.4M) |
| Busiest Order Day | Tuesday |
| Best Quarter | Q2 2021 ($3.8M) |

---

## 🔄 4-Tool Pipeline

```
Raw CSV Files (3 years)
       │
       ▼
┌─────────────┐
│   PYTHON    │  Combine, clean, feature engineer, merge lookups
└──────┬──────┘
       │ aw_sales_clean.csv
       ▼
┌─────────────┐
│    SQL      │  10 business queries — aggregations, JOINs, window functions
└──────┬──────┘
       │ Query results
       ▼
┌─────────────┐
│    EXCEL    │  3 pivot tables — Region, Monthly Trend, Top Products
└──────┬──────┘
       │ Summary report
       ▼
┌─────────────┐
│   POWER BI  │  3-page executive dashboard
└─────────────┘
```

---

## 🗂️ Project Structure

```
AdventureWorks-Capstone/
│
├── aw_cleaning.py                  # Stage 1 — Python cleaning script
├── aw_analysis.sql                 # Stage 2 — 10 SQL queries
├── aw_excel_report.xlsx            # Stage 3 — Excel pivot tables
├── aw_dashboard.pbix               # Stage 4 — Power BI dashboard
├── aw_dashboard.pdf                # Static export of all 3 pages
│
├── data/
│   ├── aw_sales_clean.csv          # Combined & cleaned sales data
│   ├── aw_customers_clean.csv      # Cleaned customer lookup
│   ├── aw_products_clean.csv       # Cleaned product lookup
│   ├── aw_territories_clean.csv    # Cleaned territory lookup
│   └── aw_returns_clean.csv        # Cleaned returns data
│
├── results/                        # Screenshots of SQL query outputs
│
└── README.md
```

---

## Stage 1 — Python Cleaning & Feature Engineering

**Script:** `aw_cleaning.py`

| Step | Description |
|---|---|
| Combined 3 years | Merged 2020, 2021, 2022 sales into one 56,046 row dataset |
| Date parsing | Converted OrderDate and StockDate to datetime |
| Date features | Extracted Year, Month, MonthName, Quarter, DayOfWeek |
| Lead time | Calculated StockToOrderDays (order date - stock date) |
| Product merge | Joined ProductName and ProductPrice from product lookup |
| Territory merge | Joined Region from territory lookup |
| Revenue calc | Calculated Revenue = ProductPrice × OrderQuantity |
| Clean export | Exported 5 clean pipe-delimited CSVs |

**Output Stats:**
- 56,046 sales records
- 0 null values
- Date range: Jan 2020 – Jun 2022
- $24.9M total revenue calculated

---

## Stage 2 — SQL Analysis

**Script:** `aw_analysis.sql` | **Database:** SQL Server (SSMS)

| Query | Business Question | Key Finding |
|---|---|---|
| Q1 | Overall KPIs | $24.9M revenue, 25K orders, 84K units |
| Q2 | Revenue by year | 2021 was peak year at $9.3M |
| Q3 | Revenue by region | Australia leads at $7.4M |
| Q4 | Top 10 products | Mountain-200 bikes dominate top 6 spots |
| Q5 | Monthly seasonality | December and June are peak months |
| Q6 | Top 10 customers | Maurice Shan leads at $12,407 spent |
| Q7 | Revenue by occupation | Professionals account for $8.4M (34%) |
| Q8 | Return rate by product | Road-750 Black has 107% return rate — data anomaly |
| Q9 | Quarterly revenue | Q2 2021 was best quarter at $3.8M |
| Q10 | Running total (window) | Cumulative revenue tracked month by month per year |

**SQL Concepts Used:**
- `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`, `ROUND`
- `JOIN` across 3+ tables
- `TRY_CAST` for safe type conversion
- `NULLIF` for division safety
- `SUM() OVER()` window function with `ROWS BETWEEN`
- `PARTITION BY` for year-level running totals

---

## Stage 3 — Excel Pivot Report

**File:** `aw_excel_report.xlsx`

| Sheet | Pivot Table | Chart |
|---|---|---|
| Region Analysis | Revenue by Region × Year | Clustered bar chart |
| Monthly Trend | Revenue by Month × Year | Line chart (3 series) |
| Top Products | Revenue + Quantity by Product | Horizontal bar chart |

---

## Stage 4 — Power BI Dashboard

**File:** `aw_dashboard.pbix` | 3 pages, 4 DAX measures, 2 slicers

**DAX Measures:**
```dax
Total Revenue = SUM(aw_sales_clean[Revenue])
Total Orders = DISTINCTCOUNT(aw_sales_clean[OrderNumber])
Total Returns = SUM(aw_returns_clean[ReturnQuantity])
Return Rate = DIVIDE([Total Returns], [Total Orders], 0)
```

**Page 1 — Executive Overview**
KPIs + Revenue by Region + Monthly Trend + Year Split Donut + Top Products

**Page 2 — Customer Analysis**
Revenue by Occupation + Income vs Spending Scatter + Orders by Year + Orders by Day of Week

**Page 3 — Product & Returns Analysis**
Most Returned Products + Revenue Treemap + Quarterly Revenue by Year

---

## 🛠️ Tools & Technologies

| Tool | Usage |
|---|---|
| **Python 3.10+** | Data cleaning, feature engineering, multi-file merging |
| **Pandas** | Data wrangling, merging, date parsing, column engineering |
| **SQL Server (SSMS)** | Database setup, BULK INSERT, T-SQL analysis |
| **Excel** | Pivot tables, pivot charts, summary reporting |
| **Power BI Desktop** | DAX measures, data modelling, 3-page dashboard |

---

## 🚀 How to Reproduce

### Step 1 — Get the Dataset
Download **AdventureWorks Sales Data** from [Kaggle](https://www.kaggle.com/datasets/larxel/adventure-works-cycles).

### Step 2 — Run Python Cleaning
```bash
pip install pandas numpy
python aw_cleaning.py
```

### Step 3 — Set Up SQL Database
Open SSMS → run `setup/create_tables.sql` → run `setup/load_data.sql` (update file paths) → run `aw_analysis.sql`

### Step 4 — Open Excel Report
Open `aw_excel_report.xlsx` — pivot tables auto-refresh from the clean CSV.

### Step 5 — Open Power BI Dashboard
Open `aw_dashboard.pbix` → update data source paths → refresh.

---

## 💡 Business Recommendations

1. **Double down on Australia** — highest revenue region at $7.4M, nearly 60% more than second-place Southwest. Expand marketing and seller base here.
2. **Mountain-200 is the cash cow** — top 6 revenue products are all Mountain-200 variants. Ensure consistent stock and consider premium upsells within this line.
3. **Target Professionals** — they account for 34% of revenue despite being one of 5 segments. Tailored loyalty programs for this group would have the highest ROI.
4. **Investigate Road-750 return anomaly** — 107% return rate suggests a data or fulfilment issue worth investigating with the operations team.
5. **Capitalize on Tuesday demand** — highest order day. Targeted email campaigns or flash sales on Tuesdays could amplify this natural peak.

---

## 📝 Dataset

- **Source:** [AdventureWorks Sales — Kaggle](https://www.kaggle.com/datasets/larxel/adventure-works-cycles)
- **Records:** 56,046 sales transactions across 2020–2022
- Raw files are **not included** in this repo. Download from Kaggle as per Step 1.

---

*End-to-end analytics capstone demonstrating Python, SQL, Excel and Power BI in a single connected pipeline 📊*
