#################################################################
# TRABALHO DE PROBABILIDADE E ESTATÍSTICA COM R
#
# Script R (documentado) para resolução das Questões 1 
#
# Aluno(s): grupo 1
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



