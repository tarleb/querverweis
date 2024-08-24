---
perevir:
  compare: 'strings'
---

# Adding labels only in some formats

Whether labels should be added to the caption generally depends on the
output format. E.g., TeX engines have their own caption system and add
labels automatically, but not such system exists for HTML.

The `labels` option can be set to a list of formats, and labels will be
added to the caption only if the output format is part of the list.

``` markdown {#input}
---
querverweis:
  labels: ['html']
---

| Language  | Family   |
|-----------|----------|
| German    | Germanic |
| French    | Romance  |
| Ukrainian | Slavic   |

: Some Indo-European languages. []{#languages}
```

If the config specifies that labels should only be added when producing
HTML, then no labels will be produced for LaTeX.

``` latex {#output}
\begin{longtable}[]{@{}ll@{}}
\caption{Some Indo-European languages.}\label{languages}\tabularnewline
\toprule\noalign{}
Language & Family \\
\midrule\noalign{}
\endfirsthead
\toprule\noalign{}
Language & Family \\
\midrule\noalign{}
\endhead
\bottomrule\noalign{}
\endlastfoot
German & Germanic \\
French & Romance \\
Ukrainian & Slavic \\
\end{longtable}
```
