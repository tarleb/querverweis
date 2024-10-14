querverweis
===========

A cross-reference library, implemented in pandoc Lua.

The filter can fill in missing link labels to cross-linked elements,
parse and handle `\label` commands in LaTeX math elements, and add
caption labels to figures and tables.


<!-- DO NOT EDIT AFTER THIS LINE! THE FOLLOWING CONTENT IS GENERATED -->

Functionality
-------------

*Querverweis* handles common tasks and demands around cross-links and
cross-linked elements.

### Figures

*Querverweis* updates the link label with the figure numbers.

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
<p>See figure <a href="#sunset">1</a> for a sunset.</p>
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

<p>See table <a href="#one">1</a> for a placeholder.</p>
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

### Formulæ

Formulæ that take up their own line (“display math”) can also be
cross-referenced. There are two ways to specify an ID: either set the ID
on a span that wraps the equation, or use the LaTeX `\label` syntax.
When using a span, the span *must* also have the class `equation` to set
it apart from other spans.

<details>

Consider this Markdown input:

``` markdown
Formula [](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
[$$ a^2 + b^2 = c^2 $$]{#squares .equation}

This formula can be generalized to
$$ a^n + b^n = c^n \label{fermat} $$

It has been proven that equation [](#fermat) has no solutions in the
positive integers if $n ≥ 3$.
```

The filter converts the above to

``` markdown
Formula [1](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
[$$ a^2 + b^2 = c^2 $$]{#squares .equation}

This formula can be generalized to
[$$ a^n + b^n = c^n$$]{#fermat .equation}

It has been proven that equation [2](#fermat) has no solutions in the
positive integers if $n ≥ 3$.
```

</details>

### Sections

Unlabeled section links are labeled with the number of the referenced
section.

``` markdown
# Prelude {-}

Some introductory text.

# Introduction

The results are described in section [](#results).

The the computational model is described in section
[](#simulation).

This is mentioned in [](#prelude).

# Methods

How things were done.

## Lab
## Simulation

# Results
```

After passing through the filter this input becomes equivalent to

``` markdown
# Prelude {.unnumbered}

Some introductory text.

# Introduction

The results are described in section [3](#results).

The the computational model is described in section
[2.2](#simulation).

This is mentioned in [Prelude](#prelude).

# Methods

How things were done.

## Lab

## Simulation

# Results
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

### `ref-types`: mark links with type of cross-linked element

The `ref-types` option allows to enable and disable the addition of
`ref-type` attributes to links. The option is most useful when
converting to JATS, where this [attribute is
standardized](https://jats.nlm.nih.gov/articleauthoring/tag-library/1.2/attribute/ref-type.html).

#### Figures

<details>

The example below is using JATS as output, because element identifiers
are easily visible there.

``` markdown
---
querverweis:
  ref-types: true
---

![A beautiful sunset.](sunset.jpg){#sunset}

See figure [](#sunset) for a sunset.
```

Besides updating the link labels, the filter now also adds the
`ref-type` attribute to the link, augmenting the reference with semantic
information.

``` xml
<fig id="sunset">
  <caption><p>A beautiful sunset.</p></caption>
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="sunset.jpg" />
</fig>
<p>See figure <xref alt="1" rid="sunset" ref-type="figure">1</xref> for
a sunset.</p>
```

</details>

#### Tables

<details>

The example below is using JATS as output, because element identifiers
are easily visible there.

``` markdown
---
querverweis:
  ref-types: true
---

---- ----
eins zwei
drei vier
---- ----

: []{#one}

See table [](#one) for four German numbers,
and table [](#two) for some more.

 -------- --------
 dreizehn vierzehn
      elf    zwölf
 -------- --------

 : []{#two}
```

The `ref-type` is set to `table` when referencing a table.

``` xml
<table-wrap>
  <table id="one">
    <tbody>
      <tr>
        <td>eins</td>
        <td>zwei</td>
      </tr>
      <tr>
        <td>drei</td>
        <td>vier</td>
      </tr>
    </tbody>
  </table>
</table-wrap>
<p>See table <xref alt="1" rid="one" ref-type="table">1</xref> for four
German numbers, and table
<xref alt="2" rid="two" ref-type="table">2</xref> for some more.</p>
<table-wrap>
  <table id="two">
    <tbody>
      <tr>
        <td>dreizehn</td>
        <td>vierzehn</td>
      </tr>
      <tr>
        <td>elf</td>
        <td>zwölf</td>
      </tr>
    </tbody>
  </table>
</table-wrap>
```

</details>
