#' File, sheet, column Names Overview
#'
#' Display xlsx file, worksheet,variable name in table to view data name
#'
#' not done
#' @param file_paths the path of the file which the data are to be read from.
#'
#' @return a tibble
#' @export
read_xlsx_tool <- function(file_paths){
read_xlsx_sheets <- function(file_path) {
	sheet_names <- openxlsx::getSheetNames(file_path)
	sheets_data <- lapply(sheet_names, function(sheet_name) {
		readxl::read_xlsx(file_path, sheet = sheet_name)
	})
	names(sheets_data) <- sheet_names
	return(sheets_data)
}

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
	final_result <- dplyr::bind_rows(purrr::flatten(result))
	final_result
}
return(name_list(all_data))
}
#' @export
read_xlsx_sheets <- function(file_path) {
	sheet_names <- openxlsx::getSheetNames(file_path)
	sheets_data <- lapply(sheet_names, function(sheet_name) {
		readxl::read_xlsx(file_path, sheet = sheet_name)
	})
	names(sheets_data) <- sheet_names
	return(sheets_data)
}
#' @export
name_list <- function(all_data) {
	file_names <- names(all_data)
	result <- lapply(file_names, function(file_names) {
		sheet_names <- names(all_data[[file_names]])
		lapply(sheet_names, function(sheet_names) {
			column_names <- names(all_data[[file_names]][[sheet_names]])
			tibble::tibble(
				file = file_names,
				sheet = sheet_names,
				column = column_names
			)
		})
	})
	final_result <- dplyr::bind_rows(purrr::flatten(result))
	final_result
}

#' @examples
#' path <- system.file("extdata",package = "xlsxtools")
#' # full.names must be true, because openxlsx need read full path
#' file_paths <- list.files(path, full.names = T)
#' read_xlsx_tool(file_paths)
#'

read_xlsx_tool <- function(file_paths){
	read_xlsx_sheets <- function(file_path) {
		sheet_names <- openxlsx::getSheetNames(file_path)
		sheets_data <- lapply(sheet_names, function(sheet_name) {
			readxl::read_xlsx(file_path, sheet = sheet_name)
		})
		names(sheets_data) <- sheet_names
		return(sheets_data)
	}

	all_data <- lapply(file_paths, read_xlsx_sheets)
	names(all_data) <- basename(file_paths)

	#變數名稱表
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
		final_result <- dplyr::bind_rows(purrr::flatten(result))
		final_result
	}
	return(name_list(all_data))
}

