![BATModel_logoround](/images/BATModel_logo_round_small.png)

# Global Value Chains

*Modular code for enhancement of trade analysis with simulation models in GAMS or GEMPACK developed by David Cui (Wageningen Economic Research)*

### **Objective**

The purpose of creating this module is to enable a flexible switch
between the GTAP-GVC model and the standard GTAP model. With a
switchable module, modellers can attach this module to other GTAP-based
CGE models (e.g., MAGNET) and use this module to gain insights into the
results at the MRIO level and compare these results with the results
derived from the standard GTAP version.

### **Applicability & incompatibilities**

The GVC module is created based on the GTAPv7-MRIO model. The code for
this module consists of two parts:

1\. Inseparable statements placed in model core

This part mainly deals with coefficients used both in the standard model
and in the GVC module but these coefficients have different formulas
when used in the two different model versions. In this case, the
statements for these coefficients become inseparable and thus should be
put together in the model core with the module switch controlled by the
activation parameter or a region set.

2\. Separable statements placed respectively in model core and in GVC
module

The second part of the code deals with statements that are separable
between the two model versions as these statements are used either in
the standard model or in the GVC module. The statements related to the
GVC module can thus be put together as a real/physical module and placed
at the end of the TABLO file or in a separate TABLO file. The second
part can also be detached from the model core if the GVC module is
switched off.

Modellers should be aware that when the GVC module is switched on, the
model's results will be affected to some extent since the Armington
trade structure will be replaced by the MRIO trade structure.

### **Documentation & code**

For full documentation, including technical details on how to link the module to a target model, consult the [BATModel Wiki](https://github.com/BATModules/BATModules/wiki). Code is provided in [GEMPACK](/GLobalValueChains/GEMPACK) in both Visual Gtree (*gmp*) and standard GEMPACK (*tab*) file format.

![BATModel_EUacknowledgement](/images/BATModel_EUAcknowledgement_bottom.png)
