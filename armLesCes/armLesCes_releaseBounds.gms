********************************************************************************
$ontext

   CGEBox Project

   GAMS file : ARMLESCES_RELEASEBOUNDS.GMS

   @purpose  : Remove bounds for solved year from memory
   @author   : Wolfgang Britz
   @date     : 03.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : solve\releaseBounds.gms

$offtext
********************************************************************************
$iftheni.arg1 %1==m
   option kill=e_xwArmCom;
   option kill=e_pmtArmCom;
   option kill=e_pmtUArmCom;
   option kill=e_xmtUArmCom;
   option kill=e_nonComImpExp;
$endif.arg1

option kill=pmtUArmCom.%1;
option kill=xmtUArmCom.%1;
option kill=nonComImpExp.%1;
