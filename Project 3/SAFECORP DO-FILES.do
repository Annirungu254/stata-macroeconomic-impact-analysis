use "C:\Users\ANN\OneDrive\Desktop\safecorp_data 2.dta", clear
br
*CHECK IN 1
*summary statistics
summarize annual_sal yr_work, detail
*tabulate variables
tabu1ate minority 
tabulate sex
tabulate highest 
tabulate position
*visualization
histogram annual_sal, normal title("FIGURE 1: Distribution of Employee Annual Salary")
tabstat annual_sal, by(minority) s(mean sd n)
tabstat annual_sal, by(sex) s(mean sd n)
*CHECK IN 2
*test statistic
ttest annual_sal, by(minority)
ttest annual_sal, by(sex)
*anova test
anova annual_sal position
anova annual_sal highest
*regression analysis
regress annual_sal yr_work
regress annual_sal i.minority i.sex i.position i.highest yr_work
regress annual_sal i.minority##i.sex i.minority##i.position i.highest yr_work
*tabulate the model
esttab using "Multivariate_Salary_Model.rtf", replace se label star(* 0.10 ** 0.05 *** 0.01)
*resgression model
regress annual_sal i.minority i.sex i.position i.highest yr_work
regress annual_sal i.minority##i.sex i.minority##i.position i.highest yr_work
*CHECK IN 3
*multivariate regression model
regress annual_sal i.minority i.sex i.position i.highest yr_work
*QUESTION 2
*discrimination test
regress annual_sal i.minority##i.sex i.minority##i.position i.highest yr_work
