test_that("r6 counter works", {
  t_count = dn_counter$new("Figure ", "_")
  t_count$increment("t1")
  t_count$increment("t2")

  expect_equal(max(t_count$count), 2)
  expect_equal(length(t_count$count), 2)
  expect_equal(t_count$label_text("t2"), "Figure 2")
  expect_equal(t_count$label_text(c("t1", "t2")), "Figure 1, 2")
  expect_equal(t_count$label_file("t1"), "Figure_1")
  expect_error(t_count$label_text("t3"))
  expect_error(t_count$label_file("t3"))

  expect_invisible(t_count$rename("t1", "t3"))
  expect_equal(t_count$label_text("t3"), "Figure 1")
  expect_error(t_count$rename("t4", "t5"))
  expect_error(t_count$rename("t1", "t3"))
  expect_error(t_count$rename("t3", "t2"))
})
