#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado)
#
# Aluno(s): Alexandre Novaes Dornelas, José Carlos Maria Júnior, Thiago Itamar Plum, Walter Alves Moreira Barbosa dos Santos, Ygor Silva Nascimento Coelho
#################################################################


# --- PASSO 0: PREPARAÇÃO E CARREGAMENTO DOS DADOS ---
# Este passo é feito uma única vez para todo o script.

# 1. Instalar os pacotes necessários (só é necessário rodar UMA VEZ)
# A depender da instalação do usuário, pode ser necessária a instalação de outros pacotes.

# 2. Carregar os pacotes necessários para a manipulação dos dados na sessão atual do R
# Isto "ativa" as funções do pacote, como a read_excel()

library(readxl)
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
knitr::opts_chunk$set(echo = TRUE, message = FALSE)
library(car)        # Para VIF (multicolinearidade)
library(olsrr)      # Para testes de pressupostos (Homocedasticidade)
library(package = naniar)
library(lmtest)


# 3. Carregar a planilha na memória do R
# A função read_excel() lê o arquivo e o armazena na variável 'dados'.
dados <- read_excel("Base_trabalho.xlsx")

# 4. Verificação dos nomes das colunas (opcional, mas recomendado)
names(dados)


#################################################################
# ANTES DE RESPONDER: ANÁLISE EXPLORATÓRIA DOS DADOS
#################################################################

# Transformação de variáveis binárias em fatores com rótulos
# Convertendo variáveis categóricas para fatores
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
                    labels = c("Não", "Sim")),
    
    reincidente = factor(x = reincidente, 
                    levels = c(0, 1), 
                    labels = c("Não", "Sim"))
  )

dados

# Verificação de dados gerais acerca do nosso conjunto de dados

summary(dados)

#################################################################
# QUESTÃO 1: Score médio de periculosidade > 170?
#################################################################

# --- 1.1. Análise Exploratória de Dados (EDA) ---

# 1.a) Histograma
# Para verificar a forma da distribuição
hist(dados$score_periculosidade, 
     main="Histograma do Score de Periculosidade", 
     xlab="Score",
     col="lightblue", 
     border="black") 

# 1.b) Resumo Numérico
# Para verificar a média e mediana da amostra
summary(dados$score_periculosidade)
# Observação: A média da amostra (174.52) é > 170.


# --- 1.2. Teste de Hipótese Formal (Teste t de Student) ---

# Hipóteses:
# H₀ (Hipótese Nula): Média <= 170
# H₁ (Hipótese Alternativa): Média > 170
# Nível de Significância (Alpha): 0.05

# 1.c) Execução do Teste t para Uma Amostra
t.test(
  dados$score_periculosidade,  # Nossos dados da amostra
  mu = 170,                    # Valor de referência (H₀)
  alternative = "greater"      # H₁ é "maior que" (unilateral)
)

# --- 1.3. Conclusão da Questão 1 ---
#
# O teste retornou um p-valor = 0.006845.
# Como p-valor (0.0068) < alpha (0.05), REJEITAMOS H₀.
#
# Resposta: Sim, existem evidências estatísticas para afirmar
# que o score médio de periculosidade é superior a 170 pontos.
#
################### FIM DA QUESTÃO 1 ###################



#################################################################
# QUESTÃO 2: Tempo médio de prisão de H = M?
#################################################################

# --- 2.1. Análise Exploratória de Dados (EDA) ---

# 2.a) Boxplot comparativo
# Para comparar as distribuições dos dois grupos
# (0 = Feminino, 1 = Masculino)
boxplot(tempo_preso ~ sexo, data = dados, 
        main="Tempo de Prisão por Sexo", 
        ylab="Tempo de Prisão (dias)",
        xlab="Sexo (0 = Feminino, 1 = Masculino)",
        col=c("pink", "lightblue"))
# Observação: As medianas são próximas e as caixas se sobrepõem.


# --- 2.2. Teste de Hipótese Formal (Teste t de Student) ---

# Hipóteses:
# H₀ (Hipótese Nula): As médias são iguais (µ_F = µ_M)
# H₁ (Hipótese Alternativa): As médias são diferentes (µ_F != µ_M)
# Nível de Significância (Alpha): 0.05

# 2.c) Execução do Teste t para Amostras Independentes
t.test(
  tempo_preso ~ sexo,           # Fórmula: numérico ~ categórico
  data = dados,                 # Onde encontrar os dados
  alternative = "two.sided"     # H₁ é "diferente de" (bilateral)
)

# --- 2.3. Conclusão da Questão 2 ---
#
# O teste retornou um p-valor = 0.2147.
# Como p-valor (0.2147) > alpha (0.05), FALHAMOS EM REJEITAR H₀.
#
# Resposta: Não, não podemos afirmar que os tempos médios são
# diferentes. Não há evidência estatística suficiente para
# rejeitar a hipótese de que o tempo médio de prisão é 
# igual entre homens e mulheres.
#
################### FIM DA QUESTÃO 2 ###################



###############################################################################
# QUESTÃO 3: correlação entre o tempo de prisão e o score de periculosidade?
###############################################################################

#  Utilize um nível de significância de 5% e apresente o valor do coeficiente de correlação.

# 1. Visualização da normalidade para 'tempo_preso'
qq1 <- ggqqplot(dados$tempo_preso)

# 2. Visualização da normalidade para 'score_periculosidade'
qq2 <- ggqqplot(dados$score_periculosidade)

# Exibição conjunta
qq1 + qq2 # [7]

# 3. Teste formal de Shapiro-Wilk para 'tempo_preso' [7, 9]
shapiro.test(x = dados$tempo_preso)

# 4. Teste formal de Shapiro-Wilk para 'score_periculosidade' [7, 9]
shapiro.test(x = dados$score_periculosidade)

## Interpretação:
# 1. Tempo de Prisão: O p-valor (0.4003) é maior que o nível de significância de 
# 0.05. Portanto, não rejeitamos a Hipótese Nula (H0) 
# Concluímos que não há evidência estatística de que a variável tempo_preso se 
#afaste da normalidade.

#2.Score de Periculosidade: O p-valor (0.7738) também é maior que 0.05. Não rejeitamos a H0.
#indicando que é razoável assumir que o score_periculosidade possui distribuição 
#aproximadamente normal.
#COMO AMBAS AS VARIÁVEIS SE APROXIMAM DA DISTRIBUIÇÃO NORMAL, O TESTE DE CORRELAÇÃO DE PERSON É O PROCEDIMENTO ESTATISTICO ADEQUADO 


#DEFINIÇÃO DO TESTE DE CORRELAÇÃO

# 1. Gráfico de dispersão para avaliar a relação visualmente
ggplot(data = dados,
       mapping = aes(x = tempo_preso,
                     y = score_periculosidade)) +
  geom_point() +
  labs(y = "Score de Periculosidade", x = "Tempo de Prisão (meses)") +
  theme_minimal()

# 2. Estimativa pontual do coeficiente de correlação (r)
r_amostral <- cor(x = dados$tempo_preso,
                  y = dados$score_periculosidade,
                  use = "pairwise.complete.obs")
print(r_amostral)

# Realiza o Teste de Correlação de Pearson (bilateral)
cor.test(x = dados$tempo_preso,
         y = dados$score_periculosidade,
         method = "pearson",
         alternative = "two.sided",
         conf.level = 0.95)

# O valor do coeficiente de correlação de Pearson é de aproximadamente 0.804. O teste de hipóteses
# (H0 : P=0) foi rejeitado, pois o p-valor (<2.2e−16) foi inferior ao nível de significância adotado (α=0.05). 
# A correlação é forte e positiva, indicando que um tempo de prisão mais longo está significativamente associado
# a um score de periculosidade mais elevado.

# 5.RESPOSTA FINAL
# SIM, EXISTE CORRELAÇÃO ESTATISTICAMENTE ENTRE TEMPO DE PRISÃO E O SCORE DE PERICULOSIDADE

################### FIM DA QUESTÃO 3 ###################


###############################################################################
# QUESTÃO 4: correlação entre o sexo e a reincidência?
###############################################################################

#  Utilize um nível de significância de 5% e apresente o valor do coeficiente de correlação.

# 1. Mostrar proporções por sexo

conting <- table(dados$sexo, dados$reincidente)
cat('\nTabela de contingência (sexo x reincidência):\n')
print(knitr::kable(conting))
prop_por_sexo <- prop.table(conting, margin = 1) # linhas somam 1
cat('\nProporção de reincidência por sexo (linhas = sexo):\n')
print(round(prop_por_sexo, 3))

# 2. Visualizações exploratórias

# Barras empilhadas mostrando proporção de reincidência por sexo
plot_df <- dados %>% dplyr::count(sexo, reincidente) %>% dplyr::group_by(sexo) %>% dplyr::mutate(prop = n / sum(n))


p <- ggplot(plot_df, aes(x = sexo, y = prop, fill = reincidente)) +
  geom_col(position = 'stack') +
  labs(title = 'Proporção de reincidência por sexo', y = 'Proporção', x = 'Sexo') +
  theme_minimal()


print(p)


# Gráfico de barras lado a lado (contagem)
p2 <- ggplot(plot_df, aes(x = sexo, y = n, fill = reincidente)) +
  geom_col(position = 'dodge') +
  labs(title = 'Contagem de reincidência por sexo', y = 'Contagem', x = 'Sexo') +
  theme_minimal()
print(p2)

# 3. Escolher e aplicar teste estatístico
# Regra prática: se tabela 2x2 e todas as frequências esperadas >= 5 -> Qui-quadrado de Pearson
# se alguma frequência esperada < 5 -> Fisher exato


# Trabalhar apenas se tabela for 2x2 depois de limpeza
if(all(dim(conting) == c(2,2))) {
  # calcular teste qui-quadrado com correção de Yates
  chisq_res <- suppressWarnings(chisq.test(conting, correct = TRUE))
  expected <- chisq_res$expected
  cat('\nFrequências esperadas (Qui-quadrado):\n')
  print(round(expected, 2))
  min_expected <- min(expected)
  cat('\nMenor frequência esperada =', round(min_expected, 3), '\n')
  
  
  if(min_expected < 5) {
    cat('\nAlguma célula com valor esperado < 5 -> Aplicando Fisher Exact Test (mais apropriado para contagens pequenas)\n')
    fisher_res <- fisher.test(conting)
    print(fisher_res)
    pval <- fisher_res$p.value
    est_or <- if(!is.null(fisher_res$estimate)) fisher_res$estimate else NA
    confint_or <- if(!is.null(fisher_res$conf.int)) fisher_res$conf.int else NA
    test_used <- 'Fisher Exact Test'
  } else {
    cat('\nTodas as células com valor esperado >= 5 -> Aplicando Qui-quadrado de Pearson\n')
    print(chisq_res)
    pval <- chisq_res$p.value
    est_or <- NA
    confint_or <- NA
    test_used <- 'Chi-squared test (Pearson)'
  }
} else {
  # tabela não 2x2 -> usar teste qui-quadrado sem correção (mais geral) mas checar condições
  chisq_res <- suppressWarnings(chisq.test(conting))
  expected <- chisq_res$expected
  cat('\nTabela não 2x2. Aplicando Qui-quadrado (sem correção de Yates).\n')
  print(chisq_res)
  pval <- chisq_res$p.value
  test_used <- 'Chi-squared test (Pearson) - tabela RxC'
  est_or <- NA
  confint_or <- NA
}

#Todas as células com valor esperado >= 5 -> Aplicando Qui-quadrado de Pearson

#Pearson's Chi-squared test with Yates' continuity correction

#data:  conting
#X-squared = 0.078738, df = 1, p-value = 0.779


# 4. Interpretação final com nível de significância alpha = 0.05
alpha <- 0.05
cat('\n\n--- RESULTADO ---\n')
cat('Teste utilizado:', test_used, '\n')
cat('p-valor =', format.pval(pval, digits = 4), '\n')
if(pval < alpha) {
  cat('Conclusão: rejeita-se H0 ao nível de', alpha*100, '% -> existe evidência estatística de associação entre sexo e reincidência.\n')
} else {
  cat('Conclusão: Não se rejeita H0 ao nível de', alpha*100, '% -> não há evidência estatística suficiente de associação entre sexo e reincidência.\n')
}

################### FIM DA QUESTÃO 4 ###################

###############################################################################
# QUESTÃO 5: Modelo de regressão para o score de periculosidade
###############################################################################

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

################### FIM DA QUESTÃO 5 ###################

###############################################################################
# QUESTÃO 6: correlação entre o sexo e a reincidência?
###############################################################################

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

