**************************************************************************
*
*   Author:      undefined
*   Called by:   COM_.gms
*   Created:     27-06-2016 07:54:43
*   Purpose:     Scenario definition file
*
**************************************************************************
*
* User supplied description :
*
* Apply to  TTIP
**************************************************************************
$setglobal SCENDES
*
*  Category : Policy Shocks
*
********************************************************************************
$ontext

   GTAP project

   GAMS file : Tariffs.GMS

   @purpose  : This scenario encompasses (1): full removal of  bilateral tariffs for all commodities betwwen EU and  US ;
              full removal of NTMs  based on expressing the NTMs by AVE, Fixed Cost Equivalents and Dmand raising Equivalents)
   @author   : Wolfgang Britz  and Yaghoob Jafari
   @date     : 02.11.16
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : com_.gms
 the second scenario (B) encompasses
$offtext
********************************************************************************
$iftheni "%inclMode%"=="decl"

*
*
*   --- define which regions, commodities to shock
*       (the onmulti and the kill statement
*        allow to use that construction in several files
*        and to change the regions etc. shocked)
*

$onmulti
    set rShocked(rNat)    ;
     set iShocked (i) /chees_GI-c, chees_noGI-c,Pigmeat_GI-c,Pigmeat_noGI-c, bovMe_GI-c , bovMe_noGI-c , PoulMeat_GI-c, PoulMeat_noGI-c/;
$offmulti

    option kill= rShocked   ;
    option kill= iShocked;
    
    rShocked("CAN")          = YES;
    
    rShocked("FRA")          = YES;
    rShocked("DEU")          = YES;
    rShocked("ITA")          = YES;
    rShocked("ESP")          = YES;
    rShocked("PRT")          = YES;
   
    alias(rshocked,rshocked1)       ;


  iShocked(i) = YES;


  set sectAgg /GIs /;

  set sectAgg_i(sectAgg,i)
                /  GIs  .( chees_GI-c,Pigmeat_GI-c, bovMe_GI-c ,PoulMeat_GI-c, butt_GI-c )/;



  TABLE p_ntmEgg (sectAgg,r)  " AVEs of NTMs reduction from Egger et al.,table 6 , p:559 "
*                              The values for NTMS recution comes from from
*                               Non-tariff barriers, integration and the transatlantic economy

                              FRA        CAN    ITA    DEU    PRT    ESP
                  GIS         10         10     10     10     10     10
                 
             ;

   parameter p_fcCalc(r,i,r,t,*);
   parameter p_demCalc(r,i,r,t,*);

$else
*
*  --------------------------------------------------------------------
*
*     Calculations for all sectors: changes in tariff and export taxes
*
*  --------------------------------------------------------------------

*
*  -- remove any bi-lateral tariffs and export subsidies between EU and US
*
*   imptx.fx(rshocked,iShocked,rShocked1,tsim)  $ (not sameas(rshocked,rshocked1)) = eps;
*

*  --------------------------------------------------------------------
*
*     Calculations for all sectors: trade volumes and comprised
*                                   NTMs
*
*  --------------------------------------------------------------------
*  --- Calculate the trade volume (= export quantity times f.o.b)
*
*   p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalVol") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%") $ (not sameas(rShocked,rShocked1)))
*      = xw.l(rShocked,iShocked,rShocked1,"%t0%") * pefob(rShocked,iShocked,rShocked1,"%t0%");
      
p_fcCalc(rshocked,iShocked,"CAN",tsim,"totalVol") $ (xw.l(rShocked,iShocked,"CAN","%t0%") $ (not sameas(rShocked,"CAN")))
      = xw.l(rShocked,iShocked,"CAN","%t0%") * pefob(rShocked,iShocked,"CAN","%t0%");
*
*  ---  NTMs based on trade volume
*
   p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed") $ (not sameas(rShocked,rShocked1))
      = sum(sectAgg_i(sectAgg,iShocked), p_ntmEgg(sectAgg,rShocked)/100 )
                                           *  p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalVol");

*  --------------------------------------------------------------------
*
*     Calculations for Melitz sectors
*
*  --------------------------------------------------------------------
*$ONTEXT
$iftheni.mel "%modulesGTAP_Melitz%"=="on"

*
*  --- calculate variable costs (=iceberg cost) on each trade link
*
   p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"vCost") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                $ (not sameas(rShocked,rShocked1)))
      = xw.l(rShocked,iShocked,rShocked1,"%t0%")
          * sum(sameas(rShocked1,rrd), p_tau(rShocked,iShocked,rrd,"%t0%")/p_phiFirm0(rShocked,iShocked,rrd,"%t0%"));

*
*  --- assign fixed cost on each trade link
   p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"fCost") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                        $ (not sameas(rShocked,rShocked1)))
      = sum(sameas(rrd,rShocked1), p_fc(rshocked,iShocked,rrd,tsim));

*
* --- a negative share leads to the same relative reduction in variables and fixed cost.
*     1 means: up to 50% reduction in FCost, rest in varaible
*     0 means: 100% to variable cost
*
$set shareFC 1

$ifthene.shareFc %shareFc%<0

   p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"red") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                      $ (not sameas(rShocked,rShocked1)))
     = p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed")/(    p_fcCalc(rshocked,iShocked,rShocked1,tsim,"fCost")
           +  p_fcCalc(rshocked,iShocked,rShocked1,tsim,"vCost"));

  p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"redfc")= p_fcCalc(rshocked,iShocked,rShocked1,tsim,"red");

  p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"redVc") = p_fcCalc(rshocked,iShocked,rShocked1,tsim,"red");

$else.shareFC
*
*  --- distribute share of total cost savings to fixed and variable cost in trade links
*
  p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"redfc") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                      $ (not sameas(rShocked,rShocked1)))
     =  min(p_fcCalc(rshocked,iShocked,rShocked1,tsim,"fCost")*0.5,
             p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed")*%shareFC%)/p_fcCalc(rshocked,iShocked,rShocked1,tsim,"fCost");

   p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"redVc") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                     $ (not sameas(rShocked,rShocked1)))
     = [ p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed")*(1-%shareFC%)
       + max(0, p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed")*%shareFC%
                 - p_fcCalc(rshocked,iShocked,rShocked1,tsim,"fCost")*0.5)]/p_fcCalc(rshocked,iShocked,rShocked1,tsim,"vCost");
$endif.shareFc

   p_fcCalc(rshocked,iMel(iShocked),rShocked1,tsim,"redTest") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                     $ (not sameas(rShocked,rShocked1)))
      =   p_fcCalc(rshocked,iShocked,rShocked1,tsim,"VCost") *  p_fcCalc(rshocked,iShocked,rShocked1,tsim,"redVc")
        + p_fcCalc(rshocked,iShocked,rShocked1,tsim,"FCost") *  p_fcCalc(rshocked,iShocked,rShocked1,tsim,"redFc");



   option p_fcCalc:2:4:1;
   display p_fcCalc;


*  -- remove NTBs by reducing bi-lateral fix and variable cost of trade

   p_fc(rshocked,iMel(iShocked),rrd,tsim) $ sum(sameas(rrd,rShocked1) $  (not sameas(rshocked,rshocked1)),1)
      = sum(sameas(rrd,rShocked1),p_fc(rshocked,iShocked,rrd,tsim) *  (1 - p_fcCalc(rshocked,iShocked,rShocked1,tsim,"redfc")));

   p_tau(rshocked,iMel(iShocked),rrd,tsim) $ sum(sameas(rrd,rShocked1) $  (not sameas(rshocked,rshocked1)),1)
       = sum(sameas(rrd,rShocked1),p_tau(rshocked,iShocked,rrd,tsim) * (1 - p_fcCalc(rshocked,iShocked,rShocked1,tsim,"redVc")));

*  --------------------------------------------------------------------
*
*     Calculations for competitive sectors
*
*  --------------------------------------------------------------------

*
* --- calculates the  equivalent % cost generating impact  of  NTMS on demand
*     and reduces  that  %  by  lowering the armington  shifter

   ishocked(iMel)= NO;

$endif.mel
*
*  --- WB: calculate Armington demand : Bi-lateral quantity * bilateral price*share parameters

   p_demCalc(rshocked,iShocked,rShocked1,tsim,"ArmDemand") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                    $ (not sameas(rShocked,rShocked1)))
      = xw.l(rShocked,iShocked,rShocked1,"%t0%")*pm.l(rShocked,iShocked,rShocked1,"%t0%");


   p_demCalc(rshocked,iShocked,rShocked1,tsim,"red") $ (xw.l(rShocked,iShocked,rShocked1,"%t0%")
                                                                    $ (not sameas(rShocked,rShocked1)))
      = p_fcCalc(rshocked,iShocked,rShocked1,tsim,"totalRed")
       /p_demCalc(rshocked,iShocked,rShocked1,tsim,"ArmDemand");


*
*  -- remove NTBs by reducing preference shifters:
*
   lambdam.fx(rShocked,iShocked,rShocked1,tSim) $ p_demCalc(rshocked,iShocked,rShocked1,tsim,"red")
    = (1 + p_demCalc(rshocked,iShocked,rShocked1,tsim,"red"));

*  abort p_demCalc,p_fcCalc,lambdam.l;
*
*
*
 iShocked(iMel)= YES;
*$OFFTEXT

$endif
