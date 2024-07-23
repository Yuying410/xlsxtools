read_xlsx_tool("C:/Users/annie/Documents/git/olist_data")
readxl::read_xlsx("olist_customers_dataset")
read_csv_tool("C:/Users/annie/Documents/git/olist_data")
system.file("extdata","i_dataset.xlsx",package = "xlsxtools")


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
library(magrittr)
function(path,pattern){}

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
file_path <- system.file("extdata", "i_dataset.xlsx", package = "xlsxtools")
sheets_data <- read_xlsx_sheets(file_path)
print(sheets_data)



file_paths <- sapply(file_names, function(x){system.file("extdata", x, package = "xlsxtools")})

read_multiple_files <- function(file_paths) {
	all_data <- lapply(file_paths, read_xlsx_sheets)
	return(all_data)
}
all_sheets_data <- read_multiple_files(file_paths)

