Consider a simple figure with link (`labels` option is enabled, see
[below for details](#labels-add-labels-to-caption)):

``` markdown {#input}
---
querverweis:
  labels: true
---
![A beautiful sunset.](sunset.jpg){#sunset}

See Figure [](#sunset) for a sunset.
```

…would generate this HTML output:

```html {#expected}
<figure id="sunset">
<img src="sunset.jpg" alt="A beautiful sunset." />
<figcaption><span class="caption-label">Figure 1 </span>A beautiful sunset.</figcaption>
</figure>
<p>See Figure <a href="#sunset">1</a> for a sunset.</p>
```



# Functionality

*Querverweis* handles common tasks and demands around cross-links and
cross-linked elements.
