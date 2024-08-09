#' Counting figures and tables
#'
#' The counter is configurable and queryable to show what has already been done.
#' It provides an alternative to the {bookdown} word_document2 format.
#'
#' @section Creating the counter:
#' The counter is an R6 object, that can be created with \code{dn_counter$new()}.
#' It has the following arguments:
#' \describe{
#'   \item{prefix}{The text to prefix to the number. Normally one would use
#'   "Figure " or "Table " (note the spaces).}
#'   \item{space_fill}{The character to use to replace " " if using the prefix as
#'   part of a file name.}
#'   \item{prefix2}{A second prefix to add, if you need "S" for supplemental, for example.}
#'   \item{link}{"yes" or "no". Default is "no".}
#' }
#'
#' @section Using the counter:
#' There is one function to add to the counter, \code{dn_counter$increment("name")}
#' increases the count and adds the name to the count for recall later.
#'
#' \code{dn_counter$label_text("name")} returns a text string for use in text,
#'   "Figure 1" for example.
#'
#' \code{dn_counter$label_caption("name")} returns a text string to use in a caption.
#'
#' \code{dn_counter$just_count("name")} returns just the count as a string, with {prefix2} if it was supplied.
#'
#' \code{dn_counter$label_file("name")} returns a text string for use as part of
#'   a file name, "Figure_1" as an example.
#'
#' \code{dn_counter$rename("old_name", "new_name")} replaces the names on the count
#'   object so that you can refer to the correct one.
#'
#' \code{dn_counter$modify_path(oldpath, label)} generates a new path filename that incorporates the figure number.
#'   This is most useful with `knitr::opts_chunk$set(fig.process = my_counter$modify_path)`.
#'
#' \code{dn_counter} displays the prefix, file replacement text, the current set of
#'   counts, and their names.
#'
#' @name dn_counter
#' @export
NULL

dn_counter = R6::R6Class("dn_counter", list(
  count = vector("numeric", length = 0),
  increment = function(name = NULL){
    if (is.null(name)) {
      stop("Please provide at least 1 name to increment the count!")
    } else if (any(name %in% names(self$count))) {
      stop("That name already exists, use something else!")
    } else {
      n_names = length(name)
      n_count = length(self$count)

      use_number = paste0(self$prefix2, n_count + seq_len(n_names))

      self$count = c(self$count, use_number)
      names(self$count)[seq(n_count + 1, n_count + n_names)] = name
      invisible(self)
    }
  },
  rename = function(old_name = NULL, new_name = NULL) {
    if (is.null(old_name) || is.null(new_name)) {
      stop("Neither old_name OR new_name cannot be NULL!")
    }
    if (!any(old_name %in% names(self$count))) {
      stop(paste0('old_name "', old_name, '" not found in counter!'))
    }
    if (any(new_name %in% names(self$count))) {
      stop(paste0('new_name "', new_name, '" already being used in counter!'))
    }
    match_loc = which(names(self$count) %in% old_name)
    names(self$count)[match_loc] = new_name
    invisible(self)
  },
  label_text = function(name = NULL) {
    if (!any(name %in% names(self$count))) {
      stop(paste0('name "', name, '" not found!'))
    }
    name_loc = sort(which(names(self$count) %in% name), decreasing = FALSE)
    name_number = self$count[name_loc]

    if ((length(name_number) > 2) || ((name_loc[length(name_loc)] - name_loc[1]) > 1)) {
      str_numbers = paste0(name_number[1], "-", name_number[length(name_number)])
    } else if (length(name_number) == 2) {
      str_numbers = paste(name_number, collapse = ", ")
    } else if (length(name_number) == 1) {
      str_numbers = name_number
    }

    if (length(name_number) > 1) {
      tmp_prefix = gsub("Table", "Tables", self$prefix)
      tmp_prefix = gsub("Figure", "Figures", tmp_prefix)
    } else {
      tmp_prefix = self$prefix
    }
    use_text = paste(tmp_prefix, str_numbers, sep = "")

    if ((self$link %in% "yes") & (length(name_number) == 1)) {
      use_text = paste('<a href="#', name, '">', use_text, '</a>', sep = "")
    }

    return(use_text)
  },

  label_caption = function(name = NULL) {
    if (is.null(name)) {
      stop(paste0('name cannot be NULL!'))
    }
    if (length(name) > 1) {
      stop(paste('Only one \'name\' can be passed for labeling captions!'))
    }
    if (!any(name %in% names(self$count))) {
      stop(paste0('name "', name, '" not found!'))
    }
    name_loc = which(names(self$count) %in% name)

    name_number = self$count[name_loc]
    tmp_prefix = self$prefix

    use_text = paste(tmp_prefix, name_number, sep = "")

    if ((self$link %in% "yes")) {
      use_text = paste('<a id="', name, '">', use_text, '</a>', sep = "")
    }

    return(use_text)
  },

  label_file = function(name = NULL) {
    if (!any(name %in% names(self$count))) {
      stop(paste0('name "', name, '" not found!'))
    }
    name_number = self$count[name]
    if (length(name_number) > 1) {
      stop("Please provide only one name at a time for files!")
    }
    use_text = paste(self$file_replace, name_number, sep = "")
    return(use_text)
  },
  modify_path = function(path, label) {
    out_file = try(self$label_file(label))
    if (inherits(out_file, "try-error")) {
      return(path)
    } else {
      org_dir = dirname(path)
      file_name = basename(path)

      new_name = paste0(out_file, "-", file_name)
      new_file = file.path(org_dir, new_name)
      #print(new_file)
      file.rename(path, new_file)
      return(new_file)
    }
  },
  just_count = function(name = NULL) {
    if (!any(name %in% names(self$count))) {
      stop(paste0('name "', name, '" not found!'))
    }
    name_number = self$count[name]
    return(name_number)
  },
  print = function(...) {
    cat("  dn_counter: \n")
    cat("      prefix: ", self$prefix, "\n", sep = "")
    cat("        link: ", self$link, "\n", sep = "")
    cat("file_replace: ", self$file_replace, "\n", sep = "")
    cat("       count: ", paste0(self$count, collapse = ", "), "\n", sep = "")
    cat("       names: \n")
    print(names(self$count))
    invisible(self)
  },
  prefix = "",
  prefix2 = "",
  link = "",
  file_replace = NULL,

  initialize = function(prefix = "Figure ",
                        space_fill = "_",
                        prefix2 = "",
                        link = "no") {
    self$prefix = prefix
    self$prefix2 = prefix2
    self$file_replace = gsub(" ", space_fill, prefix)
    self$link = link
    invisible(self)
  }
))
