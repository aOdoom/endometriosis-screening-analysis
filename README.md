# Symptom-Based Screening for Endometriosis: An Exploratory Analysis

## Introduction

The purpose of this analysis was to identify symptom patterns that could inform early screening for endometriosis. Five research questions guided the investigation:

1. **What is the average chronic pain level for individuals with endometriosis compared to those without?** Individuals with endometriosis may have different pain experiences, which can inform the types of treatments clinicians recommend.

2. **Do individuals with endometriosis have a higher BMI than those without?** A higher BMI might indicate that other risk factors should be considered when evaluating patients.

3. **What are the earliest and average ages of those with endometriosis and infertility compared to those without endometriosis and fertile?** Knowing the earliest age helps individuals begin identifying symptoms and consider treatment options early on. The average age helps identify when endometriosis symptoms typically appear.

4. **Among those who are infertile, what is the average menstrual irregularity score compared to those who are fertile?** Infertile individuals might have a higher likelihood of irregular menstrual cycles, so observing differences compared to fertile individuals could inform screening approaches.

5. **How many individuals have an endometriosis diagnosis, abnormal hormone levels, and menstrual irregularity?** This combination of factors could alert clinicians to screen a patient for endometriosis, enabling earlier detection.

## Methods

Data were obtained from the Endometriosis Dataset on Kaggle (https://www.kaggle.com/datasets/michaelanietie/endometriosis-dataset, n=10,000). Variables examined included demographics (age, BMI), symptom indicators (chronic pain level, menstrual irregularity, hormone level abnormality, infertility), and the outcome variable (endometriosis diagnosis). Analysis was conducted using SQL queries with aggregate functions (AVG, MIN, COUNT) and GROUP BY for group comparisons. RStudio was used to peform logistic regression to identify predictors of endometriosis. T-tests were run on age, BMI, and pain level to detect any meaningful differences.

## Results

**Table 1. Average Chronic Pain Level by Diagnosis**

| Diagnosis | Avg Pain Level |
|-----------|----------------|
| Yes | 5.31 |
| No | 4.84 |

**Table 2. Average BMI by Diagnosis**

| Diagnosis | Avg BMI |
|-----------|---------|
| Yes | 23.4 |
| No | 22.8 |

**Table 3. Age by Diagnosis and Fertility Status**

| Diagnosis | Infertility | Min Age | Avg Age |
|-----------|-------------|---------|---------|
| Yes | Yes | 18 | 33.9 |
| No | No | 18 | 33.75 |

**Table 4. Menstrual Irregularity by Fertility Status**

| Infertility | Avg Irregularity Score |
|-------------|------------------------|
| Yes | 0.689 |
| No | 0.701 |

**Table 5. Symptom Cluster Frequency**

| Metric | Count |
|--------|-------|
| Patients with endo + abnormal hormones + menstrual irregularity | 2,145 |
| Total patients with endo | 4,079 |
| Percentage | 52.6% |

<div align="left">
  <h3>Figure 1. Pain Scoring</h3>
  <img src="images/Self-Reported Pain.jpeg" width="500">
</div>

<div align="left">
  <h3>Figure 2. Participant BMI</h3>
  <img src="images/Participant Body Mass Index Distribution.jpeg" width="500">
</div>

<div align="left">
  <h3>Figure 3. Logistic Regression for Endometriosis Diagnoses</h3>
  <img src="images/endo_table.png" width="500">
</div>

<div align="left">
  <h3>Figure 4. Participant Age</h3>
  <img src="images/Participant_Age.jpeg" width="500">
</div>

<div align="left">
  <h3>Figure 5. Odds Ratio Plot</h3>
  <img src="images/Odd Ratio Plot.jpeg" width="500">
</div>



## Discussion

Indiividuals with endometriosis had higher pain levels (5.31 vs 4.84, p < 0.001) and BMI (23.4 vs 22.8, p < 0.001) (Figures 1 and 2). The difference was small (0.6 points), which suggests that BMI as a standalone metric may not be useful. 

Among individuals who were infertile, menstrual irregularity was similar to individuals who were fertile (0.689 vs 0.701). This suggests that menstrual irregularity by itself is not a reliable indicator of infertility in this population.

Logistic regression indicated that all variables except age were significant predictors in an individual having an endometriosis diagnosis. (Figures 3, 4, 5). Individuals with hormone irregularity had 2.28 times the odds of having an endometriosis diagnosis compared to those without irregularity.

The most actionable finding was that 2,145 of 4,079 endometriosis patients (52.6%) presented with both abnormal hormone levels and menstrual irregularity. This symptom cluster captured over half of endometriosis cases, whereas individual factors showed minimal predictive value.

A limiting factor was the minimum age of 18 in the dataset. Endometriosis symptoms often appear in adolescence; therefore, collecting data on individuals younger than 18 may reveal earlier patterns of symptom onset. Additionally, data on PMDD screening would be valuable, as it is a known comorbidity. Understanding this relationship may improve initial diagnoses and strengthen treatment options for both conditions. 

## Conclusion

Individuals presenting with both abnormal hormone levels and menstrual irregularity should be prioritized for endometriosis screening, as this combination captured over 50% of diagnosed cases. Single factors such as BMI, age, and menstrual irregularity alone did not reliably distinguish between groups, reinforcing that combination screening is more effective than relying on individual symptoms.
