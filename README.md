# Gene Expression & Disease Relationship Analysis

End-to-end analysis of 1,000 patient records exploring how Gene X and Gene Y expression relate to disease status, smoking status and treatment response.

**Workflow:** Excel (data prep) → MySQL (validation & EDA) → Excel (PivotTables) → Power BI (dashboard)

![Power BI Dashboard]([dashboard/Dashboard.png](https://github.com/Pramatha2002/Gene-Expression-And-Disease-Relationship-Analysis/blob/main/Dashboard.png
))

## Dataset
Public dataset of 1,000 patients: 962 Healthy, 18 Disease A, 20 Disease B. Coded variables were kept and readable `_Label` columns were added.

## Tools
- **Excel:** data preparation, label columns, PivotTables
- **MySQL:** data-quality checks, aggregation, subqueries, `CASE` logic
- **Power BI:** KPI cards, slicers, interactive charts

## Methodology
1. **Prepare (Excel):** created readable label columns, keeping the original coded values.
2. **Validate (SQL):** record count, duplicate PatientIDs, missing values, data types.
3. **Analyze (SQL):** `GROUP BY` aggregations, `CASE` categories, subqueries for above-average expression, treatment-response analysis.
4. **Summarize (Excel):** PivotTables and PivotCharts as a second analytical view.
5. **Visualize (Power BI):** KPI cards, slicers, scatter plot and comparison charts.

## Key Findings

| Group | Avg Gene X | Avg Gene Y |
|---|---|---|
| Healthy | 3.79 | 3.55 |
| Disease A | 6.40 | 4.58 |
| Disease B | 7.94 | 6.52 |

- Both genes show higher average expression in disease groups than in Healthy.
- Disease B has the highest observed expression for both genes.
- Strong patterns were observed between smoking status, disease status and treatment response.

📄 [Project Report ]([report/Gene_Expression_Analysis_Report.pdf](https://github.com/Pramatha2002/Gene-Expression-And-Disease-Relationship-Analysis/blob/main/Project%20Report.pdf)) 

