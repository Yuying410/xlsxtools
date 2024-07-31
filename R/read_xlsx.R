#' Overview xlsx files name
#'
#' read_xlsx_name(.) displays the xlsx file name, sheet name, and variable name in the table to browse the data overview
#'
#' The xlxstools package provides all the files needed to read into a folder at once.
#' Also can filter out the required files through the pattern in list.files(path,pattern="xxx", full.names = TRUE) and then input the path.
#'
#'
#' @param file_path The path to the xlsx file
#'
#' ( read_xlsx_name(.) allows multiple paths, read_xlsx_sheets(.) just only input one path ).
#'
#' @return - return a tibble : n × 3. n changes based on the file read.
#'
#' - The type of the column is character, and the column's name is "File", "Sheet", "Column".
#'
#' @export

#' @examples
#' # Example 1 :
#' path <- system.file("extdata",package = "xlsxtools")
#' file_path <- list.files(path, full.names = TRUE)
#' read_xlsx_name(file_path)
#'
#' # Example 2 :
#' path <- system.file("extdata",package = "xlsxtools")
#' file_path <- list.files(path,pattern="i", full.names = TRUE)
#' read_xlsx_name(file_path)
#'
# read sheet in one file
read_xlsx_sheets <- function(file_path) {
	sheet_names <- openxlsx::getSheetNames(file_path)
	sheets_data <- lapply(sheet_names, function(sheet_name) {
		readxl::read_xlsx(file_path, sheet = sheet_name)
	})
	names(sheets_data) <- sheet_names
	return(sheets_data)
}

#extract sheet names in one file
extract_sheet_names <- function(all_data, file_name) {
	sheet_names <- names(all_data[[file_name]])
	return(sheet_names)
}

#extract column names in one sheet
extract_column_names <- function(all_data, file_name, sheet_name) {
	column_names <- names(all_data[[file_name]][[sheet_name]])
	return(column_names)
}


# main function
read_xlsx_name <- function(file_path) {
	# check input path is xlsx and length!=0
	valid_paths <- file_paths[file.exists(file_path) & grepl("\\.xlsx$", file_path)]
	invalid_paths <- file_path[!file.exists(file_path) | !grepl("\\.xlsx$", file_path)]
	if (length(valid_paths) == 0) {
		stop("No valid files found in provided paths.")
	}

	# check paths is character
	if (!is.character(valid_paths)) {
		stop("Error: Paths must be a character vector.")
	}

	all_data <- lapply(valid_paths, read_xlsx_sheets)
	names(all_data) <- basename(valid_paths)

	result <- lapply(names(all_data), function(file_name) {
		sheet_names <- extract_sheet_names(all_data, file_name)
		lapply(sheet_names, function(sheet_name) {
			column_names <- extract_column_names(all_data, file_name, sheet_name)
			tibble::tibble(
				file = file_name,
				sheet = sheet_name,
				column = column_names
			)
		})
	})
	final_result <- dplyr::bind_rows(purrr::flatten(result))
	return(final_result)
	warning("Some files do not exist: ", invalid_paths, collapse = ", ")
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
