%LET _CLIENTTASKLABEL='CHIS_81_Exacerbations';
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
**  Date Created    : 28 April 2019 21:45                                           **
**  Program Name    : CHIS_81_Exacerbations                                         **
**  Purpose         : Performs Binomial Regression Model - ED/UC for Asthma #2      **
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
OPTIONS PDFSECURITY=HIGH;
OPTIONS PDFPASSWORD=(owner="&pdfPassword");

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* DEFINE FORMATS FOR NEWLY RECODED VARIABLES */
PROC FORMAT LIBRARY=CHIS;
    VALUE frace         1    = 'Latino'
                        3    = 'American Indian / Alaska Native'
                        4    = 'Asian'
                        5    = 'African American'
                        6    = 'White'
                        9    = 'Multiracial / Other'
                        ;

    VALUE fchildhh      1    = 'Children in HH'
                        2    = 'No Children in HH'
                        ;

    VALUE fnonasthmatic 1    = '1 Non-Asthmatic'
                        2    = '2 Current Asthmatic'
                        ;

    VALUE flateradult   1    = 'Later Adult'
                        2    = 'Young / Middle Aged'
                        ;

    VALUE frcbmi        0    = 'Not Overweight 0-24.99'
                        3    = 'Overweight 25.0-29.99'
                        4    = 'Obese 30.0+'
                        ;

    VALUE fpfpl         1    = '0-99% FPL'
                        5    = '100% FPL and Above'
                        ;

    VALUE fasthmaesc    1    = '1 Asthmatic Escalation'
                        2    = '2 No Asthma Escalation'
                        ;
    
RUN;

/* CREATE BINOMIAL ANALYSIS DATASET WITH RECODED VARIABLES */
DATA CHIS.CHIS_DATA_BINOMIAL_ED2;
    SET CHIS.CHIS_DATA_FINAL;

    analyzeData = 0;
    IF asthmastatus = 1 THEN analyzeData = 1;

    * Recode ED/Urgent Care Asthmatic Variable;
    asthmaesc = 2;
    IF asthmastatus = 1 THEN 
        DO;
            IF AH13A = 1 THEN asthmaesc = 1; *1 = ED/UC;
            IF AH13A = 2 THEN asthmaesc = 2; *2 = No ED/UC;
        END;
    LABEL     asthmaesc = 'ED/UC Asthma Visit';
    FORMAT    asthmaesc fasthmaesc.;

    * Collapse Race/Ethnicity Categories;
    race = RACEDF_P1;
    IF RACEDF_P1 IN(2,8) THEN race = 9;     *Collapse Other with Multiracial;
    LABEL     race    = 'race';
    FORMAT    race    frace.;

    * Collapse Family Type to Children-in-Household;
    IF famtype IN(1,3) THEN childhh = 2;
    IF famtype IN(2,4) THEN childhh = 1;
    LABEL     childhh    = 'Child Household';
    FORMAT    childhh    fchildhh.;

    * Invert Asthma Status to Boolean Non-Asthmatic;
    nonasthmatic = 1;
    IF asthmastatus = 1 THEN nonasthmatic = 2;
    LABEL     nonasthmatic = 'Non-Asthmatic';
    FORMAT    nonasthmatic fnonasthmatic.;

    * Collapse Tri-Category Age to Dichotomous;
    lateradult = 2;
    IF agegroup = 3 THEN lateradult = 1;
    LABEL     lateradult    = 'Later Adult';
    FORMAT    lateradult    flateradult.;

    * Collapse Underweight/Normal to Single Category;
    rcbmi = RBMI;
    IF RBMI IN(1,2) THEN rcbmi = 0;
    LABEL     rcbmi    = 'descriptive BMI';
    FORMAT    rcbmi    frcbmi.;

    * Collapse FPL to Under vs At Least;
    pfpl = POVLL;
    IF POVLL IN(2,3,4) THEN pfpl = 5;
    LABEL     pfpl    = 'percentage of FPL';
    FORMAT    pfpl    fpfpl.;

RUN;

/* VALIDATE RECODED DATASET CONTENTS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_BINOMIAL_ED2 (WHERE=(analyzeData=1)) VARNUM;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC CONTENTS - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
    RUN;
ODS PDF CLOSE;

/* TEST MODEL VARIABLES FOR MULTICOLLINEARITY */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-REG.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC REG DATA=CHIS.CHIS_DATA_BINOMIAL_ED2 (WHERE=(analyzeData=1));
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC REG - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        MODEL    asthmaesc = SRSEX
                             CITIZEN2
                             race
                             pfpl
                             INS
                             / TOL VIF COLLIN;
                             ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_BINOMIAL_ED2 VARMETHOD=JACKKNIFE;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC SURVEYFREQ - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        WEIGHT    FNWGT0;
        CLUSTER   analyzeData;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (SRSEX
                   CITIZEN2
                   race
                   pfpl
                   INS
                  )*asthmaesc 
                  / CHISQ PLOTS=ALL;
    RUN;
    ODS GRAPHICS OFF;
ODS PDF CLOSE;

/* PERFORM BINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYLOGISTIC.pdf"
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
                   SRSEX(REF='Male')
                   CITIZEN2(REF='Naturalized Citizen')
                   race(REF='White')
                   pfpl(REF='100% FPL and Above')
                   INS(REF='No')
                   ;
        MODEL    asthmaesc = SRSEX
                             CITIZEN2
                             race
                             pfpl
                             INS
                             / LINK=GLOGIT CTABLE PPROB = (0.852) 
                               CORRB COVB RSQUARE STB
                             ;/*1 - CA Asthma Rate*/
    RUN;
ODS PDF CLOSE;

/* PERFORM UNWEIGHTED BINOMIAL LOGISTIC REGRESSION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-LOGISTIC.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
    PROC LOGISTIC DATA=CHIS.CHIS_DATA_BINOMIAL_ED2 (WHERE=(analyzeData=1)) PLOTS=ALL;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC SURVEYLOGISTIC - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        WEIGHT     FNWGT0;
        CLASS      asthmaesc(REF='2 No Asthma Escalation')
                   SRSEX(REF='Male')
                   CITIZEN2(REF='Naturalized Citizen')
                   race(REF='White')
                   pfpl(REF='100% FPL and Above')
                   INS(REF='No')
                   ;
        MODEL    asthmaesc = SRSEX
                             CITIZEN2
                             race
                             pfpl
                             INS
                             / LINK=GLOGIT CTABLE PPROB = (0.852) 
                               CORRB COVB RSQUARE STB
                             ;/*1 - CA Asthma Rate*/
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

