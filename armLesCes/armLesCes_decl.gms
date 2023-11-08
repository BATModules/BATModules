********************************************************************************
$ontext

   CGEBox project

   GAMS file : ARMLESCES_MOD.GMS

   @purpose  : Introduce changed or new equations for ARM-LES-CES module
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************
$ifi not set targetModel $abort "Targetmodel global not set, SPE module cannot be used."
$ondotl

$iftheni.targetModel "%targetModel%"=="CGEBox"

* ---------------------------------------------------------------------------------------
*
*   mappings and definitions for CGEBox
*
* ---------------------------------------------------------------------------------------

*
* --- export and import regiogns
*
  alias(armComExpReg,armComImpReg,rNat);
*
* --- general definitions of products in SPE model (no dynamic set allowed)
*
  alias(armComPro,armComPro1,i);
*
* --- current products in SPE model
*
  alias(armComProCur,i);
*
* --- non-dynamic set for all time points
*
  alias(armComT,t);
*
* --- dynamic set for benchmark time point
*
  alias(armComT0,t0);
*
* --- and global to be used as a fixed string "%t0%"
*
  $$setglobal armComT0 %t0%
*
* --- dynamic set for current simulation time point
*
  alias(armComTCur,ts);
*
* --- ordered set for all simulation time points
*
  alias(armComTSim,tSim);
*
* --- macros for import quantity (index) variables
*
  $$macro m_xmtArmCom(armComRegImp,armComPro,armComTCur)       xmt(armComRegImp,armComPro,ArmComTCur)
  $$macro m_xmtArmCom_L(armComRegImp,armComPro,armComTCur)     xmt.l(armComRegImp,armComPro,ArmComTCur)
  $$macro m_xmtArmCom_Scale(armComRegImp,armComPro,armComTCur) xmt.scale(armComRegImp,armComPro,ArmComTCur)
*
* --- macros for import price (index) variables
*
  $$setglobal pmtArmCom                                        pmt
  $$macro m_pmtArmCom(armComRegImp,armComPro,armComTCur)       pmt(armComRegImp,armComPro,ArmComTCur)
  $$macro m_pmtArmCom_L(armComRegImp,armComPro,armComTCur)     pmt.l(armComRegImp,armComPro,ArmComTCur)
  $$macro m_pmtArmCom_Range(armComRegImp,armComPro,armComTCur) pmt.range(armComRegImp,armComPro,ArmComTCur)
*
* --- macros for bi-lateral import quantity (index)
*
  $$setglobal xwArmCom                                                     xw
  $$macro m_xwArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)       xw(armComRegExp,armComPro,armComRegImp,ArmComTCur)
  $$macro m_xwArmCom_Scale(armComRegExp,armComPro,armComRegImp,armComTCur) xw.scale(armComRegExp,armComPro,armComRegImp,ArmComTCur)
  $$macro m_xwArmCom_Range(armComRegExp,armComPro,armComRegImp,armComTCur) xw.range(armComRegExp,armComPro,armComRegImp,ArmComTCur)
  $$macro m_xwArmCom_L(armComRegExp,armComPro,armComRegImp,armComTCur)     xw.l(armComRegExp,armComPro,armComRegImp,ArmComTCur)
  $$macro m_xwArmCom_Lo(armComRegExp,armComPro,armComRegImp,armComTCur)    xw.lo(armComRegExp,armComPro,armComRegImp,ArmComTCur)
*
* --- macro for Armington substiution elasticity between importer regions
*
  $$macro m_sigmaW(armComImpReg,armComPro) p_sigmaW(armComImpReg,armComPro)
*
* --- macro for additional multiplier in import price definition, can be set to unity on the LHS if not needed
*
  $$macro m_axPmtCD(armComImpReg,armComPro,armComTCur) p_axPmtCD(armComImpReg,armComPro,armComTCur)
*
* --- macro for Armington share parameter
*
  $$macro m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) p_amw(armComExpReg,armComPro,armComImpReg,armComTCur)
*
* --- macros for iceberg trade cost
*
  $$macro m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) m_lambdam(armComExpReg,armComPro,armComImpReg,armComTCur)
*
* --- macros for bi-lateral import price at CIF
*
  $$macro m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur) \
*
                           [(1 + imptx(armComExpReg,armComPro,armComImpReg,armComTCur) + mtax(armComImpReg,armComPro,armComTCur)) \
*
*                          --- Note WB: cif price is defined via macro %pmcif%, normally not a variable in model
*
                          * %pmcif%(armComExpReg,armComPro,armComImpReg,armComTCur) ]


*
* --- this defines the combination of exporter, product, importer in current SPE equations
*
  $$macro m_combArmCom(armComRegExp,armComPro,armComRegImp) [xwFlag(armComRegExp,armComPro,armComRegImp) $ rrComb(armComRegExp,armComRegImp) \
                                                              $ (not iMrio(armComPro)) $ (not iSpe(armComPro)) $ iIn(armComPro)]

*
* --- this defines the combination of import regions and product in current SPE equations
*
  $$macro m_hasArmComImp(armComImpReg,armComPro) [ (pmt.range(armComImpReg,armComPro,armComTCur) ne 0) \
                                                   $ (not p_pmtElas(armComImpReg,armComPro)) $ xmtFlag(armComImpReg,armcomPro) \
                                                   $ (not iMrio(armComPro)) $ (not iSpe(armComPro)) $ iIn(armComPro) ]
*
* --- this defines the products with commitment term (potential combination)
*
 $$macro m_isArmCom(armComImpReg,armComPro)      arm_LES_CES(armComImpReg,armComPro)
*
* --- this defines the potential exporter flows with commitment terms, used in calibration
*
 $$macro m_isArmComExpReg(armComExpReg) arm_les_ces_exp_sel(armComExpReg)

*
* --- special macros for small shares handled as Leontief (can be left out, see below)
*
 $$setglobal addCondXwArmCom1 $ifi "%hasSmallShare%"=="on" $ (not isSmallImpShare(armComExpReg,armComPro,armComImpReg)) + m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) $ isSmallImpShare(armComExpReg,armComPro,armComImpReg)
 $$setglobal addCondXwArmCom2 $ifi "%hasSmallShare%"=="on"   $ (not isSmallImpShare(armComExpReg,armComPro,armComImpReg))
 $$setglobal addCondXwArmCom3 $ifi "%hasSmallShare%"=="on"  + sum(rNat $ isSmallImpShare(rNat,armComPro,armComImpReg), p_amw(rNat,armComPro,armComImpReg,armComTCur)*m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)/m_lambdam(rNat,armComPro,armComImpReg,armComTCur))
*
* --- for calibration: share below which "boosting" starts
*
 $$setglobal armComBoostShare  %arm_les_ces_boostShare%
*
* --- for calibration: multiplicative boost factors relative to CES standard response to a 10%
*     reduction in import prices (at unchanged other import prices)
*
 $$setglobal armComBoostFactor %arm_les_ces_boostFactor%


$endif.targetModel

*
* --- additional tests and terms in equations, set empty and if not provided by target model
*
$$ifi not setglobal addCondXwArmCom1 $setglobal addCondXwArmCom1
$$ifi not setglobal addCondXwArmCom2 $setglobal addCondXwArmCom2
$$ifi not setglobal addCondXwArmCom3 $setglobal addCondXwArmCom3


  Equations

     e_xwArmCom(armComExpReg,armComPro,armComImpReg,armComT)  "Definition of bi-lateral imports, Armington with commitments or standard CES"
     e_pmtArmCom(armComImpReg,armComPro,armComT)              "Definition of CES import price index, Armington with commitments or standard CES"
     e_pmtUArmCom(armComImpReg,armComPro,armComT)             "Exhaustion condition, defines average import prices"
     e_xmtUArmCom(armComImpReg,armComPro,armComT)             "Definition of CES import price index, Armington with commitments or standard CES"
     e_nonComImpExp(armComImpReg,armComPro,armComT)           "Definition of non-committed expenditure on imports"
   ;
   Variables

     pmtUArmCom(armComImpReg,armComPro,armComT)          "Price of aggregate imports for Armington with commitments"
     xmtUARmCom(armComImpReg,armComPro,armComT)          "Utility of import demand under Armington with commitments"
     nonComImpExp(armComImpReg,armComPro,armComT)        "Non-committed expenditure on imports under Armington with commitments"
   ;

   parameters
     p_amwCom(armComExpReg,armComPro,armComImpReg,armComT)  "Commitment terms in Arminton with commitments"
   ;

*
* --- if set to on (default), a fudging function will ensure the non-negativity condition
*
$setglobal armComFudg on
*
* --- Blateral import demand with commitment terms
*
*     Note: macro m_isArmCom(armComImpReg,armComPro) depict the import markets where at least one import flow
*           comprises a commitment terms such that the additional pmtU and xmtU variables and related
*           equations are needed. For the other markets, this is the standard CES formulation
*
*
  e_xwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) $ m_CombArmCom(armComExpReg,armComPro,armComImpReg)..


      m_xwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)/m_xwArmCom_scale(armComExpReg,armComPro,armComImpReg,armComTCur)
        =e=
               [ ( m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
*
                          * (   m_xmtArmCom(armComImpReg,armComPro,armComTCur)        $  (not m_isArmCom(armComImpReg,armComPro))
                              + xmtUArmCom(armComImpReg,armComPro,armComTCur)         $       m_isArmCom(armComImpReg,armComPro))


                        *  [{(  (  m_pmtArmCom(armComImpReg,armComPro,armComTCur)        $  (not m_isArmCom(armComImpReg,armComPro))
                                 + pmtUArmCom(armComImpReg,armComPro,armComTCur)         $       m_isArmCom(armComImpReg,armComPro))

                              /m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur))**m_sigmaW(armComImpReg,armComPro)

*
*                            --- preference shifter (also termed iceberg cost term)
*
                             *  m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)**(m_sigmaW(armComImpReg,armComPro) - 1)}

%addCondXwArmCom1%

                          ]
*
*                         --- add commitment term
*
                          + p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)

                 )/m_xwArmCom_scale(armComExpReg,armComPro,armComImpReg,armComTCur) ]

           $$iftheni.fudg "%armComFudg%"=="on"
                   $ (p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur) ge 0)

*
*              -- fudging function to ensure non-negativity in case of negative commitment terms
*
               -{ncpVUSin(-m_xwArmCom_lo(armComExpReg,armComPro,armComImpReg,armComTCur),-[
                ( m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
*
                          * (   m_xmtArmCom(armComImpReg,armComPro,armComTCur)  $  (not m_isArmCom(armComImpReg,armComPro))
                              + xmtUArmCom(armComImpReg,armComPro,armComTCur)   $       m_isArmCom(armComImpReg,armComPro))

                        *  [{(  (  m_pmtArmCom(armComImpReg,armComPro,armComTCur)  $  (not m_isArmCom(armComImpReg,armComPro))
                                 + pmtUArmCom(armComImpReg,armComPro,armComTCur)   $       m_isArmCom(armComImpReg,armComPro))

                              /m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur))**m_sigmaW(armComImpReg,armComPro)
                            *  m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)**(m_sigmaW(armComImpReg,armComPro) - 1)}
%addCondXwArmCom1%
                          ]
*
*                         --- add commitment term
*

                          + p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                 )
              ],1.E-7)/m_xwArmCom_scale(armComExpReg,armComPro,armComImpReg,armComTCur)}  $ (p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur) lt 0)
           $$endif.fudg
                ;

*
* --- Average price of imported origin, equation (52) in VDM 2018
*
  e_pmtArmCom(armComImpReg,armComPro,armComTCur) $ m_hasArmComImp(armComImpReg,armComPro)  ..
*
*  --- standard case without commitments
*
     m_pmtArmCom(armComImpReg,armComPro,armComTCur)  $ (not m_isArmCom(armComImpReg,armComPro))
*
*  --- case with commitments for ARM with commitments
*
   + pmtUArmCom(armComImpReg,armComPro,armComTCur)   $ m_isArmCom(armComImpReg,armComPro)

       =e=
*
*       --- CES case with m_sigmaW <> 1
*
        [sum(armComExpReg $ (m_CombArmCom(armComExpReg,armComPro,armComImpReg)
%addCondXwArmCom2%
                     ),
               m_amwArmcom(armComExpReg,armComPro,armComImpReg,armComTCur)
                     *(m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)
                      /m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur))**(1-m_sigmaW(armComImpReg,armComPro))
             )**(1/(1-m_sigmaW(armComImpReg,armComPro))) * m_axPmtCD(armComImpReg,armComPro,armComTCur)
         ] $ ((m_sigmaW(armComImpReg,armComPro) ne 1) $ m_axPmtCD(armComImpReg,armComPro,armComTCur))
*
*       --- CD case with m_sigmaW == 1
*
      + [prod(armComExpReg $ (m_CombArmCom(armComExpReg,armComPro,armComImpReg)
%addCondXwArmCom2%
                      ),
                     (m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)
                      /(m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)*m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur))
                       )**m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
              ) * p_axPmtCD(armComImpReg,armComPro,armComTCur)
        ] $ ((m_sigmaW(armComImpReg,armComPro) eq 1) $ m_axPmtCD(armComImpReg,armComPro,armComTCur))
*
%addCondXwArmCom3%
    ;

*
* ---- define non-commit expenditure on imports (only for import markets with at least one commitment terms
*
  e_nonComImpExp(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro)) ..

     nonComImpExp(armComImpReg,armComPro,armComTCur)/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur)
        =E=
*
*          --- total import expenditures (quantity times prices)
*
           m_xmtArmCom(armComImpReg,armComPro,armComTCur)/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur)
               * m_pmtArmCom(armComImpReg,armComPro,armComTCur)
*
*          --- minues valus of commitment at c.i.f. prices plus tariffs
*
            - sum(armComExpReg $ p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur),
                          p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                           * m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur))
                               /m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur);
*
* --- utility from exhaustions, i.e. non commitment expenditure on imports divided by dual price index
*
  e_xmtUArmCom(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro)) ..

     xmtUArmCom(armComImpReg,armComPro,armComTCur)/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur)
      * pmtUArmCom(armComImpReg,armComPro,armComTCur)

        =E= nonComImpExp(armComImpReg,armComPro,armComTCur)/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur);
*
* --- this defines the exhaustion price pmt for the imports if at least one commitment is active on the import market
*
  e_pmtUArmCom(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro) ) ..

     (m_pmtArmCom(armComImpReg,armComPro,armComTCur)-pmtUArmCom(armComImpReg,armComPro,armComTCur))
       * xmtUArmCom(armComImpReg,armComPro,armComTCur)/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur) =E=

            sum(armComExpReg $ p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur),
                        p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                         *m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur) )/m_xmtArmCom_scale(armComImpReg,armComPro,armComTCur);


  model m_arm_les_ces /

     e_xwArmCom.%xwArmCom%
     e_pmtArmCom.%pmtArmCom%
     e_nonComImpExp.nonComImpExp
     e_xmtUArmCom.xmtUArmCom
     e_pmtUArmCom.pmtUArmCom
  /;
