library(FactoMineR)
data = read.csv("../data/winequality-red.csv", sep=";")
#data <- data[1:100,]
res.pca = PCA(data, scale.unit=TRUE, ncp=5, quanti.sup=c(12), graph=T) 
#decathlon: le tableau de données utilisé
#scale.unit: pour choisir de réduire ou non les variables
#ncp: le nombre de dimensions à garder dans les résultats
#quanti.sup: vecteur des index des variables continues illustratives
#graph: pour choisir de faire apparaître les graphiques ou non

#plot.PCA(res.pca, axes=c(1, 2), choix="ind")
desc <- dimdesc(res.pca, axes=c(1,2))
print(desc)
