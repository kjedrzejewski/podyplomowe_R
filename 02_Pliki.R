###################################################
### Dodatkowe materiały
###################################################

# https://readr.tidyverse.org
# http://r4ds.had.co.nz/data-import.html
# https://github.com/rstudio/cheatsheets/raw/master/data-import.pdf


###################################################
### Folder roboczy oraz nawigacja po nim
### Folder roboczy - folder w którym szukane jest to
###    do czego nie podamy pełnej ścieżki
###################################################

getwd() # pokazuje obecny folder roboczy, obecnie 
        # powinien być folder główny projektu
list.files() # listuje jakie mamy pliki w podanym folderze
             # nie podaliśmy folderu, więc pokazuje folder roboczy
list.files('example') # zwraca listę pliki z podfolderu o nazwie 'examplu' (z folderu roboczego)
list.files('/Users/kjedrzejewski') # a to zawsze zwróci to samo
                                   # nie ważne jaki jest folder roboczy
                                   # Oczywiście to konkretne wywołanie prawidłowo zadziała
                                   # u mnie, bo u mnie istnieje folder o takiej ścieżce bezwzględnej

setwd('example') # zmienia folder roboczy na podfolder 'example' (bo podana ścieżka jest względna)
# setwd('/kompletna/ścieżka/do/folderu/example')) # to by zrobiło to samo (na Macu i Linuxach)
# setwd('c:\kompletna\ścieżka\do\folderu\example')) # albo to (na Windach)

getwd() # jak widać, folder roboczy został zmieniony

list.files() # więc teraz ta funkcja pokazuje pliki z nowego folderu roboczego

setwd('..') # wróćmy poziom wyżej (.. oznacza folder poziom wyżej)
# setwd(paste0(getwd(),'/..'))
getwd()


###################################################
### Wczytanie pliku CSV
###################################################

library(readr) # ładujemy pakiet readr

# jest też read.csv w pakiecie bazowym, ale dużo lepiej korzystać z readr::read_csv
read_csv("iris.csv") # wczytywanie pliku CSV do tabeli
                     # można też użyć pełnych ścieżek, ale iris.csv jest w folderze roboczym, więc po co :)
                     # nie przypisaliśmy do zmiennej, więc wynik wypisało
iris_data = read_csv("iris.csv") # a tutaj przypisanie tego do zmiennej
typeof(iris_data) # technicznie rzecz biorąc jest to data.frame
class(iris_data)  # ale lekko ulepszony - tbl - tibble, podstawa tidyverse'u

spec_csv("iris.csv") # wyświeltenie specyfikacji, w postaci którą możemy łatwo skopiować,
                     # przerobić, i wrzucić jako 'col_types', tak jak niżej

iris_data2 = read_csv("iris.csv", col_types = cols(
  sepal_length = col_double(), # tę kolumnę każemy wczytać jako double
  sepal_width = col_double(), # tę też
  petal_length = col_skip(), # a te dwie każemy pominąć
  petal_width = col_skip(),
  species = col_factor(c("setosa", "versicolor", "virginica")) # a tą chcemy aby wczytało jako
                             # factora z podanymi poziomami
))
iris_data2


# podobne wywołanie jak wcześniej, ale tym razem pominęliśmy definicje dla kolumn do skipnięcia
# w tej sytuacji te zostały wczytane na domyślnym ustawieniu
iris_data2 = read_csv("iris.csv", col_types = cols( 
  sepal_length = col_double(),
  sepal_width = col_double(),
  species = col_factor(c("setosa", "versicolor", "virginica"))
))
iris_data2


# i kolejna lekka zmiana, tym razem użyliśmy 'cols_only' zamiast 'cols'
# kolumny niewymienione zostały pominięte
iris_data2 = read_csv("iris.csv", col_types = cols_only( # cols_only - pomiń kolumny, które nie zostały wymienione
  sepal_length = col_double(),
  sepal_width = col_double(),
  species = col_factor(c("setosa", "versicolor", "virginica"))
))
iris_data2

# to samo co wyżej, ale z wykorzystaniem skróconego zapisu definicji kolumn
iris_data2 = read_csv("iris.csv", col_types = "dd__c") #  d - double, c - character, _ - skip
iris_data2

# Więcej: 
vignette("readr") # vignette() wyświetla artykuł na dany temat


# aaaa..., można też wczytać pliki bezpośrednio z Internetu
read_csv("https://raw.githubusercontent.com/uiuc-cse/data-fa14/gh-pages/data/iris.csv")


###################################################
### Zapisywanie pliku
###################################################

# mamy zmienną d
d = read_csv("iris.csv")
# przerabiamy ją lekko
# dodajemy numery wierszy jako kolumnę
d$number = row.names(d)
# jako dodatkową kolumnę dodajemy losowe litery
d$letter = sample(LETTERS, length(d$number), replace = T)
d # w 'd' mamy jakiś przerobiony dataset, który chcemy zapisać


write_csv(d, "iris2.csv") # zapiszmy tabelę ze zmiennej 'd'
                          # do pliku "iris2.csv" (w folderze roboczym)



###################################################
### Zadanie READR1
###################################################

### Z pliku https://gist.githubusercontent.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv
### wczytaj kolumny:
### - model - jako ciąg znaków
### - mpg - jako liczbę zmiennoprzecinkową
### - cyl - jako liczbę zmiennoprzecinkową
### - hp - jako liczbę całkowitą
### - carb - jako ciąg znaków
### Pozostałe kolumny pomiń.
### Następnie:
### - dodaj do tego kolumnę "x" o treści "xxx" w każdym wierszu
### - zapisz otrzymany data.frame do pliku

