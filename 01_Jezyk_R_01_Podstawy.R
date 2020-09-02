###################################################
### Dodatkowe materiały
###################################################

# Filmy na Yotube: https://www.youtube.com/playlist?list=PLL3-3m0jNaWlA9iLeQlZJQpoXTz3rSTer

# Prezka o zajęciach: https://bit.ly/2OepmuG

# https://www.tutorialspoint.com/r/index.htm
# http://r4ds.had.co.nz/workflow-basics.html
# http://r4ds.had.co.nz/functions.html
# http://r4ds.had.co.nz/vectors.html
# http://r4ds.had.co.nz/iteration.html (rozdziały 21.2 i 21.3)
# http://adv-r.had.co.nz

###################################################
### Do czego to się przyda?
###################################################

# Znajomość podstaw R jest konieczna aby zrobić
# cokolwiek w tym języku :)

###################################################
### Podstawy RStudio
###################################################

# Ctrl + Enter / Cmd + Enter
#     wykonuje zaznaczony blok kodu, albo linię
#     w której jest kursor, jeżeli nic nie jest
#     zaznaczone

print('Hello world!') # np. wykonanie tej linii
                      # wyświetli napis 'Hello world!'

###################################################
### Korzystanie z pomocy
### ?temat - pokaż dokumentację na temat "temat";
###          tak samo zadziała naciśnięcie F1, gdy
###          kursor jest na nazwie tematu
### ??temat - przeszukaj "temat" w dostępnej doumentacji
###################################################

?mean # wyświetli pomoc do funkcji mean(), czyli średniej
??mean # wyszuka wszystkie pomoce w których pojawia się
       # słowo 'mean'

?`?` # czyli wyświetlenie pomocy do korzystania z pomocy ;)
?`??`

###################################################
### Operatory i stałe
###################################################

# w R dostępne są typowe operatory matermatyczne

?`+` # pomoc do tematu operatorów arytmetycznych
?`!` # pomoc do tematu operatorów boolowskich

# operatory arytmetyczne
1+1 
2-1; 3-3 
2*2
2/2
5%%2 #reszta z dzielenia
5%/%2 #część całkowita
2^3; 2**3 #potęgowanie na dwa sposoby

# nieskończoności i dzielenie przez zero
1/0; Inf  #nieskończoność pozytywna
-1/0; 1/-0; -Inf  #nieskończoność negatywna
0/0 #NaN
Inf / -Inf #NaN
NaN

# porównywanie
2<3; 2<2
2<=3; 2<=2
3>2; 2>2
3>=2; 2>=2
3==2; 2==2
3!=2; 2!=2

# operacje logiczne (boolowskie)

!TRUE #negacja
TRUE&TRUE; TRUE&FALSE #logiczne AND
TRUE|TRUE; TRUE|FALSE #logiczne OR

###################################################
### Zmienne i przypisywanie wartości
###################################################

# w R można przypisywać wartość za pomocą
# trzech operatorów: '=', '<-', '->'

?`<-` # pomoc do tematu

x = 1 # ustaw wartość x na 1
x     # wypisz (a dokładniej to zewaluuj i wypisz wynik)

x <- 4 # ustaw wartość x na 4
x

5 -> x # ustaw wartość x na 5
x

x = 2 < 3 # do x przypisz wynik porównania 2 < 3
x
(x = 2 < 3)

x = y = 2 # przypisanie zwraca wartość przypisaną
x; y

Y = 3
y; Y #wielkość znaków ma znaczenie


###################################################
### Nazewnictwo zmiennych
###################################################

# nazwy zmiennych muszą zaczynać się od litery,
# dalej jednak mogą zawierać liczby oraz . i _

varname1 
var_name2
var.name3 # niezalecane, może mieć 
          # konflikty z mechanizmami R


###################################################
### Czyszczenie pamięci
###################################################

smiec = "ogryzek" # utwórzmy sobie zmienną do usuwania
skarb = "100 milionów" # oraz taką którą chcemy zachować

rm(smiec) #usuwanie zmiennej 'smiec' ()

gc() #oczyszczenie pamięci zajmowanej przez usunięte zmienne
# Jest to także wykonywane automatycznie co jakiś czas
# lub w momencie gdy brakuje pamięci

# wywołanie tej funkcji zwraca statystyki zużycia pamięci, więc
# w pratyce gc() częściej się uzywa do sprawdzania statystyk
# zużycia pamięci, niż do faktycznego jej zwalniania



###################################################
### Proste typy danych
###################################################

?typeof  # w jakim formacie dane są trzymane w pamięci
?class   # w jaki sposób dane powinny być interpretowane

#numeric - typ liczbowy, domyślnie zmiennoprzecinkowy
x = 3.14 # domyśłnie wszystkie liczby są numeric'ami
x
typeof(x) # format danych, czyli jak dane są trzymane w pamięci
class(x)  # klasa, czyli jak dane powinny być interpretowane
is.numeric(x) # sprawdza czy x jest typu numeric



#integer - typ liczbowy, zawsze całkowitoliczbowy
x = 1L # L = chcemy integera
x
typeof(x)
class(x)
is.numeric(x)   # integer jest numericiem
is.integer(x)
is.integer(1) # ale numeric nie jest integerem



#character - ciąg znaków
x = "Krzychu"
x
typeof(x)
class(x)
is.character(x)

#sklejanie / konkatenacja
x = paste0("a","b","c") # domyślnie nie wstawia separatora
x

x = paste(c("a","b","c"), 1:3, c(T, F, T)) # N:M wektor zawierajacy kolejne 
                                           # liczby naturalne od N do M
x # jak jest kilka wektorów, to sklejane są odpowiadające sobie elementy

x = paste(c("a","b","c"), 1:3, sep = "_") # zmieniamy separator z domyślnego
x

# cięcie na fragmenty
strsplit('a-b-c','-') # rozbija na fragmenty porozdzielane '-'



# logical - typ logiczny TRUE / FALSE
# można też pisać skrótowo:
# - T dla TRUE
# - F dla FALSE
x = TRUE
x
typeof(x)
class(x)
is.logical(x)

#NA
x = NA #NA w R znaczy 'nie wiem'. Podobnie jak NULL w SQL 
x
typeof(x) # domyślnie logical, ale są też NA innych typów, np. liczbowe albo tekstowe
class(x)
is.logical(x)
is.na(x)

# co oznacza to, że NA interpretujemy jako 'nie wiem'?
TRUE  & TRUE  # AND zwraca TRUE gdy wartości z obu stron są TRUE 
TRUE  & FALSE # w innym przypadku FALSE
TRUE  & NA    # w tym przypadku nie wiadomo, czy to powinno być TRUE czy FALSE
FALSE & NA    # a tutaj nigdy nie może TRUE, więc jest FALSE

FALSE | TRUE  # OR jest TRUE gdy przynajmniej jedna z wartości jest TRUE
FALSE | FALSE # więc gdy obie są FALSE, wynik to FALSE
TRUE  | NA    # tutaj już wiemy, że jest TRUE
FALSE | NA    # a tutaj wszystko zależy od prawej wartości, więc nie wiemy czy jest TRUE czy FALSE 



#factor - typ wyliczeniowy
?factor

x = factor(c("kot", "kot", "pies", "kot"))
x
typeof(x) # integer, czyli liczbowy
class(x) # ale ma być interpretowany jako jedna ze zdefiniowanych wartości
levels(x) # lista różnych wartości przechowywanych w tym factorze
as.numeric(x)

x[1] < x[3] # sypie błędem, bo w przypadku nieuporządkowanego
            # factora porównywanie nie ma sensu
            # (w R indeksy są od 1, a nie od 0) 


# można także stworzyć wariant uporządkowany 
x = factor(c("kot", "kot", "pies", "kot"), levels = c("kot","pies"), ordered = T)
as.numeric(x)

x[1] < x[3] # elementy factora uporządkowanego można porównywać




###################################################
### Złożone typy danych - wektory i sekwencje
###################################################

x = c(1,2,3) # c() nie tworzy wektora, jedynie skleja
             # wektory któtsze (w tym przypadku jednoelementowe);
             # w R każda zmienna typów prostych jest wektorem
x
typeof(x) # niczym nie różni się od zwykłej zniennej przechowującej
class(x)  # wartośći zmiennoprzecinkowe

# do elementów wektora odwołujemy się po ich indeksach za pomocą [], np.
x[1] # wybierze pierwszy element (w R pierwszy element ma indeks 1, a nie 0)
x[c(1,3)] # wybierze elementy pierwszy i trzeci

# możemy także wybierać elementy za pomocą wektora wartości logicznych
# TRUE - weź, FALSE - pomiń
x[c(F,T,T)]
x[(x %% 2) == 1] # wybór elementów nieparzystych


# zmiana wybranych elementów wektora

x = c('a','b','c','d','e','f','g') # utwórzmy nowy wektor
x

x[3] = 'z' # zmieńmy teraz jego trzeci element na 'z
x

x[c(6,7)] = c(92,68) # możemy też zmieniać kilka elementów
                     # wektora jednocześnie
x # tutaj dodatkowo widzimy, że gdy próbowaliśmy wrzucić do wektora
  # liczby zostały one zamienione automatycznie na ciągi znaków, bo 
  # ten wektor był tekstowy

x[20] = 'z' # gdy spróbujemy ustawić wartość w wektorze na pozycji
            # dalszej niż jego długość, wektot ten zostanie wydłużony,
            # a brakujące elementy zostaną wypełnione NA
x



### Generowanie sekwencji:
### `:` - utwórz sekencję kolejnych liczb całkowitych
### seq - utwórz sekwencję wartości z dowolnym krokiem
### rep - powtórz elementy ileś razy

x = 1:5 # kolejne liczby od 1 do 5
x

x = 5:1 # kolejne liczby od 5 do 1
x


# tworzenie sekwencji liczbowych
?seq # czyli rzut okiem do dokumentacji
x = seq(1, 9, 2) # liczby od 1 do 9 z krokiem co 2
x = seq(from = 1, to = 9, by = 2) # to samo, ale z nazwami atrybutów
x

?rep # zobaczmy dokumentację
x = rep(1:3, 2) # powtórz wektor 1:3 dwukrotnie
x

x = rep(1:3, each = 2) # powtórz każdy element drugiego wektora
x


# operacje na wektorach różnej długości

1:6 + 2:7 # dodaj do siebie elementy na odpowiadających sobie pozycjach
1:6 * 2 # pomnóż każdy element wektora
1:6 + 2 # do każdego elementu dodaj
1:6 + 1:3 # krótszy wektor został powtórzony
# 1 2 3 4 5 6
# 1 2 3 1 2 3
# ===========
# 2 4 6 5 7 9

1:5 + 1:3 # nie można dodać, bo długość żadnego wektora nie jest wielokrotnością długości drugiego



# sprawdzanie czy wektor zawiera określone elementy

4 %in% 1:5 # czy 4 należy do ciągu 1:5
6 %in% 1:5 # czy 6 należy do ciągu 1:5
1:2 %in% 1:5 # czy poszczególne elementy ciągu 1:2 należą do ciągu 1:5
all(1:2 %in% 1:5) # prawda, jeżeli wszystkie to prawda
1:2 %in% 2:5
all(1:2 %in% 2:5) # TRUE tylko wtedy gdy wszystkie elementy wektora są TRUE





###################################################
### Zadanie WEK1
###################################################

### Utwórz wektor postaci:
### a) 1, 2, 3, ..., 99, 100, 99, ..., 3, 2, 1
### b) 1, 2, 3, 1, 2, 3, ...   (10 powtórzeń)
### c) 1, 1, 1, ... , 3, 3, 3, ...   (10 x 1, 10 x 3)
### d) 1, 4, 7, 10, ..., 100
### e) 1, 4, 9, 16, ..., 81, 100
### f) 1, 2, 2, 3, 3, 3, ..., 100, 100, 100, 100
###    (1 x 1, 2 x 2, 3 x 3, ..., 99 x 99, 100 x 100)
### g) a1, b10, c100, d1000, ..., j1000000000 (9 zer)

letters                # wektor z kolejnymi literami alfabetu
as.integer(2e+8)       # zamienia z numeric na integer
as.integer(200000000)  # to m.in. wymusza notację zwykłą
                       # zamiast wykładniczej




###################################################
### Złożone typy danych - macierze
###################################################

#matrix - dwuwymaiarowa macierz
x = matrix(c(1,2,3,4), nrow = 2, ncol = 2) # trzeba podać wektor z danymi, liczbę wierszy i kolumn
x
typeof(x) # tak na prawdę to dalej jest wektor zmiennoprzecinkowy...
class(x)  # ... ale R wie, że ma go interpretować jako macierz

dim(x) # jakie ma wymiary

# do elementów macierzy można się odwoływać na wiele sposobów:
x
x[2,] # drugi wiersz
x[c(F,T),] # to samo wektorem logicznym, T - biorę ten wiersz, F - pomijam ten wiersz
x[,2] # druga kolumna
x[,c(F,T)] # to samo wektorem logicznym
x[2,2] #konkretny element, z drugiego wiersza i drugiej kolumny
x[c(F,T),c(F,T)]

t(x) #transpozycja
x * 2
x * x # mnożenie skalarne
x %*% x # mnożenie macierzowe



#array - macierz o liczbie wymiarów >= 2
x = array(1:8, c(2,2,2))
x
typeof(x)
class(x)

x
x[,1,] # wybieramy elementy, z dowolnych pozycji na 1-szym i 3-cim wymiarze, a na drugim z pozycji 1



###################################################
### Złożone typy danych - listy, czyli zmienne
### zawierające elementy o potencjalnie różnych typach
###################################################

x = list(a = 1, b = 2, c = "s") # zbiór nazwanych wartości
x
typeof(x)
class(x)


# może zawierać elementy róznych typów, w tym też np. listy
x = list(a = 1, b = 1:5, c = list(d = 3, e = 4), f = 'abc')

x
str(x) # trochę ładniej wypisuje strukturę

x$a # wartość elementu listy o nazwie a
x[2] # podlista zawierająca drugi element, wynik jest listą z jednym elementem
x[[2]] # wartość drugiego elementu
x["a"]  # podlista, po nazwie
x[["a"]] # wartość elementu o nazwie a
x[c("a", "b")] # podlista zawierająca elementy a i b
x[c(T,T,F,F)] # wektorem logicznym


x$c
x$d # nie ma, bo d nie jest elementem x...
x$c$d # ... a x$c

# dodawanie nowych elementów listy
x$g = 'nowy element'
x[c('h','i')] = c(10,12)
x[8] = 'element nienazwany'

# zmiana elementów listy
x$a = 'kiedyś tu była jedynka'

#usuwanie elementów listy
x$c = NULL
x[2] = NULL



###################################################
### Złożone typy danych - data.frame'y, czyli coś
### podobnego to tabel SQL-owych
###################################################

x = data.frame(
  a = c(1,2),
  b = c("a","b"),
  c = c(T,F),
  d = factor(c("A","B")),
  stringsAsFactors = F # bo domyślnie stringi zamieniane są na factory
)
x
typeof(x) # bo technicznie jest listą wektorów o tej samej długości
class(x)  # tylko, że R wie, że ma interpretować inaczej


# wybór kolumn (jako data.frame)
x[1] #kolumna jako data.frame (tak naprawdę, to pierwszy element listy)
x["b"] # wybór kolumny b
x[c("b","c")] # wybór kolumny a i b
x[c(F,T,T,F)] # F - weź kolumnę, T - pomiń kolumnę

# wybór pojedynczej kolumny (jako wektor)
x[,1] #kolumna jako wektor
x[,"a"] #albo tak
x[,c(T,F,F,F)] # albo tak
x$a #albo tak, no bo lista
x[[1]] #tak też, no bo lista

# wybór wierszy (jako data.frame)
x[1,] # jako indeks wiersza
x[c(T,F),] # albo wektorem logicznym

# wybór konkretnych elementów
x[1,4]
x[1,"d"]
x[c(T,F),c(F,F,F,T)]

# nazwy kolumn i wierszy
colnames(x) # odczytanie nazw kolumn
rownames(x) # odczytanie nazw wierszy
rownames(x) = c("Mietek", "Zdzisiek") # przypisanie nazw wierszy
x
x["Mietek","d"] # odwołanie się do kolumny i wiersza po ich nazwach


## Modyfikacja data.frame'ów

# nadpisywanie konkretnych elementów
x[1,"a"]
x[1,"a"] = 100
x

#dodawanie wiersza (możemy dodać data.frame, albo listę)
df2 = data.frame(a = 3, b = "c", c = F, d = "C", row.names = "Stasiu") # utwórzmy data.frame z nowym wierszem...
df2

x = rbind(x, df2) # ... i go doklejmy
x
x = rbind(x, "Hilary" = list(a = 5, b = "c", c = F, d = "C")) # alternatywnie, możemy nowy wiersz jako listę wartości
x


#dodawanie kolumny

df2 = data.frame(e = c(3, 5, 8, 13)) # utwórzmy data.frame z nową kolumną...
df2

x = cbind(x, df2) # ... i go doklejmy
x

x = cbind(x, f = c(20, 30, 40, 50)) # możemy dokleić wektor jako kolumnę
x

x$g = 1:4
x


###################################################
### Wywoływanie funkcji
### name(args) - wartość args podstaw pod pierwszy
###              argument funkcji
### name(arg_name = value) - wartość value podstaw
###              pod argument o nazwie arg_name
### name(arg1, arg2, argX_name = argX_value) - 
###              można mieszczać argumenty nazwane
###              i nie nazwane
###################################################

log(1) #logarytm naturalny
exp(1) #e do potęgi...
log2(2) #log o podstawie 2
log(4, 2) #logarytm o wybranej podstawie 
choose(6,2) #dwumian Newtona: 6!/(2!*(6-2)!), liczba możliwych różnych par spośród sześciu elementów
sqrt(4)
ceiling(4.2)
floor(4.6)
trunc(3.99) # przytnij w kierunku zera
trunc(-3.99)
round(6.492)
round(6.492, 1)
signif(123456, 3)
factorial(5) #silnia

# sprawdzanie, które elementy wektora ciągu znaków zawierają podany wzorzec
grep("woda", c("ziemia woda ziemia","ziemia","woda"))
grep("^woda$", c("ziemia woda ziemia","ziemia","woda")) 
grep("w.*", c("ziemia woda ziemia","ziemia","woda"))

x = data.frame(
  a = c(1,2,2,2,3),
  b = c("a","b","c","d","e"),
  c = c(T,F,T,NA,T),
  d = factor(c("A","B","B","B","B")),
  stringsAsFactors = F
)
summary(x) # ogólne podsumowanie każdej kolumny

x = seq(from = -4, to = 4, by = 0.1)
y = dnorm(x)
plot(x, y) # ale są lepsze sposoby na robienie wykresów (np. plotly, ale o tym później)
plot(x, y, type = "l", xlab = "Oś X", ylab = "Oś Y")

# argumenty podane z nazwy i pozycyjnie
# (wszystkie wywołania poniżej są identyczne)
seq(0, 4, 1) # każdy argument jest przekazany pozycyjnie
seq(from = 0, to = 4, by = 1) # tym razem każdy argument jest nazwany
seq(by = 1, from = 0, to = 4) # kiedy nazywamy argumenty, ich kolejność nie ma znaczenia
seq(by = 1, 0, 4) # kiedy część argumentów przekażemy pozycyjnie, a część w sposób nazwany,
seq(0, 1, to = 4) # to argumenty pozycyjne zostaną przypisane w kolejności do pozycji
                  # dla których wartości nie zostały określone


###################################################
### Obsługa pakietów
###################################################

install.packages("tidyverse") # instalacja pakietu o nazwie tidyverse

library(tidyverse) # wczytywanie pakietu
library(tidyversexxx) # sypie błędem, jeżeli pakietu nie ma

require(tidyverse) # też wczytywanie, ale błędem nie sypie
require(tidyversexxx) # wyświetla jedynie komunikat
(require(tidyverse)) # zwraca TRUE jeżeli pakiet jest
(require(tidyversexxx)) # zwraca FALSE jeżeli pakietu nie ma
# require możemy użyć gdy chcemy sprawdzić czy dany pakiet jest,
# i jeżeli tak, to załadować go i zrobić coś z jego użyciem


###################################################
### Tworzenie funkcji
### name <- function(arguments){
###   ... body ...
### }
###
### Dokładniej, to do zmiennej 'name' przypisujemy
### zdefiniowaną funcję
###################################################

avg <- function(data) {
  s = sum(data)
  l = length(data)
  return(s/l) # jeżeli nie ma return(...), zwracany jest wynik ostatniego wywołania...
}

avg(1:5)

avg <- function(data) {
  s = sum(data)
  l = length(data)
  s/l # ...czyli np. jak tutaj
}

avg(1:5)


### Argumenty z domyślną wartością

power_avg <- function(data, power = 1){ # power ma domyślną wartość 1
  d = data ^ power
  m = mean(d)
  m ^ (1/power)
}

power_avg(1:5) #nie ustawiono wartości 'power', zostala przyjęta domyślna wartość, czyli 1
power_avg(1:5, power = 2) #tutaj podaliśmy, więc wynosi 2
power_avg(1:5, 2) # to samo co linia wyżej, bo power to drugi argument, więc domyślnie
# ustawiany jest na wartość drugiego nienazwanego argumentu
power_avg(1:5, power = -1)


# operator ..., czyli wszystkie argumenty wywołania, które nie zostały dopasowane do żadnego argumentu
# poszczególne argumenty to ..1, ..2, ..3, ..4, etc.
moja_wspaniala_lista <- function(name, ...){ # zróbmy sobie funkcję, która tworzy listę, ale pierwszy argument
  list(imię = name, ...)                     # wstawia do niej, jako element o nazwie 'imię' 
}

x = moja_wspaniala_lista("Zdziś", x = 7, y = "abc")
x




#### WAŻNE!!! ####

# W funkcjach nie chodzi o to, aby wypisały wynik na ekran.
# Chodzi o to, aby go zwróciły, i potem ten wynik było można wykorzystać
# do czegoś innego (np. wypisać go na ekran)


avg(1:5)
res_ret = avg(1:5)
res_ret # wartość jest przypisana
sqrt(res_ret) # jeżeli chcemy, to potem możemy z nią zrobić coś
              # np. policzyć jej pierwiastek



# ale zróbmy drugą funckję, która też liczy średnią

avg_print <- function(data) { # ta funakjca nie zwraca wartości, jedynie ją wypisuje
  s = sum(data)
  l = length(data)
  
  print(paste0('Wynik to:', s/l))
}


avg_print(1:5)
res_print = avg_print(1:5)
res_print
class(res_print) # wynik jest ciągiem znaków, bo print() zwraca
                 # to samo co wpisał...
sqrt(res_print) # ... a na nim operacji liczbowych wykonać nie możemy
                # np. policzyć pierwiastka


###################################################
### If, else oraz ifelse
###################################################

if (2 < 3) { # jeżeli spełnione wykonaj ten kod
  print("prawda")
}

if (2 < 3) print("prawda") # klamry nie są obowiązkowe
                           # ale bez nich tylko jedna
                           # instrukcja jest warunkowana


if (2 > 3) { # jeżeli spełnione wykonaj ten kod
  print("prawda") # warunek nie jest prawdziwy, więc napis się nie pokazał
}


if (2 > 3) {
  print("prawda")
} else { # w innym przypadku wykonaj ten kod
  print("fałsz")
}


if(2 > 3) {
  print("pierwszy")
} else if(FALSE) { # jak chcemy dać kilka warunków
  print("drugi")
} else {
  print("trzeci")
}



# wektorowa wersja ifa
# jeżeli na danej pozycji pierwszego argumentu jest TRUE,
# to zwróć element z odpowiadającej pozycji drugiego wektora,
# a jak FALSE to z trzeciego

x = c(1,2,3,4)

ifelse(x>2, "większe", "nie większe")


d = data.frame(
  a = c(1,2,3,4),
  b = c("B1","B2","B3","B4"),
  c = c("C1","C2","C3","C4"),
  d = c("D1","D2","D3","D4"),
  stringsAsFactors = F
)
d

# dodajmy kolumnę e, która:
# w nieparzystych wierszach zawiera element z kolumny b,
# a w parzystych element z kolumny c
d$e = ifelse((d$a %% 2) == 1, d$b, d$c)
d


###################################################
### Zadanie POD1
###################################################

### Napisz funkcję fibonacci(n), zwracającą n-ty
### element ciągu fibonacciego, w oparciu
### podejście rekurencyjne.
### Przyjmij, że:
### - dla n == 0 wartość wynosi 0
### - dla n == 1 wartość wynosi 1
### - dane wejsciowe są prawidłowe


###################################################
### While - powtarzaj tak długo, jak warunek jest spełniony
###
### break - przerywa wykonywanie pętli
### next - kończy obecną iterację, przechodzi do następnej
###################################################
?`while`

i = 0
while (i < 8) { # tak długo, jak i jest mniejsze niż 8
  i = i + 1     # zwiększ i o 1
  print(i)      # oraz wypisz nową wartość i
}


i = 0
while (i < 8) {
  i = i + 1
  if(i == 4){
    break # zakończ pętlę
  }
  print(i)
}


i = 0
while (i < 8) {
  i = i + 1
  if(i == 4){
    next # zakończ ten przebieg pętli i przejdź do kolejnego
  }
  print(i)
}

###################################################
### Repeat - powtarzaj, aż nie wywołam break
### break i next działają tak samo jak w while
###################################################

i = 0

repeat{ # to samo co while(true)
  i = i + 1
  if(i > 8){
    break
  }
  print(i)
}

###################################################
### For - wykonaj po kolei, dla każdego elementu z wektora
### break i next działają tak samo jak w while
###################################################

for(i in 1:10){
  print(i)
}

x = 1:6
y = 1
for(i in x){
  y = y * i
  print(y)
}
y

for(a in as.list(letters)){
  print(a)
}


###################################################
### Zadanie POD2
###################################################

### Napisz funkcję fibonacci_series(n), zwracającą
### n pierwszych elementów ciągu fibonacciego.
### Wykorzystaj podejście oparte o programowanie
### dynamiczne.
### Przyjmij, że:
### - dla n == 1 wartość wynosi 1
### - dla n == 2 wartość wynosi 1
### - n jest nie mniejsze niż 1
### - dane wejsciowe są prawidłowe



###################################################
### Tworzenie funkcji, część 2
###################################################

### Konflikty

# Do konfliktu dochodzi, gdy coś przypiszemy pod zmienną
# o tej samej nazwie pod jaką widzimy coś (np. funckję)
# pochodzące z jakiegoś pakietu

avg <- function(data){ # zróbmy sobie funkcję liczącą średnią
  cat("JESTEM avg()\n") # wypiszmy coś, abyśmy mogli poznać, że to właśnie ta funckja została wywołana
  sum(data) / length(data)
}

avg(1:5)


mean = avg # nadpisujemy metode mean z pakietu bazowego, czyli robimy konflikt
mean(1:5)
conflicts() # sprawdźmy, rzeczywiście jest na liście konfliktów
base::mean(1:5) # do oryginalnej funkcji z konkretnego pakietu base możemy się odwołać w ten sposóbb
# bez określenia nazwy pakietu, jest używana funkcja zdefiniona lokalnie
# a jak takiej nie ma, to z pakietu dołączonego najbardziej ostatnio
rm(mean) # usuwamy funkcję tak samo jak zmienną, bo właśnie nią jest
mean(1:5)
conflicts() # konfliktu po usunięciu już nie ma
avg(1:5) # nasza funkcja dalej istnieje pod oryginalną nazwą


###################################################
### Zadanie POD3
###################################################

### Napisz funckję sampled_frame() która tworzy
### data.frame w oparciu o przekazane wartości
### kolumn, a następnie go spróbkuje, t.j. wybierze
### n losowych wierszy (domyślnie ze zwracaniem).
### 
### Funkcja ta powinna przyjmować argumenty:
### n       - liczba wierszy do wylosowania i zwrócenia
### replace - czy losowanie ma być ze zwracaniem
### ...     - kolumny do zbudowania data.frame'a
### 
### Dodatkowo, każdy wiersz wyniku powinien mieć
### zgodną z wzorcem: sampled_row_N, gdzie N to
### numer wiersza. N powinno być uzupełnione zerami
### w liczbie wystarczającej, aby każdy wiersz miał
### nazwę identycznej długości.


sampled_frame = function(n, ..., replace = TRUE){
   ### wasz kod
}


sampled_frame(9, a = 1:5, b = letters[1:5])
#               a b
# sampled_row_1 4 d
# sampled_row_2 2 b
# sampled_row_3 2 b
# sampled_row_4 5 e
# sampled_row_5 4 d
# sampled_row_6 5 e
# sampled_row_7 5 e
# sampled_row_8 1 a
# sampled_row_9 2 b

sampled_frame(11, a = 1:5, b = letters[1:5])
#                a b
# sampled_row_01 5 e
# sampled_row_02 5 e
# sampled_row_03 3 c
# sampled_row_04 3 c
# sampled_row_05 3 c
# sampled_row_06 1 a
# sampled_row_07 2 b
# sampled_row_08 5 e
# sampled_row_09 5 e
# sampled_row_10 1 a
# sampled_row_11 4 d

sampled_frame(4, digit = 1:1000, letter = sample(letters, 1000, replace = TRUE))
#               digit letter
# sampled_row_1   476      a
# sampled_row_2   888      a
# sampled_row_3   445      h
# sampled_row_4   744      f






###################################################
### --- BARDZO OPCJONALNE, ACZ PRZYDATNE ---
### Tworzenie funkcji, część 3
###################################################

#lazy evaluation - wartość przypisana argumentowi funkcji
#       nie jest obliczana w momencie wywołania funkcji,
#       a dopiero w momencie gdy jest pierwszy raz w niej potrzebna

x <- function(){ # zróbmy sobie funckję
  print("Działam! Działam! Działam!") # wypiszmy coś, abyśmy wiedzieli, że ciało funkcji zostało wykonane
  return("Jestem z x")
}
x()

y1 <- function(a){ # nie korzysta z wartości podanej w argumencie
  print("y1")
}

y2 <- function(a){ # jednokrotnie korzysta z wartości podanej w argumencie
  print(paste0("y2", " ", a))
}


y3 <- function(a){ # dwukrotnie korzysta z wartości podanej w argumencie
  print(paste0("y3", " ", a, " ", a))
}

y1(x()) # x() nie została wywołana
y2(x()) # x() została wykonana, bo była potrzebna jej wartość
y3(x()) # x() została wykonana tylko raz, bo za drugim razem jej wartość była już znana

# wniosek: przekazując wywołanie funkcji jako argument innej funkcji, nie należy zakładać
#          że to wywołanie zostanie rzeczywiście wykonane
