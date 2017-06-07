# install with install.packages("ade4", dep = TRUE)
library("ade4")

print("reading data file...")
data = read.csv("../data/winequality-white-virg.csv", sep=";")

print("dudi.acm requires factors, converting...")
data2 = as.data.frame(data)
for(i in 1:ncol(data)) {
  data2[, i] = as.factor(data[, i])
}

print("calculating acm...")
acm = dudi.acm(data2, scannf=FALSE)
screeplot(acm)

#burt = acm.burt(data2)

print("done")
