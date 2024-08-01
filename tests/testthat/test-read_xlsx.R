test_that("1. confirm that there are elements in tibble", {
	# Example :
	path <- system.file("extdata",package = "xlsxtools")
	file_path <- list.files(path, full.names = TRUE)
	all_data <- lapply(file_path, read_xlsx_sheets)
	result <- read_xlsx_name(file_path)
	names(all_data) <- basename(file_path)
	expect_true(all(
		names(all_data) %in% result$file,
		result$file %in% names(all_data)
		))
	expect_true(all(
		c(names(all_data[[1]]),names(all_data[[2]])) %in% result$sheet,
		result$sheet %in% c(names(all_data[[1]]),names(all_data[[2]]))
		))
	expect_equal(c(names(all_data[[1]][[1]]),
				   names(all_data[[1]][[2]]),
				   names(all_data[[2]][[1]]),
				   names(all_data[[2]][[2]])),result$column)
	expect_s3_class(result,"tbl_df")
})

test_that("2. path works correctly and show warning", {
	temp_dir <- tempdir()
	temp_file1 <- file.path(temp_dir, "temp_file1.xlsx")
	temp_file2 <- file.path(temp_dir, "temp_file2.csv")
	test_dataset1 <- openxlsx::write.xlsx(list(sheet1 = data.frame(A = 1:3, B = 4:6)), temp_file1)
	test_dataset2 <- openxlsx::write.xlsx(list(sheet2 = data.frame(X = 7:9, Y = 10:12)), temp_file2)


	path <- system.file("extdata",package = "xlsxtools")
	file_path <- list.files(path, full.names = TRUE)
	file_path1 <- list.files(temp_dir, full.names = TRUE)
	non_existent_file <- file.path(temp_dir, "nonexistent.xlsx")

	file_paths <- c(file_path,file_path1,non_existent_file, 123548)
	expect_warning(result <- read_xlsx_name(file_paths), "Invalid paths")
})




