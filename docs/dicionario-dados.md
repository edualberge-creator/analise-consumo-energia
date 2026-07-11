# Dicionario de dados

| Variavel | Significado | Unidade | Tipo | Utilizacao na analise |
|---|---|---:|---|---|
| `Date` | Data da medicao | dia/mes/ano | temporal/texto bruto | Combinada com `Time` para criar `DateTime` |
| `Time` | Hora da medicao | hora:minuto:segundo | temporal/texto bruto | Combinada com `Date` para criar `DateTime` |
| `DateTime` | Instante completo da medicao | data-hora | temporal | Ordenacao, recorte temporal, series e grupos por dia |
| `Global_active_power` | Potencia ativa global da residencia | kW | quantitativa continua | Principal variavel de interesse; descritiva, inferencia e modelagem |
| `Global_reactive_power` | Potencia reativa global | kW | quantitativa continua | Analise descritiva da qualidade/uso de energia reativa |
| `Voltage` | Tensao media por minuto | V | quantitativa continua | Avaliacao da estabilidade do fornecimento |
| `Global_intensity` | Corrente global | A | quantitativa continua | Analise descritiva da demanda eletrica |
| `Sub_metering_1` | Energia ativa da cozinha | Wh por minuto | quantitativa continua | Comparacao de submedicoes e consumo acumulado |
| `Sub_metering_2` | Energia ativa da lavanderia | Wh por minuto | quantitativa continua | Comparacao de submedicoes e consumo acumulado |
| `Sub_metering_3` | Energia ativa de climatizacao/aquecimento de agua | Wh por minuto | quantitativa continua | Comparacao de submedicoes e consumo acumulado |
| `Tipo_Dia` | Classificacao em dia util ou fim de semana | categoria | qualitativa nominal | Teste de Welch e comparacoes de consumo |

Observacao: as submedicoes estao em Wh por minuto, enquanto
`Global_active_power` esta em kW. O projeto evita converter uma unidade na
outra sem explicitar a operacao necessaria.
