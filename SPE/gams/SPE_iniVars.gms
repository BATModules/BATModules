********************************************************************************
$ontext

   CGEBOX project

   GAMS file : SPE_INIVARS.GMS

   @purpose  : Initalizate variables for SPE model
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : solve/iniVars.gms

$offtext
********************************************************************************
$onlisting
* --- Model-specific initializations, e.g. transport cost function
$iftheni.targetModel "%targetModel%"=="CGEBox"



$elseifi.targetModel "%targetModel%"=="CAPRI"

* --- Price calibration term is constant from calibration point
   p_speCal(speRegExp,spePro,speRegImp,speTCur) = p_speCal(speRegExp,spePro,speRegImp,speT0);

* --- Initialize transport cost variable according to function
    v_transpCost(speRegImp,speRegExp,spePro) $ [m_combSpe(speRegExp,spePro,speRegImp) $ speProCur(spePro)]
    =   p_transpCostConst(speRegImp,speRegExp,spePro)
      + p_transpCostSlope(speRegImp,speRegExp,spePro) * v_tradeflows.L(speRegImp,speRegExp,spePro);

$else.targetModel
   abort "ERROR: Target model not set in %system.fn%";
$endif.targetModel

*
* --- aggregate imports (= pyhsical aggregation under law of one price)
*
  m_xmtSpe(speRegImp,spePro,speTCur) $ m_hasSpeImp(speRegImp,spePro)
    = sum(speRegExp $ m_combSpe(speRegExp,spePro,speRegImp), m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur))/p_xmtScaleSpe(speRegImp,spePro);
*
* --- calculate average import prices from given solution
*
  m_pmtSpe(speRegImp,spePro,speTCur) $ (m_hasSpeImp(speRegImp,spePro)  $ m_xmtSpe(speRegImp,spePro,speTCur))
   = sum(speRegExp $ (m_combSpe(speRegExp,spePro,speRegImp) $ m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)),
            m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)
             *m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur)*p_speCal(speRegExp,spePro,speRegImp,speTCur))
     / (m_xmtSpe(speRegImp,spePro,speTCur)*p_xmtScaleSpe(speRegImp,spePro));
*
* --- calculate c.i.f. prices plus tariff as to match the average import price for non-zero flows
*     (requirement from spatial arbitrade)
*
  m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur) $ ((m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur) gt 1.E-10)
                                                               $ m_combSpe(speRegExp,spePro,speRegImp))
    = m_pmtSpe(speRegImp,spePro,speTCur)/p_speCal(speRegExp,spePro,speRegImp,speTCur);
*
* --- calculate average import prices again
*
  m_pmtSpe(speRegImp,spePro,speTCur) $ (m_hasSpeImp(speRegImp,spePro)  $ m_xmtSpe(speRegImp,spePro,speTCur))
   = sum(speRegExp $ (m_combSpe(speRegExp,spePro,speRegImp) $ m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)),
            m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur)
             *m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur)*p_speCal(speRegExp,spePro,speRegImp,speTCur))
     / (m_xmtSpe(speRegImp,spePro,speTCur)*p_xmtScaleSpe(speRegImp,spePro));
*
* --- calculate c.i.f. price plus tariff to match average import price for non-zero flows
*     (requirement from spatial arbitrade)
*
  m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur) $ ((m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur) gt 1.E-10)
                                                                $ m_combSpe(speRegExp,spePro,speRegImp))
     =  m_pmtSpe(speRegImp,spePro,speTCur)/p_speCal(speRegExp,spePro,speRegImp,speTCur);
*
*
* --- calculate change in transport costs and flows from update import prices
*     (code must be provided by target model via globals or can be left empty)
*
$if not set trsCostIniSpe1     $set trsCostIniSpe1
$if not set trsCostIniSpe2     $set trsCostIniSpe2
$if not set trsCostIniSpe3     $set trsCostIniSpe3
$if not set trsCostIniSpe4     $set trsCostIniSpe4
$if not set trsCostIniSpe5     $set trsCostIniSpe5
$if not set trsCostIniSpe6     $set trsCostIniSpe6
$if not set trsCostIniSpe7     $set trsCostIniSpe7
$if not set trsCostIniSpe8     $set trsCostIniSpe8
$if not set trsCostIniSpe9     $set trsCostIniSpe9
$if not set trsCostIniSpe10    $set trsCostIniSpe10
$if not set trsCostIniSpe11    $set trsCostIniSpe11
$if not set trsCostIniSpe12    $set trsCostIniSpe12
$if not set trsCostIniSpe13    $set trsCostIniSpe13
$if not set trsCostIniSpe14    $set trsCostIniSpe14
$if not set trsCostIniSpe15    $set trsCostIniSpe15

  %trsCostIniSpe1%
  %trsCostIniSpe2%
  %trsCostIniSpe3%
  %trsCostIniSpe4%
  %trsCostIniSpe5%
  %trsCostIniSpe6%
  %trsCostIniSpe7%
  %trsCostIniSpe8%
  %trsCostIniSpe9%
  %trsCostIniSpe10%
  %trsCostIniSpe11%
  %trsCostIniSpe12%
  %trsCostIniSpe13%
  %trsCostIniSpe14%
  %trsCostIniSpe15%
*
*  --- update c.i.f. plus tariff price
*
   m_pmcifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur) $ m_combSpe(speRegExp,spePro,speRegImp)
      = m_pmcifPlusTarDef(speRegExp,spePro,speRegImp,speTCur);
*
* --- calculate slack for zero flows
*
  xwSpeSlack(speRegExp,spePro,speRegImp,speTCur) $ ((m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur) gt 1.E-10) $  m_combSpe(speRegExp,spePro,speRegImp)) = 0;

  xwSpeSlack(speRegExp,spePro,speRegImp,speTCur) $ ((m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur) le 1.E-10) $ m_combSpe(speRegExp,spePro,speRegImp))
     = max(1.E-6,m_pmCifPlusTarSpe(speRegExp,spePro,speRegImp,speTCur) * p_speCal(speRegExp,spePro,speRegImp,speTCur)
           - m_pmtSpe(speRegImp,spePro,speTCur));
*
* --- re-aggregate total imports
*
  m_xmtSpe(speRegImp,spePro,speTCur) $ m_hasSpeImp(speRegImp,spePro)
    = sum(speRegExp $ m_combSpe(speRegExp,spePro,speRegImp), m_xwSpe_L(speRegExp,spePro,speRegImp,speTCur))/p_xmtScaleSpe(speRegImp,spePro);

  if ( execerror,
     
      execute_unload "%ERROR_FILE%";
      abort "Execerror after initialization of SPE module in file: %system.fn%, line: %system.incline%"
  );
  display "SPE module finished variable initialization";    
*  execute_unload "%results_out%\spe_ini.gdx";