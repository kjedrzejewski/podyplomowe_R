###################################################
### Dodatkowe materiały
###################################################

# https://shiny.rstudio.com/tutorial/ (jest tutorial video)
# https://shiny.rstudio.com/articles/reactivity-overview.html

# install.packages('shiny')

library(shiny)

# Wyrażenia rekatywne to takie wyrażnie, które jeżeli się zmieniło
# coś na podstawie czego były obliczone, to zostaną ponownie przeliczane

# stwórzmy listę reaktywnych wartości
?reactiveValues
v <- reactiveValues(
  a = 1,
  b = 2
)

isolate(v$a) # żeby odczytać wartości reaktywne poza kontekstem, trzeba użyć funckji isolate()
isolate(v$b)

# oraz wyrażenie, w którym je wykorzystujemy
c = reactive({
  v$a + v$b
})
isolate(c()) # to co powstało jako reactive() musi być odczytywane jak funkcja
isolate(v$a)
isolate(v$b)

?reactive

###
# W tym momencie mamy zbudowaną zależność między c oraz v$a i v$b,
# dlatego gdy v$a albo v$b się zmieni, wtedy c zostanie o tym
# poinformowane, i będzie wiedziało, że musi się ponownie przeliczyć. 
###

# zobaczmy to w działaniu

v$a = 5 # zmieńmy wartość jednego składnika
isolate(c()) # wartość się zmieniła
isolate(v$a)
isolate(v$b)




# zresetujmy wartości
v <- reactiveValues(
  a = 1,
  b = 2
)

isolate(c()) # w tym momencie c się nie zmieniło, bo nie zmieniły się zmienne,
             # a kontener je zawierający, w którym są nowe zmienne a i b.
             # c dalej czeka na informacje o zmianach od starego v$a oraz v$b
             # w starej zmiennej v

c = reactive({ # zdefiniujmy c jeszcze raz, żeby reagowało na zmiany
  v$a + v$b
})

isolate(c()) # teraz się wartość zmieniła, ole trzeba pamiętać, że to jest nowe c
             # które tak samo nie będzie informować o swoich zmiana, wyrażeń gdzie było użyte



# tym razem zdefiniujmy c tak żeby:
# - było przeliczane gdy zmienimy v$b
# - NIE było przeliczane gdy zmienimy v$a
c = reactive({
  isolate(v$a) + v$b # isolate() znaczy "weź to co jest obecnie i nie reaguj na zmiany tej wartości"
})
isolate(c())

v$a = 5
isolate(c()) # a się zmieniło, ale to nas nie interesuje, więc c nie zostało przeliczone

v$b = 3
isolate(c()) # b się zmieniło, więc przeliczamy (to uwzględnia też nową wartość a) -> 5 + 3.
             # c czeka z przeliczeniem do momentu, aż nieizolowane zmienna się zmieni, ale 
             # gdy to już nastąpi, to korzysta z aktualnych wartości każdej zmiennej


###
# Ale czym to się różni od zwykłej funkcji???
###

# zresetujmy v raz jeszcze
v <- reactiveValues(
  a = 1,
  b = 2
)

# c tym razem oprócz zsumowania v$a i v$b, wypisze tekst na konsoli,
# będziemy więc wiedzieć kiedy się wykonuje
c = reactive({
  print('UWAGA!!! ODPALAM!!!!!!!!!!!!')
  v$a +v$b
})

isolate(c()) # wypisało, a więc za pierwszym razem się przeliczyło (w momencie gdy zażądaliśmy wartości, a wiedziało, że nie zna aktualnej)
isolate(c()) # nie obliczyło się ponownie. Żadna z reaktywnych wartości się nie zmieniła, wiec zwróciło jedynie zapamiętaną wartość

v$a = 5      # zmieńmy v$a
isolate(c()) # po zmianie musiało przeliczyć, więc wypisało
isolate(c()) # ale jak poprzednio, tylko za pierwszym razem




###
# obserwatory
# - przeliczają się kiedy tylko mogą (a nie w 
#   momencie kiedy są odczytywane). No dobra,
#   dopiero w momencie flush'a
# - nie mają wartości
###
?observe

# jeszcze raz zresetujmy v
v <- reactiveValues(
  a = 1,
  b = 2
)

# zróbmy obserwatora, który w momencie wykonania będzie
# do v$d przypisywał iloczyn v$a i v$b
observe({
  cat('Policzyłem:', v$a * v$b)
  v$d = v$a * v$b
})

isolate(v$d) # nie było flush'a - NULL
shiny:::flushReact() # robimy flush'a; poza Shinym trzeba ręcznie; w appce Shiniego
                     # nie trzeba, bo Shiny to robi automatycznie w odpowiednim momencie
isolate(v$d) # był flush - 2

v$a = 5      # zmieniamy v$a
isolate(v$d) # nie było flush'a - 2, czyli po staremu
shiny:::flushReact() # robimy flush'a
isolate(v$d) # był flush - 10




# observeEvent działa podobnie jak observe(), ale
# osobno określamy kiedy ma się wykonać przeliczenie,
# i osobno co ma się wtedy stać
?observeEvent
# eventReactive działa podobnie jak reactive(), ale
# osobno określamy kiedy ma ponownie przeliczyć wartości,
# i osobno jak ma być obliczone
?eventReactive

