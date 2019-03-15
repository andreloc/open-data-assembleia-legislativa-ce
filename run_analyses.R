# Requirements
# install.packages("rvest")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("pdftools")
# install.packages("urltools")

source("./src/web-scrapping.R")
source("./src/clean_data.R")

resultado           <- extrair_tabela_completa(ano_inicio = 2015, ano_fim = 2019)
resultado$texto_limp <- limpar_dados(resultado$texto_pdf)