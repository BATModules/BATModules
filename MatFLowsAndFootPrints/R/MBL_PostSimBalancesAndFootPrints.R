# === Regionalized material balances and footprint data from a GTAP database ====

# == PURPOSE
# Derives regionalized material balances tracing production from producers to
# final destinations. These first of all serve as a check on the
# reference year or projected quantities in case of updated databases. 

# The second purpose is to provide data suitable for use in a Leontief inverse 
# calculation of direct and indirect flows through global supply chains. The 
# Leontief inverse is used to compute the shares of commodity i produced in region
# p in final demand by households, government and investment in
# region d cosnumed through commodities c produced in region s. Multiplication of
# these shares with characterisics of product i from p (like production in
# phsyical units or land use) provides a consistent tracing of materials or other
# footrpints of production through global supplyc chains to final demand. 

# == USE
# Provide a cmf file that links the logical file names in this code (GTAPSETS
# and GTAPDATA) to files containing standard GTAPagg headers (v7 
# nomenclature). in addition to the standard GTAP-style inputs extra data need
# to be provided to (1) split activity in case of joint ptoduction (optional - if
# not provided value-based shares are used) and (2) the maximum deviation of the
# computed Leontief inverse.

# Output is split over different files as matrices can be very large in
# full-fledge models. Material balance entries are stored in the MBAL file and
# data needed to compute footprints in the FOOTP file. Checks are stored in a separte
# CHEK file. 

# == WARNING
# In case of a nearly singular matrix the Leontief inversion may fail. This can
# be detected by checking the product of the orginal and inverted matrix, which
# should equal the identity matrix. A check is imposed through an assertion
# forcing an error if there is too much deviation from the identity matrix. 


# == ACKNOWLEDGMENT
# The code for inverting the Leontief matrix is an adaption of GEMPACK code for
# matrix inversion provdided by COPS at https://www.copsmodels.com/gp-inv2.htm. 

# == VERSION
# Version 1.0 (August 2023)

# == CONTACT 
# Marijke Kuiper (marijke.kuiper@wur.nl)

# == Logical file names for input data & output of results
  source("2_Code/MBL_postsim/MBL_Files.r")
  
# == Sets and mappings
  source("2_Code/MBL_postsim/MBL_SetsMaps.r")
  
# == Read headers with quantities
  source("2_Code/MBL_postsim/MBL_ReadData.r")
  
# == Construct regoinalized material balances
  source("2_Code/MBL_postsim/MBL_ConstructBalances.r")
  
# == Derive Leontief inverse
  source("2_Code/MBL_postsim/MBL_InvertLeontief.r")
  
# As we solve a model to derive Leontief all subsequent calculations are
# post-sim

# == Derive production shares in final demand
  source("2_Code/MBL_postsim/MBL_ProductionShares.r")
  
# == Compute footprint indicators
  source("2_Code/MBL_postsim/MBL_Footprints.r")
  
# == Write coefficients
  source("2_Code/MBL_postsim/MBL_WriteCoefficients.r")
  