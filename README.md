# Classificador-de-Imagens-R
## Basicamente um código usando Machine Learning para identificação e predição de imagens no R
![images](https://user-images.githubusercontent.com/50224653/71328744-e031b780-24fa-11ea-9400-959b57875e9c.png)

Foram usadas apenas 8 imagens de bolinhos e 8 imagens de cachorros, o código importa as imagens (que no teste estavam 240x240) dá um down scale 90% (24x24) e um grayscale (deixa preto e branco) e por fim usa Randon Florest para fazer o modelo de classificação. Com o modelo pronto, ele consegue classificar se na imagem contem cachorro ou bolinho (mesmo para imagens fora do treinamento/teste) e diz uma porcentagem de acerto/erro.

As 16 imagens foram separadas para treino e teste do modelo e as 2 restantes são usadas para fazer o teste em tempo real.
Devido ao número extremamente pequeno de imagens, as imagens de teste em tempo real foram escolhidas para melhor expressar os resultados do modelo.

O código pode ser usado para mais imagens e outros tipos de classificação (como humanos e não humanos, identificar pessoas diferentes, etc).
