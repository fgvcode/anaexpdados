
# ------------------------------------------------------------------------------
# 0 - Carregando pacotes necessários
# ------------------------------------------------------------------------------

library(readxl)
library(dplyr)
library(gtsummary)
library(vcd) 
library(DescTools)
# ------------------------------------------------------------------------------
# 1 - Importando e tratando a base de dados
# ------------------------------------------------------------------------------

#dados <- read_excel(path = "Base_trabalho.xlsx")

# Conversão das variáveis categóricas (binárias) para o formato 'factor' 
# Variáveis de interesse: 'sexo' e 'reincidente' (variável implícita na base).

dados <- dados |>
  mutate(    
    sexo = factor(x = sexo,
                  levels = c(0, 1),
                  labels = c("Feminino", "Masculino")), 
    
    
    reincidente = factor(x = reincidente,
                         levels = c(0, 1),
                         labels = c("Não", "Sim"))
  )


# ------------------------------------------------------------------------------
# 2 - Análise Exploratória: Tabela de Contingência
# ------------------------------------------------------------------------------
# Observar a distribuição das frequências e proporções de reincidência 
# para cada categoria de Sexo.

tabela_sexo_reincidencia <- dados |>
  select(sexo, reincidente) |>
  tbl_summary(
    by = sexo, # Variável usada para agrupar as colunas
    statistic = all_categorical() ~ "{n} ({p}%)",
    percent = "column", # Calcula percentuais dentro de cada grupo de Sexo
    label = list(reincidente ~ "Indivíduo Reincidente?")
  ) |>
  modify_header(label ~ "**Variável**") |>
  bold_labels()

print(tabela_sexo_reincidencia)

# ------------------------------------------------------------------------------
# 3 - Teste Estatístico: Qui-Quadrado de Independência (α = 0,05)
# ------------------------------------------------------------------------------

# Hipóteses:
# H0: Sexo e Reincidência são independentes (Não há relação) 
# H1: Há associação entre Sexo e Reincidência (Não são independentes) 

# 3.1. Criar a tabela de contingência (objeto 'table' para o chisq.test)
tab_contingencia <- table(dados$sexo, dados$reincidente)
print(tab_contingencia)

# 3.2. Calcular estatísticas de associação (inclui Qui-Quadrado, p-valor e Cramer's V)
# Esta função é útil para obter o Qui-Quadrado e Cramer's V de forma complementar.
assocstats(tab_contingencia) 

# 3.3. Executar o Teste Qui-Quadrado de Independência
# Usamos 'correct = FALSE' para evitar a Correção de Continuidade de Yates,
# a menos que as frequências esperadas sejam muito baixas (e a recomendação geral 
# é que as frequências esperadas Eij > 5 ).

teste_qui_quadrado <- chisq.test(x = tab_contingencia, 
                                 correct = FALSE) 

# Exibir os resultados do teste
print(teste_qui_quadrado)

# ------------------------------------------------------------------------------
# 4 - Interpretação e Conclusão
# ------------------------------------------------------------------------------
# Como o p-valor (0.6345, conforme resultado anterior) é maior que 0.05,
# não rejeitamos H0. Concluímos que não há relação estatisticamente significativa
# entre o sexo e a reincidência dos indivíduos.




