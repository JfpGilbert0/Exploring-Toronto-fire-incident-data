#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(dplyr)
library(cancensus)

#### Download data ####
fire_incidents <-
  list_package_resources("64a26694-01dc-4ec3-aa87-ad8509604f50") |>
  filter(name == "Fire Incidents Data.csv") |>
  get_resource()

#### Save data ####
write_csv(fire_incidents, "inputs/data/fire_incidents_data.csv")
