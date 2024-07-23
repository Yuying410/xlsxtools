read_xlsx_tool("C:/Users/annie/Documents/git/olist_data")
readxl::read_xlsx("olist_customers_dataset")


##test
path <- "C:/Users/annie/Documents/git/olist_data"
file_name <- list.files(path, pattern = "\\.xlsx$", full.names = TRUE)
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
