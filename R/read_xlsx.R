# Goal 1：read xlsx file
# Goal 2：output variable：(file name),sheet name,column name
# Goal 3：data type is as.tibble
# pattern to chosse file

# def of function
read_xlsx_tool <- function(path){
	#列出目錄下all file name，pattern = "\\.xlsx$ 限制只列出xlsx資料
	#file_name <- list.files(path, pattern = "\\.xlsx$", full.names = TRUE)

	#read file 批次讀取所有 xlsx file
	data_list <- lapply(file_name, function(file){
		file_name <- basename(file)  # basename 截資料名稱
		data <- readxl::read_xlsx(file_name)  #讀xlsx檔案
	})
	max_length <- max(sapply(data_list, length))
	# 填補每個元素，使其具有相同的長度
	padded_list <- lapply(data_list, function(x) {
		length(x) <- max_length
		return(x)
	})
	column_list <-lapply(data_list,names)
	column_list <-tibble::as_tibble(column_list,.name_repair = c("universal"))
	names(column_list) <- basename(file_name)
	print(column_list)
}

#未完
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

	file_path <- system.file("extdata", "i_dataset.xlsx", package = "xlsxtools")
	sheets_data <- read_xlsx_sheets(file_path)
	file_paths <- sapply(file_names, function(x){system.file("extdata", x, package = "xlsxtools")})#所有檔案路徑

	#一個檔案多個sheet
	read_multiple_files <- function(file_paths) {
		all_data <- lapply(file_paths, read_xlsx_sheets)
		return(all_data)
	}
}


