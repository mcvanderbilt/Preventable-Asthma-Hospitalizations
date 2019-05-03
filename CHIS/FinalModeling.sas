
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
**  Date Created    : 2 May 2019 16:12                                              **
**  Program Name    : FinalModeling                                                 **
**  Purpose         : Performs Final Logistic Modeling for Input to Tableau         **
**  Note            : Capitalized values represent SAS commands and unadjusted      **
**                    variables; lower-case variables represent study-created       **
**                    variables.                                                    **
**                                                                                  **
*************************************************************************************/

/* GLOBAL VARIABLES */
* Determine File Path for SAS EGP;
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));

/* MASTER LIBRARY */
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

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* PERFORM BINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-Asthma.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_BINOMIAL_C VARMETHOD=JACKKNIFE;
            TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
            TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
            TITLE3 "PROC SURVEYLOGISTIC - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
            WEIGHT     FNWGT0;
            DOMAIN     analyzeData;
            REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
            CLASS      nonasthmatic(REF='1 Non-Asthmatic')
                       ;
            MODEL    nonasthmatic = SRSEX
                                    CITIZEN2
                                    race
                                    pfpl
                                    INS
                                    / LINK=GLOGIT CTABLE PPROB = (0.852) 
                                      CORRB COVB RSQUARE STB
                                    ;/*1 - CA Asthma Rate*/
            ODS OUTPUT ParameterEstimates=CHIS.MLE_CurrentAsthma;
        RUN;
ODS PDF CLOSE;

PROC TRANSPOSE DATA=CHIS.MLE_CURRENTASTHMA (WHERE=(analyzeData=1)) OUT=CHIS.MLE_CURRENTASTHMA_FLAT NAME=MLEValue;
RUN;

DATA CHIS.MLE_CURRENTASTHMA_FLAT (WHERE=(MLEVALUE='Estimate'));
    SET CHIS.MLE_CURRENTASTHMA_FLAT;

    RENAME col1 = intercept;
    RENAME col2 = SRSEX;
    RENAME col3 = CITIZEN2;
    RENAME col4 = race;
    RENAME col5 = pfpl;
    RENAME col6  = ins;

RUN;

PROC PRINT DATA=CHIS.MLE_CURRENTASTHMA;
RUN;

PROC PRINT DATA=CHIS.MLE_CURRENTASTHMA_FLAT;
RUN;

/* PERFORM BINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC-AsthmaEsc.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_BINOMIAL_ED2 VARMETHOD=JACKKNIFE;
            TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
            TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
            TITLE3 "PROC SURVEYLOGISTIC - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
            WEIGHT     FNWGT0;
            DOMAIN     analyzeData;
            REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
            CLASS      asthmaesc(REF='2 No Asthma Escalation')
                       ;
            MODEL    asthmaesc = SRSEX
                                 CITIZEN2
                                 race
                                 pfpl
                                 INS
                                 / LINK=GLOGIT CTABLE 
                                   CORRB COVB RSQUARE STB;
            ODS OUTPUT ParameterEstimates=CHIS.MLE_ASTHMAESCALATION;
        RUN;
ODS PDF CLOSE;

PROC TRANSPOSE DATA=CHIS.MLE_ASTHMAESCALATION (WHERE=(analyzeData=1)) OUT=CHIS.MLE_ASTHMAESCALATION_FLAT NAME=MLEValue;
RUN;

DATA CHIS.MLE_ASTHMAESCALATION_FLAT (WHERE=(MLEValue='Estimate'));
    SET CHIS.MLE_ASTHMAESCALATION_FLAT;

    RENAME col1 = intercept;
    RENAME col2 = SRSEX;
    RENAME col3 = CITIZEN2;
    RENAME col4 = race;
    RENAME col5 = pfpl;
    RENAME col6  = ins;

RUN;

PROC PRINT DATA=CHIS.MLE_AsthmaEscalation;
RUN;

PROC PRINT DATA=CHIS.MLE_ASTHMAESCALATION_FLAT;
RUN;

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

