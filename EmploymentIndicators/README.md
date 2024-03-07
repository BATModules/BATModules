![BATModel_logoround](/images/BATModel_logo_round_small.png)

# Employment inidicators

*Modular code for enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by Marijke Kuiper (Wageningen Economic Research)*

### **Objective**

This modules provides an extension for global CGE models to provide additional detail on employment and labour income distribution indicators (real wages per worker, poverty headcount measures, poverty gap indices and Palma ratio).

### **Applicability & incompatibilities**

The code has been structured to work with standard GTAP v7 databases. It consists of two parts:

1.  *EMP_LabourForceVariables*: add-on code to update the labour force data with quantity changes from the target model.

2.  *Employment_indicators*: R code for post-simulation calculation of indicators. 

The additions have no impact on model results unless the model closure is adjusted (see the documentation for details). Variables standard in the GTAP v7 model are used to update the quantity estimates. The documentation also provides information on potential datasources in GTAP compatible format.

### **Documentation & code**

For full documentation, including technical details on how to link the module to a target model, consult the [#ADD LINK] in the [BATModel Wiki](https://github.com/BATModules/BATModules/wiki). Add-on code for target models  is provided in both Visual Gtree (*gmp*) and standard GEMPACK (*tab*) file format. Post-simulation code is in R.

![BATModel_EUacknowledgement](/images/BATModel_EUAcknowledgement_bottom.png)