![BATModel_logoround](https://github.com/BATModules/BATModules/blob/main/images/BATModel_logo_round.png) 
# Remove self-trade from aggregated GTAP regions
*Modular code for enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by Marijke Kuiper (Wageningen Economic Research)*

### **Objective**
The standard GTAP data aggregation procedure joins regional endowments while keeping within-region trade separate. This is conceptually inconsistent and complicates analysis of trade impacts as well as tracing direct and indirect impacts through global value chains. The self-trade removal module can be included in the data preparation process moving self-trade that appears when aggregating countries or regions to domestic supply. The resulting database will have zero trade within model regions, simplifying international trade analysis to trade between model regions. 

### **Applicability & incompatibilities**
The code can be used as is on any GTAP derived aggregated database using the GTAP model V7 nomenclature in case of GEMPACK based programs. It will affect model behaviour as the database changes for models using the standard GTAP two-layer Armington with default parameters. In this specification domestic commodities have a lower elasticity of substitution with a composite imported commodity (ESUBD) than the elasticity used for the upper nest where commodities from different regional sources are substituted (ESUBM). The self-trade adjustments moves part of the domestic output that was consumed domestically through self-trade from the upper to the lower nest, thus lowering the effective ease of substitution between domestic and imported commodities. Furthermore trade taxes, domestic sales taxes and transport margins are adjusted in the data adjustment process which may also affect model behaviour, especially in the case of trade policy simulations.

### **Documentation & code**
Full documentation including how to link the module to a target model is provided in the BATModel wiki page 
[RST Module - Remove self-trade from database](https://github.com/BATModules/BATModules/wiki/RST-Module-%E2%80%90-Remove-self%E2%80%90trade-from-aggregated-GTAP-regions). Code is provided in [GEMPACK](https://github.com/BATModules/BATModules/tree/main/RemoveSelfTrade/GEMPACK) in both Visual Gtree (*.gmp) and standard GEMPACK (*.tab) format.

![BATModel_EUacknowledgement](https://user-images.githubusercontent.com/125276497/218486555-c0780914-fe2a-4fcf-9fe3-6da53eb8c6ca.png)
