*QUESTION 1
use "C:\Users\ANN\OneDrive\Desktop\Project2.dta", clear
browse
*gen crisis dummy
gen crisis=0
br
browse
replace crisis =1 if datadate >= td(01jul2007) & datadate <= td(30jun2008)
br
xtset gvkey datadate
check gvkey
describe gvkey
encode gvkey, gen(gvkey_numeric)
br
xtset gvkey_numeric datadate
duplicates report gvkey_numeric datadate
sort gvkey_numeric datadate
*remove duplicates
duplicates drop
duplicates drop gvkey_numeric datadate, force keep(last)
duplicates drop gvkey_numeric datadate, force keep(last)
sort gvkey_numeric datadate
duplicates tag gvkey_numeric datadate,gen(is_duplicate)
browse
by gvkey_numeric datadate: gen obs_count=_N
by gvkey_numeric datadate: gen obs_num=_n
keep if is_duplicate==0
drop is_duplicate obs_count obs_num
xtset gvkey_numeric datadate
browse
bysort gvkey_numeric (datadate):gen LIQ2006 = liq_ratio if datadate ==td(30jun2006)
gen liq_ratio=cheq/atq
bysort gvkey_numeric (datadate):gen LIQ2006 = liq_ratio if datadate ==td(30jun2006)
bysort gvkey_numeric (datadate); replace LIQ2006=LIQ2006[1] if LIQ2006[1] !=.
bysort gvkey_numeric (datadate): replace LIQ2006=LIQ2006[1] if LIQ2006[1] !=.
*generating dummy variables.
gen crisis_liq= crisis*LIQ2006
gen L_Size=log(L.atq)
gen L_Tang=L.ppentq/L.atq
gen L_NMP=L.niq/L.saleq
gen L_TD=(L.dlttq+L.dlcq)/L.atq
describe
gen L_TD=(L.ddlq+L.dlttq)/L.atq
gen L_TD=(L.dd1q+L.dlttq)/L.atq
gen STD_ratio=dd1q/L.atq
br
*drop variables with condition.
drop id datadate<td(01jul2005)
drop if datadate<td(01jul2005)
drop if datadate>td(31dec2010)
br
drop if sic >=6000& sic <=6999
describe sic
gen sic_num=real(sic)
drop if sic_num>=6000&sic_num<=6999
drop if atq<=0
drop if rectq==.
drop if atq <10
drop if (saleq-L.saleq)/L.saleq>1
drop if saleq==.
*QUESTION 2 DO FILES

*winsorizing the dummy variables.
winsor2 AR_ratio ,replace cuts(1,99)
 winsor2 L_Size ,replace cuts(1,99)
 winsor2 L_TD ,replace cuts(1,99)
 winsor2 L_Tang ,replace cuts(1,99)
 winsor2 L_NPM ,replace cuts(1,99)
 winsor2 LIQ_RAW ,replace cuts(1,99)
 winsor2 temp_2006 ,replace cuts(1,99)
 winsor2 LIQ2006 ,replace cuts(1,99)
 winsor2 crisis ,replace cuts(1,99)
 winsor2 crisis_liq ,replace cuts(1,99)
 winsor2 stdate ,replace cuts(1,99)
 winsor2 datenumeric ,replace cuts(1,99)
 winsor2 AGrowth ,replace cuts(1,99)
 winsor2 SGrowth ,replace cuts(1,99)
br
drop temp_2006 LIQ2006 stdate datenumeric
drop crisis
asdoc summ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW crisis_liq AGrowth SGrowth
ssc install asdoc, replace
save "C:\Users\ANN\OneDrive\Desktop\clean dataset.dta", replace
*generate the descriptive statistics table.
asdoc summ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW crisis_liq AGrowth SGrowth
drop temp_2006 LIQ2006 stdate datenumeric
drop crisis
asdoc summ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW crisis_liq AGrowth SGrowth
ssc install asdoc, replace
save "C:\Users\ANN\OneDrive\Desktop\clean dataset.dta", replace
asdoc summ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW crisis_liq AGrowth SGrowth
br
drop crisis_liq
asdoc summ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW crisis_liq AGrowth SGrowth
save "C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta"
use C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta
br
asdoc summarize[ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth], replace title(Table 1;Descriptive Statistics of Winsorized Variables)
asdoc summarize[ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth], replace title(Table 1;Descriptive Statistics of Winsorized Variables)
save "C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta", replace
br
pwd
save "C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta", replace
asdoc summarize[ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth], replace title(Table 1;Descriptive Statistics of Winsorised Variables)
summarize
save "C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta", replace
asdoc summarize[ STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth], replace title(Table 1;Descriptive Statistics of Winsorised Variables)
save "C:\Users\ANN\OneDrive\Desktop\Project2_Clean.dta", replace

*QUESTION 3 DO FILES
pwd
cd "C:\Windows\system32"
asdoc sum STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth,replace title(TABLE 1:DESCRIPTIVE STATISTICS)
cd"C:\Windows\system32"
asdoc sum STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth,replace title(TABLE 1:DESCRIPTIVE STATISTICS)
cap mkdir c:/results
label var L_Size "Lagged Log of Total Assets"
gen crisis = (datadate>td(31dec2007))
br
*label the dummy variables for clarity.
label var STD_ratio"Short Term debt Ratio"
label var L_TD"Lagged Log of Total Debt Ratio"
label var L_NPM"Net Profit Margin"
label var L_Tang"Lagged Tangibility"
label var LIQ_RAW"Raw Liquidity"
label var crisis"Crisis Dummy"
label var AGrowth"Asset Growth"
label var SGrowth"Sales Growth"
erase MyFile.doc
gen investment= capxy/ atq
br
drop if investment==.
label var investment"investment"
asdoc sum investment STD_ratio AR_ratio L_Size L_TD L_Tang L_NPM LIQ_RAW AGrowth SGrowth,replace title(TABLE 1:DESCRIPTIVE STATISTICS FOR WINSORISED VALUES)
*run three models
ssc install estout, replace
eststo clear
eststo MI: areg AR_ratio crisis,absorb(gvkey_num)
eststo M2: areg STD_ratio crisis,absorb(gvkey_num)
eststo M3: areg investment crisis,absorb(gvkey_num)
*regress the models
eststo M1: areg AR_ratio crisis,absorb(gvkey_num)
*generating the regression table.
esttab M1 M2 M3 using "REGRESSION TABLE COMPARING AR_RATIO, STD_RATIO AND INVESTMENT"

*QUESTION 4 DO FILES
cd "C:\Users\Noah\Downloads\ann curr"
cls
use "C:\Users\Noah\Downloads\ann curr\section b.dta", clear
import delimited "C:\Users\Noah\Downloads\ann curr\TNIC3HHIdata.txt", delimiter(tab) varnames(1) clear 
rename gvkey firmid_num
save "C:\Users\Noah\Downloads\ann curr\TNIC3HHIdata.dta"
*merging the datasets.
merge m:1 firmid_num year using "TNIC3HHIdata.dta"
tab _merge
keep if _merge == 3
drop _merge
save "merged_data.dta", replace
* Calculate industry-year median of TNIC3HHI
* Replace 'industry' with your actual industry variable name
bysort firmid_num year: egen median_tnic3hhi = median(tnic3hhi)
* Create group indicators
* Low TNIC3HHI = Strong competition = Low market power
gen low_market_power = (tnic3hhi < median_tnic3hhi)
gen high_market_power = (tnic3hhi >= median_tnic3hhi)
* Label the groups
label variable low_market_power "Low Market Power (Strong Competition)"
label variable high_market_power "High Market Power (Weak Competition)"
* Check the split
tab low_market_power
tab high_market_power
use "C:\Users\Noah\Downloads\ann curr\section b.dta", clear
rename gvkey firmid_num
merge m:1 firmid_num year using "TNIC3HHIdata.dta"
tab _merge
keep if _merge == 3
drop _merge
save "merged_data.dta", replace
* Calculate industry-year median of TNIC3HHI
* Replace 'industry' with your actual industry variable name
bysort indfmt year: egen median_tnic3hhi = median(tnic3hhi)
* Create group indicators
* Low TNIC3HHI = Strong competition = Low market power
gen low_market_power = (tnic3hhi < median_tnic3hhi)
gen high_market_power = (tnic3hhi >= median_tnic3hhi)
* Label the groups
label variable low_market_power "Low Market Power (Strong Competition)"
label variable high_market_power "High Market Power (Weak Competition)"
* Check the split
tab low_market_power
tab high_market_power
* Clear stored estimates
eststo clear
* Keep only low market power firms
preserve
keep if low_market_power == 1
* Run three models for Group 1
eststo g1_m1: regress AR_ratio crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
eststo g1_m2: regress STD_ratio crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
eststo g1_m3: regress investment crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
restore
* Keep only high market power firms
preserve
keep if high_market_power == 1
* Run three models for Group 2
eststo g2_m1: regress AR_ratio crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
eststo g2_m2: regress STD_ratio crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
eststo g2_m3: regress investment crisis L_Size L_TD L_Tang L_NPM AGrowth SGrowth, robust
restore
esttab g1_m1 g1_m2 g1_m3 using "Table_Group1.rtf"
do "C:\Users\Noah\AppData\Local\Temp\STD00000000.tmp"
run "C:\Users\Noah\AppData\Local\Temp\STD00000000.tmp"
do "C:\Users\Noah\AppData\Local\Temp\STD00000000.tmp"
esttab g1_m1 g1_m2 g1_m3 using "Table_Group1.rtf", replace b(4) se t star(* 0.05 ** 0.01 *** 0.001) title("Group 1: Low Market Power")
esttab g2_m1 g2_m2 g2_m3 using "Table_Group2.rtf", replace b(4) se t star(* 0.05 ** 0.01 *** 0.001) title("Group 2: High Market Power")
esttab g1_m1 g2_m1 g1_m2 g2_m2 g1_m3 g2_m3 using "Table_Comparison.rtf", replace b(4) se t star(* 0.05 ** 0.01 *** 0.001) title("Table 2: Crisis Impact Comparison by Market Power") mtitles("Strong Competition" "Weak Competition" "Strong Competition" "Weak Competition" "Strong Competition" "Weak Competition") mgroups("Accounts Receivable" "Short-term Debt" "Investment", pattern(1 0 1 0 1 0)) scalars("N Observations" "r2 R-squared") addnote("Strong Competition = Low Market Power (TNIC3HHI below industry-year median)" "Weak Competition = High Market Power (TNIC3HHI above industry-year median)" "Robust standard errors in parentheses" "* p<0.05, ** p<0.01, *** p<0.001")
*QUESTION 5
use "C:\Users\ANN\OneDrive\Desktop\CSR..dta", clear
br
*renaming the unique firm identifier
rename ticker firm_id
encode firm_id,gen(firmid_num)
*keep only the needed variables
keep firmid_num csr_std emp_csr_std env_csr_std comm_csr_std year
br
save "C:\Users\ANN\OneDrive\Desktop\CSR.DATA.dta"
use "C:\Users\ANN\OneDrive\Desktop\Project2..dta", clear
rename gvkey firm_id
encode firm_id,gen(firmid_num)
*generate helper variables.
gen qtr_clean=subinstr( datacqtr,"Q","",.)
destring qtr_clean,replace
gen year_part=int( qtr_clean/10)
gen qtr_part=mod( qtr_clean,10)
gen qdate=yq( year_part, qtr_part)
format qdate %tq
 xtset firmid_num qdate
br
gen P_lag=L.prccq
gen stock_return=( prccq- P_lag)/ P_lag
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
gen year=year(dofq(qdate))
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
xtset firmid_num qdate
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
use "C:\Users\ANN\OneDrive\Desktop\CSR..dta", clear
br
*renaming to have uniform firm identifiers.
rename ticker firm_id
encode firm_id,gen(firmid_num)
keep firmid_num csr_std emp_csr_std env_csr_std comm_csr_std year
br
use "C:\Users\ANN\OneDrive\Desktop\Project2..dta", clear
format qdate %tq
 xtset firmid_num qdate
br
gen P_lag=L.prccq
gen stock_return=( prccq- P_lag)/ P_lag
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
xtset firmid_num qdate
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
 use "C:\Users\ANN\OneDrive\Desktop\CSR.DATA.dta"
br
use C:\Users\ANN\OneDrive\Desktop\Project2..dta
br
duplicates tag firmid_num year, generate(is_duplicate)
browse if is_duplicate == 1
duplicates drop firmid_num year, force
 merge 1:m firmid_num year using "C:\Users\ANN\OneDrive\Desktop\CSR.DATA.dta"
 xtset firmid_num qdate
rename csr_std CSR_Score
gen crisis=0
replace crisis=1 if year>=2008 & year<=2009
gen crisis_csr= crisis* CSR_Score
save "C:\Users\ANN\OneDrive\Desktop\Project2..dta", replace
drop _merge is_duplicate
br
use "C:\Users\ANN\OneDrive\Desktop\Project2..dta", clear
levelsof year, local(years)
br
doedit
do "C:\Users\ANN\AppData\Local\Temp\STD04000000.tmp"

