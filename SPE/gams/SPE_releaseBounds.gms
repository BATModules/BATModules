********************************************************************************
$ontext

   CGEBox Project

   GAMS file : SPE_releaseBounds.GMS

   @purpose  : Remove bounds for solved year from memory, spatial equ. module
   @author   : Wolfgang Britz
   @date     : 03.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : solve\releaseBounds.gms

$offtext
********************************************************************************
$iftheni.arg1 %1==m
 option kill=e_xwSpe;
 option kill=e_xwSpeSlack;
 option kill=e_pmtSpe;
$endif.arg1
