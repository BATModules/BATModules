#============================================================================
#  File      : MBL_ProductionShares.r
#  Remarks   : Use the Leontief inverse to compute contents of consumed
#              commodities and derive production shares
#=============================================================================

# Data preparation -----------------------------------------------------------

# Split combined indices in Leontief invers
#MBL_LI(i,s,c,d) # Quantity-based Leontief inverse  i from s in final demand c in d #;
MBL_LI <- MBL_L %>%
  melt(.) %>% 
  left_join(comregmap) %>% 
  left_join(comregmap2) %>% 
  select(-COMREG, -COMREG_2) %>%
  rename(Value = value)

# Production required for final demand by agent  ---------------------------------

# Leontief inverse specifies the amount of production i from region p needed
# for final demand of c in s. Multiplying this with the final demand for c from s
# by final demand categories from d provides full description of how products
# flow from p via s to final demand in d. We combine the final demand categories
# in a single set to create a single matrix

#MBL_Q2FD(i,p,c,s,f,d) # Production i in p for final demand in d via cons. of c from s (mil USD)#;
MBL_Q2FD <- COMM %>%
  rename(i = Value) %>%
  merge(., REG %>%
          rename(p = Value)) %>%
  merge(. , COMM %>%
          rename(c = Value)) %>%
  merge(. , REG %>%
          rename(s = Value)) %>%
  merge(. , FDEM %>%
          rename(f = Value)) %>%
  merge(. , REG %>%
          rename(d = Value)) %>%
  left_join(. , MBL_LI %>%
              rename(i = COMM,
                     p = REG,
                     c = COMM_2,
                     s = REG_2,
                     LI = Value)) %>%
  left_join(., MBL_s_FP_q %>%
              rename(c = COMM,
                     s = REG,
                     d = REG_2,
                     s_FP_q = Value) %>%
              mutate(f = "phh")) %>%
  left_join(., MBL_s_FG_q %>%
              rename(c = COMM,
                     s = REG,
                     d = REG_2,
                     s_FG_q = Value) %>%
              mutate(f = "gvt")) %>%
  left_join(., MBL_s_FI_q %>%
              rename(c = COMM,
                     s = REG,
                     d = REG_2,
                     s_FI_q = Value) %>%
              mutate(f = "inv")) %>%
  mutate(Value = ifelse(f == "phh", s_FP_q * LI, 
                        ifelse(f == "gvt", s_FG_q * LI, 
                               ifelse(f == "inv", s_FI_q * LI, 0)))) %>%
  select(COMM = i,
         REG = p,
         COMM_2 = c,
         REG_2 = s,
         FDEM = f,
         REG_3 = d,
         Value)

# This provides the full matrix of how production of i in region p flows to
# final demand categories in d. Based on the Leontief inverse it captures all direct
# and indirect flows through the global economy. Of these flows only the producer
# location (p) and final commodity (c) source region (s) are made explicit in
# tracing how commodity i from region p arrives in final consumption of c from s
# by agent a located in region d. It can serve to derive more manageable subset of
# flows like  direct and indirect flows of primary products etc. 

# NB summing over all c,s,d and f should equal the production i in p
# (requirement of the material balance that the demand for each commodity (direct
# + indirect) has to equal production.

# As matrix inversion is less numerically accurate than solving system of
# equations there will be deviations. Given larg differences in size of sectors
# we express this check in percentage terms 

# MBL_chk_FDq(i,p) # Difference beteen sum of demand and production (%) #;
MBL_chk_FDq <- MBL_Q2FD %>%
  rename(i = COMM,
         p = REG,
         c = COMM_2,
         s = REG_2,
         f = FDEM,
         d = REG_3,
         Q2FD = Value) %>%
  group_by(i, p) %>%
  summarize(Q2FD = sum(Q2FD)) %>%
  ungroup() %>%
  left_join(. , MBL_Q_q %>%
              rename(i = COMM,
                     p = REG,
                     Q_q = Value)) %>%
  mutate(Value = 100 * (Q2FD/Q_q -1)) %>%
  select(COMM = i,
         REG = p,
         Value)


# Express final demand as shares ----------------------------------------------------

# To ease the introduction of for example biophysical quantities we express
# material flows in shares. This also takes care of any slacks due to
# imprecision in the matrix inversion. 

#MBL_FD_shr(i,p,c,s,f,d) 
#Shares final demand in d for produced i from p via consumption of c from d #;
MBL_FD_shr <- MBL_Q2FD %>%
  rename(i = COMM,
         p = REG,
         c = COMM_2,
         s = REG_2, 
         f = FDEM,
         d = REG_3,
         Q2FD = Value) %>%
  group_by(i, p) %>% 
  mutate(Value = Q2FD / sum(Q2FD)) %>% 
  ungroup() %>%
  mutate(Value = ifelse(is.nan(Value), 0, Value)) %>%
  select(COMM = i,
         REG = p,
         COMM_2 = c,
         REG_2 = s,
         FDEM = f,
         REG_3 = d,
         Value)

