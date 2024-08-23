---
perevir:
  compare: strings
---

# Table with Label

Setting the `querverweis.labels` property to `true` ensures that a label is
added to the caption.

``` markdown {#input format="commonmark_x"}
---
querverweis:
  labels: true
---

{#languages}
| Language  | Family   |
|-----------|----------|
| German    | Germanic |
| French    | Romance  |
| Ukrainian | Slavic   |
```

``` html {#output}
<table id="languages">
<caption><span class="caption-label">Table 1 </span></caption>
<thead>
<tr>
<th>Language</th>
<th>Family</th>
</tr>
</thead>
<tbody>
<tr>
<td>German</td>
<td>Germanic</td>
</tr>
<tr>
<td>French</td>
<td>Romance</td>
</tr>
<tr>
<td>Ukrainian</td>
<td>Slavic</td>
</tr>
</tbody>
</table>
```
