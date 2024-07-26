---
perevir:
  filters:
  - querverweis.lua
---

# Tables

Check to see if tables are numbered.

We're using HTML as input and JATS as output, because element
identifiers are easily visible there.

``` html {#input}
<table id="one">
  <tr><td>eins</td><td>zwei</td></tr>
  <tr><td>drei</td><td>vier</td></tr>
</table>
<p>See table <a href="#one"></a> for some German numbers,
  and table <a href="#two"></a> for some more.</p>
<table id="two">
  <tr><td>elf</td><td>zwölf</td></tr>
  <tr><td>dreizehn</td><td>vierzehn</td></tr>
</table>
```

``` jats {#output}
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
<p>See table <xref alt="1" rid="one" ref-type="table">1</xref> for some
German numbers, and table
<xref alt="2" rid="two" ref-type="table">2</xref> for some more.</p>
<table-wrap>
  <table id="two">
    <tbody>
      <tr>
        <td>elf</td>
        <td>zwölf</td>
      </tr>
      <tr>
        <td>dreizehn</td>
        <td>vierzehn</td>
      </tr>
    </tbody>
  </table>
</table-wrap>
```
