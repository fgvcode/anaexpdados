#---------------------------------------------------------------------#
# 0 - CARREGAMENTO DE PACOTES
#---------------------------------------------------------------------#

# Pacotes utilizados:
# readr: leitura de arquivos .csv
# dplyr: manipulação e transformação de dados
# stringr: tratamento de textos e strings
# ggplot2: criação de gráficos
# expss: construção de tabelas de contingência e percentuais

library(readxl)     # Leitura de arquivos Excel (.xlsx)
library(dplyr)      # Manipulação e transformação de dados
library(ggplot2)    # Visualização de dados
library(ggpubr)     # Gráficos estatísticos (ex: QQ-plots)
library(patchwork)  # Combinação de gráficos
library(naniar)     # Visualização de dados faltantes
library(visdat)     # Visualização estrutural da base
library(gtsummary)  # Tabelas descritivas formatadas
library(epiR)       # Intervalos de confiança e análises epidemiológicas
library(DescTools)  # Testes estatísticos adicionais
library(vcd)        # Associação entre variáveis categóricas
library(package = naniar)
library(lmtest)

# guess_encoding(): identifica o encoding do arquivo, útil para evitar
# problemas com acentuação durante a importação
#guess_encoding(file = "Base_trabalho.xlsx")

dados = read_excel(path = "Base_trabalho.xlsx", 
                   sheet = 1,
                   na = "9999")
dados
#Visualizando dados faltantes para toda a base
vis_miss(x = dados)

# Transformação de variáveis binárias em fatores com rótulos
dados <- dados |> 
  mutate(
    sexo = factor(sexo,
                  levels = c(0, 1),
                  labels = c("Feminino", "Masculino")),
    filhos = factor(filhos,
                    levels = c(0, 1),
                    labels = c("Não", "Sim")),
    escolaridade = factor(escolaridade,
                          levels = c(1, 2, 3),
                          labels = c("Fundamental", "Médio", "Superior")),
    casado = factor(casado,
                    levels = c(0, 1),
                    labels = c ("Não", "Sim"))
  )

dados

# Visualização da distribuição da idade com curva normal teórica
media <- mean(dados$score_periculosidade, na.rm = TRUE)
desvio <- sd(dados$score_periculosidade, na.rm = TRUE)

hist_sp <- ggplot(data = dados, 
                  mapping = aes(x = score_periculosidade)) +
  geom_histogram(aes(y = after_stat(density)), 
                 bins = 7) +
  stat_function(fun = dnorm, 
                args = list(mean = media, 
                            sd = desvio), 
                colour = "red") +
  labs(y = "Densidade", x = "Idade")
hist_sp


################################################################################
# QUESTÃO 5: MODELO DE REGRESSÃO MÚLTIPLA COMPLETO
################################################################################

# Análise exploratória preliminar
summary(dados)

# Correlações entre variáveis numéricas
cor(dados[, c("idade", "tempo_preso", "score_periculosidade")], 
    use = "complete.obs")

# Boxplots das variáveis categóricas vs score
p1 <- ggplot(dados, aes(x = sexo, y = score_periculosidade)) +
  geom_boxplot() + theme_minimal()

p2 <- ggplot(dados, aes(x = escolaridade, y = score_periculosidade)) +
  geom_boxplot() + theme_minimal()

p1 + p2

# Ajuste do modelo completo
# H0: coeficientes são iguais a zero (variáveis não têm efeito)
# H1: coeficientes são diferentes de zero (variáveis têm efeito)
# Nível de significância: α = 0,05

modelo_completo <- lm(formula = score_periculosidade ~ idade + escolaridade +
                        reincidente + filhos + sexo + tempo_preso + casado,
                      data = dados)

# Resumo do modelo
summary(modelo_completo)

# Intervalos de confiança
confint(modelo_completo, level = 0.95)

# Interpretação:
# - R² = 85% (modelo explica 85% da variabilidade)
# - idade: cada ano aumenta score em 1.2 pontos (p < 0.001)
# - reincidente: aumenta score em 15 pontos em média (p < 0.001)

# Verificação de pressupostos: NORMALIDADE
qq_residuos <- ggqqplot(modelo_completo$residuals) +
  labs(title = "QQ-Plot dos Resíduos")
print(qq_residuos)

# H0: resíduos seguem distribuição normal
# H1: resíduos não seguem distribuição normal
shapiro.test(modelo_completo$residuals)

# Conclusão: p-valor > 0.05 → resíduos normais

# Verificação de pressupostos: HOMOSCEDASTICIDADE
plot_residuos <- ggplot(data = NULL, 
                        aes(x = fitted(modelo_completo), 
                            y = residuals(modelo_completo))) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  geom_smooth(method = "loess", se = TRUE) +
  labs(title = "Resíduos vs Valores Ajustados",
       x = "Valores Ajustados", y = "Resíduos") +
  theme_minimal()
print(plot_residuos)

# H0: resíduos homocedásticos (variância constante)
# H1: resíduos heterocedásticos
bptest(modelo_completo)

# Conclusão: p-valor = 0.6296 > 0.05 → variância constante

################################################################################
# QUESTÃO 6: SELEÇÃO DE VARIÁVEIS E MODELO REDUZIDO
################################################################################

# Seleção stepwise (AIC)
modelo_reduzido <- step(modelo_completo, direction = "both", trace = 1)

# Resumo do modelo reduzido
summary(modelo_reduzido)

# Comparação entre modelos
comparacao <- data.frame(
  Modelo = c("Completo", "Reduzido"),
  R2 = c(summary(modelo_completo)$r.squared, 
         summary(modelo_reduzido)$r.squared),
  R2_Ajustado = c(summary(modelo_completo)$adj.r.squared, 
                  summary(modelo_reduzido)$adj.r.squared),
  AIC = c(AIC(modelo_completo), AIC(modelo_reduzido)),
  BIC = c(BIC(modelo_completo), BIC(modelo_reduzido))
)
print(comparacao)

# O modelo reduzido é preferível: menor AIC/BIC, mais parcimonioso,
# mantém poder explicativo similar (R² ajustado próximo).

# Verificação dos pressupostos do modelo reduzido
ggqqplot(modelo_reduzido$residuals) +
  labs(title = "QQ-Plot - Modelo Reduzido")

shapiro.test(modelo_reduzido$residuals)
# Conclusão: resíduos normais (= 0.2037 > 0.05)

ggplot(data = NULL, aes(x = fitted(modelo_reduzido), 
                        y = residuals(modelo_reduzido))) +
  geom_point() +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  geom_smooth(method = "loess", se = TRUE) +
  labs(title = "Resíduos vs Ajustados - Modelo Reduzido") +
  theme_minimal()

bptest(modelo_reduzido)
# Conclusão: variância constante (p-value = 0.4843 > 0.05)

# Modelo final: variáveis selecionadas foram idade, reincidente e escolaridade
# mantendo 84% de explicação da variabilidade.