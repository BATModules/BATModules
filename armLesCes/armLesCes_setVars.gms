********************************************************************************
$ontext

   CGEBox project

   GAMS file : ARMLESCES_SETVARS.GMS

   @purpose  : Initialize variables/parameters in arm_les_ces module
               for next solution point
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : iterloop.gms

$offtext
********************************************************************************

   pmtUArmCom(armComImpReg,armComPro,armComTSim)       = pmtUArmCom(armComImpReg,armComPro,armComTSim-1);
   xmtUArmCom(armComImpReg,armComPro,armComTSim)       = xmtUArmCom(armComImpReg,armComPro,armComTSim-1);
   p_amwCom(armComExpReg,armComPro,armComImpReg,armComTSim)
               $ p_amwCom(armComExpReg,armComPro,armComImpReg,armComTSim-1) = p_amwCom(armComExpReg,armComPro,armComImpReg,armComTSim-1);
   nonComImpExp(armComImpReg,armComPro,armComTSim)     = nonComImpExp(armComImpReg,armComPro,armComTSim-1);
