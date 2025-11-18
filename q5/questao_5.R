#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado) para resolução da Questão 5 (Regressão Múltipla)
#
# Aluno(s): [grupo 1]
#################################################################


# --- PASSO 0: PREPARAÇÃO, CARREGAMENTO DE PACOTES E DADOS ---

# 1. Carregar pacotes necessários
library(readxl) 
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(patchwork)
# Pacotes adicionais comuns para Regressão
library(car)      # Para VIF (multicolinearidade)
library(olsrr)    # Para testes de pressupostos (Homocedasticidade)


# 2. Carregar a planilha na memória do R
dados <- read_excel("Base_trabalho.xlsx")


# 3. Tratamento de variáveis categóricas
# (Converte variáveis categóricas/binárias em fatores)
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


#################################################################
# QUESTÃO 5: Modelo de Regressão Múltipla
#################################################################

# --- 5.1. Ajuste do Modelo de Regressão ---

# Ajusta o modelo de regressão, onde score_periculosidade é a resposta (Y) 
# e o ponto ('.') representa todas as outras variáveis explicativas (X's).
modelo_completo <- lm(score_periculosidade ~ ., data = dados)


# --- 5.2. Avaliação e Interpretação do Modelo ---

# a) Sumário e Interpretação dos Coeficientes
summary(modelo_completo)

# b) Teste de Multicolinearidade (VIF - Opcional)
vif(modelo_completo)


# --- 5.3. Avaliação dos Pressupostos (Resíduos) ---

# a) Normalidade dos Resíduos 
# i. QQ-Plot
qqnorm(modelo_completo$residuals)
qqline(modelo_completo$residuals)

# ii. Teste de Shapiro-Wilk (H0: Normalidade)
shapiro.test(modelo_completo$residuals)


# b) Homocedasticidade (Variância Constante)
# O gráfico de Resíduos vs. Valores Ajustados
plot(modelo_completo, which = 1) 

# Teste Formal de Breusch-Pagan (H0: Homocedasticidade)
ols_test_breusch_pagan(modelo_completo)


################### FIM DA QUESTÃO 5 ###################
