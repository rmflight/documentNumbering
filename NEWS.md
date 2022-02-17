# documentNumbering 0.0.4

* Moved from requiring `dn_id` to using the chunk id to get the number out for figure file renumbering.
* Added a second text argument `prefix2` that is added **all** the time.
* Added a function `just_number` that provides the number and `prefix2` only, without `prefix`. 
This is useful for a few cases, including when doing multiple figure labels.
* Finally, `label_text` learns to put in a dash instead of just listing them all delimited by comma.

# documentNumbering 0.0.3

* Changed `counter_identifier` to `dn_id` for use in renaming the figures.

# documentNumbering 0.0.2

* Added an alternative way to do things, {dn_counter}, an R6 object that you
  call on itself for side effects.

# documentNumbering 0.0.1

* Added a `NEWS.md` file to track changes to the package.
