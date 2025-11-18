#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado) para resolução da Questão 3
#
# Aluno(s): [grupo 1]
#################################################################


# --- PASSO 0: PREPARAÇÃO, CARREGAMENTO DE PACOTES E DADOS ---

# 1. Carregar pacotes necessários para leitura, manipulação e testes
library(readxl) 
library(dplyr) 
library(ggplot2)
library(ggpubr)
library(patchwork)

# 2. Carregar a planilha na memória do R
dados <- read_excel("Base_trabalho.xlsx")

# 3. Tratamento de variáveis categóricas (Necessário para a base completa)
# Converção de binárias e categóricas para fatores, conforme a análise do HTML.
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
# QUESTÃO 3: Correlação entre tempo de prisão e score de periculosidade?
#################################################################

# Pergunta: Existe correlação entre o tempo de prisão e o score de periculosidade?
# Nível de Significância (Alpha): 0.05

# --- 3.1. Análise de Pressupostos (Normalidade) ---
# O Teste de Pearson exige que as variáveis sejam aproximadamente normais.

# a) Visualização da normalidade (QQ-plots)
qq1 <- ggqqplot(dados$tempo_preso)
qq2 <- ggqqplot(dados$score_periculosidade)

# Exibição conjunta
qq1 + qq2 

# b) Teste formal de Shapiro-Wilk para 'tempo_preso'
shapiro.test(x = dados$tempo_preso) # p-value = 0.4003

# c) Teste formal de Shapiro-Wilk para 'score_periculosidade'
shapiro.test(x = dados$score_periculosidade) # p-value = 0.7738

# Conclusão de Pressupostos:
# Como ambos os p-valores (0.4003 e 0.7738) são maiores que 0.05, 
# falhamos em rejeitar a hipótese nula de normalidade. 
# O Teste de Correlação de Pearson é o procedimento estatístico adequado.


# --- 3.2. Teste de Correlação de Pearson ---

# Hipóteses:
# H₀ (Hipótese Nula): Não há correlação (P = 0)
# H₁ (Hipótese Alternativa): Há correlação (P != 0)

# a) Gráfico de dispersão para avaliar a relação visualmente
ggplot(data = dados,
       mapping = aes(x = tempo_preso,
                     y = score_periculosidade)) +
  geom_point() +
  labs(y = "Score de Periculosidade", x = "Tempo de Prisão (meses)") +
  theme_minimal()

# b) Execução do Teste de Correlação de Pearson (bilateral)
cor.test(x = dados$tempo_preso,
         y = dados$score_periculosidade,
         method = "pearson",
         alternative = "two.sided",
         conf.level = 0.95)


# --- 3.3. Conclusão da Questão 3 ---
#
# O teste retornou um p-valor < 2.2e-16 e um coeficiente de correlação (r) de 0.8037558.
# Como p-valor (< 2.2e-16) < alpha (0.05), REJEITAMOS H₀.
#
# Resposta: SIM, existe correlação estatisticamente significativa entre
# o tempo de prisão e o score de periculosidade. O coeficiente de correlação
# de Pearson é r ≈ 0.804, indicando uma correlação forte e positiva.
#
################### FIM DA QUESTÃO 3 ###################
