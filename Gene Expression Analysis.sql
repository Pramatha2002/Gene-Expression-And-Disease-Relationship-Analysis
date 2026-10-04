-- ============================================================
-- PROJECT: Gene Expression & Disease Relationship Analysis
-- PURPOSE: Analyze gene expression, disease status,
--          patient characteristics, and treatment response
-- TOOLS: MySQL
-- DATASET: Gene Expression Analysis and Disease Relationship
-- RECORDS: 1,000 patients
-- ===========================================================

-- ============================================================
-- STEP 0: DATABASE AND TABLE
-- ============================================================

CREATE DATABASE GENE_EXPRESSION_ANALYSIS;
SELECT * FROM gene_expression_analysis.gene;

-- ============================================
-- STEP 1: DATA QUALITY CHECKS
-- ============================================
-- 1.1 check the total no of records
SELECT 
COUNT(*) AS TOTAL_RECORDS
FROM gene;

-- 1.2 Check table structure and data types
DESCRIBE gene;

-- 1.3 Check for duplicate Patient IDs
SELECT 
PatientID,
COUNT(*) AS record_count
FROM gene 
GROUP BY PatientID
HAVING COUNT(*)>1;

-- 1.4 Check for missing values in important columns
SELECT
COUNT(*) AS total_records,
SUM(PatientID IS NULL) AS missing_patient_id,
SUM(Age IS NULL) AS missing_age,
SUM(Gender IS NULL) AS missing_gender,
SUM(Gender_Label IS NULL) AS missing_gender_label,
SUM(Gene_X_Expression IS NULL) AS missing_gene_x,
SUM(Gene_Y_Expression IS NULL) AS missing_gene_y,
SUM(SmokingStatus IS NULL) AS missing_smoking_status,
SUM(SmokingStatus_Label IS NULL) AS missing_smoking_label,
SUM(DiseaseStatus IS NULL) AS missing_disease_status,
SUM(DiseaseStatus_Label IS NULL) AS missing_disease_label,
SUM(TreatmentResponse IS NULL) AS missing_treatment_response,
SUM(TreatmentResponse_Label IS NULL) AS missing_treatment_label
FROM gene;

-- ============================================
-- STEP 2: EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================
-- 2.1 Patient distribution by gender
SELECT
Gender_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY Gender_Label
ORDER BY patient_count DESC;

-- 2.2 Patient distribution by disease status
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY patient_count DESC;

-- 2.3 Patient distribution by smoking status
SELECT
SmokingStatus_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY SmokingStatus_Label
ORDER BY patient_count DESC;

-- 2.4 Patient distribution by treatment response
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY patient_count DESC;

-- 2.5 Calculate basic age statistics
SELECT
MIN(Age) AS minimum_age,
MAX(Age) AS maximum_age,
ROUND(AVG(Age),2) AS average_age
FROM gene;

-- 2.6 Analyze age statistics by disease status
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count,
MIN(Age) AS minimum_age,
MAX(Age) AS maximum_age,
ROUND(AVG(Age), 2) AS average_age
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY average_age DESC;

-- 2.7 Calculate overall average gene expression
SELECT
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene;

-- 2.8 Compare average gene expression across disease groups
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY avg_gene_x_expression DESC;

-- 2.9 Compare average gene expression by gender
SELECT
Gender_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY Gender_Label;

-- 2.10 Compare average gene expression by smoking status
SELECT
SmokingStatus_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY SmokingStatus_Label
ORDER BY avg_gene_x_expression DESC;

-- 2.11 Compare average gene expression by treatment response
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY avg_gene_x_expression DESC;

-- 2.12 Analyze disease distribution by gender
SELECT
Gender_Label,
DiseaseStatus_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY Gender_Label, DiseaseStatus_Label
ORDER BY Gender_Label, patient_count DESC;

-- 2.13 Analyze disease distribution by smoking status
SELECT
SmokingStatus_Label,
DiseaseStatus_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY SmokingStatus_Label, DiseaseStatus_Label
ORDER BY  patient_count DESC ;

-- 2.14 Analyze treatment response across disease groups
SELECT
DiseaseStatus_Label,
TreatmentResponse_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY DiseaseStatus_Label, TreatmentResponse_Label
ORDER BY patient_count DESC;

-- ============================================
-- STEP 3: GENE EXPRESSION & DISEASE ANALYSIS
-- ============================================
-- 3.1 Compare average gene expression across disease groups
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY avg_gene_x_expression DESC;

-- 3.2 Analyze the range of gene expression across disease groups
SELECT
DiseaseStatus_Label,
ROUND(MIN(Gene_X_Expression), 2) AS min_gene_x,
ROUND(MAX(Gene_X_Expression), 2) AS max_gene_x,
ROUND(MIN(Gene_Y_Expression), 2) AS min_gene_y,
ROUND(MAX(Gene_Y_Expression), 2) AS max_gene_y
FROM gene
GROUP BY DiseaseStatus_Label;

-- 3.3 Identify patients with Gene X expression above the overall average
SELECT
PatientID,
Age,
Gender_Label,
DiseaseStatus_Label,
Gene_X_Expression
FROM gene
WHERE Gene_X_Expression > (
    SELECT AVG(Gene_X_Expression)
    FROM gene
)
ORDER BY Gene_X_Expression DESC;

-- 3.4 Compare Gene X and Gene Y expression for each disease group
SELECT
DiseaseStatus_Label,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y,
ROUND(AVG(Gene_X_Expression - Gene_Y_Expression), 2) AS avg_expression_difference
FROM gene
GROUP BY DiseaseStatus_Label;

-- 3.5 Categorize Gene X expression into low, medium, and high levels
SELECT
PatientID,
DiseaseStatus_Label,
Gene_X_Expression,
CASE
WHEN Gene_X_Expression < (
	SELECT AVG(Gene_X_Expression)
		FROM gene
	) THEN 'Low'
WHEN Gene_X_Expression = (
	SELECT AVG(Gene_X_Expression)
		FROM gene
	) THEN 'Medium'
ELSE 'High'
END AS Gene_X_Expression_Category
FROM gene;

-- 3.6 Analyze disease distribution among patients with high Gene X expression
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count
FROM gene
  WHERE Gene_X_Expression > (
    SELECT AVG(Gene_X_Expression)
    FROM gene
)
GROUP BY DiseaseStatus_Label
ORDER BY patient_count DESC;

-- 3.7 Analyze disease distribution among patients with high Gene Y expression
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count
FROM gene
WHERE Gene_Y_Expression > (
    SELECT AVG(Gene_Y_Expression)
    FROM gene
)
GROUP BY DiseaseStatus_Label
ORDER BY patient_count DESC;

-- ============================================
--  STEP 4 :TREATMENT RESPONSE ANALYSIS
-- ============================================

-- 4.1 Analyze the overall distribution of treatment responses
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY patient_count DESC;

-- 4.2 Compare average gene expression across treatment responses
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x_expression,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y_expression
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY avg_gene_x_expression DESC;

-- 4.3 Analyze treatment response across disease groups
SELECT
    DiseaseStatus_Label,
    TreatmentResponse_Label,
    COUNT(*) AS patient_count
FROM gene
GROUP BY DiseaseStatus_Label, TreatmentResponse_Label
ORDER BY DiseaseStatus_Label, patient_count DESC;

-- 4.4 Analyze treatment response across smoking groups
SELECT
SmokingStatus_Label,
TreatmentResponse_Label,
COUNT(*) AS patient_count
FROM gene
GROUP BY SmokingStatus_Label, TreatmentResponse_Label
ORDER BY SmokingStatus_Label, patient_count DESC;

-- 4.5 Compare age statistics across treatment-response groups
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count,
MIN(Age) AS minimum_age,
MAX(Age) AS maximum_age,
ROUND(AVG(Age), 2) AS average_age
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY average_age DESC;

-- 4.6 Identify patients with the highest Gene X expression and their treatment response
SELECT
PatientID,
DiseaseStatus_Label,
TreatmentResponse_Label,
Gene_X_Expression,
Gene_Y_Expression
FROM gene
ORDER BY Gene_X_Expression DESC
LIMIT 10;

-- 4.7 Identify patients with the highest Gene Y expression and their treatment response
SELECT
PatientID,
DiseaseStatus_Label,
TreatmentResponse_Label,
Gene_X_Expression,
Gene_Y_Expression
FROM gene
ORDER BY Gene_Y_Expression DESC
LIMIT 10;

-- ============================================
-- STEP 5: FINAL INSIGHTS
-- ============================================
-- 5.1 Summarize patient count and gene expression by disease
SELECT
DiseaseStatus_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y,
ROUND(AVG(Age), 2) AS avg_age
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY patient_count DESC;

-- 5.2 Identify disease groups with the highest average gene expression
SELECT
DiseaseStatus_Label,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y
FROM gene
GROUP BY DiseaseStatus_Label
ORDER BY avg_gene_x DESC;

-- 5.3 Summarize treatment response and average gene expression
SELECT
TreatmentResponse_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y
FROM gene
GROUP BY TreatmentResponse_Label
ORDER BY avg_gene_x DESC;

-- 5.4 Identify patients with above-average expression for both genes
SELECT
PatientID,
Age,
Gender_Label,
DiseaseStatus_Label,
TreatmentResponse_Label,
Gene_X_Expression,
Gene_Y_Expression
FROM gene
WHERE Gene_X_Expression > (
    SELECT AVG(Gene_X_Expression)
    FROM gene
)
AND Gene_Y_Expression > (
    SELECT AVG(Gene_Y_Expression)
    FROM gene
)
ORDER BY Gene_X_Expression DESC;


-- 5.5 Create an integrated disease and treatment-response summary
SELECT
DiseaseStatus_Label,
TreatmentResponse_Label,
COUNT(*) AS patient_count,
ROUND(AVG(Gene_X_Expression), 2) AS avg_gene_x,
ROUND(AVG(Gene_Y_Expression), 2) AS avg_gene_y,
ROUND(AVG(Age), 2) AS avg_age
FROM gene
GROUP BY
DiseaseStatus_Label,
TreatmentResponse_Label
ORDER BY
DiseaseStatus_Label,
patient_count DESC;


-- ============================================================
-- FINAL SQL INSIGHTS
-- ============================================================
/*
1. The dataset contains 1,000 patient records.

2. The dataset is highly imbalanced, with the majority of
   records belonging to the Healthy group.

3. Gene X and Gene Y show higher average expression levels
   in the disease groups than in the Healthy group.

4. Disease B shows the highest observed average expression
   for both Gene X and Gene Y.

5. Different treatment-response groups show different
   average gene-expression levels.

6. A strong observed association exists between disease status
   and treatment response in this dataset.

7. A strong observed pattern also exists between smoking status
   and disease status.

8. These findings represent associations observed in the dataset
   and should not be interpreted as causal relationships.

9. The high imbalance between Healthy and disease groups should
   be considered when interpreting the results or performing
   future predictive analysis.
*/
-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================