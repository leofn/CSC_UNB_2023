rm(list=ls()) 
getwd()
#carregando o pacote tm
library(tm)

#Lendo os arquivos do diretorio para criar o Corpus
arquivos <- DirSource(directory = "arquivos-txt/")
arquivos

#Carregando os arquivos e criando um Corpus
corpus <- VCorpus(x=arquivos)
corpus

#Summary dos dados
summary(corpus)

#Observando o primeiro arquivo importado
corpus[[1]]$content

#Elimimando os espaços em branco extras
corpus <- tm_map(corpus,stripWhitespace)
corpus[[1]]$content

#Propriedades do corpus
length(corpus)

show(corpus)

inspect(corpus)

#Alterar tudo para minusculo
corpus[[1]]$content
corpus <- tm_map(corpus, content_transformer(tolower))
corpus[[1]]$content

#Removendo stopwords em inglês
stopwords("english")

corpus <- tm_map(corpus,removeWords,stopwords("english"))
corpus[[1]]$content

#Removendo stopwords em português

lista <- stopwords("portuguese")
#lista 

#class(lista)

lista <- readLines("lista de stopwords Portugues.txt",
                   encoding = "latin1")

corpus <- tm_map(corpus,removeWords,lista)
#Removendo pontuacao
corpus<- tm_map(corpus,removePunctuation)
#Removendo números
#Criando uma função para remover números
removerNumeros = function(texto){
  
  texto = gsub(pattern = "[0-9]+",replacement = " ", x = texto)
  
  texto
  
}

#Aplicando no corpus a funçao de remover numeros
corpus<- tm_map(corpus,content_transformer(removerNumeros))

#Removendo espaços em brancos que podem aparecer
corpus <- tm_map(corpus,stripWhitespace)

#Corpus preparado

#Matriz de frequencia
matriz_termos <- DocumentTermMatrix(corpus)
matriz_termos

############ Treinando Matriz de termos

dim(matriz_termos) # para ver o tamanho da minha matriz
## matriz[posição1-seleciono o artigo, posição2-colunas/termos]
treinamento <- matriz_termos[1:100,]
validar <- matriz_termos[1661,]
posterior(modelo, validar)
########################################################
##########33333  E seu eu quiser remover alguns arquivos
############   do modelo para poder testar

treino = modelo[-c(arq1,arq2,qrq3),]
## Com isso removi três arquivos do modelo
## E agora eu posso testá-lo EM RELAÇÃO ao modelo

validar <-modelo[c(arq1,arq2,qrq3),]

#criando o modelo de tópicos
#Fonte: https://www.tidytextmining.com/topicmodeling.html

library("topicmodels")
#install.packages("https://cran.r-project.org/src/contrib/topicmodels_0.2-9.tar.gz", repos=NULL, type="source")

#Criando o modelo com 2 tópicos
# LDA = algoritmo
############################
# k = número de tópicos, voce pode estimar de acordo com 
# análise crítica dos dados ou usar uma função 
# para saber o valor do k. k = número de tópicos de acordo
# com um conjunto de palavras
###############################
# control = randomizar a escolha da ORDEM de processamento dos 
# artigos 
################################################
# seed = número que trava/ordena a minha aleatoriedade
##############################################
modelo = LDA(matriz_termos, k = 4, control = list(seed = 1234))
modelo

#interpretacao
install.packages("tidytext")
library(tidytext)

## beta e gamma são duas dimensoes do modelo, ver siginficado depois
### Se O RESULTADO DO VALOR DO BETA OU GAMMA FOREM MUITO PRÓXIMOS
### adicione a palavra a stopwords e rode o modelo novamente
topicos <- tidy(modelo, matrix = "beta")
topicos

#criando o grafico
library(ggplot2)
library(dplyr)

top = topicos %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top

#Beta
top %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()


library(tidyr)

vbeta = top %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(log_ratio = log2(topic2 / topic1))

vbeta

#Gamma

documento <- tidy(modelo, matrix = "gamma")
documento

tidy(matriz_termos) %>%
  filter(document == '1002.txt') %>%
  arrange(desc(count))
