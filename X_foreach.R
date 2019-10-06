###################################################
### Dodatkowe materiały
###################################################

# https://cran.r-project.org/web/packages/foreach/vignettes/foreach.pdf
# https://cran.r-project.org/web/packages/doParallel/vignettes/gettingstartedParallel.pdf


###################################################
### foreach
### foreach(zmienna = wektor, [zmienna2 = wektor2], ...) %do% {
###   [kod pojedynczego przebiegu odwołujący się do zmiennych]
### }
###################################################

# install.packages("foreach")
library("foreach")
library("data.table") # bo w kilku miejscach niżej korzystamy


y = foreach(i=1:9) %do% {
  sqrt(i)
}
y # lista


y = foreach(i=1:9, .combine = c) %do% {
  sqrt(i)
}
y # wektor


y = foreach(i=1:9, .combine = rbind) %do% {
  sqrt(i)
}
y # macierz

y = foreach(i=1:9, .combine = rbind) %do% {
  list(n = i, v = sqrt(i)) # jak zwrócimy listę albo tabelę zadziała tak samo
}
y

# w każdym przebiegu pod zmienne podstawiane są elementy wektorów
# wejściowych o tym samym indeksie
foreach(i=1:9, j=((1:9)*100), .combine = c) %do% {
  i + j
}

foreach(i=1:9, j=((1:9)*100), .combine = function(a,b){a + b}) %do% {
  c(i, j)
} # wektory wynikowe można też sumować


###################################################
### Iteratory
###################################################

library(iterators)

it = iter(1:3)
nextElem(it)
nextElem(it)
nextElem(it)
nextElem(it) # Błąd, brak elementów do zwrócenia


it = iter(1:9)
foreach(i=it, .combine = c) %do% {
  i
}



dt = data.table(
  a = 1:10,
  b = seq(10,100,10),
  c = seq(100,1000,100),
  d = letters[1:10]
)

# iteracja po wierszach data.table
it = iter(dt, by="row")
y = foreach(i=it, .combine = rbind) %do% {
  i
}
y

#łączenie wyników własną funkcją
comb = function(a,b) {
  data.table(
    a = a$a + b$a,
    b = a$b + b$b,
    c = a$c + b$c,
    d = paste0(a$d,b$d)
  )
}

comb(
  data.table(a = 1, b = 2, c = 3, d = 'x'),
  data.table(a = 10, b = 20, c = 30, d = 'y')
)



it = iter(dt, by="row")
y = foreach(i=it, .combine = comb) %do% {
  i
}
y






###################################################
### Przetwarzanie równoległe
###################################################

# install.packages("doParallel")
library(doParallel)

cl <- makeCluster(4)
registerDoParallel(cl)

# stopCluster(cl) - aby zamknąć cluster

getDoParWorkers()

y = foreach(i=1:9, .combine = c) %dopar% {
  sqrt(i)
}
y


###################################################
### Beanchmark for, %do% i %dopar%
###################################################

f <- function(n){
  sample(n, 1000000, replace = T)
  sqrt(n)
}

# zwykła pętla
before = Sys.time()
y = rep(NA, 10000)
for(i in 1:10000){
  y[i] = f(i)
}
after = Sys.time()
after - before # Time difference of 2.35057 mins (141.0342s)


before = Sys.time()
y = foreach(i=1:10000, .combine = c) %do% {
  f(i)
}
after = Sys.time()
after - before # Time difference of 2.436261 mins (146.17566s)


# funkcja do testów na różnej liczbie wątków
# robi to samo co pętle wyżej, ale dodatkowo tworzy clustry z podaną liczbą wątków
benchmark <- function(n){
  f <- function(n){
    sample(n, 1000000, replace = T)
    sqrt(n)
  }
  
  cl <- makeCluster(n)
  registerDoParallel(cl)
  
  before = Sys.time()
  y = foreach(i=1:10000, .combine = c) %dopar% {
    f(i)
  }
  after = Sys.time()
  
  stopCluster(cl)
  
  after - before
}

# mam 4 rdzenie fizyczne + 4 wirtualne
benchmark(1) #Time difference of 2.271581 mins (136.29486s)
benchmark(2) #Time difference of 1.224574 mins (73.47444s)
benchmark(3) #Time difference of 55.92213 secs
benchmark(4) #Time difference of 47.56728 secs
benchmark(5) #Time difference of 46.83729 secs #miałem inne procesy w tle chyba, i była walka o dostęp
benchmark(6) #Time difference of 40.31611 secs
benchmark(7) #Time difference of 34.51118 secs
benchmark(8) #Time difference of 34.06393 secs


###################################################
### Zadanie FOREACH1
###################################################

dt = data.table(
  id = 1:100,
  stanowisko = sample(c(
    "prezes",
    rep("dyrektor",4),
    rep("menedzer",20),
    rep("specjalista",75)
  )),
  staz = runif(100,1,39)
)

dt[stanowisko == "prezes", pensja := (runif(1, 20000, 30000) * log(staz+1,7))]
dt[stanowisko == "dyrektor", pensja := (runif(.SD[stanowisko == "dyrektor", .N], 15000, 22000) * log(staz+1,7))]
dt[stanowisko == "menedzer", pensja := (runif(.SD[stanowisko == "menedzer", .N], 8000, 16000) * log(staz+1,7))]
dt[stanowisko == "specjalista", pensja := (runif(.SD[stanowisko == "specjalista", .N], 5000, 14000) * log(staz+1,7))]


# Wykorzystując pakiet foreach oblicz średnie płace
# na danym stanowisku, oraz ich 95%-owe przedziały ufności.
# Wykorzystaj do tego funkcję boot_ci poniżej:

boot_ci <- function (data, FUN, rep = 10000) 
{
  if(length(data) > 1){
    res <- c()
    for (i in 1:rep) {
      d2 <- sample(data, replace = T)
      r <- FUN(d2)
      res <- c(res, r)
    }
    v <- FUN(data)
    q <- quantile(res, probs = c(0.025, 0.975), na.rm = TRUE)
    return(list(min = q[1], val = v, max = q[2], se = sd(res)))
  } else {
    return(list(min = NA, val = data, max = NA, se =NA))
  }
}

boot_ci(1:999, mean)
