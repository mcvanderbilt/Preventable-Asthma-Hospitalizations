%LET _CLIENTTASKLABEL='CHIS_30_FinalData';
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
**  Date Created    : 29 March 2019 16:36                                           **
**  Program Name    : CHIS_30_FinalData                                             **
**  Purpose         : Create final table for use thorughout analysis                **
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

DATA CHIS.CHIS_DATA_FINAL(KEEP = SRTENR
                                 SRSEX
                                 RACEDF_P1
                                 AB1
                                 AB17
                                 AB40
                                 AB41
                                 ASTCUR
                                 ASTS
                                 ASTYR
                                 AB18
                                 AB19
                                 AH13A
                                 AB43
                                 AB98
                                 AB108_P1
                                 AB22
                                 AB24
                                 AB25
                                 AB30
                                 AB34
                                 AB52
                                 AB117
                                 AD37W
                                 AD40W
                                 AESODA_P1
                                 AE15
                                 AE15A
                                 SMKCUR
                                 SMOKING
                                 NUMCIG
                                 AC42_P
                                 AC44
                                 AD50
                                 RBMI
                                 AF65
                                 AF63
                                 DSTRS12
                                 DSTRS30
                                 AH33NEW
                                 AH34NEW
                                 AH35NEW
                                 AH37
                                 CITIZEN2
                                 YRUS_P1
                                 PCTLF_P
                                 AG22
                                 SERVED
                                 AG10
                                 WRKST_P1
                                 AHEDC_P1
                                 HMO
                                 AI25
                                 AH71_P1
                                 AH72_P1
                                 AH14
                                 INS
                                 AH1
                                 USUAL5TP
                                 AJ9
                                 AH16
                                 AJ19
                                 AH22
                                 AJ20
                                 AJ102
                                 AJ105
                                 AJ108
                                 AJ112
                                 AJ113
                                 AH12
                                 ER
                                 AK4
                                 FSLEV
                                 POVLL
                                 AL6
                                 AL22
                                 AL18A
                                 AK23
                                 AK25
                                 AM19
                                 AM21
                                 AK28
                                 AM36
                                 AM34
                                 UR_CLRT
                                 maritstat
                                 agegroup
                                 healthplan
                                 asthmastatus
                                 prilanguage
                                 famtype
                                 year
                                 fnwgt0-fnwgt160
                         );
    SET CHIS.CHIS_DATA_INTRM;
RUN;

/* VIEW TABLE CONTENTS & STRUCTURE */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_FINAL VARNUM;
        TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_FINAL';
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

