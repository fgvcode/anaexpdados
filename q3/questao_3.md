
```{r setup, include=TRUE, message=FALSE}
# Carregamento da planilha Base_trabalho.xlsx e pacotes necessários

library(readxl)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(patchwork)

# Carrega a base
dados <- read_excel("Base_trabalho.xlsx")

# Converte variáveis categóricas para fatores (Tratamento de Dados, conforme análise prévia)
dados <- dados |> 
  mutate(
    sexo = factor(x = sexo,
                    levels = c(0, 1), 
                    labels = c("Masculino", "Feminino")),
    filhos = factor(x = filhos, 
                         levels = c(0, 1), 
                         labels = c("Não", "Sim")),
    escolaridade = factor(x = escolaridade,
                  levels = c(1, 2, 3), 
                  labels = c("Fundamental","Médio", "Superior")),
    casado = factor(x = casado, 
                    levels = c(0, 1), 
                    labels = c("Não", "Sim"))
  )
