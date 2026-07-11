# Metodologia

Este projeto reorganiza, em formato reproduzivel, o trabalho academico
"Analise estatistica aplicada ao perfil de consumo de energia residencial".
A analise usa o dataset "Individual household electric power consumption", do
UCI Machine Learning Repository.

## Recorte temporal

A base original contem medicoes minuto a minuto entre dezembro de 2006 e
novembro de 2010. O trabalho academico selecionou uma amostra temporal
continua de um ano:

- inicio: 16/12/2006 17:24:00;
- fim: 16/12/2007 17:24:00.

Essa escolha preserva a ordem temporal dos dados, permitindo observar padroes
diarios, semanais e sazonais. A amostragem nao e aleatoria: trata-se de uma
amostragem temporal intencional.

## Tratamento de dados ausentes

O arquivo bruto usa `?` para valores ausentes. Na preparacao, esses valores sao
convertidos para `NA`. Em seguida, as linhas com ausencia nas variaveis
numericas principais ou em `DateTime` sao removidas. O log salvo em
`outputs/tables/log_preparacao.csv` registra quantas linhas foram importadas,
filtradas, removidas e mantidas.

## Analise descritiva

Para as variaveis quantitativas principais, sao calculados:

- quantidade de observacoes;
- media;
- mediana;
- desvio padrao;
- variancia;
- minimo e maximo;
- quartis;
- intervalo interquartil;
- coeficiente de variacao.

A potencia ativa global recebe destaque porque representa a demanda instantanea
total da residencia em kW.

## Intervalo de confianca

O intervalo de confianca de 95% para a media de `Global_active_power` e obtido
por teste t de uma amostra. O intervalo estima a faixa plausivel para a media
populacional sob as condicoes observadas na amostra.

## Testes de hipotese

O teste t bilateral de uma amostra compara a media da potencia ativa com o valor
de referencia de 1,10 kW, conforme usado no trabalho original.

Tambem e aplicado um teste t de Welch para comparar a potencia ativa entre dias
uteis e fins de semana. O teste de Welch e usado porque nao exige variancias
iguais entre os grupos.

## Comparacao com medias diarias

Como as medicoes minuto a minuto apresentam dependencia temporal, o projeto
inclui uma comparacao complementar baseada em medias diarias. Essa abordagem
reduz a influencia da autocorrelacao minuto a minuto e ajuda a interpretar a
relevancia pratica da diferenca entre grupos.

## Maxima verossimilhanca

As distribuicoes Normal, Lognormal e Gamma sao ajustadas por maxima
verossimilhanca usando `fitdistrplus::fitdist`. Os parametros sao extraidos
diretamente dos objetos ajustados.

## AIC e BIC

Os modelos sao comparados por log-verossimilhanca, AIC e BIC. Valores menores
de AIC e BIC indicam melhor equilibrio entre aderencia aos dados e complexidade
do modelo.

## Distribuicao Lognormal

O trabalho original selecionou a Lognormal porque o consumo de energia e
assimetrico, estritamente positivo e concentrado em valores baixos com cauda a
direita. O codigo deste repositorio seleciona automaticamente o melhor modelo
com base no AIC calculado nos dados disponiveis.

## Probabilidade de excedencia

Depois de escolhido o melhor modelo, calcula-se a probabilidade modelada de
`Global_active_power > 2 kW`. O projeto tambem calcula a proporcao empirica de
observacoes acima de 2 kW e a diferenca entre estimativa modelada e dado
observado.
