

********************************************************************************
$iftheni.decl %1==decl
*
* --- Some key indicators

parameter endowm(rnat,is,*);
parameter totalendowm(*);
parameter sharendowm(is);


set GIa/chees_GI-a, Pigmeat_GI-a, bovMe_GI-a, PoulMeat_GI-a/;
*, butt_GI-a

set capri/beef, pork,eggs,rmk/;

set GIa_capri(a,capri) /
      bovMe_GI-a.beef
      Pigmeat_GI-a.pork
      PoulMeat_GI-a.eggs
      chees_GI-a.rmk
      butt_GI-a.rmk/;

set rnatGI/fra,deu, esp, ita, prt/;


parameter endow(rnat,is,GIa);
parameter totalendow(GIa);
parameter sharendow(is);

  
endowm("fra",is,"rmk-a")= sam0("fra",is,"rmk-a");
totalendowm("rmk-a")= sum(is, endowm("fra",is,"rmk-a"));
sharendowm(is)=endowm("fra",is,"rmk-a")/ totalendowm("rmk-a");



parameter pric_chang(rnat,GIa,t);
pric_chang(rGI,"Pigmeat_GI-a",t)= pp(rGI,"Pigmeat_GI-a",t );






$ontext
 $$iftheni.GDX not "%outputtypesGDX%"=="ON"

       $$setglobal outputtypesGDX on
       $$SETGLOBAL GDXOutputString sharendowm sharendow
        

  $$endif.GDX
  


  
$offtext


$endif.decl
  

*
 
*$else.decl