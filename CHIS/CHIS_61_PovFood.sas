%LET _CLIENTTASKLABEL='CHIS_61_PovFood';
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
**  Date Created    : 15 April 2019                                                 **
**  Program Name    : CHIS_61_PovFood                                               **
**  Purpose         : Analysis of Effects of Food Access on POVLL and RBMI          **
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
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-FPLtoFood-A.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Full Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      POVLL(REF='300% FPL and Above') /*POVERTY LEVEL*/
                   AC42_P(REF='Always')            /*HOW OFTEN FIND FRESH FRUIT*/
                   AC44(REF='Always')              /*FRUIT/VEG AFFORDABLE*/
                   ;
        MODEL POVLL = AC42_P
                      AC44
                      / LINK=GLOGIT;
    RUN;
ODS PDF CLOSE;

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-FPLtoFood-B.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Full Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      POVLL(REF='300% FPL and Above') /*POVERTY LEVEL*/
                   AC42_P(REF='Always')            /*HOW OFTEN FIND FRESH FRUIT*/
                   AC44(REF='Always')              /*FRUIT/VEG AFFORDABLE*/
                   ;
        MODEL POVLL = AC42_P*
                      AC44
                      / LINK=GLOGIT;
    RUN;
ODS PDF CLOSE;

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-BMItoFood-A.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Full Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      RBMI(REF='Normal 18.5-24.99')   /*BMI DESCRIPTIVE*/
                   AC42_P(REF='Always')            /*HOW OFTEN FIND FRESH FRUIT*/
                   AC44(REF='Always')              /*FRUIT/VEG AFFORDABLE*/
                   ;
        MODEL RBMI = AC42_P
                     AC44
                     / LINK=GLOGIT;
    RUN;
ODS PDF CLOSE;

/* PERFORM MULTINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-BMItoFood-B.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_FINAL - Full Association';
        WEIGHT     FNWGT0;
        REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
        CLASS      RBMI(REF='Normal 18.5-24.99')   /*BMI DESCRIPTIVE*/
                   AC42_P(REF='Always')            /*HOW OFTEN FIND FRESH FRUIT*/
                   AC44(REF='Always')              /*FRUIT/VEG AFFORDABLE*/
                   ;
        MODEL RBMI = AC42_P*
                     AC44
                     / LINK=GLOGIT;
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

