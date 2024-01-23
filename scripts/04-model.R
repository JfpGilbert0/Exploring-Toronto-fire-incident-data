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

#### Read data ####
fire_event_data <- read_csv("outputs/data/fire_event_data.csv")

### Model data ####

non_downtown_data <- fire_event_data %>%
  filter(is_downtown == 0)
downtown_data <- fire_event_data %>%
  filter(is_downtown == 1)

fire_event_costs <-
  select(fire_event_data, c("location", "estimated_dollar_loss")) %>%
  group_by(location) %>%
  summarise(avg_dollar_loss = mean(estimated_dollar_loss))

downtown_cost_data <-
  select(fire_event_data, c("location", "estimated_dollar_loss")) %>%
  group_by(location) %>%
  summarise(avg_dollar_loss = mean(estimated_dollar_loss))

dt_residential <-
  downtown_data %>%
  filter(location == "residential") |>
  mutate(ignition_source = ave(ignition_source, ignition_source, FUN = function(i) replace(i, length(i) < 3, "other")))

### GRAPHS ###

fire_event_count <-
  ggplot(fire_event_data, aes(location, fill = location)) +
  geom_bar() +
  labs(title = "Fire event type") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
    legend.position = "right"
  )

print(fire_event_count)

fire_event_cost_graph <-
  ggplot(fire_event_costs, aes(x = location, y = avg_dollar_loss, fill = location)) +
  geom_col() +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
    legend.position = "right"
  )

print(fire_event_cost_graph)

non_downtown_count_graph <-
  ggplot(non_downtown_data, aes(location, fill = location)) +
  geom_bar() +
  labs(title = "Fire Location frequency - Downtown",
       x = "Location") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
    legend.position = "right"
  )

downtown_count_graph <-
  ggplot(downtown_data, aes(location, fill = location)) +
  geom_bar() +
  labs(title = "Fire Location frequency - Downtown",
       x = "Location") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # Rotate x-axis labels
    legend.position = "right"  # Remove legend
  )

print(downtown_count_data)

downtown_cost_graph <-
  ggplot(downtown_cost_data, aes(x = location, y = avg_dollar_loss, fill = location)) +
  geom_col() +
  theme_minimal()


print(downtown_cost_graph)

dt_residential_cause <-
  ggplot(dt_residential, aes(x = ignition_source)) +
  geom_bar()

print(dt_residential_cause)
