Untitled
================

**Go back to the [main
:leftwards\_arrow\_with\_hook:](https://github.com/ricardohuapaya/Portafolio/blob/main/README.md)**

**Check the code:**

  - [:arrow\_forward:
    Exploratory.R](https://github.com/ricardohuapaya/Portafolio/blob/main/Projects/chipotl_locations/exploratory_analysis.R)

## Objetive

Since this is a guided project the main objective is to understand each
line of code and comprehend how will it work under future projects.
Thanks to DataCamp we have access to our input file `chipotle.csv` which
contains all data regarding open and close chipotle around the world,
for this case we’ll be focusing on the state of South Dakota.

``` r
chipotle <- read_csv("datasets/chipotle.csv")
```

    ## 
    ## ── Column specification ────────────────────────────────────────────────────────
    ## cols(
    ##   id = col_double(),
    ##   street = col_character(),
    ##   city = col_character(),
    ##   st = col_character(),
    ##   ctry = col_character(),
    ##   lat = col_double(),
    ##   lon = col_double(),
    ##   closed = col_logical()
    ## )

``` r
closed_chipotle <- 
  chipotle %>%
  filter(closed == TRUE)
```

## Including Plots

You can also embed plots, for example:

![](hello_files/figure-gfm/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
