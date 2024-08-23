# Labeled Equation

An equation that's labeled using LaTeX syntax should be converted
to the internal labeling structure, i.e., the label should become
the id of a wrapping Span.

``` markdown {#input}
$\{\}=\varnothing \label{emptyset}$
```

Markdown output:

``` markdown {#output}
[$\{\}=\varnothing$]{#emptyset .equation}
```
