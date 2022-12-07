*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** CODE TO CREATE STATA 16 SUPPLEMENTARY RESULTS SHOWN IN: 
*** "Aid and radicalization: 
*** the case of Hamas in the West Bank and Gaza" 
*** AUTHORS: Amit Loewenthal, Sami Miaari, Anke Hoeffler
*** REVISED: 4 December 2022
*** SPECIAL NOTE: WHILE MOST REPLICATION CODE WAS WRITTEN AND RUN WITH STATA 13, THIS FILE IS FOR STATA 16
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set more off

clear all
set matsize 11000

*** SET DIRECTORIES 
cd "C:\Users\akadi\Documents\PhD\Data\"

*** LOG FILE 
cap log close
log using "Aid_Rad\sup_S16.smcl", replace

*** Install required packages
*ssc install xtabond2


/*** -------------------------------------------------------------------------------
*** TABLE OF CONTENTS ***
------------------------------------------------------------------------------- ***/
* Table S9. FE model results – share of households receiving aid.
* Table S10. FE model results – aid value per household.
* Table S11. FD model results – share of households receiving aid.
* Table S12. FD model results – aid value per household.
* Table S13. AB model results – share of households receiving aid.
* Table S14. AB model results – aid value per household.

*macros for tables S9-S14

global binary received_pna received_charity received_international received_other
global values pna charity international other
global soc_ec r_dwage unemployment
global demog praying female married refugees doccupation2-doccupation10 dsector2 dsector3 village camp dage_group2-dage_group6

global dbinary d.received_pna d.received_charity d.received_international d.received_other
global dvalues d.pna d.charity d.international d.other
global dsoc_ec d.r_dwage d.unemployment
global ddemog d.praying d.female d.married d.refugees d.doccupation2 d.doccupation3 d.doccupation4 d.doccupation5 d.doccupation6 d.doccupation7 d.doccupation8 d.doccupation9 d.doccupation10 d.dsector2 d.dsector3 d.village d.camp d.dage_group2 d.dage_group3 d.dage_group4 d.dage_group5 d.dage_group6

*****Table S9
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
*The code for constructing this data file is found in sup_data.do under "Create data for Tables S1-S2"
keep if year <= 2007

xtreg Fatah $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Hamas $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Islamic_Jihad $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg other_fac $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg No_one $binary pal_fatalities $soc_ec $demog, fe vce(robust)

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

xtreg Fatah $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Hamas $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Islamic_Jihad $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg other_fac $binary pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg No_one $binary pal_fatalities $soc_ec $demog, fe vce(robust)


*****Table S10
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
keep if year <= 2007

xtreg Fatah $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Hamas $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Islamic_Jihad $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg other_fac $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg No_one $values pal_fatalities $soc_ec $demog, fe vce(robust)

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

xtreg Fatah $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Hamas $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg Islamic_Jihad $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg other_fac $values pal_fatalities $soc_ec $demog, fe vce(robust)
xtreg No_one $values pal_fatalities $soc_ec $demog, fe vce(robust)

*****Table S11
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
keep if year <= 2007

reg d.Fatah $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Hamas $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Islamic_Jihad $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.other_fac $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.No_one $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

reg d.Fatah $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Hamas $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Islamic_Jihad $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.other_fac $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.No_one $dbinary d.pal_fatalities $dsoc_ec $ddemog, vce(robust)

*****Table S12
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
keep if year <= 2007

reg d.Fatah $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Hamas $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Islamic_Jihad $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.other_fac $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.No_one $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

reg d.Fatah $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Hamas $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.Islamic_Jihad $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.other_fac $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)
reg d.No_one $dvalues d.pal_fatalities $dsoc_ec $ddemog, vce(robust)

*****Table S13
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
keep if year <= 2007

xtabond2 Fatah L.Fatah $binary pal_fatalities $soc_ec $demog, gmm(L.Fatah $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Hamas L.Hamas $binary pal_fatalities $soc_ec $demog, gmm(L.Hamas $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Islamic_Jihad L.Islamic_Jihad $binary pal_fatalities $soc_ec $demog, gmm(L.Islamic_Jihad $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 other_fac L.other_fac $binary pal_fatalities $soc_ec $demog, gmm(L.other_fac $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 No_one L.No_one $binary pal_fatalities $soc_ec $demog, gmm(L.No_one $binary pal_fatalities $soc_ec $demog) noleveleq robust

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

xtabond2 Fatah L.Fatah $binary pal_fatalities $soc_ec $demog, gmm(L.Fatah $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Hamas L.Hamas $binary pal_fatalities $soc_ec $demog, gmm(L.Hamas $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Islamic_Jihad L.Islamic_Jihad $binary pal_fatalities $soc_ec $demog, gmm(L.Islamic_Jihad $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 other_fac L.other_fac $binary pal_fatalities $soc_ec $demog, gmm(L.other_fac $binary pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 No_one L.No_one $binary pal_fatalities $soc_ec $demog, gmm(L.No_one $binary pal_fatalities $soc_ec $demog) noleveleq robust

*****Table S14
*columns (1)-(5)
use "Aid_Rad\reverse_causality.dta", clear
keep if year <= 2007

xtabond2 Fatah L.Fatah $values pal_fatalities $soc_ec $demog, gmm(L.Fatah $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Hamas L.Hamas $values pal_fatalities $soc_ec $demog, gmm(L.Hamas $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Islamic_Jihad L.Islamic_Jihad $values pal_fatalities $soc_ec $demog, gmm(L.Islamic_Jihad $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 other_fac L.other_fac $values pal_fatalities $soc_ec $demog, gmm(L.other_fac $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 No_one L.No_one $values pal_fatalities $soc_ec $demog, gmm(L.No_one $values pal_fatalities $soc_ec $demog) noleveleq robust

*columns (6)-(10)
use "Aid_Rad\reverse_causality.dta", clear
keep if year >= 2009

xtabond2 Fatah L.Fatah $values pal_fatalities $soc_ec $demog, gmm(L.Fatah $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Hamas L.Hamas $values pal_fatalities $soc_ec $demog, gmm(L.Hamas $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 Islamic_Jihad L.Islamic_Jihad $values pal_fatalities $soc_ec $demog, gmm(L.Islamic_Jihad $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 other_fac L.other_fac $values pal_fatalities $soc_ec $demog, gmm(L.other_fac $values pal_fatalities $soc_ec $demog) noleveleq robust
xtabond2 No_one L.No_one $values pal_fatalities $soc_ec $demog, gmm(L.No_one $values pal_fatalities $soc_ec $demog) noleveleq robust

log close