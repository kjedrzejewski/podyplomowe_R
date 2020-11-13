###################################################
### Dodatkowe materiały
###################################################
#
# https://plotly-r.com/linking-views-with-shiny.html
# 
# ?event_data
#

# Tym razem dashboard zawiera informacje o klejnotach
# - pozwala wybrać rodzaje cięć które chcemy widzieć na wykresach
# - na wykresie punktowym pokazywany jest losowy podzbiór
#   diamentów spełniających wybrane kryteria (klikając przycisk
#   można przelosować podzbiór)
# - na tym wykresie można zaznaczyć podzbiór punktów
# - wykres słupkowy poiżej pokazuje rozkład barw klejnotów
#   zaznaczonych na wykresie (albo wszystkich z wykresu,
#   jeżeli nic nie jest zaznaczone)
# - po najechaniu na słupek mozna zobaczyć ile diamentów
#   o poszczególnych jakościach cięcia składa się na ten
#   słupem
# - dodatkowo interaktywne tabelka pod wykresami pokazuje
#   szczegóły o wszystkich zaznczonych diamentach


library(shiny)
library(plotly)
library(DT)
library(dplyr)

# dane z których będziemy korzystać
# do standardowego zbioru diamonds, dodajemy
# kolumnę z unikalnym id każdego wiersza (będzie
# ona potrzebne do obsługi zdarzenia zaznaczania)
diamonds2 = diamonds %>%
  tibble::rownames_to_column(var = 'id')

# lista jakości cięć
diamond_cuts = levels(diamonds$cut)

# jak zwykle tworzymy frontend
ui <- fluidPage(
  titlePanel('Przeglądarka diamentów:'),
  sidebarLayout(
    # w panelu bocznym dajemy:
    # - grupę checkboxów do wyboru jakości cięć
    # - przycisk do przelosowania wyboru podzbioru obserwacji
    # - tabelkę z liczbami cięć każdego typu (pojawiającą się po najechaniu na słupek)
    sidebarPanel(
      h3("Wybierałka:"),
      checkboxGroupInput('cut', "Wybierz jakość cięcia:", diamond_cuts, selected = diamond_cuts),
      hr(),
      actionButton('reroll', "Wylosuj ponownie"),
      hr(),
      tableOutput('bar_cuts')
    ),
    # w panelu głównym:
    # - wykres punktowy
    # - wykres słupkowy pokazujacy podzbiór
    # - interaktywną tabelkę ze szczegółami zaznaczonych punktów
    mainPanel(
      h3("Wykres:"),
      plotlyOutput('plot_scatter'),
      plotlyOutput('plot_bar'),
      dataTableOutput('dt')
    )
  )
)

# oraz jak zawsze backend
srv <- function(input, output){
  
  # tutaj tworzymy reactive zawierający wiersze, które
  # odpowiadają obecnie wybranym jakościom cięć
  # później przy tworzeniu wykresów odwołujemy się tylko do niego
  diamonds_data = reactive({
    input$reroll # nic więcej z tym nie robimy,
                 # kliknięcie w przycisk zmienia tę wartość,
                 # więc to wyrażenie musi być ponownie przeliczone
                 # zawsze po kliknięciu
    
    # a tutaj właściwa logika, czyli wybranie wierszy
    # odpowiadających zaznaczonym jakościom cięć
    diamonds2 %>%
      filter(cut %in% input$cut) %>%
      sample_n(., min(3000, nrow(.))) # dodatkowo losujemy podzbiór max 3000 wierszy
                                      # żeby zbytnio nie muliło
  })
  
  # tworzymy wykres punktowy popkazujący dane z diamonds_data
  output$plot_scatter = renderPlotly({
    plot_ly(
      diamonds_data(),
      source = 'scatter' # nazwa pod jaką będziemy widzieć
                         # eventy związane z tym wykresem
    ) %>%
      add_markers(
        x = ~carat,
        y = ~price,
        color = ~depth,
        key = ~id # ustawiamy sobie wartość po której rozróżnimy co zostało zaznaczone
      ) %>%
      layout(dragmode =  "select") # czyli 'rysowanie prostokątów' myszką na wykresie
                                   # będzie zaznaczać, a nie powiększaćs
  })
  
  # a teraz tworzymy reactive'a, który zawiera
  # wiersze odpowiadające punktom zaznaczonym na wykresie
  selected_data = reactive({
    sel_data = NULL
    # odczytujemy co zostało zaznaczone na wykresie
    # w source podajemy wartość którą ustawiliśmy w scatterplocie,
    # czyli w tym przypadku 'scatter'
    # jeżeli nic nie jest zaznaczone, ta funkcja zwraca NULL
    ed = event_data("plotly_selected", source = "scatter") # plotly_selected - zostało zaznaczone na wykresie
    
    if(!is.null(ed)){ # jeżeli coś jest zaznaczone na wykresie, to...
      sel_data = diamonds_data() %>% # tutaj wybieramy te wiersze, których $id
        filter(id %in% ed$key)       # są wymienione jako $key w zdarzeniu
                                     # (tworząc wykres ustawiliśmy, aby key zawierało
                                     # wartości z id)
    } else { # a jeżeli nic nie jest zaznaczone, to...s
      sel_data = diamonds_data()
    }
    
    sel_data
  })
  
  # dane z reactive'a utworzonego powyżej
  # (selected_data) wrzucamy do tabelki na dole
  output$dt = renderDataTable({
    selected_data()
  })
  
  # a tutaj przeliczamy dane do wykresu słupkowego,
  # też w oparciu o zawartość selected_data, czyli o dane
  # obecnie zaznaczone na wykresie
  barplot_data = reactive({
    selected_data() %>%
      group_by(color) %>%
      summarise(
        n = n(),
        mean_carat = mean(carat),
        cuts = list(cut),         # w cuts zapamiętujemy jakie sekwencję wartości jaka
                                  # wystąpiła w cut w każdej grupie (wg. color)
        mean_price = mean(price)
      ) %>%
      arrange(color)
  })
  
  # robimy wykres słupkowy i przekazujemy do frontendu
  output$plot_bar = renderPlotly({
    plot_ly(
      barplot_data(),
      source = 'bar' # nazwa pod jaką będziemy widzieć
                     # eventy nadchodzące z tego wykresu
    ) %>%
      add_bars(
        x = ~color,
        y = ~n,
        key = ~color # ustawiamy sobie wartość po której rozróżnimy co zostało
                     # zaznaczone, w tym przypadku odcień
      )
  })
  
  # wyciągamy dane odpowiadające słupkowi
  # nad którym obecnie jest kursor
  bar_data = reactive({
    bar_data = NULL
    # odczytujemy nad czym jest kursor na wykresie słupkowym
    # w source podajemy wartość którą ustawiliśmy w barplocie
    # tworzonym powyżej, czyli w tym przypadku 'bar'
    # jeżeli kurson nie jest nad żadnym słupkiem, ta funkcja zwraca NULL
    ed = event_data("plotly_hover", source = "bar") # plotly_hover - kursor znajduje się nad elementem
    
    if(!is.null(ed)){                # jeżeli coś mysz jest nad którymś słupkie, to
      bar_data = barplot_data() %>%  # wyciągamy odpowiadający jemu wiersz z barplot_data
        filter(color %in% ed$key)
    }                                # a jeżeli nie, to pozostaje NULL ustawiony na początku tej funkcji
    
    bar_data
  })
  
  # robimy tabelkę zawierającą liczbę diamentów
  # o danej jakości cięcia, w danych odpowiadających
  # słupkowi nad którym jest myszka
  output$bar_cuts = renderTable({
    d = bar_data()
    
    if(!is.null(d)){
      tibble(cut = d$cuts[[1]]) %>%
        group_by(cut) %>%
        summarise(n = n())
    }
  })
}

###################################################
### Zadanie SHINY3
###################################################

# - Usuń widget z tabelą
# - Zamiast tabelki pojawiającej się po najechaniu
#   na słupek, wstaw pod barplotem, drugiego barplota
#   który pojawi się po kliknięciu na słupek na tym
#   pierwszym i zwizualizuje dane z tej tabelki,
#   pokazując ile jest jest diamentów o każdej
#   z jakości cięcia


shinyApp(ui, srv)