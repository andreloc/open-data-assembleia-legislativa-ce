## 
## O objetivo desse arquivo e' realizar webscrapping da lista de arquivos de verba
## de desempenho parlamentar. A idéia é obter os arquivos e ler o conteúdo dos PDFs
## https://www.al.ce.gov.br/index.php/transparencia/verba-de-desempenho-parlamentar
## 
## Bibliotecas
## Suporte a leitura de pdfs e conversão para texto
library(pdftools)  ## Necessária a instalação de ferramental no sistema operacional
library(rvest)     ## Biblioteca de webscraping. Simplifica a manipulação de xml e html 
library(dplyr)     ## Biblioteca auxiliar para chamada de métodos e consultas de forma mais semantica
library(stringr)
library(httr)
library(urltools)

anos    <- 2019:2019                    # Anos disponíveis na página
meses   <- str_pad(1:12, 2, pad = "0")  # Meses numéricos 01 - 12
periodo <- expand.grid("meses" = meses, "anos" = anos)
pdf_cache_dir <- "cache/pdf_files"

# como obter esses dados? 
# Na pagina de desempenho parlametar, inspecionar o html
# Verificar que ao selecionar um mês e ano, é realizada uma requisição POST 
# a qual traz a página com a lista com a lista de parlamentares sinalizados naquele mês
carregar_pagina_por_mes <- function(ano, mes) {
  url <- "https://www.al.ce.gov.br/index.php/transparencia/verba-de-desempenho-parlamentar"
  form_data <- list(
    act   = "vp2",
    f_ano = ano,
    f_mes = mes,
    bt1   = "Prosseguir" 
  )
  post_result <- POST(url, body=form_data, encode="form")
  read_html(post_result)
}

# 
# 
# 
extrair_lista_de_parlamentares <- function(html_page) {
  html_page %>%
    html_nodes(xpath = "//a[contains(@onclick,'MM_openBrWindow')]") %>% 
    html_text()
}

file_names <- function(ano,mes,parlamentar) {
  parlamentar = gsub("[/. ]","_", parlamentar)
  paste0(pdf_cache_dir,"/",ano,"_",mes,"_",parlamentar,".pdf")
}

download_demonstrativo_de_gastos <- function(ano, mes, parlamentar) {
  base_url  = "https://www.al.ce.gov.br/paineldecontrole/jumi_transparencia_deputados.php?act=vervdp"
  url       = paste0(base_url,"&f_ano=",ano,"&f_mes=",mes,"&f_dep=",sapply(parlamentar, URLencode)) 
  if(!dir.exists(pdf_cache_dir)) {
    dir.create(pdf_cache_dir,showWarnings = T)
  }
  fileName = file_names(ano, mes, parlamentar)
  ifelse(file.exists(fileName),
         print(paste0("File already downloaded: ",fileName)),
         download.file(url,fileName))
  lapply(fileName, pdf_text)
}

executar <- function(ano, mes) {
    print(paste0("Extraindo: ",ano,"-",mes))
    html          <- carregar_pagina_por_mes(ano, mes)
    parlamentares <- extrair_lista_de_parlamentares(html)
    if(length(parlamentares) == 0) {
      print("Nenhum parlamentar encontrado!")
      return()
    }
    download_demonstrativo_de_gastos(ano, mes, parlamentares)
}

