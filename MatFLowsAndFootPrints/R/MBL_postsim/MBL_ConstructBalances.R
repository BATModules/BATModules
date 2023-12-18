#============================================================================
# File      : MBL_ConstructBalances.r
# Remarks   : Construct regionalized material balances using data on quantities
#             produced and demanded
# =============================================================================


# Allocate activity intermediate demand to commodities--------------------

#  Activity accounts need to be split in case of by-products. Default split is 
#  value-based (computed from baseedata). Can be replaced by user-defined split 
#  read from file if provided.  

# Value-shares of commodities in intermediate input use - no differentiation by inputs

# Commodity share in activity a input use  in r #;  

# MBL_VAL_SHR(c,a,r) # Commodity share in activity a input use  in r #;
MBL_VAL_SHR <- MAKEB %>% 
  rename(c = COMM,
         a = ACTS,
         r = REG) %>%
  group_by(a, r) %>% 
  mutate(Value = Value / sum(Value)) %>% 
  ungroup() %>%
  mutate(Value = ifelse(is.nan(Value), 0, Value)) %>%
  rename(COMM = c,
         ACTS = a,
         REG = r)


COMM_2 <- data.frame(MBL_VAL_SHR$COMM) %>%
  rename(COMM_2 = MBL_VAL_SHR.COMM) %>%
  unique()

# MBL_COMM_SHR(c,i,a,r) # Commodity share c in inputs i used by activity a in r #;
MBL_COMM_SHR <- merge(MBL_VAL_SHR, 
                      COMM_2)


#Write to check file so can serve as template for custom shares!
CHEK$VBCS <- magnetr:::magnet_prepdf_for_write_har(
  MBL_COMM_SHR, list(COMM = COMM$Value,
                     ACTS = ACTS$Value,
                     COMM_2 = COMM$Value,
                     REG = REG$Value))

# Allow user-defined shares to change allocation of inputs #
MBL_COMM_SHR <- if (is.null(dim(XDATA$CSHR))) {
  MBL_COMM_SHR
} else {
  XDATA$CSHR 
}

#  Define components of material balance equations ------------------------------------------   

#Define coefficients for material balance equations in quantity terms
# production (Q) = intermediate demand (I) + final demand (F)

# Total demand for imports from demand - assures that shares sum to 1 ----------------------
# MBL_m_TOT_q(i,d)  # Total demand for imports i in destination region d (mil. USD)#;
MBL_m_TOT_q <- MBL_m_INT_q %>%
  rename(i = COMM,
         a = ACTS,
         d = REG,
         m_INT_q = Value) %>%
  group_by(i, d) %>% 
  summarize(sum_m_INT_q = sum(m_INT_q)) %>%
  ungroup() %>%
  left_join(.,
            MBL_m_FINP_q %>%
              rename(i = COMM,
                     d = REG,
                     m_FINP_q = Value)) %>%
  left_join(., 
            MBL_m_FING_q %>%
              rename(i = COMM,
                     d = REG,
                     m_FING_q = Value)) %>%
  left_join(., MBL_m_FINI_q  %>%
              rename(i = COMM,
                     d = REG,
                     m_FINI_q = Value)) %>%
  mutate(Value = sum_m_INT_q + m_FINP_q + m_FING_q + m_FINI_q) %>%
  select(COMM = i,
         REG = d,
         Value)

# Fill Production -------------------------------------------------------------------------------
# MBL_Q_q(i,s) # Quantity of production by commodity i and region s (mil USD)#;
MBL_Q_q <-  MBL_PROD_q %>% 
  group_by(COMM, REG) %>% 
  summarize(Value = sum(Value)) %>%
  ungroup()

#  Fill for non-margin demand --------------------------------------------------------------------  

# Fill intermediate demand -----------------------------------------------------------------------

# Imports
# MBL_I_q(i,s,c,d) # Intermediate demand for i from s by commodity c in region d (mil USD) #;
MBL_I_q <- full_join(MBL_TRADE_q %>%
                       rename(i = COMM,
                              s = REG,
                              d = REG_2,
                              TRADE_q = Value),
                     left_join(MBL_COMM_SHR %>%
                                 rename(c = COMM,
                                        i = COMM_2,
                                        a = ACTS,
                                        d = REG,
                                        COMM_SHR = Value),
                               MBL_m_INT_q %>%
                                 rename(i = COMM,
                                        a = ACTS,
                                        d = REG,
                                        m_INT_q = Value)) %>% 
                       mutate(V2 = COMM_SHR * m_INT_q) %>%
                       group_by(c, i, d) %>%
                       summarize(V2 = sum(V2)) %>%
                       ungroup()
) %>%
  left_join(MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  mutate(Value = TRADE_q * V2 / m_TOT_q) %>%
  select(i, s, c, d, Value)
# domestic (allowing for self-trade)
MBL_I_q <- MBL_I_q %>%
  rename(I_q = Value) %>%
  left_join(., 
            left_join(MBL_COMM_SHR %>%
                        rename(c = COMM,
                               i = COMM_2,
                               a = ACTS,
                               d = REG,
                               COMM_SHR = Value),
                      MBL_d_INT_q %>%
                        rename(i = COMM,
                               a = ACTS,
                               d = REG,
                               d_INT_q = Value)) %>% 
              mutate(V2 = COMM_SHR * d_INT_q) %>%
              group_by(c, i, d) %>%
              summarize(V2 = sum(V2)) %>%
              ungroup()
  ) %>%
  mutate(Value =  ifelse(s == d, I_q + V2, I_q)) %>%
  select(COMM = i, 
         REG = s,
         COMM_2 = c,
         REG_2 = d,
         Value)  


# MBL_FP_q(i,s,d) # Final demand for i from s by private household in region d (mil USD) #;
MBL_FP_q <- MBL_TRADE_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         TRADE_q = Value) %>%
  left_join(. ,
            MBL_m_FINP_q %>%
              rename(i = COMM,
                     d = REG,
                     m_FINP_q = Value)) %>%
  left_join(.,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  mutate(Value = TRADE_q * m_FINP_q / m_TOT_q ) %>%
  select(i, s, d, Value)
# domestic (allowing for self-trade)
MBL_FP_q <- MBL_FP_q %>%
  rename(FP_q = Value) %>%
  left_join(.,
            MBL_d_FINP_q %>%
              rename(i = COMM,
                     d = REG, 
                     d_FINP_q = Value)) %>%
  mutate(Value =  FP_q + d_FINP_q) %>%
  mutate(Value =  ifelse(s == d, FP_q + d_FINP_q, FP_q)) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)

# MBL_FG_q(i,s,d) # Final demand for i from s by government in region d (mil USD) #;
MBL_FG_q <- MBL_TRADE_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         TRADE_q = Value) %>%
  left_join(. ,
            MBL_m_FING_q %>%
              rename(i = COMM,
                     d = REG,
                     m_FING_q = Value)) %>%
  left_join(.,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  mutate(Value = TRADE_q * m_FING_q / m_TOT_q ) %>%
  select(i, s, d, Value)
# domestic (allowing for self-trade)
MBL_FG_q <- MBL_FG_q %>%
  rename(FG_q = Value) %>%
  left_join(.,
            MBL_d_FING_q %>%
              rename(i = COMM,
                     d = REG, 
                     d_FING_q = Value)) %>%
  mutate(Value =  ifelse(s == d, FG_q + d_FING_q, FG_q)) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)


# MBL_FI_q(i,s,d) # Final demand for i from s by government in region d (mil USD) #;
MBL_FI_q <- MBL_TRADE_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         TRADE_q = Value) %>%
  left_join(. ,
            MBL_m_FINI_q %>%
              rename(i = COMM,
                     d = REG,
                     m_FINI_q = Value)) %>%
  left_join(.,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  mutate(Value = TRADE_q * m_FINI_q / m_TOT_q ) %>%
  select(i, s, d, Value)
# domestic (allowing for self-trade)
MBL_FI_q <- MBL_FI_q %>%
  rename(FI_q = Value) %>%
  left_join(.,
            MBL_d_FINI_q %>%
              rename(i = COMM,
                     d = REG, 
                     d_FINI_q = Value)) %>%
  mutate(Value =  ifelse(s == d, FI_q + d_FINI_q, FI_q)) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)



#  Allocate international margins & add to demand  ----------------------------------------

#  Allocate international margins supplied to the global transpot pool by using
#  the share of supplying rgeions t in total transport and allocating the demand
#  for international margins linked to imports of c from from s based on the
#  share of each demand category in total imports of c from s. Result is then
#  summed over c and set to get the (indiretc) imports of margins m from
#  transporter region t by the demand categories in d.

#regional share of transporter t in supply of margin m to global pool#
MBL_SHR_TRANSS <- MBL_TRANSS_q %>%
  rename(m = MARG,
         t = REG,
         Value_MARG = Value) %>%
  group_by(m) %>%
  mutate(Value = Value_MARG/ sum(Value_MARG )) %>% 
  ungroup() %>%
  select(MARG = m,
         REG = t,
         Value)

#MBL_m_I_TRNS(m,t,c,d) # Int'l transport margins from s for intermediate use by c in d (mil. USD) #;
MBL_m_I_TRNS <- MBL_COMM_SHR %>%
  rename(c = COMM,
         i = COMM_2,
         a = ACTS,
         d = REG,
         COMM_SHR = Value) %>%
  left_join(., 
            MBL_m_INT_q %>%
              rename(i = COMM,
                     a = ACTS,
                     d = REG,
                     m_INT_q = Value)) %>% 
  # demand category share in total imports of commodity
  mutate(Value = COMM_SHR * m_INT_q) %>%
  group_by(c, i, d) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  left_join(., MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  mutate(Value = Value / m_TOT_q) %>%
  # international margins demanded for imports of commodity i from s #
  left_join(., 
            MBL_TRANSD_q %>%
              rename(m = MARG,
                     i = COMM,
                     s = REG,
                     d = REG_2,
                     TRANSD_q = Value)) %>%
  #regional share of transporter t in supply of margin m to global pool# 
  left_join(., MBL_SHR_TRANSS %>%
              rename(m = MARG,
                     t = REG,
                     SHR_TRANSS = Value)
  ) %>%
  mutate(Value = SHR_TRANSS * Value * TRANSD_q) %>%
  group_by(m,t,c,d) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  rename(MARG = m,
         REG = t,
         COMM = c,
         REG_2 = d)


#MBL_m_FP_TRS(m,t,d) # Int'l transport margins from t for private hh imports in d (mil. USD) #;
MBL_m_FP_TRS <-  MBL_m_FINP_q %>%
  rename(i = COMM,
         d = REG,
         m_FINP_q = Value) %>%
  left_join(. ,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  #demand category share in total imports of commodity i#
  mutate(Value = m_FINP_q/m_TOT_q) %>%
  # international margins demanded for imports of commodity i from s #
  left_join(., 
            MBL_TRANSD_q %>%
              rename(m = MARG,
                     i = COMM,
                     s = REG,
                     d = REG_2, 
                     TRANSD_q = Value)) %>% 
  #regional share of transporter t in supply of margin m to global pool# 
  left_join(., MBL_SHR_TRANSS %>%
              rename(m = MARG,
                     t = REG,
                     SHR_TRANSS = Value)
  ) %>%
  mutate(Value = SHR_TRANSS * Value *  TRANSD_q) %>%
  group_by(m, t, d) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  rename(MARG = m,
         REG = t,
         REG_2 = d)

#MBL_m_FG_TRS(m,t,d)  # Int'l transport margins from t for government imports in d (mil. USD) #;
MBL_m_FG_TRS <-  MBL_m_FING_q %>%
  rename(i = COMM,
         d = REG,
         m_FING_q = Value) %>%
  left_join(. ,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  #demand category share in total imports of commodity i#
  mutate(Value = m_FING_q/m_TOT_q) %>%
  # international margins demanded for imports of commodity i from s #
  left_join(., 
            MBL_TRANSD_q %>%
              rename(m = MARG,
                     i = COMM,
                     s = REG,
                     d = REG_2, 
                     TRANSD_q = Value)) %>% 
  #regional share of transporter t in supply of margin m to global pool# 
  left_join(., MBL_SHR_TRANSS %>%
              rename(m = MARG,
                     t = REG,
                     SHR_TRANSS = Value)
  ) %>%
  mutate(Value = SHR_TRANSS * Value *  TRANSD_q) %>%
  group_by(m, t, d) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  rename(MARG = m,
         REG = t,
         REG_2 = d)

#MBL_m_FI_TRS(m,t,d)  # Int'l transport margins from t for investment imports in d (mil. USD) #;
MBL_m_FI_TRS <-  MBL_m_FINI_q %>%
  rename(i = COMM,
         d = REG,
         m_FINI_q = Value) %>%
  left_join(. ,
            MBL_m_TOT_q %>%
              rename(i = COMM,
                     d = REG,
                     m_TOT_q = Value)) %>%
  #demand category share in total imports of commodity i#
  mutate(Value = m_FINI_q/m_TOT_q) %>%
  # international margins demanded for imports of commodity i from s #
  left_join(., 
            MBL_TRANSD_q %>%
              rename(m = MARG,
                     i = COMM,
                     s = REG,
                     d = REG_2, 
                     TRANSD_q = Value)) %>% 
  #regional share of transporter t in supply of margin m to global pool# 
  left_join(., MBL_SHR_TRANSS %>%
              rename(m = MARG,
                     t = REG,
                     SHR_TRANSS = Value)
  ) %>%
  mutate(Value = SHR_TRANSS * Value *  TRANSD_q) %>%
  group_by(m, t, d) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  rename(MARG = m,
         REG = t,
         REG_2 = d)

# Add this indirect demand for transport services to the direct demand already
# computed above  

MBL_I_q <- MBL_I_q %>%
  #filter(COMM == MARG$Value) %>%
  rename(i = COMM,
         s = REG,
         c = COMM_2,
         d = REG_2,
         I_q = Value) %>%
  left_join(. ,
            MBL_m_I_TRNS %>%
              rename(m = MARG,
                     s = REG,
                     c = COMM,
                     d = REG_2,
                     m_I_TRNS = Value)) %>%
  mutate(Value = ifelse(i %in% MARG$Value, I_q + m_I_TRNS, I_q)) %>%
  select(COMM = i,
         REG = s,
         COMM_2 = c,
         REG_2 = d,
         Value)

MBL_FP_q <- MBL_FP_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         FP_q = Value) %>%
  left_join(., MBL_m_FP_TRS %>%
              rename(m = MARG,
                     s = REG,
                     d = REG_2,
                     m_FP_TRS = Value)) %>%
  mutate(Value = ifelse(i %in% MARG$Value, FP_q + m_FP_TRS, FP_q)) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)

MBL_FG_q <- MBL_FG_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         FG_q = Value) %>%
  left_join(., MBL_m_FG_TRS %>%
              rename(m = MARG,
                     s = REG,
                     d = REG_2,
                     m_FG_TRS = Value)) %>%
  replace(is.na(.), 0) %>%
  mutate(Value = ifelse(i %in% MARG$Value, FG_q + m_FG_TRS, FG_q)) %>%
  select(COMM= i,
         REG = s,
         REG_2 = d,
         Value)

MBL_FI_q <- MBL_FI_q %>%
  rename(i = COMM,
         s = REG,
         d = REG_2,
         FI_q = Value) %>%
  left_join(., MBL_m_FI_TRS %>%
              rename(m = MARG,
                     s = REG,
                     d = REG_2,
                     m_FI_TRS = Value)) %>%
  replace(is.na(.), 0) %>%
  mutate(Value = ifelse(i %in% MARG$Value, FI_q + m_FI_TRS, FI_q)) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)


# Check if material balances hold-------------------------------


#MBL_TOTDEM_q(i,s) # Total demand for commodity i from s (mil USD) #;
MBL_TOTDEM_q <-  MBL_I_q %>%
  rename(i = COMM,
         s = REG,
         c = COMM_2,
         d = REG_2,
         I_q = Value) %>%
  group_by(i,s,d) %>%
  summarize(I_q = sum(I_q)) %>%
  ungroup() %>%
  left_join(.,
            MBL_FP_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FP_q = Value)
  ) %>%
  left_join(.,
            MBL_FG_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FG_q = Value)
  ) %>%
  left_join(., MBL_FI_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FI_q = Value)
  ) %>%
  mutate(Value = I_q + FP_q + FG_q + FI_q) %>%
  group_by(i, s) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  select(COMM = i,
         REG = s,
         Value)

# Compute slack on material balances in percentages as quantities produced vary
# widely 

# MBL_SLACK_p(i,s) # Slack or imbalance in material flows for commodity i from s (%) #; 
MBL_SLACK_p <- MBL_TOTDEM_q %>%
  rename(i = COMM,
         s = REG,
         TOTDEM_q = Value) %>%
  left_join(. ,
            MBL_Q_q %>%
              rename(i = COMM,
                     s = REG,
                     Q_q = Value)
  ) %>%
  mutate(Value = 100 * (TOTDEM_q / Q_q - 1)) %>%
  select(COMM = i,
         REG = s,
         Value)


#  Scale demand categories to quantity produced -----------------------------------------

# We trust changes in production most as here maximum one CET in case of joint
#  production. Redistribute slack over demand categories to not bias relative 
#  amounts

# MBL_s_I_q(i,s,c,d) # Scaled interm. demand for i from s by commodity c in region d (mil USD) #;
MBL_s_I_q <-  MBL_Q_q %>%
  rename(i = COMM,
         s = REG,
         Q_q = Value) %>%
  left_join(., 
            MBL_TOTDEM_q %>%
              rename(i = COMM,
                     s = REG,
                     TOTDEM_q = Value)
  ) %>%
  left_join(MBL_I_q %>%
              rename(i = COMM,
                     s = REG,
                     c = COMM_2,
                     d = REG_2,
                     I_q = Value)
  ) %>%
  mutate(Value = (Q_q/TOTDEM_q) * I_q) %>%
  select(COMM = i,
         REG = s,
         COMM_2 = c,
         REG_2 = d,
         Value)

#MBL_s_FP_q(i,s,d) # Scaled final demand for i from s by private hh in region d (mil USD) #;
MBL_s_FP_q <-  MBL_Q_q %>%
  rename(i = COMM,
         s = REG,
         Q_q = Value) %>%
  left_join(., 
            MBL_TOTDEM_q %>%
              rename(i = COMM,
                     s = REG,
                     TOTDEM_q = Value)
  ) %>%
  left_join(MBL_FP_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FP_q = Value)
  ) %>%
  mutate(Value = (Q_q/TOTDEM_q) * FP_q) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)

# MBL_s_FG_q(i,s,d) # Scaled final demand for i from s by government in region d (mil USD) #;
MBL_s_FG_q <-  MBL_Q_q %>%
  rename(i = COMM,
         s = REG,
         Q_q = Value) %>%
  left_join(., 
            MBL_TOTDEM_q %>%
              rename(i = COMM,
                     s = REG,
                     TOTDEM_q = Value)
  ) %>%
  left_join(MBL_FG_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FG_q = Value)
  ) %>%
  mutate(Value = (Q_q/TOTDEM_q) * FG_q) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)

# MBL_s_FI_q(i,s,d) # Scaled final demand for i from s by investment in region d (mil USD) #;
MBL_s_FI_q <-  MBL_Q_q %>%
  rename(i = COMM,
         s = REG,
         Q_q = Value) %>%
  left_join(., 
            MBL_TOTDEM_q %>%
              rename(i = COMM,
                     s = REG,
                     TOTDEM_q = Value)
  ) %>%
  left_join(MBL_FI_q %>%
              rename(i = COMM,
                     s = REG,
                     d = REG_2,
                     FI_q = Value)
  ) %>%
  mutate(Value = (Q_q/TOTDEM_q) * FI_q) %>%
  select(COMM = i,
         REG = s,
         REG_2 = d,
         Value)  