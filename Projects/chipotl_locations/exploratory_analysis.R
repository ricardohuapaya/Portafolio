#packages we will use
library(leaflet)
library(leaflet.extras)
library(tidyverse)
library(sf)
library(tidycensus) 
library(tripack)
library(ggvoronoi)
#Load data
chipotle <- read_csv("E:/Data Science/Where Would You Open a Chipotle_/datasets/chipotle.csv")

#Filter to remove the data of closed Chipotles
closed_chipotle <- 
  chipotle %>%
  filter(closed == TRUE)

head(closed_chipotle)

# Create a new tibble named chipotle_open that contains only open chipotle 
chipotle_open <-
  chipotle %>% 
  filter(closed == FALSE) %>% 
  # Drop the closed column from chipotle_open
  select(-closed)


# Pipe chipotle_open into a chain of leaflet functions
chipotle_heatmap <- 
  chipotle_open %>% 
  leaflet() %>% 
  # Use addProviderTiles to add the CartoDB provider tile 
  addProviderTiles(provider = 'CartoDB') %>%
  # Use addHeatmap with a radius of 8
  addHeatmap(radius =10)

# Print heatmap
chipotle_heatmap

# Create a new tibble called chipotles_by_state to store the results
chipotles_by_state <- 
  chipotle_open %>% 
  # Filter the data to only Chipotles in the United States
  filter(ctry== 'United States') %>% 
  # Count the number of stores in chipotle_open by st
  count(st) %>% 
  # Arrange the number of stores by state in ascending order
  arrange(n)

# Print the state counts
chipotles_by_state


# Print the state.abb vector
# .... YOUR CODE FOR TASK 6 ....

# Use the %in% operator to determine which states are in chipotles_by_state
state.abb %in% chipotles_by_state$st

# Use the %in% and ! operators to determine which states are not in chipotles_by_state
!state.abb %in% chipotles_by_state$st

# Create a states_wo_chipotles vector
states_wo_chipotles <- state.abb[!state.abb %in% chipotles_by_state$st]

# Print states with no Chipotles
states_wo_chipotles

#####South Dakota#####

#create a south dakota population archive
census_api_key("352fc39a0a06988dca1b8279f70672a37d683aff", install = TRUE)

south_dakota_pop <- get_acs(geography = "county", 
                            variables = "B01003_001", 
                            state = "SD",
                            geometry = TRUE) 
# Create color palette to color map by county population estimate
pal <- colorNumeric(palette = "viridis", domain = south_dakota_pop$estimate)

sd_pop_map <-south_dakota_pop %>%
  leaflet() %>%
  addProviderTiles("CartoDB") %>%
  # Add county boundaries with addPolygons and color by population estimate
  addPolygons(stroke = FALSE, fillOpacity = 0.7, color = ~ pal(estimate)) %>%
  # Add a legend using addLegend 
  addLegend(pal = pal, values = ~estimate, title = "Population")

# Print map of South Dakota population by county
sd_pop_map

####MARKET RESEARCH####

# Load chipotle_sd_locations.csv that contains proposed South Dakota locations  
chipotle_sd_locations <- read_csv("E:/Data Science/Where Would You Open a Chipotle_/datasets/chipotle_sd_locations.csv")

# limit chipotle store data to locations in states boardering South Dakota
chipotle_market_research <- 
  chipotle_open %>% 
  filter(st %in% c("IA", "MN", "MT", "ND", "NE", "WY")) %>% 
  select(city, st, lat, lon) %>% 
  mutate(status = "open") %>% 
  # bind the data on proposed SD locations onto the open store data
  bind_rows(chipotle_sd_locations) 

# print the market research data
chipotle_market_research

# Create a blue and red color palette to distinguish between open and proposed stores
pal <- colorFactor(palette = c("Blue", "Red"), domain = c("open", "proposed"))

names(providers)
# Map the open and proposed locations
sd_proposed_map <-
  chipotle_market_research %>% 
  leaflet() %>% 
  # Add the Stamen Toner provider tile
  addProviderTiles(provider="Stamen.Toner") %>%
  # Apply the pal color palette
  addCircles(color = ~pal(status)) %>%
  # Draw a circle with a 100 mi radius around the proposed locations
  addCircles(data = chipotle_sd_locations, radius = 100 * 1609.34, color = ~pal(status), fill = FALSE) 

# Print the map of proposed locations 
sd_proposed_map

# load the Voronoi polygon data 
polys <- readRDS("E:/Data Science/Where Would You Open a Chipotle_/datasets/polys.rds")
lvoronoi_map <- 
  polys %>%
  leaflet() %>%
  # Use the CartoDB provider tile
  addProviderTiles("CartoDB") %>%
  # Plot Voronoi polygons using addPolygons
  addPolygons(fillColor = ~pal(status), weight = 0.5, color = "black") %>%
  # Add proposed and open locations as another layer
  addCircleMarkers(data = chipotle_market_research, label = ~city, color = ~pal(status))

# Print the Voronoi map
voronoi_map

