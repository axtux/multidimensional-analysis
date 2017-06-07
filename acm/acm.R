
# number of kept axes
KEPT_AXES=5
# if true, classes will be created with more or less same quantity ; if false, classes are created with equal range value
QUANTITY_CLASSES = TRUE
# add burt/disjonctif
BURT_DISJONCTIF = TRUE

# install with install.packages("ade4", dep = TRUE)
print("loading ade4...")
library("ade4")

print("changing current direcotry to data...")
script.dir = dirname(sys.frame(1)$ofile)
data.dir = paste(script.dir, "..", "data", sep='/')
setwd(data.dir)

print("reading data file...")
data = read.csv("winequality-red.csv", sep=";")

print("creating classses...")
classes = data.frame(data)
for(n in names(data)) {
  if(QUANTITY_CLASSES) {
    # same number classes, some more inertia
    classes[,n] = cut(data[,n], unique(quantile(data[,n])), include.lowest=TRUE, right=FALSE)
  } else {
    # same interval classes
    classes[,n] = cut(data[,n], 4, include.lowest=TRUE, right=FALSE)
  }
  
  # print classes repartition
  #print(n)
  #print(summary(classes[,n]))
}

print("converting as factor... (required by some ade4 functions)")
for(i in 1:ncol(classes)) {
  classes[, i] = as.factor(classes[, i])
}

print("calculating acm...")
acm = dudi.acm(classes, scannf=FALSE, nf=KEPT_AXES)

# graph of axis inertia
screeplot(acm)
# inertia values
print(summary(acm))

# modality per axis (here 1 and 2)
s.corcircle(acm$co, 1, 2)
# modality repartition
boxplot(acm, 1)
# correlation ratio
barplot(acm$cr[,1], names.arg=row.names(acm$cr), las = 2)
# modalities graph, more precision with clabel=0, arrow with s.arrow
s.label(acm$co, 1, 2)
# variable repartition
s.class(acm$li, as.factor(classes$quality), xax=1)

if(BURT_DISJONCTIF) {
  # burt / disjonctif
  burt = acm.burt(classes, classes)
  disjonctif = acm.disjonctif(classes)
  
  coa.burt = dudi.coa(burt, scannf="FALSE", nf=KEPT_AXES)
  coa.disjonctif = dudi.coa(disjonctif, scannf="FALSE", nf=KEPT_AXES)
  
  scatter(coa.burt)
  scatter(coa.disjonctif)
  
  conts = inertia.dudi(coa.burt)
  print("Contributions et cos^2:")
  print(conts)
}


print("done")
