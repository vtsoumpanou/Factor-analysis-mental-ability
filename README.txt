# Factor Analysis of Mental Ability Test Scores

Course: Multivariate Data Analysis  
Institution: National and Kapodistrian University of Athens  
Department: Department of Mathematics

Exploratory factor analysis of the Holzinger-Swineford (1939) mental ability dataset using R.

# About

This project was completed as part of the Multivariate Data Analysis course at the National and Kapodistrian University of Athens. The objective is to identify latent dimensions underlying nine mental ability test scores from 301 students across two schools (Pasteur and Grant-White).

The analysis demonstrates the full factor analysis workflow: data validation, correlation diagnostics, factor extraction (maximum likelihood), rotation (varimax and promax), model adequacy assessment, and factor score computation for group comparisons.



# Files

| File | Description |
|------|-------------|
| `fa_code.R` | Complete R script with all analyses (fully commented) |
| `hs_mental_ability_test.csv` | Dataset (301 observations, 15 variables) |
| `Report_FA_VT.pdf` | Full 17-page analysis report |
| `Presentation_fa_case_study.pdf` | 5-slide executive summary |

# Key Findings

| Finding | Result |
|---------|--------|
| **Factors retained** | 3 (Verbal, Spatial, Processing speed) |
| **Variance explained** | 54% |
| **KMO** | 0.75 (meritorious) |
| **Bartlett's test** | p < 0.001 (suitable for FA) |
| **Model fit (Frobenius norm)** | 0.163 (acceptable) |

# Group Differences Detected

- **School:** Pasteur higher on spatial ability; Grant-White higher on verbal ability
- **Grade:** 8th graders outperform 7th graders on verbal and spatial tasks
- **Sex:** Males slightly faster on processing speed; females slightly stronger on verbal tasks

# Requirements

# Install R and RStudio

1. Download R from https://cran.r-project.org/
2. Download RStudio Desktop (free) from https://posit.co/download/rstudio-desktop/
3. Install R first, then RStudio

# Install Required Packages

Open RStudio and run:

`install.packages(c("psych", "rgl", "GPArotation"))`

Note: The `rgl` package is used for 3D visualizations. On some systems, you may need additional dependencies.

# Usage

### Clone the repository

`git clone https://github.com/your-username/factor-analysis-mental-ability.git`
`cd factor-analysis-mental-ability`

### Run the analysis

In RStudio, open and run:
`source("fa_code.R")`

Or run line by line in RMarkdown or R console.

# What the script does

1. Task 1: Loads data, descriptive statistics, outlier detection
2. Task 2: Correlation analysis, KMO, Bartlett's test
3. Task 3: Determines number of factors (scree plot, AIC/BIC, parallel analysis)
4. Task 4: Fits MLE factor model (3-factor and 4-factor comparison)
5. Task 5: Rotation and interpretation (varimax, promax, 3D visualizations)
6. Task 6: Model evaluation (residual matrix, Frobenius norm)
7. Task 7: Factor scores and group comparisons (school, grade, sex)

# Dataset

The Holzinger-Swineford (1939) dataset is a classic dataset in psychometrics and factor analysis. It contains mental ability test scores for students from two schools:

- Sample size: 301 students
- Schools: Pasteur and Grant-White
- Variables analyzed (x1 to x9):

x1: Visual perception (Visual/Spatial)
x2: Cubes (Visual/Spatial)
x3: Lozenges (Visual/Spatial)
x4: Paragraph comprehension (Textual/Verbal)
x5: Sentence completion (Textual/Verbal)
x6: Word meaning (Textual/Verbal)
x7: Speeded addition (Processing speed)
x8: Speeded counting of dots (Processing speed)
x9: Speeded discrimination (Processing speed)

Note: One observation (row 351) has a missing value in the grade column. R handles this appropriately during analysis.

# Results Summary

# Factor Loadings (Varimax Rotation)

Variable x1: loads on Spatial (0.72)
Variable x2: loads on Spatial (0.65)
Variable x3: loads on Spatial (0.58)
Variable x4: loads on Verbal (0.85)
Variable x5: loads on Verbal (0.82)
Variable x6: loads on Verbal (0.78)
Variable x7: loads on Processing Speed (0.67)
Variable x8: loads on Processing Speed (0.71)
Variable x9: loads on Processing Speed (0.55) and Spatial (0.32)

# Model Comparison

2 factors: AIC = 3.85, BIC = 11.26, Cumulative Variance = 48%
3 factors: AIC = 5.85, BIC = 16.97, Cumulative Variance = 54%
4 factors: AIC = 7.85, BIC = 22.68, Cumulative Variance = 58%

The 3-factor solution was selected based on theoretical interpretability and variance explained, despite AIC/BIC modestly favoring the 2-factor solution (Delta AIC = 2.00).

# Project Structure

factor-analysis-mental-ability/
├── fa_code.R
├── hs_mental_ability_test.csv
├── Report_FA_VT.pdf
├── Presentation_fa_case_study.pdf
├── README.md
└── .gitignore

# Limitations

- Maximum likelihood estimation assumes multivariate normality (variables showed some deviation)
- No inferential testing on factor scores (descriptive comparisons only)
- Historical data from 1939 (generalizability may be limited)
- Factor retention criteria did not fully converge (AIC/BIC favored 2 factors, theory favored 3)

# Future Work

- Cross-validate factor structure on an independent sample
- Employ parallel analysis for additional guidance on factor retention
- Conduct formal inferential tests on factor score differences
- Compare with confirmatory factor analysis (CFA) approach

# Author

Vasiliki Tsoumpanou
National and Kapodistrian University of Athens
Department of Mathematics

# License

This project is for educational purposes as part of coursework at the National and Kapodistrian University of Athens.

# Acknowledgements

- Course Instructor: Ioannis Oikonomidis
- Textbook: Multivariate Data Analysis Notes, Loukia Meligkotsidou
- Dataset: Holzinger-Swineford (1939) mental ability study

# Contact

email: vasiliki.tsoumpanou@gmail.com
GitHub: https://github.com/vtsoumpanou
