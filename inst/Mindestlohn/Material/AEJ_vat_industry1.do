clear all
set mem 600m 
set matsize 3000
cap log close
set more off
 
cd "Y:\HH_MASTERFOLDER\do_data_files\min_wage_do\reconstruct\AEJ\"

use "vat_industry_panel.dta", clear
***TABLE 6: FIRM ENTRY & EXIT (3-DIGIT INDUSTRY)
cap estimates drop *
*Entry
eststo:xi: areg ent_rate lowpay_nmw lowpay nmw femaleTV part_timeTV unionTV i.year if year>=1996 & year<=2001 & kk==1,cluster(sic3) abs(sic2)
eststo:xi: areg ent_rate lowpay_fake lowpay fake femaleTV part_timeTV unionTV i.year if year<=1998 & pp==1, cluster(sic3) abs(sic2)
*Exit
eststo:xi: areg ex_rate lowpay_nmw lowpay nmw femaleTV part_timeTV unionTV i.year if year>=1996 & year<=2001 & kk==1,cluster(sic3) abs(sic2)
eststo:xi: areg ex_rate lowpay_fake lowpay fake femaleTV part_timeTV unionTV i.year if year<=1998 & pp==1, cluster(sic3) abs(sic2)
*Net entry
eststo:xi: areg net lowpay_nmw lowpay nmw femaleTV part_timeTV unionTV i.year if year>=1996 & year<=2001 & kk==1,cluster(sic3) abs(sic2)
eststo:xi: areg net lowpay_fake lowpay fake femaleTV part_timeTV unionTV i.year if year<=1998 & pp==1, cluster(sic3) abs(sic2)
esttab using table6.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(lowpay_nmw lowpay_fake) nogap

* TABLE B2: FIRM ENTRY & EXIT RATES FOR 3-DIGIT INDUSTRY
xtile band2=lowpay,nq(2)
keep if year>=1996 & year<=2001
su ent_rate ex_rate net lowpay union part_time female 

tab band2, su(ent_rate)
tab band2, su(ex_rate)
tab band2, su(net)
tab band2, su(lowpay)
tab band2, su(union)
tab band2, su(female)
tab band2, su(part_time)

