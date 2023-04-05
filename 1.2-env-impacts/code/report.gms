$onText
   @purpose: Report items from the link with a cge market model
   @author: T. Jansson

$offText


*  Report some quantities of the linked CGE model, to compare with corresponding CAPRI results
*  CGE models typically deliver percentage change, not absolute values.
*  We try to write both variants here, under "Absolute" for absolute and "PercentageChange" for change vs baseline
DATAOUT(rall,"mmAbsolute",cols,rows,"%SIMY%")
   = p_mmReport(rall,cols,rows,"Absolute");
   
DATAOUT(rall,"mmChangeFactor",cols,rows,"%SIMY%")
   = p_mmReport(rall,cols,rows,"ChangeFactor");

   
set mmCompareModel "Set of models to compare" /capri,mm,ratio_capri_mm,colour "Index of goodness"/;
set mmModel(mmCompareModel) "Models to compare" /capri,mm/;
set mmCompareScen "Set of scenarios to compare" /CAL,SIM,ChangeFactor,PercentChange/;
parameter p_mmCompareQuant(RALL,ROWS,mmCompareScen,mmCompareModel) "Percentage quantity change vs baseline in both CAPRI and the linked model";
parameter p_mmComparePrice(RALL,ROWS,mmCompareScen,mmCompareModel) "Percentage price change vs baseline in both CAPRI and the linked model";


* --- MM: Collect quantity change indicators from the report parameter done in "logic.gms"
p_mmCompareQuant(rmssup,rows,"CAL","mm")
   $ p_mmReport(rmssup,"GROF",rows,"ChangeFactor")
   = p_mmReport(rmssup,"GROF",rows,"Absolute")/p_mmReport(rmssup,"GROF",rows,"ChangeFactor");
   
p_mmCompareQuant(rmssup,rows,"SIM","mm")
   = p_mmReport(rmssup,"GROF",rows,"Absolute");

p_mmCompareQuant(rmssup,rows,"ChangeFactor","mm")
   = p_mmReport(rmssup,"GROF",rows,"ChangeFactor");

p_mmCompareQuant(rmssup,rows,"PercentChange","mm")
   = p_mmReport(rmssup,"GROF",rows,"PercentChange");
   
p_mmComparePrice(rmssup,rows,"CAL","mm")
   $ p_mmReport(rmssup,"UVAG",rows,"ChangeFactor")
   = p_mmReport(rmssup,"UVAG",rows,"Absolute")/p_mmReport(rmssup,"UVAG",rows,"ChangeFactor");
   
p_mmComparePrice(rmssup,rows,"SIM","mm")
   = p_mmReport(rmssup,"UVAG",rows,"Absolute");

p_mmComparePrice(rmssup,rows,"ChangeFactor","mm")
   = p_mmReport(rmssup,"UVAG",rows,"ChangeFactor");

p_mmComparePrice(rmssup,rows,"PercentChange","mm")
   = p_mmReport(rmssup,"UVAG",rows,"PercentChange");



* --- CAPRI: The relevant info from the Market Model is the change factor, since quantities are typically
*     monetary and not physical in CGE. To compare with those factors, we need to load a baseline
*     for CAPRI to compare with. That baseline is pointed out in the policy file.

execute_load "%results_in%\capmod\%baselineScenario_underscores%.gdx" p_DataOutTemp=DATAOUT;

p_mmCompareQuant(rmssup,rows,"CAL","capri")
   $ p_mmCompareQuant(rmssup,rows,"CAL","mm")
   = p_DataOutTemp(rmssup,"","GROF",rows,"%simy%");
   
p_mmCompareQuant(rmssup,rows,"SIM","capri")
   $ p_mmCompareQuant(rmssup,rows,"SIM","mm")
   = DATAOUT(rmssup,"","GROF",rows,"%simy%");

p_mmCompareQuant(rmssup,rows,"ChangeFactor","capri")
   $ p_mmCompareQuant(rmssup,rows,"CAL","capri")
   = p_mmCompareQuant(rmssup,rows,"SIM","capri")
   / p_mmCompareQuant(rmssup,rows,"CAL","capri");   

p_mmCompareQuant(rmssup,rows,"PercentChange","capri")
   $ p_mmCompareQuant(rmssup,rows,"CAL","capri")
   = (p_mmCompareQuant(rmssup,rows,"SIM","capri") - p_mmCompareQuant(rmssup,rows,"CAL","capri"))
   / p_mmCompareQuant(rmssup,rows,"CAL","capri") * 100;


p_mmComparePrice(rmssup,rows,"CAL","capri")
   $ p_mmComparePrice(rmssup,rows,"CAL","mm")
   = p_DataOutTemp(rmssup,"","UVAG",rows,"%simy%");
   
p_mmComparePrice(rmssup,rows,"SIM","capri")
   $ p_mmComparePrice(rmssup,rows,"SIM","mm")
   = DATAOUT(rmssup,"","UVAG",rows,"%simy%");

p_mmComparePrice(rmssup,rows,"ChangeFactor","capri")
   $ p_mmComparePrice(rmssup,rows,"CAL","capri")
   = p_mmComparePrice(rmssup,rows,"SIM","capri")
   / p_mmComparePrice(rmssup,rows,"CAL","capri");   

p_mmComparePrice(rmssup,rows,"PercentChange","capri")
   $ p_mmComparePrice(rmssup,rows,"CAL","capri")
   = (p_mmComparePrice(rmssup,rows,"SIM","capri") - p_mmComparePrice(rmssup,rows,"CAL","capri"))
   / p_mmComparePrice(rmssup,rows,"CAL","capri") * 100;


* --- Compute ratios between model indicators that can be of interest to somebody?
   
p_mmCompareQuant(rmssup,rows,mmCompareScen,"ratio_capri_mm")
   $ p_mmCompareQuant(rmssup,rows,mmCompareScen,"mm")
   = p_mmCompareQuant(rmssup,rows,mmCompareScen,"capri")
   / p_mmCompareQuant(rmssup,rows,mmCompareScen,"mm");
   
p_mmCompareQuant(rmssup,rows,mmCompareScen,"colour")
   $ [p_mmCompareQuant(rmssup,rows,mmCompareScen,"ratio_capri_mm") lt 0]
   = -1;
   
p_mmCompareQuant(rmssup,rows,mmCompareScen,"colour")
   $ [p_mmCompareQuant(rmssup,rows,mmCompareScen,"ratio_capri_mm") gt 0]
   = abs(log10(p_mmCompareQuant(rmssup,rows,mmCompareScen,"ratio_capri_mm")))+1;


p_mmComparePrice(rmssup,rows,mmCompareScen,"ratio_capri_mm")
   $ p_mmComparePrice(rmssup,rows,mmCompareScen,"mm")
   = p_mmComparePrice(rmssup,rows,mmCompareScen,"capri")
   / p_mmComparePrice(rmssup,rows,mmCompareScen,"mm");
   
p_mmComparePrice(rmssup,rows,mmCompareScen,"colour")
   $ [p_mmComparePrice(rmssup,rows,mmCompareScen,"ratio_capri_mm") lt 0]
   = -1;
   
p_mmComparePrice(rmssup,rows,mmCompareScen,"colour")
   $ [p_mmComparePrice(rmssup,rows,mmCompareScen,"ratio_capri_mm") gt 0]
   = abs(log10(p_mmComparePrice(rmssup,rows,mmCompareScen,"ratio_capri_mm")))+1;


* --- Compute the "traffic light index" that goes from negative (bad) to positive (good)

$set fn %results_out%\capmod\res_mm_%result_type_underscores%
set myDims "Dimensions in a result table" /region,product,resultMeasure,modelComparison,value/;

execute_unload "%fn%.gdx" p_mmCompareQuant p_mmComparePrice p_mmReport myDims;

execute "copy /Y pol_input\link_cge\res_template.xlsx %fn%.xlsx";
execute "gdxxrw i=%fn%.gdx o=%fn%.xlsx set=myDims rng=quantities!A1 rdim=0 cdim=1 par=p_mmCompareQuant rng=quantities!A2 rdim=4 cdim=0 set=myDims rng=prices!A1 rdim=0 cdim=1 par=p_mmComparePrice rng=prices!A2 rdim=4 cdim=0"


option kill = p_dataOutTemp;