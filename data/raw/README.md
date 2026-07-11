# Dados brutos

Coloque aqui o arquivo bruto do UCI Machine Learning Repository:

`data/raw/household_power_consumption.txt`

O arquivo esperado usa separador `;` e representa valores ausentes com `?`.
Ele nao deve ser versionado no Git por ser grande e por pertencer a uma fonte externa.

Fonte do dataset:
<https://archive.ics.uci.edu/dataset/235/individual+household+electric+power+consumption>

Depois de baixar e descompactar o dataset, execute:

```r
source("scripts/preparar_dados.R")
source("scripts/executar_analise.R")
```
