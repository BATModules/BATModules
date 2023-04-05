*-------------------------------------------------------------------------------
*
*  @purpose: Link the MIRAGE model to CAPRI supply models. 
*            Runs only with supply models.
*  @seeAlso: pol_input\link_cge\logic.gms
*  @date: 2022-07-26
*  @author: Torbjorn Jansson, SLU
*
*-------------------------------------------------------------------------------


*--------------------------------------------------------------------------------------------------
* --- Market Model (MM, e.g. MIRAGE) specific settings
*--------------------------------------------------------------------------------------------------

*   Location of GDX-file with input data from MM (relative or absolute path)
$set file_MM                pol_input\link_cge\results_mirage_ceta_wp1.gdx

*   GDX symbol containing producer price changes
$set par_priceChgMmTrad     Price_Producer_Change

*   GDX symbol containing endowment price changes
$set par_priceChgMmEndw     Price_Changes

*   GDX symbol containing production quantities (at constant price, for quality check)
$set par_quantMmTrad        Prod_Volume

*   GDX symbol containing production quantity changes (at constant price, for quality check)
$set par_quantChgMmTrad     Prod_Volume_Changes

*   GDX symbol containing the baseline shares of Endowments in Sectors
$set par_endwShareBaseline  Share_Baseline

*   Set containing tradable commodities
$set set_mmTrad             sector_mirage

*   Set containing endowment commodities
$set set_mmEndw             ENDW_COMM_mirage

*   Set containing regions
$set set_mmReg              Countries_mirage

*   Mapping of GTAP to MM tradable sectors
$set map_GTAP_to_mmTrad     Map_i

*   Mapping of GTAP to MM endowments
$set map_GTAP_to_mmEndw     Map_ENDW_COMM

*   Mapping of GTAP to MM regions
$set map_GTAP_to_mmReg      Map_r


*   Define how to read the MM parameters, essentially the order of indices but also unit (e.g. percent)

*   Producer price changes (percent) for outputs and inputs
$macro m_priceChgMmTrad(mmReg,mmTrad)           Price_Producer_Change(mmTrad,mmReg)*100

*   Endowment price changes (percent) 
$macro m_priceChgMmEndw(mmReg,mmEndw,mmTrad)    Price_Changes(mmEndw,mmTrad,mmReg)*100

*   Volumes (constant dollar)
$macro m_quantMmTrad(mmReg,mmTrad)              Prod_Volume(mmTrad,mmReg,"2030","sim")

*   Volume changes (percent)
$macro m_quantChgMmTrad(mmReg,mmTrad)           Prod_Volume_Changes(mmTrad,mmReg,"2030","sim")*100

*   Cost shares of each endowment in each sector in the baseline
$macro m_endwShareBaseline(mmReg,mmEndw,mmTrad) Share_Baseline(mmEndw,mmTrad,mmReg)


*--------------------------------------------------------------------------------------------------
* --- Specify the baseline scenario to which the supply models should have been calibrated
*--------------------------------------------------------------------------------------------------

$set baselineScenario "cap_after_2014\ref.gms"
$setGlobal baselineScenario_underscores "res_2_%BAS%%SIM%cap_after_2014_ref%reg_agg%"

display "Baseline scenario: %baselineScenario_underscores%";

*$stop
*--------------------------------------------------------------------------------------------------
* --- Specify a custom reporting file to be used in this scenario
*--------------------------------------------------------------------------------------------------

$setGlobal customReport "pol_input\link_cge\report.gms"


*--------------------------------------------------------------------------------------------------
* --- Include the logic of the link
*--------------------------------------------------------------------------------------------------

$include "pol_input\link_cge\logic.gms"

*$stop