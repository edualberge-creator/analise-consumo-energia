verificar_pacotes <- function(pacotes) {
  ausentes <- pacotes[!vapply(pacotes, requireNamespace, logical(1), quietly = TRUE)]
  if (length(ausentes) > 0) {
    stop(
      "Pacotes ausentes: ", paste(ausentes, collapse = ", "),
      ". Instale-os antes de executar a analise.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

criar_datetime <- function(data, hora) {
  lubridate::dmy_hms(paste(data, hora), tz = "Europe/Paris")
}

identificar_tipo_dia <- function(datetime) {
  dia <- lubridate::wday(datetime, week_start = 1)
  ifelse(dia %in% c(6, 7), "Fim de Semana", "Dia de Semana")
}

validar_nao_negativo <- function(dados, variaveis) {
  invalidas <- variaveis[vapply(variaveis, function(var) {
    any(dados[[var]] < 0, na.rm = TRUE)
  }, logical(1))]

  if (length(invalidas) > 0) {
    stop(
      "Valores negativos encontrados nas variaveis: ",
      paste(invalidas, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

calcular_resumo <- function(vetor) {
  vetor <- vetor[!is.na(vetor)]
  media <- mean(vetor)

  data.frame(
    n = length(vetor),
    media = media,
    mediana = median(vetor),
    desvio_padrao = stats::sd(vetor),
    variancia = stats::var(vetor),
    minimo = min(vetor),
    q1 = as.numeric(stats::quantile(vetor, 0.25, names = FALSE)),
    q3 = as.numeric(stats::quantile(vetor, 0.75, names = FALSE)),
    maximo = max(vetor),
    iqr = stats::IQR(vetor),
    cv_percentual = ifelse(media == 0, NA_real_, stats::sd(vetor) / media * 100)
  )
}

salvar_csv <- function(objeto, caminho) {
  dir.create(dirname(caminho), recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(objeto, caminho, row.names = FALSE, fileEncoding = "UTF-8")
  invisible(caminho)
}
