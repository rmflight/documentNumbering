#' modify figure path
#'
#' We often want to include the figure number in figure file names.
#' This function allows us to rename them easily.
#'
#' @param figure_path the original figure path
#' @param options the chunk options
#'
#' @description This function uses chunk options to rename the figure file.
#'   You should add a chunk option called `dn_id` that uses
#'   `dn_figure_rename` to get the figure number. See the vignette for an
#'   example of how to use this in an actual document.
#'
#' @export
#' @return character
dn_modify_path = function(figure_path, options){
  cat(names(options), sep = "\n")
  if (any(grepl("dn_id", names(options)))) {
    tmp_id = options[["dn_id"]]
    if (inherits(tmp_id, "character")) {
      #message("character")
      figure_identifier = options[["dn_id"]]
    } else if (inherits(tmp_id, "dn_counter")) {
      #message("counter")
      figure_identifier = tmp_id$label_file(options[["label"]])
    }

    org_dir = dirname(figure_path)
    file_name = basename(figure_path)

    new_name = paste0(figure_identifier, "_", file_name)
    new_file = file.path(org_dir, new_name)
    file.rename(figure_path, new_file)
    return(new_file)
  } else {
    return(figure_path)
  }
}
