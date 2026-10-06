### airbnb-price-and-superhost-prediction
Classification and regression models predicting Airbnb Superhost status and listing prices.

# Airbnb Prediction Models
This repository contains two predictive analytics projects built using Airbnb listing data from Chicago, Jersey City, and Washington, D.C. The projects focus on both classification and regression problems using machine learning, feature engineering, model tuning, and leaderboard evaluation.
 
## Overview
The objective of these projects was to develop predictive models using Airbnb host and listing characteristics.
### Project 1: Airbnb Superhost Classification
Predict whether an Airbnb host is a Superhost based on listing attributes, amenities, host information, and geographic features.
### Project 2: Airbnb Price Prediction
Predict Airbnb listing prices using property characteristics, amenities, location information, and host-related variables. Both projects were completed using R and involved iterative model development, feature engineering, missing-data handling, hyperparameter tuning, and competition-style evaluation.

# Results
## Airbnb Superhost Classification
### Goal
Predict whether an Airbnb host is a Superhost.
### Best Model
Light Gradient Boosted Tree (LightGBM)
### Performance
- Best ROC-AUC: **0.9714**
- Competition Placement: **14th Place**
- Public Leaderboard ROC-AUC: 0.9661
### Key Feature Engineering
- Amenity extraction and grouping
- Geographic distance from city center using latitude and longitude
- Missing-value imputation
- Host-level feature engineering
- Known Superhost adjustments based on repeated hosts
### Models Evaluated
- LightGBM
- Random Forest
- Boosted Trees
- Neural Networks
- KNN
- SVM
- MARS
- Logistic Regression 
### Key Insight
Tree-based models consistently outperformed non-tree models. Incorporating geographic information, structured amenity variables, and host-level information significantly improved predictive performance.
 
## Airbnb Price Prediction
### Goal
Predict Airbnb listing prices based on listing features and location information.
### Best Model
Hybrid Boosted Tree + Random Forest Framework
### Performance
- Best MAE: **105.88**
- Competition Placement: **2nd Place**
- Public Leaderboard MAE: 156.54
### Key Feature Engineering
- Property-type segmentation
- Outlier identification
- Geographic distance calculations
- Amenity extraction
- Missing-data imputation
- Bootstrap and cross-validation resampling
### Modeling Strategy
Instead of fitting a single model to all listings, properties identified as outliers were modeled separately.
**Outlier Properties**
- Boosted Tree Model
- Multiclass price-bin framework
- Bootstrap resampling
**Typical Properties**
- Random Forest Regression
- Cross-validation
- Hyperparameter tuning
Predictions from both models were combined into the final submission.
### Key Insight
Separating outlier properties from typical listings substantially improved predictive performance compared to a single-model approach. Tree-based methods consistently outperformed linear and penalized regression models throughout model development.

