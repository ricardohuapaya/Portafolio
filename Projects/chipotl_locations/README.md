# Where should you open a new Chipotle Store?

**Go back to the [main :leftwards_arrow_with_hook: ](https://github.com/ricardohuapaya/Portafolio/blob/main/README.md)** 

**Check the code:**

- [:arrow_forward: Exploratory.R ](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/exploratory_analysis.R)

## Objective
Since this is a guided project the main objective is to understand each line of of code and comprehend how will it work under future projects. Thanks to DataCamp we have access to our input file `chipotle.csv` which contains all data regarding open and close chipotle around the world, for this case we'll be focusing on the state of South Dakota.

## Data Clean
For this specific project there not much data cleaning to do, after all we are going to be focusing on the open chipotles, for this reason we are only going to filter this variable.

```R
chipotle_open <; 
  chipotle %>% 
  filter(closed == FALSE) %>% 
  select(-closed)
```

Now that we have filtered the data to only open chipotles, we can create a heat-map in order to give us a glimpse on the possible solutions that come next. 

![HeatMap](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/Images/heatmap.png)

## Data Visualization

The insight that the heat map gives us is that there are areas where there is a larger concentration chipotles and certain places with no presence at all. As we look into our data we are going to see that the states without chipotles are: ``` "AK", "HI", "SD"```. As we said in the begging we focus are going to focus only on South Dakota. 

As we want to open a new store it is important to understand how many potencial customer we are going to have. For this will be estimating the population per city in South Dakota. In this case well be using the package ```tidycensus```, which gives uf more information regarding the population in the United States; for more info regarding this package check this [website](https://walker-data.com/tidycensus/articles/basic-usage.html).

We load the population of South Dakota using the following: 

```R
south_dakota_pop <- get_acs(geography = "county", 
                            variables = "B01003_001", 
                            state = "SD",
                            geometry = TRUE)
```

![SD](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/Images/SD%20Population.png) 

As we can see in the map there are to city that contain the majority of the population, Sioux Falls and Rapid City. We can create a data frame with two the proposed chipotles in those two cities and the locations in the neighbor states. 

```R
chipotle_market_research <- 
  chipotle_open %>% 
  filter(st %in% c("IA", "MN", "MT", "ND", "NE", "WY")) %>% 
  select(city, st, lat, lon) %>% 
  mutate(status = "open")
```

Now we can create a map with the dot as actually opened stores and the both circle representing the possible location and it's reach to 100 miles radius. 

![Market](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/Images/proposed%20map.png)