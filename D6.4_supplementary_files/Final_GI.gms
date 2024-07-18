$ontext

   @BATModel project
   @GAMS file : BATModel_GI_Split
   @purpose  : Split BATModel agifood commodities and sectors into GI and noGI
               
   @author   : CASE BATModel team
   @date     : 19.10.2021
   @since    :2021
   @refDoc   :
   @seeAlso  :
   @calledBy : build\split.gms

$offtext
********************************************************************************

$iftheni.decl1 "%1"=="decl"

   set s_spliti / chees_GI-c      "Cheese under GI"
                  chees_noGI-c    "Rest of Cheese"
                  Pigmeat_GI-c    "Pigmeat under GI"
                  Pigmeat_noGI-c  "Rest of Pigmeat"
                  bovMe_GI-c      "Bovine meat under GI"
                  bovMe_noGI-c    "Rest of bovine meat products"
                  PoulMeat_GI-c   "Poultry meat under GI"
                  PoulMeat_noGI-c "Rest of poultry meat"
                  butt_GI-c       "butter under GI"
                  butt_noGI-c     " Rest of butter products"
                  /;
$ONTEXT                  

                  
                  butt_GI-c       "butter under GI"
                  butt_noGI-c     "Rest of butter"
                  bovMe_GI-c      "Bovine meat under GI"
                  bovMe_noGI-c    "Rest of bovine meat products"
                  PoulMeat_GI-c   "Poultry meat under GI"
                  PoulMeat_noGI-c "Rest of poultry meat"/;
$OFFTEXT
                  

 set s_splita /   chees_GI-a      "Cheese under GI production"
                  chees_noGI-a    "Rest of Cheese production"
                  Pigmeat_GI-a    "Pigmeat under GI production"
                  Pigmeat_noGI-a  "Rest of Pigmeat production"
                  bovMe_GI-a       "Bovine meat under GI"
                  bovMe_noGI-a     "Rest of bovine meat products"
                  PoulMeat_GI-a    "Poultry meat under GI production"
                  PoulMeat_noGI-a  "Rest of poultry meat production"
                  butt_GI-a       "butter under GI production"
                  butt_noGI-a     "Rest of butter production"/;
$ONTEXT
                  
                  butt_GI-a       "butter under GI production"
                  butt_noGI-a     "Rest of butter production"
                  bovMe_GI-a       "Bovine meat under GI"
                  bovMe_noGI-a     "Rest of bovine meat products"
                  PoulMeat_GI-a    "Poultry meat under GI production"
                  PoulMeat_noGI-a  "Rest of poultry meat production"/;
$OFFTEXT
                  

set i_a(*,*) /    chees_GI-c.chees_GI-a,     
                  chees_noGI-c.chees_noGI-a,
                  Pigmeat_GI-c.Pigmeat_GI-a,
                  Pigmeat_noGI-c.Pigmeat_noGI-a,
                  bovMe_GI-c.bovMe_GI-a,
                  bovMe_noGI-c.bovMe_noGI-a
                  PoulMeat_GI-c.PoulMeat_GI-a,
                  PoulMeat_noGI-c.PoulMeat_noGI-a,
                  butt_GI-c.butt_GI-a ,      
                  butt_noGI-c.butt_noGI-a/;
                  
$ONTEXT                  
                  
                  butt_GI-c.butt_GI-a ,      
                  butt_noGI-c.butt_noGI-a
                  bovMe_GI-c.bovMe_GI-a,
                  bovMe_noGI-c.bovMe_noGI-a
                  PoulMeat_GI-c.PoulMeat_GI-a,
                  PoulMeat_noGI-c.PoulMeat_noGI-a/;
$OFFTEXT
                  

set i_a(*,*)   / (chees_GI-a,chees_noGI-a).ches-a
               (Pigmeat_GI-a,Pigmeat_noGI-a).Pigmeat-a
                (bovMe_GI-a,bovMe_noGI-a).bovMe-a
                (PoulMeat_GI-a,PoulMeat_noGI-a).PoulMeat-a
                (butt_GI-a,butt_noGI-a).butt-a/;
$ONTEXT
               
               (butt_GI-a,butt_noGI-a).butt-a
               (bovMe_GI-a,bovMe_noGI-a).bovMe-a
               (PoulMeat_GI-a,PoulMeat_noGI-a).PoulMeat-a/;
$OFFTEXT


set is_i(*,*) /(chees_GI-c,chees_noGI-c).ches-c
              (Pigmeat_GI-c,Pigmeat_noGI-c).Pigmeat-c
             (bovMe_GI-c,bovMe_noGI-c).bovMe-c
              (PoulMeat_GI-c,PoulMeat_noGI-c).PoulMeat-c
              (butt_GI-c,butt_noGI-c).butt-c/ ;

$ONTEXT /(butt_GI-c,butt_noGI-c).butt-c /;

$OFFTEXT

set diagIO / set.s_splitA /;
         
$elseifi.decl1    "%1"=="run"

set GIi(s_spliti) /chees_GI-c ,Pigmeat_GI-c,bovMe_GI-c,PoulMeat_GI-c, butt_GI-c/;
set noGIi(s_spliti) /chees_noGI-c,Pigmeat_noGI-c,bovMe_noGI-c,PoulMeat_noGI-c, butt_noGI-c/;


set GIa(s_splita) /chees_GI-a,Pigmeat_GI-a,bovMe_GI-a ,PoulMeat_GI-a , butt_GI-a/;
set noGIa(s_splita) /chees_noGI-a ,Pigmeat_noGI-a,bovMe_noGI-a,PoulMeat_noGI-a, butt_noGI-a/;

*************************************Include outputs share data
* --- use that set to indicate that intermediate Output of the split industry
*     for its own Output should only comprise the combination of split commodity
*     and split activity, typicaly case is seed use

*set diagIO / set.s_splitA /;
set rGI(rNat) /FRA,ITA,DEU,PRT,ESP/;
*set rNoGI(rnat) /REU28,ROW,USA/;

*****************************$ontext output_share
Parameter outputshare(rNat,s_splita) 'GIs Output share';
execute_load "%datdir%/output2.gdx" outputshare;
p_splitFactor(rGI,GIa,"prod") $ (outputshare(rGI,GIa) gt 1.E-6)   = outputshare(rGI,GIa);
p_splitFactor(rGI,noGIa,"prod")$(outputshare(rGI,noGIa) gt 1.E-6)   = outputshare(rGI,noGIa);
*p_splitFactor(rNoGI,GIa, "prod")   = EPS;
*p_splitFactor(rNoGI,noGIa,"prod")  = 1-EPS;

$else.decl1

display p_splitFactor;
$endif.decl1

*$offtext