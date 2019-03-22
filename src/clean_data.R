library(dplyr)

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

extrair_gastos_linha <- function(row) {
  gastos <- data.frame(linha_gasto = unlist(row$texto_limp), stringsAsFactors = F)
  char_financeiros = 20
  
  gastos <- gastos %>% 
    mutate( gasto = substr(
      linha_gasto, start = 0, 
      stop = (nchar(linha_gasto) - char_financeiros)
    )) %>% 
    mutate( gasto = trimws(gasto) ) %>% 
    mutate( valor = substr( 
      linha_gasto, 
      start = (nchar(linha_gasto) - char_financeiros), 
      stop = nchar(linha_gasto))
    ) %>% 
    mutate( valor = str_replace(valor, "\\.","") ) %>% 
    mutate( valor = str_replace(valor, ",",".")) %>% 
    mutate( valor = as.numeric(trimws(valor))) %>% 
    select(-c("linha_gasto"))
  
  row <- row %>% select(-c("texto_limp","texto_pdf"))
  merge(row, gastos)
}


extrair_gastos <- function(tabela) {
  dado_tratado <- data.frame(
    ano = numeric(),
    mes = character(),
    parlamentar = character(),
    gasto = character(),
    valor = numeric()
  )
  for( i in 1:nrow(tabela)) {
    dado_tratado <- rbind(dado_tratado, extrair_gastos_linha(resultado[i,]))
  }
  dado_tratado
}




