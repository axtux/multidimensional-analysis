
# install with install.packages("ade4", dep = TRUE)
print("loading ade4...")
library("ade4")

print("reading data file...")
data = read.csv("~/Downloads/Unif/stat_multi/stat-multi/data/winequality-red.csv", sep=";")

# matrice des corrélations
#print(cor(data))
print(cor(data)[,"quality"])

# centre et réduit (automatique pour acp)
#data = scalewt(data)

pca = dudi.pca(data, scannf=FALSE, nf=3)

# inertie
print(inertia.dudi(pca))
# contribution des variables, corrélation avec les facteurs
print(pca$co)

#scatter(pca)

# contribution des variables à l'inertie
s.arrow(pca$co, xax=1, yax=2)

# cercle des corrélations
s.corcircle(pca$co)

