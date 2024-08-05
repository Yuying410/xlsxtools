test_that("Confirm that the result of the new function is still correct", {
	# Example :
	path <- system.file("extdata",package = "xlsxtools")
	file_path <- list.files(path, full.names = TRUE)
	all_data <- lapply(file_path, read_xlsx_sheets)
	result <- read_xlsx_name(file_path)

	# constructive::construct(result)
	expected <- tibble::tibble(
		file = rep(c("i_dataset.xlsx", "m_dataset.xlsx"), 13:14),
		sheet = rep(c("infert_data", "iris_data", "morley_data", "mtcars_data"), c(8L, 5L, 3L, 11L)),
		column = c(
			"education", "age", "parity", "induced", "case", "spontaneous", "stratum",
			"pooled.stratum", "Sepal.Length", "Sepal.Width", "Petal.Length",
			"Petal.Width", "Species", "Expt", "Run", "Speed", "mpg", "cyl", "disp", "hp",
			"drat", "wt", "qsec", "vs", "am", "gear", "carb"
		),
	)

	expect_equal(result, expected)
})

test_that(" NA files ignored with warning", {
	temp_dir <- tempdir()
	temp_file1 <- file.path(temp_dir, "temp_file1.xlsx") # write.csv
	writexl::write_xlsx(data.frame(), temp_file1)

	expect_warning(results <- read_xlsx_name(c(temp_file1,"12455")))
	expect_equal(results,  tibble::tibble(file = character(), sheet = character(), column = character()))
})


test_that("corrupted .xlsx files ignored with warning", {
	temp_dir <- tempdir()
	temp_file1 <- file.path(temp_dir, "temp_file1.csv") # csv -> csv
	temp_file2 <- file.path(temp_dir, "temp_file2.xlsx") # xlsx -> csv

	temp_file3 <- file.path(temp_dir, "temp_file3.csv")  # csv -> xlsx (need to output)
	temp_file4 <- file.path(temp_dir, "temp_file4.xlsx") # xlsx -> xlsx (need to output)

	# 不管檔案路徑為csv/xlsx,只要是writexl::write_xlsx,也要用readxl::read_xlsx讀,
	# 否則 readxl::read_xlsx裡會出現zip無法讀檔問題
	# read.csv(temp_file3)
	# readxl::read_xlsx(temp_file3)
	# openxlsx::read.xlsx(temp_file3)  #openxlsx can only read .xlsx or .xlsm files
	# openxlsx::getSheetNames(temp_file3)

	write.csv(iris, temp_file1)
	write.csv(iris, temp_file2)
	writexl::write_xlsx(mtcars, temp_file3)
	writexl::write_xlsx(mtcars, temp_file4)

	file_path <- list.files(temp_dir, full.names = TRUE)
	file_paths <- c(file_path, file.path(temp_dir, "nonexistent.xlsx"))

	# constructive::construct(results)
	expect_warning(	results <- read_xlsx_name(file_paths))
	expected <- tibble::tibble(
		file = rep(c("temp_file3.csv", "temp_file4.xlsx"), each = 11L),
		sheet = rep("Sheet1", 22L),
		column = rep(
			c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb"),
			2
		),
	)
	expect_equal(results, expected) # later, we should allow the "csv" file
})
