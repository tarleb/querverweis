# Equations

"Display math" equations should get numbered.

## Example

<div id="input">

Formula [](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
<span id="squares" class="equation">$$
a^2 + b^2 = c^2
$$</span>

This formula can be generalized to
[$$
a^n + b^n = c^n
$$]{#fermat .equation}

It has been proven that equation [](#fermat) has no solutions in the
positive integers if $n ≥ 3$.

</div>

## Expected output

<div id="output">

Formula [1](#squares) has an infinite number of solutions for
$a, b, c ∈ ℕ$
[
$$
a^2 + b^2 = c^2
$$
]{#squares .equation}

This formula can be generalized to
[$$
a^n + b^n = c^n
$$]{#fermat .equation}

It has been proven that equation [2](#fermat) has no solutions in the
positive integers if $n ≥ 3$.

</div>
