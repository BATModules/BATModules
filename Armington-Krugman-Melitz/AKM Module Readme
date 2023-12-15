
# **Armington-Krugman-Melitz Module for GTAPv7**

*Modular enhancement of trade analysis with simulation models in GAMS or
GEMPACK developed by David Cui (Wageningen Economic Research)*

### **Objective**

The purposes of creating this module are three-fold: 1) to prepare the
firm heterogeneity model developed by Bekkers & Francois (2018) in a
modular fashion so users can attach this module to a GTAP or GTAP-based
CGE model and switch between Armington, Ethier-Krugman, and Melitz trade
mechanisms as chosen by the user; 2) to update Bekkers & Francois'
original model code and make it compatible with the GTAP v7 model; and
3) to add extra indicators accounting for the productivity of the
representative firm and product quality perceived on the demand side, as
shown in Jafari, Engemann, and Heckelei (2023).

### **Applicability & incompatibilities**

The module is created based on the firm heterogeneity model developed by
Bekkers & Francois (2018), with their original code being largely
reflected in this module. The main differences between this module and
Bekkers & Francois original code include:

1.  Compared to their original model where the code related to the
    Melitz module is scattered around the model, this module puts
    together all the related code as a flexible and standalone module so
    that users can conveniently attach and switch on/off this module to
    a GTAP or GTAP-based CGE model.
2.  This module includes a number of updates compared to their original
    code to reflect the updated GTAP v7 nomenclature and modelling
    approaches. These updates include modified sets, coefficients, and
    variables to make them compatible with GTAP v7 names, and modified
    equations to reflect the new modelling approaches in GTAP v7, for
    example, for the investment goods.
3.  New indicators to capture the productivity of the representative
    firm and product quality perceived on the demand side, derived from
    Jafari et al. (2023) and Dixon et al. (2016), are added in the
    module.

Modellers should be aware that when the AKM module is switched on, the
model results will be affected to some extent since the trade structure
will be different when different mechanisms/parameters are chosen.

This module is incompatible with GTAP v6 or earlier versions.

### **Documentation & code**

For full documentation, including technical details on how to link the
module to a target model, consult the [BATModel
Wiki](https://github.com/BATModules/BATModules/wiki). Code is provided
in
[GEMPACK](https://github.com/BATModules/BATModules/blob/main/GLobalValueChains/GEMPACK)
in both Visual Gtree (*gmp*) and standard GEMPACK (*tab*) file format.

