********************************************************************************
$ontext

   CGEBox project

   GAMS file : SPE_BOUNDS.GMS

   @purpose  : Set bounds for variables in Spatial equlibrium module
   @author   : Wolfgang Britz
   @date     : 03.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : model/closures.gms

$offtext
********************************************************************************

display "Set bounds for SPE trade module in %targetModel%";


*------------------------------------------------------------------------------
*  Common settings for all targe models. For some reason, this does not work. Why?
*  My bounds are untouched afterwards, but work in a small didactic file.
*  Can it be that restarts do not work?
*------------------------------------------------------------------------------

* --- One key point of this module is that it permits the deletion and creation of trade flows
*     This must be permitted.
m_xwSpe_Lo(speRegExp,spePro,speRegImp,speTCur) = 0 $ m_combSpe(speRegExp,spePro,speRegImp);

*     Upper bound: can we access calibration point value in some generic way? Until then...
m_xwSpe_Up(speRegExp,spePro,speRegImp,speTCur) = 10E9 $ m_combSpe(speRegExp,spePro,speRegImp);



xwSpeSlack.fx(speRegExp,spePro,speRegExp,speTCur) = 0;

*------------------------------------------------------------------------------
*  Model-specific bounds
*------------------------------------------------------------------------------

$iftheni.targetModel "%targetModel%"=="CGEBox"

*
* --- MCP solver requires a lower limit of zero
*
   xw.lo(speRegExp,spePro,speRegImp,speTCur)    $ m_combSpe(speRegExp,spePro,speRegImp) = 0;
   xmt.lo(speRegImp,spePro,speTCur)             $ (m_xmtSpe(speRegImp,spePro,speTCur) gt 0)  = 0;
   $$iftheni.ACET not "%SPENonLinear%"=="Additive CET"
      lambdamg.lo(m,speRegExp,spePro,speRegImp,speTCur) $ p_amgm(m,speRegExp,spePro,speRegImp)  = -inf;
      lambdamg.up(m,speRegExp,spePro,speRegImp,speTCur) $ p_amgm(m,speRegExp,spePro,speRegImp)  = +inf;
   $$endif.ACET

$elseifi.targetmodel "%targetModel%"=="CAPRI"
   
   v_transpCost.lo(speRegImp,speRegExp,spePro) $ m_combSpe(speRegExp,spePro,speRegImp) = 0;
   v_transpCost.up(speRegImp,speRegExp,spePro) $ m_combSpe(speRegExp,spePro,speRegImp)
     = max(100, 100*p_speTranspCost(speRegImp,speRegExp,spePro));
*   display v_transpCost.up, speTCur;   

*  For SPE model trade flows, permit all flows except to self, as long as there is some market in both ends
*   v_tradeFlows.LO(speRegImp,speRegExp,spePro) = 0;
*   v_tradeFlows.UP(speRegImp,speRegExp,spePro) $ m_combSpe(speRegExp,spePro,speRegImp) = +inf; 
*   DATA(speRegImp,"Arm1",spePro,"CUR");
   v_tradeFlowNeg.fx(speRegImp,speRegExp,spePro) = 0;
   
*  deltaSpe = 1E-6;

$else.targetModel
   $$abort "Unknown targetmodel for SPE trade module: %targetModule%"
$endif.targetModel


*------------------------------------------------------------------------------
*  General bounds
*------------------------------------------------------------------------------

m_xwSpe_Lo(speRegExp,spePro,speRegImp,speTCur) $ m_combSpe(speRegExp,spePro,speRegImp) = 0;
m_xwSpe_Up(speRegExp,spePro,speRegImp,speTCur) $ m_combSpe(speRegExp,spePro,speRegImp) = +inf;

m_pmCifPlusTarSpe_Lo(speRegExp,spePro,speRegImp,speTCur) $ m_combSpe(speRegExp,spePro,speRegImp) = 0;
m_pmCifPlusTarSpe_Up(speRegExp,spePro,speRegImp,speTCur) $ m_combSpe(speRegExp,spePro,speRegImp) = +inf;

*  The following section can make the penalty function model square by fixing the complementarity gap
*  Useful for checking squareness or for solving with a fixed complementarity gap.
if(p_speLockPenalty,
   %spePF%.fx = 0;
   speGap.fx(speRegExp,spePro,speRegImp,speTCur) 
      = sum(spet0,(xwSpeSlack.l(speRegExp,spePro,speRegImp,spet0) - deltaSpe)
        *(m_xwSpe_L(speRegExp,spePro,speRegImp,spet0)/m_xwSpe_Scale(speRegExp,spePro,speRegImp,speTCur) - deltaSpe));
else
   %spePF%.lo = 0;
   %spePF%.up = inf;
   speGap.lo(speRegExp,spePro,speRegImp,speTCur) = 0;
   speGap.up(speRegExp,spePro,speRegImp,speTCur) = inf;
);