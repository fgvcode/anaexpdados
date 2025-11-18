#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado) para resolução das Questão 2
#
# Aluno(s): [grupo 1]
#################################################################


# --- PASSO 0: PREPARAÇÃO E CARREGAMENTO DOS DADOS ---
# Este passo é feito uma única vez para todo o script.

# 1. Instalar o pacote 'readxl' (só é necessário rodar esta linha UMA VEZ)
# install.packages("readxl")

# 2. Carregar o pacote 'readxl' na sessão atual do R
# Isto "ativa" as funções do pacote, como a read_excel()
library(readxl)

# 3. Carregar a planilha na memória do R
# A função read_excel() lê o arquivo e o armazena na variável 'dados'.
dados <- read_excel("Base_trabalho.xlsx")

# 4. Verificação dos nomes das colunas (opcional, mas recomendado)
# names(dados)




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
