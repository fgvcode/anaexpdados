
# Questão 2: 
Podemos afirmar que o tempo médio de prisão entre homens e mulheres é igual?
Utilize um nível de significância de 5%. Caso os tempos médios sejam
significativamente diferentes, apresente o intervalo de confiança de 95% para essa
diferença.

## 1. Análise Exploratória de Dados (EDA)

Para comparar os dois grupos (0 = Feminino, 1 = Masculino), usamos um boxplot.

```{r boxplot_q2, echo=TRUE}
# Boxplot comparativo
boxplot(tempo_preso ~ sexo, data = dados, 
        main="Tempo de Prisão por Sexo", 
        ylab="Tempo de Prisão (dias)",
        xlab="Sexo (0 = Feminino, 1 = Masculino)",
        col=c("pink", "lightblue"))
```

O gráfico mostra que a mediana (linha grossa) do grupo 1 (Masculino) é um pouco mais alta que a do grupo 0 (Feminino), mas as caixas se sobrepõem bastante, o que sugere que a diferença pode não ser significativa.

## 2. Teste de Hipótese Formal

Vamos agora realizar o Teste t formal para duas amostras independentes.

* **$H_0$ (Hipótese Nula):** As médias são iguais ($\mu_F = \mu_M$)
* **$H_1$ (Hipótese Alternativa):** As médias são diferentes ($\mu_F \neq \mu_M$)
* **Alpha:** 0.05

```{r teste_t_q2, echo=TRUE}
# Teste t para duas amostras (o padrão é 'alternative = "two.sided"')
t.test(tempo_preso ~ sexo, data = dados, alternative = "two.sided")
```

## 3. Conclusão da Questão 2

O teste retornou um **p-valor = 0.2147**.

Como o p-valor (0.2147) é **MAIOR** que o nosso nível de significância (0.05), nós **falhamos em rejeitar a Hipótese Nula**.


**Resposta:** Não, não podemos afirmar que os tempos médios são iguais. Não há evidência estatística suficiente para rejeitar a hipótese de que o tempo médio de prisão é igual entre homens e mulheres. A pequena diferença vista no gráfico é provavelmente devida ao acaso.

