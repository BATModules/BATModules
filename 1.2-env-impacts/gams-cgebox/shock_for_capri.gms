********************************************************************************
$ontext

   CGEBox project

   GAMS file : shock_for_capri.gms

   @purpose  : Compute items that can be used to shock CAPRI
   @author   : Torbjörn Jansson,
   @date     : 11.04.24
   @since    : 2024
   @refDoc   : 
   @seeAlso  : https://github.com/BATModules/BATModules/wiki/REI-module-%E2%80%90-Regional-Environmental-Impacts
   @calledBy :

$offtext
********************************************************************************



*------------------------------------------------------------------------------
* Items needed by the interface with CAPRI
*------------------------------------------------------------------------------

* --- Producer price change vs baseline
*     Symbol ps(r,i,t) contains absolute price, we need to compare with SAM,
*     and take this opportunity to also forget about the time dimension

parameter p_dps(r,i) "Percentage change in producer price of traded good";

p_dps(r,i) $ ps.l(r,i,"bench")
    = ps.l(r,i,"shock")/ps.l(r,i,"bench")*100 - 100;


* --- Endowment price change vs baseline
*     Based on symbol pfa(r,f,a,t) ?
parameter p_dpfa(r,f,a) "Percentage change in price of endowment";

p_dpfa(r,f,a) $ pfa.l(r,f,a,"bench")
    = pfa.l(r,f,a,"shock")/pfa.l(r,f,a,"bench")*100 - 100;


* --- Domestic supply
*     Based on symbol xs(r,i,t)
parameter p_dxs(r,i) "Percentage change in domestic production";

p_dxs(r,i) $ xs.l(r,i,"bench") = xs.l(r,i,"shock")/xs.l(r,i,"bench")*100 - 100;


* --- Endowment share in total revenue per sector (i.e. cost shares)
*     Based on SAM(r,i,a)
parameter p_shrFa(r,f,a) "Share of factor f in total costs of activity a";

p_shrFa(r,f,a) $ sum(is, sam0(r,is,a))
    = sam0(r,f,a) / sum(is, sam0(r,is,a));


* --- Set of tradable commodities
*     Use the set i

* --- Set of endowment commodities
*     Use the set f

* --- Set of activities
*     Use the set a

* --- Set of regions
*     Use the set r

* --- Map tradable commodities to capri primary commodities
*     This is the tricky part... Now just a dummy start, inputs missing, and I used the 10x10 db.
*     Can we make this depend on the aggregation of CGEBOX in some clever way?
*     The old implementation used the GTAP commodities, but they turned out not to
*     be fine-grained enough to take e.g. GI commodities into account (or MAGNET disagg)
set iop(*) CAPRI marketable outputs /
    SWHE   'Soft wheat'
    DWHE    'Durum wheat'
    RYEM    'Rye and meslin'
    BARL    'Barley'
    OATS    'Oats'
    MAIZ    'Grain maize'
    OCER    'Other cereals'
    RAPE    'Rape seed'
    SUNF    'Sunflower seed'
    SOYA    'Soya seed'
    OOIL    'Other oil'
    OIND    'Other industrial crops'
    NURS    'Nurseries'
    FLOW    'Flowers'
    OCRO    'Other crops'
    NECR    'New energy crops'
    MAIF    'Fodder maize'
    ROOF    'Fodder root crops'
    OFAR    'Fodder other on from arable land'
    PARI    'Paddy rice'
    OLIV    'Olive oil'
    PULS    'Pulses'
    POTA    'Potatoes'
    SUGB    'Sugar beet'
    TEXT    'Flax and hemp'
    TOBA    'Tobacco'
    TOMA    'Tomatoes'
    OVEG    'Other vegetables'
    APPL    'Apples  pears and peaches'
    OFRU    'Other fruits'
    CITR    'Citrus fruits'
    TAGR    'Table grapes'
    TABO    'Table olives'
    TWIN    'Table wine'
    GRAS    'Gras'
    FGRA    'Gras'
    FMAI    'Fodder maize'
    FOFA    'Fodder other on arable land'
    FROO    'Fodder root crops'
    FCOM    'Milk for feeding'
    FSGM    'Sheep and Goat Milk for feeding'
    FSTR    'Straw'
    FCER    'Feed cereals'
    FPRO    'Feed rich protein'
    FENE    'Feed rich energy'
    FMIL    'Feed from milk product'
    FOTH    'Feed other'
    WADR    'Livestock drinking water'
    WASE    'Livestock service water'
    WATR    'Water balance or deficit'
    WIRR    'Gross irrigation water use by crop (m3/ha)'
    PESTOF  'Fungicides and bactericides incl seed treatments aggregate'
    PESTOH  'Herbicides, haulm destructors and moss killers aggregate'
    PESTOI  'Insecticides and acaricides incl seed treatments aggregate'
    PESTOG  'Plant growth regulators aggregate'
    PESTOO  'Other Pesticides aggregate'
    OANI    'Other animals output'
    NITF    'Nitrogen in fertiliser'
    PHOF    'Phospate in fertiliser [P2O5]'
    POTF    'Potassium in fertiliser [K2O]'
    PESTOTAL    'Pesticides (total)'
    STRA    'Straw'
    ARES    'Agricultural residuals usable for biofuels'
    YCOW    'Young cow'
    YBUL    'Young bull'
    YHEI    'Young heifer'
    YCAM    'Young male calf'
    YCAF    'Young female calf'
    YPIG    'Young piglet'
    YLAM    'Young lamb'
    YCHI    'Young chicken'
    COMI    'Milk for sales'
    COMF    'Milk for feeding'
    BEEF    'Beef'
    PORK    'Pork meat'
    SGMI    'Sheep and goat milk'
    SGMF    'Sheep and goat milk feeding'
    SGMT    'Sheep and goat meat'
    EGGS    'Eggs'
    POUM    'Poultry meat'
    MANN    'Nitrogen in manure'
    MANP    'Phospate in manure'
    MANK    'Potassium in manure'
    LRES    'Livestock residues usable for biofuels'
    ICAM    'Male calves'
    ICAF    'Female calves'
    IHEI    'Young heifers'
    ICOW    'Young cows'
    IPIG    'Piglets'
    IBUL    'Young bulls'
    ILAM    'Lambs'
    ICHI    'Chicken'
    CAOF    'Calcium in fertiliser'
    SEED    'Seed'
    REPM    'Maintenance materials'
    REPB    'Maintenance buildings'
    ELEC    'Electricity'
    EGAS    'Heating gas and oil'
    EFUL    'Fuels'
    ELUB    'Lubricants'
    IRRO    'Irrigation (other than water use)'
    INPO    'Other inputs'
    SERI    'Services input'
    mitiI   'efforts for GHG mitigation may be negative in case of benefits [Quantity measure in constant prices of 2005]'
    PESF    'Fungicides and bactericides'
    PESFBAC 'Bactericides'
    PESFBEN 'Fungicides based on benzimidazoles'
    PESFCAR 'Fungicides based on carbamates and dithiocarbamates'
    PESFINO 'Inorganic fungicides'
    PESFMOR 'Fungicides based on morpholines'
    PESFOTH 'Fung & Bact � Other'
    PESFTRI 'Fungicides based on imidazoles and triazoles'
    PESH    'Herbicides, haulm destructors and moss killers'
    PESHAMI 'Herbicides based on amides and anilides'
    PESHBIP 'Herbicides � Bipiridils'
    PESHCAR 'Herbicides based on carbamates and bis-carbamates'
    PESHDIN 'Herbicides based on dinitroaniline derivatives'
    PESHOTH 'Herbicides � Other'
    PESHPHE 'Herbicides based on phenoxy-phytohormones'
    PESHTIR 'Herbicides based on triazines and triazinones'
    PESHURAC    'Herbicides � Uracil'
    PESHURD 'Herbicides � Urea derivates'
    PESHURE 'Herbicides based on derivatives of urea, of uracil or of sulfonylurea'
    PESHURS 'Herbicides � Sulfonyl ureas'
    PESI    'Insecticides and acaricides'
    PESIACA 'Acaricides'
    PESIBOT 'Insecticides � Botanical products and biologicals'
    PESICAR 'Insecticides based on carbamates and oxime-carbamate'
    PESICHL 'Insecticides based on chlorinated hydrocarbons'
    PESIORG 'Insecticides based on organophosphates'
    PESIOTH 'Insecticides � Other'
    PESIPYR 'Insecticides based on pyrethroids'
    PESM    'Molluscicides'
    PESMOL  'Molluscicides1'
    PESMOL2 'Molluscicides2'
    PESO    'Other Pesticides nes'
    PESO2   'Other Pesticides nes2'
    PESPGR  'Plant growth regulators'
    PESPGR2 'Plant Growth Regulators'
    PESPGRANT   'Anti-sprouting products'
    PESPGROTH   'Other plant growth regulators'
    PESPGRPHY   'Physiological plant growth regulators'
    PESZR   'Other plant protection products'
    PESZRMIN    'Mineral oils'
    PESZRMIN2   'Mineral oils2'
    PESZROTH    'All other plant protection products'
    PESZRROD    'Rodenticides'
    PESZRSOI    'Soil sterilants (incl. nematicides)'
    PESZRVEG    'Vegetal oils'
    PESZRRAO    'Rodenticides � Anti-coagulants'
    PESDES  'Vegetal oils'
    PESSF   'Fungicides � Seed treatments'
    PESSFBEN    'Seed Treat Fung � Benzimidazoles'
    PESSFBOT    'Seed Treat Fung � Botanical products and biologicals'
    PESSFCAR    'Seed Treat Fung � Dithiocarbamates'
    PESSFORG    'Seed Treat Insect � Organo-phosphates'
    PESSFOTH    'Seed Treat Fung � Other'
    PESSFTRI    'Seed Treat Fung � Triazoles, diazoles'
    PESSI   'Insecticides � Seed Treatments'
    PESSICAR    'Seed Treat Insect � Carbamates'
    PESSIOTH    'Seed Treat Insect � Other'
    PESSIPYR    'Seed Treat Insect � Pyrethroids'
    RQUO    'Renting of milk quota'
    SERO    'Agricultural Services Output'
    NASA    'Non Agricultural Secondary Activities'
    mitiO   'Service output from GHG mitigation [Quantity measure in constant prices of 2005]'
    IPHA    'Pharmaceutical inputs'
/;

set i_iop(i,iop) "Map from tradable commmodities to CAPRI marketable outputs"/
    GrainsCrops-c.(SWHE,DWHE,RYEM,BARL,OATS,MAIZ,OCER,RAPE,SUNF,SOYA,MAIF,ROOF,OFAR,PARI,OLIV,PULS,POTA,SUGB,TEXT,TOBA,TOMA,OVEG,APPL,OFRU,CITR,TAGR,TABO,TWIN,GRAS,FCER,FPRO,FENE,FMIL,FOTH)
    MeatLstk-c.(YCOW,YBUL,YHEI,YCAM,YCAF,YPIG,YLAM,YCHI,COMI,COMF,BEEF,PORK,SGMI,SGMF,SGMT,EGGS,POUM)
    LightMnfc-c.(PESTOF,PESTOH,PESTOI,PESTOG,PESTOO,NITF,PHOF,POTF)
/;

* --- Map from activities to CAPRI activities. Entirely missing for the moment.
*     This is new, needed to set different labour and capital prices for different activities,
*     in case they are sluggish in the CGE. We didn't think of this with MIRAGE...
set a_mpact(a,*) "Should become a mapping from activity to capri production activity";

* --- Subset of factors are "labour or capital"
set labCap(f) "Factors that are labour or capital" /unSkLab,skLab,capital/;

* --- List CAPRI supply model countries to use in mapping
*     Similarly dummy mapping as the commodity one...
set rmssup(*) "CAPRI countries with supply model" /
    BL000000    'Belgium and Luxembourg'
    DK000000    'Denmark'
    DE000000    'Germany'
    EL000000    'Greece'
    ES000000    'Spain'
    FR000000    'France'
    IR000000    'Irland'
    IT000000    'Italy'
    NL000000    'The Netherlands'
    AT000000    'Austria'
    PT000000    'Portugal'
    SE000000    'Sweden'
    FI000000    'Finland'
    UK000000    'United Kingdom'
    CZ000000    'Czech Republic'
    HU000000    'Hungary'
    PL000000    'Poland'
    SI000000    'Slovenia'
    SK000000    'Slovak Republic'
    EE000000    'Estonia'
    LT000000    'Lithuania'
    LV000000    'Latvia'
    CY000000    'Cyprus'
    MT000000    'Malta'
    BG000000    'Bulgaria'
    RO000000    'Romania'
    NO000000    'Norway'
    TUR 'Turkey'
    AL000000    'Albania'
    MK000000    'Macedonia'
    CS000000    'Serbia'
    MO000000    'Montenegro'
    HR000000    'Croatia'
    BA000000    'Bosnia and Herzegovina'
    KO000000    'Kosovo'
/;

* --- Map regions to capri supply model countries
set r_rmssup(r,rmssup) "Map from region to CAPRI supply model country"/
    EU_25.(BL000000,DK000000,DE000000,EL000000,ES000000,FR000000,IR000000,IT000000,NL000000,AT000000,PT000000,SE000000,FI000000,UK000000,CZ000000,HU000000,PL000000,SI000000,SK000000,EE000000,LT000000,LV000000,CY000000,MT000000,BG000000,RO000000)
    restOfWorld.(NO000000,TUR,AL000000,MK000000,CS000000,MO000000,HR000000,BA000000,KO000000)
/;

*------------------------------------------------------------------------------
* Write out gdx for CAPRI
*------------------------------------------------------------------------------


* --- For now, just unload to gams directory

execute_unload "shock_for_capri.gdx" r,f,a,i,is,t,ps,pfa,xs,sam0
                        p_dps
                        p_dpfa
                        p_dxs
                        p_shrFa
                        i_iop
                        labCap
                        r_rmssup;

