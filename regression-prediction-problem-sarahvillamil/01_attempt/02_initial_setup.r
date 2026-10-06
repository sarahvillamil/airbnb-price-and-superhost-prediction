## Regression Prediction Problem Attempt 01
# Data folding

# load packages ----
library(tidyverse)
library(tidymodels) 
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
load(here("01_attempt/results/splits/clean_train.rda"))

#data already split.

# folding ----
airbnb_folds <-
  vfold_cv(clean_train, v = 5, repeats = 3, strata = price)

# saving folds ----
save(airbnb_folds, file = here("01_attempt/results/splits/airbnb_folds.rda")) 