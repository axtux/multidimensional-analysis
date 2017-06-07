
# change current direcotry to data
script.dir = dirname(sys.frame(1)$ofile)
data.dir = paste(script.dir, "..", "data", sep='/')
setwd(data.dir)

# number of kept axes
nf=5

print("reading data file...")
data = read.csv("winequality-red.csv", sep=";")

# min, max and mean
print(summary(data))

classes = data.frame(data)
for(n in names(data)) {
  # same interval classes
  classes[,n] = cut(data[,n], 5, include.lowest=TRUE, right=FALSE)
  
  # same number classes
  classes[,n] = cut(data[,n], unique(quantile(data[,n])), include.lowest=TRUE, right=FALSE)
  
  print(n)
  print(summary(classes[,n]))
}
