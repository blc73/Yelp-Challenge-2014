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

log using "$logs/`date' 04 graph a network of bars.log", replace
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
*Sort the data set by date, in preparation for making connections only relevant for 

keep if year == 2012
keep if city == "Phoenix"
keep if _Bars == 1

*create a name/business_id Translation Table
preserve
	keep business_id name
	contract *
	save "$temp/TT.dta"
restore


by user_id, sort: gen gfreq = _N
expand gfreq
sort user_id business_id
by user_id business_id: gen numid2 = _n
by user_id: gen business_id2 = business_id[gfreq * numid2]
drop if business_id == business_id2
keep business_id*
duplicates drop

set seed 1
netplot business_id business_id2

merge m:1 business_id using "$temp/TT.dta"
rename name from
rename business_id2 business_id
merge m:1 business_id using "$temp/TT.dta"
rename name to

set seed 1
netplot from to, label
*EOF
