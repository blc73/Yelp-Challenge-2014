***********************************
***********************************
**       Research of blc73       **
**        ~Confidential~         **
**        Washington, DC   		   **
**       blc73@cornell.edu       **
***********************************
***********************************
*for lines 15-20, please set up a new project folder with 5 subfolders (Logs, Input, Scripts, Output, and Temp).
*Set the root file-path in line 15 to the file-path of your new project folder.
clear
set more off

global root "/Users/Ben/Desktop/Independent Networks Projects/Reshape and clean categories"
global logs $root/Logs
global input $root/Input
global scripts $root/Scripts
global output $root/Output
global temp $root/Temp
capture log close

local date = string(year(date("$S_DATE","DMY")))+"."+substr("0"+string(month(date("$S_DATE","DMY"))),-2,2)+"."+substr("0"+string(day(date("$S_DATE","DMY"))),-2,2)

log using "$logs/`date' 01 Reshape categories.log", replace
*******************


use "$input/Index.dta"
*Load into memory a 229,907 review data set from Yelp.
keep business_id name categories open
tempfile name
save "`name'

keep business_id categories

split categories, parse(",")

forval num = 1/11 {
replace categories`num' = "." if mi(categories`num')
}
duplicates drop
drop categories
reshape long categories, i(business_id) j(temp)

drop if categories == "."
gen _ = 1
replace categories = trim(categories)
drop temp
replace categories = strtoname(categories)
replace categories = substr(categories,1,31)
reshape wide _, i(business_id) j(categories) string

merge 1:m business_id using "`name'"

save "$output/category indicator matrix.dta", replace
save "$temp/category indicator matrix.dta", replace

*EOF
