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
  date = seq(as.Date("2022-01-01"), as.Date("2022-01-10"), by = "1 Month"),
  cause = sample(c("Electrical", "Kitchen", "Arson", "Unknown"), 10, replace = TRUE), # nolint: line_length_linter.
  location = sample(c("Residential", "Commercial", "Industrial"), 10, replace = TRUE), # nolint: line_length_linter.
  casualties = sample(0:5, 12, replace = TRUE),
  damage = sample(0:10000, 12, replace=TRUE) 
) <-
  simulated_fire_incidents$date <- format(fire_incidents$date, "%Y-%m")
