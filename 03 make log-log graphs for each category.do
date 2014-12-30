***********************************
***********************************
**        Sept. 20, 2014	       **
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

log using "$logs/`date' 03 make log-log graphs for each category.log", replace
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
histogram degree_source, discrete frequency ytitle("Frequency") xtitle("Degree") name(powerlaw, replace)
*Take the histogram before collapsing

collapse (count) freq, by (degree_source)
rename degree_source K
egen total = total(freq)
gen P_of_K = freq/total

local labels = ""
forval x = 1(1)3{
  local y = 10^`x'
  local labels =  "`labels'`y' "
}

local vallabel = ""
forval x = 1(1)3{
  local y = 10^`x'
  local vallabel =  `"`vallabel'`y' "10^`x'" "'
}
label define expon `vallabel',replace
label val K expon
label val P_of_K expon

local ticks = ""
forval x = 0(1)2{
  forval z = 1(1)9{
    local y = 10^(`x')*`z'
    local ticks = "`ticks'`y' "
  }
}
twoway  (scatter P_of_K K, msize(vsmall) yscale(log) xscale(log) xlabel(`labels',grid valuelabel) xmtick(`ticks') aspect(1) ytitle("Probability") xtitle("Degree") name(loglog, replace))

graph combine powerlaw loglog, saving("$temp/Single category test/Nightlife combined scale-free graph.pdf", replace)
*End of do-file.
