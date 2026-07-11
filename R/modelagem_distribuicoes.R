source(here::here("R", "funcoes_auxiliares.R"))

ajustar_distribuicoes <- function(dados) {
  verificar_pacotes(c("fitdistrplus", "dplyr"))

  x <- dados$Global_active_power
  x <- x[is.finite(x) & x > 0]

  ajustes <- list(
    Normal = fitdistrplus::fitdist(x, "norm"),
    Lognormal = fitdistrplus::fitdist(x, "lnorm"),
    Gamma = fitdistrplus::fitdist(x, "gamma")
  )

  comparacao <- data.frame(
    distribuicao = names(ajustes),
    log_verossimilhanca = vapply(ajustes, function(a) a$loglik, numeric(1)),
    aic = vapply(ajustes, stats::AIC, numeric(1)),
    bic = vapply(ajustes, stats::BIC, numeric(1))
  ) |>
    dplyr::arrange(.data$aic)

  list(
    ajustes = ajustes,
    comparacao = comparacao,
    melhor_modelo = comparacao$distribuicao[1]
  )
}

parametros_modelo <- function(resultado_modelagem) {
  do.call(rbind, lapply(names(resultado_modelagem$ajustes), function(nome) {
    est <- resultado_modelagem$ajustes[[nome]]$estimate
    data.frame(
      distribuicao = nome,
      parametro = names(est),
      estimativa = as.numeric(est),
      row.names = NULL
    )
  }))
}

probabilidade_acima_2kw <- function(dados, resultado_modelagem, limite_kw = 2) {
  melhor <- resultado_modelagem$melhor_modelo
  ajuste <- resultado_modelagem$ajustes[[melhor]]
  pars <- as.list(ajuste$estimate)

  prob_modelo <- switch(
    melhor,
    Normal = stats::pnorm(limite_kw, mean = pars$mean, sd = pars$sd, lower.tail = FALSE),
    Lognormal = stats::plnorm(limite_kw, meanlog = pars$meanlog, sdlog = pars$sdlog, lower.tail = FALSE),
    Gamma = stats::pgamma(limite_kw, shape = pars$shape, rate = pars$rate, lower.tail = FALSE)
  )

  prop_empirica <- mean(dados$Global_active_power > limite_kw, na.rm = TRUE)

  data.frame(
    melhor_modelo = melhor,
    limite_kw = limite_kw,
    probabilidade_modelada = prob_modelo,
    proporcao_empirica = prop_empirica,
    diferenca_modelo_empirico = prob_modelo - prop_empirica
  )
}
