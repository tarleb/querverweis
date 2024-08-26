### Identifiers in captions

Pandoc Markdown does currently not include syntax to set a table ID. As
an ID is essential for cross-linking, *querverweis* includes a mechanism
to set an ID via the caption:

``` markdown {#input}
| sample |
|--------|
| table  |

: Example table []{#example}
```

If the last element of the caption is a span, then the identifier of
that span is transferred to the table.

``` html {#output}
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
