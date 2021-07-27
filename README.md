
<!-- README.md is generated from README.Rmd. Please edit that file -->

# documentNumbering

<!-- badges: start -->
<!-- badges: end -->

The goal of documentNumbering is to provide figure and table numbering
in Rmd output formats that don’t normally provide figure numbers. This
package exists as an alternative to the number referencing provided by
the [bookdown
package](https://bookdown.org/yihui/rmarkdown-cookbook/figure-number.html).

## Installation

You can currently install from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rmflight/documentNumbering")
```

## Example

For basic usage, you initialize any counters you need:

``` r
library(documentNumbering)

figure_counts = dn_initialize_counter()
table_counts = dn_initialize_counter()
```

From there, you can add to each one with identifiers, and then
subsequently use it to reference it later:

``` r
figure_counts = dn_increment_counter(figure_counts, "plot1")
plot(rnorm(100), rnorm(100))
```

<img src="man/figures/README-make_plot-1.png" width="100%" />

And now you can refer to it in the text:

`r dn_figure_string(figure_counts, "plot1")`. Shows the result of
plotting a random normal.

Figure 1. Shows the result of plotting a random normal.

For table numbers, you can use `dn_table_string`.

Both `dn_table_string` and `dn_figure_string` are wrappers around the
more general `dn_paste_counter`, where you can supply any text you want:

``` r
dn_paste_counter(figure_counts, "Whoa ", "plot1")
#> [1] "Whoa 1"
```

## Disadvantage

You need to define the counter identifier before it can be used. That
can be annoying, but in practice it’s not too bad.

## Modifying Figure Names

In addition to just using the counter, there is the ability to modify
the file names of the figures generated. This is particularly useful if
you are creating figure files for a manuscript. If you set
`keep_md: true` in the yaml header, and then you can add a custom figure
processor:

``` yaml
output:
  word_document:
    keep_md: true
```

``` r
knitr::opts_chunk$set(fig.processor = dn_modify_path)
```

And then to rename the figure file, you set a custom chunk option,
`counter_identifier`:

    ```{r rename_chunk, counter_identifer = dn_figure_rename(figure_counts, "plot1")}
    plot(rnorm(100), rnorm(100))
    ```

The figure file will be prepended with `figure_1_` in the output
directory that is generated, which makes it much easier to refer to when
uploading files or sharing them with collaborators.
