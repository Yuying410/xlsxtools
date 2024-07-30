
# xlsxtools

<!-- badges: start -->
<!-- badges: end -->

This project is mainly for practicing the development process. 
The goal of xlxstools is to provide all the files needed to read the folder at one time.

## Installation

You can install the development version of xlsxtools from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Yuying410/xlsxtools")
```

## Example

This is a basic example which shows you how to solve a common problem:

# Example 1 :
path <- system.file("extdata",package = "xlsxtools")
file_path <- list.files(path, full.names = TRUE)
read_xlsx_name(file_path)

# Example 2 :
path <- system.file("extdata",package = "xlsxtools")
file_path <- list.files(path,pattern="i", full.names = TRUE)
read_xlsx_name(file_path)

``` r
library(xlsxtools)
## basic example code
```

