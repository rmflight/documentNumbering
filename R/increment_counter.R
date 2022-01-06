#' increment counter
#'
#' given a counter, add to it with a specific name
#'
#' @param counter the counter to add to
#' @param name the name for the value
#'
#' @export
#' @return named numeric
dn_increment_counter = function(counter, name){
  n_obj = length(counter)
  use_number = max(counter) + 1
  counter = c(counter, use_number)
  names(counter)[n_obj + 1] = name
  counter
}

#' paste counter
#'
#' Given a counter and a name to find, returns a string for insertion
#' into the text.
#'
#' @param counter the counter to search on
#' @param pre_string any text to paste first
#' @param identifier the id for the count
#'
#' @export
#' @return string
dn_paste_counter = function(counter, pre_string = "", identifier = NULL){
  if (is.null(identifier)) {
    stop("No identifier provided!")
  }
  if (!any(grepl(identifier, names(counter)))) {
    stop(paste0('identifier "', identifier, '" not found in the counter supplied!'))
  }
  id_number = counter[identifier]

  if (length(id_number) > 1) {
    str_numbers = paste(id_number, collapse = ", ")
  } else {
    str_numbers = id_number
  }

  use_text = paste(pre_string, str_numbers, sep = "")

  use_text
}


#' figure string
#'
#' Generate a figure string with the number included.
#'
#' @param counter the counter object
#' @param identifier the identifier to get the number for
#' @param supplemental should an "S" be added to the label first?
#'
#' @export
#' @return character
dn_figure_string = function(counter, identifier = NULL, supplemental = FALSE){
  if (supplemental) {
    fig_str = "Figure S"
  } else {
    fig_str = "Figure "
  }
  dn_paste_counter(counter, fig_str, identifier)
}

#' table string
#'
#' Generate a "Table " string with the number included.
#'
#' @param counter the counter object
#' @param identifier the identifier to get the number for
#' @param supplemental should an "S" be added to the identifier
#'
#' @export
#' @return character
dn_table_string = function(counter, identifier = NULL, supplemental = FALSE){
  if (supplemental) {
    table_str = "Table S"
  } else {
    table_str = "Table"
  }
  dn_paste_counter(counter, table_str, identifier)
}


#' figure rename
#'
#' Generate a figure number for renaming within a path.
#'
#' @param counter the counter object
#' @param identifier the identifier for the figure
#' @param supplemental is this a supplemental
#'
#' @export
#' @return character
dn_figure_rename = function(counter, identifier = NULL, supplemental = FALSE){
  if (supplemental) {
    fig_str = "figure_s"
  } else {
    fig_str = "figure_"
  }
  dn_paste_counter(counter, fig_str, identifier)
}

#' modify figure path
#'
#' We often want to include the figure number in figure file names.
#' This function allows us to rename them easily.
#'
#' @param figure_path the original figure path
#' @param options the chunk options
#'
#' @description This function uses chunk options to rename the figure file.
#'   You should add a chunk option called `counter_identifier` that uses
#'   `dn_figure_rename` to get the figure number. See the vignette for an
#'   example of how to use this in an actual document.
#'
#' @export
#' @return character
dn_modify_path = function(figure_path, options){
  if (!any(grepl("counter_identifier", names(options)))) {
    stop("No chunk option `counter_identifer` provided, stopping!")
  }
  figure_identifier = options[["counter_identifier"]]
  org_dir = dirname(figure_path)
  file_name = basename(figure_path)

  new_name = paste0(figure_identifier, "_", file_name)
  new_file = file.path(org_dir, new_name)
  file.rename(figure_path, new_file)
  new_file
}
