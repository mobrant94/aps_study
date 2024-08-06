# Context
Economic vulnerability in developing countries results in deficient healthcare systems with failures at various levels of care, affecting access and quality of services. Primary Health Care (PHC) is a care model recommended by the World Health Organization (WHO) as an essential strategy for achieving universal and comprehensive health. This study aims to analyze the impact of PHC on the vaccination coverage of the pneumococcal vaccine (PCV10) and hospitalization rates for pneumonia in children under 5 years old in Brazilian municipalities. Evaluating the effects of PHC on immunization programs is crucial for understanding child protection and health sustainability.

## Statistical Analysis
The statistical analysis was conducted using the R environment (RStudio version 4.4.1). Data were described using medians and interquartile ranges (IQR) or means and standard deviations (SD) for numerical variables, and frequencies and proportions for categorical variables. No imputation of missing values was performed.

The analysis was divided into three main parts:

### Descriptive Analysis of the Pandemic and Vaccination Coverage:
We assessed the daily progression of the COVID-19 burden (hospitalizations per 100,000 inhabitants) and vaccination coverage. Vaccination coverage was calculated based on the number of individuals vaccinated, stratified by municipality, state, and region.

### Analysis of the Association with GDP per Capita:
We estimated the association between GDP per capita and vaccination rates using a multivariate regression model. The first dose vaccination rate was the dependent variable, and GDP per capita (classified as low) was the main variable of interest. Covariates included municipal population size, population density, pneumonia hospitalization rates between 2008 and 2022, the five Brazilian macro-regions (North, Northeast, Central-West, Southeast, and South), and PHC coverage. An interaction term between GDP per capita and PHC coverage was included in the model.

### Data Treatment and Visualization:
Data were adjusted for prevalence using the formula: cases/population in the area x 100,000. Descriptive analyses were presented by state and region. Visualization maps were used to assess spatial-temporal changes, and regressions were applied to analyze temporal changes. Packages used for data analysis and visualization included ggplot2, geobr, tidyverse, janitor, and microdatasus. Additionally, sensitivity analyses were performed to assess the robustness of the estimates:
- Evaluation of the association between GDP per capita and vaccination coverage rates adjusted for the same covariates.
- Estimation of the association between GDP per capita and vaccination coverage rates for doses administered to children under 4 years old, to observe the effect without the impact of potential priority groups in the vaccination campaign.
