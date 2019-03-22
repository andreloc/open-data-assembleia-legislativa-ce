# Requirements
# install.packages("rvest")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("pdftools")
# install.packages("urltools")

source("./src/web-scrapping.R")
source("./src/clean_data.R")

resultado            <- extrair_tabela_completa(ano_inicio = 2019, ano_fim = 2019)
resultado$texto_limp <- remove_cabecalho_rodape(resultado$texto_pdf)

dados_limpos <- extrair_gastos(resultado)
