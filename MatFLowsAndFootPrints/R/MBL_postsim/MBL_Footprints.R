#============================================================================
# File      : MBL_Footprints.r
# Remarks   : Combine shares in production by final demand category with activity
#             characteristics to compute footprint indicators. 
#=============================================================================  


# Read data on foot print indicators -------------------------------------------

# Cannot read from file in post-sim after initialization so short intermezzo

# MBL_A_FPRINT(n,a,p)  # Activity level footprints (various units) #;
MBL_A_FPRINT <- ACTDAT$A_FP %>%
  data.frame()

# MBL_I_FPRINT(n,k,a,p) #Intermediate input level footprints (various units) #;
MBL_I_FPRINT <- ACTDAT$I_FP %>%
  data.frame()

# Compute footprint indicator ----------------------------------------------------

# Combine footprint data in single header

#MBL_FOOTP_RW(n,i,p,g,s,t,d) 
#Footprint n for i produced in p by channel in s and final demand cat t in d#;
if (dim(MBL_I_FPRINT)[1] == 0) {
# Assign activity footprints to produced commodities
  MBL_FOOTP_RW <-  MBL_COMM_SHR %>%
    rename(i = COMM,
           k = COMM_2,
           a = ACTS,
           p = REG,
           COMM_SHR = Value) %>%
    left_join(., MBL_A_FPRINT %>%
                rename(n = FPRNT_A,
                       a = ACTS,
                       p = REG,
                       FPRINT_A_Value = Value)) %>%
    mutate(Value = COMM_SHR * FPRINT_A_Value) %>%
    select(-k) %>%
    unique() %>%
    group_by(n,i,p) %>%
    summarize(Value = sum(Value)) %>%
    ungroup() %>%
    left_join(. ,
              MBL_FD_shr %>%
                rename(
                  i = COMM,
                  p = REG,
                  c = COMM_2,
                  s = REG_2,
                  f = FDEM,
                  d = REG_3,
                  FD_shr = Value) ) %>%
    mutate(Value = FD_shr * Value) %>%
    left_join(., COMM2CHNL %>%
                rename(c = COMM,
                       g = CHNL)) %>%
    left_join(., FDEM2FDCAT %>%
                rename(f = FDEM,
                       t = FDCAT)) %>%
    group_by(n, i, p, g, s, t, d) %>%
    summarize(Value = sum(Value)) %>%
    ungroup() %>%
    select(FPRNT_A = n,
           COMM = i,
           REG = p,
           CHNL = g,
           REG_2 = s,
           FDCAT = t,
           REG_3 = d,
           Value)
} else {
# Assign intermediate input footprints to produced commodities
  MBL_FOOTP_RW <- MBL_FOOTP_RW %>%
    rbind(., MBL_COMM_SHR %>%
            rename(i = COMM,
                   k = COMM_2,
                   a = ACTS,
                   p = REG,
                   COMM_SHR = Value) %>%
            left_join(., MBL_I_FPRINT %>%
                        rename(n = FPRNT_I,
                               a = ACTS,
                               p = REG,
                               FPRINT_I_Value = Value)) %>%
            mutate(Value = COMM_SHR * FPRINT_I_Value) %>%
            group_by(n,i,p) %>%
            select(-k) %>%
            unique() %>%
            summarize(Value = sum(Value)) %>%
            ungroup() %>%
            left_join(. ,
                      MBL_FD_shr %>%
                        rename(
                          i = COMM,
                          p = REG,
                          c = COMM_2,
                          s = REG_2,
                          f = FDEM,
                          d = REG_3,
                          FD_shr = Value) ) %>%
            mutate(Value = FD_shr * Value) %>%
            left_join(., COMM2CHNL %>%
                        rename(c = COMM,
                               g = CHNL)) %>%
            left_join(., FDEM2FDCAT %>%
                        rename(f = FDEM,
                               t = FDCAT)) %>%
            group_by(n, i, p, g, s, t, d) %>%
            summarize(Value = sum(Value)) %>%
            ungroup() %>%
            select(FPRNT_I = n,
                   COMM = i,
                   REG = p,
                   CHNL = g,
                   REG_2 = s,
                   FDCAT = t,
                   REG_3 = d,
                   Value))
}


#MBL_FOOTP_FD(n,i,p,g,s,t,d) #Footprint n of i produced in p by channel g in s and final demand cat t in d#
MBL_FOOTP_FD <- MBL_FOOTP_RW %>%
  rename(n = FPRNT_A,
         i = COMM,
         p = REG,
         g = CHNL,
         s = REG_2,
         t = FDCAT,
         d = REG_3) %>%
  # Apply filter to remove commodities in i with no footprint data
  group_by(i) %>%
  mutate(sum_Value = sum(Value)) %>%
  ungroup() %>%
  filter(sum_Value != 0)

# Define produced commodities with footprint data

#MBL_FPCOMM # Produced commodities with footprint data #
MBL_FPCOMM <- MBL_FOOTP_FD$i %>%
  unique()

# Apply filter to remove commodities in i with no footprint data

# MBL_FOOTP_FD(n,i,p,g,s,t,d) #Footprint n of i produced in p by channel g in s and final demand cat t in d#
MBL_FOOTP_FD <- MBL_FOOTP_FD %>%
  select(FPRNT = n,
         COMM = i,
         REG = p,
         CHNL = g,
         REG_2 = s,
         FDCAT = t,
         REG_3 = d,
         Value)
