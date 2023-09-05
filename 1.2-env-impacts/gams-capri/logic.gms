*-------------------------------------------------------------------------------
*
*  @purpose: Link CAPRI supply models to the results of a GTAP-type CGE simulation
*            This includes a price shock coming from a parent model
*            and runs only the supply models of CAPRI
*            This particular file contains the logic and the mapping to GTAP.
*            This file won't run as a policy file, but contains the logic used by other scenarios.
*  @usage:   For an example of usage, see pol_input\link_cge\mirage.gms
*  @date: 2022-07-26
*  @author: Torbjorn Jansson, SLU
*
*-------------------------------------------------------------------------------

* --- Assert that the user does not attempt to run the market model.
*     That would be incompatible with the current top-down link

$ifi %MARKET_M%==ON $ABORT "Run with only the supply model if you want to link to another market model."
$ifi not %SUPPLY_MODEL%==ON $ABORT "You have to use the supply models to link to another market model."

* --- Assert that the needed input strings ($set someting in parent file) are provided
$set ERROR_HINT  "Hint: you cannot use logic.gms as scenario."
$if not set file_MM                 $abort "Missing input string file_MM in %system.fn%. %ERROR_HINT%"
$if not set  par_priceChgMmTrad     $abort "Missing input string par_priceChgMmTrad in %system.fn%. %ERROR_HINT%"
$if not set  par_priceChgMmEndw     $abort "Missing input string par_priceChgMmEndw in %system.fn%. %ERROR_HINT%"
$if not set  par_endwShareBaseline  $abort "Missing input string par_endwShareBaseline in %system.fn%. %ERROR_HINT%"
$if not set  set_mmTrad             $abort "Missing input string set_mmTrad in %system.fn%. %ERROR_HINT%"
$if not set  set_mmEndw             $abort "Missing input string set_mmEndw in %system.fn%. %ERROR_HINT%"
$if not set  map_GTAP_to_mmTrad     $abort "Missing input string map_GTAP_to_mmTrad in %system.fn%. %ERROR_HINT%"
$if not set  map_GTAP_to_mmEndw     $abort "Missing input string map_GTAP_to_mmEndw in %system.fn%. %ERROR_HINT%"
$if not set  map_GTAP_to_mmReg      $abort "Missing input string map_GTAP_to_mmReg in %system.fn%. %ERROR_HINT%"


*--------------------------------------------------------------------------------------------------
* --- Load a reference scenario to which the model has been calibrated
*--------------------------------------------------------------------------------------------------

$if not set baselineScenario $abort "Missing input string baselineScenario in %system.fn%."
$include "pol_input\%baselineScenario%"


*--------------------------------------------------------------------------------------------------
* --- Map GTAP 10 sectors and regions to CAPRI.
*--------------------------------------------------------------------------------------------------

set TRAD_COMM "GTAP tradable commodities (sectors)" /
    pdr 'Paddy rice'
    wht 'Wheat'
    gro 'Cereal grains nec'
    v_f 'Vegetables, fruit, nuts'
    osd 'Oil seeds'
    c_b 'Sugar cane, sugar beet'
    pfb 'Plant-based fibers'
    ocr 'Crops nec'
    ctl 'Bovine cattle, sheep, goats, horses'
    oap 'Animal products nec'
    rmk 'Raw milk'
    wol 'Wool, silk-worm cocoons'
    frs 'Forestry'
    fsh 'Fishing'
    coa 'Coal'
    oil 'Oil'
    gas 'Gas'
    oxt 'Other Extraction (formely omn Mineral nec)'
    cmt 'Bovine meat products'
    omt 'Meat products nec'
    vol 'Vegetable oils and fats'
    mil 'Dairy products'
    pcr 'Processed rice'
    sgr 'Sugar'
    ofd 'Food products nec'
    b_t 'Beverages and tobacco products'
    tex 'Textiles'
    wap 'Wearing apparel'
    lea 'Leather products'
    lum 'Wood products'
    ppp 'Paper products, publishing'
    p_c 'Petroleum, coal products'
    chm 'Chemical products'
    bph 'Basic pharmaceutical products'
    rpp 'Rubber and plastic products'
    nmm 'Mineral products nec'
    i_s 'Ferrous metals'
    nfm 'Metals nec'
    fmp 'Metal products'
    ele 'Computer electronic and optical products'
    eeq 'Electrical equipment'
    ome 'Machinery and equipment nec'
    mvh 'Motor vehicles and parts'
    otn 'Transport equipment nec'
    omf 'Manufactures nec'
    ely 'Electricity'
    gdt 'Gas manufacture'
    wtr 'Water'
    cns 'Construction'
    trd 'Trade'
    afs 'Accomodation, Food and service activities'
    otp 'Transport nec'
    wtp 'Water transport'
    atp 'Air transport'
    whs 'Warehousing and support activities'
    cmn 'Communication'
    ofi 'Financial services nec'
    ins 'Insurance (formely isr)'
    rsa 'Real estate activities'
    obs 'Business services nec'
    ros 'Recreational and other services'
    osg 'Public administration and defense'
    edu 'Education'
    hht 'Human health and social work activities'
    dwe 'Dwellings'

/;

set map_io_to_gtap(rows,TRAD_COMM) "Map CAPRI IO to gtap TRAD_COMM"/
    SWHE.wht
    DWHE.wht
    RYEM.gro
    BARL.gro
    OATS.gro
    MAIZ.gro
    OCER.gro
    RAPE.osd
    SUNF.osd
    SOYA.osd
    OOIL.osd
    OIND.ocr
    NURS.ocr !?
    FLOW.ocr !?
    OCRO.ocr
    NECR.ocr !?
*    MAIF.
*    ROOF.
*    OFAR.
    PARI.pdr
    OLIV.v_f
    PULS.ocr !?
    POTA.v_f
    SUGB.v_f
    TEXT.pfb
    TOBA.b_t
    TOMA.v_f
    OVEG.v_f
    APPL.v_f
    OFRU.v_f
    CITR.v_f
    TAGR.v_f
    TABO.v_f
    TWIN.v_f

    COMI.rmk
    COMF.mil
    BEEF.ctl
    PORK.oap
    SGMI.rmk
    SGMF.mil
    SGMT.ctl
    EGGS.oap
    POUM.oap

*   --- All inputs mapped to some GTAP output
*   Tradable feeding stuffs linked to primary agricultural commodities in GTAP
    FCER.(wht,gro)
    FPRO.osd
    FENE.ocr
    FMIL.mil
    FOTH.ocr
    
*   Anorganic fertilizers
    NITF.chm
    POTF.chm
    PHOF.chm
    

*   Objective function costs
*    WATR.Serv
    CAOF.chm
    SEED.omf        Putting seed cost to other manufactures since it is not crop-specific
    PLAP.chm
    REPM.cns        Repairs mapped to construction
    REPB.cns        Repairs mapped to construction
    ELEC.ely        Electricity
    EGAS.p_c        Petroleum
    EFUL.p_c        Petroleum
    ELUB.p_c        Petroleum
    IRRO.cns        Irrigation costs mapped to construction
    INPO.omf        Other inputs map to other manufactures
    SERI.(otp,wtp,atp,whs,cmn,ofi,ins,rsa,obs)       Services inputs linked to several service sectors ()
    IPHA.chm
    

*   Young animals
    ICAM.ctl
    ICAF.ctl
    IHEI.ctl
    ICOW.ctl
    IPIG.oap
    IBUL.ctl
    ILAM.oap
    ICHI.oap
    
    YCOW.ctl
    YBUL.ctl
    YHEI.ctl
    YCAM.ctl
    YCAF.ctl
    YPIG.oap
    YLAM.oap
    YCHI.oap

/;

set gtap_reg Countries (regions) in GTAP /
    AUS 'Australia'
    NZL 'New Zealand'
    XOC 'Rest of Oceania'
    CHN 'China'
    HKG 'Hong Kong'
    JPN 'Japan'
    KOR 'Korea Republic of'
    MNG 'Mongolia'
    TWN 'Taiwan'
    XEA 'Rest of East Asia'
    BRN 'Brunei Darussalam'
    KHM 'Cambodia'
    IDN 'Indonesia'
    LAO 'Lao Peoples Democratic Republic'
    MYS 'Malaysia'
    PHL 'Philippines'
    SGP 'Singapore'
    THA 'Thailand'
    VNM 'Viet Nam'
    XSE 'Rest of Southeast Asia'
    BGD 'Bangladesh'
    IND 'India'
    NPL 'Nepal'
    PAK 'Pakistan'
    LKA 'Sri Lanka'
    XSA 'Rest of South Asia'
    CAN 'Canada'
    USA 'United States of America'
    MEX 'Mexico'
    XNA 'Rest of North America'
    ARG 'Argentina'
    BOL 'Bolivia, Plurinational Republic of'
    BRA 'Brazil'
    CHL 'Chile'
    COL 'Colombia'
    ECU 'Ecuador'
    PRY 'Paraguay'
    PER 'Peru'
    URY 'Uruguay'
    VEN 'Venezuela'
    XSM 'Rest of South America'
    CRI 'Costa Rica'
    GTM 'Guatemala'
    HND 'Honduras'
    NIC 'Nicaragua'
    PAN 'Panama'
    SLV 'El Salvador'
    XCA 'Rest of Central America'
    DOM 'Dominican Republic'
    JAM 'Jamaica'
    PRI 'Puerto Rico'
    TTO 'Trinidad and Tobago'
    XCB 'Caribbean'
    AUT 'Austria'
    BEL 'Belgium'
    CYP 'Cyprus'
    CZE 'Czech Republic'
    DNK 'Denmark'
    EST 'Estonia'
    FIN 'Finland'
    FRA 'France'
    DEU 'Germany'
    GRC 'Greece'
    HUN 'Hungary'
    IRL 'Ireland'
    ITA 'Italy'
    LVA 'Latvia'
    LTU 'Lithuania'
    LUX 'Luxembourg'
    MLT 'Malta'
    NLD 'Netherlands'
    POL 'Poland'
    PRT 'Portugal'
    SVK 'Slovakia'
    SVN 'Slovenia'
    ESP 'Spain'
    SWE 'Sweden'
    GBR 'United Kingdom'
    CHE 'Switzerland'
    NOR 'Norway'
    SRB 'Serbia and Montenegro'
    XEF 'Rest of EFTA'
    ALB 'Albania'
    BGR 'Bulgaria'
    BLR 'Belarus'
    HRV 'Croatia'
    ROU 'Romania'
    RUS 'Russian Federation'
    UKR 'Ukraine'
    XEE 'Rest of Eastern Europe'
    XER 'Rest of Europe'
    KAZ 'Kazakhstan'
    TJK 'Tajikistan'
    KGZ 'Kyrgyzstan'
    XSU 'Rest of Former Soviet Union'
    ARM 'Armenia'
    AZE 'Azerbaijan'
    GEO 'Georgia'
    BHR 'Bahrain'
    IRN 'Iran Islamic Republic of'
    IRQ 'Iraq'
    ISR 'Israel'
    JOR 'Jordan'
    KWT 'Kuwait'
    LBN 'Lebanon'
    OMN 'Oman'
    PSE 'Palestinian Territory'
    QAT 'Qatar'
    SAU 'Saudi Arabia'
    TUR 'Turkey'
    SYR 'Syrian Arab Republic'
    ARE 'United Arab Emirates'
    XWS 'Rest of Western Asia'
    EGY 'Egypt'
    MAR 'Morocco'
    TUN 'Tunisia'
    XNF 'Rest of North Africa'
    BEN 'Benin'
    BFA 'Burkina Faso'
    CMR 'Cameroon'
    CIV 'Cote dIvoire'
    GHA 'Ghana'
    GIN 'Guinea'
    NGA 'Nigeria'
    SEN 'Senegal'
    TGO 'Togo'
    XWF 'Rest of Western Africa'
    XCF 'Central Africa'
    XAC 'South Central Africa'
    ETH 'Ethiopia'
    KEN 'Kenya'
    MDG 'Madagascar'
    MWI 'Malawi'
    MUS 'Mauritius'
    MOZ 'Mozambique'
    RWA 'Rwanda'
    SDN 'Sudan'
    TZA 'Tanzania United Republic of'
    UGA 'Uganda'
    ZMB 'Zambia'
    ZWE 'Zimbabwe'
    XEC 'Rest of Eastern Africa'
    BWA 'Botswana'
    NAM 'Namibia'
    ZAF 'South Africa'
    XSC 'Rest of South African Customs Union'
    XTW 'Rest of the World '    
/;

set map_rmssup_to_gtap(rall,gtap_reg) "Map CAPRI region to GTAP region"/

AL000000.ALB
AT000000.AUT
BA000000.XEE
BG000000.BGR
*   We map CAPRI Belgium to GTAP Belgium and ignore Luxemburg.
BL000000.BEL
CS000000.SRB
CY000000.CYP
CZ000000.CZE
DE000000.DEU
DK000000.DNK
EE000000.EST
EL000000.GRC
ES000000.ESP
FI000000.FIN
FR000000.FRA
HR000000.HRV
HU000000.HUN
IR000000.IRL
IT000000.ITA
KO000000.XEE
LT000000.LTU
LV000000.LVA
MK000000.XEE
MO000000.SRB
MT000000.MLT
NL000000.NLD
NO000000.NOR
PL000000.POL
PT000000.PRT
RO000000.BGR
SE000000.SWE
SI000000.SVN
SK000000.SVK
UK000000.GBR
/;

set ENDW_COMM GTAP endowment commodities /
Land
tech_aspros
clerks
service_shop
off_mgr_pros
ag_othlowsk
Capital
NatlRes
CNTER
/;

SET map_labCap_to_gtap(rows,ENDW_COMM) "Linking CAPRI quasi-factors to GTAP endowments" /
*    uaar.Land
    pmpt.tech_aspros 
    pmpt.clerks
    pmpt.service_shop
    pmpt.off_mgr_pros
    pmpt.ag_othlowsk
    pmpt.Capital
*    nat.NatlRes
    /;


*--------------------------------------------------------------------------------------------------
* --- General logic of the link, using the model specifi settings of each Market Model
*--------------------------------------------------------------------------------------------------

$gdxin %file_MM%

* --- Get the sets of commodities and regions in MM
set mmTrad(*) Linked commodities;
$load mmTrad = %set_mmTrad%

set mmEndw(*) Linked endowments;
$load mmEndw = %set_mmEndw%

set mmReg(*) Linked regions;
$load mmReg  = %set_mmReg%


* --- Contruct two mappings to achieve MM --> GTAP --> CAPRI
set map_gtap_to_mmTrad(TRAD_COMM,mmTrad) "Map GTAP to MM";
$load map_gtap_to_mmTrad = %map_GTAP_to_mmTrad%

set map_gtap_to_mmEndw(ENDW_COMM,mmEndw) "Map GTAP to MM";
$load map_gtap_to_mmEndw = %map_GTAP_to_mmEndw%

set map_gtap_to_mmReg(gtap_reg,mmReg) "Map GTAP to MM";
$load map_gtap_to_mmReg = %map_GTAP_to_mmReg%

set io_to_mmTrad(rows,mmTrad) "Map CAPRI IO to MM tradable sectors";
io_to_mmTrad(IO,mmTrad) = sum(TRAD_COMM $ [map_io_to_gtap(IO,TRAD_COMM) and map_gtap_to_mmTrad(TRAD_COMM,mmTrad)], 1);

set pact_to_mmTrad(mpact,mmTrad) "Map CAPRI production activities to mm sectors";
pact_to_mmTrad(mpact,mmTrad) = sum(IO $ [pact_to_y(mpact,IO) and IO_to_mmTrad(io,mmTrad)], 1);

set labCap_to_mmEndw(rows,mmEndw) "Map CAPRI quasi-endowments to MM endowment sectors";
labCap_to_mmEndw(rows,mmEndw) = sum(ENDW_COMM $ [map_labCap_to_gtap(rows,ENDW_COMM) and map_gtap_to_mmEndw(ENDW_COMM,mmEndw)], 1);

set rmssup_to_mmReg(rall,mmReg) "Map CAPRI IO to MM regions";
rmssup_to_mmReg(rmssup,mmReg) = sum(gtap_reg $ [map_rmssup_to_gtap(rmssup,gtap_reg) and map_gtap_to_mmReg(gtap_reg,mmReg)], 1);


* --- VERIFY LINK INTEGRITY. HOW?


* --- Get data from the Market Model
parameter %par_priceChgMmTrad% "The parameter of the Market Model containing price changes";
$load %par_priceChgMmTrad%

parameter %par_priceChgMmEndw% "The parameter of the Market Model containing price changes";
$load %par_priceChgMmEndw%

parameter %par_quantMmTrad% "The parameter of the Market Model containing quantity changes";
$load %par_quantMmTrad%

parameter %par_quantChgMmTrad% "The parameter of the Market Model containing quantity changes";
$load %par_quantChgMmTrad%

parameter %par_endwShareBaseline% "The parameter of the Market Model containing endowment cost shares";
$load %par_endwShareBaseline%

*parameter p_mmChangeFactors(rall,cols,rows) "All change factors of the market model converted to CAPRI products and regions";
parameter p_mmReport(rall,cols,rows,*) "Report values from the market model converted to CAPRI products and regions";


* --- Shift prices of outputs and inputs in CAPRI (plain average, what should the weights be?)
DATA(RMSSUP,"UVAG",OMS,"ChangeFactor")
   
   $ SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_priceChgMmTrad(mmReg,mmTrad)], 1)
   = SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad)], 1 + m_priceChgMmTrad(mmReg,mmTrad)/100)
   / SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_priceChgMmTrad(mmReg,mmTrad)], 1);
   

* --- Shift the PMP-constant in proportion to the change in labour and capital costs

* Compute the share of labour and capital use in each CAPRI activity as indicated by the mapped MM sectors

* Approximate the use of LabCap in CAPRI by the share of corresponding endowments in MM times output value in CAPRI
parameter p_shareLabCap(rall,pact,mmEndw) "This parameter is just meant for inspecting the implied labour and capital shares";
p_shareLabCap(rmssup,mpact,mmEndw) $ sum(labCap_to_mmEndw(rows,mmEndw), 1)
    = sum((mmReg,mmTrad) $ [rmssup_to_mmReg(rmssup,mmReg) and pact_to_mmTrad(mpact,mmTrad)], m_endwShareBaseline(mmReg,mmEndw,mmTrad));

parameter p_shiftLabCap(rall,pact,rows) "The shift in labour and capital costs in percent of the total revenues";
p_shiftLabCap(rmssup,mpact,rows) 
    = sum((mmReg,mmEndw,mmTrad) $ [rmssup_to_mmReg(rmssup,mmReg) and labCap_to_mmEndw(rows,mmEndw) and pact_to_mmTrad(mpact,mmTrad)],
        m_endwShareBaseline(mmReg,mmEndw,mmTrad) * m_priceChgMmEndw(mmReg,mmEndw,mmTrad));

* Compute a shift of the pmp constant that is similar to the labour and capital shift when expressed as share of revenuess.
parameter p_shiftPMPcnst(rall,pact,a) "Absolute amount (1000 euro per hectare or head) by which to shift the PMP constant";
loop(rmssup,
    p_shiftPMPcnst(rs,mpact,a) $ [p_technFact(rs,mpact,"LEVL",a) and map_rr(rmssup,rs)]
        = (sum(pact_to_y(mpact,io), data(rmssup,"uvag",io,"y")*data(rs,mpact,io,"y")*(1+p_technFact(rs,mpact,io,a)))/1000
           + data(rmssup,mpact,"prme","y"))
        * sum(rows $ p_shiftLabCap(rmssup,mpact,rows), p_shiftLabCap(rmssup,mpact,rows)/100);
);

p_pmpCnst(rs,mpact,A) = p_pmpCnst(rs,mpact,A) + p_shiftPMPcnst(rs,mpact,a);


* --- Collect some items to report to the DATAOUT parameter and to the "traffic light similarity index"

p_mmReport(RMSSUP,"GROF",OMS,"Absolute")
   = SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad)], m_quantMmTrad(mmReg,mmTrad));

p_mmReport(RMSSUP,"GROF",OMS,"PercentChange")  
   $ SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_quantChgMmTrad(mmReg,mmTrad)], m_quantMmTrad(mmReg,mmTrad))
   = SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad)], m_quantMmTrad(mmReg,mmTrad)*m_quantChgMmTrad(mmReg,mmTrad))
   / SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_quantChgMmTrad(mmReg,mmTrad)], m_quantMmTrad(mmReg,mmTrad));

p_mmReport(RMSSUP,"GROF",OMS,"ChangeFactor")  
   $ SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_quantChgMmTrad(mmReg,mmTrad)], m_quantMmTrad(mmReg,mmTrad))
   = SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad)], m_quantMmTrad(mmReg,mmTrad)*(1 + m_quantChgMmTrad(mmReg,mmTrad)/100))
   / SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_quantChgMmTrad(mmReg,mmTrad)], m_quantMmTrad(mmReg,mmTrad));


p_mmReport(RMSSUP,"UVAG",OMS,"ChangeFactor") = DATA(RMSSUP,"UVAG",OMS,"ChangeFactor");

p_mmReport(RMSSUP,"UVAG",OMS,"PercentChange")
   $ SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_priceChgMmTrad(mmReg,mmTrad)], 1)
   = SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad)], m_priceChgMmTrad(mmReg,mmTrad))
   / SUM((mmReg,mmTrad) $ [RMSSUP_to_mmReg(RMSSUP,mmReg) and io_to_mmTrad(OMS,mmTrad) and m_priceChgMmTrad(mmReg,mmTrad)], 1);

* In a CGE model, the price is "1" in the baseline? I think we can assume so. Then the simulated price = changefactor 
p_mmReport(RMSSUP,"UVAG",OMS,"Absolute") = p_mmReport(RMSSUP,"UVAG",OMS,"ChangeFactor");

p_mmReport(RMSSUP,mpact,rows,"ChangeFactor") $ p_shiftLabCap(rmssup,mpact,rows) = (1 + p_shiftLabCap(rmssup,mpact,rows) / 100);
p_mmReport(RMSSUP,mpact,rows,"PercentChange") $ p_shiftLabCap(rmssup,mpact,rows) = p_shiftLabCap(rmssup,mpact,rows);


* --- Unload GDX-file here if you want to inspect the data at this point.
execute_unload "%scrdir%\chk_link_data_all.gdx";


*--------------------------------------------------------------------------------------------------
* --- Clean up in memory by killing parameters containing MM data
*--------------------------------------------------------------------------------------------------

option kill = %par_priceChgMmTrad%;
option kill = %par_priceChgMmEndw%;
option kill = %par_quantChgMmTrad%;
option kill = %par_endwShareBaseline%;

