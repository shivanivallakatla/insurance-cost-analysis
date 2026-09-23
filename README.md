# project-insurance-cost-analysis
SQL and Tableau analysis of 1,338 health insurance policyholder records to identify 
what actually drives medical costs up or down.
## Business Question
A health insurer wants to understand what's driving medical costs across its 
policyholder base, to price premiums fairly and identify the most expensive 
segments to insure. Which factors — smoking, weight, age, family size, or 
region — have the biggest impact on charges, and how much does each one 
actually cost?
## Dataset
- Source: Kaggle — Medical Cost Personal Dataset
- Size: 1,338 policyholder records
- Columns: Age, Sex, BMI, Children, Smoker, Region, Charges
- Link: https://www.kaggle.com/datasets/mirichoi0218/insurance
## Tools Used
- MySQL — data cleaning, exploration, and analysis (6 SQL queries)
- Tableau Desktop — interactive dashboard
## Key Findings
1. BASELINE: Average medical cost per policyholder is $13,270.42, ranging from 
   $1,121.87 to $63,770.43. The standard deviation ($12,105.48) is nearly as 
   large as the average itself, indicating costs are highly skewed rather than 
   evenly distributed
2. SMOKING: Smokers average $32,050.23 in charges versus $8,434.27 for 
   non-smokers — a $23,616 gap, roughly 3.8x higher. Even the lowest-charged 
   smoker in the dataset ($12,829) exceeds the average non-smoker's cost
3. BMI: Obese policyholders (BMI ≥ 30) average $15,552 — the highest of any 
   BMI category, and 53% of the dataset falls into this group. The cost jump 
   from Normal to Overweight is small (~$578), while the jump from Overweight 
   to Obese is much larger (~$4,565) — BMI's cost impact concentrates at the 
   obesity threshold rather than rising steadily with weight
4. COMPOUNDING EFFECT: Smoking and obesity compound each other rather than 
   adding together. Among non-smokers, BMI has minimal effect on cost 
   (Normal: $7,686 vs. Obese: $8,843 — a ~$1,157 gap). Among smokers, the 
   same BMI difference produces a $21,616 gap (Normal: $19,942 vs. Obese: 
   $41,558) — a smoking, obese policyholder costs roughly 11.5x more than a 
   non-smoking, normal-weight policyholder
5. REGIONAL VALIDATION: Ranking policyholders by charges within each region 
   confirms the finding independently — 100% of the top-5-costliest 
   policyholders in every region are smokers with obese-range BMI (30.36–47.41). 
   No non-smoker or normal-weight individual appears in any region's top 5
6. AGE: Charges rise steadily and consistently with age — from $9,182 (18-29) 
   to $17,903 (50-64), a clear, monotonic pattern independent of smoking/BMI. 
   Number of children shows no reliable pattern; the apparent drop at 4-5 
   children is based on very small samples (25 and 18 people) and is not a 
   real effect
## Recommendation
1. Price premiums around the smoker + BMI combination specifically, not either 
factor alone — a smoking, obese policyholder costs ~11.5x a non-smoking, 
normal-weight one, far more than either risk factor would suggest individually
2. Target smoking cessation and weight management programs at smokers first — 
obesity's cost impact is minimal for non-smokers (~$1,157 gap) but massive 
for smokers (~$21,616 gap), so intervention resources are best spent where 
the compounding effect is strongest
3. Use age as a stable, independent pricing factor — its steady, linear 
relationship with cost makes it a reliable input, unlike children count, 
which showed no consistent pattern
## Dashboard
https://public.tableau.com/app/profile/shivani.vallakatla/viz/Superstore_Sales_Performance_Analysis/SuperstoreSalesPerformanceAnalysis
## SQL Queries
All 6 analysis queries with comments are in the /sql folder.
