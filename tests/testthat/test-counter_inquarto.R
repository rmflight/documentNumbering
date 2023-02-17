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
  final_qmd = file.path(use_dir, "chunk_success.qmd")
  file.copy("chunk_success.qmd", final_qmd, overwrite = TRUE)
  final_md = file.path(use_dir, "chunk_success.md")
  figure_loc = file.path(use_dir, "chunk_success_files", "figure-html", "Figure_1-testfigure-1.png")
  figure2_loc = file.path(use_dir, "chunk_success_files", "figure-html", "Figure_2-test2-1.png")
  quarto::quarto_render(final_qmd)
  expect_true(file.exists(figure_loc))
  expect_true(file.exists(figure2_loc))
})

test_that("wrong label fails", {
  skip_if_not_installed("rmarkdown")
  use_dir = create_local_output_directory()
  dir.create(use_dir)
  final_qmd = file.path(use_dir, "chunk_failure.qmd")
  final_md = file.path(use_dir, "chunk_failure.md")
  file.copy("chunk_failure.qmd", final_qmd)
  expect_error(quarto::quarto_render(final_qmd))
})
