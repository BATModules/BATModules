todo: insert BATmodel logo

# Remove self trade from aggregated GTAP regions
*Modular enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by:*
### Marijke Kuiper (Wageningen Economic Research)
 &nbsp;

### **Objective**
The standard GTAP data aggregation procedure joins  regional endowments while keeping within-region trade separate. This is conceptually inconsistent and complicates analysis of trade impacts as well as tracing direct and indirect impacts through global value chains. The self-trade removal module can be included in the data preparation process moving self-trade that appears when aggregating countries or regions to domestic supply. The resulting database will have zero trade within model regions, simplifying international trade analysis to trade between model regions. 

### **Applicability & incompatibilities**
The code can be used as is on any GTAP derived aggregated database using the GTAP model V7 nomenclature in case of GEMPACK based programs. It will affect model behaviour through databased changes for models using the standard GTAP two-layer Armington whereby domestic commodities  have a lower elasticity of substitution with a composite imported commodity (ESUBD) than the used for the upper nest where commodities from different regional sources are substituted (ESUBM). The self-trade adjustments moves part of the domestic commodities that where consumed domestically through self-trade from the upper to the lower nest thus lowering the effective ease of substitution between domestic and imported commodities. Furthermore trade taxes, domestic sales taxes and transport margins are adjusted in the process which may also affect model behaviour, especially in the case of trade policy simulations.

### **Documentation & code**
Full documentation including how to link the module to a target model is provided in the documentation.\doc\[todo:insert file]. Code is provided in GEMPACK in .\code\gp
todo: can we add hyperlinks to folders for quick access?
