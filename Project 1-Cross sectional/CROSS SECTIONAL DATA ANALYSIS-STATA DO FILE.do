import excel "C:\Users\ANN\Downloads\Cross_sectional6_2.xlsx", sheet("Sheet1") firstrow
br
* H0: mean(directors_native) = 0.5
ttest directors_native == 0.5
* 4b
* 1. Calculate the median
summarize totalassetseur2024, detail
scalar med_assets = r(p50)
* 2. Create the binary variable using the scalar
gen high_assets = (totalassetseur2024 > med_assets) if totalassetseur2024 != .
* 3. Run the t-test
ttest roeusingplbeforetax2024, by(high_assets)
*4c
* Perform a paired t-test
* H0: mean(roceusingplbeforetax2024 - roeusingplbeforetax2024) = 0
* Ha: mean(roceusingplbeforetax2024 - roeusingplbeforetax2024) > 0
ttest roceusingplbeforetax2024 == roeusingplbeforetax2024
*5
* 1. Create the new variable with 4 groups (quartiles)
* Automatically calculates the 25th, 50th, and 75th percentiles
xtile roe_quartiles = roeusingplbeforetax2024, nq(4)
* 2. Define the labels for the 4 groups
label define roe_label 1 "very low" 2 "low" 3 "middle" 4 "high"
* 3. Apply the labels to the roe_quartiles variable
label values roe_quartiles roe_label
* 4. Check the results
tabulate roe_quartiles
* Create crosstab with expected frequencies and Chi-square test
tabulate roe_quartiles high_assets, expected chi2
*6
* 1. Creating the dummy variable
* Returns 1 if the condition is met, 0 otherwise
gen public_admin_dummy = (nacerev2mainsection == "O - Public administration and defence; compulsory social security")
* 2. Label the variable 
label variable public_admin_dummy "1 if Public Admin/Defence, 0 otherwise"
label define pub_label 0 "Private/Other" 1 "Public Admin"
label values public_admin_dummy pub_label
* 3. Verify the count 
tabulate public_admin_dummy
ttest roeusingplbeforetax2024 == 0.5 if public_admin_dummy == 0
ttest roeusingplbeforetax2024, by(public_admin_dummy)
regress roeusingplbeforetax2024 totalassetseur2024 public_admin_dummy
*7(a)
* Perform the Mann-Whitney U / Wilcoxon rank-sum test
ranksum roeusingplbeforetax2024, by(public_admin_dummy)
*7b
* 1. Jarque-Bera Test (requires 'sktest' in Stata for skewness/kurtosis)
sktest directors_age
* 2. Shapiro-Wilk Test (The appropriate choice for general normality testing)
swilk directors_age
* 3. Visual Diagnostics
graph box directors_age, name(boxplot_age, replace)
qnorm directors_age, name(qqplot_age, replace)
*7c
* Performing the Wilcoxon Signed-Rank Test
signrank roeusingplbeforetax2024 = roceusingplbeforetax2024
*2.3: Multivariate regression 1
foreach v in totalassetseur2024 directors_age directors_native directors_male {
    capture drop z_`v'
    egen z_`v' = std(`v')
}
gen ln_assets = ln(totalassetseur2024)
* ssc install winsor2
winsor2 totalassetseur2024, replace cuts(1 99)
list totalassetseur2024 z_totalassetseur2024 if abs(z_totalassetseur2024) > 3 & !missing(z_totalassetseur2024)
drop z_totalassetseur2024
egen z_totalassetseur2024 = std(totalassetseur2024)
capture drop z_totalassetseur2024
egen z_totalassetseur2024 = std(totalassetseur2024)
gsort -z_totalassetseur2024
*remedy for skewness
capture drop ln_assets
gen ln_assets = ln(totalassetseur2024)
* Create a Z-score for new "remedied" variable
capture drop z_ln_assets
egen z_ln_assets = std(ln_assets)
* Count how many extreme outliers (>3) exist now
count if abs(z_ln_assets) > 3 & !missing(z_ln_assets)
* Visual proof: look at the new boxplot
graph box ln_assets, title("Boxplot of Remedied Assets (Log)")
*8b
* Plotting Assets against Director Age
* Plotting Director Age against Director Male %
scatter directors_age directors_male, title("Age vs. Gender %")
describe
* Plotting ROE against the remedied Assets
regress roeusingplbeforetax2024 ln_assets directors_age directors_native directors_male, vce(robust)
*9
regress roeusingplbeforetax2024 ln_assets directors_age directors_native directors_male, vce(robust)
