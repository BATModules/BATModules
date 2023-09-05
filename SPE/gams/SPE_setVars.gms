********************************************************************************
$ontext

   CGEBox project

   GAMS file : SPE_SETVARS.GMS

   @purpose  : Initialize variables/parameters in spatial equilibrium module
               for next solution point
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : iterloop.gms

$offtext
********************************************************************************
*
*  --- bi-lateral trade calibration term for SPE model
*
   p_speCal(speRegExp,spePro,speRegImp,speTSim) = p_speCal(speRegExp,spePro,speRegImp,speTSim-1);
   $$iftheni.multRef "%SpeMultRef%"=="on"
      xwSpeSlack(speRegExp,spePro,speRegImp,speTSim) $ p_speCal(speRegExp,spePro,speRegImp,speTSim) = xwSpeSlack(speRegExp,spePro,speRegImp,speTSim-1);
   $$endif.multRef

