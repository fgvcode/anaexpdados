    # 0 - Carregando pacotes necessários

    library(readxl)
    library(dplyr)

    ## 
    ## Anexando pacote: 'dplyr'

    ## Os seguintes objetos são mascarados por 'package:stats':
    ## 
    ##     filter, lag

    ## Os seguintes objetos são mascarados por 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    library(gtsummary)
    library(vcd) 

    ## Carregando pacotes exigidos: grid

    library(DescTools)

    # Importando e tratando a base de dados

    # Substitua "Base_trabalho.xlsx" pelo caminho correto se necessário
    dados <- read_excel(path = "Base_trabalho.xlsx")

    # Conversão das variáveis categóricas (binárias) para o formato 'factor' 
    # Variáveis de interesse: 'sexo' e 'reincidente' (variável implícita na base).

    dados <- dados |>
      mutate(
        
        sexo = factor(x = sexo,
                      levels = c(0, 1),
                      labels = c("Feminino", "Masculino")), 
        
        # Reincidente: 0 = Não, 1 = Sim (Implícito pela estrutura de dados binária)
        reincidente = factor(x = reincidente,
                             levels = c(0, 1),
                             labels = c("Não", "Sim"))
      )

    dados

    ## # A tibble: 200 × 8
    ##    idade escolaridade reincidente filhos sexo      tempo_preso casado score_periculosidade
    ##    <dbl> <chr>        <fct>        <dbl> <fct>           <dbl>  <dbl>                <dbl>
    ##  1    60 1            Não              0 Masculino          58      0                 176.
    ##  2    60 3            Não              0 Masculino          63      1                 155.
    ##  3    30 3            Sim              0 Masculino          52      0                 169.
    ##  4    63 2            Não              1 Masculino          66      1                 200.
    ##  5    33 1            Não              1 Masculino          45      0                 156.
    ##  6    53 2            Não              0 Feminino           76      0                 186.
    ##  7    48 2            Não              0 Masculino          70      0                 184.
    ##  8    43 2            Sim              1 Masculino          68      1                 201.
    ##  9    49 2            Não              1 Feminino           45      0                 122.
    ## 10    36 2            Sim              0 Masculino          74      0                 204.
    ## # ℹ 190 more rows

    summary(dados)

    ##      idade       escolaridade       reincidente     filhos            sexo      tempo_preso        casado    
    ##  Min.   :18.00   Length:200         Não:162     Min.   :0.00   Feminino : 62   Min.   :37.00   Min.   :0.00  
    ##  1st Qu.:34.00   Class :character   Sim: 38     1st Qu.:0.00   Masculino:138   1st Qu.:53.75   1st Qu.:0.00  
    ##  Median :52.00   Mode  :character               Median :1.00                   Median :60.50   Median :0.00  
    ##  Mean   :50.91                                  Mean   :0.52                   Mean   :60.59   Mean   :0.37  
    ##  3rd Qu.:64.25                                  3rd Qu.:1.00                   3rd Qu.:67.00   3rd Qu.:1.00  
    ##  Max.   :97.00                                  Max.   :1.00                   Max.   :88.00   Max.   :1.00  
    ##  score_periculosidade
    ##  Min.   : 91.05      
    ##  1st Qu.:155.70      
    ##  Median :177.21      
    ##  Mean   :174.52      
    ##  3rd Qu.:191.12      
    ##  Max.   :247.07

    # Análise Exploratória: Tabela de Contingência

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

    # 3 - Teste Estatístico: Qui-Quadrado de Independência (α = 0,05)

    # Hipóteses:
    # H0: Sexo e Reincidência são independentes (Não há relação)
    # H1: Há associação entre Sexo e Reincidência (Não são independentes) 

    # 3.1. Criar a tabela de contingência (objeto 'table' para o chisq.test)
    tab_contingencia <- table(dados$sexo, dados$reincidente)
    print(tab_contingencia)

    ##            
    ##             Não Sim
    ##   Feminino   49  13
    ##   Masculino 113  25

    # 3.2. Calcular estatísticas de associação (inclui Qui-Quadrado, p-valor e Cramer's V)
    # Esta função é útil para obter o Qui-Quadrado e Cramer's V de forma complementar.
    assocstats(tab_contingencia) 

    ##                      X^2 df P(> X^2)
    ## Likelihood Ratio 0.22302  1  0.63675
    ## Pearson          0.22607  1  0.63445
    ## 
    ## Phi-Coefficient   : 0.034 
    ## Contingency Coeff.: 0.034 
    ## Cramer's V        : 0.034

    # 3.3. Executar o Teste Qui-Quadrado de Independência
    # Usamos 'correct = FALSE' para evitar a Correção de Continuidade de Yates,
    # a menos que as frequências esperadas sejam muito baixas (e a recomendação geral 
    # é que as frequências esperadas Eij > 5 ).

    teste_qui_quadrado <- chisq.test(x = tab_contingencia, 
                                     correct = FALSE) # correct = FALSE é consistente com o exemplo 

    # Exibir os resultados do teste
    print(teste_qui_quadrado)

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  tab_contingencia
    ## X-squared = 0.22607, df = 1, p-value = 0.6345

    # 4 - Interpretação e Conclusão

    # Como o p-valor (0.6345, conforme resultado anterior) é maior que 0.05,
    # não rejeitamos H0. Concluímos que não há relação estatisticamente significativa
    # entre o sexo e a reincidência dos indivíduos.
