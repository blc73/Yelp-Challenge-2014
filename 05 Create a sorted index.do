***********************************
***********************************
**        ~Confidential~         **
**        Nov. 30, 2014	   		   **
**     Washington, DC 20010		   **
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

log using "$logs/`date' 05 create a sorted index.log", replace
****************************

use "$temp/Index with category indicator matrix.dta"
*Load into memory a 229,907 review data set from Yelp.



gsort -date
gen year = substr(date,1,4)
gen month = substr(date,6,2)
gen day = substr(date,9,2)
order date year month day
destring year, replace
destring month, replace
destring day, replace
*generate intiger date variables

gsort -date

save "$temp/sorted Index.dta", replace
*EOF
