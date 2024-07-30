#' Overview xlsx files name
#'
#' read_xlsx_name() displays the xlsx file name, sheet name, and variable name in the table to browse the data overview
#'
#' The xlxstools package provides all the files needed to read into a folder at once.
#' Also can filter out the required files through the pattern in list.files(path,pattern="xxx", full.names = T) and then input the path.
#'
#'
#' @param file_paths The path to the xlsx file (multiple paths are allowed).
#'
#' @return - return a tibble : n × 3. n changes based on the file read.
#'
#' - The type of the column is character, and the column's name is "File", "Sheet", "Column".
#'
#' @export

#' @examples
#' Example 1 :
#' path <- system.file("extdata",package = "xlsxtools")
#' file_paths <- list.files(path, full.names = T)
#' read_xlsx_name(file_paths)
#'
#' Example 2 :
#' path <- system.file("extdata",package = "xlsxtools")
#' file_paths <- list.files(path,pattern="i", full.names = T)
#' read_xlsx_name(file_paths)
#'
read_xlsx_name <- function(file_paths){
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

#' @rdname read_xlsx_name
#' @export
read_xlsx_sheets <- function(file_path) {
	sheet_names <- openxlsx::getSheetNames(file_path)
	sheets_data <- lapply(sheet_names, function(sheet_name) {
		readxl::read_xlsx(file_path, sheet = sheet_name)
	})
	names(sheets_data) <- sheet_names
	return(sheets_data)
}
