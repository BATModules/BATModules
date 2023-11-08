********************************************************************************
$ontext

   CGEBox project

   GAMS file : ARMLESCES_CAL.GMS

   @purpose  : calibration of ARM_CES_LES commitment terms and
               population of set steering the use of the ARM_CES_LES cases
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : cal/cal.gms

$offtext
********************************************************************************
$iftheni.targetModel "%targetModel%"=="CGEBox"
   $$ifthen.mrio defined mrio_sel1

      if ( sum(i $ (mrio_sel(i) and arm_les_ces_pro_sel(i)),1),
        abort "A product cannot be at the same time in the MRIO and ARM_LES_CES module",
           arm_les_ces_pro_sel,mrio_sel;
      );
   $$endif.mrio
   $$ifthen.melitz defined iMel_sel

      if ( sum(i $ (iMel_sel(i) and arm_les_ces_pro_sel(i)),1),
        abort "A product cannot be at the same time in the Melitz and ARM_LES_CES module",
           arm_les_ces_pro_sel,iMel_sel;
      );
   $$endif.melitz
*
*  --- use sets from interface to populate the ARM-CES-LES case
*
   arm_les_ces(armComImpReg,i) $ (arm_les_ces_imp_sel(armComImpReg) $ arm_les_ces_pro_sel(i) $ xmt.l(armComImpReg,i,"%t0%")) = YES;
   iIn(i) = YES;

   singleton set curMioI(i);

$endif.targetModel

  $$setglobal reportArmFit on

  option kill=p_amwCom;

  set calPoints / "%armComt0%","Expert" /;

*
* --- define calibration model
*
   parameter
             p_xArmCom(armComImpReg,calPoints)  "Observed demands"
             p_pArmCom(armComExpReg,calPoints)  "Prices"
             p_fitArmCom                     "Reporting parameter"
             p_priceMult                        "Multiplier to line up exhaustion price"
             p_sumShare
   ;

   equations
*
*            --- Equations in simulation model
*
             e_impPCES(calPoints)               "CES price index"
             e_nonComE(calPoints)               "Non committed expenditure"
             e_nonComEN(calPoints,mrioA)        "Non committed expenditure, bound on negative expenditures"
             e_marsh(armComExpReg,calPoints)    "Marshallian demands"
             e_uArmCom(calPoints)               "Utility from exhaustion of non-committed income"
             e_xcArmcom(armComExpReg,calPoints) "Bounds on commitment terms"
             e_impPArmCom                       "Definition of average import price"
*
*            --- Additional equation in calibration"
*
             e_addupShare         "Share parameters add up to unity"
             e_objFitArmCom             "Fit to expert point"
   ;

   variables v_xArmCom(armComExpReg,calPoints) "Bi-lateral demands"
             v_uArmCom(calPoints)              "Utility"
             v_cnstArmCom(armComExpReg)           "Commitment terms"
             v_sArmCom(armComExpReg)           "Share parameters"
             v_impPArmCom(calPoints)           "Exhaustion price index for imports"
             v_optArmCom                       "Calibration objective"
             v_budArmCom(calPoints)            "Budget spent on imports"
             v_pindCes(calPoints)        "CES price index"
             v_nonComE(calPoints)        "Non committed expenditure"
   ;

  parameter p_p_sigmaW;

*
*  --- CES price index
*
   e_impPCES(calPoints) ..
*
       v_pindCes(calPoints) =E= sum[armComExpReg $ v_sArmCom.scale(armComExpReg),
                                      v_sArmCom(armComExpReg) * p_pArmCom(armComExpReg,calPoints) ** (1-p_p_sigmaW)]**(1/(1-p_p_sigmaW))
                                 * p_priceMult;
*
*  --- Non-Committed expenditure
*
   e_nonComE(calPoints) ..

       v_nonComE(calPoints) =E= v_budArmCom(calPoints)
                                  - sum(armComExpReg $ v_sArmCom.scale(armComExpReg), v_cnstArmCom(armComExpReg) * p_pArmCom(armComExpReg,calPoints));
*
*  --- ensure that negative commitments do not exceed budget
*

$iftheni.targetModel "%targetModel%"=="CGEBox"
$iftheni.MRIO "%modulesGTAP_Mrio%"=="on"
*
*  --- depending on the differences in c.i.f. prices across importers, the MRIO extension can imply quite different
*      shares of the value of the commitment terms on total import value by agent. This equation ensures that the
*      implicite expenditure can not exceed spendings by more than 25%
*
   e_nonComEN(calPoints,mrioA) $ (card(curMioI) $ sum( (rsNat,curMioI,armComExpReg), mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif")))  ..

      sum(armComExpReg $ (v_sArmCom.scale(armComExpReg) $ sum((rsNat,curMioI), mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif"))),
            v_cnstArmCom(armComExpReg) * p_pArmCom(armComExpReg,calPoints)
                            * sum( (rsNat,curMioI), mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif")
                                 *(1+mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"m")/mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif"))))
          =G= -sum(armComExpReg, v_xArmCom(armComExpReg,"%armComt0%")* p_pArmCom(armComExpReg,calPoints)
                * sum((rsNat,curMioI) $ mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif"),
                            mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif")
                               *(1+mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"m")/mrioSplitFactors(rsNat,curMioI,armComExpReg,mrioA,"cif")))
                   )*0.25;
$endif.MRIO
$endif.targetModel
*
*  --- Definition of u
*
   e_uArmCom(calPoints) ..

      v_uArmCom(calPoints) * v_pindCes(calPoints) =E= v_nonComE(calPoints);
*
*  --- Marshallian demands
*
   e_marsh(armComExpReg,calPoints) $ v_sArmCom.scale(armComExpReg)  ..

      v_xArmCom(armComExpReg,calPoints) =E= (v_uArmCom(calPoints) * v_sArmCom(armComExpReg)
                          * (v_pindCes(calPoints)/p_pArmCom(armComExpReg,calPoints))**p_p_sigmaW + v_cnstArmCom(armComExpReg));
*
*  --- Definition of price index (u is implicite in simulation model where budget is exogenous)
*
   e_impPArmCom(calPoints)    ..

      v_budArmCom(calPoints) =E= v_uArmCom(calPoints) * v_impPArmCom(calPoints);
*
*  --- fit for expert point (benchmark is fixed)
*
   e_objFitArmCom     .. v_optArmCom * card(armComExpReg)
                        =E= sum(armComExpReg $ p_xArmCom(armComExpReg,"expert"),
                            sqr[ (v_xArmCom(armComExpReg,"expert") - p_xArmCom(armComExpReg,"expert"))/(p_xArmCom(armComExpReg,"expert")+1.E-6) ]);
*
*  --- Share parameters add up to unity
*
   e_addUpShare .. sum(armComExpReg $ v_sArmCom.scale(armComExpReg), v_sArmCom(armComExpReg)) =E= p_sumShare;
*
*  --- Bounds on commitment terms to prevent problems in later sims
*
   e_xcArmcom(armComExpReg,calPoints) $ v_sArmCom.scale(armComExpReg)   ..  v_xArmCom(armComExpReg,calPoints)*0.50 =G= v_cnstArmCom(armComExpReg);
*
*  --- calibration framework
*
   model m_calArmCom /
                     e_marsh.v_xArmCom
                     e_impPCES.v_pindCes
                     e_impPArmCom.v_impPArmCom
                     e_nonComE.v_nonComE
                     e_uArmCom.v_uArmCom
                     e_objFitArmCom,
                     e_addUpShare,

                     $$ifi "%modulesGTAP_Mrio%"=="on" e_nonComeN
                     e_xcArmCom
                     /;
   m_calArmCom.holdfixed = 1;
   m_calArmCom.solvelink = 5;
   m_calArmCom.iterlim   = 10000;
   m_calArmCom.optfile   = 1;
   m_calArmCom.domlim    = 1000;
*
* --- exhaustion prices are identical in starting point
*
   pmtUArmCom(armComImpReg,armComPro,"%armComt0%") $  m_isArmCom(armComImpReg,armComPro) = m_pmtArmCom(armComImpReg,armComPro,"%armComt0%");
*
*  ---- loop over relevant cases
*
   loop( (armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro),
      $$Ifi "%targetModel%"=="CgeBox" curMioI(armComPro) = Yes $ iMrio(armComPro) ;
*
*     --- starting values for share parameters from initialization of Armington module
*
      v_sArmCom.l(armComExpReg)            = m_amwArmCom(armComExpReg,armComPro,armComImpReg,"%armComt0%");

      v_sArmCom.scale(armComExpReg)        = v_sArmCom.l(armComExpReg);
      p_sumShare                           = sum(armComExpReg, v_sArmCom.l(armComExpReg));
*
*     --- set observed bi-lateral import price
*
      p_pArmCom(armComExpReg,calPoints)    = m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,"%armComT0%");


*
*     --- set a 10% price increase for the shares below the critial limit
*
      p_pArmCom(armComExpReg,"expert") = p_pArmCom(armComExpReg,"%armComT0%")
             * ( 1 - 0.1 $  (v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_sumShare) $ m_isArmComExpReg(armComExpReg));

      v_cnstArmCom(armComExpReg)              = 0;
      v_xArmCom.l(armComExpReg,calPoints)  = m_xwArmCom_l(armComExpReg,armComPro,armComImpReg,"%armComT0%");
      p_p_sigmaW                = p_sigmaW(armComImpReg,armComPro);
*
*     --- calculate budget
*
      v_budArmCom(calPoints)        = sum(armComExpReg, v_xArmCom.l(armComExpReg,"%armComT0%") * p_pArmCom(armComExpReg,"%armComT0%"));
      if ( (abs( (v_budArmCom.l("%armComT0%") - m_pmtArmCom_L(armComImpReg,armComPro,"%armComT0%")*m_xmtArmCom_L(armComImpReg,armComPro,"%armComT0%"))
                /v_budArmCom.l("%armComT0%")) gt 1.E-6)
          $  (abs( (v_budArmCom.l("%armComT0%") - m_pmtArmCom_L(armComImpReg,armComPro,"%armComT0%")*m_xmtArmCom_L(armComImpReg,armComPro,"%armComT0%"))) gt 1.E-5),
           abort "xmt*pmt<>bud",v_budArmCom.l);
*
*     --- derive estimate for CES price index (= unity)
*
      p_priceMult = m_axPmtCD(armComImpReg,armComPro,"%armComT0%");

      v_pindCes(calPoints)
         = sum[armComExpReg $ v_sArmCom.l(armComExpReg), v_sArmCom(armComExpReg) * p_pArmCom(armComExpReg,calPoints) ** (1-p_p_sigmaW)]**(1/(1-p_p_sigmaW))
             * p_priceMult;
*
*     --- non-committed inomce is equal to budget
*
      v_nonComE(calPoints) = v_budArmCom(calPoints);
      v_uArmCom(calPoints)       = v_nonCome(calPoints)/v_pindCes(calPoints);
*
*     --- simulate standard response (i.e. without commitment terms) at given total demand and updated prices
*
      v_xArmCom(armComExpReg,calPoints)  $ v_sArmCom(armComExpReg)
       = v_uArmCom(calPoints) * v_sArmCom(armComExpReg) * (v_pindCes(calPoints)/p_pArmCom(armComExpReg,calPoints))**p_p_sigmaW;
*
*     --- for shares above the critical limit, we calibrated against the standard response
*
      p_xArmCom(armComExpReg,"Expert") $ ((v_sArmCom(armComExpReg) gt 1.E-%armComBoostShare%*p_sumShare) $ v_sArmCom(armComExpReg))
          = v_xArmCom.l(armComExpReg,"expert");
*
*     --- otherwise, we simulate the response at a share which is multiplied with the user chosen boostShare,
*         but does not exceed the critical share limit
*
      p_xArmCom(armComExpReg,"Expert") $ ( (v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_sumShare)
                                          $ v_sArmCom(armComExpReg) $ m_isArmComExpReg(armComExpReg))
         = min(1.E-%armComBoostFactor%*v_uArmCom("expert")* (v_pindCes("expert")/p_pArmCom(armComExpReg,"expert"))**p_p_sigmaW,
               v_xArmCom(armComExpReg,"expert")*%armComBoostFactor%);
*
*     --- price index at benchmark (should be unity if all benchmark prices are unity)
*
      v_impPArmCom(calPoints) = v_budArmCom(calPoints) / v_uArmCom(calPoints);
*
*     --- lower / upper bounds on parameters / estimates
*         (CONOPT4 reacts quite sensitive to bounds on the share parmameters, 1.E-20 work best in tests)
*
      v_sArmCom.lo(armComExpReg) = 1.E-20;
      v_sArmCom.up(armComExpReg) = p_sumShare-v_sArmCom.lo(armComExpReg)*card(armComExpReg);
*
      v_pindCes.lo(calPoints)    = 0.001;
      v_pindCes.up(calPoints)    = inf;
*
*     --- in order to boost the demand response, we need a negative commitment term, to help the solver,
*         set an upper limit for the boost cases
*
      v_cnstArmCom.up(armComExpReg) = +inf;
      v_cnstArmCom.up(armComExpReg) $ ((v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_SumShare) $ m_isArmComExpReg(armComExpReg))
         = max(p_xArmCom(armComExpReg,"Expert")*0.5,1.E-3*v_budArmCom("expert"));
      v_cnstArmCom.lo(armComExpReg) = -inf;

      v_impPArmCom.fx("%armComT0%")  = 1;
      v_budArmCom.fx(calPoints) = v_budArmCom.l("%armComT0%");

      v_xArmCom.lo(armComExpReg,calPoints) = v_xArmCom.l(armComExpReg,"%armComT0%") * 1.E-6;
      v_xArmCom.lo(armComExpReg,"expert") $ ((v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_sumShare)
                                        $ m_isArmComExpReg(armComExpReg))  = p_xArmCom(armComExpReg,"expert")*0.5;
      v_xArmCom.up(armComExpReg,calPoints) = inf;

      v_xArmCom.fx(armComExpReg,"%armComT0%") = v_xArmCom.l(armComExpReg,"%armComT0%");
*
      v_nonComE.lo(calPoints) = v_budArmCom(calPoints) * 0.75;
      v_nonComE.up(calPoints) = v_budArmCom(calPoints) * 1.25;

*
      if ( sum(armComExpReg $ (p_pArmCom(armComExpReg,"expert") ne p_pArmCom(armComExpReg,"%armComT0%")),1),

         $$iftheni.report "%reportArmFit%"=="on"
*
*           --- store calibration target (enters objective) and standard shares
*
            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"start")     = p_xArmCom(armComExpReg,calPoints);
            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"std")       = v_xArmCom.l(armComExpReg,calPoints);
            p_fitArmCom("%armComT0%",armComExpReg,armComPro,armComImpReg,"share")  = v_sArmCom.l(armComExpReg);
            p_fitArmCom("expert",armComExpReg,armComPro,armComImpReg,"share") $ ((v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_sumShare)
               $ m_isArmComExpReg(armComExpReg))  = v_sArmCom.l(armComExpReg);

         $$endif.report
*
*        --- calibrate parameters to come close to artificial observations
*
         m_calArmCom.solprint = 2;

         if ( p_sumShare le 1.E+6,
*
*           --- exclude cases where a very high substitution elasticity in combination with a large share
*               on a quite high import price generates crazy share parameters as seen by their sum.
*               This seems to keep the solver from being able to work on the system
*

            solve m_calArmCom minimizing v_optArmCom using NLP;
            if ( m_calArmCom.modelstat ne 2,
               v_xArmCom.lo(armComExpReg,"expert") $ ((v_sArmCom(armComExpReg) le 1.E-%armComBoostShare%*p_sumShare)
                                    $ m_isArmComExpReg(armComExpReg))  = p_xArmCom(armComExpReg,"%armComT0%");
               m_calArmCom.solprint = 1;
               solve m_calArmCom minimizing v_optArmcom using NLP;
               if ( m_calArmCom.sumInfes  ne 0, abort "ARm_calArmCom calibration failed ",armComImpReg,p_sumshare;);
            );
         );
*
*        --- reporting part, irrelevant for functioning of module
*
         $$iftheni.report "%reportArmFit%"=="on"

            p_fitArmCom("","resusd",armComPro,armComImpReg,"fit")   = m_calArmCom.resUsd;
*
*           --- reporting: squared relative dev. for each demand, commitement terms,
*                          simulated demand versus what a standard CES would give
*
            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"fit")
             $ v_sArmCom.l(armComExpReg)  = sqr[ (v_xArmCom.l(armComExpReg,calPoints)-p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"start"))
                                                 /(p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"start")+1.E-8)];

            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"fit")
             $ (p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"fit") le 1.E-8) = 0;

            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"com")   = v_cnstArmCom.l(armComExpReg);

            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"com/x%")  $ (v_cnstArmCom.l(armComExpReg) gt 0) = v_cnstArmCom.l(armComExpReg)/v_xArmCom.l(armComExpReg,calPoints);

            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"cal/std")
             $ v_sArmCom.l(armComExpReg)  = v_xArmCom.l(armComExpReg,calPoints)/p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"std");

*
*           ---- calibration did not work: the new simulated point is even lower than the standard. Result of numerical
*                                          issues
            p_fitArmCom("expert",armComExpReg,armComPro,armComImpReg," ***   ")
             $ ( (p_fitArmCom("expert",armComExpReg,armComPro,armComImpReg,"cal/std") le 1) $ p_fitArmCom("expert",armComExpReg,armComPro,armComImpReg,"share"))
              = p_fitArmCom("expert",armComExpReg,armComPro,armComImpReg,"cal/std");
            p_fitArmCom(calPoints,armComExpReg,armComPro,armComImpReg,"cal")     = v_xArmCom.l(armComExpReg,calPoints);
*
*           --- overall model stats
*
            p_fitArmCom(calPoints,"check",armComPro,armComImpReg,"fit")
                   = sum(armComExpReg, v_cnstArmCom(armComExpReg)*p_pArmCom(armComExpReg,calPoints)) - v_uArmCom(calPoints)*(v_pindCes(calPoints)-v_impPArmCom(calPoints));
            p_fitArmCom("","solveStat",armComPro,armComImpReg,"fit")   = m_calArmCom.solvestat;
            p_fitArmCom("","modelStat",armComPro,armComImpReg,"fit")   = m_calArmCom.modelstat;
            p_fitArmCom("",calPoints,armComPro,armComImpReg,"fit")
              = sum(armComExpReg, sqr( (v_xArmCom.l(armComExpReg,calPoints)-p_xArmCom(armComExpReg,calPoints))/(p_xArmCom(armComExpReg,calPoints)+1.E-8)))/card(armComExpReg);
         $$endif.report

*
*        --- copy results (parameter, starting values for pmtU and xmtU
*
         p_amwCom(armComExpReg,armComPro,armComImpReg,"%armComT0%")    = v_cnstArmCom(armComExpReg);
         m_amwArmCom(armComExpReg,armComPro,armComImpReg,"%armComT0%") = v_sArmCom(armComExpReg);
         pmtUArmCom(armComImpReg,armComPro,"%armComT0%")               = v_pindCes("%armComT0%");
         xmtUArmCom(armComImpReg,armComPro,"%armComT0%")               = v_uArmCom("%armComT0%");
      );
  );

*
* --- take out import - product combination where no commitments are present
*
  m_isArmCom(armComImpReg,armComPro) $ (not sum(armComExpReg, p_amwCom(armComExpReg,armComPro,armComImpReg,"%armComT0%"))) = no;

  nonComImpExp(armComImpReg,armComPro,"%armComT0%") $ m_isArmCom(armComImpReg,armComPro) =
*
*         --- total value of imports
*
          m_xmtArmCom(armComImpReg,armComPro,"%armComT0%") * m_pmtArmCom(armComImpReg,armComPro,"%armComT0%")
*
*          --- minues values of commitment at c.i.f. prices
*
            - sum(armComExpReg $ p_amwCom(armComExpReg,armComPro,armComImpReg,"%armComT0%"),
                       p_amwCom(armComExpReg,armComPro,armComImpReg,"%armComT0%")
                       *m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,"%armComT0%") );


*
 if ( execerror, abort "Execerror after calibration of ARm_calArmCom module in file: %system.fn%, line: %system.incline%");
$if not errorfree $abort Compilation error after file: %system.fn%
