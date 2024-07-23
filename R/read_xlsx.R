# Goal 1：read xlsx file
# Goal 2：output need sheet name,column name
# Goal 3：data type is as.tibble

# def of function
read_xlsx_tool <- function(path){
	#列出目錄下all file name，pattern = "\\.xlsx$ 限制只列出xlsx資料
	file_name <- list.files(path, pattern = "\\.xlsx$", full.names = TRUE)

	#read file 批次讀取所有 xlsx file
	data_list <- lapply(file_name, function(file){
		file_name <- basename(file)  # basename 截資料名稱
		data <- readxl::read_xlsx(file_name)  #讀xlsx檔案
		data <- as.data.frame(data) #轉成data.frame 格式
	})
	cat("Sheet name :\n")
	cat(sprintf("%d,%s \n",1:length(data_list), basename(file_name)))
	cat("column name:\n")
	print(lapply(data_list,names))
}
