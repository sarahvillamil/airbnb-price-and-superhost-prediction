## Regression Prediction Problem Attempt 01
# Boosted Tree Model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(future)

# handle common conflicts ----
tidymodels_prefer() 

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)/2
plan(multisession, workers = num_cores)

# load data ----
load(here("01_attempt/results/recipes/airbnb_tree_recipe.rda"))
load(here("01_attempt/results/splits/airbnb_folds.rda"))

# model specifications ----
bt_spec <- boost_tree(
  min_n = tune(), 
  mtry = tune(), 
  learn_rate = tune(), 
  trees = tune()
) |>
  set_engine("xgboost") |> 
  set_mode("regression")

# define workflows----
bt_wkflow <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(airbnb_tree_recipe)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec) |> 
  update(min_n = min_n(range = c(2, 20)), 
         mtry = mtry(range = c(15, 35)), 
         learn_rate = learn_rate(range = c(-0.01, 0.05)), 
         trees = trees(range = c(750, 3000)))

# create grid on parameters ----
bt_grid <- grid_regular(bt_params, levels = 5)

set.seed(301)
# fit model ----
bt_tuned <- tune_grid(
  bt_wkflow, 
  resamples = airbnb_folds,
  grid = bt_grid, 
  metrics = metric_set(mae),
  control = control_grid(save_pred = TRUE, save_workflow = TRUE)
)

# save fit ----
save(bt_tuned, file = here("01_attempt/results/bt_tuned.rda"))
