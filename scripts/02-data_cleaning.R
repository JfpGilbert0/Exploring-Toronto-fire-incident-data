#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(janitor)

#### Clean data ####
raw_data <- read_csv("inputs/data/fire_incidents_data.csv", show_col_types = FALSE)

cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  mutate(
    date = as_date(tfs_alarm_time),
    hour = hour(tfs_alarm_time),
    estimated_dollar_loss = ifelse(is.na(estimated_dollar_loss), 0, estimated_dollar_loss),
    is_not_property = ifelse(is.na(business_impact), "#052c66cb", "red"),
    is_highrise = grepl("highrise", initial_cad_event_type, ignore.case = TRUE),
    is_downtown = grepl("downtown", initial_cad_event_type, ignore.case = TRUE),
    location = case_when(
      grepl("vehicle", initial_cad_event_type, ignore.case = TRUE) ~ "vehicle",
      grepl("residential", initial_cad_event_type, ignore.case = TRUE) ~ "residential",
      grepl("industrial", initial_cad_event_type, ignore.case = TRUE) ~ "commercial/industrial",
      grepl("institution", initial_cad_event_type, ignore.case = TRUE) ~ "institution",
      grepl("grass", initial_cad_event_type, ignore.case = TRUE) ~ "grass/rubbish",
      grepl("subway", initial_cad_event_type, ignore.case = TRUE) ~ "subway")
  ) |>
  filter(date > as_date("2020-01-01")) |>
  filter(is.numeric(incident_station_area)) |>
  filter(!is.na(final_incident_type)) |>
  filter(!is.na(longitude)) |>
  filter(longitude != 0) |>
  filter(number_of_responding_personnel != 0 | !is.na(number_of_responding_personnel))

#### Save cleaned data ####
write_csv(cleaned_data, "outputs/data/cleaned_fire_incident_data.csv")

#### Data subset ####
# Leaves behind all unused columns in the analysis 
long_lat <-
  select(filter(cleaned_data, !is.na(longitude)), c("longitude", "latitude", "estimated_dollar_loss"))

fire_data_subset <-
  select(cleaned_data, c( "is_not_property", "estimated_dollar_loss",
                         "ignition_source", "longitude", "latitude", "hour"))

write_csv(fire_data_subset, "outputs/data/fire_event_data.csv")
