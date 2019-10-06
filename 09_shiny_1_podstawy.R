###################################################
### Dodatkowe materiały
###################################################

# http://shiny.rstudio.com/tutorial/
# http://shiny.rstudio.com/gallery/widget-gallery.html
# http://shiny.rstudio.com/articles/layout-guide.html


###################################################
### Odpalanie:
###  aby odpalić kliknij przycisk "Run App" w prawym
###  górnym rogu okna edytora kodu źródłowego. Tam
###  gdzie zwykle są przyciski "Run" oraz "Source'
###################################################

# ten dashboard zawiera 3 suwaków, wykres oraz
# pole tekstowe pod tym wykresem. Zmiana ustawień
# suwaków powoduje automatyczne przegenerowanie
# wykresu oraz jego parametrów podanych w polu
# tekstowym

library(shiny)
library(plotly)

# zdefiniujmy interfejs użytkownika, czyli frontend.
# Aby to zrobić musimy skorzystać z funckji tworzącej
# strony, np. fluidPage() albo navbarPage()
ui <- fluidPage(
  # wstawmy tytuł u góry dashboardu
  titlePanel('Rozkład normalny:'),
  # layouty służą do rozmieszczenia elementów w określony sposób
  # sidebarLayout() wstawia pasek boczny dwa panele, mniejszy boczny
  # do którego najczęsciej wrzuca się elementy sterujące, oraz większy
  # główny na to co chcemy pokazać
  sidebarLayout(
    # jako pierwszy argument podajemy panel boczny
    sidebarPanel(
      h3("Wybierałka:"),
      # teraz wstawiamy 3 suwaki. Mają one nazwy 'mean', 'sd' oraz
      # 'sigmas'. Korzystając z tych nazw będziemy mogli dostać się do wartości
      # w nich ustawionych
      sliderInput("mean", "Ustaw średnią", -100, 100, 0, step = 0.001),
      sliderInput("sd", "Ustaw odch. st.", 1, 100, 1, step = 0.001),
      sliderInput("sigmas", "Liczba odch. st.", 1, 10, 3, step = 0.001)
    ),
    # jako drugi argument podajemy panel główny
    mainPanel(
      h3("Wykres:"),
      # w tym miejscu wstawiamy wykres. Jest on pobierany ze
      # zmiennej 'plot' podawanej z backendu za pomocą funkcji
      # renderPlotly()
      # zwykle używa się par funkcji renderXxx() oraz xxxOutput()
      # do przekazania elementu z backendu oraz jego wstawienia
      # we frontendzie
      plotlyOutput('plot'),
      # a tutaj wstawiamy tekst, pobrany ze zmiennej tekst
      # tutaj używamy verbatimTextOutput(), ale jest też
      # zwykły textOutput()
      verbatimTextOutput('txt')
    )
  )
)

# a tutaj tworzymy część serwerować, czyli backend
# jest to po prostu funckja biorąca co najmniej dwa argumenty:
# - input, poprzez który możemy odczytywać dane z frontendu (np. z kontrolek)
# - output, poprzez który przekazujemy dane do frontendu (np. wykres do wstawienia)
srv <- function(input, output){
  # bierzemy wejście z suwaków 'mean' oraz 'sd' i na podstawie
  # tego generujemy tekst do wypisania, który wrzucamy do
  # zmiennej 'txt' przekazywanej do frontendu
  # Wynik renderXXX() jest reaktywny, dzięki czemu
  # jest automatycznie odświeżany, gdy zmieni się wartość
  # jednego z inputów. Gdybyśmy np. chcieli, aby tekst
  # zmieniał się tylko po zmianie średniej, ale nie odchylenia
  # standardowe, odwołanie do input$sd możemy wziąć w isolate(),
  # czyli normalnie jak w przypadku wyrażeń reaktywnych
  output$txt <- renderPrint({
    paste0('Mean: ',input$mean,' SD: ',input$sd)
  })
  
  
  # bierzemy wejście ze wszystkich trzech suwaków i na jego
  # podstawie generujemy wykres, który wrzucamy do zmiennej
  # 'plot'
  output$plot <- renderPlotly({
    min_x = input$mean - input$sigmas * input$sd
    max_x = input$mean + input$sigmas *  input$sd
    x = seq(min_x, max_x, length.out = 1000)
    y = dnorm(x, input$mean, input$sd)
    
    plot_ly() %>%
      add_lines(x = ~x, y = ~y)
  })
}

# odpalamy dashboard wykorzystując frontend oraz backend
# zdefiniowane powyżej
shinyApp(ui, srv)
