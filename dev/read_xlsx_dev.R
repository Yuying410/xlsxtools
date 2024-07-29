system.file("extdata","i_dataset.xlsx",package = "xlsxtools")

##### 7/29 new ######################
rm(list = ls())
path <- system.file("extdata",package = "xlsxtools")
read_xlsx_tool("C:/Users/annie/Documents/git/xlsxtools/inst/extdata","i")

# def of function
read_xlsx_tool <- function(path1,pattern1){
	# file.exists(path)
	# path1 <- system.file("extdata",package = "xlsxtools")
	# pattern1 <- "i"
	#file_names <- list.files(path, full.names = F)  #"i_dataset.xlsx" "m_dataset.xlsx"

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


##test
path <- "C:/Users/annie/Documents/git/olist_data"
file_name <- list.files(path, pattern = "\\.xlsx$", full.names = F)
data_list <- lapply(file_name, function(file){
	file_name <- basename(file)  # basename 截資料名稱
	data <- readxl::read_xlsx(file_name)  #讀xlsx檔案
	#data <- as.data.frame(data) #轉成data.frame 格式
})


basename(file_name)
lapply(data_list,names)

cat(sprintf("Sheet name: %d,%s \n",1:length(data_list), basename(file_name)))


data_list <- unlist(data_list)

column_list <-lapply(data_list,names)
column_list <-as.data.frame(column_list)

##test
path <- "C:/Users/annie/Documents/git/olist_data"
file_name <- list.files(path, pattern = "\\.csv", full.names = TRUE)
data_list <- lapply(file_name, function(file){
	file_name <- basename(file)  # basename 截資料名稱
	data <- read.csv(file_name)  #讀xlsx檔案
	#data <- as.data.frame(data) #轉成data.frame 格式
})
max_length <- max(sapply(data_list, length))


# 填補每個元素，使其具有相同的長度
padded_list <- lapply(data_list, function(x) {
	length(x) <- max_length
	return(x)
})

########################
read_csv_tool <- function(path){
	file_name <- list.files(path, pattern = "\\.csv$", full.names = TRUE)
	data_list <- lapply(file_name, function(file){
		file_name <- basename(file)  # basename 截資料名稱
		data <- read.csv(file_name)  #讀csv檔案
	})
	max_length <- max(sapply(data_list, length))
	# 填補每個元素，使其具有相同的長度
	padded_list <- lapply(data_list, function(x) {
		length(x) <- max_length
		return(x)
	})
	column_list <-lapply(padded_list,names)
	column_list <-tibble::as_tibble(column_list,.name_repair = c("universal"))
	names(column_list) <- basename(file_name)
	print(column_list)
}
##### 7/23 new ######################
rm(list = ls())
path <- system.file("extdata",package = "xlsxtools")
read_xlsx_tool(path)



path <- system.file("extdata",package = "xlsxtools")
file_names <- list.files(path, pattern = "\\.xlsx$", full.names = F)
file_length <- length(file_names)

##check sheet
sheet_names <- file_names |> lapply(openxlsx::getSheetNames)
#sheet_length <- length(sheet_names)
sheet_length <- sheet_names |> lapply(length)

sheets_data <- list()



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

# 使用函數來展開列表並創建 tibble
a <- name_list(all_data)
print(a)







name_tibble <- function(all_data) {
	purrr::imap_dfr(all_data, function(sheets, file) {
	purrr::imap_dfr(sheets, function(columns, sheet) {
		tibble::tibble(
			file = file,
			sheet = sheet,
			column = names(columns)
			)
		})
	})
}





#7/29 改之前
read_xlsx_tool <- function(path,pattern1){
	file_names <- list.files(path, pattern = pattern1, full.names = F)  #"i_dataset.xlsx" "m_dataset.xlsx"
	file_length <- length(file_name) #2

	##check sheet
	sheet_names <- file_names |> lapply(openxlsx::getSheetNames)
	sheet_length <- sheet_names |> lapply(length)

	read_xlsx_sheets <- function(file_path) {
		sheet_names <- openxlsx::getSheetNames(file_path)
		sheets_data <- list()
		for (sheet_name in sheet_names) {
			sheets_data[[sheet_name]] <- readxl::read_xlsx(file_path, sheet = sheet_name)
		}
		return(sheets_data)
	}

	#file_path <- system.file("extdata", "i_dataset.xlsx", package = "xlsxtools")
	all_file_path <- function(file_names) {
		all_file_path <- list()
		for (file_name in file_names) {
			all_file_path[[file_name]] <-system.file("extdata", file_name, package = "xlsxtools")
		}
		return(all_file_path)
	}
	file_path <- file_names |> lapply(all_file_path)

	sheets_data <- read_xlsx_sheets(file_path)
	file_paths <- sapply(file_names, function(x){system.file("extdata", x, package = "xlsxtools")})#所有檔案路徑
	cloumn_name <- sheets_data |> lapply(names)


	#一個檔案多個sheet
	read_multiple_files <- function(file_paths) {
		all_data <- lapply(file_paths, read_xlsx_sheets)
		return(all_data)
	}
}
