# 🛒 E-Commerce Customer Behavior & Churn Analysis

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)

---

## 📌 Project Overview

Analyzed **500,000+ transactions** from a UK-based e-commerce store to uncover customer purchase patterns, detect churn risk, and segment customers using **K-Means clustering**.

Built an end-to-end data pipeline from raw SQL extraction → Python EDA → RFM Analysis → Power BI Dashboard.

> *"This project demonstrates: data extraction, cleaning, segmentation, churn analysis, and business storytelling."*

---

## 🎯 Problem Statement

Every e-commerce business faces 3 core challenges:
- **Who are my most valuable customers?**
- **Which customers are about to leave?**
- **How do I improve retention?**

This project answers all 3 using real data.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **SQL** | Data extraction, joins, cohort queries |
| **Python (Pandas)** | Data cleaning, EDA, feature engineering |
| **Matplotlib & Seaborn** | Charts, heatmaps, visualizations |
| **Scikit-learn** | K-Means clustering, RFM segmentation |
| **Power BI** | Interactive dashboard |
| **Excel** | Initial sanity checks |

---

## 📁 Project Structure

```
ecommerce-churn-analysis/
├── 📂 sql/
│   └── analysis.sql              ← All SQL queries
├── 📂 notebooks/
│   └── ecommerce_analysis.ipynb  ← Full Python analysis
├── 📂 data/
│   ├── data.csv                  ← Raw dataset
│   ├── cleaned_ecommerce.csv     ← Cleaned data
│   └── rfm_final.csv             ← RFM segments
├── 📂 dashboard/
│   └── customer_behaviour_analysis_dashboard.pbix
├── 📂 images/
│   └── ecommerce_analysis_charts.png
└── README.md
```

---

## ⚙️ Project Workflow

```
RAW DATA → SQL CLEANING → PYTHON EDA → RFM ANALYSIS → K-MEANS → POWER BI
```

### Step 1 — Data Extraction (SQL)
- Wrote JOIN queries to extract customer transactions
- Removed cancelled orders, null CustomerIDs, negative quantities
- Built cohort tables for monthly retention tracking

### Step 2 — EDA & Cleaning (Python)
- Handled missing values and outliers using Pandas
- Engineered **TotalPrice = Quantity × UnitPrice**
- Analyzed distributions, seasonal trends, top products

### Step 3 — RFM Analysis
- Calculated **Recency, Frequency, Monetary** scores per customer
- Scored each customer on a 1-5 scale per dimension

### Step 4 — K-Means Clustering (k=4)
- Applied StandardScaler for normalization
- Used Elbow Method to find optimal k=4
- Identified 4 customer segments

### Step 5 — Power BI Dashboard
- Built interactive dashboard with slicers, KPI cards, funnel
- Published to Power BI Service for sharing

---

## 👥 Customer Segments (K-Means, k=4)

| Segment | Customers | Avg Revenue | Description |
|---------|-----------|-------------|-------------|
| 💎 Champions | 3,054 | £369 | High frequency, high value |
| 🔁 Loyalists | 1,067 | £310 | Regular buyers, mid value |
| ⚠️ At Risk | 13 | £1,543 | High value but inactive |
| 👋 One-Timers | 204 | £569 | Purchased once only |

---

## 💡 Key Business Insights

```
📉 Only 20% of new customers return after 30 days
💎 Champions (70% of customers) drive majority of revenue
⚠️  At Risk segment has highest avg revenue — needs re-engagement!
🌍 Netherlands is top international market after UK
📅 November peak — seasonal campaigns work well
🛒 Checkout drop-off is biggest funnel leak
```

---

## 📊 Dashboard Preview

![Dashboard](images/ecommerce_analysis_charts.png)

🔗 **[View Live Power BI Dashboard](https://app.powerbi.com/YOUR_DASHBOARD_LINK)**

---

## 🚀 How to Run

### SQL:
```sql
-- Run analysis.sql in any SQL Server / MySQL environment
-- Or use SQLite for local testing
```

### Python:
```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/ecommerce-churn-analysis

# Install dependencies
pip install pandas numpy matplotlib seaborn scikit-learn openpyxl

# Open notebook
jupyter notebook notebooks/ecommerce_analysis.ipynb
```

---

## 📦 Dataset

- **Source:** [E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)
- **Records:** 541,909 transactions
- **Period:** Dec 2010 – Dec 2011
- **Region:** UK-based online retail store

---

## 📬 Connect

**Advik Rathee**
- 🔗 [LinkedIn](https://linkedin.com/in/YOUR_LINKEDIN)
- 💻 [GitHub](https://github.com/YOUR_USERNAME)
- 📧 your.email@gmail.com

---

⭐ *If you found this project helpful, please give it a star!*
