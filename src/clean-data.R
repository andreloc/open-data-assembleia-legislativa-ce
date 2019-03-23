library(dplyr)

#' 
#' Remove cabeçalho e rodapé do arquivo para que se trate apenas o 
#' texto que contém as informações de gasto 
#' 
remove_cabecalho_rodape <- function(texto) {
  ## separa em linhas
  texto <- sapply(texto, str_split, "\n")
  
  ## remove 5 primeiras e 3 últimas linhas
  lapply(texto, function(x) {
    if( length(x) > 7) {
      x[5:(length(x)-3)]
    } else {
      ""
    }
  })
}

char_financeiros = 20

#' 
#' Transforma linha de gastos textuais em um texto descritivo 
#' sem espaços à esquerda e à direita. 
#' 
transformar_descricao_gasto <- function(gastos) {
  gastos %>% 
    mutate( gasto = substr(
      linha_gasto, start = 0, 
      stop = (nchar(linha_gasto) - char_financeiros)
    )) %>% 
    mutate( gasto = trimws(gasto) )
}

#' 
#' Transforma linha de gasto textual em um valor financeiro decimal
#' 
transformar_valor_gasto <- function(gastos) {
  gastos %>% mutate( valor = substr( 
    linha_gasto, 
    start = (nchar(linha_gasto) - char_financeiros), 
    stop = nchar(linha_gasto))
  ) %>% 
    mutate( valor = str_replace(valor, "\\.","") ) %>% 
    mutate( valor = str_replace(valor, ",",".")) %>% 
    mutate( valor = as.numeric(trimws(valor)))
}

#' 
#' Extrai todos custos transoformando-os em uma tabela na qual há 
#' uma linha por registro de gasto. 
#' 
#' 
transformar_gastos_linha <- function(row) {
  gastos <- data.frame(linha_gasto = unlist(row$texto_limp), stringsAsFactors = F)
  char_financeiros = 20
  
  gastos <- transformar_descricao_gasto(gastos)
  gastos <- transformar_valor_gasto(gastos)
  
  gastos %>% select(-c("linha_gasto"))                  # remove coluna linha_gasto
  row <- row %>% select(-c("texto_limp","texto_pdf"))   # remove coluna texto_limp e texto_pdf
  
  merge(row, gastos)
}

#' 
#' Cria uma nova resultado, na qual há um registro de gasto individualizado 
#' por linha 
#' 
transformar_tabela_gastos <- function(resultado) {
  
  resultado$texto_limp <- remove_cabecalho_rodape(resultado$texto_pdf)
  
  dado_tratado <- data.frame(
    ano = numeric(),
    mes = character(),
    parlamentar = character(),
    gasto = character(),
    valor = numeric()
  )
  
  for( i in 1:nrow(resultado)) {
    dado_tratado <- rbind(dado_tratado, transformar_gastos_linha(resultado[i,]))
  }
  
  dado_tratado
}




