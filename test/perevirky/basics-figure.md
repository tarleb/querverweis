
## Figures

*Querverweis* updates the link label with the figure numbers. The filter
also adds a `ref-type` attribute to the link, augmenting the reference
with semantic information.

``` html {#input}
<figure id="sunset">
  <img src="sunset.jpg" />
  <figcaption>A beautiful sunset.</figcaption>
</figure>
<p>See figure <a href="#sunset"></a> for a sunset.</p>
```

After passing through the filter this input becomes equivalent to

``` html {#output}
<figure id="sunset">
  <img src="sunset.jpg" />
  <figcaption>A beautiful sunset.</figcaption>
</figure>
<p>See figure <a href="#sunset" data-ref-type="figure">1</a> for a sunset.</p>
```
