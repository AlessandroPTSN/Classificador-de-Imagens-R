##############################################################################################
###################################
#CARREGANDO AS IMGS "NEO"

library(imager)
Folder_Neo <- "C:/Users/T-Gamer/Desktop/Photos/Neo"
files_Neo <- list.files(path = Folder_Neo, pattern = "*.jpg", full.names=TRUE)
all_im_Neo <- lapply(files_Neo, load.image )

for(i in 1:length(all_im_Neo)){
  all_im_Neo[[i]]=as.data.frame(grayscale(imresize(all_im_Neo[[i]],1/10)))
}
head(all_im_Neo[[1]])


library(plyr) 
resultados_Neo <- join_all(all_im_Neo,c("x","y")) 
head(resultados_Neo)

library(tidyverse)
resultado_Neo=resultados_Neo %>%
  pivot_longer(-c("x","y"), names_to = "nome", values_to = "var")
resultado_Neo
resultado_Neo$nome="Neo"
resultado_Neo

###################################
#CARREGANDO AS IMGS "Mel"

library(imager)
Folder_Mel <- "C:/Users/T-Gamer/Desktop/Photos/Mel"
files_Mel <- list.files(path = Folder_Mel, pattern = "*.jpg", full.names=TRUE)
all_im_Mel <- lapply(files_Mel, load.image )
for(i in 1:length(all_im_Mel)){
  all_im_Mel[[i]]=as.data.frame(grayscale(imresize(all_im_Mel[[i]],1/10)))
}
head(all_im_Mel[[1]])


library(plyr) 
resultados_Mel <- join_all(all_im_Mel,c("x","y")) 
head(resultados_Mel)

resultado_Mel=resultados_Mel %>%
  pivot_longer(-c("x","y"), names_to = "nome", values_to = "var")
resultado_Mel
resultado_Mel$nome="Mel"
resultado_Mel

##############################################################################################
#COLOCANDO AS IMGS EM UM UNICO DATA FRAME

MIX = as.data.frame(resultado_Neo)
MAX = as.data.frame(resultado_Mel)

for(i in 1:length(MAX[,1])){
  MIX[(length(MAX[,1])+i),] = MAX[i,]
}


MIX=MIX[,-4]

##############################################################################################
#CRIANDO E TESTANDO O MODELO

library(caret)
control <- trainControl(method='cv', number=10)
metric <- 'Accuracy'

sample <- createDataPartition(MIX$nome, p=0.85, list=FALSE)

MIX_train <- MIX[sample,]
str(MIX_train)
length(MIX_train[,1])

MIX_test <- MIX[-sample,]
str(MIX_test)
length(MIX_test[,1])

tune.grid <- expand.grid(mtry = 1:(ncol(MIX)-1))
fit.rf <- train(nome~., data=MIX_train, method="rf",tuneGrid =tune.grid,
                trControl=control)#,metric=metric)

MIX_prediction <- predict(fit.rf, MIX_test)
confusionMatrix(MIX_prediction, as.factor(MIX_test$nome))


##############################################################################################
#TESTANDO O MODELO DE VERDADE

TEST_IMG=load.image("C:/Users/T-Gamer/Desktop/Photos/IMG0022A.jpg")
plot(TEST_IMG)

TEST_IMG = as.data.frame(grayscale(imresize(TEST_IMG,1/10)))
cor_pix=TEST_IMG$value
TEST_IMG=TEST_IMG[,-3]
TEST_IMG$nome="???"
TEST_IMG$var=cor_pix

MIX_prediction <- predict(fit.rf, TEST_IMG)
data.frame("Neo" = length(MIX_prediction[MIX_prediction=="Neo"])/length(MIX_prediction) ,"Mel" = length(MIX_prediction[MIX_prediction=="Mel"])/length(MIX_prediction))
