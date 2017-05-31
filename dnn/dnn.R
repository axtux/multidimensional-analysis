library(deepnet)

###Tentative de creer un reseau de neurones avec deepnet, mais c'est un echec
### Toujours les memes valeurs de sorties, ou aleatoire. Cela provient soit de nn.train
### Soit de mes données. Elles correspondent à un conseil trouvé sur un forum et aucune
### Info n'est donnée sur deepnet. Peut-être un bug du coup. Changement de librairie
### Du coup on utilise pas ce fichier



####### Chargement du fichier et normalization pour le DNN ############
size <- 15000000
sinmat = matrix(1:size,size,2)
sinmat =t(apply(sinmat, 1, function(x) x/size*2*pi))
sinmat[,2] <- t(apply(sinmat, 1, function(x) sin(x)))[,2]
enq <- sinmat
enq <- enq[sample(nrow(enq)),] 

####### Séparation de l'ensemble d'entrainement et de test ###########
alpha <- 0.90 #pourcentage dédié à l'entrainement
a <- floor(alpha * size)
enqTrain = enq[1:a,]
enqTest = enq[(a+1):size,]
enqParam = as.matrix(enqTrain[,1])
enqObj = as.matrix(enqTrain[,2])
enqParamTest = as.matrix(enqTest[,1])
enqObjTest = as.matrix(enqTest[,2])

####### Entrainement via le plugin deepnet (qui implemente la theorie de DNN) ##########
model = nn.train(enqParam, enqObj, hidden = c(4), activationfun = "sigm")

#######                           Test de nos valeurs                         #########
y <- enqObjTest
y_p <- nn.predict(model, enqParamTest)
m <- nrow(enqParamTest)
error_count <- sum(abs(y_p - y))/2
error_count <- error_count / m

######              Tentatives de prédictions pour un nouveau vin            #########
t1 <- data.frame(3.151592)#-0.8011526
t2 <- data.frame(0)#0.8689658
score1 <- nn.predict(model, t1)
score2 <- nn.predict(model, t2)