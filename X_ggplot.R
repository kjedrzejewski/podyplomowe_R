###################################################
### Dodatkowe materiały
###################################################

# https://r4ds.had.co.nz/data-visualisation.html
# https://r4ds.had.co.nz/graphics-for-communication.html
# http://ggplot2.orgxw
# A szczególnie: http://docs.ggplot2.org/
# A ggforce bardzo ładnie rozszerza:
#     https://ggforce.data-imaginist.com/

###################################################
### Kilka prostych wykresów
###################################################

# install.packages("ggplot2")

library(ggplot2)

# wykres słupkowy
# ile jest różnych modeli dla każdej z wartości gear
ggplot(mtcars, aes(x = gear)) + # w ggplot jest '+', a nie '%>%'
  geom_bar()


# jak przypiszemy do zmiennej, to wykres nie jest renderowany
plot = ggplot(mtcars, aes(x = gear)) +
  geom_bar()


# żeby go wyrenderować, trzeba tę zmienną wywołać
plot


# ozdóbmy go trochę
ggplot(mtcars, aes(x = gear)) +
  geom_bar(fill = "darkgreen") +       # pomalumy na ciemno zielono
  xlab("Liczba biegów") +              # dodajmy opis osi X
  ylab("Liczba modeli") +              # dodajmy opis osi Y
  ggtitle("Super wykres")              # dodajmy tytuł
  

ggplot(mtcars, aes(x = gear, fill = factor(gear))) + # wg czego ma wypełniać
  geom_bar() +
  xlab("Liczba biegów") +
  ylab("Liczba modeli") +
  ggtitle("Super wykres")


# dodajmy podział wg. v/s
ggplot(mtcars, aes(x = gear, fill = factor(vs))) + # wg czego ma wypełniać
  geom_bar() +
  xlab("Liczba biegów") +
  ylab("Liczba modeli") +
  scale_fill_discrete(name = "V/S") + # nazwa legendy
  ggtitle("Super wykres")


# użyjmy własnych kolorów
ggplot(mtcars, aes(x = gear, fill = factor(vs))) +
  geom_bar() +
  xlab("Liczba biegów") + 
  ylab("Liczba modeli") + 
  scale_fill_manual(name = "V/S", values = c("red","green")) + # bo chcemy czerwony i zielony
  ggtitle("Super wykres")



# a jeżeli chcemy, chcemy aby powstał wykres, gdy mamy dane już przeliczone:
df = data.frame(x = 1:6, y = rnorm(6, mean = 100, sd = 20))

ggplot(df, aes(x = x, y = y)) +
  geom_bar(stat = "identity") # stat = "identity" mówi:
                              # nie zliczaj, weź to co jest w y




# wykres punktowy - scatterplot
ggplot(mtcars, aes(x = disp, y = wt)) +
  geom_point()


# wykres pudełkowy - boxplot
ggplot(mtcars, aes(x = factor(gear), y = wt)) + # factor, aby wartość była traktowana jako etykieta, nie liczba
  geom_boxplot()


# histogram
ggplot(mtcars, aes(x = wt)) +
  geom_histogram(bins = 7)

ggplot(mtcars, aes(x = wt)) +
  geom_freqpoly(bins = 7)





###################################################
### Zapisywanie
### ggsave(nazwa_pliku_z_rozszerzeniem, wykres)
###################################################

plot = ggplot(mtcars, aes(x = gear, fill = factor(vs))) +
  geom_bar() +
  xlab("Liczba biegów") + 
  ylab("Liczba modeli") + 
  scale_fill_manual(name = "V/S", values = c("red","green")) +
  ggtitle("Super wykres")   


ggsave("wykres.png", plot)
ggsave("wykres.pdf", plot)




###################################################
### Zadanie GGPLOT1
###################################################

# Zrób wykres punktowy (scatterplot) pokazujący 
# zależność między Sepal.Length a Sepal.Width
# we wbudowanym datasecie iris.

?iris

