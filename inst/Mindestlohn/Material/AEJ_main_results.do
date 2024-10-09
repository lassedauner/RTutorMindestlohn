clear all
set memory 500m
set matsize 1500 
cap log close
set more off

cd "Y:\HH_MASTERFOLDER\do_data_files\min_wage_do\reconstruct\AEJ\"

use "main_fame.dta", clear
 
*** TABLE 1: DIFF-IN-DIFF
cap estimates drop *
tab ctreat NMW if pp==1,su(avwage)
tab ctreat NMW if pp==1,su(ln_avwage)
tab ctreat NMW if pp==1,su(net_pcm)
eststo: xi: reg ln_avwage  ctreat1  treat1_NMW NMW if pp==1,cluster(regno)
eststo: xi: reg net_pcm  ctreat1  treat1_NMW NMW if pp==1,cluster(regno)

*** TABLE 2: WAGES AND PROFITABILITY BEFORE AND AFTER NMW, REGRESSION ESTIMATES
** Controls
cap estimates drop *
***Policy
**Discrete
*Main
eststo: xi: reg ln_avwage ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1,cluster(regno)
eststo: xi: reg net_pcm ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1,cluster(regno)
*No response
xi: mvreg ln_avwage net_pcm =  ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1
test [net_pcm]treat1_NMW + (([ln_avwage]treat1_NMW)*.27) = 0
**Continuous
*Main
eststo: xi: reg ln_avwage c_avwage99 avwage99_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1,cluster(regno)
eststo: xi: reg net_pcm c_avwage99 avwage99_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1,cluster(regno)
*No response
xi: mvreg ln_avwage net_pcm = c_avwage99 avwage99_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 
test [net_pcm]avwage99_NMW + (([ln_avwage]avwage99_NMW)*.27) = 0
esttab using table2.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(treat1_NMW avwage99_NMW) nogap
 
*** TABLE 3: PLACEBO EXPERIMENT FOR WAGES AND PROFITS
cap estimates drop *
**Placebo
*Discrete
eststo: xi: reg ln_avwage  ptreat ptreat_placebo placebo grad2 unionmem ptwk female i.year i.sic2 i.gorwk  if ff==1,cluster(regno)
eststo: xi: reg net_pcm  ptreat ptreat_placebo placebo grad2 unionmem ptwk female i.year i.sic2 i.gorwk  if ff==1,cluster(regno)
* Continuous
eststo: xi: reg ln_avwage  c_avwage96 avwage96_placebo placebo grad2 unionmem ptwk female i.year i.sic2 i.gorwk  if ff==1,cluster(regno)
eststo: xi: reg net_pcm  c_avwage96 avwage96_placebo placebo grad2 unionmem ptwk female i.year i.sic2 i.gorwk  if ff==1,cluster(regno)
esttab using table3.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(ptreat_placebo avwage96_placebo) nogap

*** TABLE 4: CARE HOMES: See below at the bottom of the file (separate dataset)

*** TABLE 5: SPLITTING BY HIGH & LOW MARKET POWER INDUSTRIES
cap estimates drop *
*Above
eststo: xi: reg ln_avwage ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==2,cluster(regno)
eststo: xi: reg net_pcm ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==2,cluster(regno)
eststo: xi: reg lnemp ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==2,cluster(regno)
eststo: xi: reg lturnemp ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==2,cluster(regno)
*Below
eststo: xi: reg ln_avwage ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==1,cluster(regno)
eststo: xi: reg net_pcm ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==1,cluster(regno)
eststo: xi: reg lnemp ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==1,cluster(regno)
eststo: xi: reg lturnemp ctreat1  treat1_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1 & split==1,cluster(regno)
esttab using table5.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(treat1_NMW) nogap

*** TABLE B1: SUMMARY STATS
su avwage if ctreat==1 & pp==1  
su avwage if ctreat==0 & pp==1
su avwage if pp==1

su net_pcm if ctreat==1 & pp==1
su net_pcm if ctreat==0 & pp==1
su net_pcm if pp==1

su capsale if ctreat==1 & pp==1 & capsale>0 & capsale<=1
su capsale if ctreat==0 & pp==1 & capsale>0 & capsale<=1
su capsale if pp==1 & capsale>0 & capsale<=1

su wb_sales if ctreat==1 & pp==1, det
su wb_sales if ctreat==0 & pp==1, det
su wb_sales if pp==1, det

su emp if ctreat==1 & pp==1,det
su emp if ctreat==0 & pp==1,det
su emp if pp==1,det
 
su turnemp if ctreat==1 & pp==1,det
su turnemp if ctreat==0 & pp==1,det
su turnemp if pp==1,det

su ptwk if ctreat==1 & pp==1
su ptwk if ctreat==0 & pp==1
su ptwk if pp==1

foreach var in female unionmem manuf whsle retail hosp biz {
su `var' if ctreat==1 & pp==1
su `var' if ctreat==0 & pp==1
su `var' if pp==1
}

**** ROLLING THRESHOLDS
replace avwage=avwage*1000
set more off
local i=10000
while `i'<=16000 {
 
*POLICY
drop treat1 ctreat1 
g treat1=(avwage<=`i' & year==1999)
egen ctreat1=max(treat1),by(regno)
g treat`i'_NMW=ctreat1*NMW

xi: reg net_pcm ctreat1  treat`i'_NMW NMW grad2 unionmem ptwk female i.sic2  i.year i.gorwk if pp==1,cluster(regno)
g prof_btreat`i'=_b[treat`i'_NMW]
g prof_bse`i'=_se[treat`i'_NMW]
 
*PLACEBO
g ptreat`i'=(avwage<=`i' & year==1996)
egen max_ptreat`i'=max(ptreat`i'),by(regno)
g ptreat`i'_placebo=max_ptreat`i'*placebo
 
xi: reg net_pcm  max_ptreat`i' ptreat`i'_placebo placebo grad2 unionmem ptwk female i.year i.sic2 i.gorwk  if ff==1,cluster(regno)
g prof_placebo_btreat`i'=_b[ptreat`i'_placebo]
g prof_placebo_bse`i'=_se[ptreat`i'_placebo]

local i=`i'+100
}

**Footnote 26
su prof_btreat10000 prof_bse10000
su prof_btreat11000 prof_bse11000
su prof_btreat12000 prof_bse12000
su prof_btreat13000 prof_bse13000
su prof_btreat14000 prof_bse14000

keep  prof_* prof_placebo*  
order prof_btreat* prof_bse* prof_placebo* 
keep if _n==1
g k=1
reshape long prof_btreat prof_bse prof_placebo_btreat prof_placebo_bse, i(k) j(threshold) 
drop k
lab var  prof_placebo_btreat "Placebo"
lab var  prof_btreat "Policy On"
twoway line  prof_btreat  prof_placebo_btreat threshold, ytitle( "Treatment Effect") xtitle(Threshold) text(0.022 12000 "Placebo") text(-0.02 12000 "Policy On") lw(thick thick) lp(solid dash)
saveold "coeffs_NMW_thresholds.dta", replace

**** FIGURE 2: CHANGE IN LN(AVWAGE) BY PERCENTILE IN THE FINANCIAL YEAR BEFORE
**** AND AFTER NMW INTRODUCTION
clear
use "main_fame.dta", clear
 
    *£3K lower bound
	local i=3
	pctile pcw95=ln_avwage if year==1995 & avwage>=`i', nq(100) genp(percent95)
	pctile pcw96=ln_avwage if year==1996 & avwage>=`i', nq(100) genp(percent96)
	pctile pcw97=ln_avwage if year==1997 & avwage>=`i', nq(100) genp(percent97)
	pctile pcw98=ln_avwage if year==1998 & avwage>=`i', nq(100) genp(percent98)
	pctile pcw99=ln_avwage if year==1999 & avwage>=`i', nq(100) genp(percent99)
	pctile pcw00=ln_avwage if year==2000 & avwage>=`i', nq(100) genp(percent00)
	pctile pcw01=ln_avwage if year==2001 & avwage>=`i', nq(100) genp(percent01)
	pctile pcw02=ln_avwage if year==2002 & avwage>=`i', nq(100) genp(percent02)

	sort percent95
	g diff96=pcw96-pcw95
	g diff97=pcw97-pcw96
	g diff98=pcw98-pcw97
	g diff99=pcw99-pcw98
	g diff00=pcw00-pcw99
	g diff01=pcw01-pcw00
	g diff02=pcw02-pcw01

	order pcw95 pcw96 pcw97 pcw98 pcw99 pcw00 pcw01 pcw02 percent95 percent96 percent97 percent98 percent99 percent00 percent01 percent02 diff96 diff97 diff98 diff99 diff00 diff01 diff02  
 
	lab var percent99 "Percentile"
	lab var diff99 "1998-1999"
	lab var diff00 "1999-2000"
 	lab var diff99 "1998-1999"
	lab var diff00 "1999-2000"
	lab var percent99 "Percentiles"
	*Figure 2 graph
	line diff99 diff00 percent99 if percent99<76, clpat(dash solid) ysc(r(-0.02 0.14)) xsc(r(0 70)) ylabel(0 0.05 0.10 0.15) xlabel(0 13 25 50 75) xline(13 50, lp(dash) lw(vvthin) lc(gs8)) text(0.14 14 "£12,000") text(0.10 53 "£20,000")
                                   

***** TABLE 4: NMW INTRODUCTION AND WAGES & PROFITABILITY IN CARE HOMES, 1998-1999
clear
use "care_homes_final.dta", clear
cap estimates drop *
*wages
eststo:xi: reg dlwi gapi0, rob
eststo:xi: reg dlwi gapi0 age0 sex0 qual0 dss0 i.region0 mm0* , rob
*profits
eststo:xi: reg dps gapi0, rob
eststo:xi: reg dps gapi0 age0 sex0 qual0 dss0 i.region0 mm0*, rob
esttab using table4.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(gapi0) nogap






 
