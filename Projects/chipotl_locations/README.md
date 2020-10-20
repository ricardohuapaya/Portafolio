# Where should you open a new Chipotle Store?

**Go back to the [main :leftwards_arrow_with_hook: ](https://github.com/ricardohuapaya/Portafolio/blob/main/README.md)** 

**Check the code:**

- [:arrow_forward: Exploratory.R ](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/exploratory_analysis.R)

## Objective
Since this is a guided project the main objective is to understand each line of code and comprehend how will it work under future projects. Thanks to DataCamp we have access to our input file `chipotle.csv` which contains all data regarding open and close chipotle around the world, for this case we'll be focusing on the state of South Dakota.

## Data Clean
For this specific project there not much data cleaning to do, after all we are going to be focusing on the open chipotles, for this reason we are only going to filter this variables.

```R
chipotle_open <-
  chipotle %>% 
  filter(closed == FALSE) %>% 
  select(-closed)
```

Now that we have filtered the data to only open chipotles, we can create a heat-map in order to give us a glimpse on the possible solutions that come next. 

## Data Vizualization