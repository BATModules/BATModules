![BATModel_logoround](/images/BATModel_logo_round_small.png)

# Armington with Commitment terms

*Modular code for enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by Wolfgang Britz (University of Bonn)*

### **Objective**

This modules provides an Armington with Commitment term (SPE) trade extension for global CGE models in GAMS. The module is written so that the same code should be usable in several GAMS models, and therefore to be set and data driven, steered by e.g. the user interface. It enables to overcome the small shares stay small problem of standard CES trade representations.

### **Applicability & incompatibilities**

The code has been structured to work with standard and extended GTAP databases. 

It can be selected for single products and while it can be run in parallel with other trade models available on this repository, different products have to be chosen per trade extension. 


### **Documentation & code**

For full documentation, including technical details on how to link the module to a target model, consult the [BATModel Wiki](https://github.com/BATModules/BATModules/wiki). Add-on code for target models is provided in GAMS file format. 

![BATModel_EUacknowledgement](/images/BATModel_EUAcknowledgement_bottom.png)
