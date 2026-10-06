# Classification Prediction Problem Attempt 01
## Initial cleaning/data quality

# Load package(s) ----
library(tidymodels)
library(tidyverse)
library(here)
library(naniar)
library(lubridate)

# handle common conflicts
tidymodels_prefer()

# load data ----
airbnb_train <- read_csv(here("data/raw/train.csv"))
airbnb_test <- read_csv(here("data/raw/test.csv"))

# EDA of Data ----
skimr::skim_without_charts(airbnb_train)

# Missingness Overview of Data ----
## all variables with missingness
airbnb_train |> 
  miss_var_summary() |> 
  filter(n_miss > 0)

# start cleaning -----
airbnb_clean_train <- airbnb_train |> 
  mutate(
    #set NA values 
    across(where(is.character), ~na_if(.x, "N/A")), 
    across(where(is.character), ~na_if(.x, "")),
    # take out percentages
    host_response_rate = parse_number(host_response_rate),
    host_acceptance_rate = parse_number(host_acceptance_rate),
    #outcome variable
    host_is_superhost = as.factor(case_when(
      (host_is_superhost == 1) ~ "Yes", 
      (host_is_superhost == 0) ~ "No")),
    # description (take out description in recipe)
    desc_length = str_length(description), 
    has_desc = !is.na(description), 
    # host about
    host_about_length = str_length(host_about), 
    has_host_about = !is.na(host_about), 
    # bathroom
    bathrooms_text = (str_replace(bathrooms_text, "[H|h]alf-bath", "0.5")),
    num_bath = (str_remove_all(bathrooms_text, "[A-z]")|> as.numeric()), 
    # host vertify
    host_verify_email = str_detect(host_verifications, "\\bemail\\b"), 
    host_verify_phone = str_detect(host_verifications, "phone"), 
    host_verify_work_email = str_detect(host_verifications, "work_email"), 
    host_verify_none = str_detect(host_verifications, "None"), 
    # amenities
    num_amenities = str_count(amenities, ",") + 1, 
    wifi = str_detect(amenities, "(W|w)ifi") |> as.numeric(), 
    pool = str_detect(amenities, "(P|p)ool") |> as.numeric(), 
    parking = str_detect(amenities, "(P|p)arking") |> as.numeric(),
    pets = str_detect(amenities, "(P|p)ets") |> as.numeric(), 
    tv = str_detect(amenities, "(T|t)(V|v)") |> as.numeric(),
    # host since
    host_years = round(time_length(interval(host_since, Sys.Date()), "years")),
    # review
    has_review = !is.na(first_review) | !is.na(last_review),
    most_recent_review = (round(time_length(interval(last_review, Sys.Date()), "days"))),
    reviews_per_month = round(reviews_per_month),
    # host location
    host_location = if_else(str_detect(host_location, ","), 
                            str_remove(host_location, "^.*?,\\s*"), 
                            host_location),
    host_location = case_when(host_location == "Illinois" ~ "IL",
                              host_location == "D.C." ~ "DC",
                              host_location == "D.C., DC" ~ "DC",
                              host_location == "Nakagami District, Japan" ~ "Japan",
                              TRUE ~ host_location),
    # host lives local
    host_neighbourhood = str_to_lower(str_trim(host_neighbourhood)),
    neighbourhood_cleansed = str_to_lower(str_trim(neighbourhood_cleansed)),
    host_lives_local = as.factor(case_when(is.na(host_neighbourhood) | is.na(neighbourhood_cleansed) ~ NA,
                                           host_neighbourhood == neighbourhood_cleansed ~ "Yes",
                                           TRUE ~ "No")),
    # set character as factors
    across(where(is.character), as.factor),
    host_has_profile_pic = as.factor(host_has_profile_pic), 
    host_identity_verified = as.factor(host_identity_verified), 
    has_availability = as.factor(has_availability), 
    instant_bookable = as.factor(instant_bookable), 
    has_review = as.factor(has_review), 
    # max/min nights
    minimum_nights_avg_ntm = round(minimum_nights_avg_ntm),
    maximum_nights_avg_ntm = round(maximum_nights_avg_ntm),
    #leave id as factor 
    id = as.factor(id),
    # set logical as numeric 
    across(where(is.logical), as.numeric))

## View(airbnb_clean_train)
## skimr::skim_without_charts(airbnb_clean_train)

# save train ----
save(airbnb_clean_train, file = here("01_attempt/results/splits/airbnb_clean_train.rda"))

# clean testing data -----
airbnb_clean_test <- airbnb_test |> 
  mutate(
    #set NA values 
    across(where(is.character), ~na_if(.x, "N/A")), 
    across(where(is.character), ~na_if(.x, "")),
    # take out percentages
    host_response_rate = parse_number(host_response_rate),
    host_acceptance_rate = parse_number(host_acceptance_rate),
    # description (take out description in recipe)
    desc_length = str_length(description), 
    has_desc = !is.na(description), 
    # host about
    host_about_length = str_length(host_about), 
    has_host_about = !is.na(host_about), 
    # bathroom
    bathrooms_text = (str_replace(bathrooms_text, "[H|h]alf-bath", "0.5")),
    num_bath = (str_remove_all(bathrooms_text, "[A-z]")|> as.numeric()), 
    # host vertify
    host_verify_email = str_detect(host_verifications, "\\bemail\\b"), 
    host_verify_phone = str_detect(host_verifications, "phone"), 
    host_verify_work_email = str_detect(host_verifications, "work_email"), 
    host_verify_none = str_detect(host_verifications, "None"), 
    # amenities
    num_amenities = str_count(amenities, ",") + 1, 
    wifi = str_detect(amenities, "(W|w)ifi") |> as.numeric(), 
    pool = str_detect(amenities, "(P|p)ool") |> as.numeric(), 
    parking = str_detect(amenities, "(P|p)arking") |> as.numeric(),
    pets = str_detect(amenities, "(P|p)ets") |> as.numeric(), 
    tv = str_detect(amenities, "(T|t)(V|v)") |> as.numeric(),
    # host since
    host_years = round(time_length(interval(host_since, Sys.Date()), "years")),
    # review
    has_review = !is.na(first_review) | !is.na(last_review),
    most_recent_review = (round(time_length(interval(last_review, Sys.Date()), "days"))),
    reviews_per_month = round(reviews_per_month),
    # host location
    host_location = if_else(str_detect(host_location, ","), 
                            str_remove(host_location, "^.*?,\\s*"), 
                            host_location),
    host_location = case_when(host_location == "Illinois" ~ "IL",
                              host_location == "D.C." ~ "DC",
                              host_location == "D.C., DC" ~ "DC",
                              host_location == "Nakagami District, Japan" ~ "Japan",
                              TRUE ~ host_location),
    # host lives local
    host_neighbourhood = str_to_lower(str_trim(host_neighbourhood)),
    neighbourhood_cleansed = str_to_lower(str_trim(neighbourhood_cleansed)),
    host_lives_local = as.factor(case_when(is.na(host_neighbourhood) | is.na(neighbourhood_cleansed) ~ NA,
                                           host_neighbourhood == neighbourhood_cleansed ~ "Yes",
                                           TRUE ~ "No")),
    # set character as factors
    across(where(is.character), as.factor),
    host_has_profile_pic = as.factor(host_has_profile_pic), 
    host_identity_verified = as.factor(host_identity_verified), 
    has_availability = as.factor(has_availability), 
    instant_bookable = as.factor(instant_bookable), 
    has_review = as.factor(has_review), 
    # max/min nights
    minimum_nights_avg_ntm = round(minimum_nights_avg_ntm),
    maximum_nights_avg_ntm = round(maximum_nights_avg_ntm),
    #leave id as factor 
    id = as.factor(id),
    # set logical as numeric 
    across(where(is.logical), as.numeric))

## View(airbnb_clean_test)

# save test ----
save(airbnb_clean_test, file = here("01_attempt/results/splits/airbnb_clean_test.rda"))

# Missingness Overview of Data ----
## all variables with missingness
airbnb_clean_train |> 
  miss_var_summary() |> 
  filter(n_miss > 0)

## variables with more than 20% missingness: host_about, host_location
### missingness too high so toss out as predictors
airbnb_clean_train |> 
  miss_var_summary() |> 
  filter(pct_miss > 20)


## variables with between 5% and 20% missingness: 
### advanced imputation in recipe
airbnb_clean_train |> 
  miss_var_summary() |> 
  filter(pct_miss > 5 & pct_miss < 20)

## variables with less than 5% missingness: 
### simple imputation in recipe
airbnb_clean_train |> 
  miss_var_summary() |> 
  filter(pct_miss > 0 & pct_miss < 5)

### missingness notes ----
# missigness to fix in recipe: 
## there are multiple variables with the same n_miss: 369 which indicates a relationship in the missingness
### and that it is not random. The variables are as follows based on their types in the unclean data
### character: host_response_time, host_response_rate, host_acceptance_rate, 
### date: host_since  
### logical: host_has_profile_pic, host_response_time, 
### numeric: host_listings_count, host_total_listings_counts 
### all of these give that not enough information about the host is avaliable so I would 
### put it as step_unkown() 

## there is another group with 1778 or 1779 n_miss which indicates not random. 
### the variables are as follows:
### character: reviews_per_month, review_scores_rating, review_scores_rating,review_scores_accuracy, 
### review_scores_cleanliness, review_scores_checking, review_scores_communication, 
### review_scores_location, review_scores_value
### date: first_review, last_review
### all of these have to do with review so I assume that missingnes might habe to do with a 
### no review for this place exists yet so I would put it as step_other(other = "no review")

# My Notes/ Scrap work -----
# view amenities
# airbnb_train |> 
#  select(amenities) |> 
#  write_csv(file = here("data/amenities.csv"))

# step_rm(description, amenities, host_about, host_since, first_review, 
# last_review, host_verifications, host_listings_count, minimum_maximum_nights, 
# maximum_maximum_nights, number_of_reviews_ltm, number_of_reviews_l30d, 
# calculated_host_listings_count_shared_rooms, calculated_host_listings_count_private_rooms, 
# calculated_host_listings_count_entire_homes)
