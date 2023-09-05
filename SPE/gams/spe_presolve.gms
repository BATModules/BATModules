********************************************************************************
$ontext

   CBGEBox project

   GAMS file : SPE_PRESOLVE.GMS

   @purpose  : Separate presolve of SPE markets in partial equilibrium setting
   @author   : W.Britz
   @date     : 16.11.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : solve/solveModel.gms

$offtext
********************************************************************************
$ifi not "%preSolveSpe%"=="on" $exit
$ifi "%overallClosure%"=="PE" $exit
$ifi "%regMode%"=="Single region" $exit
if( not sameas(tSim,"%t0%"),

$$batinclude 'util/title.gms' "'Presolve SPE model %dataset%, %shock_withoutPath% for '" tSim.te(tSim)
*
* --- only include the SPE products in model
*
  solveLinkOri  = gtap.solveLink;
  solveTypeOri  = solveType;
  $$ifi "%useGridSolve%"=="on" gtap.solvelink = 6;
  if ( card(iSpe) eq 1, gtap.SolveLink = 5);
  option kill=handles;
*
* --- reset
*
*
  $$ifi not %noOutputFromPresolves%==on  option asyncSolLst=1;
  $$ifi %noOutputFromPresolves%==on      option asyncSolLst=0;

  $$ifi %solprint%==On     gtap.solprint = 1;
  $$ifi %solprint%==Off    gtap.solprint = 0;
  $$ifi %solprint%==silent gtap.solprint = 2;
*
* --- Note don't write iSpe(kp) as otherwise, implicite loop in fix_for_pe will not work!
*
  loop(kp $ iSpe(kp),

     option kill=iiN; iIn(kp) = yes;
     option kill=aiN; aIn(a) $ sum ( (rs,iIn), xFlag(rs,a,iIn)) = YES;
     $$include "model/fix_for_pe.gms"

     ps.lo(rs,iIn,tSim) = ps.l(rs,iIn,tSim) * 0.80;
     ps.up(rs,iIn,tSim) = ps.l(rs,iIn,tSim) * 1.20;

     gtap.optfile = standardOptfile;
     $$iftheni.modelType "%mcpSolve%"=="MCP"
        solveType = MCP;
        solve gtap using MCP;
     $$else.modelType
        solveType = NLP;
        solve gtap using NLP minimizing v_obje;
     $$endif.modelType
     $$batinclude "model/closures.gms" noIniVars

     if ((gtap.solvelink eq 6) and (not execError), handles(kp) = gtap.handle);

     if (gtap.solvelink eq 5,
            put_utility 'msglog' /  'Presolve for SPE product "' kp.tl:0, '", "%Shock%" for year "' tSim.tl:0,
                         '" solved with ' gtap.numinfes:0:0 ,
                         ' remaining infeas., sum of infeas. ' gtap.suminfes:0:3 ,
                         ' , maxInfes: ',gtap.maxInfes:0:8 ,
                         ' , # of redefs ' gtap.numredef:0:0;
     );
  );

*
* --- reset solvelink to standard (in memory call)
*

  $$iftheni.gridsolve "%useGridSolve%"=="on"

     if ( card(handles),

        rc = readyCollect(handles,120);

        repeat

          loop(kp $ handleCollect(handles(kp)),
            display $ handledelete(handles(kp)) 'trouble deleting handles';
            handles(kp) = 0;

            put_utility 'msglog' /  'Presolve for SPE product "' kp.tl:0, '", "%Shock%" for year "' tSim.tl:0,
                         '" solved with ' gtap.numinfes:0:0 ,
                         ' remaining infeas., sum of infeas. ' gtap.suminfes:0:3 ,
                         ' , maxInfes: ',gtap.maxInfes:0:8 ,
                         ' , # of redefs ' gtap.numredef:0:0;
          );
          rc = sleep(card(handles)*0.1);
        until ( (card(handles) eq 0)  );
     );
  $$endif.gridsolve

  $$batinclude "model/closures.gms" noIniVars
  $$batinclude "solve/Inivars.gms"

  option asyncSolLst=0;
  solveType = solveTypeOri;
  gtap.solvelink = solveLinkOri;
);

