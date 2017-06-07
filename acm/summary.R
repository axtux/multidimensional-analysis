
print("reading data file...")
data = read.csv("../data/winequality-red.csv", sep=";")

# min, max and mean
print(summary(data))

# print 32 classes to help identify classes limits
classes = data.frame(data)
for(n in names(data)) {
  # Brooks-Carruthers formula classes = 5 * log(length(data), 10)
  
  # same interval classes
  classes[,n] = cut(data[,n], 5, include.lowest=TRUE, right=FALSE)
  
  # same number classes
  classes[,n] = cut(data[,n], unique(quantile(data[,n])), include.lowest=TRUE, right=FALSE)
  
  print(n)
  print(summary(classes[,n]))
}



