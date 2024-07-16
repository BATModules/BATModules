********************************************************************************
$ontext

   BatModel project

   GAMS file : melqual_decl.gms

   @purpose  : declaration part of Melitz model with quality

   @author   : Y. Jafari (yaghoob.jafari@i.r.uni-bonn.de)

   @date     : 13. Nov   2023
   @since    : 12. March 2023
   @refDoc   : A Computable General Equilibrium Theory of Heterogeneous Firms with Product Quality Differentiation
               https://www.gtap.agecon.purdue.edu/resources/res_display.asp?RecordID=6820
   @seeAlso  :
   @calledBy : test_melqual.gms


$offtext
********************************************************************************

 Parameters

   p_mq_sig             "Elasticity of substitution across goods"                             /3.8/
   p_mq_eta             "Demand elasticity"                                                   /2.0/
   p_mq_mu              "Supply elasticity"                                                   /0.5/
   p_mq_a               "Pareto shape parameter"                                              /4.6/
   p_mq_b               "Pareto lower support"                                                /0.5/

*  ---  quality elasticty with respect to prodcutvity should be above one to make sure that
*       quality is increasing with respect to productvity

   p_mq_psi             "Quality elasticity with respect to prodcutvity(default=0.7)"         /0.7/

*  --- the elasticity of taste with respec to quality intuitivaly
*      should be greater than one

   p_mq_gama             "Elasticty of taste/apprecition for quality( with respect to GDP)"    /1.5/

*  --- Marginal cost elastcity of below 1 ensure that the costs ar enot increasing
*      excessively fast

   p_mq_beta                             "Marginal cost elastcity of quality"                 /0.5/

   p_mq_Q0(%i_mq%,%r_mq%)                "Benchmark aggregate quantity"
   p_mq_P0(%i_mq%,%r_mq%)                "Benchmark price index"
   p_mq_MFirmsEnt0(%i_mq%,%r_mq%)        "Benchmark number of entered firms"
   p_mq_NFirmsOp0(%i_mq%,%r_mq%,%s_mq%)  "Benchmark number of operating firms"
   p_mq_qFirm0(%i_mq%,%r_mq%,%s_mq%)     "Benchmark avg firm-level quantity"
   p_mq_pFirm0(%i_mq%,%r_mq%,%s_mq%)     "Benchmark avg firm-level pricing (gross)"
   p_mq_phiFirm0(%i_mq%,%r_mq%,%s_mq%)   "Benchmark avg productivity"
   p_mq_c0(%i_mq%,%r_mq%)                "Benchmark input cost"
   p_mq_Y0(%i_mq%,%r_mq%)                "Benchmark input supply"
   p_mq_fCost(%i_mq%,%r_mq%,%s_mq%)      "Bilateral fixed costs"
   p_mq_delt_fs(%i_mq%,%r_mq%)           "Annualized sunk cost"
   p_mq_tau(%i_mq%,%r_mq%,%s_mq%)        "Iceberg transport cost factor"
   p_mq_vx0(%i_mq%,%r_mq%,%s_mq%)        "Arbitrary benchmark export values"
   p_mq_GDP0(%r_mq%)                     "Benchmark GDP"
   p_mq_quality0(%i_mq%,%r_mq%,%s_mq%)   "Benchmark average quality"
   p_mq_tast0(%r_mq%)                    "Benchmark taste"
   p_mq_Btast0(%r_mq%)                   "Constant benchmark taste"
   p_mq_lambda(%i_mq%,%r_mq%,%s_mq%)     "Preference parameters not related to prodcut quality"
   p_mq_lab(%r_mq%)                      "Labor supply"
   p_mq_PcGdp0(%r_mq%)                   "Per capita regional income/per capita GDP"
   p_mq_WELF0(%r_mq%)                    "Welfare"
   p_mq_impTax(%i_mq%,%r_mq%,%s_mq%)     "Bilateral AVE tariffs"
 ;

  Positive Variables
    v_mq_Q(%i_mq%,%r_mq%,%t_mq%)               "Composite Quantity"
    v_mq_P(%i_mq%,%r_mq%,%t_mq%)               "Composite price index"
    v_mq_MFirmsEnt(%i_mq%,%r_mq%,%t_mq%)       "Number of Entered firms"
    v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%) "Number of Operating firms (varieties,%t_mq%)"
    v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    "Avg Firm output in s-market"
    v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    "Avg Firm (gross,%t_mq%) pricing in s-market"
    v_mq_phiFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  "Avg Firm productivity"
    v_mq_c(%i_mq%,%r_mq%,%t_mq%)               "Composite input price (marginal cost,%t_mq%)"
    v_mq_Y(%i_mq%,%r_mq%,%t_mq%)               "Composite input supply (output,%t_mq%)"
    v_mq_GDP(%r_mq%,%t_mq%)                    "Nominal income variable(GDP,%t_mq%)"
    v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%)  "Average Firm prodcut quality"
    v_mq_tast(%r_mq%,%t_mq%)                   "Taste"
    v_mq_WELF(%r_mq%,%t_mq%)                   "Welfare"
    v_mq_PcGdp(%r_mq%,%t_mq%)                  "Per capita income"
  ;

  Equations
    e_mq_DEM(%i_mq%,%r_mq%,%t_mq%)            "Aggregate demand"
    e_mq_DS(%i_mq%,%r_mq%,%t_mq%)             "Dixit-Stiglitz price index"
    e_mq_FE(%i_mq%,%r_mq%,%t_mq%)             "Free entry"
    e_mq_ZCP(%i_mq%,%r_mq%,%s_mq%,%t_mq%)     "Zero cutoff profits"
    e_mq_DEMF(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    "Firm demand"
    e_mq_MKUP(%i_mq%,%r_mq%,%s_mq%,%t_mq%)    "Optimal firm pricing"
    e_mq_PAR(%i_mq%,%r_mq%,%s_mq%,%t_mq%)     "Pareto Productivity"
    e_mq_MKT(%i_mq%,%r_mq%,%t_mq%)            "Input market clearance"
    e_mq_SUP(%i_mq%,%r_mq%,%t_mq%)            "Input supply (output,%t_mq%)"
    e_mq_BC(%r_mq%,%t_mq%)                    "Budget constraint"
    e_mq_Quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%) "Quality prodcution function"
    e_mq_APP(%r_mq%,%t_mq%)                   "Appreciation for quality"
    e_mq_WLF(%r_mq%,%t_mq%)                   "Welfare function"
    e_mq_PC(%r_mq%,%t_mq%)                    "Per capita income"
  ;

* --- Aggregate demand

  e_mq_DEM(%i_mq%,%r_mq%,%t_mq%) ..

    v_mq_Q(%i_mq%,%r_mq%,%t_mq%) =E= v_mq_GDP(%r_mq%,%t_mq%)*(p_mq_P0(%i_mq%,%r_mq%)/v_mq_P(%i_mq%,%r_mq%,%t_mq%))**p_mq_eta;

* --- Dixit-Stiglitz price index

  e_mq_DS(%i_mq%,%s_mq%,%t_mq%) ..

    v_mq_P(%i_mq%,%s_mq%,%t_mq%) =E= sum(%r_mq%, p_mq_lambda(%i_mq%,%r_mq%,%s_mq%)*v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                                          *(v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**(p_mq_tast0(%r_mq%)*(p_mq_sig-1)))
                                          *(v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**(1-p_mq_sig)))**(1/(1-p_mq_sig));

* --- Bilateral firm-level demand

  e_mq_DEMF(%i_mq%,%r_mq%,%s_mq%,%t_mq%) ..

    v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%) =E= p_mq_lambda(%i_mq%,%r_mq%,%s_mq%)*v_mq_Q(%i_mq%,%s_mq%,%t_mq%)
                                          *(v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**(p_mq_tast0(%r_mq%)*(p_mq_sig-1)))
                                          *(v_mq_P(%i_mq%,%s_mq%,%t_mq%)/v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%))**p_mq_sig;

* --- Markup Condition

  e_mq_MKUP(%i_mq%,%r_mq%,%s_mq%,%t_mq%)..

    (1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_tau(%i_mq%,%r_mq%,%s_mq%)
      * v_mq_c(%i_mq%,%r_mq%,%t_mq%)*(v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**p_mq_beta)/v_mq_phiFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
       =E= (1 - 1/p_mq_sig)*v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%);

* --- Zero Profits

  e_mq_ZCP(%i_mq%,%r_mq%,%s_mq%,%t_mq%) ..

    v_mq_c(%i_mq%,%r_mq%,%t_mq%)*p_mq_fCost(%i_mq%,%r_mq%,%s_mq%) =E=
            (v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)*v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
            /((1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_sig))
            * ((p_mq_a+1-p_mq_sig)/p_mq_a)**(1 +  (p_mq_psi/(1-p_mq_sig))
                                                 *(((p_mq_sig-1)*p_mq_tast0(%r_mq%))+ (p_mq_beta *(1-p_mq_sig))));

* --- Free Entry

  e_mq_FE(%i_mq%,%r_mq%,%t_mq%) ..

    v_mq_c(%i_mq%,%r_mq%,%t_mq%)*p_mq_delt_fs(%i_mq%,%r_mq%) =E=
           sum(%s_mq%,  (v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%)/v_mq_MFirmsEnt(%i_mq%,%r_mq%,%t_mq%))
                       *  ((v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)*v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                         /((1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%))*p_mq_sig))
                          - (v_mq_c(%i_mq%,%r_mq%,%t_mq%)*p_mq_fCost(%i_mq%,%r_mq%,%s_mq%))));

*---- Prodcutvity of representative firm
*     The productvity is arbitrary increased by 1 to insure that quality is a monotoinic function
*     of prodcutvity in 'Quality Prodcution Function'


  e_mq_PAR(%i_mq%,%r_mq%,%s_mq%,%t_mq%) ..

    v_mq_phiFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%) - 1
        =E=  p_mq_b * (p_mq_a/(p_mq_a+1-p_mq_sig))**(1/(p_mq_sig-1))
                    * (v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%)/v_mq_MFirmsEnt(%i_mq%,%r_mq%,%t_mq%))**(-1/p_mq_a);

* --- Composite input Market Clearing

  e_mq_MKT(%i_mq%,%r_mq%,%t_mq%) ..

    v_mq_Y(%i_mq%,%r_mq%,%t_mq%) =E= p_mq_delt_fs(%i_mq%,%r_mq%)*v_mq_MFirmsEnt(%i_mq%,%r_mq%,%t_mq%)
                             + sum(%s_mq%, v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                                         *(  p_mq_fCost(%i_mq%,%r_mq%,%s_mq%)
                                          + ( p_mq_tau(%i_mq%,%r_mq%,%s_mq%)*v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                                             *v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**p_mq_beta)/v_mq_phiFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)));

* --- Factor supply (Considering only one input: labor cost = unit input cost)

  e_mq_SUP(%i_mq%,%r_mq%,%t_mq%) ..

    v_mq_Y(%i_mq%,%r_mq%,%t_mq%) =E= p_mq_Y0(%i_mq%,%r_mq%) * (v_mq_c(%i_mq%,%r_mq%,%t_mq%)/p_mq_c0(%i_mq%,%r_mq%)**p_mq_mu);

* --- Budget constraint

  e_mq_BC(%r_mq%,%t_mq%) ..

    v_mq_GDP(%r_mq%,%t_mq%) =e=
*                        --- factor income
                         sum(%i_mq%,v_mq_c(%i_mq%,%r_mq%,%t_mq%))*p_mq_lab(%r_mq%)
*                        --- tariff revenue
                        + sum((%s_mq%,%i_mq%), p_mq_impTax(%i_mq%,%r_mq%,%s_mq%)
                                                * v_mq_pFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                                                * v_mq_qFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)*v_mq_NFirmsOp(%i_mq%,%r_mq%,%s_mq%,%t_mq%)
                                                 /(1+p_mq_impTax(%i_mq%,%r_mq%,%s_mq%)));

* --- Per capita income ("1" is added in equation below to prevent devision
*     by zero in "Appreciation for quality")

  e_mq_PC (%r_mq%,%t_mq%) ..

    v_mq_PcGdp(%r_mq%,%t_mq%) =e= 1 + v_mq_GDP(%r_mq%,%t_mq%)/p_mq_lab(%r_mq%);

* --- Quality prodcution function

  e_mq_Quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%) ..

    v_mq_quality(%i_mq%,%r_mq%,%s_mq%,%t_mq%) =E= v_mq_phiFirm(%i_mq%,%r_mq%,%s_mq%,%t_mq%)**p_mq_psi;

* ---- Appreciation for quality

  e_mq_APP(%r_mq%,%t_mq%) ..

    v_mq_tast(%r_mq%,%t_mq%) =E= p_mq_Btast0(%r_mq%) * (log(v_mq_PcGdp(%r_mq%,%t_mq%))/log(p_mq_PcGdp0(%r_mq%)))**p_mq_gama;

*---- Welfare function measured as nominal income deflated by the price index

  e_mq_WLF(%r_mq%,%t_mq%)..

    v_mq_WELF(%r_mq%,%t_mq%) =E= v_mq_GDP(%r_mq%,%t_mq%)/sum(%i_mq%, v_mq_P(%i_mq%,%r_mq%,%t_mq%));

  model m_melQual /
      e_mq_DEM.v_mq_P
      e_mq_DS.v_mq_Q
      e_mq_FE.v_mq_MFirmsEnt
      e_mq_ZCP.v_mq_NFirmsOp
      e_mq_DEMF.v_mq_PFirm
      e_mq_MKUP.v_mq_QFirm
      e_mq_PAR.v_mq_PhiFirm
      e_mq_MKT.v_mq_c
      e_mq_SUP.v_mq_Y
      e_mq_BC.v_mq_GDP
      e_mq_PC.v_mq_PcGdp
      e_mq_quality.v_mq_quality
      e_mq_APP.v_mq_tast
      e_mq_WLF.v_mq_WELF
   /;

  m_melQual.limcol  = 0;
  m_melQual.limrow  = 0;
