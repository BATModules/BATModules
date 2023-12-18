#============================================================================
# File      : MBL_SetsMaps.r
# Remarks   : Standard GTAP sets + new sets used in post-sim calculations
#=============================================================================

# Standard GTAP sets ----------------------------------------------------------

# Set REG # Regions in the model
REG <- GTAPSETS$REG

# Set COMM # Traded commodities (including split sectors) #
COMM <- GTAPSETS$COMM

# Set MARG # margin commodities #
MARG <- GTAPSETS$MARG
# Subset MARG is subset of COMM;

# Set ACTS # Sectors producing traded commodities #
ACTS <- GTAPSETS$ACTS
# Subset ACTS is subset of COMM;


# Additional sets and mappings for footprints -------------------------------

# Set FDEM # Final demand categories # (phh,gvt,inv);
Value <- c("phh", "gvt", "inv")
FDEM <- data.frame(Value)
# Set FPRNT_A # Footprint indicators at activity level #
FPRNT_A <- ACTDAT$SFPA
# Set FPRNT_I # Footprint indicators at intermediate level #
FPRNT_I <- ACTDAT$SFPI
# Set FPRNT # Set of footprint indicators # = FPRNT_A + FPRNT_I;
FPRNT <- rbind(FPRNT_A, FPRNT_I)

# note that + enforces sets to be disjoint - so footprints are eiher defined at
# activity or at intermediate input level 

# Set CHNL # Channels through which products flow to final demand #
CHNL <- ACTDAT$MC2C
# Mapping COMM2CHNL from COMM to CHNL
COMM2CHNL <- data.frame(ACTDAT$MC2C %>%
                          rename(CHNL = Value),
                        COMM %>%
                          rename(COMM = Value))

# Set FDCAT # Grouping of final demand categories #
FDCAT <- ACTDAT$FDCT
# Mapping FDEM2FDCAT from FDEM to FDCAT
FDEM2FDCAT <- data.frame(ACTDAT$MD2F %>%
                           rename(FDCAT = Value),
                         FDEM %>%
                           rename(FDEM = Value))



