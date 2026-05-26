#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Case Study: Factor Analysis of Mental Ability Test Scores      ~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# First install and load package psych
library(psych)
# e.g KMO() is in this library
# and fa()


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 1 Descriptive Stats                        ~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Load data in data frame form

df1 <- read.csv("hs_mental_ability_test.csv")
head(df1)

# Correlation diagnostics were run for the complete dataset --  > not
# particularly strong correlations were detected -->
# only x1:9 are considered relevant for this analysis

# Variables x1:9 will be included in the analysis
df <- df1[, 7:15]
head(df)

# Calculate means and standard deviation
round(cbind(apply(df, 2, mean), apply(df, 2, sd)), 2)

#Some plots to detect outliers
par(mfrow = c(3, 3))

for (i in 1:ncol(df)) {
  hist(
    df[, i],
    main = paste("Distribution of", colnames(df)[i]),
    xlab = colnames(df)[i],
    col = "lightblue",
    border = "darkblue",
    breaks = 10
  )
}
par(mfrow = c(1, 1))
boxplot(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 2 Examine Correlations          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Recalculate metrics for trimmed dataset
# Correlation plots
pairs(df)

# Correlation Matrix
print(cor(df), 2)

# KMO
KMO(df)

# Testing correlations
cortest.bartlett(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 3 Choose Number of Factors          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Based on expert knowledge, 3 factors will be considered;
# Visual / spatial ability, Textual / verbal ability and Processing speed

# This 3 factor assumption will be judged later, after fitting the model

scree(df)

# The screeplot suggests keeping 1 factor (Kaiser's Criterion) or 2-3 factors
# (based on elbow of the screeplot)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# For a more robust approach, AIC and BIC will be considered.
# Calculation of AIC and BIC is done by hand, despite the fact that
# R built-in methods exist

# Test normality to check if MLE approach is valid
# Very low p_values for most variables raise concerns -->
# methodoligicaly sound to assume normality?
apply(df, 2, shapiro.test)


# Perform factor analysis with fa() function
fa.3 <- fa(
  r = cor(df),
  nfactors = 3,
  rotate = "none",
  fm = "ml"
)
summary(fa.3)

# Obtain value of minimized MLE function
l.3 <- fa.3$objective

# Calculate AIC and BIC
# Note that the model with the lowest AIC / BIC offers the best fit
# The absolute values of AIC / BIC do not provide any information
# about model fit, only comparative interpretation is valuable

aic <- function(k , l) {
  2 * k - 2 * l
}

bic <- function(k , l, nobs) {
  log(nobs) * k - 2 * l
}

# 3 factor model

aic_3 <- aic(3 , l.3)
aic_3

bic_3 <- bic(3, l.3, 301)
bic_3

# 4 factor model

fa.4 <- fa(
  r = cor(df),
  nfactors = 4,
  rotate = "none",
  fm = "ml"
)
summary(fa.4)

l.4 <- fa.4$objective

aic_4 <- aic(4 , l.4)
aic_4

bic_4 <- bic(4, l.4, 301)
bic_4

# 2 factor model

fa.2 <- fa(
  r = cor(df),
  nfactors = 2,
  rotate = "none",
  fm = "ml"
)
summary(fa.2)

l.2 <- fa.2$objective

aic_2 <- aic(2 , l.2)
aic_2

bic_2 <- bic(2, l.2, 301)
bic_2

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# At this point it should be noted that AIC and BIC crude numbers are not
# relevant for making the comparison between models.
# It should also be noted that fa$objective used to calculate AIC and BIC is NOT
# the loglikelihood. However, for comparison and delta score interpretation
# this is not significantly off.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Calculate delta score to compare models
# i.e the difference between the AIC or BIC values of each model relative to the
# best (lowest) score. In our case, the 2 factor model has the lowest AIC/BIC
# The delta value tells us how much worse a model is compared to the top model

delta_2.3 <- c(aic_3 - aic_2, bic_3 - bic_2)
delta_2.3

delta_2.4 <- c(aic_4 - aic_2, bic_4 - bic_2)
delta_2.4

# Interpretation of delta scores
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A delta <2 generally suggests that the competing model has substantial support
# A delta between 4 and 7 indicates considerably less support
# A delta >10 implies that the competing model is very unlikely
# relative to the best model
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# delta_2.3
#  2.00000 5.70711

# delta_2.4
# 4.00000 11.41422

# Observe that the BIC delta scores favor the 2 factor model more
# This is due to the more "harsh" penalty in BIC (log(n)) that points
# towards more parsimonious models as the number of observations increases
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# After careful consideration and balancing statistical evidence with
# expert judgement, the 3 factor model will serve as our base model
# To evaluate goodness of fit, further benchmarks and model comparisons
# will be conducted in Task 4.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Most robust method to decide number of factors --> parallel analysis
# Parallel analysis suggests 3 factors as well

fa.parallel(df, fm = "ml")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 4 Fit MLE FA model              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fa3 <- factanal(df, factors = 3)
fa3


# The 3 factor assumption leads to a model that explains 54% of the
# variance. Test of the hypothesis that 3 factors are sufficient yields p<0.05
# but p >0.01. Therefore a model with 4parameters will be fit to compare results.

fa4 <- factanal(df, factors = 4)
fa4

# Variance explained did not rise dramatically (54%-->58%), p>0.05 indicates
# that 4 factors are sufficient. However, based on the screeplot, expert judgement and
# the small contribution of the 4th factor to the explined variance, the model
# with 3 factors is more suitable for parsimony.

# uniquenesses
fa3$uniquenesses

# communality
rowSums(fa3$loadings^2)

1 - rowSums(fa3$loadings^2) # uniqueness

# The residual matrix
Lambda <- fa3$loadings
Lambda
Psi <- diag(fa3$uniquenesses)
Psi
R <- fa3$correlation
Rhat <- Lambda %*% t(Lambda) + Psi
round(R - Rhat, 6)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 5 Rotation and Interpretation            ~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Interpretation of the factors
fa3.none <- factanal(df, factors = 3, rotation = "none")
fa3.varimax <- factanal(df, factors = 3, rotation = "varimax")
fa3.promax <- factanal(df, factors = 3, rotation = "promax")

# import and load rgl package
install.packages("rgl")
library(rgl)

# plot the 3D graph
plot3d(
  fa3.none$loadings[, 1],
  fa3.none$loadings[, 2],
  fa3.none$loadings[, 3],
  col = "blue",
  size = 10,
  xlim = c(-1, 1),
  ylim = c(-1, 1),
  zlim = c(-1, 1)
)



plot3d(
  fa3.varimax$loadings[, 1],
  fa3.varimax$loadings[, 2],
  fa3.varimax$loadings[, 3],
  col = "violet",
  size = 10,
  xlim = c(-1, 1),
  ylim = c(-1, 1),
  zlim = c(-1, 1)
)


plot3d(
  fa3.promax$loadings[, 1],
  fa3.promax$loadings[, 2],
  fa3.promax$loadings[, 3],
  col = "sienna",
  size = 10,
  xlim = c(-1, 1),
  ylim = c(-1, 1),
  zlim = c(-1, 1)
)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Comments                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# There are three distinct clusters of variables, with three variables each.
# This suggests that the initial grouping rationale was well-informed, however
# interpretation is not completely straightforward, even after rotation.
# This again is expected due to the complicated
# and abstract notion of mental abilities
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Projections to two dimensional plots

pairs(fa3.none$loadings[, 1:3])

pairs(fa3.varimax$loadings[, 1:3])

pairs(fa3.promax$loadings[, 1:3])

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 6 Evaluation of Factor Model             ~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

D <- round(R - Rhat, 6)
D
norm(D, type = 'f')
# 0.1633003 is considered small enough-->the model fits well

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TASK 7 Factor Scores                          ~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Factor analysis using principal component method
# factor score estimation is straightforward
fitPCA <- principal(df,
                    nfactors = 3,
                    covar = F,
                    rotate = "none")
fitPCA

# Factor scores
colMeans(fitPCA$scores)
cov(fitPCA$scores)

scores <- scale(df) %*% (solve(cor(df)) %*% fitPCA$loadings[, 1:3])
scores

df.complete <- df1
df.complete$pc1 <- scores[, 1]
df.complete$pc2 <- scores[, 2]
df.complete$pc3 <- scores[, 3]
head(df.complete)


# Mean factor scores by school
pasteur <- subset(df.complete, school == "Pasteur")
gw <- subset(df.complete, school == "Grant-White")

round(colMeans(pasteur[16:18]), 2)
round(colMeans(gw[16:18]), 2)

# Mean factor scores by grade

gr7 <- subset(df.complete, grade == 7)
gr8 <- subset(df.complete, grade == 8)

round(colMeans(gr7[16:18]), 2)
round(colMeans(gr8[16:18]), 2)


# Mean factor scores by sex

male <- subset(df.complete, sex == 1)
female <- subset(df.complete, sex == 2)

round(colMeans(male[16:18]), 2)
round(colMeans(female[16:18]), 2)

# Comparison with factor score estimation via regression (MLE fa)

fitMLE <- factanal(df,
                   factors = 3,
                   scores = "regression",
                   rotation = "none")
fitMLE

# Obtain scores
scores.est <- fitMLE$scores
df.mle <- df1
df.mle$f1 <- scores.est[, 1]
df.mle$f2 <- scores.est[, 2]
df.mle$f3 <- scores.est[, 3]
head(df.mle)

# Mean factor scores by school
pasteur <- subset(df.mle, school == "Pasteur")
gw <- subset(df.mle, school == "Grant-White")

round(colMeans(pasteur[16:18]), 2)
round(colMeans(gw[16:18]), 2)

# Mean factor scores by grade

gr7 <- subset(df.mle, grade == 7)
gr8 <- subset(df.mle, grade == 8)

round(colMeans(gr7[16:18]), 2)
round(colMeans(gr8[16:18]), 2)


# Mean factor scores by sex

male <- subset(df.mle, sex == 1)
female <- subset(df.mle, sex == 2)

round(colMeans(male[16:18]), 2)
round(colMeans(female[16:18]), 2)

# Despite producing different scores, both methods of score
# estimation (pca-regression) lead to the same interpretation--> consistency.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# END OF PROJECT