limpar_dados <- function(texto) {
  ## separa em linhas
  texto = str_split(texto,"\n")[[1]]
  ## remove 5 primeiras e 3 últimas linhas
  texto = texto[5:(length(texto)-3)]
  return(texto)
}

