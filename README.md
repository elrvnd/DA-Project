# 🏪 Retail Sales Performance Analysis (2016–2021)

**Portfolio Project – Data Analyst**  
*Tools:* SQL Server, Power BI
*Dataset:* 6 years of global retail sales data (67 stores across 8 countries)  

---

## 🎯 Project Objective

This project aims to analyze **multi-country retail performance** to understand revenue trends, store efficiency, and product profitability.  
The main goal is to **build actionable KPIs** and **derive business insights** that support management decisions regarding store strategy, product focus, and sales optimization.

---

## 🧱 Data Preparation

The dataset was modeled using a **star schema**, consisting of:

- **Fact Table:** `gold_fact_sales` (order-level sales and revenue data)  
- **Dimension Tables:**  
  - `gold_dim_products` – product category, brand, and cost/price info  
  - `gold_dim_stores` – store location, size, and store type  
  - `gold_dim_customers` – customer demographics  
  - `gold_dim_exchange_rates` – currency conversion to USD  

All sales values were standardized to **USD** for consistent financial comparison.

---

## 🔍 Exploratory Data Analysis (EDA)

### Overall Business Metrics
| Metric | Value |
|--------|--------|
| Total Revenue | **$57.53M USD** |
| Total Cost of Goods Sold | **$23.83M USD** |
| Total Profit | **$33.70M USD** |
| Profit Margin | **58.6%** |
| Total Orders | **26,326** |
| Total Items Sold | **197,757** |
| Average Items per Order (AIPO) | **7.51** |
| Average Order Value (AOV) | **$2,185** |

📅 *Date Range:* 2016-01-01 → 2021-02-20  

---

## 📈 KPI Highlights

### 🧾 Yearly Revenue Growth (YoY)
| Year | Total Revenue (USD) | YoY Growth % |
|------|----------------------|--------------|
| 2016 | 7.24M | – |
| 2017 | 7.71M | +6.6% |
| 2018 | 13.38M | **+73.5%** |
| 2019 | 18.63M | **+39.3%** |
| 2020 | 9.49M | **–49.1%** |
| 2021 | 1.08M | **–88.6%** |

🟢 **Insight:** Strong growth until 2019, followed by sharp decline post-2020, likely due to pandemic-related operational constraints.  
📊 *Recommendation:* Reassess online and physical store strategies to recover post-pandemic sales volume.

---

### 🛒 AOV and AIPO Trend
| Year | Average Order Value (USD) | Avg Items per Order |
|------|----------------------------|----------------------|
| 2016 | 2,525.57 | 7.6 |
| 2017 | 2,351.43 | 7.56 |
| 2018 | 2,242.72 | 7.46 |
| 2019 | 2,051.40 | 7.53 |
| 2020 | 2,047.77 | 7.44 |
| 2021 | 2,170.27 | 7.62 |

📊 *Insight:* Average order value (AOV) shows gradual decline from 2016–2020, indicating possible price pressure or smaller basket sizes.  
💡 *Recommendation:* Revisit product bundling and pricing strategies to increase AOV.

---

### 🏬 Store Performance and Efficiency

#### Store Type Breakdown
| Store Type | Total Revenue (USD) | Total Profit (USD) | Profit Margin (%) |
|-------------|--------------------|--------------------|-------------------|
| Large Physical | 26.45M | 15.49M | 58.57 |
| Medium Physical | 17.07M | 10.00M | **58.61** |
| Online | 11.67M | 6.83M | 58.52 |
| Small Physical | 2.35M | 1.38M | 58.80 |

🟢 *Insight:*  
Medium-sized physical stores achieved the **best overall efficiency** (balanced cost-to-revenue ratio).  
Online channel remains profitable but needs growth revitalization post 2020.

💡 *Recommendation:*  
Prioritize investment in **medium-size stores** for expansion, and **revamp online marketing** to boost digital channel revenue.

---

### 🌍 Regional Performance (Top 5 by Profit Margin)
| Country | Total Revenue | Profit Margin (%) |
|----------|----------------|-------------------|
| Australia | 1.51M | **59.23** |
| France | 1.40M | 58.98 |
| Netherlands | 1.81M | 58.92 |
| Germany | 4.82M | 58.80 |
| Italy | 2.33M | 58.72 |

📊 *Insight:*  
European markets like **Australia, France, and Netherlands** deliver high margins despite lower sales volume.  

💡 *Recommendation:*  
Increase **sales campaigns and product availability** in these high-margin regions.

---

## 💬 Business Summary

✅ **What’s working:**  
- Profit margin is consistently high (~58%), indicating cost efficiency.  
- Medium-sized physical stores drive stable profitability.  
- Certain European markets offer strong margin potential.

⚠️ **What needs attention:**  
- Sharp post-2020 revenue drop due to external disruptions (likely pandemic).  
- Online sales channel underperforming in growth contribution.  
- Average Order Value declined ~20% from 2016 to 2020.

💡 **Suggested Actions:**  
1. **Reinforce digital strategy:** improve online customer engagement and cross-selling.  
2. **Invest in mid-sized stores:** highest return per square meter.  
3. **Revise product pricing:** mitigate AOV decline and maintain premium perception.  
4. **Focus expansion** on high-margin but low-volume countries (Australia, France, Netherlands).

---

## 🧩 Files in This Repository
| File | Description |
|------|--------------|
| `KPI_queries.sql` | SQL queries for KPI calculations |
| `gold_table_creation.sql` | Gold-layer data model setup |
| `Dashboard.pbix` | Power BI dashboard file |
| `Dashboard_Screenshot.png` | Visual reference for portfolio |
| `insights_summary.md` | Detailed EDA notes |

---

## 🧠 Key Takeaway
> This project demonstrates end-to-end analytical thinking from data modeling to business insights, turning retail data into actionable recommendations for strategic decision-making.

---

### 🔗 Links
