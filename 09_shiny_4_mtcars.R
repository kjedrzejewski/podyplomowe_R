###################################################
### Zadanie SHINY1
###################################################

# Zrób dashboard podobny do tego: https://kjedrzejewski.shinyapps.io/podyplomowe/
# - skorzystaj ze zbioru mtcars
# - w wybierałce daj wartości liczby biegów występujące w zbiorze
# - na wykresie umieść tylko dane o samochodach mających wybraną liczbę biegów
# - na osi x umieść liczbę mil przejeżdżanych na jednym galonie paliwa
# - na osi y umieść czas potrzebny na przejechanie ćwierci mili

library(shiny)
library(plotly)
library(DT)
library(dplyr)

# Do zmiennej gears przypisz wektor z unikalnymi wartościami
# z kolumny gear datasetu mtcars
# UZUPEŁNIJ STĄD...
# gears = ...

# ... DOTĄD

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput('gears', 'Liczba biegów', gears)
    ),
    mainPanel(
      plotlyOutput('plot'),
      dataTableOutput('table')
    )
  )
)

srv <- function(input, output){
  # Do zmiennej d przypisz wyrażenie reaktywne zawierające podzbiór wierszy mtcars
  # dotyczących samochodów o liczbie biegów wybranej aktualnie w wybierałce "gears"
  # UZUPEŁNIJ STĄD...
  # d = reactive({
  #   ...
  # })
  
  # ... DOTĄD
  
  output$plot <- renderPlotly({
    # funkcja którą da się wykorzystać do wygładzania
    l = loess(
      data = d(), # dla danych w d
      qsec ~ mpg, # chcemy znaleźć zależność qsec od mpg
      span = 2 # jak bardzo chcemy wygładzić
    )
    
    # generujemy sobie 100 wartości na X (od min do max mpg)
    r = seq(
      min(d()$mpg),
      max(d()$mpg),
      length.out = 100
    )
    
    # tibble z wygładzoną linią
    # W X_plotly_loess.R jest przykład jak to policzyć
    sm = tibble(
      mpg = r, # zakres wartości
      qsec_smooth = predict(
        l, # korzystając z modelu w zmiennej l
        r  # znajdź wygładzone wartości Y, dla każdej wartości X znajdującej się w zmiennej r
      )
    )
    
    plot_ly(d()) %>%
      
      # uzupełnij add_markers() tak aby:
      # - na osi x było umieszczone spalanie
      # - na osi y był umieszczony czas na ćwierć mili
      # UZUPEŁNIJ STĄD...
      add_markers(
        
      ) %>%
      # ... DOTĄD
      
      # uzupełnij add_lines() tak aby wstawić linię trendu ze zmienej "sm"
      # zauważ, że w tym przypadku korzystasz z innych danych,
      # niż te odziedziczone z plot_ly()
      # UZUPEŁNIJ STĄD...
      add_lines(
        
      ) %>%
      # ... DOTĄD
      
      # dodaj opisy osi
      # UZUPEŁNIJ STĄD...
      layout(
        
      )
    # ... DOTĄD
  })
  
  # te same dane wyrzuć jako DT::datatable
  # UZUPEŁNIJ STĄD...
  # output$table = render_____({...})
  
  # ... DOTĄD
}

# odpal aplikację korzystając z:
# - interfejsu w zmiennej ui
# - kodu serwerowego w zmiennej srv
# UZUPEŁNIJ PONIŻEJ...
