# Limitacoes

## Uma unica residencia

Os dados se referem a uma residencia unifamiliar especifica, localizada em
Sceaux, Franca. Os resultados descrevem esse contexto e nao devem ser
generalizados diretamente para todas as residencias.

## Periodo historico analisado

O recorte usado no trabalho cobre um ano, de 16/12/2006 a 16/12/2007. Padroes
de consumo, equipamentos domesticos, tarifas e habitos podem ter mudado desde
esse periodo.

## Amostragem temporal nao aleatoria

A amostra e um bloco temporal continuo, escolhido de forma intencional. Essa
decisao preserva a estrutura temporal, mas nao equivale a uma amostra aleatoria
simples.

## Autocorrelacao minuto a minuto

Medicoes consecutivas de consumo tendem a ser dependentes. Por isso, p-valores
calculados diretamente sobre observacoes minuto a minuto podem aparentar mais
precisao do que existe na pratica. O projeto inclui uma comparacao complementar
com medias diarias para reduzir esse problema.

## Tamanho amostral e valores-p

Com centenas de milhares de observacoes, diferencas numericamente pequenas
podem se tornar estatisticamente significativas. A interpretacao deve separar
significancia estatistica de relevancia pratica.

## Distribuicao marginal

Ajustar uma distribuicao marginal para `Global_active_power` resume a
distribuicao dos valores, mas nao modela diretamente dependencia temporal,
sazonalidade, horarios do dia ou sequencias de uso.

## Variaveis externas ausentes

O dataset nao inclui informacoes meteorologicas, ocupacao da residencia,
tarifas, equipamentos ligados ou comportamento dos moradores. Esses fatores
poderiam explicar parte importante dos picos de consumo.

## Dados ausentes

Linhas com valores ausentes nas variaveis principais sao removidas. Essa
decisao e simples e transparente, mas pode introduzir vies se as ausencias nao
forem aleatorias.
