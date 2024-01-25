#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Jacob Gilbert
# Date: 25 January 2024
# Contact: j.gilbert@mail.utoronto.ca
# License: MIT
# Pre-requisites: 02-data_cleaning.R



#### Workspace setup ####
library(tidyverse)


#### Test data ####

summary(fire_event_data)

na_cost <- fire_event_data |>
  filter(is.na(fire_event_data$estimated_dollar_loss))

na_ <- fire_event_data |>
  filter(-1 < hour | hour < 24 | is.na(hour))

na_longitude <- fire_event_data |>
  filter(is.na(fire_event_data$longitude)| longitude > -79 | longitude < -80)

na_latitude <- fire_event_data |>
  filter(is.na(fire_event_data$latitude)| latitude > 44 | loatitude < 43)
