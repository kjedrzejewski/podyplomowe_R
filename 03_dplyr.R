###################################################
### Dodatkowe materiały
###################################################

# https://dplyr.tidyverse.org
# http://r4ds.had.co.nz/relational-data.html
# https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html
# https://cran.r-project.org/web/packages/dbplyr/vignettes/dbplyr.html
# https://cran.r-project.org/web/packages/dplyr/vignettes/two-table.html
# https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf


library(dplyr)

###################################################
### Operator pipe: %>%
### przekazywanie wwartości z lewej, jako argument
### wywołania funkcji z prawej
###################################################

# Zobaczmy jak działa operator %>% 
?magrittr::`%>%`

# Typowo funkcje wywołuje się tak jak poniżej, ta np. skleja 4 stringi w jeden
paste("Krzychu","poszedł","do","sklepu")

# alternatywnie możemy użyć %>%, aby przekazać to co mamy po lewej stronie,
# na pierwsze miejsce w wywołaniu funkcji po prawej
"Krzychu" %>% paste("poszedł","do","sklepu")

# poniższe wywołania są identyczne, bo wywołania %>% można chainować
paste("Krzychu","poszedł") %>% paste("do","sklepu")
paste("Krzychu") %>% paste("poszedł") %>% paste("do") %>% paste("sklepu")

# jeżeli ma byc inna pozycja niż pierwszy argument - trzeba użyć kropki w odpowiednim miejscu
"poszedł" %>% paste("Krzychu","do","sklepu")   # tutaj wstawi 'poszedł' jako pierwszy argument
"poszedł" %>% paste("Krzychu",.,"do","sklepu") # a tutaj jako drugi


###################################################
### W ramach tej lekcji będzie pracować dużo ze
### ze zbiorem mtcars. Aby dowiedzieć się o nim
### więcej wpisz ?mtcars
###################################################

?mtcars

###################################################
### select - wybranie kolumn i usunięcie reszty
### select(dataset, kolumna1, kolumna2, ...)
###################################################
?select

# przygotowanie datasetu
data = as_tibble(mtcars) # konwersja na tibbla, ale na data.frame też by działało
                         # tibble to taki lepszy data.frame
data = bind_cols(name = row.names(mtcars), data) # dodanie nazw jako kolumny, bo tidyverse nie wspiera nazw wierszy
                                                 # ... i jest to uzasadnione

data # ostatecznie tabelka wygląda tak


# View() w przykładach czasami używam, aby wynik obliczeń się ładnie wyświetlił
# W normalnym przetwarzaniu dplyr-em wynik raczej zamiast tego się przypisuje
# do zmiennej, a nie przekazuje na View()

data %>%
  View()

# to samo co View(data), czyli wyświetlenie w tabelce na nowej karcie.
# Tak samo jak po kliknięciu na zmienną po karcie environment 

data %>%
  select(name, mpg) # wybieramy kolumny name oraz mpg
# to samo co wywołanie select(data, name, mpg)


# zamiast wymieniać kolumny, można określić wzór nazwy, np.
data %>%
  select(name, starts_with("d")) # czyli wszystkie kolumny zaczynające się na 'd' oraz kolumna name

?starts_with # są też inne wzorce nazw

# wynik przetwarzania zawsze możemy przypisać do zmiennej
data2 = data %>%
  select(name, mpg)

data2

###################################################
### arrange - sortowanie według podanych kolumn
### arrange(dataset, kolumna1, kolumna2, ...)
###################################################
?arrange

data %>%
  arrange(name) %>% # sortujemy rosnąco po kolumnie name
  View()

data %>%
  arrange(vs, mpg) %>% # sortujemy rosnąco najpierw po vs, a potem po name
  View()

data %>%
  arrange(vs, desc(mpg)) %>% #  sortujemy najpierw rosnąco po vs, a potem malejąco po name
  View()


###################################################
### filter - selekcja wierszy (sql-owy WHERE)
### filter(dataset, warunek1, warunek2, ...)
###################################################
?filter

data %>%
  filter(gear == 4) %>% # tylko wiersza mające gear == 4
  View()

data %>%
  filter(gear == 4, carb == 4) %>% # tylko wiersza mające grear == 4 oraz carb == 4
  View()


data %>%
  filter(gear == 4) %>%
  filter(carb == 4) %>%
  View() # działa tak samo jak poprzednie, ale jest wolniej niż z warunkami w jednym wywołaniu
         # filter(), bo dataset musi zostać przetworzony dwukrotnie


# prównajmy prędkość przetwarzania:
# install.packages(microbenchmark)
microbenchmark::microbenchmark(  # :: - wywołaj funckcję z pakietu bez jego ładowania
  data %>%
    filter(gear == 4, carb == 4)
)

microbenchmark::microbenchmark( # zauważalnie wolniej, a robi to samo
  data %>%
    filter(gear == 4) %>%
    filter(carb == 4)
)


# jak chcemy zrobić OR, czyli przynajmniej jeden z warunków musi być spełniony,
# a nie wszystkie
data %>%
  filter(gear == 4 | carb == 4) %>% # jak wszędzie indziej w R
  View()


###################################################
### mutate / transmute - tworzenie oraz modyfikacja kolumn
### mutate(dataset, kolumna1 = wartość1, ...)
### transmute(dataset, kolumna1 = wartość1, ...)
###################################################

# Jeżeli w mutate podamy nazwę kolumny istniejącej,
# to ją zmodyfikujemy. Jeżeli nieistniejącej, to 
# ją stworzymy

data %>%
  mutate(letter = 'x') %>% # tworzy kolumnę letter o wartości 'x' w każdym wierszu
  View()

data %>%
  mutate(kpl = 0.4251 * mpg) %>% # tworzymy kolumnę zawierającą przeliczenie mil na galon, na kilometry na litr
  View()


data %>%
  transmute(name, kpl = 0.4251 * mpg) %>% # transmute() działa podobnie jak mutate(), ale usuwa kolumny nie wymienione
  View()


### case_when(warunek1 ~ wartość1, warunek2 ~ wartość2, ...., [TRUE ~ domyślna wartość])
### odpowiednik CASE WHEN z SQLa

x = 1:100

case_when(
  x < 10 ~ '<10',     # jeżeli pierwszy warunek jest spełniony, to zwróć '<10', w innym przypadku...
  x <= 50 ~ '10-50',  # ... jeżeli drugi warunek jest spełniony, to zwróć '10-50', w innym przypadku...
  TRUE ~ '>50'        # ... zwróć '>50', no bo TRUE zawsze jest spełnione
)

data %>%
  mutate(
    mpg_range = case_when(
      mpg < 16 ~ 'low',
      mpg < 20 ~ 'mid',
      mpg >= 20 ~ 'high',
      TRUE ~ NA_character_ # to akurat nie jest potrzebne, zadziałało by tak samo i bez tego,
                           # bo w to miejsce może wejść tylko wtedy gdy w danej kolumnie jest NA
    )
  ) %>%
  View()


###################################################
### summarise - agregacja wartości
### summarise(dataset, nazwa1 = funkcja1(kolumna1), ...)
###################################################
?summarise

data %>%
  summarise(
    mean_mpg = mean(mpg), # średnia wartość mil na galon
    min_qsec = min(qsec), # najniższy czas na ćwierć mili
    count = n()  # n() - liczba wierszy w grupie
  )
# nie ma View(), więc wypisało na konsoli




###################################################
### Zadanie DPLYR1
###################################################

# Oblicz:
# - średnią wagę
# - średnie spalanie w litrach na 100 kilometrów
# dla samochodów mających co najmniej 6 cylindrów.
# Jeżeli nie wiesz w której kolumnie podana jest waga
# oraz liczba cylindrów, skorzystaj z dokumentacji
# datasetu mtcars.

?mtcars # opis kolumn 

data = mtcars %>%
  tibble::rownames_to_column('car_model') %>%
  tibble::as_tibble()




# oczekiwany wynik:

# A tibble: 1 x 2
#   mean_wt mean_lp100
#     <dbl>      <dbl>
# 1    3.71       14.7



###################################################
### group_by - grupowanie wierszy
### group_by(dataset, kolumna1, wyrażenie2 = wartość2, ...)
### ungroup(dataset_pogrupowany) - usunięcie grupowania
###################################################
?group_by

data %>%
  group_by(cyl) %>% # dodaje informację o podziale na grupy wg liczby cylindrów
  summarise(mean(wt))# wylicza średnią wartość wt w każdej grupie (bo grupy są zdefiniowane)


data %>%
  group_by(cyl) %>%
  mutate(group_wt_mean = mean(wt)) # mutate działa też po pogrupowaniu, wtedy
                                   # do każdego wiersza została dodana średnia wyliczona dla danej grupy


data %>%
  group_by(cyl, vs) %>% # tym razem grupujemy wg dwóch kolumn
  summarise(group_wt_mean = mean(wt))


data %>%
  group_by(cyl) %>%                    # ponownie ustawiamy podział na grupy, jednak tym razem nie po to aby zagregować wartości
  mutate(group_wt_mean = mean(wt)) %>% # tylko aby do każdego wiersza dopisać średnią wagę w danej grupie
  ungroup() %>%                        # a jak dataset nie jest pogrupowany
  mutate(total_wt_mean = mean(wt))     # wartość funkcji agregującej zostanie obliczona globalnie


data %>% # kolumna według której grupujemy nie musi być wcześniej wyliczona
  group_by(kpl = floor(0.4251 * mpg)) %>% # możemy ją zdefiniować w group_by
  summarise(mean(wt), n = n()) # n() to specjalna funkcja dplyr-owa do
                               # do zliczania liczby wierszy



###################################################
### do - wykonuje funkcję (która zwraca listę / data.frame)
### do(dataset, funkcja(..., ., ...))
###   . - określa gdzie idą dane
###################################################
?do

# funkcja poniżej oblicza przedziały ufności metodą bootstrap
boot_ci <- function (data, FUN, rep = 10000) {
  if(length(data) > 1){
    res <- c()
    for (i in 1:rep) {
      d2 <- sample(data, replace = T)
      r <- FUN(d2)
      res <- c(res, r)
    }
    v <- FUN(data)
    q <- quantile(res, probs = c(0.025, 0.975), na.rm = TRUE)
    return(data.frame(min = q[1], val = v, max = q[2], se = sd(res)))
  } else {
    return(data.frame(min = NA, val = data, max = NA, se = NA))
  }
}

# zobaczmy jak ona działa
# najpierw utwórzmy wektor losowych wartości z rozkładu N(0,1)
x = rnorm(1000, mean = 0, sd = 1)
# teraz obliczmy przedział ufności dla średniej
boot_ci(x, mean)

# a teraz policzmy 95%-owe przedziały ufności średniej dla wagi
# samochodów zależnie od liczby cylindrów
data %>%
  group_by(cyl) %>%
  do(boot_ci(.$wt, mean))



###################################################
### *_join - łączenie datasetów
### *_join(dataset1, dataset2, by = c(kolumny połączeniowe))
### inner_join - tylko wiersze dopasowane z obu stron
### left_join  - wiersze dopasowane z obu stron 
###   oraz wiersze z lewej, które nie zostały
###   dopasowane (uzupełnione NA)
### right_join - wiersze dopasowane z obu stron 
###   oraz wiersze z prawej, które nie zostały
###   dopasowane (uzupełnione NA)
### full_join - wiersze dopasowane z obu stron
###   oraz wiersze z prawej i lewej, które nie zostały
###   dopasowane (uzupełnione NA)
###################################################
?inner_join

# potrzebujemy drugiej tabeli
# powiedzmy, że mamy różne stawki podatkowe zależnie od liczby cylindrów
tax = tibble(
  cyl = c(4, 6, 8),
  tax = c(0.1, 0.13, 0.16)
)
tax


# teraz połączmy tę tabelę z tabelą data
data %>%
  inner_join(tax, by = "cyl") %>% # atrybut by mówi po jakich kolumnach łączymy, może być wektorem nazw - c()
  View()



# zmnieńmy trochę tabelę tax, teraz kolumna po której łączymy ma różne nazwy w każdej tabeli
tax = tibble(
  cylindry = c(4, 6, 8),  # kolumna nazywa się 'cylindry', a nie 'cyl'
  tax = c(0.1, 0.13, 0.16)
)

data %>%
  inner_join(tax, by = c("cyl" = "cylindry")) %>% # tej sytuacji musimy podać obie nazwy kolumn
                                                  # technicznie rzecz biorąc w wektorze przekazywanym w by
                                                  # 'cyl' jest nazwą elementu o treści 'cylindry'
  View()


# i ponownie zmieńmy tax, tym razem nie ma wartości dla cyl == 8
tax = tibble(
  cyl = c(4, 6),
  tax = c(0.1, 0.13)
)

data %>%
  inner_join(tax, by = "cyl") %>% # inner_join - odpowiadające sobie wiersze muszą być w obu tabelach
  View() # wiersze z cyl 8 zostały pominięte

data %>%
  left_join(tax, by = "cyl") %>% # left_join - zachowuje wszystkie wiersze z lewej tabeli, jeżeli nie ma
                                 #             odpowiadających wierszy w drugiej tabeli, to uzupełnia NA-mi
  View() # wiersze z cyl 8 zostały dodane z pustą kolumnę tax



# a teraz weźmy tabelę z liczbą cylindrów, która nie występuje w tabeli data
tax = tibble(
  cyl = c(4, 6, 10),
  tax = c(0.1, 0.13, 0.19)
)

data %>%
  full_join(tax, by = "cyl") %>% # full_join - zachowuje wszystkie wiersze z obu tabel tabeli
  View()


###################################################
### Zadanie DPLYR2
###################################################

# Do datasetu iris dodaj kolumny oznaczające
# - długość płatka (petal) osobnika jest większa średnia + odchylenie standardowe dla gatunku
# - szerokość płatka (petal) osobnika jest większa średnia + odchylenie standardowe dla gatunku
# - długość przegrody (sepal) osobnika jest większa średnia + odchylenie standardowe dla gatunku
# - szerokość przegrody (sepal) osobnika jest większa średnia + odchylenie standardowe dla gatunku
# - łączną liczbę odstawań danego osobnika (czyli ile z powyższych jest na TRUE)
# Wynik posortuj malejąco wg. łącznej liczby odstawań

?iris




# oczekiwany wynik:

# # A tibble: 6 x 10
# # Groups:   Species [2]
#   Sepal.Length Sepal.Width Petal.Length Petal.Width Species    big_sl big_sw big_pl big_pw big_cnt
#          <dbl>       <dbl>        <dbl>       <dbl> <fct>      <lgl>  <lgl>  <lgl>  <lgl>    <int>
# 1          5.4         3.9          1.7         0.4 setosa     TRUE   TRUE   TRUE   TRUE         4
# 2          5.7         4.4          1.5         0.4 setosa     TRUE   TRUE   FALSE  TRUE         3
# 3          5.4         3.9          1.3         0.4 setosa     TRUE   TRUE   FALSE  TRUE         3
# 4          6.9         3.1          4.9         1.5 versicolor TRUE   TRUE   TRUE   FALSE        3
# 5          5.9         3.2          4.8         1.8 versicolor FALSE  TRUE   TRUE   TRUE         3
# 6          6.7         3            5           1.7 versicolor TRUE   FALSE  TRUE   TRUE         3

