# Wykorzystując bazę SQLite zawartą pliku 'homework.db' oblicz MEDIANĘ liczby przylotów
# i odlotów na lotnisku w Los Angeles w każdym z 12 miesięcy w roku.
# Następnie zapisz wynik do pliku CSV. (oczekiwany wynik masz w pliku Zadanie_domowe_02_wynik.csv)
#
# Zwróc uwagę, że dla każdego miesiąca masz podane informacje o kilku rodzajów lotów. Należy
# więc je wstępnie zsumować.

library(DBI)
library(RSQLite)
library(dbplyr)

drv <- dbDriver("SQLite")

con <- dbConnect(drv, "Zadanie_domowe_02_homework.db", flags = SQLITE_RO) # połączenie w trybie tylko do odczytu, aby przypadkiem nie zmodyfikować zawartości bazy

#dbplyr
tbl(con, 'flights')
#DBI
dbGetQuery(con, 'SELECT * FROM flights')



# oczekiwany wynik:
readr::read_csv('Zadanie_domowe_02_wynik.csv')
