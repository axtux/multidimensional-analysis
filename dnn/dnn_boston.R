#Utilisation du set de Boston
set.seed(500)
library(MASS)
data <- Boston

#Vérification : est-ce qu'il manque des valeurs ?
print(apply(data,2,function(x) sum(is.na(x))))

#Separation des donee de train et de test
alpha <- 0.75
#sample randomize les rangees
index <- sample(1:nrow(data),round(alpha*nrow(data)))
train <- data[index,]
test <- data[-index,]
lm.fit <- glm(medv~., data=train)
summary(lm.fit)
pr.lm <- predict(lm.fit,test)
MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)

#Normalisation de la matrice vers [0,1]
maxs <- apply(data, 2, max) 
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))
train_ <- scaled[index,]
test_ <- scaled[-index,]

#Donnees pretes, on utilise neuralnet
library(neuralnet)

#Entrainement
n <- names(train_)
f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + ")))
#On a donc un raison 13 - 5 - 3 - 1 (car 13 entree, une couche "hidden" de 5, une couche "hidden" de 3 et la sortie)
nn <- neuralnet(f,data=train_,hidden=c(5,3),linear.output=T)
plot(nn)

#Test sur les données restantes
pr.nn <- compute(nn,test_[,1:13])
pr.nn_ <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test_$medv)*(max(data$medv)-min(data$medv))+min(data$medv)
MSE.nn <- sum((test.r - pr.nn_)^2)/nrow(test_)
print(paste(MSE.lm,MSE.nn)) 

#Comparaison du resultat du NN avec la realite
par(mfrow=c(1,2))
plot(test$medv,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
points(test$medv,pr.lm,col='blue',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend=c('NN','LM'),pch=18,col=c('red','blue'))

#Test sur 10 exemples (melange des donnes)
#Pour generer une probabilite sur l'erreur de notre reseau
library(boot)
set.seed(200)
lm.fit <- glm(medv~.,data=data)
cv.glm(data,lm.fit,K=10)$delta[1]

set.seed(450)
cv.error <- NULL
k <- 10

library(plyr) 
pbar <- create_progress_bar('text')
pbar$init(k)

for(i in 1:k){
  alpha = 0.90 #attention, alpha different du precedant!
  index <- sample(1:nrow(data),round(alpha*nrow(data)))
  train.cv <- scaled[index,]
  test.cv <- scaled[-index,]
  nn <- neuralnet(f,data=train.cv,hidden=c(5,2),linear.output=T)
  pr.nn <- compute(nn,test.cv[,1:13])
  pr.nn <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
  test.cv.r <- (test.cv$medv)*(max(data$medv)-min(data$medv))+min(data$medv)
  cv.error[i] <- sum((test.cv.r - pr.nn)^2)/nrow(test.cv)
  pbar$step()
}
print(mean(cv.error))

#Boite a moustache
boxplot(cv.error,xlab='MSE CV',col='cyan',
        border='blue',names='CV error (MSE)',
        main='CV error (MSE) for NN',horizontal=TRUE)
