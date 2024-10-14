## Citation syntax

Citations can be used as an alternative to unlabeled links. This is
particularly convenient when authoring in Markdown with the `citations`
extension enabled (the default for pandoc Markdown).

``` markdown {#input}
![The face of a male mandrill](mandrill.jpg){#fig:mandrill}

The *Mandrill* face in @fig:mandrill is a classic test image.
```

``` markdown {#expected}
![The face of a male mandrill](mandrill.jpg){#fig:mandrill}

The *Mandrill* face in [1](#fig:mandrill) is a classic test image.
```
