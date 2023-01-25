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
## loop para pegar os links nas diversas paginas
for(i in seq){
  print(i)
  path <- gsub("XXX", i, path_base)
  href <- read_html(path) %>% 
  rvest::html_nodes(xpath = "//strong/a") %>% 
  html_attr("href")
  df <- rbind(df, cbind(href))
  }

#write.csv(df, "./Scraper_SOL/df.csv")
## links completos para cada tese/dissertação
links <- df$href
links <- paste("https://repositorio.unb.br", links, sep = "")

# loop para links do pdf, titulos das teses/dissertações e download 

### df vazio
df2 <- data.frame()

for (j in links) {
  pdf <- read_html(j) %>% 
  rvest::html_nodes("a") %>% 
  html_attr("href") %>% 
  as_tibble() %>% 
  filter(str_detect(value, "bitstream")) %>% 
  distinct() %>% 
  pull()
  print(pdf)
  ### titulo
  titulo <- read_html(j) %>% 
    html_nodes(".dc_title") %>% 
    html_text2() 
  titulo <- titulo[2] %>% 
    str_remove_all(" ") %>% 
    stringr::str_squish() %>%
    stringr::str_trim() %>%
    stringr::str_remove_all("[:punct:]") %>%
    stringr::str_to_lower()  %>% 
    stringi::stri_trans_general(id = "Latin-ASCII")
    # download
    download.file(url = glue("https://repositorio.unb.br/{pdf}"), 
                destfile = glue("Downloads/{titulo}.pdf"), mode = "wb")
    df2 <- rbind(df2, cbind(pdf, titulo))
  }





 




