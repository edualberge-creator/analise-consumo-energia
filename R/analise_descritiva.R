source(here::here("R", "funcoes_auxiliares.R"))
source(here::here("R", "preparar_dados.R"))

analise_descritiva <- function(dados) {
  verificar_pacotes(c("dplyr"))

  resumo <- lapply(variaveis_numericas, function(var) {
    cbind(variavel = var, calcular_resumo(dados[[var]]))
  })

  dplyr::bind_rows(resumo)
}

medias_submedicoes <- function(dados) {
  data.frame(
    setor = c("Cozinha", "Lavanderia", "Climatizacao"),
    variavel = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
    media_wh_por_minuto = colMeans(dados[, c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")], na.rm = TRUE),
    total_wh = colSums(dados[, c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")], na.rm = TRUE)
  )
}
