#packages we will use
library(leaflet)
library(leaflet.extras)
library(tidyverse)
library(sf)
library(tidycensus) 
library(tripack)
library(ggvoronoi)

#Load data
chipotle <- read_csv("datasets/chipotle.csv")

#### Data Clean####
closed_chipotle <- 
  chipotle %>%
  filter(closed == TRUE)

head(closed_chipotle)

# Create a new data data frame  named chipotle_open that contains only open chipotle 
chipotle_open <-
  chipotle %>% 
  filter(closed == FALSE) %>% 
  select(-closed)

#this creates a heatmap for the open chipotles. 

chipotle_heatmap <- 
  chipotle_open %>% 
  leaflet() %>% 
  addProviderTiles(provider = 'CartoDB') %>%
  addHeatmap(radius =10)


chipotle_heatmap

#### Exploratory Analysis ####

chipotles_by_state <- 
  chipotle_open %>% 
  filter(ctry== 'United States') %>% 
  count(st) %>% 
  arrange(n)

# Print the state counts
chipotles_by_state

#which states does not a chipotle?
state.abb %in% chipotles_by_state$st
!state.abb %in% chipotles_by_state$st

# Create a states_wo_chipotles vector
states_wo_chipotles <- state.abb[!state.abb %in% chipotles_by_state$st]

# Print states with no Chipotles
states_wo_chipotles

#####South Dakota Specific case#####

#Create a south dakota population archive

census_api_key("352fc39a0a06988dca1b8279f70672a37d683aff", install = TRUE)

south_dakota_pop <- get_acs(geography = "county", 
                            variables = "B01003_001", 
                            state = "SD",
                            geometry = TRUE) 

pal <- colorNumeric(palette = "viridis", domain = south_dakota_pop$estimate)

sd_pop_map <-south_dakota_pop %>%
  leaflet() %>%
  addProviderTiles("CartoDB") %>%
  addPolygons(stroke = FALSE, fillOpacity = 0.7, color = ~ pal(estimate)) %>%
  addLegend(pal = pal, values = ~estimate, title = "Population")

# Print map of South Dakota population by county
sd_pop_map

####MARKET RESEARCH####

# Load chipotle_sd_locations.csv that contains proposed South Dakota locations  
chipotle_sd_locations <- read_csv("datasets/chipotle_sd_locations.csv")

# limit chipotle store data to locations in states boardering South Dakota
chipotle_market_research <- 
  chipotle_open %>% 
  filter(st %in% c("IA", "MN", "MT", "ND", "NE", "WY")) %>% 
  select(city, st, lat, lon) %>% 
  mutate(status = "open") %>% 

# print the market research data
chipotle_market_research


pal <- colorFactor(palette = c("Blue", "Red"), domain = c("open", "proposed"))


sd_proposed_map <-
  chipotle_market_research %>% 
  leaflet() %>% 
  addProviderTiles(provider="Stamen.Toner") %>%
  addCircles(color = ~pal(status)) %>%
  addCircles(data = chipotle_sd_locations, radius = 100 * 1609.34, color = ~pal(status), fill = FALSE) 

sd_proposed_map

