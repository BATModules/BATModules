********************************************************************************
$ontext

   CAPRI project

   GAMS file : melqual_ini.gms

   @purpose  : Benchmarking part of Melitz model with quality

   @author   : Y. Jafari (yaghoob.jafari@i.r.uni-bonn.de)

   @date     : 13. Nov   2023
   @since    : 12. March 2023
   @refDoc   : A Computable General Equilibrium Theory of Heterogeneous Firms with Product Quality Differentiation
               https://www.gtap.agecon.purdue.edu/resources/res_display.asp?RecordID=6820
   @seeAlso  :
   @calledBy : test_melqual.gms

$offtext
********************************************************************************
*
* --- Calibrate the value of p_mq_Y0(%i_mq%,%r_mq%) based on
*      sum(%s_mq%, p_mq_vx0(%i_mq%,%r_mq%,%s_mq%))= p_mq_P0(%i_mq%,%r_mq%)*p_mq_Q0(%i_mq%,%r_mq%)

  p_mq_c0(%i_mq%,%r_mq%)           =  1 ;
  p_mq_Y0(%i_mq%,%r_mq%)           = sum(%s_mq%, p_mq_vx0(%i_mq%,%r_mq%,%s_mq%))/p_mq_c0(%i_mq%,%r_mq%) ;
  p_mq_MFirmsEnt0(%i_mq%,%r_mq%)   = 10 ;
  p_mq_NFirmsOp0(%i_mq%,%r_mq%,%r_mq%)  = 9 ;

  p_mq_P0(%i_mq%,%r_mq%)           = 1 ;
  p_mq_Q0(%i_mq%,%r_mq%)           = sum(%s_mq%, p_mq_vx0(%i_mq%,%s_mq%,%r_mq%))/p_mq_P0(%i_mq%,%r_mq%) ;

* --- Assume that foreign operation falls off using the following
  p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)  = (p_mq_vx0(%i_mq%,%r_mq%,%s_mq%)/p_mq_vx0(%i_mq%,%r_mq%,%r_mq%))**2
                                         * p_mq_NFirmsOp0(%i_mq%,%r_mq%,%r_mq%);

* --- Labor endowment

  p_mq_lab(%r_mq%) = sum(%i_mq%,p_mq_Q0(%i_mq%,%r_mq%)) ;

* --- Budget constraint

  p_mq_GDP0(%r_mq%)   = sum(%i_mq%,p_mq_c0(%i_mq%,%r_mq%))*p_mq_lab(%r_mq%);

* --- Calibrated based on per capita income function (below "1" is used to prevent devision
*     by zero when "appreciation for quality" is defined

  p_mq_PcGdp0(%r_mq%)= 1 + p_mq_GDP0(%r_mq%)/p_mq_lab(%r_mq%) ;

* --- Appreciation for quality

  p_mq_Btast0(%r_mq%) =  1  ;
  p_mq_tast0(%r_mq%) = p_mq_Btast0(%r_mq%)* (log(p_mq_PcGdp0(%r_mq%))/log(p_mq_PcGdp0(%r_mq%)))**p_mq_gama ;

* --- Calibrate benchmark productvity based on Pareto Productivity equation
*      the productvity is arbitrary increased by 1 to insure that quality is a monotonic function of productvity in 'Quality Production Function'

  p_mq_phiFirm0(%i_mq%,%r_mq%,%s_mq%)= 1+  p_mq_b * (p_mq_a/(p_mq_a+1-p_mq_sig))**(1/(p_mq_sig-1)) *
       (p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)/p_mq_MFirmsEnt0(%i_mq%,%r_mq%))**(-1/p_mq_a);

* --- Calibrate the benchmark quality based on quality production function

  p_mq_quality0(%i_mq%,%r_mq%,%s_mq%) = p_mq_phiFirm0(%i_mq%,%r_mq%,%s_mq%)**p_mq_psi;

* --- Calibrated from Dixit-Stiglitz Price index
*      The calibration is based on trade identity: p_mq_vx0(%i_mq%,%r_mq%,%s_mq%)
*        = p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)*p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)*p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)
*      and the value of p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%) in firm demand equation

  p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%) = ( p_mq_vx0(%i_mq%,%r_mq%,%s_mq%)
                                      /(p_mq_lambda(%i_mq%,%r_mq%,%s_mq%)*p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)*
                                        p_mq_Q0(%i_mq%,%s_mq%)*(p_mq_quality0(%i_mq%,%r_mq%,%s_mq%)**(p_mq_tast0(%r_mq%)*(p_mq_sig-1))))
                                      )**(1/(1-p_mq_sig));

* --- Calibrate benchmark prices based on bilateral firm demand equation and that the
*     value of P in the related equation is one.

  p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%) =   p_mq_lambda(%i_mq%,%r_mq%,%s_mq%) * p_mq_Q0(%i_mq%,%s_mq%)
                                      * (p_mq_quality0(%i_mq%,%r_mq%,%s_mq%)**(p_mq_tast0(%r_mq%)*(p_mq_sig-1)))
                                      * p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)**(-p_mq_sig);

* --- Calibrate based on the zero profit equation

  p_mq_fCost(%i_mq%,%r_mq%,%s_mq%) = (p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)*p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)
                                      /((1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_sig))
                                    *((p_mq_a+1-p_mq_sig)/p_mq_a)
                                       **(1+(p_mq_psi/(1-p_mq_sig))*(((p_mq_sig-1)*p_mq_tast0(%r_mq%))+(p_mq_beta *(1-p_mq_sig))));

* --- Calibrated based on free entry equation

  p_mq_delt_fs(%i_mq%,%r_mq%) =
           sum(%s_mq%,(p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)/p_mq_MFirmsEnt0(%i_mq%,%r_mq%))
               *((p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)*p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)
               /((1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_sig)) - (p_mq_c0(%i_mq%,%r_mq%)*p_mq_fCost(%i_mq%,%r_mq%,%s_mq%))));

* --- Calibrated based on markup pricing condition

  p_mq_tau(%i_mq%,%r_mq%,%s_mq%) =  (1 - 1/p_mq_sig)*p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)
                                  * p_mq_phiFirm0(%i_mq%,%r_mq%,%s_mq%)
                                  /((1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_c0(%i_mq%,%r_mq%)
                                                                         *p_mq_quality0(%i_mq%,%r_mq%,%s_mq%)**p_mq_beta);

* --- Calibrated based on welfare function

  p_mq_WELF0(%r_mq%) = p_mq_GDP0(%r_mq%)/sum(%i_mq%, p_mq_P0(%i_mq%,%r_mq%));

* --- Set the level values and check for benchmark consistency

  v_mq_Q.l(%i_mq%,%r_mq%,%t_mq%)               =  p_mq_Q0(%i_mq%,%r_mq%);
  v_mq_P.l(%i_mq%,%r_mq%,%t_mq%)               =  p_mq_P0(%i_mq%,%r_mq%);
  v_mq_MFirmsEnt.l(%i_mq%,%r_mq%,%t_mq%)       =  p_mq_MFirmsEnt0(%i_mq%,%r_mq%);
  v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%) =  p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%);
  v_mq_QFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    =  p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%);
  v_mq_PFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    =  p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%);
  v_mq_PhiFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  =  p_mq_phiFirm0(%i_mq%,%r_mq%,%s_mq%);
  v_mq_c.l(%i_mq%,%r_mq%,%t_mq%)               =  p_mq_c0(%i_mq%,%r_mq%);
  v_mq_Y.l(%i_mq%,%r_mq%,%t_mq%)               =  p_mq_Y0(%i_mq%,%r_mq%);
  v_mq_WELF.l(%r_mq%,%t_mq%)                   =  p_mq_WELF0(%r_mq%);
  v_mq_quality.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  =  p_mq_quality0(%i_mq%,%r_mq%,%s_mq%);
  v_mq_tast.l(%r_mq%,%t_mq%)                   =  p_mq_tast0(%r_mq%);
  v_mq_pcGdp.l(%r_mq%,%t_mq%)                  =  p_mq_PcGdp0(%r_mq%);

* --- add the level value of income (Note: p_mq_P0(%i_mq%,%r_mq%)= 1)

  v_mq_Gdp.l(%r_mq%,%t_mq%)   =  sum(%i_mq%,p_mq_Q0(%i_mq%,%r_mq%))
                               + sum((%s_mq%,%i_mq%), p_mq_impTax(%i_mq%,%r_mq%,%s_mq%)*p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)
                                              *p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)
                                              *p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)/(1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%)));


