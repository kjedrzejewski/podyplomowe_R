###################################################
### Dodatkowe materiały
###################################################

# Postgres: https://code.google.com/archive/p/rpostgresql/
#           https://cran.r-project.org/web/packages/RPostgreSQL/RPostgreSQL.pdf
# MySQL: https://cran.r-project.org/web/packages/RMySQL/README.html
#        https://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
# Oracle: http://www.oracle.com/technetwork/database/database-technologies/r/roracle/201403-roracle-2167267.pdf
#         https://cran.r-project.org/web/packages/ROracle/ROracle.pdf
# MS SQL Server: https://github.com/imanuelcostigan/RSQLServer
#                https://cran.r-project.org/web/packages/RSQLServer/RSQLServer.pdf
# SQLite: https://cran.r-project.org/web/packages/RSQLite/RSQLite.pdf

# https://dbplyr.tidyverse.org
# https://dbplyr.tidyverse.org/articles/dbplyr.html
# https://github.com/tidyverse/dbplyr

###################################################
### Np. w przypadku PostgreSQL'a
###################################################

# otwieramy połączenie z bazą danych (oczywiście musimy podać dane bazy do której się łączysz)
# require("RPostgreSQL")
# drv <- dbDriver("PostgreSQL")
# con <- dbConnect(drv, dbname = "nazwa_bazy", host = "adres", port = 5432, user = "nazwa_usera", password = "hasło")



###################################################
### Np. w przypadku SQLite'a
###################################################

# Połączmy się z bazą
# install.packages("RSQLite")
require(DBI)
require(RSQLite)
# te pakiety też, bo się przydadzą
require(dplyr)
require(tidyr)

# tworzymy sterownik...
drv <- dbDriver("SQLite")

# ... i łączymy się do bazy z niego korzystając.
# Ścieżka :memory: oznacza, że baza nie jest
# zapisywana, i zniknie zaraz po rozłączeniu.
# Można się też tworzyć bazy plikowe, no ale
# bez spoilerów...
con <- dbConnect(drv, ":memory:")


# wrzućmy mtcars do naszej bazy jak tabelę 'cars'
dbWriteTable(
  con,          # którym połączeniem
  'cars',       # pod jaką nazwą
  mtcars %>%    # jakie dane
    tibble::rownames_to_column('model') # przerzucamy nazwę wiersza do kolumny model
)

# sprawdźmy listę tabel
dbListTables(con) # nasza tabela jest
# zobaczmy jakie ma kolumny
dbListFields(con, 'cars')


###################################################
### ZAPYTANIA
###################################################

# wykonajmy jakieś zapytania

# wynik możemy pobrać cały od razu używając dbGetQuery()
d <- dbGetQuery(con, "SELECT * from cars")
d

# albo gdy nie chcemy / nie możemy pobrać całości wyniku zapytania na raz
# to możemy go pobrać w częściach i przetwarzać na bieżąco używając:
# dbSendQuery(), dbFetch() oraz dbClearResult()
# 
rs = dbSendQuery(con, "SELECT * from cars") # zwraca nam obiekt przez który możemy dostać się do wyniku
dbColumnInfo(rs)
d <- dbFetch(rs, n = 24) #pobieramy pierwsze 24 wiersze
d
d <- dbFetch(rs, n = 24) #pobieramy kolejne 24 wiersze, ale jest tylko 8
d
dbClearResult(rs) # kończymy przetwarzanie tego zapytania


# oczywiście możemy też puszczać inne zapytania, np. pobierać
# tylko wiersze mające gear = 4
dbGetQuery(con, "SELECT * from cars WHERE gear = 4")

# Dane możemy zmieniać za pomocą dbExecute(), którym to
# zarówno modyfikujemy strukturę tabel...
dbExecute(con, "ALTER TABLE cars ADD COLUMN x NUMERIC;")

# ... jak i dane w nich zawarte
dbExecute(con, "UPDATE cars SET x = am + gear + carb;")

# jak widać doszła kolumna x, której zawartość jest obliczona
# zgodnie ze wzorem z poprzedniej linii
dbListFields(con, 'cars')
dbGetQuery(con, "SELECT * from cars")

# na koniec pracy, zamykamy połączenie
dbDisconnect(con)


###################################################
### dbplyr - pakiet który pozwala nam pracować
###   na tabelach w bazie, za pomocą kodu
###   korzystającego z funkcji dplyr'owych
### Na podstawie wykonanych operacji, generuje
### on kod SQL
###################################################

# https://dbplyr.tidyverse.org
# https://dbplyr.tidyverse.org/articles/dbplyr.html
# https://github.com/tidyverse/dbplyr

vignette('dbplyr')
vignette('sql-translation')

# wczytajmy paliety
library(DBI)
library(RSQLite)
library(dbplyr)
library(dplyr)

# tak samo jak wcześniej musimy się połączyć
# do bazy
drv <- dbDriver("SQLite")
con <- dbConnect(drv, ":memory:")

# wrzućmy tabelę do bazy
mtcars %>%
  tibble::rownames_to_column('model') %>%
  copy_to(con, ., name = 'cars')


###################################################
### tbl(połączenie, nazwa_tabeli) - utwórz połączenie
###   do tabeli o podanej nazwie. Na wyniku tej
###   funkcji można pracować za pomocą zwykłych
###   operacji dplyr'owych
###################################################

# połączmy się z tabelą cars
tbl(con, 'cars')
# pozornie wygląda to jak zwykły tibble

# ... nim nie jest
tbl(con, 'cars') %>%
  typeof()

tbl(con, 'cars') %>%
  class()

# nie przechowuje też danych...
tbl(con, 'cars') %>%
  str()

# ... a jedynie "zapis" operacji jakie na nim wykonaliśmy
tbl(con, 'cars') %>%
  filter(gear == 4) %>%
  str()

# jak chcemy zobaczyć dane musimy je wykonać
tbl(con, 'cars') %>% # wypisanie na ekran powoduje tylko pobranie kilku pierwszych wierszy (jako podgląd)
  filter(gear == 4)

# jak chcemy przypisać wynik do zmiennej, trzeba użyć collect()
cars_from_db = tbl(con, 'cars') %>%
  filter(gear == 4) %>%
  collect()

cars_from_db # teraz to jest zwykły tibble


# aby zoaczyć wygenerowany SQL możemy użyć funkcji show_query()
tbl(con, 'cars') %>%
  filter(gear == 4) %>%
  show_query()

# albo jakieś większe zapytanko
tbl(con, 'cars') %>%
  filter(gear == 4) %>%
  group_by(am) %>%
  summarise(n = n(), mean_mpg = mean(mpg)) %>%
  show_query() 


# też jest różnica w wygenerowanym SQL-u jeżeli wywołamy filter() raz, albo kilka razy
tbl(con, 'cars') %>%
  filter(gear == 4, carb == 4) %>%
  group_by(am) %>%
  summarise(n = n(), mean_mpg = mean(mpg)) %>%
  show_query()
# tutaj jest tylko jeden WHERE

tbl(con, 'cars') %>%
  filter(gear == 4) %>%
  filter(carb == 4) %>%
  group_by(am) %>%
  summarise(n = n(), mean_mpg = mean(mpg)) %>%
  show_query()
# a tutaj pierwszy filter() został zamieniony w WHERE
# w podzapytaniu


# pośrednie kroki przetwarzania można przypisywać do zmiennych
step1 = tbl(con, 'cars')

step2 = step1 %>%
  filter(gear == 4)

step3 = step2 %>%
  group_by(am)

step4 = step3 %>%
  summarise(n = n(), mean_mpg = mean(mpg))

step4


# na koniec musimy tak samo zamknąć połączenie
dbDisconnect(con)

