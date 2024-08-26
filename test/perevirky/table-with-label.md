---
perevir:
  ignore-softbreaks: true
---

# `labels`: add labels to caption

Setting the `querverweis.labels` property to `true` ensures that a label is
added to the caption.

``` markdown {#input}
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

Note the span with content "Table 1" and class `caption-label`.

``` html {#output}
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
