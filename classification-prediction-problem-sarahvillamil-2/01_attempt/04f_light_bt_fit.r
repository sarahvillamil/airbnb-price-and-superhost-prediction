# Classification Prediction Problem Attempt 01
# Define and fit Light Boosted Tree model

# load packages ----
# install.packages("lightgbm", repos = "https://cran.r-project.org")
library(tidyverse)
library(tidymodels)
library(here)
library(future)
library(bonsai)

# handle common conflicts
tidymodels_prefer() 

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)/2
plan(multisession, workers = num_cores)

# load objects ----
load(here("01_attempt/results/recipes/airbnb_tree_recipe.rda"))
load(here("01_attempt/results/splits/airbnb_folds.rda"))

# model specification ----
bt_light_spec <- boost_tree(
  min_n = tune(), 
  mtry = tune(), 
  learn_rate = tune(), 
  trees = tune()
) |>
  set_engine("lightgbm") |> 
  set_mode("classification")

# define workflow----
bt_light_wkflow <- workflow() |> 
  add_model(bt_light_spec) |> 
  add_recipe(airbnb_tree_recipe)

# hyperparameter tuning values ----
bt_light_params <- extract_parameter_set_dials(bt_light_spec) |> 
  update(min_n = min_n(range = c(2,20)), 
         mtry = mtry(c(1, 10)), 
         learn_rate = learn_rate(range = c(-5, 0.4)), 
         trees = trees(range = c(250, 750)))

# create grid on parameters ----
bt_light_grid <- grid_regular(bt_light_params, levels = c(5, 3, 3, 5))

set.seed(301)
# fit workflow/model ----
bt_light_tuned <- tune_grid(
  bt_light_wkflow, 
  resamples = airbnb_folds,
  grid = bt_light_grid, 
  control = control_grid(save_pred = TRUE, save_workflow = TRUE)
)

# save fit ---- 
save(bt_light_tuned, file = here("01_attempt/results/bt_light_tuned.rda"))
