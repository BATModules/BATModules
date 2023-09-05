**** ========================== BATMODEL MODULE CAPRI/MIRAGE WP1T2
**** This program computes shares and variations for MIRAGE variables that will be used as exogenous variables in CAPRI

$ontext
Some information
It is run after a complete MIRAGE session, i.e. calibration/replication/baseline(s)/simulation(s)/results
Names of the variables are SkLab (Skilled Labor), UnSkLab (Unskilled Labor), Lan, Capital, NatRes (Natural Resources), CNTER (Intermediate Consumption)
PX means Price of variable X
MIRAGE has 5 productions factors and intermediate consumption :   SkLab, UnSkLab, Land, Capital, NatlRes and CNTER
(Main) Sets in MIRAGE are : i (sectors), r or s (countries), t (time), sim (baseline or simulation)  
The share of each of those component is computed (CAPRI does not have the same production function)
The results are computed for year "2030"
$offtext

* Give the name to the gdx file that will be exported [in MIRAGE, this name is given in a master file that calls all MIRAGE files using EXECUTE commands]
$if not set mm_inputs $set export_name "TO_BE_LABELLED"

* ======== Definition of sets if needed [in MIRAGE, those sets are already defined elsewhere ; same thing for countries and sectors sets]
*$ontext
Set ENDW_COMM_GTAP FactorsIC /
tech_aspros
clerks
service_shop
off_mgr_pros
ag_othlowsk
Land
Capital
NatlRes
CNTER
/;

Set ENDW_COMM_MIRAGE FactorsIC /
SkLab
UnSkLab
Land
Capital
NatlRes
CNTER
/;

Set Map_ENDW_COMM Map_GATP_MIRAGE /
tech_aspros.SkLab
clerks.UnSkLab
service_shop.UnSkLab
off_mgr_pros.SkLab
ag_othlowsk.UnSkLab
Land.Land
Capital.Capital
NatlRes.NatlRes
CNTER.CNTER
/;
*$offtext

* ======== Computation of Shares

PARAMETERS
Share_Capital(i,r,Temps,Simul)          Share of Capital in production
Share_SkLab (i,r,Temps,Simul)           Share of Skilled Labor in production
Share_UnSkLab(i,r,Temps,Simul)          Share of Unskilled Labor in production
Share_Land(i,r,Temps,Simul)             Share of Land in production
Share_NatlRes(i,r,Temps,Simul)          Share of Natural Resources in production
Share_CInter(i,r,Temps,Simul)           Share of Intermediate Consumption in production
Share_Baseline(ENDW_COMM_MIRAGE,i,r)    Share of factors in the baseline (refstep2)

Price_Changes(ENDW_COMM_MIRAGE,i,r)     Changes in prices
Price_Producer_Change(i,r)              Changes in Producer prices

Prod_Volume_Changes(i,r,Temps,Simul)    Production in volumes
Prod_Volume(i,r,Temps,Simul)            Changes in the production in volumes

Diff(i,r,Temps,Simul)            Logical test: Computation of the difference in value between production (PY*Y) and its components (must be 0)
Check(i,r,Temps,Simul)           Logical test: Computation of the total of the shares (must be 100)
;

Share_Capital(i,r,t,sim)         = [(PCapital.l(i,r,t,sim)*Capital.l(i,r,t,sim))/scale/1000]     /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];
Share_SkLab(i,r,t,sim)           = [(PSkL.l(i,r,t,sim)*SkL.l(i,r,t,sim))/scale/1000]             /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];
Share_UnSkLab(i,r,t,sim)         = [(PUnSkL.l(i,r,t,sim)*UnSkL.l(i,r,t,sim))/scale/1000]         /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];
Share_Land(i,r,t,sim)            = [(PLand.l(i,r,t,sim)*Land.l(i,r,t,sim))/scale/1000]           /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];
Share_NatlRes(i,r,t,sim)         = [(PNatRes.l(i,r,t,sim)*NatRes.l(i,r,t,sim))/scale/1000]       /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];
Share_CInter(i,r,t,sim)          = [(PCNTER.l(i,r,t,sim)*CNTER.l(i,r,t,sim))/scale/1000]         /  [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000];

* ======== Orginal shares in the baseline
Share_Baseline("Capital",i,r)    =  Share_Capital(i,r,"2030","RefStep2");
Share_Baseline("SkLab",i,r)      =  Share_SkLab(i,r,"2030","RefStep2");
Share_Baseline("UnSkLab",i,r)    =  Share_UnSkLab(i,r,"2030","RefStep2");
Share_Baseline("Land",i,r)       =  Share_Land(i,r,"2030","RefStep2");
Share_Baseline("NatlRes",i,r)    =  Share_NatlRes(i,r,"2030","RefStep2");
Share_Baseline("CNTER",i,r)      =  Share_CInter(i,r,"2030","RefStep2");

* ======== Percentage changes in prices 
Price_Changes("Capital",i,r)     =  [PCapital.l(i,r,"2030","sim") - PCapital.l(i,r,"2030","RefStep2")]/PCapital.l(i,r,"2030","RefStep2");
Price_Changes("SkLab",i,r)       =  [PSkL.l(i,r,"2030","sim") - PSkL.l(i,r,"2030","RefStep2")]/PSkL.l(i,r,"2030","RefStep2");
Price_Changes("UnSkLab",i,r)     =  [PUnSkL.l(i,r,"2030","sim") - PUnSkL.l(i,r,"2030","RefStep2")]/PUnSkL.l(i,r,"2030","RefStep2");
Price_Changes("Land",i,r)        =  [PLand.l(i,r,"2030","sim") - PLand.l(i,r,"2030","RefStep2")]/PLand.l(i,r,"2030","RefStep2");
Price_Changes("NatlRes",i,r)     =  [PNatRes.l(i,r,"2030","sim") - PNatRes.l(i,r,"2030","RefStep2")]/PNatRes.l(i,r,"2030","RefStep2");
Price_Changes("CNTER",i,r)       =  [PCNTER.l(i,r,"2030","sim") - PCNTER.l(i,r,"2030","RefStep2")]/PCNTER.l(i,r,"2030","RefStep2");
Price_Producer_Change(i,r)       =  [PY.l(i,r,"2030","sim") - PY.l(i,r,"2030","RefStep2")]/PY.l(i,r,"2030","RefStep2");


* ======== Production (baseline & simulation) & Variation of Production [YTVol is computed in the results.gms file in MIRAGE. It is the production in volumes]
*YTVol(i,r,t,sim) = PY.l(i,r,"%Tini%",ref_prices)*(sum(s,DEM.l(i,r,s,t,Sim))+D.l(i,r,t,Sim))
*                   *YtoVol.l(i,r,t,sim)
*                   /scale/1000;

Prod_Volume(i,r,"2030",Simul) =    YTVol(i,r,"2030",Simul);
Prod_Volume_Changes(i,r,"2030","sim") =    [YTVol(i,r,"2030","sim") - YTVol(i,r,"2030","RefStep2")]/YTVol(i,r,"2030","RefStep2");

* ======== Imported sets [creation of alias of sets already created elsewhere in MIRAGE. They are not necessary, they simply ease the use of this file]
alias(GPROD_COMM,Sector_GTAP); 	! GTAP sectors
alias(i,Sector_MIRAGE);		! MIRAGE sectors (i.e. GTAP sectors aggregated to MIRAGE aggregation)
alias(GREG,Countries_GTAP);	! GTAP countries 
alias(r,Countries_MIRAGE);	! MIRAGE countries (i.e. GTAP sectors aggregated to MIRAGE aggregation)



* ======== Consistency Checks

Diff(i,r,t,sim) =    [(PY.l(i,r,t,sim)*Y.l(i,r,t,sim))/scale/1000]
                     - [PUnSkL.l(i,r,t,sim)*UnSkL.l(i,r,t,sim)
                     + PSkL.l(i,r,t,sim)*SkL.l(i,r,t,sim)
                     + PCapital.l(i,r,t,sim)*Capital.l(i,r,t,sim)
                     + PNatRes.l(i,r,t,sim)*NatRes.l(i,r,t,sim)
                     + PLand.l(i,r,t,sim)*Land.l(i,r,t,sim)
                     + PCNTER.l(i,r,t,sim)*CNTER.l(i,r,t,sim)]/scale/1000;

Check(i,r,t,sim) =            Share_Capital(i,r,t,sim)
                           +  Share_SkLab(i,r,t,sim)
                           +  Share_UnSkLab(i,r,t,sim)
                           +  Share_Land(i,r,t,sim)
                           +  Share_NatlRes(i,r,t,sim)
                           +  Share_CInter(i,r,t,sim) ;



execute_unload ".\GDX\%mm_inputs%.gdx" Price_Changes, Share_Baseline, map_i, map_r, map_ENDW_COMM, Price_Producer_Change, Sector_GTAP, Sector_MIRAGE, Countries_MIRAGE, ENDW_COMM_GTAP,ENDW_COMM_MIRAGE, Countries_GTAP, Prod_Volume_Changes, Prod_Volume

