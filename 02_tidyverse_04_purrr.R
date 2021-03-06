###################################################
### Dodatkowe materiały
###################################################

# https://purrr.tidyverse.org
# http://r4ds.had.co.nz/iteration.html#the-map-functions
# https://github.com/rstudio/cheatsheets/raw/master/purrr.pdf
# https://jennybc.github.io/purrr-tutorial/index.html

# https://davisvaughan.github.io/furrr/

###################################################
### Do czego to się przyda?
###################################################

# - Wykorzystanie koncepcji obliczeń map-reduce
# - Efektywne przetwarzanie danych w sposób
#   iteracyjny

###################################################
# purrr - pakiet pozwalający wydajnie wykonywać 
# efektywnie na każdym elemencie wektora lub listy
# .. albo nawet i kilku list naraz
# i są to funkcje lepsze niż: apply, lapply, itp.
###################################################

# załadujmy pakiet purrr (razem z resztą tidyverse)
library(tidyverse)

# oraz pakiet z którego weżmiemy dataset
library(repurrrsive)

?got_chars # dataset którego będziemy używać (lista list)
View(got_chars)
# jest to lista zawierając jako elementy listy
# z informacjami o bohaterach z Gry o tron

###################################################
### map - iteracja po liście lub wektorze i
###       wykonanie podanej operacji dla
###       każdego elementu
### map(lista, funkcja, dodatkowe_parametry...)
###################################################

?map

# rzućmy okiem na najprostszy przypadek: liczenie
# wartości pierwiastka z każdego elementu wektora 1:10
map(1:10, sqrt)
# oczywiście takie użycie funckji map() nie ma sensu,
# skoro funkcja sqrt() może przyjmować na wejście
# wektor do spierwiastkowania

# więc zróbmy coś sensowniejszego:
# wyciągnijmy same imiona bohaterów (element każdej składowej listy o nazwie 'name')
map(got_chars, 'name')

# oczywiście możemy także skorzystać z %>%
got_chars %>%
  map('name')

# tak naprawdę, to drugi parametr będący tekstem jest przekształcany na prostą
# funkcję która z każdego elementu listy wyciąga jej element o podanej nazwie
got_chars %>%
  map(function(x){ x$name }) # funkcja z jednym parametrem


# możemy także wyciągnąć imiona z wykorzystaniem formuł 
got_chars %>%
  map(~.x$name) # .x - element listy wejściowej na którym akurat działamy

?'~'
?formula # więcej o formułach, an teraz wystarczy wiedzieć, że
         # formuły pozwalają na przechowywania kodu, który ma być wykonany


# wyciągnijmy sobie tylko konkretny podzbiór elementów tych list
got_chars %>%
  map(~.x[c('name', 'gender')]) %>% # wyciągamy imię i płeć
  View()
# jak widać wynikowa lista zawiera tylko pola 'name' i 'gender'


###################################################
### No dobra, ale zróbmy z tym coś ciekawszego
###################################################

# zróbmy funkcję która poskleja krótkie zdania o postaciach
got_sentence_paste <- function(x){
  paste0(
    x$name, ' is a ', tolower(x$gender), ' member of ', x$allegiances, '. ',
    ifelse(x$gender == 'Male', 'He', 'She'), ' was born ', x$born
  )
}

# i teraz wykonajmy tę funkcję na każdym elemencie listy
got_chars %>%
  map(got_sentence_paste)




###################################################
### funkcje map_[typ](), np. map_chr()
###################################################

?map_chr

# policzmy liczbę sezonów w której każda postać się pojawiła
got_chars %>%
  map(~length(.x$tvSeries))
# no tak, ale wynik jest listą..

# ... jeżeli chcemy mieć je jako wektor, to możemy scastować ...
got_chars %>%
  map(~length(.x$tvSeries)) %>%
  as.integer()


# ... albo skorzystać z map_int(), które zmieni listę
# integerów automatycznie na wektor integerów. Dodatkowo
# sprawdzi, czy typ wartości zwracanych to integer,
# albo typ na integera przekształcalny
got_chars %>%
  map_int(~length(.x$tvSeries))


# no ale może chcemy mieć kilka kolumn w wyniku, np.
got_chars %>%
  map(function(x){
    list(
      name = x$name,
      seasons = length(x$tvSeries),
      is_male = x$gender == 'Male'
    )
  })

# wtedy warto użyć konwersji na tibble
got_chars %>%
  map_df(function(x){
    list(
      name = x$name,
      seasons = length(x$tvSeries),
      is_male = x$gender == 'Male'
    )
  })

# wtedy możemy np. kontynuować przetwarzanie dplyrem
# np. policzmy w ilu średnio sezonach pojawiają się
# postać zależnie czy jest mężczyzną czy kobietą

got_chars %>%
  map_df(function(x){
    list(
      name = x$name,
      seasons = length(x$tvSeries),
      is_male = x$gender == 'Male'
    )
  }) %>%
  group_by(is_male) %>%
  summarise(
    avg_season_count = mean(seasons),
    sample = n()
  )



###################################################
### walk(lista, funckja) - wywołaj funckję (albo 
###     formułę) na każdym elemencie listy. Zwróć
###     oryginalną listę
###################################################

?walk

# np. wypiszmy listę postaci których Martin jeszcze
# nie zdążył zabić (do momentu w jakim został
# utworzony dataset)
got_chars %>%
  walk(function(x){
    if(x$alive) cat(x$name, 'jeszcze żyje\n')
  }) %>%
  walk(function(x){
    if(!x$alive) cat(x$name, 'jest ofiarą G.R.R. Martina\n')
  })



###################################################
### map2(lista1, lista2, funckja) - wywołaj funckję
###     (albo formułę) na odpowiadających sobie 
###     elementach każdej listy. Zwróć otrzymane
###     wyniki
### walk2(lista1, lista2, funckja) - podobnie
###################################################

?map2

# zróbmy sobie drugą listę, która będzie oznaczać
# poziom szczęścia danej postaci
got_luck = as.list(runif(30))

# i teraz wypiszmy kto ma ile szczęscia
walk2(
  got_chars,
  got_luck,
  ~cat(.x$name, 'ma', paste0(round(100*.y),'%'), 'szczęścia\n')
)

# rozróżnijmy szczęśliwych i pechowych
# mężczyzn i kobiety
map2(
  got_chars,
  got_luck,
  ~case_when(
    .x$gender == 'Male' & .y < 0.5 ~ 'unlucky_male',
    .x$gender == 'Male' ~ 'lucky_male',
    .y < 0.5 ~ 'unlucky_female',
    TRUE ~ 'lucky_female'
  )
)

# albo zróbmy sobie tabelkę z tym i kilkoma
# innymi kolumnami
map2_dfr(
  got_chars,
  got_luck,
  ~tibble(
    name = .x$name,
    gender = .x$gender,
    luck = .y,
    luck_genger = case_when(
      .x$gender == 'Male' & .y < 0.5 ~ 'unlucky_male',
      .x$gender == 'Male' ~ 'lucky_male',
      .y < 0.5 ~ 'unlucky_female',
      TRUE ~ 'lucky_female'
    )
  )
)

# oprócz tego mapy funckje służącje do równoległego
# iterowania po więcej niż dwóch listach
?pmap
?pwalk

###################################################
### popatrzmy jeszcze jak korzystając z purrr'a
### można zrobić coś bardziej złożonego
### TAK, TO JEST PRZYKŁAD DO ZMIENIANIA
### I PATRZENIA CO SIĘ STANIE
###################################################

# zawiera nest() które pozwala podzielić tibble'a
# na podtabele
library(tidyr)

?nest
?unnest


# za pomocą nest możemy podzielić dane na kilka tabel
# zależnie od wartości wybranej kolumny albo kilku
# kolumn
iris %>%
  group_by(Species) %>%
  nest() # zagnieżdżamy wszyskie kolumny inne
                                  # niż Species


# kolumna species_sample zawiera tabele z podzbiorem
# danych odpowiadających każdemu gatunkowi
iris %>%
  group_by(Species) %>%
  nest() %>%
  pull(data) %>% # wyciąga pojedynczą kolumnę
  str() # jak widać ta kolumnę jest listą, której każdy
        # element jest data.framem


# to teraz zbadajmy zależność między
# długością a szerokością płatka
iris %>%
  group_by(Species) %>%
  nest() %>%
  mutate(
    model = map(
      data,                            # dla każdego elementu species_sample
      ~lm(                             # zbudujmy model liniowy
          Petal.Length ~ Petal.Width,  # zależnośći długości płatka od jego szerokości
          data = .x   # (.x zawiera podtabelę zawierającą dane
      )               # dotyczące danego gatunku)
    )
  ) %>%
  pull(model) # jak widać w kolumnie model są teraz modele liniowe


# to teraz jeszcze wyciągnijmy informacje z tych modeli
iris %>%
  group_by(Species) %>%
  nest() %>%
  mutate(
    model = map(
      data,
      ~lm(
        Petal.Length ~ Petal.Width,
        data = .x
      )
    ),
    r2 = map_dbl(
      model,
      ~summary(.x)$r.squared # miara mówiąca jak dobrze model jest dopasowany
    ),
    direction = map_dbl(
      model,
      ~coef(.x)['Petal.Width'] # o ile przyrasta długość, przy przyroście szerokości o jedną jednostkę
    ),
    intercept = map_dbl(
      model,
      ~coef(.x)['(Intercept)'] # teoretyczna długości przy szerokości 0
    )
  ) %>%
  select(-data, -model) # te dwie kolumny nie są już nam potrzebne



###################################################
### discard(lista, warunek) - usuwa albo ...
### keep(lista, warunek) - ... pozostawia, usuwając
###   resztę, elementy listy, które spełniają podany
###   warunek (określony jako funkcja albo formuła)
### Dokładniej rzecz biorąc te funkcje nie modyfikują
### oryginalnej listy, a jedynie zwracją nową listę
### pozbawioną albo ograniczoną do elementów 
### spełniających określony warunek
###################################################

?keep

# pozostawmy jedynie postacie, które są martwe
got_chars %>%
  keep(~.x$alive)

# a teraz usuńmy postacie, które pojawiły się w 
# (m.in.) pierwszym sezonie
got_chars %>%
  discard(~("Season 1" %in% .x$tvSeries))




###################################################
### reduce(lista, funkcja) - używa funkcji do
###   połączenia elementów listy
### Działa to mniej więcej tak, jakby iterować po
### kolejnych elementach listy, i dodawać je po 
### do wartości już zakumulowanej.
### Np. dla listy zawierającej 4 elementy numeryczne,
### agregowanej za pomocą funkcji sum zadziała tak:
### agg = sum(lista[[1]], lista[[2]])
### agg = sum(agg, lista[[3]])
### agg = sum(agg, lista[[4]])
### ... i zwróć agg
###################################################
?reduce

# zróbmy sobie funckję która będzie sumować dwie elementy
suma_dwoch <- function(a,b){
  cat("a = ",a,"; b = ",b,"\n") # wypiszmy wartości a i b aby widzieć
                                # ile wynosiły w kolejnych wywołaniach
  a + b
}

# a teraz z jej pomocą posumujmy liczby od 1 do 5
1:5 %>%
  reduce(suma_dwoch) 

# a teraz z jej pomocą posumujmy liczby od 1 do 5
1:5 %>%
  reduce(suma_dwoch, .init = 0) # przekazujemy wartość pierwszego
                                # agregatu, więc funkcja reduce()
                                # nie traktuje w ten sposób 
                                # pierwszego elementu z listy


# no ale może coś ciekawszego z tym...
# Np. zróbmy wektory z imoionami
# męskich i żeńskich bohaterów Gry o Tron
got_chars %>%
  reduce(                         # wywołujemy reduce()
    function(agg, element){       # jako argument podajemy funkcję, która na pierwszy element
                                  #   bierze zagregowane wartości, a na drugi nowy element do dodania
      agg[[element$gender]] = c(  # funkcja, do listy odpowiedniej
        agg[[element$gender]],    # do płci aktualnej postaci,
        element$name              # dopisuje do odpowiedniego wektora jej imię
      )
      agg                         # a następnie tę listę zwraca
    },
    .init = list(                 # jako, że w tym przypadku pierwszy element nie może
      Male = c(),                 # być wartością początkową, musimy ją sami zdefiniować
      Female = c()
    )
  )

# Często używa się naprzemian funckji map() i reduce(),
# aby naprzemian przekształcać poszczególne elementy list,
# i je agregować. Taka koncepcja przetwarzania danych
# jest używana nie tylko w purrr'ze, ale w wielu
# innych technologiach, np. w Hadoopie




###################################################
### Zadanie PURRR1
###################################################

# Korzystając z purrr'a i dplyr'a wyznacz dla każdej
# kultury:
# - liczbę postaci z niej pochodziących
# - odsetek postaci żyjących
# - średnią liczbą aliasów na postać  

library(purrr)
library(repurrrsive)

?got_chars


# oczekiwany wynik:

# # A tibble: 15 x 4
#   culture     sample alive_rate mean_alias_cnt
#   <chr>        <int>      <dbl>          <dbl>
# 1 ""               6      0.333           3   
# 2 Andal            1      1               7   
# 3 Asshai           1      1               5   
# 4 Dornish          2      0.5             2.5 
# 5 Free Folk        1      0               3   
# 6 Ironborn         4      1               2.25
# 7 Northmen         5      0.8             6.6 
# (..., w sumie 15 wierszy)









###################################################
### Zadanie PURRR2
###################################################

# Dataset purrr2_data zawiera jedną kolumnę tekstową
# oraz 11 kolumn numerycznych. Część z tych kolumn
# numerycznych zawiera wartości zmiennoprzecinkowe,
# a część ma zawartość całkowitoliczbową.
# (Zadanie ma podpunkty a) i b) )

purrr2_data = mtcars %>%
  tibble::rownames_to_column('car_models') %>%
  tibble::as_tibble()

# a) Korzystając z purrra zmień typ kolumn numerycznych:
#    - na typ logical, jeżeli zawierają jedynie 0 i 1
#    - na typ integer, zawierają jedynie wartości całkowite
#    Wynik zwróc jako tibble

?as.integer


# oczekiwany wynik:

# # A tibble: 32 x 12
#    car_models          mpg   cyl  disp    hp  drat    wt  qsec vs    am     gear  carb
#    <chr>             <dbl> <int> <dbl> <int> <dbl> <dbl> <dbl> <lgl> <lgl> <int> <int>
#  1 Mazda RX4          21       6  160    110  3.9   2.62  16.5 FALSE TRUE      4     4
#  2 Mazda RX4 Wag      21       6  160    110  3.9   2.88  17.0 FALSE TRUE      4     4
#  3 Datsun 710         22.8     4  108     93  3.85  2.32  18.6 TRUE  TRUE      4     1
#  4 Hornet 4 Drive     21.4     6  258    110  3.08  3.22  19.4 TRUE  FALSE     3     1
#  5 Hornet Sportabout  18.7     8  360    175  3.15  3.44  17.0 FALSE FALSE     3     2
#  6 Valiant            18.1     6  225    105  2.76  3.46  20.2 TRUE  FALSE     3     1
#  7 Duster 360         14.3     8  360    245  3.21  3.57  15.8 FALSE FALSE     3     4
#  8 Merc 240D          24.4     4  147.    62  3.69  3.19  20   TRUE  FALSE     4     2
#  9 Merc 230           22.8     4  141.    95  3.92  3.15  22.9 TRUE  FALSE     4     2
# 10 Merc 280           19.2     6  168.   123  3.92  3.44  18.3 TRUE  FALSE     4     4
# # ... with 22 more rows


#######################


# b) Korzystając z purrra zagreguj wartości z każdej
#    kolumny
#    - w przypadku kolumn liczbowych, oblicz średnią
#    - w przypadku pozostałych, zlicz wartośći nie-NA
#    Wynik zwróc jako tibble





# oczekiwany wynik:

# # A tibble: 1 x 12
#   car_models   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#        <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
# 1         32  20.1  6.19  231.  147.  3.60  3.22  17.8 0.438 0.406  3.69  2.81


