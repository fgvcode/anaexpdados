#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado) para resolução da QUESTÃO 5 (Regressão Múltipla)
#
# Questão 5: Ajuste um modelo de regressão para o score de periculosidade,
# considerando todas as variáveis explicativas disponíveis. Avalie as suposições
# de normalidade e homoscedasticidade dos resíduos e interprete os coeficientes
# estimados. Qual o percentual de explicação do modelo? Utilize um nível de
# significância de 5%.
#
# Aluno(s): [grupo 1]
#################################################################


# --- PASSO 0: PREPARAÇÃO, CARREGAMENTO DE PACOTES E DADOS ---

# 1. Carregar pacotes necessários
# (Caso algum pacote não esteja instalado, use install.packages("nome_do_pacote"))
library(readxl)   # Para ler arquivos .xlsx
library(dplyr)    # Para manipulação de dados
library(ggplot2)  # Para gráficos de AED e diagnóstico
library(ggpubr)   # Para funções gráficas adicionais (opcional)
library(patchwork) # Para combinar gráficos (opcional)
library(car)      # Para VIF (multicolinearidade)
library(olsrr)    # Para testes de pressupostos (Breusch-Pagan)


# 2. Carregar a planilha na memória do R
# Certifique-se de que o arquivo 'Base_trabalho.xlsx' está no seu diretório de trabalho
dados <- read_excel("Base_trabalho.xlsx")


# 3. Tratamento de variáveis categóricas
# Converte variáveis categóricas/binárias em fatores para que o modelo lm()
# as interprete corretamente como variáveis dummy.
dados <- dados |> 
  mutate(
    sexo = factor(x = sexo,
                    levels = c(0, 1), 
                    labels = c("Masculino", "Feminino")), # Masculino = referência
    filhos = factor(x = filhos, 
                         levels = c(0, 1), 
                         labels = c("Não", "Sim")), # Não = referência
    escolaridade = factor(x = escolaridade,
                  levels = c(1, 2, 3), 
                  labels = c("Fundamental","Médio", "Superior")), # Fundamental = referência
    casado = factor(x = casado, 
                    levels = c(0, 1), 
                    labels = c("Não", "Sim")) # Não = referência
  )


# --- PASSO 4: ANÁLISE EXPLORATÓRIA DE DADOS (AED) PARA QUESTÃO 5 ---
# Realizar AED prévia conforme as instruções gerais do trabalho.

# 4.1. Resumo estatístico da variável resposta
cat("Resumo Estatístico da Variável Resposta (Score de Periculosidade):\n")
print(summary(dados$score_periculosidade))

# 4.2. Visualização de Relações (Amostra)

# Exemplo A: Boxplot - Relação entre uma categórica (Escolaridade) e a resposta
g_escolaridade <- ggplot(dados, aes(x = escolaridade, y = score_periculosidade, fill = escolaridade)) +
  geom_boxplot() +
  labs(title = "Score de Periculosidade por Escolaridade", y = "Score") +
  theme(legend.position = "none")

# Exemplo B: Scatter Plot - Relação entre uma quantitativa (Tempo de Prisão) e a resposta
g_tempo <- ggplot(dados, aes(x = tempo_preso, y = score_periculosidade)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Score vs. Tempo de Prisão (Associação Linear)", x = "Tempo de Prisão")

# Combina os gráficos para visualização rápida (opcional)
print(g_escolaridade + g_tempo)


#################################################################
# QUESTÃO 5: MODELO DE REGRESSÃO MÚLTIPLA
#################################################################

# --- 5.1. Ajuste do Modelo de Regressão ---

# Ajusta o modelo completo, onde '.' inclui todas as outras variáveis na base 'dados'.
modelo_completo <- lm(score_periculosidade ~ ., data = dados)


# --- 5.2. Avaliação e Interpretação do Modelo ---

# a) Sumário e Interpretação dos Coeficientes
cat("\n--- 5.2.a) Sumário Completo do Modelo ---\n")
summary_modelo <- summary(modelo_completo)
print(summary_modelo)

# b) Percentual de Explicação (R-squared Ajustado)
R2_ajustado <- summary_modelo$adj.r.squared
cat("\nPercentual de Explicação (R-squared Ajustado):", 
    round(R2_ajustado * 100, 2), "%\n")
# Este valor deve ser reportado no relatório como o poder explicativo do modelo.

# c) Teste de Multicolinearidade (VIF - Opcional, mas crucial)
cat("\n--- 5.2.c) VIF (Multicolinearidade) ---\n")
# VIFs acima de 5 ou 10 sugerem problemas de colinearidade.
vif_resultado <- vif(modelo_completo)
print(vif_resultado)


# --- 5.3. Avaliação dos Pressupostos (Resíduos) ---
# A validade das inferências depende da satisfação destes testes.

# a) Normalidade dos Resíduos (H0: Os resíduos são normalmente distribuídos)
cat("\n--- 5.3.a) Teste de Normalidade ---\n")

# i. QQ-Plot (Visual)
# O ideal é que os pontos sigam a linha diagonal.
qqnorm(modelo_completo$residuals)
qqline(modelo_completo$residuals)

# ii. Teste de Shapiro-Wilk (Formal)
teste_shapiro <- shapiro.test(modelo_completo$residuals)
print(teste_shapiro)
# Se p-valor > 0.05, aceita-se H0 (Normalidade).

# b) Homocedasticidade (H0: A variância dos resíduos é constante)
cat("\n--- 5.3.b) Teste de Homocedasticidade ---\n")

# i. Gráfico de Resíduos vs. Valores Ajustados (Visual)
# O gráfico deve mostrar uma dispersão aleatória, sem padrão ou forma de funil.
plot(modelo_completo, which = 1) 

# ii. Teste Formal de Breusch-Pagan
teste_bp <- ols_test_breusch_pagan(modelo_completo)
print(teste_bp)
# Se p-valor > 0.05, aceita-se H0 (Homocedasticidade).


################### FIM DA QUESTÃO 5 ###################
