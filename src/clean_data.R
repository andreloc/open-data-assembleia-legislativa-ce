source("web-scrapping.R")

resultado <- criar_tabela_nao_tratados(2015, 2019)

limpar_dados <- function(texto) {
  ## separa em linhas
  texto = str_split(texto,"\n")[[1]]
  ## remove 5 primeiras e 3 últimas linhas
  texto = texto[5:(length(texto)-3)]
  return(texto)
}

### exemplo de como baixar todos resultados do periodo de 2015 a 2019
# resultado <- criar_tabela_nao_trados(ano_inicio = 2015, ano_fim = 2019)
resultado$texto_limp <- limpar_dados(resultado$texto_pdf)
