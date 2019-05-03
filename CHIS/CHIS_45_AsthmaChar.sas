%LET _CLIENTTASKLABEL='CHIS_45_AsthmaChar';
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
**  Date Created    : 31 March 2019 09:59                                           **
**  Program Name    : CHIS_45_AsthmaChar                                            **
**  Purpose         : Investigates Characteristics of Asthmat Sample                **
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
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-SURVEYFREQ.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
        ODS GRAPHICS ON;
    PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
        TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Asthma Variables';
        WEIGHT    FNWGT0;
        REPWEIGHT FNWGT1-FNWGT160 / jkcoefs = 1;
        TABLES    (AB17       /*DOCTOR EVER TOLD HAVE ASTHMA*/
                   AB43       /*HEALTH PROFESSIONAL EVER GAVE ASTHMA MANAGEMENT PLAN*/
                   AB98       /*HAVE WRITTEN COPY OF ASTHMA CARE PLAN*/
                   AB108_P1   /*CONFIDENCE TO CONTROL AND MANAGE ASTHMA*/
                   AB40       /*STILL HAS ASTHMA*/
                   AB41       /*ASTHMA EPISODE/ATTACK IN PAST 12 MOS*/
                   ASTCUR     /*CURRENT ASTHMA STATUS*/
                   ASTS       /*ASTHMA SYMPTOMS PAST 12 MOS FOR DIAGNOSED ASTHMATICS*/
                   ASTYR      /*ASTHMA SYMPTOMS PAST 12 MOS FOR CURRENT ASTHMATICS*/
                   AB18       /*TAKING DAILY MEDICATION TO CONTROL ASTHMA*/
                   AB19       /*ASTHMA SYMPT FREQ PAST 12 MOS: CURRENT ASTHMATICS*/
                   AH13A      /*ER/URGENT CRE FOR ASTHMA PAST 12 MOS: CURRENT ASTHM*/
                  )*asthmastatus
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

