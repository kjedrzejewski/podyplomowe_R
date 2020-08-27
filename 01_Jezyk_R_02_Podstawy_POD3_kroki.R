################################################################################
## Zadanie POD3 po kawałeczku ;) 
################################################################################

# a) Utworz funkcję sampled_frame() posiadającą jeden parametr o nazwie x, która zwraca wartość x.






# b) Zmodyfikuj funkcję sampled_frame() tak, by zwracała ona ramkę danych (data.frame) z dwiema
# kolumnami o nazwach x i y. Wartościami kolumny x będą wartości podane w parametrze x, 
# natomiast wartości w kolumnie y będą podwojnymi wartościami x.








# c) Zmodyfikuj funkcję sampled_frame(), tak by tworzyła ona i zwracała ramkę danych w oparciu 
# o nazwy kolumn i wartości przekazne w parametrze ...









# d) Kod pomocniczy - utwórz wektor "id_wierszy" zawierający n liczb wylosowanych z wektora 1:N 
# (domyślnie losowanie ze zwracaniem). Użyj funkcji sample(). Niech:
n <- 5
N <- 10





# e) Zmodyfikuj funkcję sampled_frame(), tak by zwracała ona spróbkowaną ramkę danych, 
# t.j. po utworzeniu ramki danych w oparciu o wartości przekazane w parametrze ..., 
# następuje losowy wybór n wierszy (domyślnie ze zwracaniem). 
# Argumenty funkcji:
# n       - liczba wierszy do wylosowania i zwrócenia
# replace - czy losowanie ma być ze zwracaniem
# ...     - kolumny do zbudowania data.frame'a












# f) Zmień nazwy wierszy zgodnie ze wzorcem: sampled_row_N, 
# gdzie N to numer wiersza w nowej ramce danych. 














# g) Zmodyfikuj funkcję sampled_frame() tak, by nazwa wiersza była zawsze równej długości,
# poprzez uzupełnienie zerami np. sampled_row_01, ..., sampled_row_11. 
# Oprócz funkcji paste0 użyj funkcji sprintf().















