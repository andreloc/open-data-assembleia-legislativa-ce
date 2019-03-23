# Requirements
# install.packages("rvest")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("pdftools")
# install.packages("urltools")
# install.packages("revealjs)

source("./src/web-scrapping.R") # Métodos para extração
source("./src/clean-data.R")    # Métodos para limpeza 

resultado     <- extrair_tabela_completa(ano_inicio = 2019, ano_fim = 2019)

dados_limpos  <- transformar_tabela_gastos(resultado)
