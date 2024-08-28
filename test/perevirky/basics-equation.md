## Formulæ

Formulæ that take up their own line ("display math") can also be
cross-referenced. There are two ways to specify an ID: either set the ID
on a span that wraps the equation, or use the LaTeX `\label` syntax.
When using a span, the span *must* also have the class `equation` to set
it apart from other spans.

<details>

Consider this Markdown input:

``` markdown {#input}
Formula [](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
[$$ a^2 + b^2 = c^2 $$]{#squares .equation}

This formula can be generalized to
$$ a^n + b^n = c^n \label{fermat} $$

It has been proven that equation [](#fermat) has no solutions in the
positive integers if $n ≥ 3$.
```

The filter converts the above to

``` markdown {#output}
Formula [1](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
[$$ a^2 + b^2 = c^2 $$]{#squares .equation}

This formula can be generalized to
[$$a^n+b^n=c^n$$]{#fermat .equation}

It has been proven that equation [2](#fermat) has no solutions in the
positive integers if $n ≥ 3$.
```

</details>
