create_local_output_directory = function(dir = tempfile(), env = parent.frame()) {
  withr::defer({
    unlink(dir, recursive = TRUE, force = TRUE)
  })
  dir
}

test_that("figure renaming works", {
  skip_if_not_installed("rmarkdown")
  use_dir = create_local_output_directory()
  dir.create(use_dir)
  final_rmd = file.path(use_dir, "chunk_success.Rmd")
  file.copy("chunk_success.Rmd", final_rmd, overwrite = TRUE)
  final_md = file.path(use_dir, "chunk_success.md")
  figure_loc = file.path(use_dir, "chunk_success_files", "figure-html", "Figure_1_plot_rnorm-1.png")
  figure2_loc = file.path(use_dir, "chunk_success_files", "figure-html", "Figure_2_test2-1.png")
  rmarkdown::render(final_rmd, rmarkdown::html_document(keep_md = TRUE))
  expect_true(file.exists(figure_loc))
  expect_true(file.exists(figure2_loc))
})

test_that("missing option failes", {
  skip_if_not_installed("rmarkdown")
  use_dir = create_local_output_directory()
  dir.create(use_dir)
  final_rmd = file.path(use_dir, "chunk_failure.Rmd")
  final_md = file.path(use_dir, "chunk_failure.md")
  file.copy("chunk_failure.Rmd", final_rmd)
  expect_error(rmarkdown::render(final_rmd, rmarkdown::html_document(keep_md = TRUE)))
})
