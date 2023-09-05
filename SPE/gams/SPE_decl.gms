********************************************************************************
$ontext

   BATMODEL project - transferable SPE module in GAMS

   GAMS file : SPE_decl.GMS

   @purpose  : Declaration of mappings between target model and SPE module
               (with examples for CGEBox and CAPRI)

   @author   : Wolfgang Britz, Torbjoern Jansson
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

$ifi not set targetModel $abort "Targetmodel global not set, SPE module cannot be used."
$ifi not defined MCP acronym MCP;

$iftheni.targetModel "%targetModel%"=="CGEBox"

* ---------------------------------------------------------------------------------------
*
*   mappings and definitions for CGEBox
*
* ---------------------------------------------------------------------------------------
* --- Wolfgang, you might want to qualify this file name with a path and suffix to allow
*     parallel execution. I just took a quess here. Perhaps you already have one? CAPRI has a general one.
$setglobal ERROR_FILE %scrdir%\error.gdx
*
* --- export and import regiogns
*
  alias(speRegExp,speRegImp,rNat);
*
* --- general definitions of products in SPE model (no dynamic set allowed)
*
  alias(spePro,spePro1,i);
*
* --- current products in SPE model
*
  alias(speProCur,iSpe);
*
* --- non-dynamic set for all time points
*
  alias(speT,t);
*
* --- dynamic set for benchmark time point
*
  alias(speT0,t0);
*
* --- dynamic set for current simulation time point
*
  alias(speTCur,ts);
*
* --- dynamic set for all simulation time points
*
  alias(speTSim,tSim);
*
* --- macros for import quantity (index) variables
*
  $$macro m_xmtSpe(speRegImp,spePro,speTCur)       xmt(speRegImp,spePro,SpeTCur)
  $$macro m_xmtSpe_Scale(speRegImp,spePro,speTCur) xmt.scale(speRegImp,spePro,SpeTCur)
*
* --- macros for import price (index) variables
*
  $$setglobal pmtSpe                              pmt
  $$macro m_pmtSpe(speRegImp,spePro,speTCur)       pmt(speRegImp,spePro,SpeTCur)
  $$macro m_pmtSpe_Range(speRegImp,spePro,speTCur) pmt.range(speRegImp,spePro,SpeTCur)
*
* --- macros for bi-lateral import quantity (index)
*
  $$setglobal xwSpe                                        xw
  $$macro m_xwSpe(speRegExp,spePro,speRegImp,speTCur)      xw(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) xw.scale(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_xwSpe_Range(speRegExp,spePro,speRegImp,speTCur) xw.range(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)     xw.l(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_xwSpe_Lo(speRegExp,spePro,speRegImp,speTCur)     xw.lo(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_xwSpe_Up(speRegExp,spePro,speRegImp,speTCur)     xw.up(speRegExp,spePro,speRegImp,SpeTCur)
*
* --- macros for bi-lateral import price at CIF
*
  $$macro m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur)      pmcifPlusTar(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_pmcifPlusTarSpe_lo(speRegExp,spePro,speRegImp,speTCur)   pmcifPlusTar.lo(speRegExp,spePro,speRegImp,SpeTCur)
  $$macro m_pmcifPlusTarSpe_up(speRegExp,spePro,speRegImp,speTCur)   pmcifPlusTar.up(speRegExp,spePro,speRegImp,SpeTCur)
*
* --- this defines the combination of exporter, product, importer in current SPE equations
*
  $$macro m_combSpe(speRegExp,spePro,speRegImp) [xwFlag(speRegExp,spePro,speRegImp) $ rrComb(speRegExp,speRegImp) $ iIn(spePro)]
*
* --- this defines the combination of import regions and product in current SPE equations
*
  $$macro m_hasSpeImp(speRegImp,spePro)  [ (not p_pmtElas(speRegImp,spePro)) $ xmtFlag(speRegImp,spePro) $ rsNat(speRegImp) $ iIn(spePro) ]
*
* --- Variables and equations to be introduced in SPE sub-model for CGEBox,
*     expressions which define c.i.f. plus tariff price and render transport costs a function
*     of traded quantities in CGEBox
*
  variable
     pmCifPlusTar(speRegImp,spePro,speRegExp,speT)      "C.i.f. price plus tariff, used in SPE module"
  ;
  Equations
     e_lambdamg(m,speRegImp,spePro,speRegExp,speT)      "Transport margins by mode are a functon of bi-lateral export quantities"
     e_pmcifPlusTar(speRegImp,spePro,speRegImp,speT)    "Definition of Cif price plus tariff"
  ;

  parameter p_largestXW(speRegExp,spePro)                "Largest observed bi-lateral trade flow for a product, by exporter region";
*
* --- additional equation in SPE module for CGEBox: transport cost update equation, definition of cif + tariff price
*
  $$setglobal trsCstEquSpePaired e_lambdaMg.lambdaMG, e_pmcifPlusTar.pmCifPlusTar

*  --- as per unit transport margins on each flows are endogenous, the definition of the c.i.f. price is more non-linear
*      compared to the standard case. Combined with the (almost) convex wx x pmcif =E= 0 relation, it has turned out that
*      introducing the cif price as a variable helps the solver. Additionally, we need the ad-valorem tariff considered
*
  $$macro m_pmCifPlusTarDef(speRegExp,speProCur,speRegImp,speT0)  %pmCif%(speRegExp,speProCur,speRegImp,speT0) \
                                                                 * [1 + imptx(speRegExp,speProCur,speRegImp,speT0) + mtax(speRegImp,speProCur,speT0)];

  e_pmCifPlusTar(speRegExp,speProCur,speRegImp,speTCur) $ (m_combSpe(speRegExp,speProCur,speRegImp) $ (m_xwSpe_Range(speRegExp,speProCur,speRegImp,speTCur) ne 0)) ..

        pmCifPlusTar(speRegExp,speProCur,speRegImp,speTCur) =E= m_pmCifPlusTarDef(speRegExp,speProCur,speRegImp,speTCur);

*  --- per unit trade margins increase/decrease if trade flow increases/decreases relative to benchmark. Constant p_largestXW
*      prevents (a) a division by zero for non-observed flows allowed to emerge, (b) that emerging flow face extremely
*      large increases in transport cost.
*
  scalar p_splopeTrsCostSpe / 0.25 /;

  e_lambdamg(m,speRegExp,speProCur,speRegImp,speTCur) $ (p_amgm(m,speRegExp,speProCur,speRegImp)
    $ (lambdamg.range(m,speRegExp,speProCur,speRegImp,speTCur) ne 0) $ m_combSpe(speRegExp,speProCur,speRegImp)) ..

     lambdamg(m,speRegExp,speProCur,speRegImp,speTCur) =e=
         1/([ (m_xwSpe(speRegExp,speProCur,speRegImp,speTCur) + p_largestXW(speRegExp,speProCur))
             /(sum(speT0,m_xwSpe_L(speRegExp,speProCur,speRegImp,speT0))  + p_largestXW(speRegExp,speProCur))-1]*p_splopeTrsCostSpe+1);
*
* --- these are macros used in spe/ini_vars to update the transport cost
*
  $$setglobal trsCostIniSpe1 lambdamg(m,speRegExp,speProCur,speRegImp,speTCur) $ (p_amgm(m,speRegExp,speProCur,speRegImp) $ (m_xwSpe_L(speRegExp,speProCur,speRegImp,speTCur) gt 1.E-10)
  $$setglobal trsCostIniSpe2                                                    $ m_combSpe(speRegExp,speProCur,speRegImp))
  $$setglobal trsCostIniSpe3 = sum(m1 $ p_amgm(m1,speRegExp,speProCur,speRegImp), p_amgm(m1,speRegExp,speProCur,speRegImp)*ptmg(m1,speTCur)) * tmarg(speRegExp,speProCur,speRegImp,speTCur)
  $$setglobal trsCostIniSpe4      /(pmcif(speRegExp,speProCur,speRegImp,speTCur) - m_pefob(speRegExp,speProCur,speRegImp,speTCur));
*
* --- update xw accordingly
*
  $$setglobal trsCostIniSpe5 m_xwSpe_L(speRegExp,speProCur,speRegImp,speTCur) $ ((m_xwSpe_L(speRegExp,speProCur,speRegImp,speTCur) gt 1.E-10)
  $$setglobal trsCostIniSpe6                                                    $ m_combSpe(speRegExp,speProCur,speRegImp)
  $$setglobal trsCostIniSpe7                                                    $ sum(m,p_amgm(m,speRegExp,speProCur,speRegImp)))
  $$setglobal trsCostIniSpe8   = max{0,[(1/smax(m,lambdamg(m,speRegExp,speProCur,speRegImp,speTCur)) - 1)/10 + 1]
  $$setglobal trsCostIniSpe9          * (sum(spet0,m_xwSpe_L(speRegExp,speProCur,speRegImp,speT0))+p_largestXW(speRegExp,speProCur)) - p_largestXW(speRegExp,speProCur)};
*
* --- and re-calculate transport cost tech shifter
*
  $$setglobal trsCostIniSpe10 lambdamg(m,speRegExp,speProCur,speRegImp,speTCur) $ (p_amgm(m,speRegExp,speProCur,speRegImp) $ m_combSpe(speRegExp,speProCur,speRegImp))
  $$setglobal trsCostIniSpe11   = 1/([(xw(speRegExp,speProCur,speRegImp,speTCur)+p_largestXW(speRegExp,speProCur))
  $$setglobal trsCostIniSpe12       /(sum(speT0, xw.l(speRegExp,speProCur,speRegImp,speT0))+p_largestXW(speRegExp,speProCur))-1]*p_splopeTrsCostSpe+1);
*
* --- specific for CGEBox pre-solve and solution algorithm
*
  scalar solveLinkOri "Temporary copy during pre-solves";
  scalar solveTypeOri "Temporary copy during pre-solves";

  $$setglobal mcpSolve %modelType%
  $$ifi "%modelType%"=="MCP_after_CNS"   $setglobal mcpSolve MCP

$elseifi.targetModel "%targetModel%"=="CAPRI"

* ---------------------------------------------------------------------------------------
*
*   mappings and definitions for CAPRI
*
* ---------------------------------------------------------------------------------------
* --- File that can contain data to check in case of an error. We already have it in CAPRI.

*$setglobal ERROR_FILE ... is already defined in CAPRI.
*
* --- Regions of the SPE model mapped to the parent model regions
*
  alias(speRegExp,speRegImp,rm);
*
* --- general definitions of products in SPE model (no dynymic set allowed)
*
  alias(spePro,spePro1,xxSpe);
*
* --- Dynamic set of current products, NOT only SPE. Use as $ speProCur(spePro)
*
  alias(speProCur,xxx);

  set spePro_regImp_regExp(xx,speRegImp,speRegExp) Combinations of products and trade flows in SPE model;

* --- All conceivable time periods (domain set)
  alias(speT,simyy_ybas);

* --- First time period in dynamic model
  alias(speT0,onlyCal);

* --- Current time period in dynamic model
  alias(speTCur,onlyCur);

* --- Final time period in dynamic model
  alias(speTSim,onlyCur);
*
* --- macro for import quantity (index) variables
*
  $$macro m_xmtSpe(speRegImp,spePro,speTCur)       v_arm2Quant(speRegImp,spePro)
  $$macro m_xmtSpe_Scale(speRegImp,spePro,speTCur) v_arm2Quant.scale(speRegImp,spePro)
*
* --- macro for import price (index) variables
*
  $$setLocal pmtSpe                                   v_arm2Price
  $$macro m_pmtSpe(speRegImp,spePro,speTCur)       v_arm2Price(speRegImp,spePro)
  $$macro m_pmtSpe_Range(speRegImp,spePro,speTCur) v_arm2Price.range(speRegImp,spePro)
*
* --- macro for bi-lateral import quantity (index)
*
  $$setLocal xwSpe                                             v_tradeFlows
  $$macro m_xwSpe(speRegExp,spePro,speRegImp,speTCur)       v_tradeFlows(speRegImp,speRegExp,spePro)
  $$macro m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) v_tradeFlows.scale(speRegImp,speRegExp,spePro)
  $$macro m_xwSpe_Range(speRegExp,spePro,speRegImp,speTCur) v_tradeFlows.range(speRegImp,speRegExp,spePro)
  $$macro m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)     v_tradeFlows.l(speRegImp,speRegExp,spePro)
  $$macro m_xwSpe_Lo(speRegExp,spePro,speRegImp,speTCur)    v_tradeFlows.lo(speRegImp,speRegExp,spePro)
  $$macro m_xwSpe_Up(speRegExp,spePro,speRegImp,speTCur)    v_tradeFlows.up(speRegImp,speRegExp,spePro)
*
* --- macro for bi-lateral import price, including CIF, tariffs and levies (variable, no expression)
*
  $$macro m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur)      v_impPrice(speRegImp,speRegExp,spePro)
  $$macro m_pmCifPlusTarSpe_lo(speRegExp,spePro,speRegImp,speTCur)   v_impPrice.lo(speRegImp,speRegExp,spePro)
  $$macro m_pmCifPlusTarSpe_up(speRegExp,spePro,speRegImp,speTCur)   v_impPrice.up(speRegImp,speRegExp,spePro)

* --- In CAPRI, I see no use of putting the definition of v_impPrice here? or did I miss something?
  $$macro m_pmCifPlusTarDef(speRegExp,spePro,speRegImp,speT0) \
      sum((RM_TO_RMTP(speRegImp,rmtp),RM1_TO_RMTP(speRegExp,rmtp1)), \
          [v_marketPrice(speRegExp,spePro) + v_transpCost(speRegImp,speRegExp,spePro)  \
          - v_perUnitExportSub(RMtp1,spePro)  $ ( (DATA(RMtp1,"PADM",spePro,"CUR") gt eps) $ (DATA(RMtp1,"FEOE_max",spePro,"CUR") GT eps)  \
                                               $ (NOT p_doubleZero(RMtp,RMtp1,spePro,"CUR") ))] * p_exchgRateChangeFactor(speRegImp,speRegExp)  \
          *  [ 1. + 0.01 * v_tarAdVal(RMTP,RMTP1,spePro) $ ( (NOT  p_doubleZero(RMTP,RMTP1,spePro,"CUR")) $ (NOT SAMEAS(RMTP,RMTP1)))]          \
          +  [   v_tarSpec(RMTP,RMTP1,spePro)   $ ((DATA(RMTP,"MinBordP",spePro,"CUR") LE eps) or (p_trqBilat(RMTP,RMTP1,spePro,"TrqNT","CUR") eq prohibitive) ) \
              +  v_flexLevy(RMTP,RMTP1,spePro)  $ ((DATA(RMtp,"MinBordP",spePro,"CUR") GT eps) $  (p_trqBilat(RMtp,RMtp1,spePro,"TrqNT","CUR") ne prohibitive) ) \
              ] $ [ (NOT p_doubleZero(RMTP,RMTP1,spePro,"CUR")) $ (not same_pblock(speRegImp,speRegExp))])

*
* --- Define the combination of exporter, product, importer in current SPE equations
*
  $$macro m_combSpe(speRegExp,spePro,speRegImp) [spePro_regImp_regExp(spePro,speRegImp,speRegExp)]
*  $$macro m_combSpe(speRegExp,spePro,speRegImp) [speProCur(spePro) and v_tradeFlows.range(speRegImp,speRegExp,spePro) and (not sameas(speRegImp,speRegExp))]
*
* --- Define the condition for allowing imports to a region speRegImp of a commodity spePro
*
  $$macro m_hasSpeImp(speRegImp,spePro)  [xxx(spePro) and sum(speRegExp $ (not sameas(speRegExp,speRegImp)), v_tradeFlows.range(speRegImp,speRegExp,spePro))]

* --- This line should go to the parent model later.
  scalar solveType /%solveType%/;

* --- Model-specific trade cost formulation
  Equations
     e_transpCost(speRegImp,speRegExp,spePro)      "Definition of trade cost"
     e_arm1QuantSpe(speRegImp,spePro)                 "Definition of imports plus domestic supply, paired with v_arm1Price"
     e_marketPriceSpe(speRegImp,spePro)               "Definition of market price equilibrium, paired with v_domSales"
     e_arm2PriceSpe(speRegImp,spePro)                 "Definition of import price equilibrium, paired with v_arm2Quant"
  ;

  parameter p_transpCostConst(speRegImp,speRegExp,spePro) "Constant of linear trade cost function";
  parameter p_transpCostSlope(speRegImp,speRegExp,spePro) "Slope of linear trade cost function";
  parameter p_speMarketPriceCal(speRegImp,spePro) "Calibration of ratio v_marketPrice/v_arm1price";
  parameter p_speArm2PriceCal(speRegImp,spePro) "Calibration of ratio v_arm2Price/v_arm1price";

  $$setglobal trsCstEquSpePaired e_transpCost.v_transpCost
*
*  --- per unit trade margins increase/decrease if trade flow increases/decreases relative to benchmark. Constant p_largestXW
*      prevents (a) a division by zero for non-observed flows allowed to emerge, (b) that emerging flow face extremely
*      large increases in transport cost.
*

  e_transpCost(speRegImp,speRegExp,spePro) $ [m_combSpe(speRegExp,spePro,speRegImp) $ speProCur(spePro)]..
    v_transpCost(speRegImp,speRegExp,spePro) =e=
        p_transpCostConst(speRegImp,speRegExp,spePro)
      + p_transpCostSlope(speRegImp,speRegExp,spePro) * v_tradeFlows(speRegImp,speRegExp,spePro);


* --- Adding up of imports and domestic production to total demand.
*
*      paired with v_arm1Price
*
  e_arm1QuantSpe(speRegImp,spePro) $ [v_arm1Price.range(speRegImp,spePro) $ speProCur(spePro)]..

       v_arm1Quant(speRegImp,spePro)
*     / (DATA(speRegImp,"Arm1",spePro,"CUR")+ 1)

       =E= (v_domSales(speRegImp,spePro)  $ DATA(speRegImp,"DSales",spePro,"CUR")
           +v_arm2Quant(speRegImp,spePro) $ DATA(speRegImp,"Arm2",spePro,"CUR")   )
*     / (DATA(speRegImp,"Arm1",spePro,"CUR") * 0.001 + 1)
     ;

* Law of one price: supply price equals demand price. Only if there are domestic sales, hence "paired" with v_domSales
* Replaces an Armington share-equation
  e_marketPriceSpe(speRegImp,spePro) $ [v_domSales.range(speRegImp,spePro) $ speProCur(spePro)] ..
      v_marketPrice(speRegImp,spePro)*p_speMarketPriceCal(speRegImp,spePro) =E= v_arm1Price(speRegImp,spePro);
  
* Law of one price: import price equals demand price. Only if there are imports, hence "paired" with v_arm2Quant
* Replaces an Armington share-equation
  e_arm2PriceSpe(speRegImp,spePro) $ [v_arm2Quant.range(speRegImp,spePro) $ speProCur(spePro)] .. 
      v_arm2Price(speRegImp,spePro)*p_speArm2PriceCal(speRegImp,spePro) =E= v_arm1Price(speRegImp,spePro);

  $$set trsCstEquSpePaired e_transpCost.v_transpCost, e_arm1QuantSpe.v_arm1Price, e_marketPriceSpe.v_domSales, e_arm2PriceSpe.v_arm2Quant
  $$set trsCstEquSpeUnPaired e_transpCost, e_arm1QuantSpe, e_marketPriceSpe, e_arm2PriceSpe

* Point to a parent-model variable to minimize in case the penalty function method is used. LHS of e_spePF (complementarity gap)
  $$setGlobal spePF v_penalty

$endif.targetModel



* -----------------------------------------------------------------------------
*  Check interface for completeness
*  (here we should put in tests for setting all things that need setting above)
* -----------------------------------------------------------------------------

* --- A file name and path for unloading data in tests is needed
$if not set ERROR_FILE $abort "ERROR: interface needs to define a setglobal ERROR_FILE with a path and file name that can contain error data."



* --------------------------------------------------------------------------------------------------------------------------------------
*
*   Module equations. Uses macros for variables also found in the target model
*
* --------------------------------------------------------------------------------------------------------------------------------------

  Equations
     e_xwSpe(speRegImp,spePro,speRegImp,speT)           "Spatial arbitrage definition in FOC, import prices are equal for active trade flows"
     e_pmtSpe(speRegImp,spePro,speT)                    "Import price paired with adding up over trade flows"
     e_xwSpeSlack(speRegImp,spePro,speRegImp,speT)      "FOC from SPE: xw x (c.i.f. + tariff) =E= 0, used with CNS or NLP solver"
   ;

  $$iftheni.smoothingFunction "%smoothingFunctionSpe%"=="Multref"
     positive variable
  $$else.smoothingFunction
     variable
  $$endif.smoothingFunction

     xwSpeSlack(speRegExp,spePro,speRegImp,speT)         "Slack in spatial arbitrage condition, only used with 'manual' MCP solve"
  $$ifi "%smoothingFunctionSpe%"=="penaltyFunction" speGap(speRegExp,spePro,speRegImp,speT) "Complementarity gap as free variable. Use with Penalty function only.";
  ;

   parameter p_speCal(speRegExp,spePro,speRegImp,speT)   "Terms which aligns import prices at benchmark"
             p_xmtScaleSpe(speRegImp,spePro)             "Scaler which ensure physical exhaustion of imports at benchmark"
             p_speProblem4D(speRegExp,spePro,speRegImp,speT) "Errors encountered, 4 dims. Should always be empty."
   ;

   scalar muSpe "Fudging error in orthogonality condition" / 1.E-%muSpe% /;
   scalar deltaSpe "Another smoothing parameter in the complementary slackness condition." /1.E-16/;
   scalar p_speLockPenalty "Flag to lock the penalty function to make the model square with fixed complementarity gap" /0/;
*
*  --- spatial arbitrage condition: trade flows can only be non-zero if cif price is equal to import price.
*      If the "manual" MCP solution method is used (speMultRef), an explicite slack is introduced
*
   e_xwSpe(speRegExp,spePro,speRegImp,speTCur) $ [ m_combSpe(speRegExp,spePro,speRegImp)
                                                      $ (m_xwSpe_Range(speRegExp,spePro,speRegImp,speTCur) ne 0)
                                                      $ speProCur(spePro)] ..

        m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur)
          * p_speCal(speRegExp,spePro,speRegImp,speTCur)
*
*         --- if the model is not solved by an MCP solver, the slack is handled by the e_xwSpeSlack
*
          - xwSpeSlack(speRegExp,spePro,speRegImp,speTCur)  $ (solveType ne MCP)
            =E= m_pmtSpe(speRegImp,spePro,speTCur);
*
*  --- market clearance for imports, defines average import price
*
   e_pmtSpe(speRegImp,spePro,speTCur) $ [ (m_pmtSpe_Range(speRegImp,spePro,SpeTCur) ne 0) 
                                             $ m_hasSpeImp(speRegImp,spePro)
                                             $ speProCur(spePro)] ..

      m_xmtSpe(speRegImp,spePro,speTCur)*p_xmtScaleSpe(speRegImp,spePro)
      /m_xmtSpe_Scale(speRegImp,spePro,speTCur)
        =E=
      sum(speRegExp $ m_combSpe(speRegExp,spePro,speRegImp), m_xwSpe(speRegExp,spePro,speRegImp,speTCur))
      /m_xmtSpe_Scale(speRegImp,spePro,speTCur);

*
*  --- Complementary slackness condition from spatial arbitrage: xw * xwSpeSlack = 0.
*      To improve numerical stability, this is slightly differently implemented.
*
   e_xwSpeSlack(speRegExp,spePro,speRegImp,speTCur) $ [m_combSpe(speRegExp,spePro,speRegImp) $ (solveType ne MCP)
                                                           $ (m_xwSpe_Range(speRegExp,spePro,speRegImp,speTCur) ne 0)
                                                           $ speProCur(spePro)] ..

    $$iftheni.smoothingFunction "%smoothingFunctionSpe%"=="multRef"
*
*      --- manual implementation of r * s = 0, with fudging term of 1.E-16 (deltaSpe) to yield non-zero derivatives at r=0 or s=0
*          and scaling factor for trade flows. RHS defines the fixed fudging error at the benchmark
*
        (xwSpeSlack(speRegExp,spePro,speRegImp,speTCur) - deltaSpe)
           *(m_xwSpe(speRegExp,spePro,speRegImp,speTCur)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) - deltaSpe)
             =E= sum(spet0,(xwSpeSlack.l(speRegExp,spePro,speRegImp,spet0) - deltaSpe)
                    *(m_xwSpe_L(speRegExp,spePro,speRegImp,spet0)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) - deltaSpe));


    $$elseifi.smoothingFunction "%smoothingFunctionSpe%"=="penaltyFunction"
    
*  This version of the complementary slackness condition is intended for use with a penalty function.
*  Note that this makes the model non-square because of the free speGap variable.
        (xwSpeSlack(speRegExp,spePro,speRegImp,speTCur) - deltaSpe)
         *(m_xwSpe(speRegExp,spePro,speRegImp,speTCur)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) - deltaSpe)
        
        =E= speGap(speRegExp,spePro,speRegImp,speTCur);

*   ... which comes here. The penalty function is the sum of squared complementarity gaps.
*   Include in parent model objective to minimize.
        variable spePF "Penalty for violating complementary slackness in SPE";
        equation e_spePF "Penalty function for violations of complementary slackness in SPE";
        e_spePF ..
        
         %spePF% =E= sum((speRegExp,spePro,speRegImp,speTCur) $ [ m_combSpe(speRegExp,spePro,speRegImp)
                                                                 $ (m_xwSpe_Range(speRegExp,spePro,speRegImp,speTCur) ne 0)
                                                                 $ speProCur(spePro)],
       
*                    Work in progress. Here, we should actually deviate from some small number depending on deltaSpe                                                            
                     sqr(speGap(speRegExp,spePro,speRegImp,speTCur)));


    $$else.smoothingFunction
*
*      --- inbuilt smoothing functions for f(r,s) = 0 if r or s is zero
*          RHS defines the fixed fudging error at the benchmark which is removed in the simulation point
*          (the functions are not defined to work well to recover a condition such as f(r,s) = 1.E-5)
*
          sum(spet0, %smoothingFunctionSpe%(xwSpeSlack.l(speRegExp,spePro,speRegImp,speT0),
              m_xwSpe_L(speRegExp,spePro,speRegImp,speT0)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur),muSpe)) $ sum(sameas(spet0,spetCur),1)
               =E= %smoothingFunctionSpe%(xwSpeSlack(speRegExp,spePro,speRegImp,speTCur),
                                        m_xwSpe(speRegExp,spePro,speRegImp,speTCur)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur),muSpe);

    $$endif.smoothingFunction

        
                

  model m_spe /
*
*    --- global provided by target model for additional equations provided by target model
*        to update transport costs (or other variables) in the context of the SPE model
*
     %trsCstEquSpePaired%
     e_xwSpeSlack.xwSpeSlack
     e_xwSpe.%xwSpe%
     e_pmtSpe.%pmtSpe%
     $$ifi "%smoothingFunctionSpe%"=="penaltyFunction" e_spePF.%spePF%
  /;

  model m_speUnpaired "The same model as m_spe but without variable pairing" /
*
*    --- global provided by target model for additional equations provided by target model
*        to update transport costs (or other variables) in the context of the SPE model
*
     %trsCstEquSpeUnPaired%
     e_xwSpeSlack
     e_xwSpe
     e_pmtSpe
     $$ifi "%smoothingFunctionSpe%"=="penaltyFunction" e_spePF
  /;
