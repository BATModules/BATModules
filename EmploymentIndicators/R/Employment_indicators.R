# Post-simulation code to derive employment and wage indicators 
# Version 1.0 (Feb 2024)

# SET WD & LOAD PACKAGES -------------------------------------------------------

# check working directory
getwd()

# load required packages
library(dplyr)
library(tidyverse)
library(reshape2, include.only='melt')
library(magnetr)
library(glue)
library(WDI)
library(HARr)


# INPUT FILES  ------------------------------------------------------------------

# Reading datafiles in GEMPACK har format. Here we refer to standard 
# GEMPACK-based GTAP files defining sets, base data, updated basedata, view and 
# a har version of the solutions file with % change variables. This last file can 
# either be created by post-sim writes in the code or using the sltoht facility 
# for converting a sl4 file into har format.

# To use the code replace the file names & paths to point to your files
# Standard GTAP set definition file
SETS_file = file.path("./../../../TestData/sets.har")
SETS <- magnet_read_all_headers(SETS_file)

# Basedata file
BDAT_file = file.path("./../../../TestData/BaseData_b.har")
BDAT <-  magnet_read_all_headers(BDAT_file)

# Scenario specific files (denoted by B1 & B2)
B1_DAT_file = file.path("./../../../TestData/D1_3_BAU_2014-2020_update.har")
B1DAT <-  magnet_read_all_headers(B1_DAT_file)
B1_SOL_file = file.path("./../../../TestData/D1_3_BAU_2014-2020_Solution.sol")
B1SOL <-  magnet_read_all_headers(B1_SOL_file)
B1_VEW_file = file.path("./../../../TestData/d1_3_bau_2014-2020_update_view.har")
B1VEW <-  magnet_read_all_headers(B1_VEW_file)

B2_DAT_file = file.path("./../../../TestData/D1_3_BAU_2020-2030_update.har")
B2DAT <-  magnet_read_all_headers(B2_DAT_file)
B2_SOL_file = file.path("./../../../TestData/D1_3_BAU_2020-2030_Solution.sol")
B2SOL <-  magnet_read_all_headers(B2_SOL_file)
B2_VEW_file = file.path("./../../../TestData/d1_3_bau_2020-2030_update_view.har")
B2VEW <-  magnet_read_all_headers(B2_VEW_file)

# MAP MODEL REGIONS TO COUNTRIES -----------------------------------------------

# Create mapping from countries -> GTAP v10 or v11 -> model regions to combine 
# model results with country level data from WDI

# A csv file  mapping gtap (v10 or v11) regions to model regions. Should contain 
# 2 columns: DREG (= GTAP regions) and REG (regions in teh model)
# denote the column with use
mapreg <- read.csv("./../../../TestData/MAPREG.csv")

# Read  file mapping ISO country codes to GTAP v10 and v11 and regions 
data2gtap <- read_csv("country2gtapv10_v11.csv")
# Run this code to use a GTAP v10 database (141 regions):
data2gtap <- data2gtap %>% mutate(DREG = gtap141, DREG.name = gtap141.name )
# or run this code to use a GTAP v11 database (160 regions):
#data2gtap <- data2gtap %>% mutate(DREG = gtap160, DREG.name = gtap160.name )

# combine mappings 
iso2reg_wdi <- data2gtap %>% 
  left_join(mapreg, by = join_by (DREG  == DREG)) %>%
  # select & reorder variables needed to match WDI data to model 
  subset(.,select = c(REG,DREG,DREG.name,isoc,country,wb))

# READ EMPLOYMENT,PAYMENT AND INCOME DATA --------------------------------------------- 

# Employment (QLAB) 
QLAB1 <- B1DAT$QLAB %>% rename(QLAB = Value) %>% mutate(SCEN = "b1")
QLAB2 <- B2DAT$QLAB %>% rename(QLAB = Value) %>% mutate(SCEN = "b2")

# compile file based on dimensions of variables
lab_acts_reg <- QLAB1 %>% full_join(QLAB2) %>% 
# organize indices
  mutate (LAB_ACTS = str_c(ENDWLAB,"_",ACTS)) %>%
  subset(., select = c(ENDWLAB,ACTS,REG,SCEN,LAB_ACTS,QLAB)) %>%
# filter 0 QLAB as not needed and avoids NA with wage calculations
  filter(., QLAB != 0)

# Labour payments (after income tax)
EVOS1 <- B1DAT$EVOS %>% rename(EVOS = Value) %>% mutate(SCEN = "b1")
EVOS2 <- B2DAT$EVOS %>% rename(EVOS = Value) %>% mutate(SCEN = "b2")
EVOS12 <- EVOS1 %>% full_join(EVOS2) 
lab_acts_reg <- lab_acts_reg %>% 
  left_join(EVOS12, 
  by = join_by(ENDWLAB == ENDW, REG == REG, ACTS == ACTS, SCEN == SCEN)) 

# get CPI (ppriv)
ppriv1 <- B1SOL$PPRI  %>% rename(ppriv = Value) %>% mutate(SCEN = "b1")
ppriv2 <- B2SOL$PPRI  %>% rename(ppriv = Value) %>% mutate(SCEN = "b2")
ppriv12 <- ppriv1 %>% full_join(ppriv2)
lab_acts_reg <- lab_acts_reg %>% left_join(ppriv12)

# Additional income indicators  ----------------------------------------

# To assess plausibility of wage-based indicators helpful to compute other 
# regional income indicators (GDP/capita, household income/capita)

# population
POP1 <- B1DAT$POP %>% rename(POP = Value) %>% mutate(SCEN = "b1")
POP2 <- B2DAT$POP %>% rename(POP = Value) %>% mutate(SCEN = "b2")
POP <- POP1 %>% full_join(POP2)

# household expenditures (domestic + imports) - comm,reg
VDPP1 <- B1DAT$VDPP %>% rename(VDPP = Value) %>% mutate(SCEN = "b1")
VDPP2 <- B2DAT$VDPP %>% rename(VDPP = Value) %>% mutate(SCEN = "b2")

VMPP1 <- B1DAT$VMPP %>% rename(VMPP = Value) %>% mutate(SCEN = "b1")
VMPP2 <- B2DAT$VMPP %>% rename(VMPP = Value) %>% mutate(SCEN = "b2")
# join & aggregate household expenditure
hhexp <- VDPP1  %>% full_join(VDPP2) %>% 
  left_join(VMPP1) %>% left_join(VMPP2) %>%
  replace(is.na(.), 0) %>%
  group_by(REG,SCEN) %>%  
  summarise(HHEXP = sum(VDPP + VMPP))

# GDP
GDP1 <- B1VEW$AG01 %>% rename(GDP = Value) %>% mutate(SCEN = "b1")
GDP2 <- B2VEW$AG01 %>% rename(GDP = Value) %>% mutate(SCEN = "b2")
GDP <- GDP1 %>% full_join(GDP2) %>%
  replace(is.na(.), 0) %>%
  group_by(REG,SCEN) %>%  
  summarise(GDP = sum(GDP))

# join income variables with regional dimension
reg <- POP %>%  full_join(GDP) %>%  full_join(hhexp)

# GET DATA FROM  WDI  ---------------------------------------------------------------

# Data collected from WDI:
# GDP (current US$)(NY.GDP.MKTP.CD) - use WDI GDP as may differ from GTAP GDP values
# GDP, PPP (current international $)(NY.GDP.MKTP.PP.CD) - converting GDP from $ to PPP $
# GDP, PPP (constant 2017 international $)(NY.GDP.MKTP.PP.KD) - converting to constant dollars for poverty line

# Current extreme poverty line used in SDGs (dec 2023 revision): The current 
# extreme poverty line is set at $2.15 a day in 2017 PPP terms, which represents
# the mean of the national poverty lines found in 28 low income countries

# define library
wdi_gdp_var = c(
  "nom_gdp_usd" = "NY.GDP.MKTP.CD",
  "nom_gdp.PPPusd" = "NY.GDP.MKTP.PP.CD",
  "real_gdp.2017PPPusd" = "NY.GDP.MKTP.PP.KD"
)

# get data from WDI
wdi_gdp_dat <- WDI(indicator = wdi_gdp_var, extra = TRUE)  %>% as_tibble() %>%
# rename iso3c to wb for matching to GTAP concordance
               rename(wb = iso3c) %>%
# remove aggregate regions 
               filter(., region != "Aggregates")

# after reading data saved raw data so no need to read again (stabilizes data used)
#saveRDS(wdi_gdp_dat, file = "./../../../TestData/wdi_gdp_raw.RDS")
#wdi_gdp_dat <- read_rds("./../../../TestData/wdi_gdp_raw.RDS")


# COMPUTE INDICATORS -----------------------------------------------------------

# Construct region specific deflator to get PPP values -------------------------

# select GDP in current and in PPP dollars for 2014 (reference year for v10)
gdp2ppp2014 <- subset(wdi_gdp_dat, 
                      select = c(wb,year,
                            nom_gdp_usd,nom_gdp.PPPusd,real_gdp.2017PPPusd)) %>%
               filter(., year == 2014) %>% drop_na()

# join with mapping 
iso2reg_wdi <- iso2reg_wdi %>% 
               left_join(gdp2ppp2014) %>%
               drop_na()
# group by model region
reg_wdi_2014 <- iso2reg_wdi  %>%
                group_by(REG) %>%
                summarise(
                nom_gdp_usd = sum(nom_gdp_usd),
                nom_gdp.PPPusd = sum(nom_gdp.PPPusd),
                real_gdp.2017PPPusd = sum(real_gdp.2017PPPusd)) %>% 
                as_tibble() %>%
# compute conversion factors 
                mutate(
                nom2ppp = nom_gdp.PPPusd / nom_gdp_usd,
                ppp2ppp2017 = real_gdp.2017PPPusd/nom_gdp.PPPusd) %>%
# select conversion factors
                subset(., select = c(REG,nom2ppp,ppp2ppp2017))
lab_acts_reg <- lab_acts_reg %>%  left_join(reg_wdi_2014)

# add deflators to regional data
reg <- reg %>%  full_join(ppriv12) %>% left_join(reg_wdi_2014)


# Real and PPP variants of labour payments -------------------------------

lab_acts_reg <- lab_acts_reg %>% mutate(
# real payments (deflated by CPI)                                 
  r_EVOS = (1-ppriv/100)* EVOS,
# real payments in PPP dollars  
  rp_EVOS = r_EVOS * nom2ppp,
# real payments in 2017 PPP dollars
  rp17_EVOS = rp_EVOS * ppp2ppp2017)
                                 

# Number of poor workers -------------------------------------------------------

# poverty lines are from Jolliffe et al. (2022): 
# URL: https://documents1.worldbank.org/curated/en/353811645450974574/pdf/Assessing-the-Impact-of-the-2017-PPPs-on-the-International-Poverty-Line-and-Global-Poverty.pdf

# Beyond the IPL, we also compute with the 2017 PPPs the higher poverty lines 
# the World Bank uses to monitor poverty in countries with a low incidence of
# extreme poverty-$3.20 and $5.50 in 2011 PPPs. These higher poverty lines
# reflect the median national poverty line of lower-middleincome countries and 
# upper-middle-income countries, respectively. With the 2017 PPPs, we compute 
# these lines to be approximately $3.65 and $6.85 per person per day. We also
# update the Bank's societal poverty line (SPL) originally defined as max($1.90,
# $1 + 50% of median consumption) in 2011 PPPs to max($2.15, $1.15 + 50% of 
# median consumption) in 2017 PPPs.

# Compute number of poor workers by poverty line
lab_acts_reg <- lab_acts_reg %>% mutate(
   wage.2017PPPUSD.day = (rp17_EVOS/QLAB)/365.25,
   poor_2.15 = ifelse(wage.2017PPPUSD.day < 2.15, 1, 0) * QLAB,
   poor_3.65 = ifelse(wage.2017PPPUSD.day < 3.65, 1, 0) * QLAB,
   poor_6.85 = ifelse(wage.2017PPPUSD.day < 6.85, 1, 0) * QLAB)

# get median wage by region and scenario
medianwage <- lab_acts_reg %>% 
              group_by(REG) %>%
              summarise (medianwage.2017PPPUSD.day = median(wage.2017PPPUSD.day))
lab_acts_reg <- lab_acts_reg %>%  left_join(medianwage)

# Compute number of poor workers by region specific social poverty line
lab_acts_reg <- lab_acts_reg %>% mutate(
  spl_reg = ifelse(1.15+(0.5*medianwage.2017PPPUSD.day) < 2.15, 2.15, 1.15+(0.5*medianwage.2017PPPUSD.day)),
  poor_spl = ifelse(wage.2017PPPUSD.day < spl_reg, 1, 0) * QLAB)


# Inputs for poverty gap calculation -------------------------------------------

# Poverty gap calculations by poverty line
lab_acts_reg <- lab_acts_reg %>% mutate(
  gap_2.15 =  ifelse(wage.2017PPPUSD.day < 2.15, 2.15-wage.2017PPPUSD.day, 0),
  gap_3.65 =  ifelse(wage.2017PPPUSD.day < 3.65, 3.65-wage.2017PPPUSD.day, 0),
  gap_6.85 =  ifelse(wage.2017PPPUSD.day < 6.85, 6.85-wage.2017PPPUSD.day, 0),
  gap_SPL =  ifelse(wage.2017PPPUSD.day < spl_reg, spl_reg-wage.2017PPPUSD.day, 0)
  )

# for poverty gap index calculations we need to sum these entities and
# divide them by the total number of workers (aggregation dependent).
# In MAGNET the poverty gap index is computed in PowerBI to easily explore 
# different aggregations

# Palma ratio ------------------------------------------------------------------

# We need to compute the share of wage income accruing to the top 10% and bottom
# 40% to derive the Palam ratio

# Compute total wage by stratum
finddecile <- lab_acts_reg %>% mutate( 
                  twage = QLAB * wage.2017PPPUSD.day)

# get data needed to interpolate bottom 40 and top 10%
finddecile <- finddecile %>% 
  group_by(REG,SCEN) %>%
  arrange(wage.2017PPPUSD.day) %>%
  mutate(
    cumshr = cumsum(QLAB/sum(QLAB)),
    cumwage = cumsum(twage),
    # get highest cum share and wage below 0.4     
    lt40 = ifelse(0.4 - cumshr >= 0, cumshr,0),
    lv40 = max(lt40),
    ls40 = ifelse(lt40 == lv40, cumshr,0),
    lw40 = ifelse(lt40 == lv40, cumwage,0),
    # get lowest  cum share and wage above 0.4
    mt40 = ifelse(0.4 - cumshr <= 0, cumshr,100),
    mv40 = ifelse (mt40 > 0, min(mt40),0),
    ms40 = ifelse(mt40 == mv40, cumshr,0),
    mw40 = ifelse(mt40 == mv40, cumwage,0),
    # get highest cum share and wage below 0.9     
    lt90 = ifelse(0.9 - cumshr >= 0, cumshr,0),
    lv90 = max(lt90),
    ls90 = ifelse(lt90 == lv90, cumshr,0),
    lw90 = ifelse(lt90 == lv90, cumwage,0),
    # get lowest  cum share and wage above 0.9
    mt90 = ifelse(0.9 - cumshr <= 0, cumshr,100),
    mv90 = ifelse (mt90 > 0, min(mt90),0),
    ms90 = ifelse(mt90 == mv90, cumshr,0),
    mw90 = ifelse(mt90 == mv90, cumwage,0),
    # get total wage 
    totwage = sum(twage),
    totqlab = sum(QLAB),
    # share of income and workers
    shrwage = twage/totwage,
    shrqlab = QLAB/totqlab
  )

# get single line by REG,SCEN through summarise
palma <- finddecile %>%
  group_by(REG,SCEN) %>%  
  summarise(
    ls40 = sum(ls40),
    lw40 = sum(lw40),
    ms40 = sum(ms40),
    mw40 = sum(mw40),
    ls90 = sum(ls90),
    lw90 = sum(lw90),
    ms90 = sum(ms90),
    mw90 = sum(mw90),
    totwage = mean(totwage),
    labforce = sum(QLAB)) %>%
# interpolate & compute palma ratio
    mutate(
    # interpolate to get cumulative wage bottom 40 and bottom 90      
    inc40 = mw40 + (0.4 - ms40)*(mw40 - lw40)/(ms40 - ls40),
    inc90 = mw90 + (0.9 - ms90)*(mw90 - lw90)/(ms90 - ls90),
    # derive income top 10%    
    inc10 = totwage - inc90,
    # compute shares in total income bottom 40 and top 10
    shr40 = inc40/totwage,
    shr10 = inc10/totwage,
    palma = shr10/shr40) %>%
# save only income shares and palma for further analysis and labforce as weights
    subset(., select = c(REG, SCEN, shr40, shr10, palma,labforce))

# combine with other data 
reg <- reg %>%  full_join(palma) 


# FILTER FOR IMPLAUSIBLE WAGES -------------------------------------------------

# Data limitations may result in highly implausible wages. This section of the code
# provides code to identify outliers and create a filter to remove these from the
# wage-based indicator caculations.
# Be careful to assess implications and adjust the filter based on the 
# distribution in your own data. Some summaries are provided to judge the outliers.

# We filter by model region based on wage distribution in the basedata to avoid
# impact of scenarios on the results. We use the interquartile range (IQR) 
# to define outliers as this does not require assumptions on the distribution.

# Compute upper and lower bounds from the IQR ----------------------------------

EVOSB <- BDAT$EVOS %>% rename(EVOS = Value)
BaseWage <- BDAT$QLAB %>% rename(QLAB = Value, ENDWLAB = ENDWLAB_COMM)
BaseWage <- BaseWage %>% 
            left_join(EVOSB,
                      by = join_by(REG == REG, ACTS == ACTS, ENDWLAB == ENDW)) %>%
            mutate (WAGE = EVOS/QLAB) %>%
            group_by(REG) %>%  
            mutate(iqrreg = IQR(na.rm = TRUE, WAGE),
            q1 = quantile(na.rm = TRUE, WAGE, probs = c(0.25)),
            q3 = quantile(na.rm = TRUE, WAGE, probs = c(0.75)),
            Low_1.5 = q1 - 1.5*iqrreg,
            Low_3 = q1 - 3*iqrreg,
            High_1.5 = q3 + 1.5*iqrreg,
            High_3 = q3 + 3*iqrreg,
            bounds = case_when(.default = "OK",
                            WAGE < Low_1.5 ~ "L1.5",
                            WAGE < Low_3 ~ "L3",
                            WAGE > High_1.5 ~ "H1.5",
                            WAGE > High_3 ~ "H3"),
         wagefilter = case_when(.default = 0,
                                bounds == "OK" ~ 1),
                                counter = 1) %>%
  ungroup()

# Explore the impact of the high and low fences dereived from the IQR ----------

# count number of cases by wagefilter
BaseWage %>% count(bounds, sort = TRUE)

# check removals by region in terms of workers
reg_sample <- BaseWage %>%
  group_by(REG) %>%  
  summarise(all_qlab = sum(QLAB),
            fltr_qlab = sum(QLAB*wagefilter),
            nrfiltr = sum(wagefilter),
            nrall = sum(counter)) %>% 
  mutate (shr_qlab = fltr_qlab/all_qlab,
          shr_N =  nrfiltr/nrall)

# Check removals by activity
acts_sample <- BaseWage %>%
  group_by(ACTS) %>%  
  summarise(all_qlab = sum(QLAB),
            fltr_qlab = sum(QLAB*wagefilter)) %>% 
  mutate (shr_fltr = fltr_qlab/all_qlab)

# Check removals by region & activity 
regacts_sample <- BaseWage %>%
  group_by(REG,ACTS) %>%  
  summarise(all_qlab = sum(QLAB),
            fltr_qlab = sum(QLAB*wagefilter)) %>% 
  mutate (shr_fltr = fltr_qlab/all_qlab)

# Check removals by region & labour type
reglab_sample <- BaseWage %>%
  group_by(REG,ENDWLAB) %>%  
  summarise(all_qlab = sum(QLAB),
            fltr_qlab = sum(QLAB*wagefilter)) %>% 
  mutate (shr_fltr = fltr_qlab/all_qlab)

# Create filter variable with manual adjustments if needed
wage_filter <- BaseWage %>% 
# adjust this example code if some cases needed to be placed back in sample  
        mutate( wagef_adj = case_when(.default = wagefilter,
                            REG == "WEU" & ACTS == "foodserv" ~ 1)) %>%
# keep only the filter variable  (default and adjusted so can easily compare impact)
        subset(., select = c(ENDWLAB,ACTS,REG,wagefilter,wagef_adj))

#join filter with wage file
lab_acts_reg <- lab_acts_reg %>% left_join(wage_filter)


# Rerun poverty and palma calcualtions with filtered data ---------------------

# Select filtered data
fltr_lab_acts_reg <- lab_acts_reg %>%
  subset(., select = c(ENDWLAB,ACTS,REG,SCEN, 
                       wagef_adj,rp17_EVOS,QLAB)) %>%
  filter(., wagef_adj== 1)

# Compute number of poor workers by poverty line
fltr_lab_acts_reg <- fltr_lab_acts_reg %>% mutate(
  wage.2017PPPUSD.day = (rp17_EVOS/QLAB)/365.25,
  poor_2.15 = ifelse(wage.2017PPPUSD.day < 2.15, 1, 0) * QLAB,
  poor_3.65 = ifelse(wage.2017PPPUSD.day < 3.65, 1, 0) * QLAB,
  poor_6.85 = ifelse(wage.2017PPPUSD.day < 6.85, 1, 0) * QLAB)

# get median wage by region and SCENario
fltr_medianwage <- fltr_lab_acts_reg %>% 
  group_by(REG) %>%
  summarise (medianwage.2017PPPUSD.day = median(wage.2017PPPUSD.day))
fltr_lab_acts_reg <- fltr_lab_acts_reg %>%  left_join(fltr_medianwage)                        

# Compute number of poor workers by region specific social poverty line
fltr_lab_acts_reg <- fltr_lab_acts_reg %>% mutate(
  spl_reg = ifelse(1.15+(0.5*medianwage.2017PPPUSD.day) < 2.15, 2.15, 1.15+(0.5*medianwage.2017PPPUSD.day)),
  poor_spl = ifelse(wage.2017PPPUSD.day < spl_reg, 1, 0) * QLAB)


# Poverty gap inputs -----------------------------------------------------------

# Poverty gap calculations by poverty line
fltr_lab_acts_reg <- fltr_lab_acts_reg %>% mutate(
  gap_2.15 =  ifelse(wage.2017PPPUSD.day < 2.15, 2.15-wage.2017PPPUSD.day, 0),
  gap_3.65 =  ifelse(wage.2017PPPUSD.day < 3.65, 3.65-wage.2017PPPUSD.day, 0),
  gap_6.85 =  ifelse(wage.2017PPPUSD.day < 6.85, 6.85-wage.2017PPPUSD.day, 0),
  gap_SPL =  ifelse(wage.2017PPPUSD.day < spl_reg, spl_reg-wage.2017PPPUSD.day, 0)
)

# for poverty gap index calculations we need to sum these entities, sum them and
# divide them by the total number of workers (aggregation dependent):
# poverty gap index computed in PowerBI because of aggregtion dependence


# Palma ratio ------------------------------------------------------------------

# compute total wage by stratum
fltr_finddecile <- fltr_lab_acts_reg %>% mutate( 
  twage = QLAB * wage.2017PPPUSD.day)

# get data needed to interpolate bottom 40 and top 10%
fltr_finddecile <- fltr_finddecile %>% 
  group_by(REG,SCEN) %>%
  arrange(wage.2017PPPUSD.day) %>%
  mutate(
    cumshr = cumsum(QLAB/sum(QLAB)),
    cumwage = cumsum(twage),
    # get highest cum share and wage below 0.4     
    lt40 = ifelse(0.4 - cumshr >= 0, cumshr,0),
    lv40 = max(lt40),
    ls40 = ifelse(lt40 == lv40, cumshr,0),
    lw40 = ifelse(lt40 == lv40, cumwage,0),
    # get lowest  cum share and wage above 0.4
    mt40 = ifelse(0.4 - cumshr <= 0, cumshr,100),
    mv40 = ifelse (mt40 > 0, min(mt40),0),
    ms40 = ifelse(mt40 == mv40, cumshr,0),
    mw40 = ifelse(mt40 == mv40, cumwage,0),
    # get highest cum share and wage below 0.9     
    lt90 = ifelse(0.9 - cumshr >= 0, cumshr,0),
    lv90 = max(lt90),
    ls90 = ifelse(lt90 == lv90, cumshr,0),
    lw90 = ifelse(lt90 == lv90, cumwage,0),
    # get lowest  cum share and wage above 0.9
    mt90 = ifelse(0.9 - cumshr <= 0, cumshr,100),
    mv90 = ifelse (mt90 > 0, min(mt90),0),
    ms90 = ifelse(mt90 == mv90, cumshr,0),
    mw90 = ifelse(mt90 == mv90, cumwage,0),
    # get total wage 
    totwage = sum(twage),
    totqlab = sum(QLAB),
    # share of income and workers
    shrwage = twage/totwage,
    shrqlab = QLAB/totqlab
  )

# Derive the filtered Palma ratio
fltr_palma <- fltr_finddecile %>%
  group_by(REG,SCEN) %>%  
  summarise(
    ls40 = sum(ls40),
    lw40 = sum(lw40),
    ms40 = sum(ms40),
    mw40 = sum(mw40),
    ls90 = sum(ls90),
    lw90 = sum(lw90),
    ms90 = sum(ms90),
    mw90 = sum(mw90),
    totwage = mean(totwage),
    fltr_labforce = sum(QLAB))%>%
# interpolate & compute palma
    mutate(
    # interpolate to get cumulative wage bottom 40 and bottom 90      
    inc40 = mw40 + (0.4 - ms40)*(mw40 - lw40)/(ms40 - ls40),
    inc90 = mw90 + (0.9 - ms90)*(mw90 - lw90)/(ms90 - ls90),
    # derive income top 10%    
    inc10 = totwage - inc90,
    # compute shares in total income bottom 40 and top 10
    fltr_shr40 = inc40/totwage,
    fltr_shr10 = inc10/totwage,
    fltr_palma = fltr_shr10/fltr_shr40) %>% 
# save only income shares and palma for further analysis
    subset(., select = c(REG, SCEN, fltr_shr40, fltr_shr10, fltr_palma, fltr_labforce))

# Add filtered data to  file with REG dimension
reg <- reg %>% full_join(fltr_palma)

# SAVE REULTS TO CSV ----------------------------------------------------------

# organized by dimensionsof indicators
write.csv(lab_acts_reg,"./../../../TestData/Xlab_acts_reg.csv", row.names = FALSE)
write.csv(reg,"./../../../TestData/Xreg.csv", row.names = FALSE)