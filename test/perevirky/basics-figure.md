
## Figures

*Querverweis* updates the link label with the figure numbers.

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
<p>See figure <a href="#sunset">1</a> for a sunset.</p>
```
