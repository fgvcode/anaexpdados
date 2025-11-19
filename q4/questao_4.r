
# ------------------------------------------------------------------------------
# 0 - Carregando pacotes necessários
# ------------------------------------------------------------------------------
# Usamos 'readxl' para ler o arquivo Excel.
# Usamos 'dplyr' para manipulação de dados (mutate).
# Usamos 'gtsummary' para criar tabelas descritivas (análise exploratória).
# Usamos 'vcd' para estatísticas de associação (Cramer's V, phi).
# Usamos 'DescTools' para testes estatísticos adicionais se necessário.

library(readxl)
library(dplyr)
library(gtsummary)
library(vcd) 
library(DescTools)
# Se algum pacote não estiver instalado, use: install.packages("nome_do_pacote")

# ------------------------------------------------------------------------------
# 1 - Importando e tratando a base de dados
# ------------------------------------------------------------------------------

# Substitua "Base_trabalho.xlsx" pelo caminho correto se necessário
dados <- read_excel(path = "Base_trabalho.xlsx")

# Conversão das variáveis categóricas (binárias) para o formato 'factor' 
# com rótulos legíveis, conforme a estrutura das fontes [9, 10].
# Variáveis de interesse: 'sexo' e 'reincidente' (variável implícita na base).

dados <- dados |>
  mutate(
    # Sexo: 0 = Feminino, 1 = Masculino. (Ajustado conforme o dicionário [11] e exemplos de tratamento [10])
    # NOTA: O tratamento no gabarito inverte a codificação 0/1 para Feminino/Masculino dependendo do contexto.
    # Usaremos a codificação mostrada no tratamento do trabalho final (0=Masculino, 1=Feminino) para consistência:
    # SEXO: 1 = Masculino, 0 = Feminino [11]
    # No exemplo de tratamento [10], foi usado levels = c(0, 1) e labels = c("Masculino", "Feminino").
    
    sexo = factor(x = sexo,
                  levels = c(0, 1),
                  labels = c("Feminino", "Masculino")), 
    
    # Reincidente: 0 = Não, 1 = Sim (Implícito pela estrutura de dados binária)
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
# H0: Sexo e Reincidência são independentes (Não há relação) [12, 13]
# H1: Há associação entre Sexo e Reincidência (Não são independentes) [12, 13]

# 3.1. Criar a tabela de contingência (objeto 'table' para o chisq.test)
tab_contingencia <- table(dados$sexo, dados$reincidente)
print(tab_contingencia)

# 3.2. Calcular estatísticas de associação (inclui Qui-Quadrado, p-valor e Cramer's V)
# Esta função é útil para obter o Qui-Quadrado e Cramer's V de forma complementar.
assocstats(tab_contingencia) 

# 3.3. Executar o Teste Qui-Quadrado de Independência
# Usamos 'correct = FALSE' para evitar a Correção de Continuidade de Yates,
# a menos que as frequências esperadas sejam muito baixas (e a recomendação geral 
# é que as frequências esperadas Eij > 5 [2, 14]).

teste_qui_quadrado <- chisq.test(x = tab_contingencia, 
                                 correct = FALSE) # correct = FALSE é consistente com o exemplo [5, 6]

# Exibir os resultados do teste
print(teste_qui_quadrado)

# ------------------------------------------------------------------------------
# 4 - Interpretação e Conclusão
# ------------------------------------------------------------------------------
# Como o p-valor (0.6345, conforme resultado anterior) é maior que 0.05,
# não rejeitamos H0. Concluímos que não há relação estatisticamente significativa
# entre o sexo e a reincidência dos indivíduos.

