---
perevir:
  compare: strings
---

## `ref-types`: mark links with type of cross-linked element

The `ref-types` option allows to enable and disable the addition of
`ref-type` attributes to links. The option is most useful when
converting to JATS, where this [attribute is standardized][ref-type].

[ref-type]: https://jats.nlm.nih.gov/articleauthoring/tag-library/1.2/attribute/ref-type.html

### Figures

<details>

The example below is using JATS as output, because element identifiers
are easily visible there.

``` markdown {#input}
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

``` xml {#output format="jats"}
<fig id="sunset">
  <caption><p>A beautiful sunset.</p></caption>
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="sunset.jpg" />
</fig>
<p>See figure <xref alt="1" rid="sunset" ref-type="figure">1</xref> for
a sunset.</p>
```

</details>
