#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(ggplot2)
library(dplyr)
library(sf)
library(opendatatoronto)

#### get data #####

fire_event_data <- read_csv("outputs/data/fire_event_data.csv", show_col_types = FALSE)

#### Create fire stations map ####

toronto <- list_package_resources("neighbourhoods") |>
  filter(name == "Neighbourhoods - historical 140 - 4326.zip") |>
  get_resource()

fire_stations <-
  list_package_resources("a6ce5495-8e2b-421a-ab11-964569416f31") |>
  filter(name == "fire-station-locations - 4326.zip") |>
  get_resource()

fire_cost <-
  filter(fire_event_data, estimated_dollar_loss != 0)

sf_data <-
  st_as_sf(fire_cost, coords =  c("longitude", "latitude"), crs = 4326)


### Geographic  cost ###

map <- ggplot() +
  geom_sf(data = toronto, fill = "white", show.legend = TRUE) +
  geom_sf(data = fire_stations, color = "darkgreen", size = 0.5, alpha = 3, show.legend = TRUE) +
  geom_sf(data = sf_data, aes(color = fire_cost$is_not_property), alpha = 0.2,
          size = pmin(0.7*fire_cost$estimated_dollar_loss / mean(fire_cost$estimated_dollar_loss),2),
          show.legend = TRUE) +
  labs(
    x = "latitude",
    y = "longitude"
  ) +
  theme_minimal() +
  scale_color_manual(
    name = "Buildings",
    values = c("#052c66cb", "red"),
    labels = c("#052c66cb" = "Not a Building", "red" = "Building affected")
  ) +

  theme(
    axis.title = element_text(size = 4),
    axis.text.x = element_text(size = 3),
    axis.text.y = element_text(size = 3),
    legend.position = "right",
    legend.text = element_text(size = 6),
    legend.title = element_text(size = 8),
    legend.key.height = unit(0.5, "cm"),
    legend.key.width = unit(0.5, "cm"))

### estimated cost by location use ###

histo_cost <-
  ggplot(fire_event_data, aes(x = pmin(estimated_dollar_loss, 10000), fill = is_not_property)) +
  geom_histogram(bins = 10, position = "identity", alpha = 0.6) +
  scale_fill_manual(
    values = c("#052c66cb", "red"),
    name = "fire location",
    labels = c("outside", "Building affected")
  ) +
  theme_classic() +
  labs(
    x = "Estimated Dollar Loss",
    y = "Frequency"
  )

print(histo_cost)


### incidents by hour ###

hour_histo <- ggplot(fire_event_data, aes(x = hour)) +
  geom_histogram(binwidth = 1, fill = "#052c66cb", color = "black", alpha = 0.7) +
  labs(title = "Fire Incidents by Hour of Day",
       x = "Hour of Day",
       y = "Count") +
  theme_classic()

# Print the histogram
print(hour_histo)

### ignition sources ###

top_ignition_values <- fire_event_data %>%
  count(ignition_source, sort = TRUE) %>%
  slice_head(n = 10) %>%
  pull(ignition_source)

subset_data <- select(filter(fire_event_data, !is.na(ignition_source)), c("ignition_source", "estimated_dollar_loss")) %>%
  filter(ignition_source %in% top_ignition_values)

top_ignition_sources <- subset_data %>%
  group_by(ignition_source) %>%
  summarise(count = n()) %>%
  sort(count)

pie_chart <- ggplot(top_ignition_sources, aes(x = "", y = count, fill = ignition_source , label = ignition_source)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "Pie Chart of Ignition Sources") +
  theme_minimal()

print(pie_chart)
