********************************************************************************
$ontext

   CAPRI project

   GAMS file : MELQUAL_BOUNDS.GMS

   @purpose  : Set bounds for Melitz-quality model
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

 v_mq_Q.lo(%i_mq%,%r_mq%,%t_mq%)               = 1e-6;
 v_mq_P.lo(%i_mq%,%r_mq%,%t_mq%)               = 1e-6;
 v_mq_MFirmsEnt.lo(%i_mq%,%r_mq%,%t_mq%)       = 1e-6;
 v_mq_NFirmsOp.lo(%i_mq%,%r_mq%,%s_mq%,%t_mq%) = 1e-6;
 v_mq_QFirm.lo(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    = 1e-6;
 v_mq_PFirm.lo(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    = 1e-6;
 v_mq_PhiFirm.lo(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  = 1e-6;
 v_mq_Y.lo(%i_mq%,%r_mq%,%t_mq%)               = 1e-6;
 v_mq_WELF.lo(%r_mq%,%t_mq%)                   = 1e-6;
 v_mq_quality.lo(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  = 1e-6;
 v_mq_tast.lo(%r_mq%,%t_mq%)                   = 1e-6;
 v_mq_Gdp.lo(%r_mq%,%t_mq%)                    = 1e-6;
 v_mq_PcGdp.lo(%r_mq%,%t_mq%)                  = 1e-6;
 v_mq_C.lo(%i_mq%,%r_mq%,%t_mq%)               = 1e-6;

