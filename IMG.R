##############################################################################################
###################################
#CARREGANDO AS IMGS "CHR"

library(imager)
Folder_CHR <- "G:/Photos/CHR"
files_CHR <- list.files(path = Folder_CHR, pattern = "*.jpg", full.names=TRUE)
all_im_CHR <- lapply(files_CHR, load.image )

for(i in 1:length(all_im_CHR)){
  all_im_CHR[[i]]=as.data.frame(grayscale(imresize(all_im_CHR[[i]],1/10)))
}
head(all_im_CHR[[1]])


library(plyr) 
resultados_CHR <- join_all(all_im_CHR,c("x","y")) 
head(resultados_CHR)

library(tidyverse)
resultado_CHR=resultados_CHR %>%
  pivot_longer(-c("x","y"), names_to = "nome", values_to = "var")
resultado_CHR
resultado_CHR$nome="CHR"
resultado_CHR

###################################
#CARREGANDO AS IMGS "BLH"

library(imager)
Folder_BLH <- "G:/Photos/BLH"
files_BLH <- list.files(path = Folder_BLH, pattern = "*.jpg", full.names=TRUE)
all_im_BLH <- lapply(files_BLH, load.image )
for(i in 1:length(all_im_BLH)){
  all_im_BLH[[i]]=as.data.frame(grayscale(imresize(all_im_BLH[[i]],1/10)))
}
head(all_im_BLH[[1]])


library(plyr) 
resultados_BLH <- join_all(all_im_BLH,c("x","y")) 
head(resultados_BLH)

resultado_BLH=resultados_BLH %>%
  pivot_longer(-c("x","y"), names_to = "nome", values_to = "var")
resultado_BLH
resultado_BLH$nome="BLH"
resultado_BLH

##############################################################################################
#COLOCANDO AS IMGS EM UM UNICO DATA FRAME

MIX = as.data.frame(resultado_CHR)
MAX = as.data.frame(resultado_BLH)

for(i in 1:length(MAX[,1])){
  MIX[(length(MAX[,1])+i),] = MAX[i,]
}


MIX=MIX[,-4]

##############################################################################################
#CRIANDO E TESTANDO O MODELO

library(caret)
control <- trainControl(method='cv', number=10)


sample <- createDataPartition(MIX$nome, p=0.85, list=FALSE)

MIX_train <- MIX[sample,]
str(MIX_train)
length(MIX_train[,1])

MIX_test <- MIX[-sample,]
str(MIX_test)
length(MIX_test[,1])

tune.grid <- expand.grid(mtry = 1:(ncol(MIX)-1))
fit.rf <- train(nome~., data=MIX_train, method="rf",tuneGrid =tune.grid,
                trControl=control)

MIX_prediction <- predict(fit.rf, MIX_test)
confusionMatrix(MIX_prediction, as.factor(MIX_test$nome))


##############################################################################################
#TESTANDO O MODELO DE VERDADE

TEST_IMG=load.image("G:/Photos/CHR.jpg")#ESCOLHA ESSA LINHA PARA TESTAR CACHORRO
TEST_IMG=load.image("G:/Photos/BLH.jpg")#ESCOLHA ESSA LINHA PARA TESTAR BOLINHO
plot(TEST_IMG)

TEST_IMG = as.data.frame(grayscale(imresize(TEST_IMG,1/10)))
cor_pix=TEST_IMG$value
TEST_IMG=TEST_IMG[,-3]
TEST_IMG$nome="???"
TEST_IMG$var=cor_pix

MIX_prediction <- predict(fit.rf, TEST_IMG)
data.frame("CHR" = length(MIX_prediction[MIX_prediction=="CHR"])/length(MIX_prediction),"BLH" = length(MIX_prediction[MIX_prediction=="BLH"])/length(MIX_prediction))
