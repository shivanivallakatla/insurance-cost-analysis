-- ============================================================
-- Health Insurance Cost & Risk Analysis
-- Dataset: mirichoi0218/insurance (Kaggle), 1,338 records
-- ============================================================

-- ------------------------------------------------------------
-- QUERY 1: Baseline Average Charges
-- Purpose: Establish the headline cost figure and its spread
-- ------------------------------------------------------------
SELECT 
    ROUND(AVG(charges), 2) AS avg_charges,
    ROUND(MIN(charges), 2) AS min_charges,
    ROUND(MAX(charges), 2) AS max_charges,
    ROUND(STDDEV(charges), 2) AS stddev_charges
FROM insurance_raw;
-- RESULT: avg $13,270.42, min $1,121.87, max $63,770.43, stddev $12,105.48


-- ------------------------------------------------------------
-- QUERY 2: Average Charges by Smoker Status
-- Purpose: Test whether smoking drives cost, and by how much
-- ------------------------------------------------------------
SELECT 
    smoker,
    COUNT(*) AS total_policyholders,
    ROUND(AVG(charges), 2) AS avg_charges,
    ROUND(MIN(charges), 2) AS min_charges,
    ROUND(MAX(charges), 2) AS max_charges
FROM insurance_raw
GROUP BY smoker
ORDER BY avg_charges DESC;
-- RESULT: Smokers $32,050.23 (n=274) vs Non-smokers $8,434.27 (n=1,064) - 3.8x gap


-- ------------------------------------------------------------
-- QUERY 3: CTE - BMI Category Bucketing
-- Purpose: Test whether BMI category correlates with cost
-- ------------------------------------------------------------
SELECT 
    COUNT(*) AS total_policyholders,
    CASE
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi < 25 THEN 'Normal'
        WHEN bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    ROUND(AVG(charges), 2) AS avg_charges
FROM insurance_raw
GROUP BY bmi_category
ORDER BY avg_charges DESC;
-- RESULT: Obese $15,552.34 (n=707) highest; effect concentrates at obesity threshold


-- ------------------------------------------------------------
-- QUERY 4: Combined Effect - Smoker x BMI Category
-- Purpose: Test whether smoking and obesity compound each other
-- ------------------------------------------------------------
SELECT 
    COUNT(*) AS total_policyholders,
    smoker,
    CASE
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi < 25 THEN 'Normal'
        WHEN bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_category,
    ROUND(AVG(charges), 2) AS avg_charges
FROM insurance_raw
GROUP BY bmi_category, smoker
ORDER BY bmi_category;
-- RESULT: Non-smokers show minimal BMI effect ($7,686 -> $8,843);
-- smokers show massive BMI effect ($19,942 -> $41,558) - compounding, not additive


-- ------------------------------------------------------------
-- QUERY 5: Window Function - Top 5 Costliest Policyholders Per Region
-- Purpose: Independently validate the smoker/BMI finding via ranking
-- ------------------------------------------------------------
SELECT * FROM (
    SELECT
        bmi,
        smoker,
        region,
        charges,
        RANK() OVER (PARTITION BY region ORDER BY charges DESC) AS rank_per_region
    FROM insurance_raw
) AS ranked
WHERE rank_per_region <= 5;
-- RESULT: 100% of top-5-per-region policyholders are smokers with obese-range BMI


-- ------------------------------------------------------------
-- QUERY 6: Age and Family Size Effects
-- Purpose: Check secondary factors independent of smoking/BMI
-- ------------------------------------------------------------

-- Part A: Age bracket
SELECT 
    CASE 
        WHEN age < 30 THEN '18-29'
        WHEN age < 40 THEN '30-39'
        WHEN age < 50 THEN '40-49'
        ELSE '50-64'
    END AS age_bracket,
    COUNT(*) AS total_policyholders,
    ROUND(AVG(charges), 2) AS avg_charges
FROM insurance_raw
GROUP BY age_bracket
ORDER BY age_bracket;
-- RESULT: Steady climb from $9,182 (18-29) to $17,903 (50-64)

-- Part B: Children count
SELECT 
    children,
    COUNT(*) AS total_policyholders,
    ROUND(AVG(charges), 2) AS avg_charges
FROM insurance_raw
GROUP BY children
ORDER BY children;
-- RESULT: Rises 0-3 children ($12,366 -> $15,355); dip at 4-5 children is
-- a small-sample artifact (n=25, n=18) - not a reliable effect
