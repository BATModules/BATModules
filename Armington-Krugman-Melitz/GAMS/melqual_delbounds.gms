********************************************************************************
$ontext

   CAPRI project

   GAMS file : MELQUAL_BOUNDS.GMS

   @purpose  : Delete bounds for Melitz-quality model
   @author   : Y. Jafari (yaghoob.jafari@i.r.uni-bonn.de)

   @date     : 13. Nov   2023
   @since    : 12. March 2023
   @refDoc   : A Computable General Equilibrium Theory of Heterogeneous Firms with Product Quality Differentiation
               https://www.gtap.agecon.purdue.edu/resources/res_display.asp?RecordID=6820
   @seeAlso  :
   @calledBy : test_melqual.gms
$offtext
********************************************************************************

*---- Set lower bounds to avoid bad function calls:
 option
  kill=v_mq_Q.lo,
  kill=v_mq_P.lo,
  kill=v_mq_MFirmsEnt.lo,
  kill=v_mq_NFirmsOp.lo,
  kill=v_mq_QFirm.lo,
  kill=v_mq_PFirm.lo,
  kill=v_mq_PhiFirm.lo,
  kill=v_mq_Y.lo,
  kill=v_mq_WELF.lo,
  kill=v_mq_quality.lo,
  kill=v_mq_tast.lo,
  kill=v_mq_Gdp.lo,
  kill=v_mq_PcGdp.lo,
  kill=v_mq_C.lo
;
