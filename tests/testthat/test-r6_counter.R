test_that("r6 counter works", {
  t_count = dn_counter$new("Figure ", "_")
  t_count$increment("t1")
  t_count$increment("t2")

  expect_equal((t_count$count)[2], c("t2" = "2"))
  expect_equal(length(t_count$count), 2)
  expect_equal(t_count$label_text("t2"), "Figure 2")
  expect_equal(t_count$label_text(c("t1", "t2")), "Figures 1, 2")
  expect_equal(t_count$label_file("t1"), "Figure_1")
  expect_equal(t_count$just_count("t1"), c("t1" = "1"))
  expect_error(t_count$label_text("t3"))
  expect_error(t_count$label_file("t3"))
  expect_error(t_count$label_file(c("t1", "t2")))

  expect_invisible(t_count$rename("t1", "t3"))
  expect_equal(t_count$label_text("t3"), "Figure 1")
  expect_error(t_count$rename("t4", "t5"))
  expect_error(t_count$rename("t1", "t3"))
  expect_error(t_count$rename("t3", "t2"))

  t_count$increment("t4")
  expect_equal(t_count$label_text(c("t3", "t2", "t4")), "Figures 1-3")
  expect_equal(t_count$label_text(c("t3", "t4")), "Figures 1-3")

  t_count$prefix = "Table "
  expect_equal(t_count$label_text(c("t3", "t4")), "Tables 1-3")
  t2_count = dn_counter$new("Figure ", "_", "S")
  t2_count$increment("t1")
  t2_count$increment("t2")
  expect_equal(t2_count$label_text("t1"), "Figure S1")
  expect_equal(t2_count$label_file("t1"), "Figure_S1")
})
