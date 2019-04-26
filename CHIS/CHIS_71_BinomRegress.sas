
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
**  Date Created    : 23 April 2019                                                 **
**  Program Name    : CHIS_71_BinomRegressionB                                      **
**  Purpose         : Performs Binomial Regression Model B                          **
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

/* ENABLE SAS GRAPHICS */
ODS GRAPHICS ON;

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* DEFINE FORMATS FOR NEWLY RECODED VARIABLES */
PROC FORMAT LIBRARY=CHIS;
    VALUE frace         1    = 'Latino'
                        3    = 'American Indian / Alaska Native'
                        5    = 'African American'
                        9    = 'Multiracial / Other'
                        10    = 'White / African American / Asian'
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
    
RUN;

/* CREATE BINOMIAL ANALYSIS DATASET WITH RECODED VARIABLES */
DATA CHIS.CHIS_DATA_BINOMIAL;
    SET CHIS.CHIS_DATA_FINAL (WHERE=(asthmastatus IN(1,3)));

    * Collapse Race/Ethnicity Categories;
    race = RACEDF_P1;
    IF RACEDF_P1 IN(2,8) THEN race = 9;     *Collapse Other with Multiracial;
    IF RACEDF_P1 IN(4,5,6) THEN race = 10;  *Collapse Asian with White*;
    LABEL    race    = 'race';
    FORMAT    race    frace.;

    * Collapse Family Type to Children-in-Household;
    IF famtype IN(1,3) THEN childhh = 2;
    IF famtype IN(2,4) THEN childhh = 1;
    LABEL    childhh    = 'Child Household';
    FORMAT    childhh    fchildhh.;

    * Invert Asthma Status to Boolean Non-Asthmatic;
    nonasthmatic = 1;
    IF asthmastatus = 1 THEN nonasthmatic = 2;
    LABEL    nonasthmatic = 'Non-Asthmatic';
    FORMAT    nonasthmatic fnonasthmatic.;

    * Collapse Tri-Category Age to Dichotomous;
    lateradult = 2;
    IF agegroup = 3 THEN lateradult = 1;
    LABEL    lateradult    = 'Later Adult';
    FORMAT    lateradult    flateradult.;

    * Collapse Underweight/Normal to Single Category;
    rcbmi = RBMI;
    IF RBMI IN(1,2) THEN rcbmi = 0;
    LABEL    rcbmi    = 'descriptive BMI';
    FORMAT    rcbmi    frcbmi.;

    * Collapse FPL to Under vs At Least;
    pfpl = POVLL;
    IF POVLL IN(2,3,4) THEN pfpl = 5;
    LABEL    pfpl    = 'percentage of FPL';
    FORMAT    pfpl    fpfpl.;

RUN;

/* VALIDATE RECODED DATASET CONTENTS */
PROC CONTENTS DATA=CHIS.CHIS_DATA_INTRM VARNUM;
    TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_INTRM';
RUN;

/* TEST MODEL VARIABLES FOR MULTICOLLINEARITY */
PROC REG DATA=CHIS.CHIS_DATA_BINOMIAL ;
    TITLE 'PROC REG - CHIS.CHIS_DATA_BINOMIAL - Model B Multicollinearity Test';
    MODEL    nonasthmatic = SRSEX
                            lateradult
                            CITIZEN2
                            race
                            childhh
                            rcbmi
                            DSTRS12
                            pfpl
                            INS
                            / TOL VIF COLLIN;
                            ;
RUN;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_BINOMIAL VARMETHOD=JACKKNIFE;
    TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL - Univarites for Model B';
    WEIGHT    FNWGT0;
    REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
    TABLES    (SRSEX
               lateradult
               CITIZEN2
               race
               childhh
               rcbmi
               DSTRS12
               pfpl
               INS
              )*nonasthmatic 
              / CHISQ PLOTS=ALL;
RUN;

/* PERFORM BINOMIAL LOGISTIC REGRESSION */
PROC SURVEYLOGISTIC DATA=CHIS.CHIS_DATA_BINOMIAL VARMETHOD=JACKKNIFE;
    TITLE 'PROC SURVEYLOGISTIC - CHIS.CHIS_DATA_BINOMIAL - Model B';
    WEIGHT     FNWGT0;
    REPWEIGHTS FNWGT1-FNWGT160 / jkcoefs = 1;
    CLASS      nonasthmatic(REF='1 Non-Asthmatic')          /*Dichotomous Non-Asthmatic*/
               SRSEX(REF='Male')                            /*Dichotomous Sex*/
               lateradult(REF='Later Adult')                /*Dichotomous Later Adult*/
               CITIZEN2(REF='Naturalized Citizen')          /*Nominal Citizenship Status*/
               race(REF='White / African American / Asian') /*Nominal Race / Ethnicity*/
               childhh(REF='No Children in HH')             /*Dichotomous Children in Household*/
               rcbmi(REF='Not Overweight 0-24.99')          /*Ordinal Descriptive BMI*/
               DSTRS12(REF='No')                            /*Dichotomous Psychological Distress Likelihood*/
               pfpl(REF='100% FPL and Above')               /*Dichotomous Poverty Level*/
               INS(REF='Yes')                               /*Dichotomous Insured for Health Care*/
               ;
    MODEL    nonasthmatic = SRSEX
                            lateradult
                            CITIZEN2
                            race
                            childhh
                            rcbmi
                            DSTRS12
                            pfpl
                            INS
                            / LINK=GLOGIT CTABLE PPROB = (1-0.148) /*California Population is 14.8% Asthmatic*/
                              CORRB COVB RSQUARE STB
                            ;
RUN;

/* DISABLE SAS GRAPHICS */
ODS GRAPHICS OFF;

QUIT;

/* REFERENCES 
Hemedinger, C. (2016). "How to read the contents of a file into a SAS macro 
    variable." The SAS Dummy https://blogs.sas.com/content/sasdummy/2016/07/12/how-to
    -read-the-contents-of-a-file-into-a-sas-macro-variable/ 2019.
*/

GOPTIONS NOACCESSIBLE;
%LET _CLIENTTASKLABEL=;
%LET _CLIENTPROCESSFLOWNAME=;
%LET _CLIENTPROJECTPATH=;
%LET _CLIENTPROJECTPATHHOST=;
%LET _CLIENTPROJECTNAME=;
%LET _SASPROGRAMFILE=;
%LET _SASPROGRAMFILEHOST=;

