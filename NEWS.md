# documentNumbering 0.1.0

* Big change for renaming files. Instead of using the `dn_modify_path` as the argument for `fig.process`, the counter R6 object has a new function, `modify_path` that should be used, and only uses the chunk label to identify the renaming. See the updated README for the example.
* The reason for the above, is that the previous method only seemed to work in rmarkdown docs, and not quarto docs. The new method works in both rmarkdown and quarto.
* Deleted all references to the non-R6 functions out of the README.

# documentNumbering 0.0.4

* Moved from requiring `dn_id` to using the chunk id to get the number out for figure file renumbering.
* Added a second text argument `prefix2` that is added **all** the time.
* Added a function `just_count` that provides the number and `prefix2` only, without `prefix`. 
This is useful for a few cases, including when doing multiple figure labels.
* Finally, `label_text` learns to put in a dash instead of just listing them all delimited by comma.

# documentNumbering 0.0.3

* Changed `counter_identifier` to `dn_id` for use in renaming the figures.

# documentNumbering 0.0.2

* Added an alternative way to do things, {dn_counter}, an R6 object that you
  call on itself for side effects.

# documentNumbering 0.0.1

* Added a `NEWS.md` file to track changes to the package.
