********************************************************************************
$ontext

   BatModel project

   GAMS file : MELITZ_QUALITY.GMS

   @purpose  : Introducing prodcut quality differentiation in CGEs based on Melitz trade model.
               Note: This is the Melitz Trade Equilibrium with Iceberg Costs and Quality Differentiation. It is is a one sector , multi regional general equilibrium.
               The solution only works when there is only one sector (h has only G1).
               if we want a multisector model we need to have a WELFity function.  All income is spent on G1 in this case.

               The model will basicaly be equaivalent to Melitz model if the parameter p_emqual_psi is set to zero.

   @author   : Y. Jafari (yaghoob.jafari@i.r.uni-bonn.de)

   @date     : 13. Nov   2023
   @since    : 12. March 2023
   @refDoc   : A Computable General Equilibrium Theory of Heterogeneous Firms with Product Quality Differentiation
               https://www.gtap.agecon.purdue.edu/resources/res_display.asp?RecordID=6820
   @seeAlso  :
   @calledBy :


$offtext
********************************************************************************
$offlisting
$Offsymlist

  Sets
   r        "Countries or regions" /R1,R2,R3/
   i        "Goods"                /G1/
   t        "Time points"          /bench/
  ;
  Alias (r,s);
*
* --- globals for names of trade regions and products
*
  $$setglobal r_mq r
  $$setglobal s_mq s
  $$setglobal i_mq i
  $$setglobal t_mq t

  $$setglobal melQual_useBounds on
*
* --- declaration
*
  $$include 'melqual_decl.gms'
*
* --- Assumed parameter values
*
  p_mq_lambda(%i_mq%,%r_mq%,%s_mq%) =  1 ;
  p_mq_vx0(%i_mq%,%r_mq%,%s_mq%)    =  1 ;
  p_mq_vx0(%i_mq%,%r_mq%,%r_mq%)    =  3 ;
  p_mq_impTax(%i_mq%,%r_mq%,%s_mq%) $ (not sameAs(r,%s_mq%)) = 0.0  ;
*
* --- benchmarking and intialization
*
  $$include 'melqual_ini.gms'

* --- Finite variance restriction

  Abort $(p_mq_a le (p_mq_sig - 1)) "Firm size distribution must have a finite variance" ;

  $$ifi "%melQual_useBounds%"=="on" $include 'melqual_setbounds.gms'
*
* --- benchmark check
*
  m_melQual.iterlim = 0;
  Solve m_melQual using CNS;
  Abort $ (m_melQual.numInfes > 1e-6) "Benchmark replication Failed";

* --- Counterfactual analysis
*     Arbitrary increase of tariffs

  p_mq_impTax(%i_mq%,"R1","R2") =  0.10;
  p_mq_impTax(%i_mq%,"R2","R1") =  0.10;

  m_melQual.iterlim = 1000;
  Solve m_melQual using CNS;
  Abort $ (m_melQual.numInfes > 1e-6) "Test shock run failed";

  $$ifi "%melQual_useBounds%"=="on" $include 'melqual_delbounds.gms'

  Display p_mq_impTax,p_mq_tau,v_mq_c.l,v_mq_quality.l,v_mq_PhiFirm.l,v_mq_PFirm.l, v_mq_MFirmsEnt.l, v_mq_nFirmsOp.l;

  parameters
    p_mq_Report
    p_mq_Result
  ;

  p_mq_report("tradeValue",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas")       = p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%);
  p_mq_report("tradeValue",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")        = v_mq_QFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_PFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%);
  p_mq_result("tradeValue",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"%ch")    = [(p_mq_report("tradeValue",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")/p_mq_report("tradeValue",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas"))-1]*100;

  p_mq_report("totalSale",%i_mq%,%r_mq%,"*",%t_mq%,"bas")           = sum(%s_mq%,p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%));
  p_mq_report("totalSale",%i_mq%,%r_mq%,"*",%t_mq%,"sim")            = sum(%s_mq%,v_mq_QFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_PFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%));
  p_mq_result("totalSale",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")        = [(p_mq_report("totalSale",%i_mq%,%r_mq%,"*",%t_mq%,"sim")/p_mq_report("totalSale",%i_mq%,%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  p_mq_report("tradeVolume",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas")      = p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%);
  p_mq_report("tradeVolume",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")       = v_mq_QFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%);
  p_mq_result("tradeVolume",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"%ch")   = [(p_mq_report("tradeVolume",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")/p_mq_report("tradeVolume",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas"))-1]*100;

  p_mq_report("totalSaleVolume",%i_mq%,%r_mq%,"*",%t_mq%,"bas")     = sum (s, p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)* p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%));
  p_mq_report("totalSaleVolume",%i_mq%,%r_mq%,"*",%t_mq%,"sim")      = sum (s,v_mq_QFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%)* v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%));
  p_mq_result("totalSaleVolume",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")  = [(p_mq_report("totalSaleVolume",%i_mq%,%r_mq%,"*",%t_mq%,"sim")/p_mq_report("totalSaleVolume",%i_mq%,%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  p_mq_report("tradePrice",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas")       = p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%);
  p_mq_report("tradePrice",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")        = v_mq_PFirm.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%);
  p_mq_result("tradePrice",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"%ch")    = [(p_mq_report("tradePrice",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")/p_mq_report("tradePrice",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas"))-1]*100;

  p_mq_report("tradeVarities",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas")    = p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%);
  p_mq_report("tradeVarities",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")     = v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%);
  p_mq_result("tradeVarities",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"%ch") = [(p_mq_report("tradeVarities",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"sim")/p_mq_report("tradeVarities",%i_mq%,%r_mq%,%s_mq%,%t_mq%,"bas"))-1]*100;

  p_mq_report("totalVariety",%i_mq%,%r_mq%,"*",%t_mq%,"bas")        = sum(%s_mq%,p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%));
  p_mq_report("totalVariety",%i_mq%,%r_mq%,"*",%t_mq%,"sim")         = sum(%s_mq%,v_mq_NFirmsOp.l(%i_mq%,%r_mq%,%s_mq%,%t_mq%));
  p_mq_result("totalVariety",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")     = [(p_mq_report("totalVariety",%i_mq%,%r_mq%,"*",%t_mq%,"sim")/p_mq_report("totalVariety",%i_mq%,%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  p_mq_report("Welfare","*",%r_mq%,"*",%t_mq%,"bas")                = p_mq_WELF0(%r_mq%);
  p_mq_report("Welfare","*",%r_mq%,"*",%t_mq%,"sim")                 = v_mq_WELF.l(%r_mq%,%t_mq%);
  p_mq_result("Welfare",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")          = [(p_mq_report("Welfare","*",%r_mq%,"*",%t_mq%,"sim")/p_mq_report("Welfare","*",%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  p_mq_report("Price",%i_mq%,%r_mq%,"*",%t_mq%,"bas")               = p_mq_P0(%i_mq%,%r_mq%);
  p_mq_report("Price",%i_mq%,%r_mq%,"*",%t_mq%,"sim")                = v_mq_P.l(%i_mq%,%r_mq%,%t_mq%);
  p_mq_result("Price",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")            = [(p_mq_report("Price",%i_mq%,%r_mq%,"*",%t_mq%,"sim")/p_mq_report("Price",%i_mq%,%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  p_mq_report("Quantity",%i_mq%,%r_mq%,"*",%t_mq%,"bas")            = p_mq_Q0(%i_mq%,%r_mq%);
  p_mq_report("Quantity",%i_mq%,%r_mq%,"*",%t_mq%,"sim")             = v_mq_Q.l(%i_mq%,%r_mq%,%t_mq%);
  p_mq_result("Quantity",%i_mq%,%r_mq%,"*",%t_mq%,"%ch")         = [(p_mq_report("Quantity",%i_mq%,%r_mq%,"*",%t_mq%,"sim")/p_mq_report("Quantity",%i_mq%,%r_mq%,"*",%t_mq%,"bas"))-1]*100;

  option decimals = 6;
  option  p_mq_report:2:4:1;
  option  p_mq_result:2:4:1;
  display p_mq_result,p_mq_report;

  execute_unload 'results.gdx' p_mq_result,p_mq_report;
