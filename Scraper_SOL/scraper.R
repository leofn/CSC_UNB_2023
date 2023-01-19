library(rvest)
library(tidyverse)


i <- seq(0,200,20)

urlbase <- "https://repositorio.unb.br/handle/10482/826?offset=0"

# Use the read_html function to read the website
html <- read_html("https://repositorio.unb.br/handle/10482/826?offset=0")

webpage <- xml2::read_html(urlbase)
# Extract the URLs
url <- html %>%
  rvest::html_nodes(xpath = "//strong/a") %>%
  rvest::html_attr("href")

url2 <- paste("https://repositorio.unb.br", url, sep = "")

html2 <- read