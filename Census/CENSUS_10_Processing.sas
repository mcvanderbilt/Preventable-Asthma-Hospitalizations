%LET _CLIENTTASKLABEL='CENSUS_10_Processing';
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
**  Date Created    : 23 April 2019 10:51                                           **
**  Program Name    : CENSUS_10_Processing                                          **
**  Purpose         : Load and Analyze Census Data                                  **
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

* Pull Secure File Path from Text - Adapted from Hemedinger, 2016;
* Determine C:\ MyDocuments Path to Raw Data;
FILENAME scrPath "&localProjectPath.RawDataPath.txt";
DATA _NULL_;
    LENGTH text $265;
    RETAIN text '';
    INFILE scrPath FLOWOVER DLMSTR='//' END=last;
    INPUT;
    text = CATS(text,_INFILE_);
    IF last THEN CALL SYMPUT('rawpath',text);
RUN;
%LET localRawDataPath = %SYSFUNC(CAT(C:\Users\,%SYSFUNC(DEQUOTE(&_CLIENTUSERID)),%SYSFUNC(TRIM(%SYSFUNC(DEQUOTE(&rawpath)))) ));

/* MASTER LIBRARIES */
LIBNAME CENSUS "&localProjectPath.Census";
LIBNAME RCENSUS "&localRawDataPath.\Census_ACS5PUMS_CA";

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

/* APPLY CENSUS FORMATS */
OPTIONS fmtsearch=(CENSUS);

PROC FORMAT LIBRARY=CENSUS;

    VALUE fbnrysex       1    = 'Male'
                         2    = 'Female'
                        ;

    VALUE fcitizen       1    = 'US-Born Citizen'
                         2    = 'Naturalized Citizen'
                         3    = 'Non-Citizen'
                        ;

    VALUE frac1p         1    = 'White Alone'
                         2    = 'Black or African American Alone'
                         3    = 'American Indian Alone'
                         4    = 'Alaska Native Alone'
                         5    = 'American Indian and/or Alaska Native'
                         6    = 'Asian'
                         7    = 'Native Hawaiian and Other Pacific Islander ALone'
                         8    = 'Some Other Race ALone'
                         9    = 'Two or More Races'
                         ;

    VALUE frace         1    = 'Latino'
                        3    = 'American Indian / Alaska Native'
                        4    = 'Asian'
                        5    = 'African American'
                        6    = 'White'
                        9    = 'Multiracial / Other'
                        ;

    VALUE fpfpl         1    = '0-99% FPL'
                        5    = '100% FPL and Above'
                        ;

    VALUE fhicov        1    = 'With Health Insurance Coverage'
                        2    = 'No Health Insurance Coverage'
                        ;

    VALUE fCHISBool     -9    = 'Not Ascertained'
                        -8    = 'Dont Know'
                        -7    = 'Refused'
                        -2    = 'Proxy Skipped'
                        -1    = 'Inapplicable'
                         1    = 'Yes'
                         2    = 'No'
                        ;

    VALUE fHUPAC        .     = 'N/A'
                         1    = 'With Children Under 6 Years Only'
                         2    = 'With Children 6 to 17 Years Only'
                         3    = 'With Children Under 6 Years and 6 to 17 Years'
                         4    = 'No Children'
                        ;

    
    VALUE fchildhh       1    = 'Mixed Age HH'
                         2    = 'Adult Only HH'
                        ;

RUN;

/* VALIDATE RECODED DATASET CONTENTS */
ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS-RawCensus.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=RCENSUS.psam_p06 VARNUM;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC CONTENTS - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
    RUN;
ODS PDF CLOSE;

DATA CENSUS.ACS5;
    SET RCENSUS.psam_p06;

    *Identify Adult Domain;
    adult = 1;
    IF AGEP < 18 THEN adult = 2;
    LABEL  adult        = 'Adult';
    FORMAT adult        fCHISBool.;

    *Recode Sex and Label;
    IF INPUT(SEX, 8.) = 1 THEN srsex = 1;
    IF INPUT(SEX, 8.) = 2 THEN srsex = 2;
    LABEL  srsex        = 'Sex';
    FORMAT srsex        fbnrysex.;

    *Recode Citizenship;
    citizen2 = 3;
    IF CIT IN(1,2,3) THEN citizen2 = 1;
    IF CIT = 4       THEN citizen2 = 2;
    IF CIT = 5       THEN citizen2 = 3;
    LABEL  citizen2   = 'citizenship';
    FORMAT citizen2   fcitizen.;
    
    *Recode Race;
    race = 9;
    IF RAC1P = 1        THEN race = 6;
    IF RAC1P = 2        THEN race = 5;
    IF RAC1P IN(3,4,5)  THEN race = 3;
    IF RAC1P IN(6,7)    THEN race = 4;
    IF RAC1P IN(8,9)    THEN race = 9;
    IF HISP ^= '01'     THEN race = 1;
    LABEL  race         = 'race';
    FORMAT race         frace.;

    *Recode Income as Percent of FPL;
    pfpl = 5;
    IF POVPIP=. THEN pfpl = 1;
    IF POVPIP < 100 THEN pfpl = 1;
    IF POVPIP >= 100 THEN pfpl = 5;
    *IF INPUT(POVPIP, 8.) < 100 THEN pfpl = 1;
    *IF INPUT(POVPIP, 8.) >= 100 THEN pfpl = 5;
    LABEL  pfpl    = 'percentage of FPL';
    FORMAT pfpl    fpfpl.;

    *Recode Health Insurance;
    ins = 2;
    IF HICOV = 1 THEN ins = 1;
    IF HICOV = 2 THEN ins = 2;
    LABEL  ins      = 'Insured for Health Care';
    FORMAT ins      FCHISBool.;

    *Recode Missing Replicate Weights to -0-;
    ARRAY a_pwgtp[80] PWGTP1-PWGTP80;
    DO i = 1 to 80;
        IF a_pwgtp[i] = . THEN a_pwgtp[i] = 0;
        IF a_pwgtp[i] < 0 THEN a_pwgtp[i] = 0;
    END;

    *Recode New Vars to Character Fields;
    IF adult    = 1 THEN c_adult    = 'Adult';
    IF adult    = 2 THEN c_adult    = 'Child';
    IF srsex    = 1 THEN c_srsex    = 'Male  ';
    IF srsex    = 2 THEN c_srsex    = 'Female';
    IF citizen2 = 1 THEN c_citizen2 = 'US-Born Citizen    ';
    IF citizen2 = 2 THEN c_citizen2 = 'Naturalized Citizen';
    IF citizen2 = 3 THEN c_citizen2 = 'Non-Citizen        ';
    IF race     = 1 THEN c_race     = 'Latino                         ';
    IF race     = 3 THEN c_race     = 'American Indian / Alaska Native';
    IF race     = 4 THEN c_race     = 'Asian                          ';
    IF race     = 5 THEN c_race     = 'African American               ';
    IF race     = 6 THEN c_race     = 'White                          ';
    IF race     = 9 THEN c_race     = 'Multiracial / Other            ';
    IF pfpl     = 1 THEN c_pfpl     = '0-99% FPL         ';
    IF pfpl     = 5 THEN c_pfpl     = '100% FPL and Above';
    IF ins      = 1 THEN c_ins      = 'Covered by Health Insurance    ';
    IF ins      = 2 THEN c_ins      = 'Not Covered by Health Insurance';

    *Combine Variables into Single Field;
    modelvars = CAT(PUMA,
                    '|',
                    c_adult,
                    '|',
                    c_srsex,
                    '|',
                    c_citizen2,
                    '|',
                    c_race,
                    '|',
                    c_pfpl,
                    '|',
                    c_ins
                   );

RUN;

/* VALIDATE RECODED DATASET CONTENTS */
ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS-RecodedCensus.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CENSUS.ACS5 VARNUM;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC CONTENTS - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
    RUN;
ODS PDF CLOSE;

ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-FREQ.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
        PROC FREQ DATA=CENSUS.ACS5;
        TITLE1  "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2  "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3  "PROC FREQ - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        TABLES  SEX / PLOTS =  ALL;
        TABLES  CIT*citizen2 / PLOTS = ALL;
        TABLES  RAC1P*race / PLOTS = ALL;
        TABLES  HISP*race / PLOTS = ALL;
        TABLES  POVPIP*pfpl / PLOTS = ALL;
        TABLES  HICOV*ins / PLOTS = ALL;
RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-ModelVariables.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        *ODS GRAPHICS OFF;
        ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
    PROC SURVEYFREQ DATA=CENSUS.ACS5 VARMETHOD=BRR(FAY);
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC SURVEYFREQ - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        TABLES     adult
                   srsex
                   citizen2
                   race
                   pfpl
                   ins
                   / PLOTS=ALL;
        WEIGHT     PWGTP;
        REPWEIGHT  PWGTP1-PWGTP80;
    RUN;
    ODS GRAPHICS OFF;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        *ODS GRAPHICS OFF;
        *ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
    PROC SURVEYFREQ DATA=CENSUS.ACS5 VARMETHOD=BRR(FAY);
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC SURVEYFREQ - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
        TABLES     modelvars; 
        ODS OUTPUT OneWay=ResponseTable;
        WEIGHT     PWGTP;
        REPWEIGHT  PWGTP1-PWGTP80;
    RUN;
    ODS GRAPHICS OFF;
ODS PDF CLOSE;

/* CREATE PERMATABLE FOR WEIGHTED REPLICATES BY PUMA */
DATA CENSUS.Results;
    SET ResponseTable;

    *Split Modeled Variable;
    puma       = SCAN(modelvars, 1, '|');
    c_adult    = TRIM(SCAN(modelvars, 2, '|'));
    c_srsex    = TRIM(SCAN(modelvars, 3, '|'));
    c_citizen2 = TRIM(SCAN(modelvars, 4, '|'));
    c_race     = TRIM(SCAN(modelvars, 5, '|'));
    c_pfpl     = TRIM(SCAN(modelvars, 6, '|'));
    c_ins      = TRIM(SCAN(modelvars, 7, '|'));

    *Recode New Vars to Character Fields;
    IF c_adult    = 'Adult'                           THEN adult    = 1;
    IF c_adult    = 'Child'                           THEN adult    = 2;
    LABEL  adult  = 'Adult';
    FORMAT adult  fCHISBool.;

    IF c_srsex    = 'Male'                            THEN srsex    = 1;
    IF c_srsex    = 'Female'                          THEN srsex    = 2;
    LABEL  srsex  = 'Sex';
    FORMAT srsex  fbnrysex.;

    IF c_citizen2 = 'US-Born Citizen'                 THEN citizen2 = 1;
    IF c_citizen2 = 'Naturalized Citizen'             THEN citizen2 = 2;
    IF c_citizen2 = 'Non-Citizen'                     THEN citizen2 = 3;
    LABEL  citizen2 = 'citizenship';
    FORMAT citizen2 fcitizen.;

    IF c_race     = 'Latino'                          THEN race     = 1;
    IF c_race     = 'American Indian / Alaska Native' THEN race     = 3;
    IF c_race     = 'Asian'                           THEN race     = 4;
    IF c_race     = 'African American'                THEN race     = 5;
    IF c_race     = 'White'                           THEN race     = 6;
    IF c_race     = 'Multiracial / Other'             THEN race     = 9;
    LABEL  race   = 'race';
    FORMAT race   frace.;

    IF c_pfpl     = '0-99% FPL'                       THEN pfpl     = 1;
    IF c_pfpl     = '100% FPL and Above'              THEN pfpl     = 5;
    LABEL  pfpl   = 'percentage of FPL';
    FORMAT pfpl   fpfpl.;

    IF c_ins      = 'Covered by Health Insurance'     THEN ins      = 1;
    IF c_ins      = 'Not Covered by Health Insurance' THEN ins      = 2;
    LABEL  ins    = 'Insured for Health Care';
    FORMAT ins    FCHISBool.;

RUN;

/* REVIEW PUMA REPLICATE TABLE */
ODS PDF FILE="&localProjectPath.Census\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS-RawCensus.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=RCENSUS.psam_p06 VARNUM;
        TITLE1 "%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))";
        TITLE2 "%SYSFUNC(TRIM(&SYSDSN))";
        TITLE3 "PROC CONTENTS - %LEFT(%QSYSFUNC(DATE(), WORDDATE18.))";
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

