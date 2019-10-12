library(plotly)
library(dplyr)
library(tidyr)
library(purrr)


# most simple apporach
mtcars %>% 
  group_by(gear) %>%
  mutate(fit = fitted(loess(qsec ~ mpg))) %>%
  plot_ly(x = ~mpg) %>%
  add_markers(y = ~qsec, color = ~factor(gear), alpha = 0.5) %>%
  add_lines(y = ~fit, color = ~factor(gear))







# a little more robust approach
d = mtcars %>%
  nest(loess_data = -gear) %>%
  mutate(
    loess_model = map( # model calculation
      loess_data,
      ~loess(qsec ~ mpg, data = .)
    ),
    loess_x = map( # smooth line X axis values calculation 
      loess_data,
      ~seq(min(.$mpg), max(.$mpg), length.out = 100)
    ),
    loess_y = map2( # smooth line Y axis values calculation
      loess_model,
      loess_x,
      ~predict(.x, .y)
    )
  ) %>%
  select(gear, loess_x, loess_y) %>%
  unnest()


plot_ly(mtcars) %>%
  add_markers(
    x = ~mpg,
    y = ~qsec,
    color = ~factor(gear),
    alpha = 0.5
  ) %>%
  add_lines(
    data = d,
    x = ~loess_x,
    y = ~loess_y,
    color = ~factor(gear)
  )

