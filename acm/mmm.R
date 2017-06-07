
print("reading data file...")
data = read.csv("../data/winequality-red.csv", sep=";")

for(n in names(data)) {
  p = paste(n, " : min is ", min(data[,n]), ", max is ", max(data[,n]), ", mean is ", mean(data[,n]))
  print(p)
}
