********************************************************************************
$ontext

   CGEBox project

   GAMS file : GIs_nest.GMS

   @purpose  : Nests in final demand for substitution between GI and noGI and some tech-nests for GI and noGI
   @author   :
   @date     : 04.01.24
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

**************define demand nest for GIs products

 set tot_cheese(i)  /   chees_GI-c  ,   chees_noGI-c /;
  dNest("cheese") = YES;
  dNest_i_fd("cheese",tot_cheese,fdn) = YES;
  dNest_n_fd("top","cheese",fdn)    = YES;
  dNest("cheese") = YES;
  p_sigmaFDNest(r,"cheese",fdn)     = 5;
  
set tot_PigMeat(i)  /Pigmeat_GI-c , Pigmeat_noGI-c /;
  dNest("PigMeat") = YES;
  dNest_i_fd("PigMeat",tot_PigMeat,fdn) = YES;
  dNest_n_fd("top","PigMeat",fdn)    = YES;
  dNest("PigMeat") = YES;
  p_sigmaFDNest(r,"PigMeat",fdn)     = 5;
  
  
set tot_PoulMeat(i)  /   PoulMeat_GI-c  ,   PoulMeat_noGI-c /;
  dNest("PoulMeat") = YES;
  dNest_i_fd("PoulMeat",tot_PoulMeat,fdn) = YES;
  dNest_n_fd("top","PoulMeat",fdn)    = YES;
  dNest("PoulMeat") = YES;
  p_sigmaFDNest(r,"PoulMeat",fdn)     = 5;
  

set tot_bovMe(i)  /bovMe_GI-c,bovMe_noGI-c /;
  dNest("bovMe") = YES;
  dNest_i_fd("bovMe",tot_bovMe,fdn) = YES;
  dNest_n_fd("top","bovMe",fdn)    = YES;
  dNest("bovMe") = YES;
  p_sigmaFDNest(r,"bovMe",fdn)     = 5;
  


****************************************PRODUCTION NEST
set rGI(rNat) /FRA,ITA,ESP,DEU,PRT/;
set rNoGI(rNat);

tNest("chees") = YES;
set GI_cheese(i)  /chees_GI-c  , chees_noGI-c /;
  tNest_n_a("ND","chees",a)  = YES;
  tNest_i_a("chees",GI_cheese,a) = YES;  
  p_sigmaNest(r,"chees",a)  = 5;


 tNest("bovine") = YES;
  set GI_bovine(i)  /bovMe_GI-c, bovMe_noGI-c /;
  tNest_n_a("ND","bovine",a)  = YES;
  tNest_i_a("bovine",GI_bovine,a) = YES;  
  p_sigmaNest(r,"bovine",a)  = 5;


 tNest("pigmeat") = YES;
  set GI_pigmeat(i)  /Pigmeat_GI-c , Pigmeat_noGI-c /;
  tNest_n_a("ND","pigmeat",a)  = YES;
  tNest_i_a("pigmeat",GI_pigmeat,a) = YES;  
  p_sigmaNest(r,"pigmeat",a)  = 5;


 tNest("Poultry") = YES;
  set GI_Poultry(i)  /PoulMeat_GI-c  ,   PoulMeat_noGI-c /;
  tNest_n_a("ND","Poultry",a)  = YES;
  tNest_i_a("Poultry",GI_Poultry,a) = YES;  
  p_sigmaNest(r,"Poultry",a)  = 5;


tNest("Butter") = YES;
  set GI_butter(i)  /butt_GI-c  , butt_noGI-c /;
  tNest_n_a("ND","Butter",a)  = YES;
  tNest_i_a("Butter",GI_Butter,a) = YES;  
  p_sigmaNest(r,"Butter",a)  = 5;





