source(here::here("R", "funcoes_auxiliares.R"))

variaveis_numericas <- c(
  "Global_active_power",
  "Global_reactive_power",
  "Voltage",
  "Global_intensity",
  "Sub_metering_1",
  "Sub_metering_2",
  "Sub_metering_3"
)

preparar_dados_consumo <- function(
    dados,
    inicio = "16/12/2006 17:24:00",
    fim = "16/12/2007 17:24:00") {
  verificar_pacotes(c("dplyr", "lubridate", "tidyr"))

  linhas_importadas <- nrow(dados)
  duplicados_antes <- sum(duplicated(dados))

  dados_preparados <- dados |>
    dplyr::mutate(
      DateTime = criar_datetime(.data$Date, .data$Time),
      dplyr::across(dplyr::all_of(variaveis_numericas), as.numeric)
    )

  inicio_dt <- lubridate::dmy_hms(inicio, tz = "Europe/Paris")
  fim_dt <- lubridate::dmy_hms(fim, tz = "Europe/Paris")

  dados_preparados <- dados_preparados |>
    dplyr::filter(.data$DateTime >= inicio_dt, .data$DateTime <= fim_dt) |>
    dplyr::arrange(.data$DateTime)

  linhas_intervalo <- nrow(dados_preparados)
  dados_preparados <- dplyr::distinct(dados_preparados)
  duplicados_removidos <- linhas_intervalo - nrow(dados_preparados)

  dados_preparados <- tidyr::drop_na(dados_preparados, dplyr::all_of(variaveis_numericas), .data$DateTime)
  validar_nao_negativo(dados_preparados, variaveis_numericas)

  log_preparacao <- data.frame(
    linhas_importadas = linhas_importadas,
    linhas_no_intervalo = linhas_intervalo,
    duplicados_detectados_antes_filtro = duplicados_antes,
    duplicados_removidos_no_intervalo = duplicados_removidos,
    linhas_removidas_por_na_ou_fora_intervalo = linhas_importadas - nrow(dados_preparados),
    linhas_mantidas = nrow(dados_preparados)
  )

  list(dados = dados_preparados, log = log_preparacao)
}

salvar_dados_processados <- function(resultado_preparacao) {
  salvar_csv(resultado_preparacao$dados, here::here("data", "processed", "dados_1ano_tratados.csv"))
  salvar_csv(resultado_preparacao$log, here::here("outputs", "tables", "log_preparacao.csv"))
  invisible(resultado_preparacao)
}
