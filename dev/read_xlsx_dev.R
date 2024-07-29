##### 7/29 ######################
rm(list = ls())
path <- system.file("extdata",package = "xlsxtools")
file_paths <- list.files(path, full.names = T) #openxlsx 只讀絕對路徑
read_xlsx_tool(file_paths)


# test
path <- system.file("extdata",package = "xlsxtools")
file.exists(path)
file_paths <- list.files(path, full.names = T) #openxlsx 只讀絕對路徑

# 定義一個函數來讀取每個文件的所有工作表
read_xlsx_sheets <- function(file_path) {
	sheet_names <- openxlsx::getSheetNames(file_path)
	sheets_data <- lapply(sheet_names, function(sheet_name) {
		readxl::read_xlsx(file_path, sheet = sheet_name)
	})
	names(sheets_data) <- sheet_names
	return(sheets_data)
}

# 讀取所有file和各file的工作表
all_data <- lapply(file_paths, read_xlsx_sheets)
names(all_data) <- basename(file_paths)

name_list <- function(all_data) {
	file_names <- names(all_data)
	# 遍歷每個file，並對每個file執行以下操作
	result <- lapply(file_names, function(file_names) {
		sheet_names <- names(all_data[[file_names]])
		# 遍歷每個sheet，並對每個sheets執行以下操作
		lapply(sheet_names, function(sheet_names) {
			column_names <- names(all_data[[file_names]][[sheet_names]])
			tibble::tibble(
				file = file_names,
				sheet = sheet_names,
				column = column_names
			)
		})
	})
	flat_result <- dplyr::bind_rows(purrr::flatten(result))
	final_result
}
name_list(all_data)



