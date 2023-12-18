# ============================================================================
# File      : MBL_WriteCoefficients.r
# Remarks   : Write computed coefficients to file
# ============================================================================
  
# Material balance components ------------------------------------------------
MBAL$Q_q <- magnetr:::magnet_prepdf_for_write_har(
  MBL_Q_q, list(COMM = COMM$Value, 
                 REG = REG$Value))

MBAL$SI_q <- magnetr:::magnet_prepdf_for_write_har(
  MBL_s_I_q, list(COMM = COMM$Value, 
                 REG = REG$Value, 
                 COMM_2 = COMM$Value,
                 REG_2 = REG$Value))

MBAL$SFPQ <- magnetr:::magnet_prepdf_for_write_har(
  MBL_s_FP_q, list(COMM = COMM$Value, 
                  REG = REG$Value, 
                  REG_2 = REG$Value))

MBAL$SFGQ <- magnetr:::magnet_prepdf_for_write_har(
  MBL_s_FG_q, list(COMM = COMM$Value, 
                  REG = REG$Value, 
                  REG_2 = REG$Value))

MBAL$SFIQ <- magnetr:::magnet_prepdf_for_write_har(
  MBL_s_FI_q, list(COMM = COMM$Value, 
                  REG = REG$Value, 
                  REG_2 = REG$Value))



#  Slack on material balance written to check file ---------------------------
CHEK$SLCK <- magnetr:::magnet_prepdf_for_write_har(
  MBL_SLACK_p, list(COMM = COMM$Value, 
                  REG = REG$Value))

# Check on matrix inversion written to check file ----------------------------
CHEK$CHKI <- magnetr:::magnet_prepdf_for_write_har(
  MBL_CHK_INV, list(COMREG = comreg, 
                    COMREG_2 = comreg))

#  Production shares ---------------------------------------------------------
FOOTP$LI <- magnetr:::magnet_prepdf_for_write_har(
  MBL_LI, list(COMM = COMM$Value,
               REG = REG$Value,
               COMM_2 = COMM$Value,
               REG_2 = REG$Value))

FOOTP$FD_S <- magnetr:::magnet_prepdf_for_write_har(
  MBL_FD_shr, list(COMM = COMM$Value,
               REG = REG$Value,
               COMM_2 = COMM$Value,
               REG_2 = REG$Value,
               FDEM = FDEM$Value,
               REG_3 = REG$Value))

CHEK$CQFD <- magnetr:::magnet_prepdf_for_write_har(
  MBL_chk_FDq, list(COMM = COMM$Value,
                   REG = REG$Value))


# Write footprints -----------------------------------------------------------
FOOTP$FPFD <- magnetr:::magnet_prepdf_for_write_har(
  MBL_FOOTP_FD, list(FPRNT = FPRNT$Value,
                     COMM = COMM$Value,
                     REG = REG$Value,
                     CHNL = CHNL$Value,
                     REG_2 = REG$Value,
                     FDCAT = FDCAT$Value,
                     REG_3 = REG$Value))