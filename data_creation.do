*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*** CODE TO CREATE MAIN DATASETS USED IN: 
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
log using "Aid_Rad\data_creation.smcl", replace

******************************************************************
* Political violence file
******************************************************************
import excel "fatalities\Israeli and Palestinians SI Original.xls", sheet("PA") firstrow clear

gen	byte lfs_district1	=	.				
replace 	lfs_district1	=	1	if	district=="Jenin"
replace 	lfs_district1	=	2	if	district=="Tubas"
replace 	lfs_district1	=	3	if	district=="Tulkarm"
replace 	lfs_district1	=	4	if	district=="Qalqilya"
replace 	lfs_district1	=	5	if	district=="Salfit"
replace 	lfs_district1	=	6	if	district=="Nablus"
replace 	lfs_district1	=	7	if	district=="Ramallah_&_Al-Bireh"
replace 	lfs_district1	=	8	if	district=="Jerusalem"
replace 	lfs_district1	=	9	if	district=="Jericho"
replace 	lfs_district1	=	10	if	district=="bethlehem"
replace 	lfs_district1	=	11	if	district=="Hebron"
replace 	lfs_district1	=	12	if	district=="North_Gaza"
replace 	lfs_district1	=	13	if	district=="Gaza"
replace 	lfs_district1	=	14	if	district=="Khanyunis"
replace 	lfs_district1	=	15	if	district=="Deir_Al-Balah"
replace 	lfs_district1	=	16	if	district=="Rafah"

label def lfs_district2 1 "Jenin"      2 "Tubas"			3 "Tulkarem"		4 "Qualqilya"		5 "Salfit"   	6 "Nablus"   /*
*/                       7 "Ramallah"	8 "Jerusalem"		9 "Jericho"			10 "Bethlehem"		11 "Hebron"		12 "Gaza North/Jabalya" /*
*/                       13 "Gaza City" 14 "Khanyounis"		15 "Deir El-Balah"	16 "Rafah"      
label  val lfs_district1 lfs_district2
drop   district
rename lfs_district1 district


gen year = year(date_event)
gen month = month(date_event)

generate quarter = 0
replace quarter = 1 if month >= 1 & month <= 3
replace quarter = 2 if month >= 4 & month <= 6
replace quarter = 3 if month >= 7 & month <= 9
replace quarter = 4 if month >= 10 & month <= 12

drop if year < 2004
drop if year > 2016

generate pal_fatalities = 1
collapse (sum) pal_fatalities, by(district year)


sort district year


save "Aid_Rad\Pal_ann.dta", replace

******************************************************************
* PCPSR public opinion file
******************************************************************

use "Palestinian Public Opinion\Pcpsr\Palestinian Public Opinion dataset\pcbsr_microdata_13.dta", clear

keep year quarter district locality_type sex age_group marital_status educ_level occupation sector refugee_status fam_income_nis faction_support family_members praying

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

drop if year < 2004

replace Islamic_Jihad = 1 if faction_support == 7 | faction_support == 10
generate other_fac = 0
replace other_fac = 1 if faction_support == 1 | faction_support == 3 | faction_support == 5  | faction_support == 6  | faction_support == 8 | faction_support == 9 | faction_support == 11  | faction_support == 13  | faction_support == 14 | faction_support == 15  | faction_support == 16

sort district year

save "Aid_Rad\faction_support.dta", replace

******************************************************************
* Palestinian households file
******************************************************************
use "Households assistance\hh_aid.dta", clear

collapse assist_value assistance pna charity international other received_pna received_charity received_international received_other [aw = rw], by(district year)

sort district year



save "Aid_Rad\hh.dta", replace

******************************************************************
* LFS file
******************************************************************

use "LFS\LFS1995-2016_stata13.dta", clear

gen	lfs_district1	=	.				
replace 	lfs_district1	=	1	if	district==1
replace 	lfs_district1	=	2	if	district==5
replace 	lfs_district1	=	3	if	district==10
replace 	lfs_district1	=	4	if	district==20
replace 	lfs_district1	=	5	if	district==25
replace 	lfs_district1	=	6	if	district==15
replace 	lfs_district1	=	7	if	district==30
replace 	lfs_district1	=	8	if	district==40
replace 	lfs_district1	=	9	if	district==35
replace 	lfs_district1	=	10	if	district==45
replace 	lfs_district1	=	11	if	district==50
replace 	lfs_district1	=	12	if	district==55
replace 	lfs_district1	=	13	if	district==60
replace 	lfs_district1	=	14	if	district==70
replace 	lfs_district1	=	15	if	district==65
replace 	lfs_district1	=	16	if	district==75

label def lfs_district2 1 "Jenin"      2 "Tubas"			3 "Tulkarem"		4 "Qualqilya"		5 "Salfit"   	6 "Nablus"   /*
*/                       7 "Ramallah"	8 "Jerusalem"		9 "Jericho"			10 "Bethlehem"		11 "Hebron"		12 "Gaza North/Jabalya" /*
*/                       13 "Gaza City" 14 "Khanyounis"		15 "Deir El-Balah"	16 "Rafah"     
label  val lfs_district1 lfs_district2
drop   district
rename lfs_district1 district

drop if year < 2004

*keep only working age persons (18-64 as in private public wage gaps paper)
keep if age >= 18 & age <=64

*generate labor market indicators
gen unemployment = empch == 2 if empch ~=.
*note that this is unemployment share of population, not of the labor force
*gen employment = empch == 1 if empch ~=.
gen LFP = empch ~= 3 if empch ~=.

*collapse to district_year level
collapse unemployment LFP dwage [aw = yweight],by(district year)
*unemployment as share of the labor force
replace unemployment = unemployment/LFP
drop LFP
sort district year

save "Aid_Rad\labor_market.dta", replace


******************************************************************
* consumer price index
******************************************************************

clear
import excel "CPI\cpi1996-2018annual.xls", sheet("cpi") firstrow

drop if year > 2016 | year < 2004

sort region year

save "Aid_Rad\cpi.dta", replace

******************************************************************
* merging files
******************************************************************

*merge household data with labor market data
use "Aid_Rad\hh.dta", clear
merge 1:1 district year using "Aid_Rad\labor_market.dta"

drop if _merge == 2
drop _merge

save "Aid_Rad\socio_econ.dta", replace

*merge cpi into socio-economic indicators and calculate real terms
use "Aid_Rad\socio_econ.dta", clear

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

*real wage
gen r_dwage = (dwage/cpi)*100
drop dwage

*support in real terms
replace pna = (pna/cpi)*100
replace charity = (charity/cpi)*100
replace international = (international/cpi)*100
replace other = (other/cpi)*100
replace assist_value = (assist_value/cpi)*100

drop cpi

save "Aid_Rad\socio_econ.dta", replace

*merge fatalities with socio-economic indicators

use "Aid_Rad\socio_econ.dta", clear
merge 1:1 district year using "Aid_Rad\Pal_ann.dta"

*filling zero fatalities
replace pal_fatalities = 0 if _merge==1

drop if _merge == 2
drop _merge


save "Aid_Rad\fat_and_econ.dta", replace

*merge public opinion to other data
use "Aid_Rad\faction_support.dta", clear
merge m:1 district year using "Aid_Rad\fat_and_econ.dta"

keep if _merge==3
drop _merge

save "Aid_Rad\master_data.dta", replace

******************************************************************
* data clean-up
******************************************************************
use "Aid_Rad\master_data.dta", clear

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

save "Aid_Rad\master_data.dta", replace

******************************************************************
* create dependent variable
******************************************************************
use "Aid_Rad\master_data.dta", clear

*replace Islamic_Jihad = 1 if faction_support == 7 | faction_support == 10
*generate other_fac = 0
*replace other_fac = 1 if faction_support == 1 | faction_support == 3 | faction_support == 5  | faction_support == 6  | faction_support == 8 | faction_support == 9 | faction_support == 11  | faction_support == 13  | faction_support == 14 | faction_support == 15  | faction_support == 16

generate mvote = .
replace mvote = 0 if Fatah == 1
replace mvote = 1 if Hamas == 1
replace mvote = 2 if Islamic_Jihad == 1
replace mvote = 3 if other_fac == 1
replace mvote = 4 if No_one == 1

label define mvote 0 Fatah, add
label define mvote 1 Hamas, add
label define mvote 2 PIJ, add
label define mvote 3 other, add
label define mvote 4 no_one, add

save "Aid_Rad\master_data.dta", replace
******************************************************************
* create independent variables
******************************************************************

use "Aid_Rad\master_data.dta", clear

*family income
gen f_inc_less_600=(fam_income_nis == 1) if fam_income_nis ~= .

************ Socio-demographic variables-
gen female=(sex==2 ) if sex~=.
drop sex

tab  marital_status 
gen married=(marital_status==2 ) if marital_status~=.
drop marital_status

tab refugee_status 
gen refugees=(refugee_status==1) if refugee_status~=.
drop refugee_status

save "Aid_Rad\master_data.dta", replace

******************************************************************
* create other variables
******************************************************************

use "Aid_Rad\master_data.dta", clear

*religous variables
generate pray =(praying == 1) if praying ~= .
drop praying
rename pray praying

*dummy for West Bank (0) and Gaza (1)
generate gaza = 0
replace gaza = 1 if district > 11

tab district, gen(ddistrict)
egen district_year = group(district year)

*interactions between aid types and refugee status

gen pna_refugees = pna * refugees
gen received_pna_refugees = received_pna * refugees

gen charity_refugees = charity * refugees
gen received_charity_refugees = received_charity * refugees

gen international_refugees = international * refugees
gen received_inter_refugees = received_international * refugees

gen other_refugees = other * refugees
gen received_other_refugees = received_other * refugees

*interactions between aid types and low productivity indicators

gen pna_f_inc_less_600 = pna * f_inc_less_600
gen received_pna_f_inc_less_600 = received_pna * f_inc_less_600
gen charity_f_inc_less_600 = charity * f_inc_less_600
gen received_charity_f_inc_less_600 = received_charity * f_inc_less_600
gen international_f_inc_less_600 = international * f_inc_less_600
gen received_inter_f_inc_less_600 = received_international * f_inc_less_600
gen other_f_inc_less_600 = other * f_inc_less_600
gen received_other_f_inc_less_600 = received_other * f_inc_less_600

save "Aid_Rad\master_data.dta", replace

*create 2004-2007 dataset

use "Aid_Rad\master_data.dta", clear

keep if year <= 2007

*interactions between aid types and Gaza Strip

gen gaza_pna = gaza*pna
gen gaza_received_pna = gaza*received_pna

gen gaza_charity = gaza*charity
gen gaza_received_charity = gaza*received_charity

gen gaza_international = gaza*international
gen gaza_received_inter = gaza*received_international

gen gaza_other = gaza*other
gen gaza_received_other = gaza*received_other

save "Aid_Rad\2004-2007.dta", replace

*create 2009-2014 dataset

use "Aid_Rad\master_data.dta", clear

keep if year >=2009

gen gaza_pna = gaza*pna
gen gaza_received_pna = gaza*received_pna

gen gaza_charity = gaza*charity
gen gaza_received_charity = gaza*received_charity

gen gaza_international = gaza*international
gen gaza_received_inter = gaza*received_international

gen gaza_other = gaza*other
gen gaza_received_other = gaza*received_other

save "Aid_Rad\2009-2014.dta", replace

log close
