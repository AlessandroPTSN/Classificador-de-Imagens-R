# Classificador-de-Imagens-R
## Basicamente um código usando Machine Learning para identificação e predição de imagens no R
Foram usadas apenas 11 imagens de uma pessoa A (Neo) e 11 imagens de uma pessoa B (Mel), o codigo importa as imagens (que no teste estavam 240x240) dá um down scale 90% (24x24) e um grayscale (deixa preto e branco) e por fim usa Randon Florest para fazer o modelo de classificação. Com o modelo pronto, ele consegue classificar se na imagem contem Neo ou Mel (mesmo para imagens fora do treinamento/teste) e diz uma porcentagem de acerto/erro.
As 20 imagens foram separadas para treino e teste do modelo e as 2 restantes são usadas para fazer o teste em tempo real.

O código pode ser usado para mais imagens e outros tipos de classificação (como humanos e não humanos, circulos e quadrados, etc).
