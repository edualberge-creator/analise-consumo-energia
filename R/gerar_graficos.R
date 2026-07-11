source(here::here("R", "funcoes_auxiliares.R"))
source(here::here("R", "inferencia_estatistica.R"))
source(here::here("R", "modelagem_distribuicoes.R"))

salvar_grafico <- function(grafico, nome, largura = 9, altura = 6) {
  verificar_pacotes(c("ggplot2"))
  caminho <- here::here("outputs", "figures", nome)
  ggplot2::ggsave(caminho, grafico, width = largura, height = altura, dpi = 300)
  caminho
}

gerar_graficos <- function(dados, resultado_modelagem = NULL) {
  verificar_pacotes(c("dplyr", "ggplot2", "tidyr"))

  dados_tipo <- dados |>
    dplyr::mutate(Tipo_Dia = identificar_tipo_dia(.data$DateTime))

  g_hist <- ggplot2::ggplot(dados, ggplot2::aes(x = .data$Global_active_power)) +
    ggplot2::geom_histogram(bins = 60, fill = "#9ecae1", color = "white") +
    ggplot2::geom_vline(xintercept = mean(dados$Global_active_power), color = "#d7191c", linewidth = 0.8) +
    ggplot2::labs(title = "Histograma da potencia ativa", x = "Potencia ativa (kW)", y = "Frequencia") +
    ggplot2::theme_minimal()

  g_box <- ggplot2::ggplot(dados, ggplot2::aes(y = .data$Global_active_power)) +
    ggplot2::geom_boxplot(fill = "#fdae61", outlier.alpha = 0.25) +
    ggplot2::labs(title = "Boxplot da potencia ativa", x = NULL, y = "Potencia ativa (kW)") +
    ggplot2::theme_minimal()

  g_serie <- ggplot2::ggplot(utils::head(dados, 2000), ggplot2::aes(x = .data$DateTime, y = .data$Global_active_power)) +
    ggplot2::geom_line(color = "#2c7bb6", linewidth = 0.25) +
    ggplot2::labs(title = "Perfil de consumo em aproximadamente 2.000 minutos", x = "Horario", y = "Potencia ativa (kW)") +
    ggplot2::theme_minimal()

  g_tensao <- ggplot2::ggplot(dados, ggplot2::aes(x = .data$Voltage)) +
    ggplot2::geom_histogram(bins = 60, fill = "#b2df8a", color = "white") +
    ggplot2::labs(title = "Distribuicao da tensao", x = "Tensao (V)", y = "Frequencia") +
    ggplot2::theme_minimal()

  sub_long <- dados |>
    dplyr::select(.data$Sub_metering_1, .data$Sub_metering_2, .data$Sub_metering_3) |>
    tidyr::pivot_longer(dplyr::everything(), names_to = "submedicao", values_to = "energia_wh") |>
    dplyr::mutate(
      setor = dplyr::recode(
        .data$submedicao,
        Sub_metering_1 = "Cozinha",
        Sub_metering_2 = "Lavanderia",
        Sub_metering_3 = "Climatizacao"
      )
    )

  g_sub_box <- ggplot2::ggplot(sub_long, ggplot2::aes(x = .data$setor, y = .data$energia_wh, fill = .data$setor)) +
    ggplot2::geom_boxplot(outlier.alpha = 0.15) +
    ggplot2::labs(title = "Comparacao de consumo por setor", x = NULL, y = "Energia por minuto (Wh)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none")

  sub_total <- sub_long |>
    dplyr::group_by(.data$setor) |>
    dplyr::summarise(total_wh = sum(.data$energia_wh, na.rm = TRUE), .groups = "drop")

  g_sub_total <- ggplot2::ggplot(sub_total, ggplot2::aes(x = .data$setor, y = .data$total_wh, fill = .data$setor)) +
    ggplot2::geom_col(color = "gray20") +
    ggplot2::labs(title = "Consumo total acumulado no ano", x = NULL, y = "Total (Wh)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none")

  g_tipo <- ggplot2::ggplot(dados_tipo, ggplot2::aes(x = .data$Tipo_Dia, y = .data$Global_active_power, fill = .data$Tipo_Dia)) +
    ggplot2::geom_boxplot(outlier.shape = NA) +
    ggplot2::coord_cartesian(ylim = stats::quantile(dados$Global_active_power, c(0, 0.99), na.rm = TRUE)) +
    ggplot2::labs(title = "Consumo: dias uteis vs. fim de semana", x = NULL, y = "Potencia ativa (kW)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none")

  ic <- inferir_media_potencia(dados)
  g_ic <- ggplot2::ggplot(ic, ggplot2::aes(x = 1, y = .data$media_amostral)) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = .data$limite_inferior, ymax = .data$limite_superior), width = 0.08) +
    ggplot2::geom_point(color = "#2b6cb0", size = 3) +
    ggplot2::labs(title = "Intervalo de confianca de 95% para a media", x = NULL, y = "Potencia ativa (kW)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_blank())

  caminhos <- c(
    salvar_grafico(g_hist, "01_histograma_potencia_ativa.png"),
    salvar_grafico(g_box, "02_boxplot_potencia_ativa.png"),
    salvar_grafico(g_serie, "03_serie_temporal_2000_minutos.png"),
    salvar_grafico(g_tensao, "04_distribuicao_tensao.png"),
    salvar_grafico(g_sub_box, "05_boxplot_submedicoes.png"),
    salvar_grafico(g_sub_total, "06_consumo_acumulado_submedicoes.png"),
    salvar_grafico(g_tipo, "07_dias_uteis_vs_fim_semana.png"),
    salvar_grafico(g_ic, "08_intervalo_confianca_media.png")
  )

  if (!is.null(resultado_modelagem)) {
    x <- dados$Global_active_power
    x <- x[is.finite(x) & x > 0]
    dens <- data.frame(x = seq(min(x), stats::quantile(x, 0.999), length.out = 500))
    pars_norm <- as.list(resultado_modelagem$ajustes$Normal$estimate)
    pars_lnorm <- as.list(resultado_modelagem$ajustes$Lognormal$estimate)
    pars_gamma <- as.list(resultado_modelagem$ajustes$Gamma$estimate)
    dens$Normal <- stats::dnorm(dens$x, mean = pars_norm$mean, sd = pars_norm$sd)
    dens$Lognormal <- stats::dlnorm(dens$x, meanlog = pars_lnorm$meanlog, sdlog = pars_lnorm$sdlog)
    dens$Gamma <- stats::dgamma(dens$x, shape = pars_gamma$shape, rate = pars_gamma$rate)

    dens_long <- tidyr::pivot_longer(dens, -x, names_to = "distribuicao", values_to = "densidade")
    g_ajustes <- ggplot2::ggplot(data.frame(Global_active_power = x), ggplot2::aes(x = .data$Global_active_power)) +
      ggplot2::geom_histogram(ggplot2::aes(y = after_stat(density)), bins = 80, fill = "white", color = "gray40") +
      ggplot2::geom_line(data = dens_long, ggplot2::aes(x = .data$x, y = .data$densidade, color = .data$distribuicao), linewidth = 0.9) +
      ggplot2::labs(title = "Comparacao de ajustes: histograma vs. modelos", x = "Potencia ativa (kW)", y = "Densidade", color = "Modelo") +
      ggplot2::theme_minimal()

    caminhos <- c(caminhos, salvar_grafico(g_ajustes, "09_ajuste_distribuicoes.png"))
  }

  invisible(caminhos)
}
