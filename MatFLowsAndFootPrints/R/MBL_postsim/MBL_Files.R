#============================================================================
# File      : MBL_Files.r
# Remarks   : Defines logical files names for input data and results
#=============================================================================  

# Files with input data --------------------------------------------------------

# File GTAPSETS # File with set specification #;
GTAPSETS

# File GTAPDATA  # File containing all Base Data #;
GTAPDATA

# File XDATA # File with additional data #;
XDATA

# File ACTDAT # File with data linked to production for footprints #;
ACTDAT

# Files with results -----------------------------------------------------------

#  File (new) MBAL # Regionalized material balances #;
MBAL <- list()

#File (new) FOOTP # Footprint indicators #;
FOOTP <- list()

#File (new) CHEK # File with checks on calcualtions #;  
CHEK <- list()
