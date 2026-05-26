## ----setup, include=FALSE-----------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

# clear console
cat("\014")

# install packages
if (!require("pacman")) install.packages("pacman")

# install additional packages
pacman::p_load(
  rio,
  here,
  tidyverse,
  ggplot2,
  dplyr,
  ggthemes,
  gtsummary,
  flextable,
  skimr,
  gt,
  forestplot,
  broom,
  writexl,
  flextable,
  ggpubr
)

# set root directory and make into object
root_dir <- "/Users/adwoaodoom/Desktop/Ad-Hoc Projects"


## -----------------------------------------------------------------------------------------------------------------------
# import dataset
endo <- rio::import(here::here(root_dir, "structured_endometriosis_data.csv"))


## -----------------------------------------------------------------------------------------------------------------------
# explore dataset
str(endo)
dim(endo) # 10k observations, 7 columns

# rename columns
endo <- endo %>%
  rename(
    diagn = `Diagnosis`,
    mens_irr    = `Menstrual_Irregularity`,
    pain_lvl    = `Chronic_Pain_Level`,
    hormone_irr = `Hormone_Level_Abnormality`,
    infert      = `Infertility`,
    age = `Age`,
    bmi = `BMI`)

#check
names(endo)

# change applicable variables to factors for comparison
endo <- endo %>%
  mutate(
    diagn = factor(diagn, levels =c(0,1), labels = c("No", "Yes")),
    mens_irr    = factor(mens_irr, levels = c(0,1), labels = c("No","Yes")),
    hormone_irr = factor(hormone_irr, levels = c(0,1), labels = c("Normal","Irregular")),
    infert      = factor(infert, levels = c(0,1), labels = c("No","Yes")))

# check if converted correctly
is.factor(endo$diagn)
is.factor(endo$mens_irr)
is.factor(endo$hormone_irr)
is.factor(endo$infert)

# use skimr to glean more insight into data
skimr::skim(endo)


## -----------------------------------------------------------------------------------------------------------------------
# visualization: boxplot for continuous variables
# age
endo %>% 
  ggplot(aes(x = diagn, y = age)) + 
  geom_boxplot() + 
  stat_compare_means(
    method = "t.test",
    label = "p.signif"
  ) +
  labs(title = "Participant Age",
       x = "Diagnosis",
       y = "Age, years") +
  theme_bw()

ggsave("Participant_Age.jpeg", width = 8, height = 6)


## -----------------------------------------------------------------------------------------------------------------------
# chronic pain level
endo %>% 
  ggplot(aes(x = diagn, y = pain_lvl)) + 
  geom_boxplot() +
  stat_compare_means(
    method = "t.test",
    label = "p.signif"
  ) +
  labs(title = "Self-Reported Pain Level",
       x = "Diagnosis",
       y = "Pain Score") + 
  theme_bw() # background color

ggsave("Self-Reported Pain.jpeg", width = 8, height = 6)


## -----------------------------------------------------------------------------------------------------------------------
# bmi
endo %>% 
  ggplot(aes(x = diagn, y=bmi)) +
  geom_boxplot() + 
  stat_compare_means(
    method = "t.test",
    label = "p.signif"
  ) +
  labs(title = "Participant Body Mass Index Distribution",
       x = "Diagnosis",
       y = "BMI (kg/m^2)") + 
  theme_bw() # background color 

ggsave("Participant Body Mass Index Distribution.jpeg", width = 8, height = 6)


## -----------------------------------------------------------------------------------------------------------------------
t.test(age ~ diagn, data = endo)

t.test(bmi ~ diagn, data = endo)

t.test(pain_lvl ~ diagn, data = endo)
# save
ggsave()



## -----------------------------------------------------------------------------------------------------------------------
# logistic regression - if age is a predictor for an endo diagnosis
age_fit <- glm(diagn ~ age, data = endo, family = binomial(link = "logit"))


# view
summary(age_fit)

# odds ratio
coef(age_fit) %>% exp()

# By itself, age is not a significant predictor in whether an individual has an endo diagnosis. The odds ratio means that each additional year decreases odds by 1%.

# model with multiple predictors
endo_mod <- glm(diagn ~ age + mens_irr + pain_lvl + hormone_irr + infert + bmi, data = endo, family = binomial(link = "logit"))

# view
summary(endo_mod)

# odds ratio
coef(endo_mod) %>% exp()

# put model in summary table
endo_table <- tbl_regression(
  endo_mod,
  exponentiate = TRUE, # show odds ratios
    label = list(
    age          ~ "Age (years)",
    mens_irr     ~ "Menstrual Irregularity",
    pain_lvl     ~ "Chronic Pain Level",
    hormone_irr  ~ "Hormone Irregularity",
    infert       ~ "Infertility",
    bmi          ~ "BMI")) %>% 
      modify_caption("Endometriosis Logistic Regression Model") %>% 
      bold_labels() %>% 
      as_flex_table() %>%
  bg(bg = "white", part = "all") %>%
  color(color = "black", part = "all")


#view table
endo_table

# save
save_as_image(endo_table, path = "endo_table.png")


# odds ratio chart
coef_endo <- coef(endo_mod)
se_endo <- summary(endo_mod)$coefficients[, "Std. Error"]

forest_data <- data.frame(
  term = names(coef_endo),
  mean = exp(coef_endo),
  lower = exp(coef_endo - 1.96 * se_endo),
  upper = exp(coef_endo + 1.96 * se_endo))

forest_data <- forest_data[forest_data$term != "(Intercept)", ]

# rename
forest_data$term <- c(
  "Age",
  "Menstrual Irregularity",
  "Pain Level",
  "Hormone Irregularity",
  "Infertility",
  "BMI"
)

# plot it
forestplot(
  labeltext = forest_data$term,
  mean = forest_data$mean,
  lower = forest_data$lower,
  upper = forest_data$upper,
  zero = 1,
  xlab = "Odds Ratio"
)

# save
ggsave("Odds Ratio.jpeg", width = 8, height = 6)


