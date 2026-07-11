library(testthat)
library(lubridate)

source(file.path("R", "funcoes_auxiliares.R"))
source(file.path("R", "preparar_dados.R"))

test_that("criar_datetime combina data e hora", {
  dt <- criar_datetime("16/12/2006", "17:24:00")
  expect_equal(format(dt, "%Y-%m-%d %H:%M:%S"), "2006-12-16 17:24:00")
})

test_that("identificar_tipo_dia separa fim de semana", {
  datas <- lubridate::ymd_hms(c("2006-12-16 10:00:00", "2006-12-18 10:00:00"), tz = "Europe/Paris")
  expect_equal(identificar_tipo_dia(datas), c("Fim de Semana", "Dia de Semana"))
})

test_that("preparar_dados_consumo remove valores ausentes", {
  dados <- data.frame(
    Date = c("16/12/2006", "16/12/2006"),
    Time = c("17:24:00", "17:25:00"),
    Global_active_power = c("1.0", NA),
    Global_reactive_power = c("0.1", "0.1"),
    Voltage = c("240", "240"),
    Global_intensity = c("4", "4"),
    Sub_metering_1 = c("0", "0"),
    Sub_metering_2 = c("0", "0"),
    Sub_metering_3 = c("1", "1")
  )

  resultado <- preparar_dados_consumo(dados, "16/12/2006 17:24:00", "16/12/2006 17:25:00")
  expect_equal(nrow(resultado$dados), 1)
})

test_that("validar_nao_negativo rejeita valores negativos", {
  dados <- data.frame(Global_active_power = c(0.1, -1))
  expect_error(validar_nao_negativo(dados, "Global_active_power"), "Valores negativos")
})

test_that("calcular_resumo retorna estatisticas basicas", {
  resumo <- calcular_resumo(c(1, 2, 3, 4))
  expect_equal(resumo$n, 4)
  expect_equal(resumo$media, 2.5)
  expect_equal(resumo$mediana, 2.5)
  expect_true("cv_percentual" %in% names(resumo))
})
