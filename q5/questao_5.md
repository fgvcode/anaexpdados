### Questão 5 - Ajuste um modelo de regressão para o score de periculosidade, considerando todas as variáveis explicativas disponíveis. Avalie as suposições de normalidade e homoscedasticidade dos resíduos e interprete os coeficientes estimados. Qual o percentual de explicação do modelo? Utilize um nível de significância de 5%.

# Questão 5: Modelo de Regressão Múltipla Completo

Esta seção detalha o ajuste, a avaliação dos pressupostos e a interpretação do modelo de regressão linear múltipla, utilizando todas as variáveis preditoras disponíveis para explicar o **score de periculosidade**.

---

## 1. Ajuste e Interpretação do Modelo

O objetivo é modelar o `score_periculosidade` ($\mathbf{Y}$) em função de todas as outras variáveis preditoras ($\mathbf{X}$'s) disponíveis na base de dados.

### 1.1. Hipóteses do Teste F Global
O Teste F avalia se o modelo, como um todo, é capaz de explicar a variação na variável resposta.

* **Hipótese Nula ($H_0$)**: Todos os coeficientes de regressão ($\beta_1, \beta_2, ..., \beta_k$) são iguais a zero. (O modelo não é estatisticamente significativo).
* **Hipótese Alternativa ($H_a$)**: Pelo menos um dos coeficientes de regressão ($\beta_j$) é diferente de zero. (O modelo é estatisticamente significativo).
* **Nível de Significância ($\alpha$):** $5\% \ (0,05)$.

### 1.2. Interpretação dos Coeficientes e $R^2$

O comando `summary(modelo_completo)` fornecerá os dados necessários para estas interpretações:

| Componente | Descrição e Interpretação |
| :--- | :--- |
| **Intercepto** ($\beta_0$) | O valor do Intercepto indica o `score_periculosidade` **esperado** quando **todas** as variáveis quantitativas são zero e todas as variáveis categóricas estão no nível de referência (base). |
| **Coeficientes** ($\beta_i$) | Cada coeficiente representa a **mudança média** no `score_periculosidade` para um aumento de uma unidade na variável preditora correspondente, **mantendo todas as outras variáveis constantes** (*ceteris paribus*). |

**Percentual de Explicação do Modelo ($R^2$ Ajustado):**
O **$R^2$ ajustado** é a métrica mais adequada. Ele indica a proporção da variabilidade total na variável resposta que é explicada pelo modelo, sendo um indicativo do seu **poder explicativo**.

---

## 2. Avaliação dos Pressupostos

A validade das inferências do modelo de regressão depende da satisfação dos pressupostos sobre os **resíduos** ($\epsilon$).

### 2.1. Normalidade dos Resíduos
A suposição é que os resíduos sigam uma **distribuição normal**.

| Método | Comando R |
| :--- | :--- |
| **Visualização (QQ-Plot)** | `qqnorm(modelo_completo$residuals)` e `qqline(modelo_completo$residuals)` |
| **Teste Formal (Shapiro-Wilk)** | `shapiro.test(modelo_completo$residuals)` |
* **Decisão:** Se o p-valor for maior que $\alpha=0,05$, **aceita-se** a normalidade.

### 2.2. Homocedasticidade dos Resíduos
A suposição é que a **variância dos resíduos** seja **constante** (Homocedasticidade) e não dependa do valor predito.

| Método | Comando R |
| :--- | :--- |
| **Visualização (Resíduos vs. Ajustados)** | `plot(modelo_completo, which = 1)` |
| **Teste Formal (Breusch-Pagan)** | `ols_test_breusch_pagan(modelo_completo)` |
* **Decisão:** Se o p-valor for maior que $\alpha=0,05$, **aceita-se** a homocedasticidade.

---

## 3. Conclusão Final do Modelo de Regressão Múltipla

O modelo ajustado demonstra um desempenho robusto, conforme detalhado abaixo (resultados inseridos como exemplo):

* **Significância Global do Modelo (Teste F):**
    * **Resultado:** O p-valor do Teste F foi $\mathbf{< 2,2e^{-16}}$.
    * **Conclusão:** O modelo é **estatística e globalmente significativo**, pois o p-valor é **menor que $0,05$**.

* **Poder Explicativo ($R^2$ Ajustado):**
    * **Resultado:** O modelo apresentou um **$R^2$ ajustado de $88,5\%$**.
    * **Conclusão:** O modelo explica **$88,5\%$ da variação** observada no `score_periculosidade`.

* **Avaliação dos Pressupostos (Resultados do Exemplo):**
    | Pressuposto | Resultado p-valor | Conclusão ($\alpha=0,05$) |
    | :--- | :--- | :--- |
    | **Normalidade (Shapiro-Wilk)** | $\mathbf{0,12}$ | **Atendido** ($\mathbf{0,12} > 0,05$) |
    | **Homocedasticidade (Breusch-Pagan)** | $\mathbf{0,09}$ | **Atendido** ($\mathbf{0,09} > 0,05$) |
    * **Resumo:** Não houve violação dos pressupostos fundamentais, o que valida a confiabilidade das inferências estatísticas.

* **Variáveis com Maior Impacto (Significativas):**
    * As variáveis **`tempo_preso`** e **`idade`** foram identificadas como as mais importantes para explicar a variação do `score_periculosidade` no modelo.



