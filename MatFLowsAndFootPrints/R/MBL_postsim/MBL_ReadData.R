#============================================================================
#  File      : Corresponds to file MBL_ReadData.r
#  Remarks   : Read data holding quantities
#=============================================================================

# Make matrix (for value shares) ---------------------------------------------

# 'make' matrix valued at basic prices #;
MAKEB <- GTAPDATA$MAKB  

# Production -----------------------------------------------------------------

# Quantity produced of c by activity a in r (mil USD) #;
MBL_PROD_q <- GTAPDATA$PQ_Q 

# Domestic demand ------------------------------------------------------------

# Intermediates
# Quantity domestic intermediate demand for c by a in s (mil USD)#;
MBL_d_INT_q  <- GTAPDATA$DA_Q

# Final demand, private household
# Quantity domestic final private household demand for c in r (mil USD)#;
MBL_d_FINP_q <- GTAPDATA$DP_Q

# Final demand, government
# Quantity domestic final government demand for c in r (mil USD)#;
MBL_d_FING_q <- GTAPDATA$DG_Q

# Final demand, investments
# Quantity domestic final investment demand for c in r (mil USD)#;
MBL_d_FINI_q <- GTAPDATA$DI_Q

# Trade -----------------------------------------------------------------------

# Quantity of c exported from r to d (mil USD) #;
MBL_TRADE_q <- GTAPDATA$TR_Q

# Import demand ----------------------------------------------------------------

# Intermediates
# Quantity imported intermediate demand for c by a in d (mil USD)#;
MBL_m_INT_q <- GTAPDATA$MA_Q

# Final demand, private household
# Quantity imported private household demand for c in d (mil USD)#;
MBL_m_FINP_q <- GTAPDATA$MP_Q

# Final demand, government
# Quantity imported government demand for c in d (mil USD)#;
MBL_m_FING_q <- GTAPDATA$MG_Q

# Final demand, investments
# Quantity imported investment demand for c in d (mil USD)#;
MBL_m_FINI_q <- GTAPDATA$MI_Q

# Transport margin supply and demand -------------------------------------------

# Supply of margin commodities to global transport pool
# Quantity int'l margin m supplied to global pool by r (mil USD)#;
MBL_TRANSS_q <- GTAPDATA$TS_Q

# Demand for margin commodities from global transport pool
# Quantity int'l margin demanded for imports of c in d from r (mil USD) #;
MBL_TRANSD_q <- GTAPDATA$TD_Q
