# About

This module provides a top-down link from a GTAP-based CGE model to CAPRI. The CGE model provides price changes and CAPRI computes environmental regional environmental impacts.


# Requirements

The module is under development, and only available in the CAPRI branch of BATModel:
https://svn1.agp.uni-bonn.de/svn/capri/branches/batmodel
The commodity set in the GTAP data base is derived from GTAP version 10


# Installation instructions

## In CAPRI
For linking with MIRAGE, no adjustment is needed - the interface is implemented in the file mirage.gms, which is the policy file to use in simulation. For other models, copy the mirage.gms file and fill it with the symbols produced by that model's CAPRI interface. 

## In the CGE model
You need to implement code that delivers the interface. One such GAMS file is provided already for MIRAGE, yet to be implemented for other models.

# Technical documentation
See the BATModules [wiki](https://github.com/BATModules/BATModules/wiki/Module-1.2-Regional-Environmental-Impacts).
