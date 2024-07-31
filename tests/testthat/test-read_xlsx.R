temp_file <- tempfile(tmpdir = "~")
library(testthat)
library(readxl)
library(openxlsx)
library(dplyr)
library(tibble)
library(purrr)


test_that("path works correctly", {
	temp_dir <- tempdir()
	temp_file1 <- file.path(temp_dir, "temp_file1.xlsx")
	temp_file2 <- file.path(temp_dir, "temp_file2.csv")
	test_dataset1 <- openxlsx::write.xlsx(list(sheet1 = data.frame(A = 1:3, B = 4:6)), temp_file1)
	test_dataset2 <- openxlsx::write.xlsx(list(sheet2 = data.frame(X = 7:9, Y = 10:12)), temp_file2)

	path <- system.file("extdata",package = "xlsxtools")
	file_path <- list.files(path, full.names = TRUE)
	file_path1 <- list.files(temp_dir, full.names = TRUE)

	non_existent_file <- file.path(temp_dir, "nonexistent.xlsx")

	file_paths <- c(file_path,file_path1,non_existent_file)
	#file_path <- file_paths

	expect_true(read_xlsx_name(file_paths), info = "some file path does not exist")##not done
})

devtools::test()


