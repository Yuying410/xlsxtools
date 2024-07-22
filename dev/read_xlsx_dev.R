read_xlsx_tool("C:/Users/annie/Documents/git/olist_data")
readxl::read_xlsx("olist_customers_dataset")


##test
path <- "C:/Users/annie/Documents/git/olist_data"
file_name <- list.files(path, pattern = "\\.xlsx$", full.names = TRUE)
data_list <- lapply(file_name, function(file){
	file_name <- basename(file)
	readxl::read_xlsx(file_name)
})

print(data_list)


lapply(data_list,names)
print(lapply(data_list,names))
