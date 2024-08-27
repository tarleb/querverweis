---
perevir:
  compare: strings
---

### Tables

<details>

The example below is using JATS as output, because element identifiers
are easily visible there.

``` markdown {#input}
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

``` xml {#output format="jats"}
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
