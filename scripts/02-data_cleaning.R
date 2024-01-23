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

#### Clean data ####
raw_data <- read_csv("inputs/data/fire_incidents_data.csv")

cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  mutate(
    estimated_dollar_loss = ifelse(is.na(estimated_dollar_loss), 0, estimated_dollar_loss),
    ignition_source = ifelse(is.na(ignition_source), "other", ignition_source),
    is_highrise = as.numeric(grepl("highrise", initial_cad_event_type, ignore.case = TRUE)),
    is_downtown = as.numeric(grepl("downtown", initial_cad_event_type, ignore.case = TRUE)),
    location = case_when(
      grepl("vehicle", initial_cad_event_type, ignore.case = TRUE) ~ "vehicle",
      grepl("residential", initial_cad_event_type, ignore.case = TRUE) ~ "residential",
      grepl("industrial", initial_cad_event_type, ignore.case = TRUE) ~ "commercial/industrial",
      grepl("institution", initial_cad_event_type, ignore.case = TRUE) ~ "institution",
      grepl("grass", initial_cad_event_type, ignore.case = TRUE) ~ "grass/rubbish",
      grepl("subway", initial_cad_event_type, ignore.case = TRUE) ~ "subway",
      TRUE ~ "other"),
    ignition_source = case_match(ignition_source,
      "11 - Stove, Range-top burner" ~ "Stove",
      "71 - Smoker's Articles (eg. cigarettes, cigars, pipes already ignited" ~ "Smoker' Article",
      "55 - Candle" ~ "Candle",
      "77 - Matches or Lighters (unable to distinguish)" ~ "Matches",
      "19 - Other Cooking Items (eg Toaster, Kettle, elec frying pan)" ~ "Cooking item",
      "43 - Clothes Dryer" ~ "Dryer",
      "79 - Other Open Flame Tools/Smokers' Articles" ~ "Open Flame"
    )
  ) |>
  filter(is.numeric(incident_station_area)) |>
  filter(!is.na(final_incident_type))

#### Save cleaned data ####
write_csv(cleaned_data, "outputs/data/cleaned_fire_incident_data.csv")

#### Data subset ####
# Leaves behind all unused columns in the analysis 
clean_subset  <-
  select(cleaned_data, c("x_id", "area_of_origin", "incident_station_area", "civilian_casualties",
                         "estimated_dollar_loss", "extent_of_fire", "ignition_source", "final_incident_type",
                         "initial_cad_event_type", "method_of_fire_control", "tfs_alarm_time", "tfs_arrival_time"))

fire_location_cost <-
  select(cleaned_data, c("location", "is_highrise", "is_downtown", "estimated_dollar_loss", "ignition_source"))

write_csv(fire_location_cost, "outputs/data/fire_event_data.csv")
