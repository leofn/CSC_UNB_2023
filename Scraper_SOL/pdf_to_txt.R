#limpando a memoria do R
rm(list=ls())
#bibliotecas utilizadas
require(pdftools)
require(tm)
#Lendo os arquivos do diretorio para criar o Corpus
arquivos <- DirSource()
arquivos

#Convertendo cada arquivos de pdf para txt
for(i in 1:length(arquivos)){
  
  #abrindo o arquivo pdf
  temp = pdf_text(arquivos[i])
  
  #determinando o nome do arquivo
  nome = paste("arquivos-txt/",i,".txt",sep="")
  
  #gravando o arquivo em disco
  write(x = temp,file = nome)
  
  #imprimindo o indice, isso causa lentidao
  print(i)
  
}



