# Classification Prediction Problem Attempt 01
# Define and fit logistic regression model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(future)

# handle common conflicts
tidymodels_prefer() 

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)/2
plan(multisession, workers = num_cores)

# load objects ----
load(here("01_attempt/results/splits/airbnb_folds.rda"))
load(here("01_attempt/results/recipes/airbnb_adv_recipe.rda"))

# model specifications ----
logist_spec <- logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

# define workflows  ----
logist_wkflow <- workflow() |> 
  add_model(logist_spec) |> 
  add_recipe(airbnb_adv_recipe)

set.seed(301)
# fit workflows/model  
logist_tuned <- fit_resamples(
  logist_wkflow, 
  resamples = airbnb_folds,
  control = control_grid(save_pred = TRUE, save_workflow = TRUE)
)

# save fit ---- 
save(logist_tuned, file = here("01_attempt/results/logist_tuned.rda"))
