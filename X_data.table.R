###################################################
### Dodatkowe materiały
###################################################

# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.pdf
# https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf

###################################################
### Tworzenie instancji - tak samo jak data.frame
###################################################

# install.packages("data.table")

library(data.table)

df = data.frame(
  a = 1:100,
  b = paste0(sample(letters, 100, replace = T), sample(10:99, 100, replace = T)),
  c = rnorm(100)
)

dt = data.table(
  a = 1:100,
  b = paste0(sample(letters, 100, replace = T), sample(10:99, 100, replace = T)),
  c = rnorm(100)
)

df
dt



###################################################
### Konwersja data.frame -> data.table
### dt = data.table(df)
###################################################

library(readr)

iris_data = read_csv("iris.csv")

# konwersja na data.table

iris_data_dt = data.table(iris_data) 
typeof(iris_data_dt)
class(iris_data_dt)

?data.table


###################################################
### Selekcja wierszy
### dt[i,,]
### i - określa, które wiersze:
### -- albo wektor TRUE / FALSE
### -- albo wektor numeryczny
###################################################

iris_data_dt[species == 'setosa',]
iris_data_dt[species %in% c('setosa','virginica'),] 
iris_data_dt[1:5,]




###################################################
### Selekcja kolumny
### dt[,j,]
### j - określa:
### -- albo które kolumny:
### ---- albo nazwa kolumny
### ---- albo lista kolumn
### ------ list(kolumna1, kolumna2)
### ------ .(kolumna1, kolumna2)
### -- wartości obliczone / zsumaryzowane
### ---- albo funkcja(nazwa kolumny)
### ---- albo list(nazwa1 = funkcja1(kolumna1), nazwa2 = funkcja2(kolumna2))
###################################################

iris_data_dt[, species] # wynik jest wektorem
iris_data_dt[, list(species)] # wynik jest data.frame'm
iris_data_dt[, .(species)]
iris_data_dt[, list(sepal_length, sepal_width, species)]
iris_data_dt[, list(
  dlugosc = sepal_length, # jak chcemy inne nazwy
  szerokosc = sepal_width,
  odmiana = species
)]

#obliczenia
iris_data_dt[,ceiling(sepal_length)]
iris_data_dt[,list(
  sufit = ceiling(sepal_length),
  proporcja = sepal_length / sepal_width
)]

# agregacja, vel. sumaryzacja
iris_data_dt[, mean(sepal_length)] # pojedyncza liczba (czyli i tak wektor :) )
iris_data_dt[, list(mean = mean(sepal_length))] #data.table
iris_data_dt[, list(
  min = min(sepal_length),
  mean = mean(sepal_length),
  median = median(sepal_length),
  max = max(sepal_length)
)] #data.table

# selekcja wierszy i kolumn razem
iris_data_dt[species == 'setosa',list(sepal_length, sepal_width, proporcja = sepal_length / sepal_width)]




###################################################
### Zadanie DT1
###################################################

# Olicz średnią długość płatków (petal_length) gatunku "virginica"











###################################################
### Grupowanie
### dt[, j, by / keyby]
### j - funkcje summaryzujące pogrupowane dane
### by - grupowanie
### keyby - grupowanie + sortowanie (i założenie klucza)
###################################################

iris_data_dt[, list(mean = mean(sepal_length), median = median(sepal_length)), keyby = species] 

# oczywiście można też grupować podzbiór wierszy:
iris_data_dt[species %in% c("setosa","virginica"), list(mean = mean(sepal_length), median = median(sepal_length)), by = species]
iris_data_dt[petal_length > 4, list(mean = mean(sepal_length), median = median(sepal_length)), by = species] 




###################################################
### Klucze (indeks i sortowanie)
###################################################

setkey(iris_data_dt, sepal_length) #zakładanie klucza na jedną kolumnę
key(iris_data_dt)
iris_data_dt

setkeyv(iris_data_dt, c("sepal_length", "sepal_width")) #zakładanie klucza na kilka kolumn
key(iris_data_dt)
iris_data_dt

setkey(iris_data_dt, NULL) #zdejmowanie klucza
key(iris_data_dt)
iris_data_dt


###################################################
### Łączanie dwóch tabel
### A[B,,]
###################################################

iris_price = data.table(
  spec = c("setosa","versicolor","virginica",'x'),
  price = c(1, 2, 3, 4)
)

# klucz musi być założony na kolumny połączeniowe
setkey(iris_data_dt, species)
setkey(iris_price, spec)

# łączenie
iris_data_dt[iris_price]
iris_price[iris_data_dt]

iris_with_price = iris_data_dt[iris_price]

setkey(iris_data_dt, NULL)
setkey(iris_price, NULL)


###################################################
### Modyfikacja / dodawanie kolumn 
### dt[, kolumna := wartość, ]
###################################################

dt = data.table(
  a = 1:100,
  b = paste0(sample(letters, 100, replace = T), sample(10:99, 100, replace = T)),
  c = rnorm(100)
)
dt

dt[, d := sample(letters, 100, replace = T)] #dodaj kolumnę d zawierającą losową literę
dt

dt[, e := a/c] #dodaj kolumnę e równą a/c
dt

dt[, c("f","g") := list(sign(e), 10)] #dodaj dwie kolumny f (znak kolumny e), g (10)
dt


###################################################
### Zadanie DT2
###################################################
dt = data.table(
  id = 1:1000,
  stanowisko = sample(c(
    "prezes",
    rep("dyrektor",40),
    rep("menedzer",200),
    rep("specjalista",759)
  )),
  staz = runif(1000,1,39)
)

dt[stanowisko == "prezes", pensja := (runif(1, 20000, 30000) * log(staz+1,7))]
dt[stanowisko == "dyrektor", pensja := (runif(.SD[stanowisko == "dyrektor", .N], 15000, 22000) * log(staz+1,7))]
dt[stanowisko == "menedzer", pensja := (runif(.SD[stanowisko == "menedzer", .N], 8000, 16000) * log(staz+1,7))]
dt[stanowisko == "specjalista", pensja := (runif(.SD[stanowisko == "specjalista", .N], 5000, 14000) * log(staz+1,7))]


### Oblicz średnią pensję na danym stanowisku, grupując jednocześnie pracowników wg. liczby pełnych 10-tek liczby ich lat stażu.
### Wynik posortuj wg. nazwy stanowiska i liczby pełnych dekad stażu.




###################################################
### data.frame vs data.table - interfejs
###################################################

iris_data$sepal_length #tak samo
iris_data_dt$sepal_length
iris_data[1] #różnica
iris_data_dt[1]
iris_data[1,] #tak samo
iris_data_dt[1,]
iris_data[,1] #różnica
iris_data_dt[,1]



# różnica jest, więc:
# - jeżeli konkretna funkcja ma problemy z data.table
#   należy przekonwertować: df = data.frame(dt)
# - jeżeli sami piszemy funckję przyjmującą tabelę jako parametr
#   konwertujemy: dt = data.table(df)



###################################################
### data.frame vs data.table - benchmark
###################################################

### Dla 10 000 elementów


library(microbenchmark)

df = data.frame(
  a = 1:10000,
  b = paste0(sample(letters, 10000, replace = T), sample(10:99, 10000, replace = T)),
  c = rnorm(10000)
)

dt = data.table(
  a = 1:10000,
  b = paste0(sample(letters, 10000, replace = T), sample(10:99, 10000, replace = T)),
  c = rnorm(10000)
)



microbenchmark(df[df$b == "a10",])
# Unit: microseconds
#                expr     min       lq     mean  median       uq      max neval
# df[df$b == "a10", ] 256.934 290.433 423.1031 329.4725 413.0835 2508.396   100

microbenchmark(dt[b == "a10",])
# Unit: microseconds
#             expr     min       lq     mean  median       uq      max neval
# dt[b == "a10", ] 451.008 493.9485 556.9275 510.4085 538.351 3313.764   100




### Dla 100 000 elementów

df = data.frame(
  a = 1:100000,
  b = paste0(sample(letters, 100000, replace = T), sample(10:99, 100000, replace = T)),
  c = rnorm(100000)
)

dt = data.table(
  a = 1:100000,
  b = paste0(sample(letters, 100000, replace = T), sample(10:99, 100000, replace = T)),
  c = rnorm(100000)
)


microbenchmark(df[df$b == "a10",])
# Unit: microseconds
#                expr      min     lq     mean   median       uq      max neval
# df[df$b == "a10", ] 1902.465 2550.533 4053.732 2971.816 3444.35 44762.21   100

microbenchmark(dt[b == "a10",])
# Unit: microseconds
#             expr     min       lq    mean  median      uq      max neval
# dt[b == "a10", ] 455.326 490.506 576.4831 516.8195 558.2945 2576.464   100




microbenchmark(aggregate(df$c, list(df$b), sum))
# Unit: milliseconds
#                             expr      min       lq     mean   median       uq      max neval
# aggregate(df$c, list(df$b), sum) 140.5388 148.2672 161.6747 152.8551 182.1972 216.725   100
microbenchmark(dt[,sum(c), by = b])
# Unit: milliseconds
#                 expr      min       lq     mean   median       uq      max neval
# dt[, sum(c), by = b] 1.892816 2.083709 2.365686 2.20104 2.48681 4.608496   100


# różnice są, więc:
# - należy używać data.table (bo jest szybsze)
