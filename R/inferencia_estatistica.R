source(here::here("R", "funcoes_auxiliares.R"))

inferir_media_potencia <- function(dados, mu0 = 1.10, conf_level = 0.95) {
  teste <- stats::t.test(dados$Global_active_power, mu = mu0, conf.level = conf_level)

  data.frame(
    media_amostral = unname(teste$estimate),
    referencia_kw = mu0,
    limite_inferior = teste$conf.int[1],
    limite_superior = teste$conf.int[2],
    estatistica_t = unname(teste$statistic),
    graus_liberdade = unname(teste$parameter),
    p_valor = teste$p.value
  )
}

comparar_tipo_dia <- function(dados) {
  verificar_pacotes(c("dplyr"))

  dados_grupo <- dados |>
    dplyr::mutate(Tipo_Dia = identificar_tipo_dia(.data$DateTime))

  teste <- stats::t.test(Global_active_power ~ Tipo_Dia, data = dados_grupo)

  medias <- tapply(dados_grupo$Global_active_power, dados_grupo$Tipo_Dia, mean, na.rm = TRUE)
  dif_abs <- unname(medias["Fim de Semana"] - medias["Dia de Semana"])

  data.frame(
    media_dia_de_semana = unname(medias["Dia de Semana"]),
    media_fim_de_semana = unname(medias["Fim de Semana"]),
    diferenca_absoluta_kw = dif_abs,
    diferenca_percentual = dif_abs / unname(medias["Dia de Semana"]) * 100,
    limite_inferior_diferenca = teste$conf.int[1],
    limite_superior_diferenca = teste$conf.int[2],
    estatistica_t = unname(teste$statistic),
    graus_liberdade = unname(teste$parameter),
    p_valor = teste$p.value
  )
}

comparar_medias_diarias <- function(dados) {
  verificar_pacotes(c("dplyr", "lubridate"))

  medias_diarias <- dados |>
    dplyr::mutate(
      Data = as.Date(.data$DateTime),
      Tipo_Dia = identificar_tipo_dia(.data$DateTime)
    ) |>
    dplyr::group_by(.data$Data, .data$Tipo_Dia) |>
    dplyr::summarise(media_diaria_kw = mean(.data$Global_active_power, na.rm = TRUE), .groups = "drop")

  teste <- stats::t.test(media_diaria_kw ~ Tipo_Dia, data = medias_diarias)
  medias <- tapply(medias_diarias$media_diaria_kw, medias_diarias$Tipo_Dia, mean, na.rm = TRUE)
  dif_abs <- unname(medias["Fim de Semana"] - medias["Dia de Semana"])

  list(
    medias_diarias = medias_diarias,
    resumo = data.frame(
      media_dia_de_semana = unname(medias["Dia de Semana"]),
      media_fim_de_semana = unname(medias["Fim de Semana"]),
      diferenca_absoluta_kw = dif_abs,
      diferenca_percentual = dif_abs / unname(medias["Dia de Semana"]) * 100,
      limite_inferior_diferenca = teste$conf.int[1],
      limite_superior_diferenca = teste$conf.int[2],
      estatistica_t = unname(teste$statistic),
      graus_liberdade = unname(teste$parameter),
      p_valor = teste$p.value
    )
  )
}
