# Goal 1：read xlsx file
# Goal 2：output variable：(file name),sheet name,column name
# Goal 3：data type is as.tibble
# pattern to chosse file

# def of function
read_xlsx_tool <- function(path1,pattern1){
	file_names <- list.files(path = path1, pattern = pattern1, full.names = F)
	sheet_names <- file_names |> lapply(openxlsx::getSheetNames)
	#抓取所有資料
	read_xlsx_sheets <- function(file_path) {
		sheet_names <- openxlsx::getSheetNames(file_path)
		sheets_data <- list()
		for (sheet_name in sheet_names) {
			sheets_data[[sheet_name]] <- readxl::read_xlsx(file_path, sheet = sheet_name)
		}
		return(sheets_data)
	}
	file_paths <- sapply(file_names, function(x) system.file("extdata", x, package = "xlsxtools"))
	all_data <- lapply(file_paths, read_xlsx_sheets)

	#變數名稱表
	name_list <- function(all_data) {
		file_names <- names(all_data)
		# 遍歷每個file，並對每個file執行以下操作
		result <- lapply(file_names, function(file_names) {
			sheet_names <- names(all_data[[file_names]])
			# 遍歷每個sheet，並對每個sheets執行以下操作
			lapply(sheet_names, function(sheet_names) {
				column_names <- names(all_data[[file_names]][[sheet_names]])
				data.frame(
					file = file_names,
					sheet = sheet_names,
					column = column_names,
					stringsAsFactors = FALSE
				)
			})
		})
		flat_result <- do.call(c, result)
		final_result <- do.call(rbind, flat_result)
		final_result
	}
	return(name_list(all_data))
}

