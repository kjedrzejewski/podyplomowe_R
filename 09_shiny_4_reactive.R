###################################################
### Dodatkowe materiały
###################################################

# https://shiny.rstudio.com/articles/reactivity-overview.html
# plik: 09_shiny_5_reaktywnosc.R

# install.packages('shiny')

library(shiny)
library(plotly)
library(dplyr)

# tutaj wstępnie wyciągamy listę różnych gatunków jakie mamy w zbiorze
iris_species = iris %>%
  select(Species) %>%
  distinct() %>%
  .$Species # to jest po prostu dataset_z_lewej$Species, ale jako elementu pipeline'u
  

ui <- fluidPage(
  titlePanel('Gatunki irysów:'),
  sidebarLayout(
    sidebarPanel(
      h3("Wybierałka:"),
      # tutaj wrzucamy grupę checkbox'ów, którymi użytkownik może wybrać, które gatunki mają być pokazane.
      # Ustawiamy 'selected' na iris_species[1], więc domyślnie jest zaznaczony jedynie pierwszy element
      # iris_species, a dwa pozostałe są odznaczone
      checkboxGroupInput('species', "Wybierz gatunek:", as.character(iris_species), selected = iris_species[1])
    ),
    mainPanel(
      h3("Wykres:"),
      # tym razem na dashboardzie mamy wykres...
      plotlyOutput('plot'),
      # ... pole tekstowe z wybranymi gatunkami ...
      verbatimTextOutput('txt1'),
      # ... oraz tabelkę zawierającą obserwację wybranych gatunków
      tableOutput('tabelka')
    )
  )
)


srv <- function(input, output){
  # do zmiennej 'species_data' przypisujemy wyrażenie
  # reaktywne, które zawiera podzbiór datasetu iris,
  # dotyczący gatunków obecnie wybranych w checkboxach.
  # Jest to wyrażenie reaktywne, więc automatycznie się
  # odświeża po każdej zmianie zaznaczeń checkboxów
  species_data = reactive({
    iris %>%
      filter(Species %in% input$species)
  })
  
  # pod wykresem wypisujemy listę zaznaczonych gatunków
  output$txt1 <- renderPrint({
    cat("Zawartość 'input$species' to: [", input$species, "]")
  })
  
  # w tabelce wypisujemy dane odnośnie wybranych gatunków.
  # bierzemy je z reactive'a species_data utworzonego wyżej
  output$tabelka <- renderTable({
    species_data()
  })
  
  # a tutaj tworzymy wykres. W tym przypadku także
  # korzystamy z reactive'a species_data
  output$plot <- renderPlotly({
    if(length(input$species) > 0){
      plot_ly(species_data()) %>%
        add_markers(
          x = ~Sepal.Length,
          y = ~Sepal.Width,
          color = ~factor(Species)
        )
    }
  })
}


shinyApp(ui, srv)