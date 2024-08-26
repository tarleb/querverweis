querverweis
===========

A cross-reference library, implemented in pandoc Lua.

The filter can fill-in missing link labels to cross-linked elements,
parse and handle `\label` commands in LaTeX math elements, and add
caption labels to figures and tables.


<!-- DO NOT EDIT AFTER THIS LINE! THE FOLLOWING CONTENT IS GENERATED -->

Functionality
-------------

*Querverweis* handles common tasks and demands around cross-links and
cross-linked elements.

### Figures

*Querverweis* updates the link label with the figure numbers. The filter
also adds a `ref-type` attribute to the link, augmenting the reference
with semantic information.

``` html
<figure id="sunset">
  <img src="sunset.jpg" />
  <figcaption>A beautiful sunset.</figcaption>
</figure>
<p>See figure <a href="#sunset"></a> for a sunset.</p>
```

After passing through the filter this input becomes equivalent to

``` html
<figure id="sunset">
  <img src="sunset.jpg" />
  <figcaption>A beautiful sunset.</figcaption>
</figure>
<p>See figure <a href="#sunset" data-ref-type="figure">1</a> for a sunset.</p>
```

### Tables

Just like for figures, empty links to tables filled with the table
number’s numbered.

``` html
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one"></a> for a placeholder.</p>
```

The empty link label gets filled with the table number. It’s as if the
above was written as

``` html
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one" data-ref-type="table">1</a> for a placeholder.</p>
```

#### Identifiers in captions

Pandoc Markdown does currently not include syntax to set a table ID. As
an ID is essential for cross-linking, *querverweis* includes a mechanism
to set an ID via the caption:

``` markdown
| sample |
|--------|
| table  |

: Example table []{#example}
```

If the last element of the caption is a span, then the identifier of
that span is transferred to the table.

``` html
<table id="example">
  <caption>Example table</caption>
  <thead>
    <tr><th>sample</th></tr>
  </thead>
  <tbody>
    <tr><td>table</td></tr>
  </tbody>
</table>
```

Configuration
-------------

The filter can be configured through a `querverweis` metadata object.

``` markdown
---
title: My config test
querverweis:
  configs-go-here: true
---
```

The `querverweis` field is cleared after processing.

``` markdown
---
title: My config test
---
```

### `labels`: add labels to caption

Setting the `querverweis.labels` property to `true` ensures that a label
is added to the caption.

``` markdown
---
querverweis:
  labels: true
---

| Language  | Family   |
|-----------|----------|
| German    | Germanic |
| French    | Romance  |
| Ukrainian | Slavic   |

: Some Indo-European languages. []{#languages}
```

Note the span with content “Table 1” and class `caption-label`.

``` html
<table id="languages">
  <caption>
    <span class="caption-label">Table 1 </span>Some
    Indo-European languages.
  </caption>
  <thead>
    <tr><th>Language</th><th>Family</th></tr>
  </thead>
  <tbody>
    <tr><td>German</td><td>Germanic</td></tr>
    <tr><td>French</td><td>Romance</td></tr>
    <tr><td>Ukrainian</td><td>Slavic</td></tr>
  </tbody>
</table>
```

#### Adding labels only in some formats

Whether labels should be added to the caption generally depends on the
output format. E.g., TeX engines have their own caption system and add
labels automatically, but not such system exists for HTML.

The `labels` option can be set to a list of formats, and labels will be
added to the caption only if the output format is part of the list.

``` markdown
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

``` latex
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
