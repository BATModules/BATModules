![BATModel_logoround](/images/BATModel_logo_round_small.png)

# Material flows and footprints

*Modular code for enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by Marijke Kuiper, Thijs de Lange and Willem-Jan van Zeist (Wageningen Economic Research)*

### **Objective**

This module derives consistent regionalized material balances from a standard GTAP v7 style database by stripping taxes and margins from commodity flows. From these material balances the Leontief Inverse matrix is derived which traces produced commodities to final demand through global value chains. Combining the tracing with production characteristics like physical production levels, land use etc. multi-dimenionsal footprints of final demand can be computed.

### **Applicability & incompatibilities**

The code has been structured to work with standard GTAP v7 databases. It consists of three parts:

1.  *MBL_DatabaseAddition*: addition of quantity estimates for the material balances to the model database

2.  *MBL_ModelAddition*: add-on code to update the new data with quantity changes from the model

3.  *MBL_PostSimBalancesAndFootPrints*: check the consistency of material flows, calculation of the Leontief inverse, derivation of footprint estimates based in the direct and indirect flows of commodities

The additions have no impact on model results, variables standard in the GTAP v7 model are used to update the quantity estimates. There are two options for the post-simulation calculations: using GEMPACK or R. For large models an inversion with GEMPACK may take excessive time or even fail. R code is offered as an alternative for the post-simulation calculations as it is better able to handle inversion of large databases.

### **Documentation & code**

For full documentation, including technical details on how to link the module to a target model, consult the [#ADD LINK] in the [BATModel Wiki](https://github.com/BATModules/BATModules/wiki). Code is provided in [GEMPACK](/RemoveSelfTrade/GEMPACK) in both Visual Gtree (*gmp*) and standard GEMPACK (*tab*) file format.

![BATModel_EUacknowledgement](/images/BATModel_EUAcknowledgement_bottom.png)
