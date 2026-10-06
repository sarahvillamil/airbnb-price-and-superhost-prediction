## Regression Prediction Problem Attempt 01
# Recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data ----
load(here("01_attempt/results/splits/clean_train.rda"))

# airbnb recipe with imputation----
airbnb_adv_recipe <- recipe(price ~ ., data = clean_train) |>
  step_rm(description, amenities, host_about, host_since, first_review, id,
          last_review, host_verifications, host_listings_count,
          number_of_reviews_ltm, number_of_reviews_l30d, 
          calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
          calculated_host_listings_count_entire_homes, host_about_length, host_location) |>
  step_novel(all_nominal_predictors()) |> 
  step_other(all_nominal_predictors(), threshold = 0.01) |>
  step_unknown(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# check recipe
# airbnb_adv_recipe |> 
#  prep() |> 
#  bake(new_data = NULL)

# View(airbnb_basic_recipe)

# save recipe ----
save(airbnb_adv_recipe, file = here("01_attempt/results/recipes/airbnb_adv_recipe.rda")) 

# airbnb recipe tree ----
airbnb_tree_recipe <- recipe(price ~ ., data = clean_train) |>
  step_rm(description, amenities, host_about, host_since, first_review, id,
          last_review, host_verifications, host_listings_count,
          number_of_reviews_ltm, number_of_reviews_l30d, 
          calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
          calculated_host_listings_count_entire_homes, host_about_length, host_location) |>
  step_novel(all_nominal_predictors()) |> 
  step_other(all_nominal_predictors(), threshold = 0.01) |>
  step_unknown(all_nominal_predictors()) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

#airbnb_tree_recipe |> 
#  prep() |> 
#  bake(new_data = NULL)

# save tree recipe ----
save(airbnb_tree_recipe, file = here("01_attempt/results/recipes/airbnb_tree_recipe.rda")) 