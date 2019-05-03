%LET _CLIENTTASKLABEL='CHIS_70_BinomRegress';
%LET _CLIENTPROCESSFLOWNAME='CHIS_Execution';
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
**  Date Created    : 22 April 2019                                                 **
**  Program Name    : CHIS_70_BinomRegress                                          **
**  Purpose         : Performs Binomial Regression Model A                          **
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

/* CREATE BINOMIAL ANALYSIS DATASET */
DATA CHIS.CHIS_DATA_BINOMIAL_A;
    SET CHIS.CHIS_DATA_FINAL (WHERE=(asthmastatus IN(1,3)));

RUN;

/* PERFORM BINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_BINOMIAL_A VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_BINOMIAL_A';
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
        MODEL    asthmastatus = SRSEX
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
                                / LINK=GLOGIT CTABLE PPROB = (.148) /*1 - CA Asthma Rate*/
                                  CORRB COVB RSQUARE STB
                                ;
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

