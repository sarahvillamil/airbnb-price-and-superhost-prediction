# Classification Prediction Problem Attempt 01
# Data folding

# load packages ----
library(tidyverse)
library(tidymodels) 
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
load(here("01_attempt/results/splits/airbnb_clean_train.rda"))

# data already split.

# folding ----
airbnb_folds <-
  vfold_cv(airbnb_clean_train, v = 5, repeats = 3, strata = host_is_superhost)

save(airbnb_folds, file = here("01_attempt/results/splits/airbnb_folds.rda")) 

# airbnb_clean_train |> 
#  group_by(host_is_superhost) |> 
#  count()
#5430:4380
# no missingness or crazy imbalance in class outcome groups.
