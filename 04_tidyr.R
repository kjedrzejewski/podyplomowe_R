###################################################
### Dodatkowe materiały
###################################################

# https://tidyr.tidyverse.org
# http://r4ds.had.co.nz/tidy-data.html
# https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html
# https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf

###################################################
### Pakiet tidyr
### pivot_longer - zmienia grupę kolumn na parę kolumn klucz-wartość
### pivot_longer(dane, selekcja_kolumn, names_to = "klucz", values_to = "wartość")
###
### pivot_wider - odwrotnie niż pivot_longer
### pivot_wider(dane, names_from = 'cecha', values_from = 'wartość')
###
### separate - podział kolumny na kilka
### separate(dataset, kolumna_źródłowa, kolumny_docelowe)
###
### unite - zrobienie z kilku kolumn jednej
### unite(dataset, kolumna_docelowa, kolumna_źródłowa1, kolumna_źródłowa2, ...)
###
### są też inne funkcje w pakiecie, np. ?expand
### ... a te wymienione mają dużo większe możliwości niż pokazuję poniżej
###################################################

# install.packages("tidyverse")
library(tidyverse) # ładuje tidyr-a i wiele innych pakietów
                   # z hadleyversu

# przygotujmy sobie dataset tak samo jak w przypadku dplyra
data = mtcars %>%
  rownames_to_column('name') %>%
  as_tibble()


# zmiana grupy kolumn na pary <klucz,wartość>
# liczba wierszy rośnie, a kolumn spada
?pivot_longer

data %>%
  pivot_longer(c('vs', 'am', 'gear', 'carb'), names_to = 'cecha', values_to = 'wartość') %>%
      # to zmieni układ danych w tabeli, tj. usunie kolumny vs, am, gear, carb
      # zamiast tego wstawi wiersze zawierające wszystkie pozostałe kolumny
      # z dodatkowymi kolumnami cecha oraz wartość, które będą zawierały nazwy
      # usuniętych kolumn oraz ich wartości. Robimy to dla 4-ech wierszy, więc
      # zamiast każdego wiersza pojawią się 4
  arrange(name) %>%
  View()

data %>%
  pivot_longer(9:12, names_to = 'cecha', values_to = 'wartość') %>%
    # to samo co wyżej, ale zamiast nazw kolumn podajemy ich indeksy
  arrange(name) %>%
  View()




# operacja odwrotna do pivot_longer()
# liczba wierszy spada, a kolumn rośnie
?pivot_wider

#przygotujmy dane
data2 = data %>%
  pivot_longer(9:12, names_to = 'cecha', values_to = 'wartość')

data2 %>%
  pivot_wider(names_from = 'cecha', values_from = 'wartość') %>%
  View()




# rozdzielanie jednej kolumny na kilka
?separate

data3 = tibble(id = 1:3, imie_i_nazwisko = c("Paweł J. Nowak","Szczepan Z. Brzęczyszczykiewicz","Stanisław S. Sosna"))

data3 # jak widać zawiera tylko id, oraz jedną kolumnę tekstową

# rozdzielmy tę kolumnę na trzy
data3 %>%
  separate(imie_i_nazwisko, c("imie","inicjal","nazwisko")) # domyślnym podział jest wg. wszystkiego co nie jest literą albo cyfrą




# sklejanie 
?unite

data4 = data3 %>%
  separate(
    imie_i_nazwisko,
    c("imie","inicjal","nazwisko"),
    "[^[:alnum:].]+" # bo chcemy jednak mieć też kropkę w inicjale
  )

data4 # mamy osobno imię, inicjał oraz nazwisko

data4 %>%
  unite("dane_osobowe", imie, inicjal, nazwisko, sep = ' ')


###################################################
### Zadanie TIDYR1
###################################################

# Korzystając z funkcji z pakietu tidyr, przekształć
# tabelę stocks z postaci w której:
# - timestampy są umieszczone w kolumnach
# - indeksy są umieszczone w wierszach
# na postać w której
# - indeksy są umieszczone w kolumnach
# - timestampy są umieszczone w wierszach
# Następnie oblicz średnią wartość każdego indeksu

# podpowiedź: za pomocą "-" można wskazywać kolumny do
# pominięcia (wtedy bierze wszystkie oprócz tych z minusem)

# ładowanie tabeli stocks
load("04_tidyr_stocks.RData")




# oczekiwany wynik:

# # A tibble: 1 x 4
#   mean_cac mean_dax mean_ftse mean_smi
#      <dbl>    <dbl>     <dbl>    <dbl>
# 1    2228.    2531.     3566.    3376.


