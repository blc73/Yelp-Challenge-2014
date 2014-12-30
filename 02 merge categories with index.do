***********************************
***********************************
**        ~Confidential~         **
**        Nov. 30, 2014	      	 **
**     Washington, DC       		 **
**       blc73@cornell.edu       **
***********************************
***********************************

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

log using "$logs/`date' 02 merge categories with index.log", replace
**********************
use "$output/category indicator matrix.dta

contract *

merge 1:m business_id using "$input/Index.dta", generate(_mergecategorymatrix)
rename _m* merge*


foreach X of varlist _* {
	replace `X' = 0 if mi(`X')
	}
	

save "$output/Index with category indicator matrix.dta", replace
save "$temp/Index with category indicator matrix.dta", replace
*EOF
