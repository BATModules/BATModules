#============================================================================
# File      : MBL_InvertLeontief.r
# Remarks   : Compute the Leontief inverse matrix
#=============================================================================

# Region Create matrix of technical coefficients 

# MBL_s_IO_q(i,s,c,d) #IO coeff.(qtity): use of i from region s when producing comm. c in region d#;
MBL_s_IO_q <- MBL_s_I_q %>%
  rename(i = COMM,
         s = REG,
         c = COMM_2,
         d = REG_2,
         s_I_q = Value) %>%
  left_join(.,
            MBL_Q_q %>%
              rename(c = COMM,
                     d = REG,
                     Q_q = Value)) %>%
  mutate(Value = s_I_q / Q_q) %>%
  select(COMM = i,
         REG = s,
         COMM_2 = c,
         REG_2 = d,
         Value)

#make commreg, combination of comm and reg to make matrix with.:
comregmap <-
  MBL_Q_q %>% 
  select(-Value) %>% 
  mutate(COMREG = paste(COMM, REG, sep = "_"))

comregmap2 <- rename(comregmap,
                     COMREG_2 = COMREG,
                     REG_2 = REG,
                     COMM_2 = COMM)

comreg <- comregmap$COMREG

#Map technical coefficients into 2-dimensopnal matrix for inversion
MBL_s_IO_q_2 <- MBL_s_IO_q %>%
  left_join(., 
            comregmap) %>% 
  left_join(.,
            comregmap2) %>% 
  select(-COMM, 
         -COMM_2, 
         -REG, 
         -REG_2)

MBL_IO <- expand_grid(COMREG = comreg, 
                      COMREG_2 = comreg)

MBL_IO <- MBL_IO %>%
  left_join(.,
            MBL_s_IO_q_2) %>% 
  mutate(Value = ifelse(is.nan(Value), 0, Value)) %>%
  mutate(COMREG = factor(COMREG, 
                         levels = comreg)) # to ensure order

MBL_IO <-  spread(MBL_IO, 
                  COMREG_2, 
                  Value) %>% 
  select(all_of(comreg)) # the select ensure order of columns


# Initialize maximum deviation from identity matrix as check on inversion -----------

#MBL_IMDIFmax # Maximum (absolute) deviation from identity matrix #;
MBL_IMDIFmax <- XDATA$DMAX

# MBL_IM(i,k) # Identity matrix #; 
MBL_IM <-
  diag(length(comreg)) 

#MBL_I_IO(i,j) # Identity - IO matrix that needs to be inverted #;
MBL_I_IO <- MBL_IM - MBL_IO


# Variables & equation ----------------------------------------------------------------

# MBL_L(j,k) # Inverse Leontief matrix #; 
MBL_L <- solve(MBL_I_IO)
# Identical to Equation E_MBL_L in GEMPACK code

MBL_L <- array(
  as.vector(MBL_L),
  #put the right names in again after solve
  dim = c(length(comreg), length(comreg)),
  dimnames = list(COMREG = comreg, COMREG_2 = comreg)
)

# converse converted to 'long' format'
MBL_L_long_comreg <- melt(MBL_L) %>%
  rename(Value = value)

rownames(MBL_I_IO) <- comreg

MBL_I_IO <- MBL_I_IO %>%
  tibble::rownames_to_column(., "COMREG") %>%
  pivot_longer(cols = comreg, names_to = "COMREG_2", values_to = "Value")


# Post-simulation checks

# MBL_CHK_INV(i,k) # Check on Leontief inversion - should be close to identity matrix#;
MBL_CHK_INV <-  MBL_I_IO %>%
  rename(i = COMREG,
         j = COMREG_2,
         I_IO = Value) %>%
  left_join(., 
            MBL_L_long_comreg %>%
              rename(j = COMREG,
                     k = COMREG_2,
                     L = Value)) %>%
  mutate(Value = I_IO * L) %>%
  group_by(i, k) %>%
  summarize(Value = sum(Value)) %>%
  ungroup() %>%
  select(COMREG = i,
         COMREG_2 = k,
         Value)

# Define assertion to generate error in case of faulty inversion

rownames(MBL_IM) <- comreg
colnames(MBL_IM) <- comreg


#MBL_IM_DIF # Difference from identity matrix #;
MBL_IM_DIF <- MBL_CHK_INV  %>%
  rename(i = COMREG,
         k = COMREG_2,
         CHK_INV = Value) %>%
  left_join(., 
            MBL_IM %>%
              melt() %>%
              rename(i = Var1,
                     k = Var2,
                     L = value)) %>%
  mutate(Value = CHK_INV - L) %>%
  summarize(Value = sum(Value))

if (MBL_IM_DIF$Value < MBL_IMDIFmax$Value){
  print("Good job!") } else { print("Arbitrary boundary - meant as warning to carefully check results")}

