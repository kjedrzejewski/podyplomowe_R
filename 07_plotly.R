###################################################
### Dodatkowe materiały
###################################################

# https://plot.ly/r/
# https://plot.ly/r/reference/
# http://plotly-book.cpsievert.me/index.html

###################################################
### Zacznijmy od wykresu punktowego
###################################################

# install.packages("plotly")

library(dplyr)
library(plotly)

# zacznijmy od scatterplota

# można go zbudować wywołując jedynie plot_ly() i podając:
# - z jakich danych ma skorzystać (w tym przypadku mtcars)
# - co umieścić na osiach x i y (w tym przypadku muszą to być formuły, czyli z ~)
# - jaki typ wykresu chcemy (w tym przypadku scatter z samymi znacznikami)
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")

# alternatywnie możemy skorzystać z plot_ly() tylko do przekazania danych,
# a co dokładnie ma na nim być, możemy ustawić osobną funkcją korzystaja
# z operatora pipe (%>%)
plot_ly(mtcars) %>%              # użyj danych z mtcars
  add_markers(x = ~wt, y = ~mpg) # wstaw scatterplot na wykres, biorąc wt na x, i mpg na y

plot_ly(mtcars, x = ~wt, y = ~mpg) %>% # użyj danych z mtcars, jako domyślne x weź wt, a y - mpg 
  add_markers() # wstaw scatterplot wstawiając na x i y domyślne wartości dla wykresu

plot_ly(mtcars) %>% # użyj danych z mtcars
  add_trace(x = ~wt, y = ~mpg, type = "scatter", mode = "markers") # add_markers() to tak na prawdę skrót od
                                                                   # add_trace(..., type = "scatter", mode = "markers")

# można także zrobić wykres w 3D
plot_ly(mtcars) %>%
  add_markers(x = ~wt, y = ~mpg, z = ~qsec)

plot_ly(mtcars) %>% # to samo
  add_trace(x = ~wt, y = ~mpg, z = ~qsec, type = "scatter3d", mode = "markers")



# zamiast samego scatterplota, można też zrobić wykres z kolejnymi
# punktami połączonymi linią
plot_ly(mtcars) %>% # użyj danych z mtcars
  add_trace(x = ~wt, y = ~mpg, type = "scatter", mode = "lines+markers")


# zróbbmy to trochę porządniej
m = lm(mpg~wt, data = mtcars) # dopasumy model liniowy, z którego weźmiemy linię trendu

mtcars %>%
  mutate(fitted_mpg = fitted(m)) %>%  # dodajmy kolumnę z danymi wynikającymi z modelu liniowego
  arrange(wt) %>%                     # posortujmy dane według kolumny, którą dajemy na oś x
  plot_ly() %>%                       # i wrzućmy je do wykresu
  add_trace(x = ~wt, y = ~mpg, type = "scatter", mode = "lines+markers", name = 'obserwacje') %>%
  add_trace(x = ~wt, y = ~fitted_mpg, type = "scatter", mode = "lines", name = 'trend')


# dostosujmy osie
# - dodajmy własne opisy
# - ustawmy zakres zaczynający się od zera
plot_ly(mtcars) %>%
  add_trace(x = ~wt, y = ~mpg, type = "scatter", mode = "markers") %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"), # rangemode = "tozero" -> uwzględnij zero na osi
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )


# a teraz jeszcze pomalujmy kropki na czerwono
plot_ly(mtcars) %>%
  add_trace(x = ~wt, y = ~mpg, type = "scatter", mode = "markers", color = I("red")) %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"),
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )


# a teraz pomalujmy kropki w zależności od liczby cylindrów
plot_ly(mtcars) %>%
  add_trace(
    x = ~wt, y = ~mpg,
    type = "scatter", mode = "markers",
    color = ~cyl # tym razem podajemy nie konkretny kolor, a to że ma zależeć od wartości zmiennej
                 # cyl jest liczbą, więc plotly traktuje to jako zmienną ciągłą
  ) %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"), 
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )

# no ale skoro tam jest ograniczony zbiór wartości, to byśmy
# chcieli, żeby to było traktowame jako wartość dyskretna
plot_ly(mtcars) %>%
  add_trace(
    x = ~wt, y = ~mpg,
    type = "scatter", mode = "markers",
    color = ~factor(cyl) # żeby to uzyskać możemy zmienić typ zmiennej na factor
  ) %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"),
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )

# a teraz:
# - ustawmy własny zestaw kolorów
# - ustawmy rozmiar punktów zależny od mocy samochodu
# - dodajmy własne tooltipy pojawiające się po najechaniu na punkt
mtcars %>%
  tibble::rownames_to_column('model') %>% # wrzuca nazwy wierszy jako kolumnę o podanej nazwie
  plot_ly() %>%
  add_trace(
    x = ~wt, y = ~mpg,
    type = "scatter", mode = "markers",
    color = ~factor(cyl),
    colors = c('red', 'gray', 'green'),      # użyjmy własnych kolorów (mogą też być w notacji #12AB34)
    size = ~hp,                              # moc pokażmy za pomocą rozmiaru kropki
    hoverinfo = 'text',                      # ustawmy, żeby pokazywany był nasz własny tooltip...
    text = ~paste0(                          # ... który podajemy w zmiennej text. Możemy do niego użyć HTML-a
      "<b>", model, "</b>",
      "\nWaga: ", round(wt*1000), " lbs",
      "\nSpalanie: ", mpg, ' mpg',
      "\nLiczba cyl.: ", cyl,
      "\nMoc: ", hp, ' km.'
    )
  ) %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"),
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )



###################################################
### Kilka innych typów wykresów
###################################################

# wykres słupkowy
mtcars %>%
  group_by(cyl = factor(cyl)) %>%               # obliczamy dane do pokazania na wykresie
  summarise(avg_mpg = mean(mpg), n = n()) %>%   # w tym przypadku średnie spalanie zależnie od liczby cylindrów
  arrange(cyl) %>%
  plot_ly() %>%
  add_bars(x = ~cyl, y = ~avg_mpg) %>%          # i dodajemy wykres słupkowy
  layout(
    xaxis = list(title = 'Liczba cylindrów'),
    yaxis = list(title = 'Średnie spalanie', rangemode = "tozero")
  )


# kilka trace'ów na jednym wykresie, do tego różnych typów
vs_stats = mtcars %>% # najpierw wyliczmy statystyki szczegółowe
  group_by(cyl, gear) %>%
  summarise(avg_mpg = mean(mpg), n = n()) %>%
  ungroup() %>%
  arrange(cyl)

mtcars %>%
  group_by(cyl) %>%
  summarise(avg_mpg = mean(mpg), n = n()) %>%
  arrange(cyl) %>%
  plot_ly() %>%
  add_bars(          # wrzucamy statystyki ogólne jako słupki
    x = ~cyl,
    y = ~avg_mpg,
    name = 'Ogólny'
  ) %>%
  add_trace(         # a wykresy zależne od poszczególnych liczb biegów jako linie 
    data = vs_stats %>% filter(gear == 3),
    x = ~cyl,
    y = ~avg_mpg,
    type = "scatter",
    mode = "lines+markers",
    name = '3 biegi'
  ) %>%
  add_trace(
    data = vs_stats %>% filter(gear == 4),
    x = ~cyl,
    y = ~avg_mpg,
    type = "scatter",
    mode = "lines+markers",
    name = '4 biegi'
  ) %>%
  add_trace(
    data = vs_stats %>% filter(gear == 5),
    x = ~cyl,
    y = ~avg_mpg,
    type = "scatter",
    mode = "lines+markers",
    name = '5 biegów'
  ) %>%
  layout(
    xaxis = list(title = 'Liczba cylindrów'),
    yaxis = list(title = 'Średnie spalanie [mile / galon]', rangemode = "tozero")
  )


# możemy też np. zrobić boxplot
plot_ly(mtcars) %>%
  add_boxplot(x = ~cyl, y = ~mpg) %>%
  layout(
    xaxis = list(title = 'Liczba cylindrów'),
    yaxis = list(title = 'Spalanie', rangemode = "tozero")
  )







# jeszcze raz punktowy, ale na podstawie danych geograficznych
plot_ly(quakes) %>% 
  add_markers(x = ~long, y = ~lat) %>%
  layout(
    title = 'Liczba trzęsień ziemi',
    xaxis = list(title = 'Długość geograficzna'),
    yaxis = list(title = 'Szerokość geograficzna')
  )

# albo możemy to wrzucić np. heatmapę
plot_ly(quakes) %>% 
  add_heatmap(x = ~long, y = ~lat, z = ~mag) %>%
  layout(
    title = 'Liczba trzęsień ziemi',
    xaxis = list(title = 'Długość geograficzna'),
    yaxis = list(title = 'Szerokość geograficzna')
  )

# no ale to trochę kiepsko wygląda. Lepszy jest histogram 2D
plot_ly(quakes) %>% 
  add_histogram2dcontour(x = ~long, y = ~lat) %>%
  layout(
    title = 'Liczba trzęsień ziemi',
    xaxis = list(title = 'Długość geograficzna'),
    yaxis = list(title = 'Szerokość geograficzna')
  )



# możemy też wrzucić te punkty na mapę. Inaczej to nawet bez sensu trochę ;)
# UWAGA: ten wykres można przesuwać, jak i oddalać i przyblizać
fiji_loc = quakes %>%
  summarise(
    lat_min = min(lat),
    lat_avg = mean(lat),
    lat_max = max(lat),
    long_min = min(long),
    long_avg = mean(long),
    long_max = max(long)
  )

plot_geo(quakes) %>% # zaczynamy wykresy "mapowy"
  add_markers( # wrzucamy punkty z danych
    x = ~long, y = ~lat,
    size = ~mag^2, # aby różnice były wyraźniejsze
    color = ~depth,
    text = ~paste0(
      "Siła.: ", mag,
      "\nGłębokość: ", depth
    )
  ) %>%
  colorbar(title = "Głębokość") %>% # opis legendy
  layout(
    geo = list( # wybieramy rodzaj mapy, ustawienie i powiększenie
      projection = list(
        type = 'orthographic',
        rotation = list(
          lon = fiji_loc$long_avg,
          lat = fiji_loc$lat_avg
        ),
        scale = 3
      )
    )
  )


###################################################
### Zapisywanie do pliku:
### - jako plik statyczny:
###   plotly::orca(...)
### - jako obiekt interaktywny
###   htmlwidgets::saveWidget()
###################################################

# Aby zapisywanie do plików działało w systemie musi być zainstalowana orca
# https://github.com/plotly/orca#installation

p = plot_ly(mtcars) %>%
  add_trace(
    x = ~wt, y = ~mpg,
    type = "scatter", mode = "markers",
    color = ~factor(cyl) # cyl jest liczbą, więc traktuje jako zmienną ciągłą
  ) %>%
  layout(
    xaxis = list(title = 'Waga [1000 lbs]', rangemode = "tozero"), 
    yaxis = list(title = 'Mile / galon', rangemode = "tozero")
  )

orca(p = p, file = 'wykres.png') # zapis do pliku
orca(p = p, file = 'wykres.png', width = 800, height = 600) # oczekiwany rozmiar obrazu można określić
orca(p = p, file = 'wykres2.png', width = 1600, height = 1200) # jak zmieniamy rozmiar, poszczególne elementy wykresu zmieniają swój względny rozmiar
orca(p = p, file = 'wykres3.png', width = 800, height = 600, scale = 2) # jak chcemy jedynie podnieść szczegółowość obrazu, można użyć scale
orca(p = p, file = 'wykres3.pdf', width = 800, height = 600) # można też zapisać do pdf
orca(p = p, file = 'wykres3.jpeg', width = 800, height = 600, scale = 2) # i jpeg
htmlwidgets::saveWidget(p, 'wykres.html') # jako plik html, który po otwarciu w przeglądarce zawiera interkatywną stronę

###################################################
### Zadanie PLOTLY1
###################################################

# Zrób wykres punktowy (scatterplot) pokazujący 
# zależność między Sepal.Length a Sepal.Width
# we wbudowanym datasecie iris. Każdemu punktowi
# nadaj kolor zależny od gatunku osobnika, a rozmiar
# zależny od iloczynu Petal.Length i Petal.Width (czyli
# proporcjonalnie do powierzchni).
# Następnie zapisz uzyskany wykres.

# wynikowy wykres powinien wyglądać tak jak w
# pliku 07_plotly_zad1.html

?iris





