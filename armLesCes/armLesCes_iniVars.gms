********************************************************************************
$ontext

   CGEBOX project

   GAMS file : ARMLESCES_INIVARS.GMS

   @purpose  : Initalizate variables for LES-CES Armington model
   @author   : Wolfgang Britz
   @date     : 02.10.20
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : solve/iniVars.gms

$offtext
********************************************************************************
   pmtUArmCom(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro))
*
*       --- CES case with m_sigmaW <> 1
*
     =  [sum(armComExpReg $ (m_CombArmCom(armComExpReg,armComPro,armComImpReg)
%addCondXwArmCom2%
                     ),
               m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                     *(m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)
                      /m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur))**(1-m_sigmaW(armComImpReg,armComPro))
             )**(1/(1-m_sigmaW(armComImpReg,armComPro))) * m_axPmtCD(armComImpReg,armComPro,armComTCur)
         ] $ ((m_sigmaW(armComImpReg,armComPro) ne 1) $ m_axPmtCD(armComImpReg,armComPro,armComTCur))
*
*       --- CD case with m_sigmaW == 1
*
      + [prod(armComExpReg $ (m_CombArmCom(armComExpReg,armComPro,armComImpReg)
%addCondXwArmCom2%
                      ),
                     (m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)
                      /(m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                       *m_amwArmcom(armComExpReg,armComPro,armComImpReg,armComTCur)))**m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)
              ) * m_axPmtCD(armComImpReg,armComPro,armComTCur)
        ] $ ((m_sigmaW(armComImpReg,armComPro) eq 1) $ m_axPmtCD(armComImpReg,armComPro,armComTCur))
*
%addCondXwArmCom3%
    ;

    nonComImpExp(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro))
         = m_xmtArmCom(armComImpReg,armComPro,armComTCur) * m_pmtArmCom(armComImpReg,armComPro,armComTCur)
             - sum(armComExpReg $ p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur),
                       p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                        *m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur));

  xmtUArmCom(armComImpReg,armComPro,armComTCur) $ m_isArmCom(armComImpReg,armComPro)
     = nonComImpExp(armComImpReg,armComPro,armComTCur)/pmtUArmCom(armComImpReg,armComPro,armComTCur);

  m_xwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) $ (m_CombArmCom(armComExpReg,armComPro,armComImpReg)
                                                                  $ m_isArmCom(armComImpReg,armComPro))
*
      =  {m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) * xmtUArmCom(armComImpReg,armComPro,armComTCur)

                        *  [(pmtUArmCom(armComImpReg,armComPro,armComTCur)
                              /m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur))**m_sigmaW(armComImpReg,armComPro)
                            *  m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)**(m_sigmaW(armComImpReg,armComPro) - 1)
%addCondXwArmCom1%
                          ]
                          + p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)

           }
           $$iftheni.fudg "%armComFudg%"=="on"
                   $ (p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur) ge 0)

        -ncpVUSin(-m_xwArmCom_lo(armComExpReg,armComPro,armComImpReg,armComTCur),-[
            ( m_amwArmCom(armComExpReg,armComPro,armComImpReg,armComTCur) * xmtUArmCom(armComImpReg,armComPro,armComTCur)

                        * [ (pmtUArmCom(armComImpReg,armComPro,armComTCur)
                              /m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur))**m_sigmaW(armComImpReg,armComPro)
                            *  m_lambdamArmCom(armComExpReg,armComPro,armComImpReg,armComTCur)**(m_sigmaW(armComImpReg,armComPro) - 1)
%addCondXwArmCom1%
                          ]

                          + p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)

                  )
              ],1.E-7)  $ ( p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur) lt 0)
           $$endif.fudg
                ;

*
*  --- pmt from exhaustion
*
   m_pmtArmCom(armComImpReg,armComPro,armComTCur) $ (m_hasArmComImp(armComImpReg,armComPro) $ m_isArmCom(armComImpReg,armComPro))
     = (pmtUArmCom(armComImpReg,armComPro,armComTCur) * xmtUArmCom(armComImpReg,armComPro,armComTCur)
          +  sum(armComExpReg $ p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur),
                         p_amwCom(armComExpReg,armComPro,armComImpReg,armComTCur)
                         *m_pmcifPlusTarArmCom(armComRegExp,armComPro,armComRegImp,armComTCur)))
                         /xmtUArmCom(armComImpReg,armComPro,armComTCur);

