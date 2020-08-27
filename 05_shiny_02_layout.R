###################################################
### Dodatkowe materiały
###################################################

# http://shiny.rstudio.com/articles/layout-guide.html

library(shiny)
library(plotly)

# tym przypadku korzystamy z navbarPage(), więc u góry
# strony pojawia się menu w którym możemy wybrać albo
# 'Rozkład normalny', albo 'Rozkład beta'
ui <- navbarPage(
  # pierwszym argumentem jest tytuł menu
  'Rozkłady:',
  # kolejnymi argumentami są panele zawierające:
  # - etykietę elementu menu
  # - zawartość pokazywaną po jego uaktywnieniu
  tabPanel('Rozkład normalny:',
    sidebarLayout(
      sidebarPanel(
        h3("Wybierałka:"),
        sliderInput("norm_mean", "Ustaw średnią", -100, 100, 0, step = 0.001),
        sliderInput("norm_sd", "Ustaw odch. st.", 1, 100, 1, step = 0.001)
      ),
      mainPanel(
        h3("Wykres:"),
        plotlyOutput('norm_plot'),
        verbatimTextOutput('norm_txt')
      )
    )
  ),
  tabPanel('Rozkład beta:',
    sidebarLayout(
     sidebarPanel(
       h3("Wybierałka:"),
       sliderInput("beta_alpha", "Ustaw wartość alfa:", 0.000000001, 1000, 4, step = 0.001),
       sliderInput("beta_beta", "Ustaw wartość beta:", 0.000000001, 1000, 4, step = 0.001)
     ),
     mainPanel(
       h3("Wykres:"),
       plotlyOutput('beta_plot'),
       verbatimTextOutput('beta_txt')
     )
    )
  )
)

srv <- function(input, output){
  output$norm_txt <- renderPrint({
    paste0('Mean: ',input$norm_mean,' SD: ',input$norm_sd)
  })
  
  output$norm_plot <- renderPlotly({
    min_x = input$norm_mean - 5 * input$norm_sd
    max_x = input$norm_mean + 5 *  input$norm_sd
    x = seq(min_x, max_x, length.out = 1000)
    y = dnorm(x, input$norm_mean, input$norm_sd)
    
    plot_ly() %>%
      add_lines(x = ~x, y = ~y)
  })
  
  
  output$beta_txt <- renderPrint({
    paste0('Alfa: ',input$beta_alpha,' Beta: ',input$beta_beta)
  })
  
  output$beta_plot <- renderPlotly({
    x = seq(0, 1, length.out = 1000)
    y = dbeta(x, input$beta_alpha, input$beta_beta)
    
    plot_ly() %>%
      add_lines(x = ~x, y = ~y)
  })
}

shinyApp(ui, srv)
