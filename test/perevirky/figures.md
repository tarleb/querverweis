---
perevir:
  filters:
  - querverweis.lua
---

# Figures

Check to see if links to figures get numbered.

We're using HTML as input and JATS as output, because element
identifiers are easily visible there.

``` html {#input}
<figure id="sunset">
  <img src="sunset.jpg" />
  <caption>A beautiful sunset.</caption>
</figure>
<p>See figure <a href="#sunset"></a> for a sunset,
  and figure <a href="#dogs"></a> for cute dogs.</p>
<figure id="dogs">
  <img src="dogs.jpg" />
  <caption>Cute dogs.</caption>
</figure>
```

``` sh {#command}
pandoc -f html -t jats --lua-filter=querverweis.lua
```

``` jats {#output}
<fig id="sunset">
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="sunset.jpg" />
  <p>A beautiful sunset.</p>
</fig>
<p>See figure <xref alt="1" rid="sunset" ref-type="figure">1</xref> for
a sunset, and figure <xref alt="2" rid="dogs" ref-type="figure">2</xref>
for cute dogs.</p>
<fig id="dogs">
  <graphic mimetype="image" mime-subtype="jpeg" xlink:href="dogs.jpg" />
  <p>Cute dogs.</p>
</fig>
```
