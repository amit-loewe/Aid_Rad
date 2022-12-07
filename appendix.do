*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** CODE TO CREATE APPENDIX RESULTS SHOWN IN: 
*** "Aid and radicalization: 
*** the case of Hamas in the West Bank and Gaza" 
*** AUTHORS: Amit Loewenthal, Sami Miaari, Anke Hoeffler
*** REVISED: 5 December 2022
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set more off

clear all
set matsize 11000

*** SET DIRECTORIES 
cd "ROOT"

*** LOG FILE 
cap log close
log using "Aid_Rad\appendix.smcl", replace

/*** -------------------------------------------------------------------------------
*** TABLE OF CONTENTS ***
------------------------------------------------------------------------------- ***/
* Figure A1. Support shares of factions, 1994-2014.
* Figure A2. Trends in time devoted to praying, 2004-2014.
* Figure A3. Praying trends by district.
* Table A1. Descriptive statistics, PCPSR.
* Table A2. Descriptive statistics, district-level variables.

*****Figure A1

use "Palestinian Public Opinion\Pcpsr\Palestinian Public Opinion dataset\pcbsr_microdata_13.dta", clear

keep year quarter faction_support

tabulate faction_support, generate(faction)

rename faction1 DFLP
rename faction2 Fatah
rename faction3 h_al_shab
rename faction4 Hamas
rename faction5 PFLP
rename faction6 Fida
rename faction7 Ind_Islamists
rename faction8 Ind_Nationalists
rename faction9 Independent
rename faction10 Islamic_Jihad
rename faction11 Others
rename faction12 No_one
rename faction13 PPP
rename faction14 Ind_leftist
rename faction15 national_inititiative
rename faction16 third_way

drop if year == 1993

replace Islamic_Jihad = 1 if faction_support == 7 | faction_support == 10
generate other_fac = 0
replace other_fac = 1 if faction_support == 1 | faction_support == 3 | faction_support == 5  | faction_support == 6  | faction_support == 8 | faction_support == 9 | faction_support == 11  | faction_support == 13  | faction_support == 14 | faction_support == 15  | faction_support == 16


generate year_quarter = yq(year,quarter)
sort year_quarter

collapse Fatah Hamas Islamic_Jihad other_fac No_one, by(year_quarter)

tsset year_quarter, quarterly

label variable Fatah "Fatah"
label variable Hamas "Hamas"
label variable Islamic_Jihad "PIJ and Islamic Independents"
label variable other_fac "Other factions"
label variable No_one "No one"
label variable year_quarter "Quarter"

twoway (line Fatah year_quarter, yaxis(1) yscale(range(0) axis(1))) (line Hamas year_quarter, yaxis(1) yscale(range(0) axis(1)))(line Islamic_Jihad year_quarter, yaxis(1) yscale(range(0) axis(1))) (line other_fac year_quarter, yaxis(1) yscale(range(0) axis(1))) (line No_one year_quarter, yaxis(1) yscale(range(0) axis(1))), ytitle(Share of support)

*****Figure A2

use "Aid_Rad\faction_support.dta", clear

*remove respondants below the age of 18
drop if age_group == 0

*remove respondents with unknown education level
drop if educ_level == 8

*reomove respondents with missing data

drop if faction_support == .
drop if age_group == .
drop if locality_type == .
drop if educ_level == .
drop if sector == .
drop if occupation == .
drop if sex == .
drop if refugee_status == .
drop if marital_status == .
drop if praying == .

*religous variables
generate pray =(praying == 1) if praying ~= .
drop praying
rename pray praying

graph bar (mean) praying, over(year) ytitle(Share of people praying five times a day)

*****Figure A3

use "Aid_Rad\faction_support.dta", clear

*remove respondants below the age of 18
drop if age_group == 0

*remove respondents with unknown education level
drop if educ_level == 8

*reomove respondents with missing data

drop if faction_support == .
drop if age_group == .
drop if locality_type == .
drop if educ_level == .
drop if sector == .
drop if occupation == .
drop if sex == .
drop if refugee_status == .
drop if marital_status == .
drop if praying == .

*religous variables
generate pray =(praying == 1) if praying ~= .
drop praying
rename pray praying

collapse praying,by (year district)

label variable praying "Praying five times a day"

xtset district year, yearly
xtline praying, recast(line) ytitle(Share of people praying five times a day) ttitle(Year)


*****Table A1

*macro for Table A1
global demographic praying female married refugees gaza ibn.occupation ibn.sector ibn.locality_type ibn.age_group ibn.educ_level f_inc_less_600

*left columns
use "Aid_Rad\2004-2007.dta", clear
sum  Fatah Hamas Islamic_Jihad other_fac No_one $demographic

*right columns
use "Aid_Rad\2009-2014.dta", clear
sum  Fatah Hamas Islamic_Jihad other_fac No_one $demographic

*****Table A2

*macros for Table A2
global binary received_pna received_charity received_international received_other
global values pna charity international other
global soc_ec r_dwage unemployment


*left columns
use "Aid_Rad\2004-2007.dta", clear
collapse $binary $values pal_fatalities $faction_fat $soc_ec ,by(district_year)
sum $binary $values pal_fatalities $faction_fat $soc_ec

*right columns
use "Aid_Rad\2009-2014.dta", clear
collapse $binary $values pal_fatalities $faction_fat $soc_ec ,by(district_year)
sum $binary $values pal_fatalities $faction_fat $soc_ec

log close
