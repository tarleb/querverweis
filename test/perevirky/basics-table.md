## Tables

Just like for figures, empty links to tables filled with the table
number's numbered.

``` html {#input}
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one"></a> for a placeholder.</p>
```

The empty link label gets filled with the table number. It's as if the
above was written as

``` html {#output}
<table id="one">
  <tr><td>placeholder</td></tr>
</table>

<p>See table <a href="#one" data-ref-type="table">1</a> for a placeholder.</p>
```
