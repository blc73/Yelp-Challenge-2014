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

log using "$logs/`date' 06 histogram of stars.log", replace


use "$temp/sorted Index.dta"

graph bar, over(stars_given)

graph export "/Users/Ben/Desktop/Independent Networks Projects/Reshape and clean categories/Output/Distribution_of_stars.eps", as(eps) preview(off) replace

*EOF
