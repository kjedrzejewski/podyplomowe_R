# Zrób dashboard podobny do tego: https://kjedrzejewski.shinyapps.io/podyplomowe2/
# - Filtrowanie po kolorze włosów (jeżeli wybrano kilka kolorów, pokazanie wszystkich bohaterów którzy mają przynajmniej jeden z nich)
# - Filtrowanie po gatunku (jeżeli wybrano kilka gatunków, pokazanie wszystkich bohaterów którzy mają przynajmniej jeden z nich)
# - Scatterplot:
#   - X - wzrost
#   - Y - rodzinna planeta
#   - kolor - płeć (zwróćcie uwagę jakie płcie są wymieniane w przykładzie, jest kilka przypadków, które płci nie ma, ale też są na wykresie)
#   - domyślnym trybem jest zaznaczanie
# - Domyślnie tabelka pod wykresem pokazuje wszystkich bohaterów
#   - ale po zaznaczeniu punktów na scatterplocie, ta tabela zostaje ograniczona tylko do wierszy odpowiadających tym punktom
#   - w tabeli na raz można zaznaczyć tylko jeden wiersz
# - Po kliknięciu wiersza w tabelce, na panelu bocznym, pod wyszukiwarkami, pojawiają się szczegółowe informacje o danym bohaterze
# - Dane o bohaterach Gwiezdnym Wojen możesz wziąć z datasetu starwars z pakietu dplyr (?starwars)

library(dplyr)

# uzupełnijmy trochę brakujących informacji
starwars_data = starwars %>%
  mutate(
    height = case_when(
      name == 'Finn' ~ as.integer(178),
      name == 'Rey' ~ as.integer(170),
      name == 'Poe Dameron' ~ as.integer(172),
      name == 'BB8' ~ as.integer(67),
      name == 'Captain Phasma' ~ as.integer(200),
      TRUE ~ height
    ),
    mass = case_when(
      name == 'Finn' ~ 73,
      name == 'Rey' ~ 54,
      name == 'Poe Dameron' ~ 80,
      name == 'BB8' ~ 18,
      name == 'Captain Phasma' ~ 76,
      TRUE ~ mass
    )
  )

