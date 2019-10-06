# Napisz funckję, która będzie obliczać wartość pierwiastka metodą iteracyjnych przybliżeń.
#
#
# 
# Algorytm działa natępująco:
# x - wartość do spierwiastkowania
# prec - oczekiwana precyzja przebliżenia wartości
# 1. Jako początkowe przybliżenie (est) przyjmij jakąś dodatnią wartość 
# 2. v = x / est
# 3. Nowe est = (v + est) / 2
# 4. Jeżeli różnica między starą i nową wartością est jest większa niż prec, wróc do kroku 2
# 5. W innym przypadku zwróć nową wartość est, jako przybliżenie wartości pierwiastka x
#
#
#
#
# Np.
# dla x = 16
# przyjmijmy est = 1, prec = 0.001
# Iteracja 1:
#  v = 16/1 = 16
#  nowa est = (16+1)/2 = 8.5
#  różnica 7.5 - większa niż 0.001, więc robimy kolejny krok
# Iteracja 2:
#  v = 16/8.5 = ~1.8823
#  nowa est = (~1.8823+8.5)/2 = ~5.1911
#  różnica ~3.3088 - większa niż 0.001, więc robimy kolejny krok
# Iteracja 3:
#  v = 16/~5.1911 = ~3.0822
#  nowa est = (~3.0822+~5.1911)/2 = ~4.1367
#  różnica ~1.0545 - większa niż 0.001, więc robimy kolejny krok
# Iteracja 4:
#  v = 16/~4.1367 = ~3.8679
#  nowa est = (~3.8679+~4.1367)/2 = ~4.0023
#  różnica ~0.1344 - większa niż 0.001, więc robimy kolejny krok
# Iteracja 5:
#  v = 16/~4.0023 = ~3.9977
#  nowa est = (~3.9977+~4.0023)/2 = ~4.0000006
#  różnica ~0.0023 - większa niż 0.001, więc robimy kolejny krok
# Iteracja 6:
#  v = 16/~4.0000006 = ~3.9999994
#  nowa est = (~3.9999994+~4.0000006)/2 = ~4.00000000000005
#  różnica ~0.0000006 - mniejsza niż 0.001, kończymy
# zwracamy ~4.00000000000005 jako wartość pierwiastka z 


pierwiastek <- function(x, est = 1, prec = 0.001){
  # Wasz kod
}