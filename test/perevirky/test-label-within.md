# Align environment with a label

It's common to add `\label` at the start of TeX math environments.

``` markdown {#input}
$$
\begin{align} \label{eq:sprinkler_DAG_markov}
    \mathbb{P}(X_1, \dots, X_5) = \mathbb{P}(X_1)\mathbb{P}(X_2|X_1) \mathbb{P}(X_3|X_1) \mathbb{P}(X_4|X_3, X_2) \mathbb{P}(X_5|X_4).
\end{align}
$$
```

Markdown output:

``` markdown {#output}
[$$
\begin{align}
    \mathbb{P}(X_1, \dots, X_5) = \mathbb{P}(X_1)\mathbb{P}(X_2|X_1) \mathbb{P}(X_3|X_1) \mathbb{P}(X_4|X_3, X_2) \mathbb{P}(X_5|X_4).
\end{align}$$]{#eq:sprinkler_DAG_markov .equation}
```
