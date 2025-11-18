
# Questão 1: 
Podemos afirmar que o score médio de periculosidade é superior a 170 pontos?
Utilize um nível de significância de 5%. Caso a média seja significativamente
maior que 170, apresente também o intervalo de confiança de
95% correspondente.

## 1. Análise Exploratória de Dados (EDA)

Primeiro, verifica-se a distribuição com um histograma.

```{r histograma_q1, echo=TRUE}
# Histograma
hist(dados$score_periculosidade, 
     main="Histograma do Score de Periculosidade", 
     xlab="Score",
     col="lightblue", 
     border="black") 
```

O histograma mostra uma distribuição aparentemente simétrica. Agora, calcula-se as principais medidas numéricas:

```{r summary_q1, echo=TRUE}
summary(dados$score_periculosidade)
```

A média da amostra é 174.52, o que é um indício de que a média real pode ser, sim, superior a 170.

## 2. Teste de Hipótese Formal

Aplicanso o Teste t de Student.

* **$H_0$ (Hipótese Nula):** Média $\le$ 170
* **$H_1$ (Hipótese Alternativa):** Média > 170
* **Alpha:** 0.05

```{r teste_t_q1, echo=TRUE}
t.test(
  dados$score_periculosidade,  
  mu = 170,                    
  alternative = "greater"      
)
```

## 3. Conclusão da Questão 1

O teste retornou um **p-valor = 0.006845**. 

Como o p-valor (0.0068) é **menor** que o nível de significância (0.05), **rejeita-se a Hipótese Nula**.

**Resposta:** Sim, existem evidências estatísticas suficientes para afirmar que o score médio de periculosidade é superior a 170 pontos. O intervalo de confiança de 95% reforça esta conclusão.

---

<div style="page-break-after: always;"></div>


