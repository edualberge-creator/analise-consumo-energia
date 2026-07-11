source(here::here("R", "funcoes_auxiliares.R"))

importar_dados_brutos <- function(
    caminho = here::here("data", "raw", "household_power_consumption.txt")) {
  verificar_pacotes(c("data.table"))

  if (!file.exists(caminho)) {
    stop(
      "Arquivo de dados nao encontrado em: ", caminho, "\n",
      "Baixe o dataset do UCI e coloque household_power_consumption.txt em data/raw/.",
      call. = FALSE
    )
  }

  data.table::fread(
    caminho,
    sep = ";",
    na.strings = "?",
    stringsAsFactors = FALSE,
    data.table = FALSE
  )
}
