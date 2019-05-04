%LET _CLIENTTASKLABEL='CHIS_51_EDA_Severity';
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
**  Date Created    : 3 May 2019 07:50                                              **
**  Program Name    : CHIS_51_EDA_Severity                                          **
**  Purpose         : CHIS Respondent Characteristics by Severe Asthma              **
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

/* DEFINE FORMATS FOR NEWLY RECODED VARIABLES */
PROC FORMAT LIBRARY=CHIS;
    VALUE fasthmaesc3c  1    = '1 Severe Asthmatic'
                        2    = '2 Standard Asthmatic'
                        3    = '3 Non-Asthmatic'
                        ;
    
RUN;

/* CREATE DATASET FOR REVIEW */
DATA WORK.CHISSEVERITY;
    SET CHIS.CHIS_DATA_FINAL;

    * Recode ED/Urgent Care Asthmatic Variable;
    asthmaesc3 = 3; *3 = Non-Asthmatic;
    IF asthmastatus = 1 THEN 
        DO;
            IF AH13A = 1 THEN asthmaesc3 = 1; *1 = ED/UC;
            IF AH13A = 2 THEN asthmaesc3 = 2; *2 = No ED/UC;
        END;
    LABEL     asthmaesc3 = 'ED/UC Asthma Visit';
    FORMAT    asthmaesc3 fasthmaesc3c.;

RUN;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Demographics.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYFREQ DATA=WORK.CHISSEVERITY VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - WORK.CHISSEVERITY - Demographic Information';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (SRSEX
                   agegroup
                   RACEDF_P1
                   AH33NEW
                   AH34NEW
                   AH35NEW
                   CITIZEN2
                   YRUS_P1
                   PCTLF_P
                   prilanguage
                   AH37
                   maritstat
                   famtype
                   SRTENR
                   AHEDC_P1
                   AG22
                   SERVED
                   AG10
                   WRKST_P1
                   AM34
                   UR_CLRT
                  )*asthmaesc3 
                  / CHISQ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Health.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYFREQ DATA=WORK.CHISSEVERITY VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - WORK.CHISSEVERITY - Health';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (AB1
                   RBMI        /*BMI DESCRIPTIVE*/
                   AB17
                   AB43
                   AB98
                   AB108_P1
                   AB40
                   AB41
                   ASTCUR
                   ASTS
                   ASTYR
                   AB18
                   AB19
                   AH13A
                   AB22
                   AB24
                   AB25
                   AB34
                   AB52
                   AB30
                   AB117
                   DSTRS12
                   DSTRS30
                   AF65
                   AF63
                   AD50
                   AE15
                   AE15A
                   SMKCUR
                   SMOKING
                   NUMCIG
                   AD37W
                   AD40W
                   AESODA_P1
                   AC42_P
                   AC44
                  )*asthmaesc3
                  / CHISQ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-HealthInsurance.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYFREQ DATA=WORK.CHISSEVERITY VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - WORK.CHISSEVERITY - Health Care Access & Insurance';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (INS
                   healthplan
                   HMO
                   AH71_P1
                   AH72_P1
                   AI25
                   AH1
                   USUAL5TP
                   AH16
                   AJ19
                   AH22
                   AJ20
                   AJ102
                   AJ112
                   AJ113
                   AJ105
                   AJ9
                   AH14
                   AH12
                   ER
                   AJ108
                  )*asthmaesc3
                  / CHISQ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Socioeconomics.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYFREQ DATA=WORK.CHISSEVERITY VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - WORK.CHISSEVERITY - Socioeconomic Status';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (POVLL
                   FSLEV
                   AL6
                   AL22
                   AL18A
                   AK4
                   AM36
                   AK23
                   AK25
                   AM19
                   AM21
                   AK28
                  )*asthmaesc3
                  / CHISQ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Asthma.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC SURVEYFREQ DATA=WORK.CHISSEVERITY VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - WORK.CHISSEVERITY -  Asthma Variables';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (AB17
                   AB43
                   AB98
                   AB108_P1
                   AB40
                   AB41
                   ASTCUR
                   ASTS
                   ASTYR
                   AB18
                   AB19
                   AH13A
                  )*asthmaesc3
                  / CHISQ;
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

