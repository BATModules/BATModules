********************************************************************************
$ontext

   CGEBOX project

   GAMS file : OSD.GMS

   @purpose  : Define split for oilseed example, random split factor
   @author   : W.Britz
   @date     : 12.12.16
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : build\split.gms

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
mil          "Dairy products                                     "
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

*
* --- define list of split-up products, will be inserted in list of SAM columns/rows
*
  set s_spliti /

                 sorg-c "Sorghum"
                 barl-c "Barley"
                 maiz-c "Maiz"
                 oat-c  "Oats"
                 rye-c  "Rye"
                 ocer-c "Other cereals"

                 olv-c  "Olives"
                 soy-c  "Soy bean"
                 palm-c "Palm oil fruit"
                 rape-c "Rape seed"
                 oso-c  "Other oilseeds"

                 pota-c    "Potatoes"
                 rttb-c    "Other roots and tubers"
                 leg-c     "Leguminosae"
                 toma-c    "Tomatoes"
                 oveg-c    "Other vegetables"
                 citr-c    "Citrus fruits"
                 banp-c    "Bananas and plantains"
                 appl-c    "Apples"
                 grap-c    "Grapes"
                 ofru-c    "Other fruits"
                 v_fo-c    "Rest of v_f"

                 coco-c    "Cocoa beans"
                 teas-c    "Teas"
                 coff-c    "Coffee beans"
                 ocro-c    "Other crops"

                 olivOil-c "Olive oil"
                 palmOil-c "Palm oil"
                 soyCake-c "Soybean cake"
                 soyOil-c  "Soybean oil"
                 rapCake-c "Rape seed cake"
                 rapOil-c  "Rape seed oil"
                 volo-c    "Other vegetable oils and cakes"

                 cattle-c  "Cattle for meat"
                 orum-c    "Other ruminant for meat"

                 pig-c     "Pigs"
                 poul-c    "Poultry birds and eggs"
                 oapo-c    "Other animal products"

                 ctlMeat-c   "Cattle meat"
                 orumMeat-c  "Other ruminant meat"
                 pigMeat-c   "Pig meat"
                 othMeat-c   "Other meat"

                 ofdAnim-c  "Feed concentrates"
                 ofdOther-c "Other food processing"

                /;

*
* --- define list of split-up activities, will be inserted in list of columns and rows in SAM
*
  set s_splita /
                 sorg-a    "Sorghum"
                 barl-a    "Barley"
                 maiz-a    "Maiz"
                 oat-a     "Oats"
                 rye-a     "Rye"
                 ocer-a    "Other cereals"

                 olv-a     "Olives"
                 soy-a     "Soy beans"
                 palm-a    "Palm oil fruits"
                 rape-a    "Rape seed"
                 oso-a     "Other oilseeds"

                 pota-a    "Potatoes"
                 rttb-a    "Other roots and tubers"
                 leg-a     "Leguminosae"
                 toma-a    "Tomatoes"
                 oveg-a    "Other vegetables"
                 citr-a    "Citrus fruits"
                 banp-a    "Bananas and plantains"
                 grap-a    "Grapes"
                 appl-a    "Apples"
                 ofru-a    "Other fruits"
                 v_fo-a    "Rest of v_f"

                 coco-a    "Cocoa beans"
                 teas-a    "Teas"
                 coff-a    "Coffee beans"
                 ocro-a    "Other crops"

                 cattle-a  "Cattle for meat"
                 orum-a    "Other ruminant for meat"

                 pig-a     "Pigs"
                 poul-a    "Poultry farming"
                 oapo-a    "Other animal activities"

                 olivOil-a "Olive oil"
                 palmOil-a "Palm oil production"
                 soyCake-a "Soybean cake"
                 soyOil-a  "Soybean oil"
                 rapCake-a "Rape seed cake"
                 rapOil-a  "Rape seed oil"
                 volo-a    "Other vegetables oils and cakes"

                 ctlMeat-a   "Cattle meat"
                 orumMeat-a  "Other ruminant meat"
                 pigMeat-a   "Pig meat"
                 othMeat-a   "Other meat"

                 ofdAnim-a  "Feed Concentrates"
                 ofdOther-a "Other food processing"

                  /;
*
* --- defines which split-up products is defined by which activity
*
  set i_a(*,*) /
                 sorg-c.sorg-a
                 barl-c.barl-a
                 maiz-c.maiz-a
                 oat-c .oat-a
                 rye-c .rye-a
                 ocer-c.ocer-a

                 pota-c.pota-a
                 rttb-c.rttb-a

                 olv-c.olv-a
                 soy-c.soy-a
                 rape-c.rape-a
                 palm-c.palm-a
                 oso-c.oso-a

                 citr-c.  citr-a
                 banp-c.  banp-a
                 appl-c.  appl-a
                 grap-c.  grap-a
                 ofru-c.  ofru-a
                 oveg-c.  oveg-a
                 toma-c.  toma-a
                 leg-c.   leg-a
                 v_fo-c.  v_fo-a

                 coco-c. coco-a
                 teas-c. teas-a
                 coff-c. coff-a
                 ocro-c. ocro-a

                 cattle-c.cattle-a
                 orum-c  .orum-a

                 pig-c   .pig-a
                 poul-c  .poul-a
                 oapo-c  .oapo-a

                 olivOil-c.olivOil-a
                 palmOil-c.palmOil-a
                 soyCake-c.soyCake-a
                 soyOil-c.soyOil-a
                 rapCake-c.rapCake-a
                 rapOil-c.rapOil-a
                 volo-c.volo-a

                 ctlMeat-c   . ctlMeat-a
                 orumMeat-c  . orumMeat-a
                 pigMeat-c   . pigMeat-a
                 othMeat-c   . othMeat-a

                 ofdAnim-c.    ofdAnim-a
                 ofdOther-c.   ofdOther-a
                  /;


*
* --- use that set to indicate that intermediate demand of the split industry
*     for its own output should only comprise the combination of split commodity
*     and split activity, typicaly case is seed use
*
$onempty
  set diagIO(*) /  /;
$offempty
*
* --- define the link between the split-up products and the aggregate in the original GTAP data base
*
  set is_i(*,*)      / (maiz-c,barl-c,oat-c,rye-c,sorg-c,ocer-c).gro-c
                       (olv-c,soy-c,palm-c,rape-c,oso-c).osd-c
                       (citr-c,banp-c,appl-c,grap-c,ofru-c,toma-c,oveg-c,v_fo-c,pota-c,leg-c,rttb-c).v_f-c
                       (coco-c,coff-c,teas-c,ocro-c).ocr-c
                       (cattle-c,orum-c).ctl-c
                       (pig-c,poul-c,oapo-c).oap-c
                       (olivOil-c,palmOil-c,soyCake-c,soyOil-c,rapCake-c,rapOil-c,volo-c).vol-c
                       (ofdAnim-c,ofdOther-c).ofd-c
                       (ctlMeat-c,orumMeat-c).cmt-c
                       (pigMeat-c,othMeat-c).omt-c
                      /;


$elseifi.decl1    "%1"=="run"

  $$if not defined gtapR_r alias(gtapR_r,rr);
  $$batinclude "fabio\fabio.gms" decl

  set testIs_i;
  testIs_i(spliti) $ (not sum(is_i(spliti,i),1)) = 1;
  if ( Card(testIs_i), abort "Not matched split product ",spliti,testIS_i,is_i;);

  set volAdd(a) /soyCake-a,soyOil-a,rapCake-a,rapOil-a/;

  mapa("vol",volAdd) = yes;
  mapa("ofd","ofdAnim-a")  = yes;
  mapa("ofd","ofdOther-a") = yes;

*
* ---- additonal information to link CAPRI data base at NUTS II
*
  set fabio_capriI(a,capriI) /
      oat-a.oats
      barl-a.barl
      maiz-a.maiz
      rye-a.ryem
      ocer-a.ocer
      leg-a.puls
      rape-a.rape
      soy-a.soya
      oso-a.(SUNF,OOIL)
      olv-a.oliv
      pota-a.pota
      toma-a.toma
      oveg-a.oveg
      appl-a.appl
      citr-a.citr
      (banp-a,ofru-a).ofru
      ctlMeat-a.beef
      orumMeat-a.sgmt
      pigMeat-a.pork
      othMeat-a.poum
      poul-a.eggs
  /;
*
$onEmpty
*
*  --- post-model aggregation to non-diagonal make
*
   set splitANonDiag(splita,splita) /

*        soyCake-a.(soyCake-a,soyOil-a)
*        rapCake-a.(rapCake-a,rapOil-a)
   /;
$offEmpty
*

*
* --- exclude beverages and tobacco from FABIO assignments. Liquors etc. are missing
*     leaving them in can product unwanted problems due to missing split factors
*
 fabC_iDAT(fabC,"B_T") = no;
 faba_iDAT(faba,"B_T") = no;
 fabC_i(fabC,"B_T-c") = no;
 faba_a(faba,"B_T-a") = no;
*
*   --- define mapping between split-up products and FABIO items
*
   set fabC_spliti(fabC,spliti) /
         "Sorghum and products                   ".Sorg-c
         "Barley and products                    ".Barl-c
         "Maize and products                     ".Maiz-c
         "Oats                                   ".Oat-c
         "Rye and products                       ".Rye-c

         "Olives (including preserved)           ".olv-c
         "Soyabeans                              ".soy-c
         "Rape and mustardseed                   ".rape-c
         "Oil, palm fruit                        ".palm-c
         "Palm kernels                           ".palm-c

         "Beans                                  ".leg-c
         "Peas                                   ".leg-c
         "Pulses, Other and products             ".leg-c

         "Potatoes and products                  ".pota-c
         "Cassava and products                   ".rttb-c
         "Yams                                   ".rttb-c
         "Sweet potatoes                         ".rttb-c
         "Roots, other                           ".rttb-c

         "Tomatoes and products                  ".toma-c
         "Onions                                 ".oveg-c
         "Vegetables, Other                      ".oveg-c

         "Oranges, Mandarines                    ".citr-c
         "Lemons, Limes and products             ".citr-c
         "Grapefruit and products                ".citr-c
         "Citrus, Other                          ".citr-c
         "Bananas                                ".banp-c
         "Plantains                              ".banp-c
         "Apples and products                    ".appl-c
         "Pineapples and products                ".ofru-c
         "Dates                                  ".ofru-c
         "Grapes and products (excl wine)        ".grap-c
         "Fruits, Other                          ".ofru-c

         "Coffee and products                    ".coff-c
         "Cocoa Beans and products               ".coco-c
         "Tea (including mate)                   ".teas-c

         "Cattle                                 ".cattle-c
         "Buffaloes                              ".cattle-c

         "Pigs                                   ".pig-c
         "Poultry birds                          ".poul-c
         "Eggs                                   ".poul-c

         "Olive oil                              ".olivOil-c
         "Palm oil                               ".palmOil-c
         "Soyabean cake                          ".soyCake-c
         "Soyabean oil                           ".soyOil-c
         "Rape and Mustard cake                  ".rapCake-c
         "Rape and Mustard oil                   ".rapOil-c

         "Bovine meat                            ".ctlMeat-c
         "Mutton and Goat Meat                   ".orumMeat-c
         "Pigmeat                                ".(pigMeat-c)
         "Poultry meat                           ".othMeat-c
         "Meat, other                            ".othMeat-c
*        "Offals, edible                         ".(ctlMeat-c,pigMeat-c,othMeat-c)
*        "Fats, Animals, Raw                     ".(ctlMeat-c,pigMeat-c,othMeat-c)
         "Offals, edible                         ".(ctlMeat-c,orumMeat-c,pigMeat-c,othMeat-c)
         "Fats, Animals, Raw                     ".(ctlMeat-c,orumMeat-c,pigMeat-c,othMeat-c)
   /;
*
*   --- define mapping between split-up activitities and FABIO activities
*
   set fabA_splitA(fabA,splitA) /
         "Sorghum production                  ".Sorg-a
         "Barley production                   ".Barl-a
         "Maize production                    ".Maiz-a
         "Oat production                      ".Oat-a
         "Rye production                      ".Rye-a

         "Olives production                   ".olv-a
         "Soyabeans production                ".soy-a
         "Rape and Mustardseed production     ".rape-a
         "Oil palm fruit production           ".palm-a

         "Beans production                    ".leg-a
         "Peas production                     ".leg-a
         "Pulses  production, Other           ".leg-a

         "Potatoes  production                ".pota-a
         "Cassava production                  ".rttb-a
         "Yams production                     ".rttb-a
         "Sweet potatoes production           ".rttb-a
         "Roots production, other             ".rttb-a

         "Tomatoes production                 ".toma-a
         "Onions production                   ".oveg-a
         "Vegetables production, Other        ".oveg-a
         "Oranges, Mandarines production      ".citr-a
         "Lemons, Limes production            ".citr-a
         "Grapefruit production               ".citr-a
         "Citrus production, Other            ".citr-a
         "Bananas production                  ".banp-a
         "Plantains production                ".banp-a
         "Apples production                   ".appl-a
         "Pineapples production               ".ofru-a
         "Dates production                    ".ofru-a
         "Grapes production                   ".grap-a
         "Fruits production, Other            ".ofru-a

         "Coffee production                   ".coff-a
         "Cocoa Beans production              ".coco-a
         "Tea production                      ".teas-a

         "Cattle husbandry                    ".cattle-a
         "Buffaloes husbandry                 ".cattle-a

         "Pigs farming                        ".pig-a
         "Poultry birds farming               ".poul-a

         "Olive Oil extraction                ".olivOil-a
         "Soyabean Oil extraction             ".soyCake-a
         "Soyabean Oil extraction             ".soyOil-a
         "Rape and Mustard oil extraction     ".rapCake-a
         "Rape and Mustard Oil extraction     ".rapOil-a
         "Palm Oil production                 ".palmOil-a

         "Cattle slaughtering                    ".ctlMeat-a
         "Buffaloes slaughtering                 ".ctlMeat-a
         "Sheep slaughtering                     ".orumMeat-a
         "Goat slaughtering                      ".orumMeat-a
         "Horses slaughtering                    ".orumMeat-a
         "Asses slaughtering                     ".orumMeat-a
         "Mules slaughtering                     ".orumMeat-a
         "Camels slaughtering                    ".orumMeat-a
         "Camelids slaughtering, other           ".orumMeat-a
         "Pigs slaughtering                      ".pigMeat-a
         "Poultry slaughtering                   ".othMeat-a
         "Rabbits slaughtering                   ".othMeat-a
         "Rodents slaughtering, other            ".othMeat-a
         "Live animals slaughtering, other       ".othMeat-a
   /;

*
*  --- introduce in FABIO mappings
*
   fabC_i(fabC,spliti) $ fabc_spliti(fabc,Spliti) = YES;
   fabA_a(fabA,splita) $ fabA_splitA(faba,Splita) = YES;
*
*  --- Assign missing mappings to residual category
*
   fabC_i(fabc,"ocer-c")     $ (fabc_i(fabc,"gro-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"oso-c")      $ (fabc_i(fabc,"osd-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"volo-c")     $ (fabc_i(fabc,"vol-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"v_fo-c")     $ (fabc_i(fabc,"v_f-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"ocro-c")     $ (fabc_i(fabc,"ocr-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"orum-c")     $ (fabc_i(fabc,"ctl-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"oapo-c")     $ (fabc_i(fabc,"oap-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"orumMeat-c") $ (fabc_i(fabc,"cmt-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;
   fabC_i(fabc,"othMeat-c")  $ (fabc_i(fabc,"omt-c")  $ (not sum(fabc_spliti(fabc,spliti),1))) = YES;

   fabA_a(faba,"ocer-a")     $ (faba_a(faba,"gro-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"oso-a")      $ (faba_a(faba,"osd-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"volo-a")     $ (faba_a(faba,"vol-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"v_fo-a")     $ (faba_a(faba,"v_f-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"ocro-a")     $ (faba_a(faba,"ocr-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"orum-a")     $ (faba_a(faba,"ctl-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"oapo-a")     $ (faba_a(faba,"oap-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"orumMeat-a") $ (faba_a(faba,"cmt-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;
   fabA_a(faba,"othMeat-a")  $ (faba_a(faba,"omt-a")  $ (not sum(faba_splita(faba,splita),1))) = YES;

  $$batinclude 'build\split_based_on_fabio.gms' splitFactors
*
*  --- define production shares for feed (=non-food) and food OFD sector based on intermediate
*      demand
*
   set anim(a) / ctl-a,rmk-a,oap-a,wol-a,fsh-a /;
   alias(anim,anim1);
   anim(splita) $ sum(as_a(splita,anim1),1) = YES;
*
*  --- remove split factors relating to food pocessing
*
   p_splitFactor(rNat,"ofdAnim-a",is)  $ (not sum(sameas(spliti,is),1)) = 0;
   p_splitFactor(rNat,"ofdOther-a",is) $ (not sum(sameas(spliti,is),1)) = 0;
*
*  --- output for feed compound industry is equal to
*      intermediate demand of animals of ofd
*      plus 50% of intra-industry demand of ofd
*
   p_splitFactor(rNat,"ofdAnim-a","prod")
      = sum(anim, sam0(rNat,"ofd-c",anim)) + sam0(rNat,"ofd-c","ofd-a") * 0.50;
*
*  --- the rest goes to the residual category of food processing
*
   p_splitFactor(rNat,"ofdOther-a","prod")
      = sum(a $ (not anim(a)), sam0(rNat,"ofd-c",a))
       + sam0(rNat,"ofd-c","hhsld")
       + sam0(rNat,"ofd-c","gov")
       -sam0(rNat,"ofd-c","ofd-a") * 0.50;

*
*  --- We need to distribute pig raising and pig fattening:
*      Estimate the pig-raising process from the GTAP sam residual
*

   p_splitFactor(rnat,"pig-a","prod") $ [ (sam0(rnat,"oap-c","omt-a")+sam0(rnat,"oap-c","oap-a")) $  p_splitFactor(rnat,"pig-a","prod")]
    =  min(p_splitFactor(rnat,"pigMeat-a","prod") * (sam0(rnat,"oap-c","omt-a")+sam0(rnat,"oap-c","oap-a"))/sum(isi,sam0(rnat,"omt-a",isi)+sam0(rnat,"oap-a",isi))*1.25,
       max(p_splitFactor(rnat,"pigMeat-a","prod") * (sam0(rnat,"oap-c","omt-a")+sam0(rnat,"oap-c","oap-a"))/sum(isi,sam0(rnat,"omt-a",isi)+sam0(rnat,"oap-a",isi))*0.75,
                                         sam0(rnat,"oap-c","omt-a")+sam0(rnat,"oap-c","oap-a") - p_splitFactor(rnat,"poul-a","prod")));
*
   p_splitFactor(rnat,"pig-a","int")  = p_splitFactor(rnat,"pig-a","prod");
   p_splitFactor(rnat,"pig-a",f)      = p_splitFactor(rnat,"pig-a","prod");

   p_splitFactor(rnat,"pig-a","pig-c") $ sum(isi,sam0(rnat,"oap-a",isi))
       = sam0(rnat,"oap-c","oap-a")/sum(isi,sam0(rnat,"oap-a",isi))  * p_splitFactor(rnat,"pig-a","prod");
   p_splitFactor(rnat,"pigMeat-a","pig-c") $ (p_splitFactor(rnat,"pigMeat-a","prod") and p_splitFactor(rnat,"pig-a","prod"))
     = p_splitFactor(rnat,"pig-a","prod") - p_splitFactor(rnat,"pig-a","pig-c");
*
*  --- final demand split for the two other food category
*
   p_splitFactor(rNat,"ofdAnim-c","hhsld")  = eps;
   p_splitFactor(rNat,"ofdAnim-c","gov")    = eps;
   p_splitFactor(rNat,"ofdOther-c","hhsld") = 1;
   p_splitFactor(rNat,"ofdOther-c","gov")   = 1;
*
*  --- use FABIO data to split up food and non-food intermediate use
*
   alias(fabr,fabr1);

   set iFabio(i);
   iFabio(i) $ sum(fabc_i(fabc,i),1) = YES;

   set fabaAnim(faba) /
       "Cattle husbandry                                         "
       "Buffaloes husbandry                                      "
       "Sheep husbandry                                          "
       "Goats husbandry                                          "
       "Pigs farming                                             "
       "Poultry Birds farming                                    "
       "Horses husbandry                                         "
       "Asses husbandry                                          "
       "Mules husbandry                                          "
       "Camels husbandry                                         "
       "Camelids husbandry, other                                "
       "Rabbits husbandry                                        "
       "Rodents husbandry, other                                 "
       "Live animals husbandry, other                            "
       "Dairy cattle husbandry                                   "
       "Dairy buffaloes husbandry                                "
       "Dairy sheep husbandry                                    "
       "Dairy goats husbandry                                    "
       "Dairy camels husbandry                                   "
       "Cattle slaughtering                                      "
       "Buffaloes slaughtering                                   "
       "Sheep slaughtering                                       "
       "Goat slaughtering                                        "
       "Pigs slaughtering                                        "
       "Poultry slaughtering                                     "
       "Horses slaughtering                                      "
       "Asses slaughtering                                       "
       "Mules slaughtering                                       "
       "Camels slaughtering                                      "
       "Camelids slaughtering, other                             "
       "Rabbits slaughtering                                     "
       "Rodents slaughtering, other                              "
       "Live animals slaughtering, other                         "
       "Beekeeping                                               "
       "Silkworm breeding                                        "
*
*      --- this should be aquaculture use in the split of ofd-anim
*
       "Fishing                                                  "
   /;

  set fabaNonAnim(faba);
  fabaNonAnim(faba) $ (not fabaAnim(faba)) = yes;


  set aCrops(a)  / pdr-a,wht-a,gro-a,v_f-a,osd-a,c_b-a,pfb-a,ocr-a /;
  alias(aCrops,aCrops1);
  aCrops(splita) $ sum(as_a(splita,aCrops1),1) = YES;

  set iCrops(i)  / pdr-c,wht-c,gro-c,v_f-c,osd-c,c_b-c,pfb-c,ocr-c /;
  alias(iCrops,iCrops1);
  iCrops(spliti) $ sum(is_i(spliti,iCrops1),1) = YES;

  set aAnim(a)   / ctl-a,rmk-a,oap-a,wol-a,omt-a,cmt-a/;

  set fabaCrops(faba);
  fabaCrops(faba) $ sum(faba_a(faba,aCrops),1) = yes;

*
* --- exclude oilseed processing, beverages, slaughtering - not part of ofd
*
  fabaNonAnim(faba) $ sum(as_a(splita,"vol-a") $ fabA_a(faba,splita),1) = no;
  fabaNonAnim(faba) $ sum(fabA_a(faba,"b_t-a"),1) = no;
  fabaNonAnim(faba) $ sum(fabA_a(faba,"cmt-a"),1) = no;
  fabaNonAnim(faba) $ sum(fabA_a(faba,"omt-a"),1) = no;
*
* --- exclude crops (= seed use)
*
  fabaNonAnim(fabaCrops) = no;
*
*  --- all positions (imports and domestic use) of that product in the MRIO
*
  iFabio("frs-c") = no;
  iFabio("lum-c") = no;

*
* --- this is an intermediate assignment to ease the next calculation, will be deleted below
*
  sam0(rNat,iFabio,a) = sam0(rnat,iFabio,a) + sum(is_i(spliti,i) $ sameas(spliti,iFabio), sam0(rnat,i,a));

  p_splitFactor(rNat,"ofdAnim-a",iFabio) $ sam0(rNat,iFabio,"ofd-a")
     =
*
*            --- non-food "final" according to FABIO definition which includes
*                intermediate use of all activities not covered by FABIO
*
         +   [sum((fabr_r(fabr,rNat),fabc_i(fabc,iFabio)) $ (not sameas(fabc,"Fodder crops")),
                       p_fabio("tot",fabc,fabr,"other")*p_fobPrices(fabr,fabc))
                 * sam0(rNat,iFabio,"ofd-a")/sum(a,sam0(rNat,iFabio,a))] $ sum(a,sam0(rNat,iFabio,a))
*
*            --- animal agricultural use
*
          +  {[sum((fabr_r(fabr,rNat),fabc_i(fabc,iFabio),fabaAnim) $ (not sameas(fabc,"Fodder crops")),
                p_fabio("tot",fabc,fabr,fabaAnim) * p_fobPrices(fabr,fabc)) + eps]
                 * sam0(rNat,iFabio,"ofd-a")/(sum(aAnim(a),sam0(rNat,iFabio,aAnim))+sam0(rNat,iFabio,"ofd-a"))
             } $ (sum(aAnim(a),sam0(rNat,iFabio,aAnim))+sam0(rNat,iFabio,"ofd-a"))

          + 0.001 * sam0(rNat,iFabio,"ofd-a")
             ;


   p_splitFactor(rNat,"ofdOther-a",iFabio) $ sam0(rNat,iFabio,"ofd-a")
     =
*
*            --- non-food "final" according to FABIO definition which includes
*                intermediate use all activities not covered by FABIO
*
         +   [ sum((fabr_r(fabr,rNat),fabc_i(fabc,iFabio)),
                       p_fabio("tot",fabc,fabr,"food")*p_fobPrices(fabr,fabc))
                         * sam0(rNat,iFabio,"ofd-a")/sum(a,sam0(rNat,iFabio,a)) ] $ sum(a,sam0(rNat,iFabio,a))
*
*            --- non animal agricultural use
*
           +  {[sum((fabr_r(fabr,rNat),fabc_i(fabc,iFabio),fabaNonAnim), p_fabio("tot",fabc,fabr,fabaNonAnim) * p_fobPrices(fabr,fabc)) + eps]
                      * sam0(rNat,iFabio,"ofd-a")/sum(a $ (not aAnim(a)),sam0(rNat,iFabio,a))
              } $ sum(a $ (not aAnim(a)),sam0(rNat,iFabio,a))
*
          + 0.001 * sam0(rNat,iFabio,"ofd-a")
           ;

    p_splitFactor(rNat,"ofdOther-a","volo-c") = 1;
*
*   --- distirbution to food and restaurants as for final demand
*
    p_splitFactor(rNat,spliti,"afs-a")   = p_splitFactor(rnat,spliti,"hhsld");
*
*  --- delete temporary assignment to SAM used in the two statements above
*
   sam0(rNat,spliti,a) = 0;
   iFabio(i) $ sum(fabc_i(fabc,i),1) = YES;
*
   set meatLiveAnim(i)   / rmk-c,ctl-c,oap-c,omt-c,cmt-c/;
   meatLiveAnim(spliti) $ sum(is_i(spliti,i) $ meatLiveAnim(i),1) = YES;

   set meatLiveAnimA(a)   / ctl-a,oap-a,omt-a,cmt-a/;
   meatLiveAnimA(splita) $ sum(as_a(splita,a) $ meatLiveAnimA(a),1) = YES;
   meatLiveAnimA(anim)  = YES;

*
*  --- meat / live animals into food industry
*
   p_splitFactor(rNat,"ofdAnim-a",meatLiveAnim)  $ sum(i_a(meatLiveAnim, meatLiveAnimA), p_splitFactor(rnat,meatLiveAnimA,"prod")) = 0.001;
   p_splitFactor(rNat,"ofdOther-a",meatLiveAnim) $ sum(i_a(meatLiveAnim, meatLiveAnimA), p_splitFactor(rnat,meatLiveAnimA,"prod")) = 0.999;

   p_splitFactor(rNat,"ofdAnim-a","ofdAnim-c")   = 1.0;
   p_splitFactor(rNat,"ofdOther-a","ofdOther-c") = 1.0;

   p_splitFactor(rNat,"ofdAnim-a","b_t-c")  = 0.001;
   p_splitFactor(rNat,"ofdOther-a","b_t-c") = 0.999;
*
   p_splitFactor(rNat,anim,"ofdOther-c") = eps;
   p_splitFactor(rNat,anim,"teas-c")     = eps;
   p_splitFactor(rNat,anim,"coff-c")     = eps;
   p_splitFactor(rNat,anim,"coco-c")     = eps;

   p_splitFactor(rNat,meatLiveAnimA(splita),"ofdAnim-c") $ p_splitFactor(rnat,splita,"prod")
     =  sum(as_a(splita,a),sam0(rNat,"ofd-c",a) * p_splitFactor(rNat,splita,"prod")) * 0.5
      + sum(iCrops, p_splitFactor(rnat,splita,iCrops));
*
*  --- assign correct oilseeds to processes (diagonal structure)
*
   set oilProc(splita)  /olivOil-a,soyCake-a,soyOil-a,rapCake-a,rapOil-a,palmOil-a,volo-a /;
   set oilProcI(spliti) /olivOil-c,soyCake-c,soyOil-c,rapCake-c,rapOil-c,palmOil-c,volo-c /;
   alias(oilProc,oilProc1);
*
*  --- allow some very limited use of other oil-seed in crushing processes
*      (the list of output comprises also mixed oils etc.)
*
   p_splitFactor(rNat,oilProc,spliti) $ (is_i(spliti,"osd-c") $ p_splitFactor(rnat,oilProc,"Prod"))
                                             = max(1.E-5,0.001
                                                * p_splitFactor(rnat,oilProc,"Prod")/sum(oilProc1,p_splitFactor(rnat,oilProc1,"Prod")));
*
*  --- allow some very limited use of other cakes and oils in crushing processes
*
   p_splitFactor(rNat,oilProc,oilProcI) $ (p_splitFactor(rnat,oilProc,"Prod") $ (not i_a(oilProcI,oilProc)))
                                             = 0.1 * sum(i_a(spliti,oilProc),p_splitFactor(rnat,oilProc,spliti))
                                                 * sum(i_a(oilProcI,oilProc1),p_splitFactor(rnat,oilProc1,"Prod"))
                                                  /sum(oilProc1,p_splitFactor(rnat,oilProc1,"Prod"));
*
*  --- prevent that the cleansing of small split factor removes the small entry
*
   p_splitFactor(rNat,oilProc,oilProcI) $ p_splitFactor(rnat,oilProc,"Prod")
    = max(1.E-4*card(oilProc)*sum(i_a(spliti,oilProc1),p_splitFactor(rnat,oilProc1,spliti)),p_splitFactor(rNat,oilProc,OilProcI));
*
*  --- assign correct oilseeds to processes (diagonal structure)
*
   p_splitFactor(rNat,"olivOil-a","olv-c")   = 1;
   p_splitFactor(rNat,"soyCake-a","soy-c")   = 1;
   p_splitFactor(rNat,"soyOil-a","soy-c")    = 1;
   p_splitFactor(rNat,"rapCake-a","rape-c")  = 1;
   p_splitFactor(rNat,"rapOil-a","rape-c")   = 1;
   p_splitFactor(rNat,"palmOil-a","palm-c")  = 1;
   p_splitFactor(rNat,"volo-a","oso-c")      = 1;
*
*  --- diagonal seed use (exemption is ocro-c which should comprise specialized seed production)
*
   p_splitFactor(rNat,aCrops,spliti)   $ (sum(i_a(spliti,aCrops1),1) and (not (sum(i_a(spliti,aCrops),1) or sameas(spliti,"ocro-c")))) = eps;
   p_splitFactor(rNat,aCrops,"ocro-c") $ p_splitFactor(rnat,aCrops,"prod") = 0.01 * p_splitFactor(rnat,aCrops,"prod")/sum(aCrops1,p_splitFactor(rnat,aCrops1,"prod"));
   p_splitFactor(rNat,aCrops,spliti)   $ i_a(spliti,aCrops)                = 1;
*
*  --- diagonal non-animal use
*
   p_splitFactor(rNat,splita(anim),spliti)   $ (sum(i_a(spliti,anim1),1) and (not (sum(i_a(spliti,anim),1)) or sameas(spliti,"oapo-c")) ) = eps;
   p_splitFactor(rNat,"oapo-a","cattle-c")    = 1.E-3;
   p_splitFactor(rNat,"oapo-a","orum-c")      = 1.E-3;
*
*  --- use of animal products by crop activities: multiply the two production quantities
*
   meatLiveAnim(spliti) $ sum(is_i(spliti,i) $ meatLiveAnim(i),1) = YES;
   p_splitFactor(rNat,aCrops,meatLiveAnim) $ ((not p_splitFactor(rNat,aCrops,meatLiveAnim)))
    = (p_splitFactor(rnat,aCrops,"Prod") + sum(is, sam0(rnat,aCrops,is)) $ (not splita(aCrops)))
            * (sum(i_a(meatLiveAnim,splita),p_splitFactor(rnat,splita,"prod")) + sum(a, sam0(rNat,a,meatLiveAnim)) $ spliti(meatLiveAnim));

*
*  --- diagonal seed use (exemption is oapo-c which should comprise e.g. eggs)
*
   p_splitFactor(rNat,splita(anim),spliti)    $ (i_a(spliti,anim) and (not sameas(spliti,"oapo-c"))) = 1;
   p_splitFactor(rNat,splita(anim),spliti)    $ (i_a(spliti,anim) and (not sameas(spliti,"oapo-c"))) = 1;
*
   p_splitFactor(rNat,"ctlmeat-a","ctl-c")        = 0.99;
   p_splitFactor(rNat,"ctlmeat-a","ctlMeat-c")    = 0.99;
   p_splitFactor(rNat,"ctlmeat-a","orum-c")       = 0.01;
   p_splitFactor(rNat,"ctlmeat-a","orumMeat-c")   = 0.01;
   p_splitFactor(rNat,"orumMeat-a","orum-c")      = 0.99;
   p_splitFactor(rNat,"orumMeat-a","orumMeat-c")  = 0.99;
   p_splitFactor(rNat,"orumMeat-a","ctl-c")       = 0.01;
   p_splitFactor(rNat,"orumMeat-a","ctlMeat-c")   = 0.01;

   p_splitFactor(rNat,"othmeat-a","poul-c")   = 1;
   p_splitFactor(rNat,"pigMeat-a","poul-c")   = eps;
   p_splitFactor(rNat,"pigMeat-a","oapo-c")   = 0.001;
   p_splitFactor(rNat,"pigMeat-a","pig-c")    = 1;
   p_splitFactor(rNat,"pigMeat-a","oapo-c")   = 0.001;
   p_splitFactor(rNat,"pigMeat-a","pigMeat-c")  = 0.99;
   p_splitFactor(rNat,"pigMeat-a","othMeat-c")  = 0.01;
   p_splitFactor(rNat,"othMeat-a","pig-c")     = eps;
   p_splitFactor(rNat,"othMeat-a","poul-c")    = 1;
   p_splitFactor(rNat,"othMeat-a","oapo-c")    = 0.001;
   p_splitFactor(rNat,"othMeat-a","othMeat-c") = 0.99;
   p_splitFactor(rNat,"othMeat-a","pigMeat-c") = 0.01;
*
*  --- input demands for split-up activities should be scaled proportionally
*
   propAssmpt(rnat,i,         splita) = yes;
   propAssmpt(rnat,f,         splita) = yes;
   propAssmpt(rnat,lnd,       splita) = no;
*
*  --- exemptions: split up products
*
   propAssmpt(rnat,spliti   , splita) = no;
   propAssmpt(rnat,i,         splitaf) $ sum(is_i(spliti,i),1) =no;
   propAssmpt(rnat,i,         splitaf) $ sum(fabc_i(fabc,i),1) =no;
*
*  --- exemptions: feed use by animals
*
   aAnim(splita) $ sum(as_a(splita,"ctl-a"),1) = YES;
   aAnim(splita) $ sum(as_a(splita,"oap-a"),1) = YES;
   propAssmpt(rnat,i,splita) $ sum(fabc_i(fabc,i),1) = no;
*
*  --- assume same distribution of split-up products to industries where we don't have information
*      Exemption: FABIO provides information
*
   propAssmpt(rnat,spliti,a) $ ((not splita(a)) and (not (sum(faba_a(faba,a),1)) and sum(fabc_i(fabc,spliti),1)) ) = YES;
*
   meatLiveAnim("oapo-c") = no;
   propAssmpt(rNat,spliti,"afs-a")      = no;
   propAssmpt(rNat,spliti,"ofdAnim-a")  = no;
   propAssmpt(rNat,spliti,"ofdOther-a") = no;
   propAssmpt(rNat,cropsI,"ofdAnim-a")  = no;
   propAssmpt(rNat,cropsI,"ofdOther-a") = no;
   propAssmpt(rNat,meatLiveAnim,"ofdAnim-a")  = no;
   propAssmpt(rNat,meatLiveAnim,"ofdOther-a") = no;
   propAssmpt(rNat,"sgr-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"sgr-c","ofdOther-a") = no;
   propAssmpt(rNat,"rmk-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"rmk-c","ofdOther-a") = no;
   propAssmpt(rNat,"fsh-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"fsh-c","ofdOther-a") = no;
   propAssmpt(rNat,"mil-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"mil-c","ofdOther-a") = no;
   propAssmpt(rNat,"b_t-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"b_t-c","ofdOther-a") = no;
   propAssmpt(rNat,"pcr-c","ofdAnim-a")  = no;
   propAssmpt(rNat,"pcr-c","ofdOther-a") = no;
*
   propAssmpt(rNat,"mil-c",oilProc) = no;
   propAssmpt(rNat,"pcr-c",oilProc) = no;

   propAssmpt(rNat,"mil-c",meatLiveAnima) = no;
   propAssmpt(rNat,"pcr-c",meatLiveAnim)  = no;
   propAssmpt(rNat,"b_t-c",meatLiveAnim)  = no;
   propAssmpt(rNat,"sgr-c",meatLiveAnim)  = no;

   propAssmpt(rNat,"b_t-c",oilProc) = no;
   propAssmpt(rNat,"sgr-c",oilProc) = no;

$elseif.decl1 "%1"=="fix"

   $$batinclude 'build\split_based_on_fabio.gms' imptx
*
*  --- special cases where no information from FABIO
*      (1) use of animals and animal products by crops
*
   p_wgts(rnat,meatLiveAnim,cropsA) = 1.E-3;
   p_wgts(rNat,"pig-a",spliti)       $ ( (mapVal(p_wgts(rNat,spliti,"pig-a")) ne 8)      $ p_sam0(rNat,spliti,"pig-a")      ) = -0.9;
   p_wgts(rNat,"pig-a",splitiF)      $ ( (mapVal(p_wgts(rNat,"pig-a",splitiF)) ne 8)     $ p_sam0(rNat,"pig-a",splitiF)     ) = -0.9;
   p_wgts(rNat,"pig-a",lnd)          $ ( (mapVal(p_wgts(rNat,"pig-a",lnd)) ne 8)         $ p_sam0(rNat,"pig-a",lnd)         ) = -0.9;
   p_wgts(rNat,"pig-c","pigMeat-a")  $ ( (mapVal(p_wgts(rNat,"pig-c","pigMeat-a")) ne 8) $ p_sam0(rNat,"pig-c","pigMeat-a") ) = -0.9;
*
*      (2) seed use from specialized seed production ("OCR" comprises this)
*
   p_wgts(rnat,"ocro-c",cropsA) $ (not i_a("ocro-c",cropsA)) = 1.E-3;

   set vegExempt(i) /
      oveg-c         "Other Vegetables                                   "
      toma-c         "Tomatoes                                           "
      appl-c         "Apples                                             "
      grap-c         "Grapes                                             "
      citr-c         "Citrus fruits                                      "
      banp-c         "Bananas and plantains                              "
      ofru-c         "Other fruits                                       "
      v_fo-c         "Rest of v_f                                        "
      coff-c
      teas-c
      coco-c
      palm-c
      olv-c
   /;

   p_wgts(rNat,oilProcI,oilProc) = -0.99;
*
*  --- remove weights where proportionality assumptions are used
*
   p_wgts(rnat,is,js) $ propAssmpt(rnat,is,js)  = eps;
*
*  --- fruits and vegs might have quite different yields
*
   p_shareLo(rnat,f,splita) $ (as_a(splita,"v_f-a") or as_a(splita,"ocr-a") or as_a(splita,"ctl-a"))
      = sum(as_a(splita,a), sam0(rnat,f,a)/sum(isi,sam0(rnat,a,isi))) * 0.4;

   p_shareLo(rnat,spliti,splita) $ (p_splitFactor(rnat,splita,"prod") $ sum(i_a(spliti,splita),p_splitFactor(rnat,splita,spliti)) $ aCrops(splita))
      = sum((as_a(splita,a),is_i(spliti,i)), sam0(rnat,i,a)/sum(isi,sam0(rnat,a,isi)))*0.75;
   p_shareUp(rnat,spliti,splita) $ (p_splitFactor(rnat,splita,"prod") $ sum(i_a(spliti,splita),p_splitFactor(rnat,splita,spliti)) $ aCrops(splita))
      = sum((as_a(splita,a),is_i(spliti,i)), sam0(rnat,i,a)/sum(isi,sam0(rnat,a,isi)))*1.25;

*
*  --- for vegetable and fruits (mostly consumed fresh), the information from FABIO should be pretty accurate
*
   p_wgts(rNat,spliti,"hhsld") $ is_i(spliti,"v_f-c") = card(spliti);
*
*  --- the opposite should be true for oilseeds (hardly consumed fresh)
*
   p_wgts(rNat,spliti,"hhsld") $ is_i(spliti,"osd-c") = 0.1;
   p_wgts(rNat,spliti,"hhsld") $ is_i(spliti,"ctl-c") = 0.1;
   p_wgts(rNat,spliti,"hhsld") $ is_i(spliti,"oap-c") = 0.1;

   p_wgts(rNat,"ocro-c","hhsld") = 0.1;
   p_wgts(rNat,"ocro-c",splita) $ (not propAssmpt(rnat,"ocro-c",splita))  = 0.1;


   p_wgts(rNat,spliti,meatLiveAnima)       $ ((not propAssmpt(rnat,spliti,meatLiveAnima))  $ (is_i(spliti,"cmt") or is_i(spliti,"omt"))) = -0.99;
   p_wgts(rNat,vegExempt,meatLiveAnima)    $ (not propAssmpt(rnat,vegExempt,meatLiveAnima))  = -0.99;
   p_wgts(rNat,vegExempt,"ofdAnim-a")      $ (not propAssmpt(rnat,vegExempt,"ofdAnim-a"))    = -0.99;

   p_wgts(rnat,isi,"ofdAnim-a")  $ ((not isNation(isi)) $ (p_wgts(rnat,isi,"ofdAnim-a")  gt 0)) = p_wgts(rnat,isi,"ofdAnim-a")  * 0.10;
   p_wgts(rnat,isi,"ofdOther-a") $ ((not isNation(isi)) $ (p_wgts(rnat,isi,"ofdOther-a") gt 0)) = p_wgts(rnat,isi,"ofdOther-a") * 0.10;

   p_wgts(rnat,"ofdAnim-a",isi)  $ ((not isNation(isi)) $ (p_wgts(rnat,"ofdAnim-a",isi)  gt 0)) = p_wgts(rnat,"ofdAnim-a",isi)  * 0.10;
   p_wgts(rnat,"ofdOther-a",isi) $ ((not isNation(isi)) $ (p_wgts(rnat,"ofdOther-a",isi) gt 0)) = p_wgts(rnat,"ofdOther-a",isi) * 0.10;

$elseif.decl1 "%1"=="cleanse"

   $$batinclude 'build\split_based_on_fabio.gms' nutrients

$endif.decl1
