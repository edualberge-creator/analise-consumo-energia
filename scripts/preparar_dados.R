pacotes <- c("here", "data.table", "dplyr", "lubridate", "tidyr")
source("R/funcoes_auxiliares.R")
verificar_pacotes(pacotes)

source(here::here("R", "importar_dados.R"))
source(here::here("R", "preparar_dados.R"))

dados_brutos <- importar_dados_brutos()
resultado_preparacao <- preparar_dados_consumo(dados_brutos)
salvar_dados_processados(resultado_preparacao)

print(resultado_preparacao$log)
