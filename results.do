*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** CODE TO CREATE MAIN RESULTS SHOWN IN: 
*** "Aid and radicalization: 
*** the case of Hamas in the West Bank and Gaza" 
*** AUTHORS: Amit Loewenthal, Sami Miaari, Anke Hoeffler
*** REVISED: 6 December 2022
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set more off

clear all
set matsize 11000

*** SET DIRECTORIES 
cd "ROOT"

*** LOG FILE 
cap log close
log using "Aid_Rad\results.smcl", replace

/*** -------------------------------------------------------------------------------
*** TABLE OF CONTENTS ***
------------------------------------------------------------------------------- ***/
* Figure 2. Share of households receiving aid, by source, 2004-2016.
* Figure 3. Average aid value per household by source, 2004-2016.
* Figure 1. Share of households receiving aid and the average aid value per household, 2004-2016.
* Figure 4. Palestinian Fatalities, 2004-2016.
* Table 1. Results for share of households receiving aid.
*	Figure 5a: The relationship between the share of households receiving aid and faction support, 2004-2007
*	Figure 5b: The relationship between the share of households receiving aid and faction support, 2009-2014
* Table 2. Results for aid value per household. 
*	Figure 5c: The relationship between the real aid value per household (2010 NIS) and faction support, 2004-2007
*	Figure 5d: The relationship between the real aid value per household (2010 NIS) and faction support, 2009-2014
* Figure 6. Margin plots for religious club mechanism.
* Figure 7. Margin plots for the clientelist mechanism – share of households receiving aid.
* Figure 8. Margin plots for the clientelist mechanism – aid value per household.

*Prepare data for Figures 1-3

use "Households assistance\hh_aid.dta", clear

generate region = .
replace region = 1 if district < 12 & district != 8
replace region = 2 if district >= 12
replace region = 3 if district == 8

sort region year

merge m:1 region year using "Aid_Rad\cpi.dta"
drop if _merge == 2
drop _merge
drop region
sort district year


*aid in real terms
replace pna = (pna/cpi)*100
replace charity = (charity/cpi)*100
replace international = (international/cpi)*100
replace other = (other/cpi)*100
replace assist_value = (assist_value/cpi)*100

label variable pna "PNA agencies"
label variable charity "Charity and factions"
label variable international "UNRWA and international institutions"
label variable other "Other sources"
label variable received_pna "PNA agencies"
label variable received_charity "Charity and factions"
label variable received_international "UNRWA and international institutions"
label variable received_other "Other sources"



*****Figure 2
graph bar (mean) received_pna received_charity received_international received_other [aweight = rw], over(year) ytitle(Share of households receiving aid)  legend(order(1 "PNA agencies" 2 "Charity and factions" 3 "UNRWA and international institutions" 4 "Other sources"))
*****Figure 3
graph bar (mean) pna charity international other [aweight = rw], over(year) ytitle(Average real value of aid (2010 NIS)) legend(order(1 "PNA agencies" 2 "Charity and factions" 3 "UNRWA and international institutions" 4 "Other sources"))

*****Figure 1
collapse assistance assist_value [aw=rw], by(year)

tsset year, yearly

label variable assist_value "Average aid value per household (2010 NIS)"
label variable assistance "Total share of households receiving aid"

twoway (bar assist_value year, yaxis(1) yscale(range(0) axis(1))) (line assistance year, yaxis(2) yscale(range(0) axis(2))), xlabel(#7)


*****Figure 4

use "Aid_Rad\Pal_ann.dta", clear
drop if year > 2014
graph bar (mean) pal_fatalities, over(year) ytitle(Pelastinian fatalities)


*Macros for Tables 1-2 and Figures 5-8
global demographic female married refugees i.occupation i.sector i.locality_type i.age_group i.educ_level
global binary received_pna received_charity received_international received_other
global values pna charity international other
global soc_ec r_dwage unemployment

global gaza_binary gaza_received_pna gaza_received_charity gaza_received_inter gaza_received_other
global gaza_value gaza_pna gaza_charity gaza_international gaza_other

global f_inc_less_600_binary received_pna_f_inc_less_600 received_charity_f_inc_less_600 received_inter_f_inc_less_600 received_other_f_inc_less_600 
global f_inc_less_600_value pna_f_inc_less_600 charity_f_inc_less_600 international_f_inc_less_600 other_f_inc_less_600 


*****Table 1

*columns (1)-(5), which we use to create Figure 5a
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(0)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(1)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(2)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(3)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(4)) post

*columns (6)-(10), which we use to create Figure 5b
use "Aid_Rad\2009-2014.dta", clear
mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(0)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(1)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(2)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(3)) post

quietly mlogit mvote $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx( $binary pal_fatalities  $soc_ec praying) predict(outcome(4)) post

*****Table 2

*columns (1)-(5), which we use to create Figure 5c
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(0)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(1)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(2)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(3)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(4)) post


*columns (6)-(10), which we use to create Figure 5d
use "Aid_Rad\2009-2014.dta", clear
mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(0)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(1)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(2)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(3)) post

quietly mlogit mvote $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($values pal_fatalities  $soc_ec praying) predict(outcome(4)) post



*****Figure 6
*Data for figure 6a
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(0)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(1)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(2)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(3)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(4)) post

*Data for figure 6b
use "Aid_Rad\2009-2014.dta", clear
mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(0)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(1)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(2)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(3)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_binary) predict(outcome(4)) post

*Data for figure 6c
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(0)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(1)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(2)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(3)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(4)) post

*Data for figure 6d
use "Aid_Rad\2009-2014.dta", clear
mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(0)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(1)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(2)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(3)) post

quietly mlogit mvote f_inc_less_600 $f_inc_less_600_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($f_inc_less_600_value) predict(outcome(4)) post

*****Figure 7

*Data for figure 7a
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote $gaza_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_binary $binary) predict(outcome(0)) post
*net effects in the Gaza Strip
lincom _b[received_pna] + _b[gaza_received_pna]
lincom _b[received_charity] + _b[gaza_received_charity]
lincom _b[received_international] + _b[gaza_received_inter]
lincom _b[received_other] + _b[gaza_received_other]

use "Aid_Rad\2009-2014.dta", clear
mlogit mvote $gaza_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_binary $binary) predict(outcome(0)) post
*net effects in the Gaza Strip
lincom _b[received_pna] + _b[gaza_received_pna]
lincom _b[received_charity] + _b[gaza_received_charity]
lincom _b[received_international] + _b[gaza_received_inter]
lincom _b[received_other] + _b[gaza_received_other]



*Data for figure 7b
use "Aid_Rad\2004-2007.dta", clear
quietly mlogit mvote $gaza_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_binary $binary) predict(outcome(1)) post
*net effects in the Gaza Strip
lincom _b[received_pna] + _b[gaza_received_pna]
lincom _b[received_charity] + _b[gaza_received_charity]
lincom _b[received_international] + _b[gaza_received_inter]
lincom _b[received_other] + _b[gaza_received_other]

use "Aid_Rad\2009-2014.dta", clear
quietly mlogit mvote $gaza_binary $binary pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_binary $binary) predict(outcome(1)) post
*net effects in the Gaza Strip
lincom _b[received_pna] + _b[gaza_received_pna]
lincom _b[received_charity] + _b[gaza_received_charity]
lincom _b[received_international] + _b[gaza_received_inter]
lincom _b[received_other] + _b[gaza_received_other]


*****Figure 8
*Data for figure 8a
use "Aid_Rad\2004-2007.dta", clear
mlogit mvote $gaza_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_value $values) predict(outcome(0)) post
*net effects in the Gaza Strip
lincom _b[pna] + _b[gaza_pna]
lincom _b[charity] + _b[gaza_charity]
lincom _b[international] + _b[gaza_international]
lincom _b[other] + _b[gaza_other]

use "Aid_Rad\2009-2014.dta", clear
mlogit mvote $gaza_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_value $values) predict(outcome(0)) post
*net effects in the Gaza Strip
lincom _b[pna] + _b[gaza_pna]
lincom _b[charity] + _b[gaza_charity]
lincom _b[international] + _b[gaza_international]
lincom _b[other] + _b[gaza_other]

*Data for figure 8b
use "Aid_Rad\2004-2007.dta", clear
quietly mlogit mvote $gaza_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_value $values) predict(outcome(1)) post
*net effects in the Gaza Strip
lincom _b[pna] + _b[gaza_pna]
lincom _b[charity] + _b[gaza_charity]
lincom _b[international] + _b[gaza_international]
lincom _b[other] + _b[gaza_other]

use "Aid_Rad\2009-2014.dta", clear
quietly mlogit mvote $gaza_value $values pal_fatalities  $soc_ec praying $demographic i.district
margins, dydx($gaza_value $values) predict(outcome(1)) post
*net effects in the Gaza Strip
lincom _b[pna] + _b[gaza_pna]
lincom _b[charity] + _b[gaza_charity]
lincom _b[international] + _b[gaza_international]
lincom _b[other] + _b[gaza_other]

log close


