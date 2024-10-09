clear all
set mem 500m
cap log close
set more off

cd "Y:\HH_MASTERFOLDER\do_data_files\min_wage_do\reconstruct\AEJ\"
 
**USES WERS WORKER-FIRM LEVEL DATA
use serial serno a3 a4 a5 c1 d1 d2 d5 d11 empwt* using "Seq98.dta", clear
 
rename a3 hours
rename a4 overtime
rename c1 tu
rename d1 male
rename d2 age
rename d5 educ

ge union = tu==1 if tu<7
replace male = 0 if male==2
tab age, ge(aa_)
tab educ if educ<7, ge(ee_)

ge w1 = . if d11==1
replace w1 = 51 if d11==2
replace w1 = 81 if d11==3
replace w1 = 141 if d11==4
replace w1 = 181 if d11==5
replace w1 = 221 if d11==6
replace w1 = 261 if d11==7
replace w1 = 311 if d11==8
replace w1 = 361 if d11==9
replace w1 = 431 if d11==10
replace w1 = 541 if d11==11
replace w1 = 681 if d11==12

ge w2 = 50 if d11==1
replace w2 = 80 if d11==2
replace w2 = 140 if d11==3
replace w2 = 180 if d11==4
replace w2 = 220 if d11==5
replace w2 = 260 if d11==6
replace w2 = 310 if d11==7
replace w2 = 360 if d11==8
replace w2 = 430 if d11==9
replace w2 = 540 if d11==10
replace w2 = 680 if d11==11
replace w2 = . if d11==12

ge lw1 = log(w1)
ge lw2 = log(w2)

ge lh = log(hours)

intreg lw1 lw2 aa_* male union ee_* lh
predict z if e(sample), e(lw1,lw2)
ge ez = exp(z)

ge hourly = ez / hours
su hourly

ge hh = hourly<=3.6
lab var hh "min wage worker"

g annual_w=hourly*52*hours

so serno 
egen hrs_firm=sum(hours),by(serno)
egen wage_bill=sum(annual_w),by(serno)
g k=1
egen emp=sum(k),by(serno)
lab var emp "headcount employee measure"

so serno
egen num_mw=sum(hh),by(serno)
lab var num_mw "number of mw workers in the firm"

g avwage=wage_bill/emp 

g k12=(avwage<12001)

so k12
egen num=sum(hh),by(k12)
 
g propmin=num_mw/emp
so serno

*Drop low values of hourly
drop if hourly<1.5


collapse hourly hh propmin avwage emp num_mw k12, by(serno)

egen top10=pctile(propmin),p(90)

so serno
g band=.
replace band=1 if avwage>0 & avwage<=1000
replace band=2 if avwage>1000 & avwage<=2000
replace band=3 if avwage>2000 & avwage<=3000
replace band=4 if avwage>3000 & avwage<=4000
replace band=5 if avwage>4000 & avwage<=5000
replace band=7 if avwage>5000 & avwage<=6000
replace band=8 if avwage>6000 & avwage<=7000
replace band=9 if avwage>7000 & avwage<=8000
replace band=10 if avwage>8000 & avwage<=9000
replace band=11 if avwage>9000 & avwage<=10000
replace band=12 if avwage>10000 & avwage<=11000
replace band=13 if avwage>11000 & avwage<=12000
replace band=14 if avwage>12000 & avwage<=13000
replace band=15 if avwage>13000 & avwage<=14000
replace band=16 if avwage>14000 & avwage<=15000
replace band=17 if avwage>15000 & avwage<=16000
replace band=18 if avwage>16000 & avwage<=17000
replace band=19 if avwage>17000 & avwage<=18000
replace band=20 if avwage>18000 & avwage<=19000
replace band=21 if avwage>19000 & avwage<=20000
replace band=21 if avwage>20000 & avwage<=21000
replace band=22 if avwage>21000 & avwage<=22000
replace band=23 if avwage>22000 & avwage<=23000
replace band=24 if avwage>23000 & avwage<=24000

g band2=.
replace band2=1 if avwage>0 & avwage<2000
replace band2=2 if avwage>2000 & avwage<=4000
replace band2=3 if avwage>4000 & avwage<=6000
replace band2=4 if avwage>6000 & avwage<=8000
replace band2=5 if avwage>8000 & avwage<=10000
replace band2=6 if avwage>10000 & avwage<=12000
replace band2=7 if avwage>12000 & avwage<=14000
replace band2=8 if avwage>14000 & avwage<=16000
replace band2=9 if avwage>16000 & avwage<=18000
replace band2=10 if avwage>18000 & avwage<=20000

lab define band2 1 "2000" 2 "4000" 3 "6000" 4 "8000" 5 "10000" 6 "12000" 7 "14000" 8 "16000" 9 "18000" 10 "20000"
lab values band2 band2

lab var propmin "proportion minimum wage workers"
lab var band2 "Average Wage"

xtile band5=avwage,nq(20)
lab define band5 5 "5th" 10 "10th" 15 "15th" 20 "20th"

*** FIGURE 1
graph bar (mean) propmin, over(band5) bargap(140) ytitle("Proportion (%) Min Wage Workers")

 
