# Classification Prediction Problem Attempt 01
## Tuning for Neural Net model 

# Load package ----
library(tidyverse)
library(tidymodels)
library(here)
library(future)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- availableCores(logical = FALSE) / 2
plan(multisession, workers = num_cores)

# load data ----
load(here("01_attempt/results/splits/airbnb_folds.rda"))
load(here("01_attempt/results/recipes/airbnb_adv_recipe.rda"))

# model specification ----
nn_model <- mlp(
  mode = "classification",
  hidden_units = tune(),
  penalty = tune()
) |>
  set_engine("nnet")

# define workflow ----
nn_wflow <-
  workflow() |>
  add_model(nn_model) |>
  add_recipe(airbnb_adv_recipe)

# hyperparameter tuning values ----
nn_params <- extract_parameter_set_dials(nn_model)

# create grid on parameters -----
nn_grid <- grid_space_filling(nn_params, size = 20)

set.seed(301)
# tune/fit workflow/model ----
nn_tuned <- tune_grid(
  nn_wflow, 
  resamples = airbnb_folds,
  grid = nn_grid, 
  control = control_grid(save_pred = TRUE, save_workflow = TRUE)
)

# save fit ----
save(nn_tuned, file = here("01_attempt/results/nn_tuned.rda"))
