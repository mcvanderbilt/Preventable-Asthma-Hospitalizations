%LET _CLIENTTASKLABEL='CHIS_55_Corr';
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
**  Program Name    : CHIS_55_Corr                                                  **
**  Purpose         : Correlation Exploratory Data Analysis                         **
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

/* PERFORM DATA CORRELATION */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CORR.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC CORR DATA=CHIS.CHIS_DATA_FINAL PLOTS=SCATTER;
        VAR SRSEX            /*SELF-REPORTED GENDER*/
            RACEDF_P1     /*RACE - FORMER DOF RACE-ETHNICITY*/
            AB22          /*DOCTOR EVER TOLD HAVE DIABETES*/
            AB24          /*CURRENTLY TAKING INSULIN*/
            AB25          /*CURRENTLY TAKING DIABETIC PILLS TO LOWER BLOOD SUGAR*/
            AB30          /*CURRENTLY TAKING RX TO CONTROL HIGH BLOOD PRESSURE*/
            AB34          /*DOCTOR EVER TOLD HAVE ANY KIND OF HEART DISEASE*/
            AB52          /*EVER TOLD HAVE HEART FAILURE/CONGESTIVE*/
            AD37W         /*WALKED AT LEAST 10 MIN FOR TRANSPORT PAST 7 DAYS*/
            AD40W         /*WALKED AT LEAST 10 MIN FOR LEISURE PAST 7 DAYS*/
            AESODA_P1     /*# OF TIMES DRINKING SODA PER WEEK (PUF 1 YR RECODE)*/
            AE15          /*SMOKED 100 OR MORE CIGARETTES IN ENTIRE LIFETIME*/
            AE15A         /*SMOKES CIGARETTES EVERYDAY, SOME DAYS OR NOT AT ALL*/
            SMKCUR        /*CURRENT SMOKER*/
            SMOKING       /*CURRENT SMOKING HABITS*/
            NUMCIG        /*# OF CIGARETTES PER DAY*/
            AC42_P        /*HOW OFTEN FIND FRESH FRUIT/VEG IN NEIGHB */
            AC44          /*NEIGHBORHOOD FRUIT/VEG AFFORDABLE*/
            AD50          /*BLIND/DEAF OR HAS SEVERE VISION/HEARING PROBLEM*/
            RBMI          /*BMI DESCRIPTIVE*/
            AF65          /*FEEL RESTLESS WORST MONTH*/
            AF63          /*FEEL NERVOUS WORST MONTH*/
            DSTRS12       /*LIKELY HAS HAD PSYCHOLOGICAL DISTRESS IN THE LAST YEAR*/
            AH33NEW       /*BORN IN U.S.*/
            AH34NEW       /*MOTHER BORN IN U.S.*/
            AH35NEW       /*FATHER BORN IN U.S.*/
            AH37          /*LEVEL OF ENGLISH PROFICIENCY: GENERAL*/
            CITIZEN2      /*CITIZENSHIP STATUS (3 LVLS)*/
            YRUS_P1       /*YEARS LIVED IN THE U.S.(PUF 1 YR RECODE)*/
            PCTLF_P       /*PERCENT LIFE IN US (PUF RECODE)*/
            AG22          /*EVER SERVE IN U.S. ARMED FORCES*/
            WRKST_P1      /*WORK STATUS(PUF 1 YR RECODE)*/
            AHEDC_P1      /*ADULT EDUCATIONAL ATTAINMENT(PUF 1 YR RECODE)*/
            AK4           /*TYPE OF EMPLOYER AT MAIN JOB*/
            FSLEV         /*FOOD SECURITY STATUS LEVEL*/
            POVLL         /*POVERTY LEVEL*/
            AL6           /*RECEIVING SSI (SUPPLEMENTAL SECURITY INCOME)*/
            AL22          /*RECEIVING SOCIAL SECURITY DISABILITY INS*/
            AL18A         /*RECVD SOCIAL SECURITY OR PENSION LAST MONTH*/
            AM19          /*PEOPLE IN NEIGHBORHOOD WILLING TO HELP EACH OTHER*/
            AM21          /*PEOPLE IN NEIGHBORHOOD CAN BE TRUSTED*/
            AK28          /*HOW OFTEN FEEL SAFE IN NEIGHBORHOOD*/
            AM36          /*DID VOLUNTEER WORK OR COMMUNITY SERVICES PAST YR*/
            AM34          /*TELEPHONE CALLS RECEIVED*/
            UR_CLRT       /*RURAL AND URBAN - CLARITAS (BY ZIPCODE) (4 LVLS)*/
            maritstat     /*marital status*/
            agegroup      /*age group*/
            asthmastatus  /*asthmatic status*/
            prilanguage   /*primary spoken language*/
            famtype       /*family type*/
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

