********************************************************************************
$ontext

   CGEBox project

   GAMS file : ARMLESCES_BOUNDS.GMS

   @purpose  : Set bounds for variables in ArmLesCes module
   @author   : Wolfgang Britz
   @date     : 03.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : model/closures.gms

$offtext
********************************************************************************
*
*  --- these bounds are equivalent to the ones used for the standard Armington
*
   pmtUArmCom.lo(armComImpReg,armComPro,armComTCur) $ m_hasArmComImp(armComImpReg,armComPro)   = 1.E-3 * pmtUArmCom.l(armComImpReg,armComPro,"%armComt0%") ;
   xmtUArmCom.lo(armComImpReg,armComPro,armComTCur) $ m_hasArmComImp(armComImpReg,armComPro)   = 1.E-6 * xmtUArmCom.l(armComImpReg,armComPro,"%armComt0%") ;

   m_xwArmCom_lo(armComImpReg,armComPro,armComExpReg,armComTCur) $ p_amwCom(armComImpReg,armComPro,armComExpReg,armComTCur)
     = max(0,p_amwCom(armComImpReg,armComPro,armComExpReg,armComTCur));

