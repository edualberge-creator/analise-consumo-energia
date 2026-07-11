pacotes <- c(
  "here",
  "dplyr",
  "lubridate",
  "tidyr",
  "ggplot2",
  "fitdistrplus"
)

source("R/funcoes_auxiliares.R")
verificar_pacotes(pacotes)

source(here::here("R", "analise_descritiva.R"))
source(here::here("R", "inferencia_estatistica.R"))
source(here::here("R", "modelagem_distribuicoes.R"))
source(here::here("R", "gerar_graficos.R"))

caminho_dados <- here::here("data", "processed", "dados_1ano_tratados.csv")
if (!file.exists(caminho_dados)) {
  stop(
    "Arquivo processado nao encontrado. Execute primeiro: source('scripts/preparar_dados.R')",
    call. = FALSE
  )
}

dados <- read.csv(caminho_dados, stringsAsFactors = FALSE)
dados$DateTime <- lubridate::ymd_hms(dados$DateTime, tz = "Europe/Paris")

resumo_descritivo <- analise_descritiva(dados)
resumo_submedicoes <- medias_submedicoes(dados)
ic_media <- inferir_media_potencia(dados)
comparacao_tipo_dia <- comparar_tipo_dia(dados)
comparacao_diaria <- comparar_medias_diarias(dados)
modelagem <- ajustar_distribuicoes(dados)
parametros <- parametros_modelo(modelagem)
probabilidade_2kw <- probabilidade_acima_2kw(dados, modelagem)

salvar_csv(resumo_descritivo, here::here("outputs", "tables", "resumo_descritivo.csv"))
salvar_csv(resumo_submedicoes, here::here("outputs", "tables", "resumo_submedicoes.csv"))
salvar_csv(ic_media, here::here("outputs", "tables", "ic_media_potencia.csv"))
salvar_csv(comparacao_tipo_dia, here::here("outputs", "tables", "comparacao_tipo_dia_minuto.csv"))
salvar_csv(comparacao_diaria$resumo, here::here("outputs", "tables", "comparacao_tipo_dia_diaria.csv"))
salvar_csv(modelagem$comparacao, here::here("outputs", "tables", "comparacao_modelos.csv"))
salvar_csv(parametros, here::here("outputs", "tables", "parametros_modelos.csv"))
salvar_csv(probabilidade_2kw, here::here("outputs", "tables", "probabilidade_acima_2kw.csv"))

gerar_graficos(dados, modelagem)

cat("Analise concluida. Tabelas em outputs/tables e graficos em outputs/figures.\n")
