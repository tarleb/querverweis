# Configuration

The filter can be configured through a `querverweis` metadata object.

``` markdown {#input}
---
title: My config test
querverweis:
  configs-go-here: true
---
```

The `querverweis` field is cleared after processing.

``` markdown {#outpt}
---
title: My config test
---

```
