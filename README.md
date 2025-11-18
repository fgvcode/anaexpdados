# Análise Exploratória de Dados

## Trabalho Final: Análise Estatística e Exploratória com R do grupo 1

Objetivo do Projeto

Este repositório contém os códigos-fonte e o relatório final referente ao trabalho prático das disciplinas de Análise Exploratória de Dados com R e Probabilidade e Estatística com R.

O projeto visa aplicar técnicas de Estatística Descritiva, Inferencial (Testes de Hipóteses) e Modelagem de Regressão Linear, utilizando a linguagem de programação R para todas as análises.

## Sumário
* [Instalação](#instalacao)
* [Questões](#questões)


# Instalação
Instalação do R e RStudio
Para começar, você precisará instalar o software R (o motor estatístico) e o RStudio (a interface de desenvolvimento recomendada).

R Base (Windows)
Acesse o CRAN (Comprehensive R Archive Network) para Windows.
Clique em "Download R X.X.X for Windows" (onde X.X.X é a versão mais recente).
Execute o instalador e siga as instruções padrão.

R Base (Linux - Ubuntu/Debian)
Abra o terminal e execute os comandos:


#### 1. Adicione o repositório CRAN (importante para atualizações)

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
```

#### 2. Instale o R
```bash
sudo apt install r-base r-base-dev
```
---

#### 3. Dependências em R

Para a execução correta do script, é necessário ter o ambiente R configurado e os seguintes pacotes instalados:

| Pacote | Função Principal |
| :--- | :--- |
| `readxl` | Leitura da base de dados `.xlsx`. |
| `ggplot2` | Geração de gráficos avançados para análise exploratória. |
| `dplyr` | Manipulação e transformação de dados. |
| `lmtest` | Testes de hipóteses para modelos de regressão (ex: Teste de Breusch-Pagan). |
| `car` | Funções para diagnóstico em regressão, como VIF para multicolinearidade. |

#### 4. Instalação dos Pacotes

Execute os comandos abaixo no console do R ou RStudio:

```r
# Instalação dos pacotes
install.packages(c("readxl", "ggplot2", "dplyr", "lmtest", "car"))

# Carregamento dos pacotes para uso no início do script .R
library(readxl)
library(ggplot2)
library(dplyr)
library(lmtest)
library(car)
```

# Questões para Análise

#### 1. Média de Score de Periculosidade (Teste t de 1 Amostra)

Podemos afirmar que o **score médio de periculosidade é superior a 170 pontos**?

* Nível de significância: **5%** ($\alpha = 0,05$).
* Resultado adicional: Intervalo de confiança de **95%** caso a média seja significativamente maior que 170.

#### 2. Comparação de Tempo Médio de Prisão (Teste t de 2 Amostras)

Podemos afirmar que o **tempo médio de prisão entre homens e mulheres é igual**?

* Nível de significância: **5%** ($\alpha = 0,05$).
* Resultado adicional: Intervalo de confiança de **95%** para a diferença caso os tempos médios sejam significativamente diferentes.

#### 3. Correlação (Teste de Hipótese para $\rho$)

**Existe correlação** entre o **tempo de prisão** e o **score de periculosidade**?

* Nível de significância: **5%** ($\alpha = 0,05$).
* Apresente o valor do **coeficiente de correlação** ($r$).

#### 4. Relação entre Sexo e Reincidência (Teste Qui-quadrado)

**Há relação** entre o **sexo** e a **reincidência** dos indivíduos?

* Nível de significância: **5%** ($\alpha = 0,05$).
* Apresente o **teste estatístico utilizado** (provavelmente o Qui-quadrado de Independência).

#### 5. Modelo de Regressão Inicial

Ajuste um **modelo de regressão linear múltipla** para o **score de periculosidade**, considerando **todas as variáveis explicativas disponíveis**.

* Avalie as suposições de **normalidade** e **homoscedasticidade** dos resíduos.
* **Interprete os coeficientes estimados** ($\beta_i$).
* Qual o **percentual de explicação do modelo** ($R^2$)?
* Nível de significância: **5%** ($\alpha = 0,05$).

#### 6. Seleção de Variáveis e Novo Modelo

Realize um processo de **seleção de variáveis** (ex: *stepwise*, *forward* ou *backward*) a partir do modelo ajustado no item anterior.

* Para o **novo modelo**, repita as checagens dos pressupostos (**normalidade** e **homoscedasticidade** dos resíduos).
* Repita a **interpretação dos resultados** (coeficientes, $R^2$, etc.).
