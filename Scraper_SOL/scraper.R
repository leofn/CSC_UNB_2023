rm(list = ls())
library(rvest)
library(tidyverse)
library(glue)

#### PATH
path_base <- "https://repositorio.unb.br/handle/10482/826?offset=XXX"
### df vazio
df <- data.frame()
## sequencia de paginas 
seq <- seq(0,200,20)
## loop para pegar os links em uma pagina
for(i in seq){
  print(i)
  path <- gsub("XXX", i, path_base)
  href <- read_html(path) %>% 
  rvest::html_nodes(xpath = "//strong/a") %>% 
  html_attr("href")
  df <- rbind(df, cbind(href))
  }

## links completos para cada tese/dissertação
links <- df$href
links <- paste("https://repositorio.unb.br", links, sep = "")

### loop para pegar os links das teses/dissertações 

df2 <- data.frame()

for (j in links) {
 pdf <- read_html(j) %>% 
  rvest::html_nodes("a") %>% 
  html_attr("href") %>% 
  as_tibble() %>% 
  filter(str_detect(value, "bitstream")) %>% 
  distinct() %>% 
  pull()
### link completo para o pdf
pdf_full <- paste("https://repositorio.unb.br", pdf, sep = "")
print(pdf_full)


### tentando manter o mesmo título

download.file(url = glue("{pdf_full}"), destfile = "Downloads/")
 




