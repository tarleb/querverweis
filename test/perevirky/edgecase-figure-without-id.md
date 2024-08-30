## Figure without ID

A figure without an ID cannot be referenced, but it will still be
included in the numbering scheme.

``` markdown {#input}
![First](one.png){#one}

![Second](two.png)

![Third](three.png){#three}

Figures [](#one) and [](#three)
```

``` html {#expected}
<figure id="one">
  <img src="one.png" alt="First" />
  <figcaption aria-hidden="true">First</figcaption>
</figure>
<figure>
  <img src="two.png" alt="Second" />
  <figcaption aria-hidden="true">Second</figcaption>
</figure>
<figure id="three">
  <img src="three.png" alt="Third" />
  <figcaption aria-hidden="true">Third</figcaption>
</figure>
<p>Figures <a href="#one">1</a> and <a href="#three">3</a></p>
```
