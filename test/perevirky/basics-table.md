## Tables

Just like with figures, empty links to tables are filled with the
table number.

``` html {#input}
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one"></a> for a placeholder.</p>
```

The empty link label gets filled with the table number:

``` html {#output}
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one">1</a> for a placeholder.</p>
```
