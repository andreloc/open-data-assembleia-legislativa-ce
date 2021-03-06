## 
## O objetivo desse arquivo e' realizar webscrapping da lista de arquivos de verba
## de desempenho parlamentar. A idéia é obter os arquivos e ler o conteúdo dos PDFs
## https://www.al.ce.gov.br/index.php/transparencia/verba-de-desempenho-parlamentar
##  
## Bibliotecas
## Suporte a leitura de pdfs e conversão para texto
library(pdftools)  ## Necessária a instalação de ferramental no sistema operacional
library(rvest)     ## Biblioteca de webscraping. Simplifica a manipulação de xml e html 
library(stringr)
library(httr)
library(urltools)
library(stringr)

pdf_cache_dir <- "data/temp"

#' como obter esses dados? 
#' Na pagina de desempenho parlametar, inspecionar o html
#' Verificar que ao selecionar um mês e ano, é realizada uma requisição POST 
#' a qual traz a página com a lista com a lista de parlamentares sinalizados naquele mês
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

#' 
#' carrega pagina e extrai apena a lista de parlamentares da página específica
#' 
extrair_lista_de_parlamentares <- function(html_page) {
  html_page %>%
    html_nodes(xpath = "//a[contains(@onclick,'MM_openBrWindow')]") %>% 
    html_text()
}

#' 
#' Cria o padrão de nome de arquivos que serão salvos no disco
#' 
file_names <- function(ano, mes, parlamentar) {
  parlamentar = gsub("[/. ,]","_", parlamentar)
  paste0(getwd(),"/",pdf_cache_dir,"/",ano,"_",mes,"_",parlamentar,".pdf")
}

#'
#' Baixa o arquivo pdf com os gastos do parlamentar no dado ano e mes
#' 
download_demonstrativo_de_gastos <- function(ano, mes, parlamentar) {
  base_url  = "https://www.al.ce.gov.br/paineldecontrole/jumi_transparencia_deputados.php?act=vervdp"
  url       = paste0(base_url,"&f_ano=",ano,"&f_mes=",mes,"&f_dep=",sapply(parlamentar, URLencode)) 
  
  if(!dir.exists(pdf_cache_dir)) {
    dir.create(pdf_cache_dir,showWarnings = T)
  }
  fileName = file_names(ano, mes, parlamentar)
  
  for (i in seq_along(url)) {
    if(file.exists(fileName[i])) {
      print(paste0("File already downloaded: ",fileName[i]))
    } else {
      download.file(url[i], fileName[i], mode = "wb")
    }
  }
  fileName
}

#'
#' Extrai os dados de um determinado mes e cria um dataframe com 
#' 
extrair_dados_do_mes <- function(ano, mes) {
  print(paste0("Extraindo: ", ano, "-", mes))
  html          <- carregar_pagina_por_mes(ano, mes)
  parlamentares <- extrair_lista_de_parlamentares(html)
  if(length(parlamentares) == 0) {
    print("Nenhum parlamentar encontrado!")
    return(data.frame(ano = ano, mes = mes, parlamentar = NA, texto_pdf = NA))
  } 
  
  files <- download_demonstrativo_de_gastos(ano, mes, parlamentares)
  texto_pdf     = sapply(files, pdf_text, USE.NAMES = F)
  data.frame(ano = ano, 
             mes = mes, 
             parlamentar = parlamentares,
             texto_pdf = texto_pdf)
}

#'
#' Cria uma tabela com o período que será explorado 
#' Exemplo:
#' mes, ano 
#' 01, 2018
#' 02, 2018
#' ... 
#' 01, 2019
#' ... 
#' 12, 2019
#'
cria_periodo <- function(ano_inicio, ano_fim) {
  anos    <- ano_inicio:ano_fim               # Anos disponíveis na página
  meses   <- str_pad(1:12, 2, pad = "0")      # Meses numéricos 01 - 12
  expand.grid("mes" = meses, "ano" = anos)    # cria uma tabela com todos anos e meses
}

#' 
#' Percorre os períodos definidos do ano inicial ao final criando um dataframe
#' com o ano, mes, parlametar e texto do pdf
#' 
extrair_tabela_completa <- function(ano_inicio, ano_fim) {
  
  periodos <- cria_periodo(ano_inicio, ano_fim)
  
  # Cria modelo do data frame (tabela)
  tabela_completa <- data.frame(
    ano = character(), 
    mes = character(),
    parlamentar = character(), 
    texto_pdf = character()
  )
  
  for( i in 1:nrow(periodos)) {
    tabela_mes      <- extrair_dados_do_mes(periodos[i, "ano"], 
                                            periodos[i, "mes"])
    tabela_completa <- rbind(tabela_completa, tabela_mes)
  }
  
  tabela_completa
}


