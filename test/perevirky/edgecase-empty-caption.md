## Empty paragraph as last block in caption

``` haskell {#input format="native"}
[ Figure
    ( "" , [] , [] )
    (Caption Nothing [Para []])
    []
]
```

Note the empty `Para` in the caption. This should not trigger an error.

``` haskell {#output}
[ Figure
    ( "" , [] , [] )
    (Caption Nothing [Para []])
    []
]
```
