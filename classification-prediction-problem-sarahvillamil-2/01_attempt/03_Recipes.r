# Classification Prediction Problem Attempt 01
# Recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data -----
load(here("01_attempt/results/splits/airbnb_clean_train.rda"))

# recipe with basic imputation ----
airbnb_basic_recipe <- recipe(host_is_superhost ~ ., data = airbnb_clean_train) |>
  step_rm(description, amenities, host_about, host_since, first_review, id,
          last_review, host_verifications, host_listings_count,
          number_of_reviews_ltm, number_of_reviews_l30d, 
          calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
          calculated_host_listings_count_entire_homes, host_about_length, host_location) |>
  step_impute_mean(host_total_listings_count, bedrooms, desc_length, num_bath, minimum_minimum_nights, 
                   maximum_minimum_nights, minimum_maximum_nights, maximum_maximum_nights, host_years, 
                   review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, 
                   review_scores_communication, review_scores_location, review_scores_value, 
                   review_scores_rating, most_recent_review, reviews_per_month, beds, 
                   host_response_rate, host_acceptance_rate) |>
  step_impute_mode(host_has_profile_pic, host_identity_verified, bathrooms_text, has_availability, 
                   host_response_time, host_neighbourhood, host_lives_local) |>
  step_novel(all_nominal_predictors()) |> 
  step_other(all_nominal_predictors(), threshold = 0.01) |>
  step_unknown(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# check recipe
# airbnb_basic_recipe |> 
#  prep() |> 
#  bake(new_data = NULL)

# save recipe ----
save(airbnb_basic_recipe, file = here("01_attempt/results/recipes/airbnb_basic_recipe.rda")) 

# advanced recipe with advanced imputation ----
airbnb_adv_recipe <- recipe(host_is_superhost ~ ., data = airbnb_clean_train) |>
  step_rm(description, amenities, host_about, host_since, first_review, id,
          last_review, host_verifications, host_listings_count,
          number_of_reviews_ltm, number_of_reviews_l30d, 
          calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
          calculated_host_listings_count_entire_homes, host_about_length, host_location) |>
  step_impute_bag(review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, 
                  review_scores_communication, review_scores_location, review_scores_value, 
                  review_scores_rating, most_recent_review, reviews_per_month, beds, 
                  host_response_rate, host_acceptance_rate) |>
  step_impute_knn(host_response_time, host_neighbourhood, host_lives_local) |> 
  step_impute_mean(host_total_listings_count, bedrooms, desc_length, num_bath, minimum_minimum_nights, 
                   maximum_minimum_nights, minimum_maximum_nights, maximum_maximum_nights, host_years) |>
  step_impute_mode(host_has_profile_pic, host_identity_verified, bathrooms_text, has_availability) |>
  step_novel(all_nominal_predictors()) |> 
  step_unknown(all_nominal_predictors(), new_level = "unknown") |> 
  step_other(all_nominal_predictors(), threshold = 0.01) |>
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
  
# airbnb_adv_recipe |> 
#    prep() |> 
#   bake(new_data = NULL)

# save recipe ----
save(airbnb_adv_recipe, file = here("01_attempt/results/recipes/airbnb_adv_recipe.rda")) 

# advanced recipe tree ----
airbnb_tree_recipe <- recipe(host_is_superhost ~ ., data = airbnb_clean_train) |>
  step_rm(description, amenities, host_about, host_since, first_review, id,
          last_review, host_verifications, host_listings_count,
          number_of_reviews_ltm, number_of_reviews_l30d, 
          calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
          calculated_host_listings_count_entire_homes, host_about_length, host_location) |>
  step_impute_bag(review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, 
                  review_scores_communication, review_scores_location, review_scores_value, 
                  review_scores_rating, most_recent_review, reviews_per_month, beds, 
                  host_response_rate, host_acceptance_rate) |>
  step_impute_knn(host_response_time, host_neighbourhood, host_lives_local) |> 
  step_impute_mean(host_total_listings_count, bedrooms, desc_length, num_bath, minimum_minimum_nights, 
                   maximum_minimum_nights, minimum_maximum_nights, maximum_maximum_nights, host_years) |>
  step_impute_mode(host_has_profile_pic, host_identity_verified, bathrooms_text, has_availability) |>
  step_novel(all_nominal_predictors()) |> 
  step_other(all_nominal_predictors(), threshold = 0.01) |>
  step_unknown(all_nominal_predictors()) |> 
# step_interact(accomdates:bedroom, accomdates:bed, num_bath:bedrooms, accomdates:num:bath)
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

# airbnb_tree_recipe |> 
#  prep() |> 
#  bake(new_data = NULL)

# save tree recipe ----
save(airbnb_tree_recipe, file = here("01_attempt/results/recipes/airbnb_tree_recipe.rda")) 