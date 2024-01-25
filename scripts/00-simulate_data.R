#### Preamble ####
# Purpose: Simulates what cleaned and useful data from opendatatoronto
# for fire incidents might look like
# Author: Jacob Gilbert
# Date: January 2024
# Contact: j.gilbert@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(tidyverse)
library(tibble)
library(dplyr)

#### Simulate data ####

# Simulated Fire Incident Data
simulated_fire_incidents <- tibble(
  property_type = sample(c("residential", "Business", "non-building"), 100, replace = TRUE),
  estimated_dollar_loss = runif(100, 1000, 50000),
  ignition_source = sample(c("Electrical", "Cooking", "Candles", "Other"), 100, replace = TRUE),
  longitude = rnorm(100, mean = -79.3832, sd = 0.1),
  latitude = rnorm(100, mean = 43.6532, sd = 0.1),
  hour = sample(0:23, 100, replace = TRUE)
)