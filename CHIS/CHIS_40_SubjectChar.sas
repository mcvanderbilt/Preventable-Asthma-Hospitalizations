%LET _CLIENTTASKLABEL='CHIS_40_SubjectChar';
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
**  Date Created    : 23 March 2019 22:31                                           **
**  Program Name    : CHIS_40_SubjectChar                                           **
**  Purpose         : Investigates Characteristics of Sample                        **
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

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Demographics.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Demographic Information';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    SRSEX       /*SELF-REPORTED GENDER*/
                  agegroup    /*age group*/
                  RACEDF_P1   /*RACE - FORMER DOF RACE-ETHNICITY(PUF 1 YR RECODE)*/
                  AH33NEW     /*BORN IN U.S.*/
                  AH34NEW     /*MOTHER BORN IN U.S.*/
                  AH35NEW     /*FATHER BORN IN U.S.*/
                  CITIZEN2    /*CITIZENSHIP STATUS (3 LVLS)*/
                  YRUS_P1     /*YEARS LIVED IN THE U.S.(PUF 1 YR RECODE)*/
                  PCTLF_P     /*PERCENT LIFE IN US (PUF RECODE)*/
                  prilanguage /*primary spoken language*/
                  AH37        /*LEVEL OF ENGLISH PROFICIENCY: GENERAL*/
                  maritstat   /*marital status*/
                  famtype     /*family type*/
                  SRTENR      /*SELF-REPORTED HOUSEHOLD TENURE (HH)*/
                  AHEDC_P1    /*ADULT EDUCATIONAL ATTAINMENT(PUF 1 YR RECODE)*/
                  AG22        /*EVER SERVE IN U.S. ARMED FORCES*/
                  SERVED      /*LENGTH OF TIME SERVED IN ACTIVE DUTY*/
                  AG10        /*RESPONDENT USUALLY WORKS*/
                  WRKST_P1    /*WORK STATUS(PUF 1 YR RECODE)*/
                  AM34        /*TELEPHONE CALLS RECEIVED*/
                  UR_CLRT     /*RURAL AND URBAN - CLARITAS (BY ZIPCODE) (4 LVLS)*/
                  / PLOTS=ALL;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Health.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Health';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    AB1         /*GENERAL HEALTH CONDITION*/
                  RBMI        /*BMI DESCRIPTIVE*/
                  asthmastatus/*asthmatic status*/
                  AB17        /*DOCTOR EVER TOLD HAVE ASTHMA*/
                  AB43        /*HEALTH PROFESSIONAL EVER GAVE ASTHMA MANAGEMENT PLAN*/
                  AB98        /*HAVE WRITTEN COPY OF ASTHMA CARE PLAN*/
                  AB108_P1    /*CONFIDENCE TO CONTROL AND MANAGE ASTHMA*/
                  AB40        /*STILL HAS ASTHMA*/
                  AB41        /*ASTHMA EPISODE/ATTACK IN PAST 12 MOS*/
                  ASTCUR      /*CURRENT ASTHMA STATUS*/
                  ASTS        /*ASTHMA SYMPTOMS PAST 12 MOS FOR DIAGOSED ASTHMATICS*/
                  ASTYR       /*ASTHMA SYMPTOMS PAST 12 MOS FOR CURRENT ASTHAMTICS*/
                  AB18        /*TAKING DAILY MEDICATION TO CONTROL ASTHMA*/
                  AB19        /*ASTHMA SYMPT FREQ PAST 12 MOS: CURRENT ASTHMATICS*/
                  AH13A       /*ER/URGENT CRE FOR ASTHMA PAST 12 MOS: CURRENT ASTHM*/
                  AB22        /*DOCTOR EVER TOLD HAVE DIABETES*/
                  AB24        /*CURRENTLY TAKING INSULIN*/
                  AB25        /*CURRENTLY TAKING DIABETIC RX TO LOWER BLOOD SUGAR*/
                  AB34        /*DOCTOR EVER TOLD HAVE ANY KIND OF HEART DISEASE*/
                  AB52        /*EVER TOLD HAVE HEART FAILURE/CONGESTIVE*/
                  AB30        /*CURRENTLY TAKING RX TO CONTROL HIGH BLOOD PRESSURE*/
                  AB117       /*ADMITTED TO HOSPITAL FOR HEART DX PAST 12 MOS*/
                  DSTRS12     /*LIKELY HAS PSYCHOLOGICAL DISTRESS IN LAST YEAR*/
                  DSTRS30     /*LIKELY HAS PSYCHOLOGICAL DISTRESS IN PAST MONTH*/
                  AF65        /*FEEL RESTLESS WORST MONTH*/
                  AF63        /*FEEL NERVOUS WORST MONTH*/
                  AD50        /*BLIND/DEAF OR HAS SEVERE VISION/HEARING PROBLEM*/
                  AE15        /*SMOKED 100 OR MORE CIGARETTES IN ENTIRE LIFETIME*/
                  AE15A       /*SMOKES CIGARETTES EVERYDAY, SOME DAYS OR NOT AT ALL*/
                  SMKCUR      /*CURRENT SMOKER*/
                  SMOKING     /*CURRENT SMOKING HABITS*/
                  NUMCIG      /*# OF CIGARETTES PER DAY*/
                  AD37W       /*WALKED AT LEAST 10 MIN FOR TRANSPORT PAST 7 DAYS*/
                  AD40W       /*WALKED AT LEAST 10 MIN FOR LEISURE PAST 7 DAYS*/
                  AESODA_P1   /*# OF TIMES DRINKING SODA PER WEEK (PUF 1 YR RECODE)*/
                  AC42_P      /*HOW OFTEN FIND FRESH FRUIT/VEG IN NEIGHB (PUF RECODE)*/
                  AC44        /*NEIGHBORHOOD FRUIT/VEG AFFORDABLE*/
                  / PLOTS=ALL;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-HealthAccess.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Health Care Access & Insurance';
        WEIGHT    FNWGT0;
        REPWEIGHT    FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    INS         /*CURRENTLY INSURED*/
                  healthplan  /*name of health plan*/
                  HMO         /*HMO STATUS*/
                  AH71_P1     /*HEALTH PLAN DEDUCTIBLE MORE THAN $1,000*/
                  AH72_P1     /*HEALTH PLAN DEDUCTIBLE MORE THAN $2,000*/
                  AI25        /*COVERED FOR PRESCRIPTION DRUGS*/
                  AH1         /*HAVE USUAL SOURCE OF HEALTH CARE*/
                  USUAL5TP    /*USUAL SOURCE OF CARE (5 LVLS)*/
                  AH16        /*DELAY/NOT GET PRESCRIPTION IN PAST 12 MO*/
                  AJ19        /*COST/NO INSUR DELAYED GETTING PRESCRIPTION*/
                  AH22        /*DELAY/NOT GET OTHER MEDICAL CARE IN PAST 12 MOS*/
                  AJ20        /*COST/NO INSR DELAYED GETTING NEEDED CARE*/
                  AJ102       /*SOUGHT APPNT W/DOC IN 2 DAYS PAST YR*/
                  AJ112       /*HOW OFTEN DOC LISTENS CAREFULLY*/
                  AJ113       /*HOW OFTEN DOC CLEARLY EXPLAINS WHAT TO DO*/
                  AJ105       /*KNOW RIGHTS TO INTERPRETOR DURING MED VISIT*/
                  AJ9         /*MD LANGUAGE REASON WHY DIFFICULT TO UNDERSTAND*/
                  AH14        /*PATIENT IN HOSP OVERNIGHT DURING PAST 12 MOS*/
                  AH12        /*VISITED EMERGENCY ROOM FOR OWN HEALTH PAST 12 MOS*/
                  ER          /*ER VISIT WITHIN THE PAST YEAR*/
                  AJ108       /*EVER USED INTERNET*/
                ;
    RUN;
ODS PDF CLOSE;

/* PERFORM WEIGHTED UNIVARIATE ANALYSIS FOR RECODED BINOMIAL DATASET */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ-Socioeconomics.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Socioeconomic Status';
        WEIGHT    FNWGT0;
        REPWEIGHT    FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    POVLL       /*POVERTY LEVEL*/
                  FSLEV       /*FOOD SECURITY STATUS LEVEL*/
                  AL6         /*RECEIVING SSI (SUPPLEMENTAL SECURITY INCOME)*/
                  AL22        /*RECEIVING SOCIAL SECURITY DISABILITY INS*/
                  AL18A       /*RECVD SOCIAL SECURITY OR PENSION LAST MONTH*/
                  AK4         /*TYPE OF EMPLOYER AT MAIN JOB*/
                  AM36        /*DID VOLUNTEER WORK OR COMMUNITY SERVICES PAST YR*/
                  AK23        /*LIVE IN HOUSE, DUPLEX, ETC*/
                  AK25        /*OWN OR RENT HOME*/
                  AM19        /*PEOPLE IN NEIGHBORHOOD WILLING TO HELP EACH OTHER*/
                  AM21        /*PEOPLE IN NEIGHBORHOOD CAN BE TRUSTED*/
                  AK28        /*HOW OFTEN FEEL SAFE IN NEIGHBORHOOD*/
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

