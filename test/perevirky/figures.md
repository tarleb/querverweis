---
perevir:
  compare: strings
---

## Figures

The example below is using HTML as input and JATS as output, because
element identifiers are easily visible there.

``` html {#input}
<figure id="sunset">
  <img src="sunset.jpg" />
  <figcaption>A beautiful sunset.</figcaption>
</figure>
<p>See figure <a href="#sunset"></a> for a sunset,
  and figure <a href="#dogs"></a> for cute dogs.</p>
<figure id="dogs">
  <img src="dogs.jpg" />
  <figcaption>Cute dogs.</figcaption>
</figure>
```

*Querverweis* updates the link label with the figure numbers. The filter
also adds a `ref-type` attribute to the link, augmenting the reference
with semantic information.

``` xml {#output format="jats"}
<fig id="sunset">
  <caption><p>A beautiful sunset.</p></caption>
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="sunset.jpg" />
</fig>
<p>See figure <xref alt="1" rid="sunset" ref-type="figure">1</xref> for
a sunset, and figure <xref alt="2" rid="dogs" ref-type="figure">2</xref>
for cute dogs.</p>
<fig id="dogs">
  <caption><p>Cute dogs.</p></caption>
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="dogs.jpg" />
</fig>
```
