%LET _CLIENTTASKLABEL='CHIS_60_Regression';
%LET _CLIENTPROCESSFLOWNAME='CHIS_Execution';
%LET _CLIENTPROJECTPATH='C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\AsthmaAnalysis.egp';
%LET _CLIENTPROJECTPATHHOST='R90T7H56';
%LET _CLIENTPROJECTNAME='AsthmaAnalysis.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
/*************************************************************************************
**  Project Name    : Secondary Research of Asthma  Hospitalizations                **
**                    Masters of Science in Business Analytics Capstone Project     **
**                    March / April 2019                                            **
**  Author          : Matthew C. Vanderbilt                                         **
**                    MSBA Candidate & NU Scholar, National University              **
**                    Director of Fiscal Affairs, Department of Medicine,           **
**                    UC San Diego School of Medicine                               **
**  =============================================================================== **
**  Date Created    : 04 April 2019 13:37                                           **
**  Program Name    : CHIS_60_Regression                                            **
**  Purpose         : Additional Categorical Exploratory Data Analysis              **
**  Note            : Capitalized values represent SAS commands and unadjusted      **
**                    variables; lower-case variables represent study-created       **
**                    variables.                                                    **
**                                                                                  **
*************************************************************************************/

/* DISABLE SAS GRAPHICS */
ODS GRAPHICS OFF;

/* GLOBAL VARIABLES */
* Determine File Path for SAS EGP;
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));

/* MASTER LIBRARIES */
LIBNAME CHIS "&localProjectPath.CHIS";

/* Determine PDF Password */
* Pull PDF Password from Text;
FILENAME scrPath "&localProjectPath.PDFPassword.txt";
DATA _NULL_;
    LENGTH text $265;
    RETAIN text '';
    INFILE scrPath FLOWOVER DLMSTR='//' END=last;
    INPUT;
    text = CATS(text,_INFILE_);
    IF last THEN CALL SYMPUT('rawpath',text);
RUN;
%LET pdfPassword = %SYSFUNC(TRIM(%SYSFUNC(DEQUOTE(&rawpath))));

/* DEFINE GLOBAL OPTIONS */
ODS GRAPHICS OFF;
OPTIONS PDFPASSWORD=(owner="&pdfPassword");
OPTIONS PDFSECURITY=HIGH;

/* CREATE CUSTOM FORMATS */
OPTIONS fmtsearch=(CHIS);

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-FULL.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE  'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Full Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      SRSEX(REF='Male')
                   RACEDF_P1(REF='White')
                   AB22(REF='No')
                   AB24(REF='No')
                   AB25(REF='No')
                   AB30(REF='No')
                   AB34(REF='No')
                   AB52(REF='No')
                   AD37W(REF='No')
                   AD40W(REF='No')
                   AESODA_P1(REF='0 Times')
                   AE15(REF='No')
                   AE15A(REF='Not at All')
                   SMKCUR(REF='Not Current Smoker')
                   SMOKING(REF='Never Smoked Regularly')
                   NUMCIG(REF='None')
                   AC42_P(REF='Always')
                   AC44(REF='Always')
                   AD50(REF='No')
                   RBMI(REF='Normal 18.5-24.99')
                   AF65(REF='Not at All')
                   AF63(REF='Not at All')
                   DSTRS12(REF='No')
                   AH33NEW(REF='Born in U.S.')
                   AH34NEW(REF='Born in U.S.')
                   AH35NEW(REF='Born in U.S.')
                   AH37(REF='Very Well')
                   CITIZEN2(REF='US-Born Citizen')
                   YRUS_P1(REF='Inapplicable')
                   PCTLF_P(REF='81+')
                   AG22(REF='No')
                   WRKST_P1(REF='Full-Time Employment (21+ hrs/week)')
                   AHEDC_P1(REF='Bachelors Degree')
                   AK4(REF='Government')
                   FSLEV(REF='Inapplicable / >=200% FPL')
                   POVLL(REF='300% FPL and Above')
                   AL6(REF='No')
                   AL22(REF='No')
                   AL18A(REF='No')
                   AM19(REF='Strongly Agree')
                   AM21(REF='Strongly Agree')
                   AK28(REF='All of the Time')
                   AM36(REF='No')
                   AM34(REF='All or Almost All Calls on Cell Phones')
                   UR_CLRT(REF='Town & Rural')
                   maritstat(REF='Married/Partnered')
                   agegroup(REF='Young Adult (18-39)')
                   asthmastatus(REF='1 Current Asthmatic')
                   prilanguage(REF='English (Includes English & Other)')
                   famtype(REF='Married w/ Children')
                   ;
        MODEL asthmastatus = SRSEX
                             RACEDF_P1
                             AB22
                             AB24
                             AB25
                             AB30
                             AB34
                             AB52
                             AD37W
                             AD40W
                             AESODA_P1
                             AE15
                             AE15A
                             SMKCUR
                             SMOKING
                             NUMCIG
                             AC42_P
                             AC44
                             AD50
                             RBMI
                             AF65
                             AF63
                             DSTRS12
                             AH33NEW
                             AH34NEW
                             AH35NEW
                             AH37
                             CITIZEN2
                             YRUS_P1
                             PCTLF_P
                             AG22
                             WRKST_P1
                             AHEDC_P1
                             AK4
                             FSLEV
                             POVLL
                             AL6
                             AL22
                             AL18A
                             AM19
                             AM21
                             AK28
                             AM36
                             AM34
                             UR_CLRT
                             maritstat
                             agegroup
                             prilanguage
                             famtype
                             / LINK=GLOGIT CTABLE PPROB = (0.148) 
                                  CORRB COVB RSQUARE STB
                                ;/*CA Asthma Rate*/
    RUN;
ODS PDF CLOSE;

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-BASIC.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Basic Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      asthmastatus(REF='1 Current Asthmatic')
                   srsex(REF='Male')
                   dstrs12(REF='No') 
                   rbmi(REF='Normal 18.5-24.99')
                   citizen2(REF='US-Born Citizen')
                   povll(REF='300% FPL and Above');
        MODEL asthmastatus = srsex
                             dstrs12
                             rbmi
                             citizen2
                             povll 
                             / LINK=GLOGIT CTABLE PPROB = (0.148) 
                                  CORRB COVB RSQUARE STB
                                ;/*CA Asthma Rate*/
    RUN;
ODS PDF CLOSE;

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-PRUNED.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Pruned Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      asthmastatus(REF='1 Current Asthmatic')
                   SRSEX(REF='Male')
                   agegroup(REF='Young Adult (18-39)')
                   CITIZEN2(REF='US-Born Citizen')
                   famtype(REF='Married w/ Children')
                   UR_CLRT(REF='Town & Rural')
                   RBMI(REF='Normal 18.5-24.99')
                   SMOKING(REF='Never Smoked Regularly')
                   DSTRS12(REF='No')
                   POVLL(REF='300% FPL and Above')
                   FSLEV(REF='Inapplicable / >=200% FPL')
                   AK4(REF='Government')
                   healthplan(REF='Inapplicable')
                   ;
        MODEL asthmastatus = SRSEX
                             agegroup
                             CITIZEN2
                             famtype
                             UR_CLRT
                             RBMI
                             SMOKING
                             DSTRS12
                             POVLL
                             FSLEV
                             AK4
                             healthplan
                             / LINK=GLOGIT CTABLE PPROB = (0.148) 
                                  CORRB COVB RSQUARE STB
                                ;/*CA Asthma Rate*/
    RUN;
ODS PDF CLOSE;

/* DISABLE SAS GRAPHICS */
ODS GRAPHICS OFF;

QUIT;

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

