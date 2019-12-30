# Classificador-de-Imagens-R
## Basicamente um código usando Machine Learning para identificação e predição de imagens no R
![images](https://user-images.githubusercontent.com/50224653/71328744-e031b780-24fa-11ea-9400-959b57875e9c.png)

Foram usadas apenas 8 imagens de bolinhos e 8 imagens de cachorros, o código importa as imagens (que no teste estavam 240x240).
```R
library(imager)
Folder_CHR <- "G:/Photos/CHR"
files_CHR <- list.files(path = Folder_CHR, pattern = "*.jpg", full.names=TRUE)
all_im_CHR <- lapply(files_CHR, load.image )
plot(all_im_CHR[[1]])
```
![aa](https://user-images.githubusercontent.com/50224653/71566911-2c03d400-2a9a-11ea-93fa-6d59170fad9b.png)

```R
library(imager)
Folder_BLH <- "G:/Photos/BLH"
files_BLH <- list.files(path = Folder_BLH, pattern = "*.jpg", full.names=TRUE)
all_im_BLH <- lapply(files_BLH, load.image )
plot(all_im_BLH[[1]])
```
![bb](https://user-images.githubusercontent.com/50224653/71566912-2c03d400-2a9a-11ea-8971-c9c953d032f9.png)

Dá um down scale 90% (24x24) e um grayscale (deixa preto e branco).
```R
for(i in 1:length(all_im_CHR)){
  all_im_CHR[[i]]=as.data.frame(grayscale(imresize(all_im_CHR[[i]],1/10)))
}
head(all_im_CHR[[1]])
plot(as.cimg(all_im_CHR[[1]]))
```
![a](https://user-images.githubusercontent.com/50224653/71566908-2c03d400-2a9a-11ea-9494-71e9fb64196a.png)
```R
for(i in 1:length(all_im_BLH)){
  all_im_BLH[[i]]=as.data.frame(grayscale(imresize(all_im_BLH[[i]],1/10)))
}
head(all_im_BLH[[1]])
plot(as.cimg(all_im_BLH[[1]]))
```
![b](https://user-images.githubusercontent.com/50224653/71566910-2c03d400-2a9a-11ea-938e-f986b67d70a9.png)

E por fim usa Randon Florest para fazer o modelo de classificação. 
```R
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
```
```R
          Reference
Prediction BLH CHR
       BLH 679 341
       CHR 401 739
                                         
               Accuracy : 0.6565         
                 95% CI : (0.636, 0.6765)
    No Information Rate : 0.5            
    P-Value [Acc > NIR] : < 2e-16  
```
Com o modelo pronto, ele consegue classificar se na imagem contem cachorro ou bolinho (mesmo para imagens fora do treinamento/teste) e diz uma porcentagem de acerto/erro.
```R
TEST_IMG=load.image("G:/Photos/CHR.jpg")#ESCOLHA ESSA LINHA PARA TESTAR CACHORRO
MIX_prediction <- predict(fit.rf, TEST_IMG)
data.frame("CHR" = length(MIX_prediction[MIX_prediction=="CHR"])/length(MIX_prediction),"BLH" = length(MIX_prediction[MIX_prediction=="BLH"])/length(MIX_prediction))
```
![x](https://user-images.githubusercontent.com/50224653/71567079-45595000-2a9b-11ea-9b0a-7a678f4d1e40.png)
```R
        CHR       BLH
1 0.6188889 0.3811111
```


```R
TEST_IMG=load.image("G:/Photos/BLH.jpg")#ESCOLHA ESSA LINHA PARA TESTAR BOLINHO
MIX_prediction <- predict(fit.rf, TEST_IMG)
data.frame("CHR" = length(MIX_prediction[MIX_prediction=="CHR"])/length(MIX_prediction),"BLH" = length(MIX_prediction[MIX_prediction=="BLH"])/length(MIX_prediction))
```
![y](https://user-images.githubusercontent.com/50224653/71567080-45595000-2a9b-11ea-8d29-83927a75ffaf.png)
```R
        CHR       BLH
1 0.3177778 0.6822222
```

As 16 imagens foram separadas para treino e teste do modelo e as 2 restantes são usadas para fazer o teste em tempo real.
Devido ao número extremamente pequeno de imagens, as imagens de teste em tempo real foram escolhidas para melhor expressar os resultados do modelo.

O código pode ser usado para mais imagens e outros tipos de classificação (como humanos e não humanos, identificar pessoas diferentes, etc).
