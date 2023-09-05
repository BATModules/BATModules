********************************************************************************
$ontext

   CGEBox project

   GAMS file : SPE_CAL.GMS

   @purpose  : calibration of spatial equilibrium model
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : cal/cal.gms

$offtext
********************************************************************************

$iftheni.targetModel "%targetmodel%"=="CGEBox"


   $$ifthen.mrio defined mrio_sel

      if ( sum(i $ (mrio_sel(i) and spe_sel(i)),1),
        display "Warning: product at the same time in the MRIO and in the SPE module, removed from MRIO",
           spe_sel,mrio_sel;
      );

      iMrio(i) $ spe_Sel(i) = No;

   $$endif.mrio
   $$ifthen.melitz defined iMel_sel

      if ( sum(i $ (iMel_sel(i) and spe_sel(i)),1),
        abort "A product cannot be at the same time in the Melitz and SPE module",
           iMel_sel,spe_sel;
      );
   $$endif.melitz
   $$ifthen.armLesCES defined arm_les_ces_pro_sel

      if ( sum(i $ (arm_les_ces_pro_sel(i) and spe_sel(i)),1),
        abort "A product cannot be at the same time in the ARM_LES_CES and SPE module",
           arm_les_ces_pro_sel,spe_sel;
      );
   $$endif.armLESCES

*
   iSpe(i) $ spe_sel(i) = YES;
   iIn(i)  = yes;
   speProCur(iSpe) = YES;

   $$iftheni.ACET "%SPENonLinear%"=="Additive CET"
*
*     ---- CET can only be calirbated to observed flows (functional form excludes real zero)
*
      iACET(speProCur) = YES;
      p_omegaw(rnat,speProCur)    = 20;
      p_omegax(rnat,speProCur)    = 20;

   $$else.ACET
*
*      --- The second option render the transport margin depending on  the size of the flow
*          this also works with zero observed flows. For such missing trade flows, we
*          use the average transport marings etc. for the observed flows of the exporter
*          New flows require at east one observed export flow with transport costs to provide estimates
*          for new flows, and that imports of the product has been observed

      set hasExports(rnat,i);
      hasExports(rnat,speProCur) $ xet.l(rNat,speProCur,"%t0%")
        = yes $ sum(rNat1 $ (not sameas(rnat,rnat1)), xwmg.l(rnat,speProCur,rnat1,"%t0%"));

      xmarg0(m,hasExports(rnat,speProCur),rNat1)    $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1)) $ sum(rpNat $ xmarg0(m,rNat,speProCur,rPNat),1)]     = sum(rpNat, xmarg0(m,rNat,speProCur,rPNat))/sum(rpNat $ xmarg0(m,rNat,speProCur,rPNat),1);
      xmgm.l(m,hasExports(rnat,speProCur),rNat1,t0) $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1)) $ sum(rpNat $ xmgm.l(m,rNat,speProCur,rPNat,t0),1)]  = sum(rpNat, xmgm.l(m,rNat,speProCur,rPNat,t0))/sum(rpNat $ xmgm.l(m,rNat,speProCur,rPNat,t0),1);
      xwmg.l(hasExports(rnat,speProCur),rNat1,t0)   $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = sum(rpNat, xwmg.l(rNat,speProCur,rPNat,t0))/sum(rpNat $ xwmg.l(rNat,speProCur,rPNat,t0),1);
      tmarg.l(hasExports(rnat,speProCur),rNat1,t0)  $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = sum(rpNat, tmarg.l(rNat,speProCur,rpNat,t0))/sum(rpNat $  tmarg.l(rNat,speProCur,rpNat,t0),1);
      pwmg.l(hasExports(rnat,speProCur),rNat1,t0)   $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = sum(rpNat, pwmg.l(rNat,speProCur,rpNat,t0))/sum(rpNat $   pwmg.l(rNat,speProCur,rpNat,t0),1);
      pe.l(hasExports(rnat,speProCur),rNat1,t0)     $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = ps.l(rNat,speProCur,t0);
      pefob.l(hasExports(rnat,speProCur),rNat1,t0)  $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = (1 + exptx.l(rNat,speProCur,rNat1,t0))*ps.l(rNat,speProCur,t0);
      pmCIF.l(hasExports(rnat,speProCur),rNat1,t0)  $ [(not xwFlag(rNat,speProCur,rNat1)) $ xmtFlag(rnat1,speProCur) $ (not sameas(rNat,rNat1))  ]     = (pefob.l(rNat,speProCur,rNat1,t0)/lcu0(rNat) + pwmg.l(rNat,speProCur,rNat1,t0)*tmarg.l(rNat,speProCur,rNat1,t0))*lcu0(rNat1);
*
*     --- determine largest observed bi-lateral flow
*
      p_largestXW(rnat,speProCur) $ (hasExports(rNat,speProCur) $ xmtFlag(rnat,speProCur))
        = max[  smax( (rnat1) $ (not sameas(rnat,rnat1)), xw.l(rnat,speProCur,rnat1,"%t0%")) + 0.01*xs.l(rnat,speProCur,"%t0%"),
                smax( (rnat1) $ (not sameas(rnat,rnat1)), xw.l(rnat1,speProCur,rnat,"%t0%"))];
*
*     --- set flag which triggers inclusion of flow in model equations
*
      xwFlag(hasExports(rnat,speProCur),rNat1) $ ((not sameas(rNat,rNat1)) $ xmtFlag(rnat1,speProCur)) = 1;
*
*     --- introduce non-linearities for changes in cif prices on each flow by rendering per unit transport margins
*         depending on transported ammounts
*
      lambdamg.l(m,speRegExp,speProCur,speRegImp,speT0)  $ (p_amgm(m,speRegExp,speProCur,speRegImp)   $ m_combSpe(speRegExp,speProCur,speRegImp)) = 1;
      lambdamg.lo(m,speRegExp,speProCur,speRegImp,speT0) $ (p_amgm(m,speRegExp,speProCur,speRegImp)   $ m_combSpe(speRegExp,speProCur,speRegImp)) = -inf;
      lambdamg.up(m,speRegExp,speProCur,speRegImp,speT0) $ (p_amgm(m,speRegExp,speProCur,speRegImp)   $ m_combSpe(speRegExp,speProCur,speRegImp)) = +inf;
*
   $$endif.ACET

   pmCifPlusTar(speRegExp,speProCur,speRegImp,speT0) = %pmCif%(speRegExp,speProCur,speRegImp,speT0)
                                                                 * [1 + imptx(speRegExp,speProCur,speRegImp,speT0) + mtax(speRegImp,speProCur,speT0)];


$elseifi.targetModel "%targetmodel%"=="CAPRI"

*  --- Define which product-flow combinaions are permissible. This should trickle down into all equations
*      and other assignments via the m_combSpe macro, where it is part (see spe_decl.gms)

   spePro_regImp_regExp(spePro,speRegImp,speRegExp)
      = yes $ [
*              There is demand in the importing market      
               DATA(speRegImp,"Arm1",spePro,"CUR")
*              There is production in the exporting market
               and DATA(speRegExp,"PROD",spePro,"CUR")
*              The importer and the exporter are not the same region               
               and (not sameas(speRegImp,speRegExp))];



   parameter p_speTranspCost(speRegImp,speRegExp,spePro) "Transportation costs estimated for SPE model";

*  Existing estimates from GLOBAL database build
   p_speTranspCost(speRegImp,speRegExp,spePro) = p_transpCost(speRegImp,speRegExp,spePro,"CAL");

*  If missing, simply use price diff from producer to target market, but at least 1.0
   p_speTranspCost(speRegImp,speRegExp,spePro) $ [(not p_speTranspCost(speRegImp,speRegExp,spePro))
                                                  and m_combSpe(speRegExp,spePro,speRegImp)]
      = max(1.0, DATA(speRegImp,"arm1p",spePro,"CAL")-DATA(speRegExp,"ppri",spePro,"CAL"));


* --- Calibrate parameters of the trade cost function
$ontext
   tc_est = tc_m + tc_k*x_obs
   
   assume something about how fast tc increases
      tc_k = tc_est/(x_obs/2 + 100)

   solve for tc_m
      tc_m = tc_est - tc_k*x_obs
$offtext

   p_transpCostSlope(speRegImp,speRegExp,spePro)
      = p_speTranspCost(speRegImp,speRegExp,spePro)
      / (100 + p_tradeFlows(speRegImp,speRegExp,spePro,"CAL")/2);

   p_transpCostConst(speRegImp,speRegExp,spePro)
      = p_speTranspCost(speRegImp,speRegExp,spePro)
      - p_transpCostSlope(speRegImp,speRegExp,spePro)*p_tradeFlows(speRegImp,speRegExp,spePro,"CAL");
   
* --- Assert that all permissible flows also have an associated trade cost

   errorItems3D(speRegImp,speRegExp,spePro) = yes $ [m_combSpe(speRegExp,spePro,speRegImp)
                                          and (not p_transpCostSlope(speRegImp,speRegExp,spePro))];
   if(card(errorItems3D),
*      p_errorData4D()
      execute_unload "%ERROR_FILE%" errorItems3D p_tradeFlows p_transpCost spePro_regImp_regExp;
      abort "ERROR in %system.FN%: Some permissible trade link has no associated trade cost", errorItems3D ;
   );

* --- Initialize transportation cost for macro below to function
   v_transpCost(speRegImp,speRegExp,spePro) = p_speTranspCost(speRegImp,speRegExp,spePro);

* --- Import prices might be missing for unobserved trade flows. Compute them now.
   p_impPrice(speRegImp,speRegExp,spePro,"CAL") $ [m_combSpe(speRegExp,spePro,speRegImp)
                                                   $ (not p_tradeFlows(speRegImp,speRegExp,spePro,"CAL"))]
   = m_pmCifPlusTarDef(speRegExp,spePro,speRegImp,speT0);


*[v_marketPrice(speRegExp,spePro)  \
*                                                               + v_transpCost(speRegImp,speRegExp,spePro)  \
*   + sum(RM_TO_RMTP(speRegExp,rmtp1), v_perUnitExportSub(RMtp1,spePro))] \
*   * (1 + 0.01*v_tarAdval.l(speRegImp,speRegExp,spePro)) + v_tarSpec.l(speRegImp,speRegExp,spePro); 


   v_impPrice.L(speRegImp,speRegExp,spePro) $ [m_combSpe(speRegExp,spePro,speRegImp)
                                                   $ (not p_tradeFlows(speRegImp,speRegExp,spePro,"CAL"))]
   = p_impPrice(speRegImp,speRegExp,spePro,"CAL");


* --- Our calibration point may not satisfy the "law of one price", because the market model
*     calibration assumes that Armington share equations can be calibrated to any price ratio.
*     With SPE, we have to calibrate the relations of arm1price to arm2price and marketPrice.
*     We deliberately do not check for division by zero, to catch missing-price-errors

   p_speMarketPriceCal(speRegImp,spePro) $ v_domSales.range(speRegImp,spePro)
      = v_arm1Price(speRegImp,spePro) / v_marketPrice(speRegImp,spePro);
      
   p_speArm2PriceCal(speRegImp,spePro) $ v_arm2Quant.range(speRegImp,spePro)
      = v_arm1Price(speRegImp,spePro) / v_arm2Price(speRegImp,spePro);


$endif.targetmodel

*  --- Assert that there is an import price (m_pmCifPlusTarSpe)
*      for each permissible trade flow (m_combSpe)
   p_speProblem4D(speRegExp,spePro,speRegImp,speT0) $ m_combSpe(speRegExp,spePro,speRegImp)
   = 1 $ [not m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speT0)];
   
   if(card(p_speProblem4D),
      Display "Oh, no! Import price is missing in calibration even though we want to allow a trade flow!";
      execute_unload "%ERROR_FILE%";
      abort "Error in %system.fn%. Import price is missing for some permissible trade flow. Data unloaded to %ERROR_FILE%.", p_speProblem4D;
   );

*
*  --- Define multiplier to calibrate zero arbitrage condition in benchmark (all permissible flows)
*
   p_speCal(speRegExp,spePro,speRegImp,speT0) $ m_combSpe(speRegExp,spePro,speRegImp)
     = m_pmtSpe(speRegImp,spePro,speT0)
        /(m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speT0));
*
*  --- for non-observed flows, assume that c.i.f. price is 50% higher than c.i.f. derived from
*      estimated c.i.f. 
*
   p_speCal(speRegExp,spePro,speRegImp,speT0) $ [(not m_xwSpe_L(speRegExp,spePro,speRegImp,speT0))
                                                   $ m_combSpe(speRegExp,spePro,speRegImp)]
      = p_speCal(speRegExp,spePro,speRegImp,speT0) * 1.5;

*
*    --- this is a manual implementation for the MCP relation: priceSlack x quantity = 0,
*        calculate slack in benchmark. Zero for observed flows by definition
*
   xwSpeSlack(speRegExp,spePro,speRegImp,speT0) $ [(not m_xwSpe(speRegExp,spePro,speRegImp,speT0)) $ m_combSpe(speRegExp,spePro,speRegImp)]
       = m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speT0) * p_speCal(speRegExp,spePro,speRegImp,speT0)
              - m_pmtSpe(speRegImp,spePro,speT0);
*
*  --- scaler to line up phyiscal quantities (reflect that xmt is defined at pmt=0, and xw at f.o.b. minus export taxes)
*
   p_xmtScaleSpe(speRegImp,spePro) $ sum(speT0,m_xmtSpe(speRegImp,spePro,speT0))
      = sum((speRegExp,speT0), m_xwSpe(speRegExp,spePro,speRegImp,speT0))/sum(speT0,m_xmtSpe(speRegImp,spePro,speT0)) ;
*
 if ( execerror,
    execute_unload "%ERROR_FILE%";
    abort "Execerror after calibration of SPE module in file: %system.fn%, line: %system.incline%";
 );
   execute_unload "%results_out%\spe_cal.gdx"