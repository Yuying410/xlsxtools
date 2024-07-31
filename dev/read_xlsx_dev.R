##### 7/31 #####
# test
path <- system.file("extdata",package = "xlsxtools")
file.exists(path)
file_paths <- list.files(path, full.names = T)
file.exists(file_paths)
read_xlsx_name(file_paths)

#for test
file_name <- names(all_data)
sheet_names <- extract_sheet_names(all_data, file_name[1])
column_names <- names(all_data[[file_name[1]]][[sheet_names[1]]])
column_names <- extract_column_names(all_data, file_name[1], sheet_names[1])


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

path <- system.file("extdata", package = "xlsxtools")
file_paths <- list.files(path, full.names = T)

non_existent_file <- tempfile(fileext = ".xlsx")
paths <- c(file_paths,non_existent_file)
name_table <- read_xlsx_name(paths)
read_xlsx_name(paths)




##### 7/29 #####
rm(list = ls())
path <- system.file("extdata",package = "xlsxtools")
file_paths <- list.files(path, full.names = T)
read_xlsx_name(file_paths)


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

##main
read_xlsx_name <- function(file_path){
	read_xlsx_sheets <- function(file_path) {
		sheet_names <- openxlsx::getSheetNames(file_path)
		sheets_data <- lapply(sheet_names, function(sheet_name) {
			readxl::read_xlsx(file_path, sheet = sheet_name)
		})
		names(sheets_data) <- sheet_names
		return(sheets_data)
	}

	all_data <- lapply(file_path, read_xlsx_sheets)
	names(all_data) <- basename(file_path)

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

