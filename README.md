# Retail Sales Data Analysis (2016–2021)

## Overview
This project analyzes six years of global retail transactions to uncover key performance drivers in customer behavior, product profitability, and store performance.  
The objective is to identify which segments and regions contribute most to overall business growth and profitability.

---

## 1. Business Summary

| Metric | Value |
|---------|------:|
| **Total Revenue** | USD 57,531,338.52 |
| **Total Profit** | USD 33,701,542.86 |
| **Profit Margin** | 58.58% |
| **Total Orders** | 26,326 |
| **Total Items Sold** | 197,757 |
| **Average Items per Order (AIPO)** | 7.51 |
| **Average Order Value (AOV)** | USD 2,185.34 |
| **Date Range** | 2016–2021 |

**Insight:**  
The company maintained a strong and consistent profit margin (~59%) across six years. Despite order volume fluctuations in 2020–2021, the average order value remained stable, suggesting resilient customer demand.


---

## 2. Customer Insights

| Aspect | Key Finding | Interpretation |
|--------|--------------|----------------|
| **Demographics** | Age 65+ group generated ~38% of total sales. | Indicates strong loyalty and purchasing power among senior customers. |
| **Gender** | Male 50.6%, Female 49.4%. | Balanced gender segmentation, suggesting neutral product appeal. |
| **Geography** | USA contributed USD 29.87M revenue (top market). | The U.S. remains the strongest region for both in-store and online purchases. |
| **Customer Activity** | 11,887 of 15,266 customers made at least one purchase. | 78% active customer rate, reflecting effective retention. |

**Insight:**  
Revenue concentration is highest in the 65+ age group and in the U.S. region. These customers form the backbone of profitability and represent the most reliable base for retention and upsell strategies.


---

## 3. Product Insights

| KPI | Finding |
|-----|----------|
| **Top Category by Profit** | Computers -> USD 11.64M |
| **Top Subcategory by Profit** | Desktops -> USD 5.83M |
| **Most Profitable Brands** | Adventure Works, Contoso, WW Importers |
| **Average Unit Price** | USD 356.83 |
| **Average Unit Cost** | USD 147.66 |
| **Overall Price Markup** | 141.6% above cost |

**Insight:**  
The *Computers and Electronics* segment drives the majority of profit, supported by higher price-to-cost ratios.  
In contrast, lower-priced categories (Games, Audio) contribute more to transaction volume than profitability.


---

## 4. Store and Channel Performance

| Region | Total Revenue (USD) | Total Profit (USD) | Profit Margin (%) |
|---------|--------------------:|-------------------:|------------------:|
| United States | 23,764,425.86 | 13,922,159.05 | 58.58 |
| Online | 11,666,662.34 | 6,827,392.11 | 58.52 |
| United Kingdom | 7,490,416.05 | 4,366,574.13 | 58.30 |
| Germany | 4,820,198.27 | 2,834,309.90 | 58.80 |
| Canada | 2,746,999.61 | 1,600,705.37 | 58.27 |

**Insight:**  
The U.S. remains the top-performing market, while the **Online channel shows nearly identical profitability**, highlighting strong operational efficiency and potential scalability in digital sales.


---

## 5. Key Strategic Insights

| Area | Key Insight | Business Implication |
|------|--------------|----------------------|
| **Customer Segmentation** | Senior buyers (65+) are the highest-value demographic. | Develop retention campaigns and loyalty programs tailored to this group. |
| **Product Strategy** | Computers and Desktops yield the strongest margins. | Maintain premium pricing; invest in continued product innovation. |
| **Channel Focus** | Online sales are as profitable as physical stores. | Expand digital marketing and e-commerce infrastructure. |
| **Regional Focus** | The U.S. dominates revenue generation. | Prioritize the U.S. and replicate its model for international scaling. |

---

## 6. Technical Overview

**Tools Used:**
- **SQL (Microsoft SQL Server):** Data cleaning, transformation (`raw → clean → gold` schema)
- **Power BI:** Dashboard visualization and KPI tracking

**Data Pipeline Summary:**
1. Imported raw CSV tables using SQL Wizard  
2. Conducted quality checks and cleaned datasets (`raw_ → clean_`)  
3. Created analytical views (`gold_`) for fact and dimension tables  
4. Joined across `customers`, `products`, `stores`, and `sales` to extract insights  

![Dashboard Preview]([power bi/images/page 1_business overview.png](https://github.com/elrvnd/DA-Project/blob/e5f674dfde6419e26932cb1af8cb8d02961b26b1/power%20bi/images/page%201_business%20overview.png))

---

## 7. Conclusion

- The business shows healthy profitability and consistent growth through diversified channels.  
- Senior customers and the Computers category drive most of the profit.  
- U.S. and online markets represent the strongest expansion opportunities.  
- Pricing structure and cost efficiency are well-optimized for scaling.  

---
