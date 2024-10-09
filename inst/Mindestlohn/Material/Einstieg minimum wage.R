


# Daten einlesen
install.packages('haven')
library(haven)

#Figure 1
library(dplyr)
library(ggplot2)
dat_seq = read_dta('seq98.dta')

#Wichtige Spalten herausfiltern
dat_seq = select(dat_seq, serial, serno, a3, a4, a5, c1_, d1, d2, d5, d11)
  

#Spalten umbennen
dat_seq = rename(dat_seq,
       hours = a3,
       overtime = a4,
       tu = c1_,
       male = d1,
       age = d2,
       educ = d5)


#Neue Spalten
dat_seq = mutate(dat_seq, "union" = 
                   case_when(tu < 7 ~ 1))

dat_seq$male = replace(dat_seq$male, dat_seq$male == 2, 0)

aa_ = dat_seq %>%
  group_by(age) %>%
  summarise(nrow)

ee_ = filter(dat_seq, dat_seq$educ < 7)

dat_seq = mutate(dat_seq,
                 "w1" = case_when(
                   d11 == 1 ~ 0,
                   d11 == 2 ~ 51,
                   d11 == 3 ~ 81,
                   d11 == 4 ~ 141,
                   d11 == 5 ~ 181,
                   d11 == 6 ~ 221,
                   d11 == 7 ~ 261,
                   d11 == 8 ~ 311,
                   d11 == 9 ~ 361,
                   d11 == 10 ~ 431,
                   d11 == 11 ~ 541,
                   d11 == 12 ~ 681,
                 ))

dat_seq = mutate(dat_seq,
                 "w2" = case_when(
                   d11 == 1 ~ 50,
                   d11 == 2 ~ 80,
                   d11 == 3 ~ 140,
                   d11 == 4 ~ 180,
                   d11 == 5 ~ 220,
                   d11 == 6 ~ 260,
                   d11 == 7 ~ 310,
                   d11 == 8 ~ 360,
                   d11 == 9 ~ 430,
                   d11 == 10 ~ 540,
                   d11 == 11 ~ 680,
                   d11 == 12 ~ 0,
                 ))

dat_seq = mutate(dat_seq,
                 "lw1" = log(w1),
                 "lw2" = log(w2),
                 "lh" = log(hours))

#Regression???
intReg()
#intreg lw1 lw2 aa_* male union ee_* lh
#predict z if e(sample), e(lw1,lw2)
#ge hourly = ez / hours
#su hourly

#ge hh = hourly<=3.6
#lab var hh "min wage worker"

#g annual_w=hourly*52*hours


dat_seq = dat_seq %>% 
  group_by(serno) %>%
  mutate("hrs_firm" = sum(hours))

#dat_seq = dat_seq %>% 
#  group_by(serno) %>%
#  mutate("wage_bill" = sum(annual_w))

dat_seq = mutate(dat_seq, "k" = 1)

dat_seq = dat_seq %>%
  group_by(serno) %>%
  mutate("emp" = sum(k)) #headcount employee measure /Beschreibung

#dat_seq = dat_seq %>%
#   group_by(serno) %>%
#  mutate("num_mw" = sum(hh)) #number of mw workers in the firm /Beschreibung

#dat_seq = mutate(dat_seq,"avwage" = wage_bill/emp)

#dat_seq = mutate(dat_seq,"k12" = avwage<12001)

#data_seq =  data_seq %>%
# group_by(k12) %>%
# mutate("num" = sum(hh))

#dat_seq = mutate(dat_seq,"propmin" = num_mw/emp)

#dat_seq = filter(dat_seq, hourly >= 1.5)





#Daten in Perzentile aufteilen
dat1 = mutate(dat_seq,
              "band" = case_when(
                avwage>0 & avwage<=1000 ~ 1,
                avwage>1000 & avwage<=2000 ~ 2,
                avwage>2000 & avwage<=3000 ~ 3,
                avwage>3000 & avwage<=4000 ~ 4,
                avwage>4000 & avwage<=5000 ~ 5,
                avwage>5000 & avwage<=6000 ~ 6,
                avwage>6000 & avwage<=7000 ~ 7,
                avwage>7000 & avwage<=8000 ~ 8,
                avwage>8000 & avwage<=9000 ~ 9,
                avwage>9000 & avwage<=10000 ~ 10,
                avwage>10000 & avwage<=11000 ~ 11,
                avwage>11000 & avwage<=12000 ~ 12,
                avwage>12000 & avwage<=13000 ~ 13,
                avwage>13000 & avwage<=14000 ~ 14,
                avwage>14000 & avwage<=15000 ~ 15,
                avwage>15000 & avwage<=16000 ~ 16,
                avwage>16000 & avwage<=17000 ~ 17,
                avwage>17000 & avwage<=18000 ~ 18,
                avwage>18000 & avwage<=19000 ~ 19,
                avwage>19000 & avwage<=20000 ~ 20,
                avwage>20000 & avwage<=21000 ~ 21,
                avwage>21000 & avwage<=22000 ~ 22,
                avwage>22000 & avwage<=23000 ~ 23,
                avwage>23000 & avwage<=24000 ~ 24,))

dat1 = mutate(dat_seq,
              "band2" = case_when(
                avwage>0 & avwage<=2000 ~ 1,
                avwage>2000 & avwage<=4000 ~ 2,
                avwage>4000 & avwage<=6000 ~ 3,
                avwage>6000 & avwage<=8000 ~ 4,
                avwage>8000 & avwage<=10000 ~ 5,
                avwage>10000 & avwage<=12000 ~ 6,
                avwage>12000 & avwage<=14000 ~ 7,
                avwage>14000 & avwage<=16000 ~ 8,
                avwage>16000 & avwage<=18000 ~ 9,
                avwage>18000 & avwage<=20000 ~ 10))

dat1 %>% 
  group_by(percentile) %>%
  summarise()






#Figure 2
#Perzentile festlegen
dat_main = read_dta('main_fame.dta')
head(dat_main)

i = 3 

pcw95 = dat_main %>%
  filter(year == 1995)%>%
  filter(avwage >= i)
percent95 = quantile(pcw95$ln_avwage, seq(0, 1, 0.01))

pcw96 = dat_main %>%
  filter(year == 1996)%>%
  filter(avwage >= i)
percent96 = quantile(pcw96$ln_avwage, seq(0, 1, 0.01))

pcw97 = dat_main %>%
  filter(year == 1997)%>%
  filter(avwage >= i)
percent97 = quantile(pcw97$ln_avwage, seq(0, 1, 0.01))

pcw98 = dat_main %>%
  filter(year == 1998)%>%
  filter(avwage >= i)
percent98 = quantile(pcw98$ln_avwage, seq(0, 1, 0.01))

pcw99 = dat_main %>%
  filter(year == 1999)%>%
  filter(avwage >= i)
percent99 = quantile(pcw99$ln_avwage, seq(0, 1, 0.01))

pcw00 = dat_main %>%
  filter(year == 2000)%>%
  filter(avwage >= i)
percent00 = quantile(pcw00$ln_avwage, seq(0, 1, 0.01))

pcw01 = dat_main %>%
  filter(year == 2001)%>%
  filter(avwage >= i)
percent01 = quantile(pcw01$ln_avwage, seq(0, 1, 0.01))

pcw02 = dat_main %>%
  filter(year == 2002)%>%
  filter(avwage >= i)
percent02 = quantile(pcw02$ln_avwage, seq(0, 1, 0.01))

diffperc = data.frame(sort(percent95))
diffperc = diffperc %>%
  mutate("percentile" = c(0:100),
         "diff96" = percent96-percent95,
         "diff97" = percent97-percent96,
         "diff98" = percent98-percent97,
         "diff99" = percent99-percent98,
         "diff00" = percent00-percent99,
         "diff01" = percent01-percent00,
         "diff02" = percent02-percent01)


#Graphik
library(ggplot2)

diffperc = filter(diffperc, percentile < 76 & percentile > 0)
ggplot(diffperc)+
  geom_line(aes(x = percentile, y = diff99), colour = "blue", linetype = 2, linewidth = 0.8)+
  geom_line(aes(x = percentile, y = diff00), colour = "red", linewidth = 0.8)+
  geom_vline(xintercept = 13)+
  geom_vline(xintercept = 50)




#Table 1

#Daten zusammenfassen
library(dplyr)


dat_table1 = dat_main %>%
  group_by(ctreat1, NMW)%>%
  filter(pp == 1) %>%
  summarise(mean_avwage = mean(avwage), mean_ln_avwage = mean(ln_avwage), mean_net_pcm = mean(net_pcm))

#Sortieren wie in Table 1
dat_table1 = arrange(dat_table1, desc(ctreat1))


#DiD händisch
DiD_ln_avwage = (dat_table1$mean_ln_avwage[2]-dat_table1$mean_ln_avwage[1])-(dat_table1$mean_ln_avwage[4]-dat_table1$mean_ln_avwage[3])
DiD_net_pcm = (dat_table1$mean_net_pcm[2]-dat_table1$mean_net_pcm[1]) - (dat_table1$mean_net_pcm[4]-dat_table1$mean_net_pcm[3])


#Daten vorbereiten
dat_main_pp = dat_main_pp %>% 
  filter(dat_main, pp == 1) 



#Regression
library(lfe)
library(stargazer)

reg1 = felm(ln_avwage ~ ctreat1 + treat1_NMW + NMW |0|0|regno, data = dat_main_pp) #Kontrollgruppe

reg2 = felm(net_pcm ~ ctreat1 + treat1_NMW + NMW |0|0|regno, data = dat_main_pp) #Kontrollgruppe

stargazer(reg1, reg2, type = "text", style = "aer") #treat1_NMW = Difference in Difference / NMW = Difference in Kontrollgruppe / 




#Table 2






