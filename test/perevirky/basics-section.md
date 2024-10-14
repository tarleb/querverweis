## Sections

Unlabeled section links are labeled with the number of the referenced
section.

``` markdown {#input}
# Prelude {-}

Some introductory text.

# Introduction

The results are described in section [](#results).

The the computational model is described in section
[](#simulation).

This is mentioned in [](#prelude).

# Methods

How things were done.

## Lab
## Simulation

# Results
```

After passing through the filter this input becomes equivalent to

``` markdown {#output}
# Prelude {.unnumbered}

Some introductory text.

# Introduction

The results are described in section [3](#results).

The the computational model is described in section
[2.2](#simulation).

This is mentioned in [Prelude](#prelude).

# Methods

How things were done.

## Lab

## Simulation

# Results
```
