%LET _CLIENTTASKLABEL='CHIS_15_Recoding';
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
**  Date Created    : 14 April 2019 08:22                                           **
**  Program Name    : CHIS_10_LoadData                                              **
**  Purpose         : Recodes variables identified with inconsistencies or too many **
**                    categories acros survey years                                 **
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

* Pull Secure File Path from Text
* Determine C:\MyDocuments Path to Raw Data;
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

/* CREATE CUSTOM FORMATS */
OPTIONS fmtsearch=(CHIS);

PROC FORMAT LIBRARY=CHIS;
    VALUE fhealthplan   -1    = 'Inapplicable'
                         1    = 'Kaiser'
                         2    = 'Blue Cross'
                         3    = 'United Healthcare'
                         4    = 'Blue Shield'
                         5    = 'Health Net'
                         6    = 'Aetna'
                         7    = 'Cigna Health Care'
                         8    = 'Other'
                         9    = 'Medicare/Medi-Cal'
                        ;

    VALUE fprilanguage   1    = 'English (Includes English & Other)'
                         2    = 'Spanish'
                         3    = 'Chinese'
                         4    = 'Vietnamese'
                         5    = 'Korean'
                         6    = 'Other'
                        ;

    VALUE fasthmastatus  1    = '1 Current Asthmatic'
                         2    = '2 Lifetime Asthmatic'
                         3    = '3 Non-Asthmatic'
                        ;

    VALUE ffamtype       1    = 'Single w/o Children'
                         2    = 'Single w/ Children'
                         3    = 'Married w/o Children'
                         4    = 'Married w/ Children'
                        ;

    VALUE fBoolean      -1    = 'NA'
                         0    = 'False'
                         1    = 'True'
                        ;

    VALUE fagegroup     -1    = 'NA'
                         1    = 'Young Adult (18-39)'
                         2    = 'Middle Aged (40-64)'
                         3    = 'Later Adult (65+)'
                        ;

    VALUE flanguage     -1    = 'NA'
                         1    = 'English'
                         2    = 'Spanish'
                         3    = 'Other'
                        ;

    VALUE fmaritstat    -1    = 'NA'
                         1    = 'Married/Partnered'
                         2    = 'Widowed/Separated'
                         3    = 'Never Married'
                        ;
RUN;

/* APPLY RECODING & CUSTOM FORMATS */
DATA CHIS.CHIS_DATA_INTRM;
    SET CHIS.CHIS_DATA_RAW;

    *Combined Married / Partnered Categories;
    maritstat    = -1;
    IF marit2    IN(1,2)    THEN maritstat = 1;
    IF marit2    = 3        THEN maritstat = 2;
    IF marit2    = 4        THEN maritstat = 3;
    LABEL        maritstat  = 'marital status';
    FORMAT       maritstat  fmaritstat.;

    *Categorize Age to Three-Level Group;
    agegroup    = -1;
    IF srage_p1 >= 18 AND srage_p1 < 40    THEN agegroup = 1;
    IF srage_p1 >= 40 AND srage_p1 < 65    THEN agegroup = 2;
    IF srage_p1 >= 65                    THEN agegroup = 3;
    LABEL       agegroup    = 'age group';
    FORMAT      agegroup    fagegroup.;
    
    *Secondary English Proficiency;
    *Recode all N/A responses to Inapplicable;
    AH37 = AH37;
    IF AH37 < -1 THEN AH37 = -1;
    IF AH37 =  . THEN AH37 = -1;

    *Years of Armed Forces Service;
    *Recode all N/A responses to Inapplicable;
    SERVED = SERVED;
    IF SERVED < -1 THEN SERVED = -1;
    IF SERVED =  . THEN SERVED = -1;

    *Educational Atttainment;
    *Normalize MA/MS/PhD from differently-coded 2013 survey;
    AHEDC_P1 = AHEDC_P1;
    IF YEAR = 2013 AND AHEDC_P1 > 8 THEN AHEDC_P1 = AHEDC_P1-1;

    *Telephone Calls Received;
    *Recode all N/A responses to Inapplicable;
    AM34 = AM34;
    IF AM34 < -1 THEN AM34 = -1;
    IF AM34 = . THEN AM34 = -1;

    *Family Type;
    *Collapse Three-Leavel Single Categories to One;
    famtype = FAMTYP_P;
    IF FAMTYP_P IN(1,2,6)   THEN famtype = 1;
    IF FAMTYP_P = 5         THEN famtype = 2;
    LABEL       famtype     = 'family type';
    FORMAT      famtype     ffamtype.;

    *Primary Language Spoken at Home;
    *Collapse all English & English + Other to Single Category;
    prilanguage = LNGHM_P1;
    IF LNGHM_P1 < -1                THEN prilanguage = -1;
    IF LNGHM_P1 IN(1,8,9,10,11,12) THEN prilanguage = 1;
    IF LNGHM_P1 IN(6,13)            THEN prilanguage = 6;
    LABEL       prilanguage         = 'primary spoken language';
    FORMAT      prilanguage         fprilanguage.;

    *Name of Health Plan;
    *Recode all N/A responses to Inapplicable;
    *Use INSMC to Add Medicare/Medi-Cal Category as 9;
    healthplan = AI22A_P;
    IF AI22A_P < -1             THEN    healthplan = -1;
    IF INSMC   = 1 OR INSMD = 1 THEN healthplan = 9;
    LABEL      healthplan       = 'name of health plan';
    FORMAT     healthplan       fhealthplan.;

    *Asthma Status;
    *Current Asthmatics = Identify or Rx/Symptoms Last 12 Months;
    *Previous Asthmatics = Diagnosed / No Current Issues;
    *AB108_P1 (Mgt Confidence) Excluded due to Unclear Responses;
    asthmastatus = 3;
    IF       AB17         = 1  /*Diagnosed*/
        OR   AB43         = 1  /*Given Mgt Plan*/
        OR   AB98         = 1  /*Have Mgt Plan*/
        THEN asthmastatus = 2; /*Previous Asthmatic*/
    IF       AB40         = 1  /*Still Has Ashtma*/
        OR   AB41         = 1  /*Episode w/in 12mos*/
        OR   ASTCUR       = 1  /*Current Asthma Status*/
        OR   ASTS         = 1  /*Symptoms w/in 12mos*/
        OR   ASTYR        = 1  /*Symptoms w/in 12mos*/
        OR   AB18         = 1  /*Daily Asthma Rx*/
        OR   AB19         = 1  /*Symptoms w/in 12mos = YES*/
        OR   AH13A        = 1  /*Asthma ED Visit w/in 12mos*/
        THEN asthmastatus = 1; /*Current Asthmat*/
    LABEL    asthmastatus = 'asthmatic status';
    FORMAT   asthmastatus fasthmastatus.;
RUN;

/* VIEW TABLE CONTENTS & STRUCTURE */
LIBNAME CHIS2015 "&localRawDataPath.\CHIS\CHIS15_adult_sas\Data\";
%INCLUDE "&localRawDataPath.\CHIS\CHIS15_adult_sas\Data\ADULT_PROC_FORMAT.SAS";
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_INTRM VARNUM;
        TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_INTRM';
    RUN;
ODS PDF CLOSE;

/* EVALUATE & CONFIRM RECODED VARIABLE RESULTS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-FREQ.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON / WIDTH=1280px HEIGHT=960;
PROC FREQ DATA=CHIS.CHIS_DATA_INTRM;
    TITLE 'PROC FREQ - CHIS.CHIS_DATA_INTRM - RECODING VALIDATION';
    TABLES  MARIT2*maritstat
            SRAGE_P1*agegroup
            AH37
            SERVED
            AHEDC_P1
            AM34
            FAMTYP_P*famtype
            LNGHM_P1*prilanguage
            (INSMC
             INSMD
             AI22A_P
            )*healthplan
            (AB17
             AB18
             AB19
             AB40
             AB41
             AB43
             AB98
             AB108_P1
             AH13A
             ASTCUR
             ASTS
             ASTYR
            )*asthmastatus
            / PLOTS=ALL;
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

