********************************************************************************
$ontext

   CAPRI project

   GAMS file : SPLIT_DAIRY.GMS

   @purpose  :
   @author   :
   @date     : 22.04.21
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************


$iftheni.decl1 "%1"=="decl"

set desiredOrder /

pdr          "Paddy rice                                         "
wht          "Wheat                                              "
barl         "Barley                                             "
maiz         "Maiz                                               "
sorg         "Sorghum                                            "
oat          "Oats                                               "
rye          "Rye                                                "
ocer         "Other cereals                                      "
soy          "Soy bean                                           "
palm         "Palm oil fruit                                     "
rape         "Rape seed                                          "
olv          "Olives                                             "
oso          "Other oilseeds                                     "
pota         "Potatoes                                           "
rttb         "Other Roots and tubers                             "
leg          "Leguminosae                                        "
oveg         "Other Vegetables                                   "
toma         "Tomatoes                                           "
appl         "Apples                                             "
grap         "Grapes                                             "
citr         "Citrus fruits                                      "
banp         "Bananas and plantains                              "
ofru         "Other fruits                                       "
v_fo         "Rest of v_f                                        "
c_b          "Sugar cane, sugar beet                             "
pfb          "Plant-based fibers                                 "
coco         "Cocoa beans                                        "
teas         "Teas                                               "
coff         "Coffee beans                                       "
ocro         "Other crops                                        "
cattle       "Cattle for meat                                    "
orum         "Other ruminant for meat                            "
pig          "Pigs                                               "
poul         "Poultry birds and eggs                             "
oapo         "Other animal products                              "
rmk          "Raw milk                                           "
wol          "Wool, silk-worm cocoons                            "
frs          "Forestry                                           "
fsh          "Fishing                                            "
coa          "Coal                                               "
oil          "Oil                                                "
gas          "Gas                                                "
oxt          "Other Extraction (former omn)                      "
ctlMeat      "Cattle meat                                        "
orumMeat     "Other ruminant meat                                "
Pigmeat      "Pig meat                                           "
othMeat      "Other meat                                         "
olivOil      "Olive oil                                          "
palmOil      "Palm oil                                           "
soyCake      "Soybean cake                                       "
soyOil       "Soybean oil                                        "
rapCake      "Rape seed cake                                     "
rapOil       "Rape seed oil                                      "
volo         "Other vegetable oils and cakes                     "
dairy        "Dairy"
butt         "Butter"
ches         "Chees"
smp          "Skimmed milk powder"
wmp          "Whole milk powder"
whey         "Whey powder"
case         "Casein"
milo         "Other dairy"
pcr          "Processed rice                                     "
sgr          "Sugar                                              "
ofdAnim      "Feed concentrates                                  "
ofdOther     "Other food processing                              "
b_t          "Beverages and tobacco products                     "
tex          "Textiles                                           "
wap          "Wearing apparel                                    "
lea          "Leather products                                   "
lum          "Wood products                                      "
ppp          "Paper products, publishing                         "
p_c          "Petroleum, coal products                           "
chm          "Chemical products                                  "
bph          "Basic pharmaceutical products                      "
rpp          "Rubber and plastic products                        "
nmm          "Mineral products nec                               "
i_s          "Ferrous metals                                     "
nfm          "Metals nec                                         "
fmp          "Metal products                                     "
ele          "Computer,electronic,optical prod                   "
eeq          "Electrical equipment                               "
ome          "Machinery and equipment nec                        "
mvh          "Motor vehicles and parts                           "
otn          "Transport equipment nec                            "
omf          "Manufactures nec                                   "
ely          "Electricity                                        "
gdt          "Gas manufacture, distribution                      "
wtr          "Water                                              "
cns          "Construction                                       "
trd          "Trade                                              "
afs          "Accommodation,Food,service act                     "
otp          "Transport nec                                      "
wtp          "Water transport                                    "
atp          "Air transport                                      "
whs          "Warehousing, support activities                    "
cmn          "Communication                                      "
ofi          "Financial services nec                             "
ins          "Insurance (formerly isr)                           "
rsa          "Real estate activities                             "
obs          "Business services nec                              "
ros          "Recreational and other serv                        "
osg          "Public Administration, defense                     "
edu          "Education                                          "
hht          "Human health, Social work act                      "
dwe          "Dwellings                                          "
/;

*  "Butter","Cheese","Skimmed milk powder","Whole milk powder","Whey powder","Casein"
*            "Other dairy"
*

*
* --- define list of split-up products, will be inserted in list of SAM columns/rows
*
  set s_spliti /

                 butt-c "Butter"
                 ches-c "Cheese"
                 smp-c  "Skimmed milk powder"
                 wmp-c  "Whole milk powder"
                 whey-c "Whey"
                 milo-c "Other dairy"
                /;


  set is_i(*,*) / set.s_spliti."mil-c" /;

  set s_splita /

                 butt-a "Butter"
                 ches-a "Cheese"
                 smp-a  "Skimmed milk powder"
                 wmp-a  "Whole milk powder"
                 whey-a "Whey"
*                case-a "Casein"
                 milo-a "Other dairy"

                /;

   set i_a(*,*) / butt-c  . butt-a
                  ches-c  . ches-a
                  smp-c   . smp-a
                  wmp-c   . wmp-a
                  whey-c  . whey-a
                  milo-c  . milo-a
   /;
   set diagIO / set.s_splitA /;

$elseifi.decl1    "%1"=="run"

set dairy,item;
$GDXIN "../data/dairy.gdx"
$load  dairy
$load  item
$GDXIN
*
*  --- post-model aggregation to non-diagonal make
*
$onempty
   set splitANonDiag(splita,splita) /

*         dair-a.(set.splita)
   /;
$offempty

   set dairy_spliti(dairy,spliti)/
                      "Butter".butt-c
                      "Cheese".ches-c
                      "Skimmed milk powder".smp-c
                      "Whole milk powder".wmp-c
                      "Whey".whey-c
                      "Other dairy".milo-c
    /;
   set dairy_splita(dairy,splita)/
                      "Butter".butt-a
                      "Cheese".ches-a
                      "Skimmed milk powder".smp-a
                      "Whole milk powder".wmp-a
                      "Whey".whey-a
*                     "Casein".case-a
                      "Other dairy".milo-a
    /;

*
*  --- build link set from ISO 3-character code to GTAP regions
*
   $$if not defined gisr $include 'postModel/map_regions.gms'
   $$if not defined gtapR_r alias(gtapR_r,rr);

   set fao_r(gisr,rNat);fao_r(gisr,rNat)  $ sum(rrmap(gisr,gtapR)  $ gtapR_r(gtapR,rNat),1) = YES;

   set faoYears / Y2014,Y2015 /;

   set anim(a) /
      cattle-a   "Cattle for meat"
      orum-a     "Other ruminant for meat"
      pig-a      "Pigs"
      poul-a     "Poultry birds and eggs"
      oapo-a     "Other animal products"
      rmk-a      "Raw milk"
   /;

   parameter p_FAOLvstProc(gisr,dairy,item,faoYears),p_dairyPrices(dairy);
   execute_load "%datdir%/dairy.gdx" p_FAOLvstProc,p_dairyPrices;

   p_splitFactor(rNat,splita,"prod") $ sum(is,sam0(rnat,"mil-a",is))
      = sum( (fao_r(gisr,rNat),dairy_splita(dairy,splita),faoYears), p_faoLvstProc(gisr,dairy,"Production",faoYears)
                                                                       * p_dairyPrices(dairy));

   p_splitFactor(rNat,spliti,dem) $ sam0(rnat,"mil-c",dem)
     = sum( (fao_r(gisr,rNat),dairy_spliti(dairy,spliti),faoYears),[  p_faoLvstProc(gisr,dairy,"Food supply quantity (tonnes)",faoYears)
                                                                    + p_faoLvstProc(gisr,dairy,"Tourist consumption",faoYears)]
                                                                     * p_dairyPrices(dairy) );

   p_splitFactor(rNat,spliti,a) $ sam0(rnat,"mil-c",a)
        = sum( (fao_r(gisr,rNat),dairy_spliti(dairy,spliti),faoYears), p_faoLvstProc(gisr,dairy,"Processed",faoYears)
                                                                                   * p_dairyPrices(dairy));

   p_splitFactor(rNat,spliti,"ofdOther-c") $ sam0(rnat,"mil-c","ofdOther-c")     = p_splitFactor(rNat,spliti,"hhsld");

   p_splitFactor(rNat,spliti,anim) $ sam0(rnat,"mil-c",anim)
        = sum( (fao_r(gisr,rNat),dairy_spliti(dairy,spliti),faoYears), p_faoLvstProc(gisr,dairy,"Feed",faoYears)* p_dairyPrices(dairy));

   p_splitFactor(rNat,spliti,"ofdAnim-c") $ sam0(rnat,"mil-c","ofdOther-c")
     = sum( (fao_r(gisr,rNat),dairy_spliti(dairy,spliti),faoYears), p_faoLvstProc(gisr,dairy,"Feed",faoYears)* p_dairyPrices(dairy));


   set hs6 /

   x040110 "Milk and cream of a fat content by weight of <= 1%, not concentrated nor containing added sugar or other sweetening matter"
   x040120 "Milk and cream of a fat content by weight of > 1% but <= 6%, not concentrated nor containing added sugar or other sweetening matter"
   x040140 "Milk and cream of a fat content by weight of > 6% but <= 10%, not concentrated nor containing added sugar or other sweetening matter"
   x040150 "Milk and cream of a fat content by weight of > 6% but <= 10%, not concentrated nor containing added sugar or other sweetening matter"
   x040210 "Milk and cream in solid forms, of a fat content by weight of <= 1,5%"
   x040221 "Milk and cream in solid forms, of a fat content by weight of > 1,5%, unsweetened"
   x040229 "Milk and cream in solid forms, of a fat content by weight of > 1,5%, sweetened"
   x040291 "Milk and cream, concentrated but unsweetened (excl. in solid forms)"
   x040299 "Milk and cream, concentrated and sweetened (excl. in solid forms)"
   x040310 "Yogurt, whether or not flavoured or containing added sugar or other sweetening matter, fruits, nuts or cocoa"
   x040390 "Buttermilk, curdled milk and cream, kephir and other fermented or acidified milk and cream, whether or not concentrated or flavoured or containing added sugar or other sweetening matter, fruits, nuts or cocoa (excl. yogurt)"
   x040410 "Whey and modified whey, whether or not concentrated or containing added sugar or other sweetening matter"
   x040490 "Products consisting of natural milk constituents, whether or not sweetened, n.e.s."
   x040510 "Butter (excl. dehydrated butter and ghee)"
   x040520 "Dairy spreads of a fat content, by weight, of >= 39% but < < 80%"
   x040590 "Fats and oils derived from milk, and dehydrated butter and ghee (excl. natural butter, recombined butter and whey butter)"
   x040610 "Fresh cheese 'unripened or uncured cheese', incl. whey cheese, and curd"
   x040620 "Grated or powdered cheese, of all kinds"
   x040630 "Processed cheese, not grated or powdered"
   x040640 "Blue-veined cheese and other cheese containing veins produced by 'Penicillium roqueforti'"
   x040690 "Cheese (excl. fresh cheese, incl. whey cheese, curd, processed cheese, blue-veined cheese and other cheese containing veins produced by 'Penicillium roqueforti', and grated or powdered cheese)"
   x210500 "Ice cream and other edible ice, whether or not containing cocoa"
   x350110 "Casein"
   /;

   set spliti_hs6(spliti,hs6) /

   milo-c .  x040110 "Milk and cream of a fat content by weight of <= 1%, not concentrated nor containing added sugar or other sweetening matter"
   milo-c .  x040120 "Milk and cream of a fat content by weight of > 1% but <= 6%, not concentrated nor containing added sugar or other sweetening matter"
   milo-c .  x040140 "Milk and cream of a fat content by weight of > 6% but <= 10%, not concentrated nor containing added sugar or other sweetening matter"
   milo-c .  x040150 "Milk and cream of a fat content by weight of > 6% but <= 10%, not concentrated nor containing added sugar or other sweetening matter"
   smp-c  .  x040210 "Milk and cream in solid forms, of a fat content by weight of <= 1,5%"
   wmp-c  .  x040221 "Milk and cream in solid forms, of a fat content by weight of > 1,5%, unsweetened"
   wmp-c  .  x040229 "Milk and cream in solid forms, of a fat content by weight of > 1,5%, sweetened"
   milo-c .  x040291 "Milk and cream, concentrated but unsweetened (excl. in solid forms)"
   milo-c .  x040299 "Milk and cream, concentrated and sweetened (excl. in solid forms)"
   milo-c .  x040310 "Yogurt, whether or not flavoured or containing added sugar or other sweetening matter, fruits, nuts or cocoa"
   milo-c .  x040390 "Buttermilk, curdled milk and cream, kephir and other fermented or acidified milk and cream, whether or not concentrated or flavoured or containing added sugar or other sweetening matter, fruits, nuts or cocoa (excl. yogurt)"
   whey-c .  x040410 "Whey and modified whey, whether or not concentrated or containing added sugar or other sweetening matter"
   milo-c .  x040490 "Products consisting of natural milk constituents, whether or not sweetened, n.e.s."
   butt-c .  x040510 "Butter (excl. dehydrated butter and ghee)"
   butt-c .  x040520 "Dairy spreads of a fat content, by weight, of >= 39% but < < 80%"
   butt-c .  x040590 "Fats and oils derived from milk, and dehydrated butter and ghee (excl. natural butter, recombined butter and whey butter)"
   ches-c .  x040610 "Fresh cheese 'unripened or uncured cheese', incl. whey cheese, and curd"
   ches-c .  x040620 "Grated or powdered cheese, of all kinds"
   ches-c .  x040630 "Processed cheese, not grated or powdered"
   ches-c .  x040640 "Blue-veined cheese and other cheese containing veins produced by 'Penicillium roqueforti'"
   ches-c .  x040690 "Cheese (excl. fresh cheese, incl. whey cheese, curd, processed cheese, blue-veined cheese and other cheese containing veins produced by 'Penicillium roqueforti', and grated or powdered cheese)"
   milo-c .  x210500 "Ice cream and other edible ice, whether or not containing cocoa"
*
*  --- at least in TASTE, casein is not mapped to mil
*
*  case-c .  x350110 "Casein"
  /;

  set items / w_tr,appliedRev /;
  parameter p_trade(hs6,rdat,rdat,items);

  execute_load "%datdir%/taste.gdx" p_trade;
  set tasteSpliti_hs6(spliti,hs6);

  parameter p_hs6(rnat,hs6,rnat,items)
            p_imptxTaste(rnat,i,rnat1);
*
   p_hs6(rnat,hs6,rnat1,items) = sum((rr(rDat,rnat),rr1(rDat1,rNat1)),p_trade(hs6,rDat,rDat1,items)) * 0.001;

   p_splitFactor(rnat,spliti,rnat1) = sum(spliti_hs6(spliti,hs6),p_hs6(rnat,hs6,rnat1,"w_tr"));

   p_imptxTaste(rnat,spliti,rnat1) $ (p_splitFactor(rnat,spliti,rnat1) gt 1.E-10)
      = sum(spliti_hs6(spliti,hs6),p_hs6(rnat,hs6,rnat1,"appliedRev"))/p_splitFactor(rnat,spliti,rnat1);

   p_splitFactor(rnat,spliti,rnat1) $ (not sum(i_a(spliti,splita), p_splitFactor(rNat,"prod",splita))) = 0;
*
*  --- input demands for split-up activities should be scaled proportionally
*
   propAssmpt(rnat,i,         splita) = yes;
   propAssmpt(rnat,f,         splita) = yes;
*
*  --- exemptions: split up products
*
   propAssmpt(rnat,spliti   , splita) = no;
   propAssmpt(rnat,i,         splita) $ sum(is_i(spliti,i),1) =no;


$elseifi.decl1    "%1"=="fix"

*
*  --- introduce weights for production outputs  where we have good a priori information from FAOSTAT
*
   p_wgts(rNat,splita,i)   $ p_sam0(rNat,splita,i)    = 19;
*
*  --- even higher weights for bi-lateral exports
*
   p_wgts(rNat,spliti,r0)  $ p_sam0(rNat,spliti,r0)   = 49;
   p_wgts(rNat,r0,spliti)  $ p_sam0(rNat,r0,spliti)   = 49;
*
*  --- render average taste tariff aggregated from HS6 to current product dis-saggregation
*
   $$iftheni.imptxTaste defined p_imptxTaste

      alias(splita,splitaf);
      alias(spliti,splitif);

      $$batinclude 'build\split_based_on_fabio.gms' imptx
   $$endif.imptxTaste

   p_nutContFabio(rnat,spliti,nut) = p_nutContFabio(rnat,"mil-c",nut);


$endif.decl1
