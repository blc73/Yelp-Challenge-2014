***********************************
***********************************
**        ~Confidential~         **
**        Nov. 30, 2014	   	  	 **
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

log using "$logs/`date' 07 degree distribution.log", replace

use "$temp/sorted Index.dta"

keep if year == 2012
keep if city == "Phoenix"
by user_id, sort: gen gfreq = _N
expand gfreq
sort user_id business_id
by user_id business_id: gen numid2 = _n
by user_id: gen business_id2 = business_id[gfreq * numid2]
drop if business_id == business_id2
keep business_id*
duplicates drop

netsis business_id business_id2, measure(adjacency) name(B, replace)
netsummarize B, gen(degree) statistic(rowsum)
*http://www.stata.com/support/faqs/data-management/expanding-datasets-to-all-pairs/
*Nicholas J. Cox of Durham University explains the above commands and how they have stata create an edgelist from panel data

keep business_id degree_source
duplicates drop
bysort degree_source: gen freq = _n

histogram degree_source, discrete frequency ytitle(Frequency) ylabel(, format(%9.0g)) 
graph export "/Users/Ben/Desktop/Independent Networks Projects/Reshape and clean categories/Output/Degree_distribution.eps", as(eps) preview(off) replace

*EOF
