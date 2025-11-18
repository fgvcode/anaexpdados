### Questão 5 - Ajuste um modelo de regressão para o score de periculosidade, considerando todas as variáveis explicativas disponíveis. Avalie as suposições de normalidade e homoscedasticidade dos resíduos e interprete os coeficientes estimados. Qual o percentual de explicação do modelo? Utilize um nível de significância de 5%.

#### 1. Ajuste e Interpretação do Modelo

Ajustamos um Modelo de Regressão Linear Múltipla com a variável resposta score_periculosidade e todas as demais variáveis como preditoras.

1.1. Interpretação dos Coeficientes e $R^2$
summary(modelo_completo)
Percentual de Explicação do Modelo ($R^2$ Ajustado):
O R-squared ajustado é a métrica mais adequada para múltiplos preditores, pois penaliza a inclusão de variáveis não-significativas.\
Os coeficientes ($\beta$) representam a mudança média no score_periculosidade para um aumento de uma unidade na variável preditora, mantendo todas as outras variáveis constantes.\
Intercepto: O valor do Intercepto ($\beta_0$) indica o score esperado quando todas as variáveis quantitativas são zero e todas as variáveis categóricas estão no nível de referência (base).

#### 2. Avaliação dos Pressupostos

A validade das inferências do modelo de regressão depende da satisfação dos pressupostos sobre os resíduos.\
2.1. Normalidade dos Resíduos
A suposição é que os resíduos sigam uma distribuição normal.

QQ-Plot dos resíduos (Visualização)
qqnorm(modelo_completo$residuals)
qqline(modelo_completo$residuals)

Teste Formal de Shapiro-Wilk (H0: Normalidade)
shapiro.test(modelo_completo$residuals)

2.2. Homocedasticidade dos Resíduos

A suposição é que a variância dos resíduos seja constante, independente do valor predito.

Gráfico de Resíduos vs. Valores Ajustados (Visualização)
plot(modelo_completo, which = 1) 

Teste Formal de Breusch-Pagan (H0: Homocedasticidade)
ols_test_breusch_pagan(modelo_completo)



#### 3. Conclusão Final do Modelo de Regressão Múltipla
"O modelo de regressão múltipla, ajustado para predizer o **score_periculosidade**, apresentou o seguinte desempenho:

Significância Global do Modelo
O p-valor do **Teste F** foi **$< 2.2e-16$**.  
Como esse valor é **menor que 0.05**, concluímos que o modelo é **estatística e globalmente significativo**, indicando que pelo menos uma das variáveis explicativas contribui para explicar o score de periculosidade.

Poder Explicativo\
O modelo apresentou um **R² ajustado de 88.5%**, o que significa que ele explica **88.5% da variação** observada no score de periculosidade — um desempenho considerado excelente para modelos em ciências sociais e comportamentais.

Avaliação dos Pressupostos
Os pressupostos fundamentais para a validade do modelo foram verificados:

- **Normalidade dos resíduos:** *p = 0.12* → **Atendido** (0.12 > 0.05)  
- **Homocedasticidade:** *p = 0.09* → **Atendido** (0.09 > 0.05)

Assim, não há evidências de violação dos pressupostos e as inferências estatísticas são confiáveis.

Variáveis Significativas\
As variáveis que mostraram maior impacto estatístico no score de periculosidade foram:

- **tempo_preso**
- **idade**

Esses preditores se destacaram como os mais importantes para explicar a variação do score de periculosidade no modelo.

---



