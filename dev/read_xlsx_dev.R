##### 7/31 #####
# test
path <- system.file("extdata",package = "xlsxtools")
file.exists(path)
file_paths <- list.files(path, full.names = T)
read_xlsx_name(file_paths)


valid_path <- valid_paths
file_path <- file_paths
file_path <- c("1")
path <- file_path
read_xlsx_name(file_path)

# read sheet in one file
read_xlsx_sheets <- function(file_path) {
	valid_path <- file_path[file.exists(file_path)]
	invalid_path <- file_path[!file.exists(file_path)]
	if (length(valid_path) == 0) {
		warning("No valid files found in provided paths.")
	}
	if (length(valid_path) > 1) {
		warning("More than one file path provided, but the path in read_xlsx_sheets() only be one.")
	}
	sheet_names <- readxl::excel_sheets(file_path)
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
	all_warnings <- list()
	valid_xlsx <- lapply(file_path, function(path) {
		tryCatch({
			read_data <- readxl::read_xlsx(path, n_max = 1)
			path
		}, error = function(e) {
			all_warnings <<- c(all_warnings, sprintf("readxl::read_xlsx(): %s", e$message))
			NULL
		})
	}) |> unlist()

	if (length(all_warnings) > 0) {
		warning(paste(all_warnings, collapse = "\n"))
	}
	all_data <- lapply(valid_xlsx, read_xlsx_sheets)
	names(all_data) <- basename(valid_xlsx)

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
}

