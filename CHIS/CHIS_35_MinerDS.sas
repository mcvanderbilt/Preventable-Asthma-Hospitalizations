%LET _CLIENTTASKLABEL='CHIS_35_MinerDS';
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
**  Date Created    : 15 April 2019 09:53                                           **
**  Program Name    : CHIS_35_MinerDS                                               **
**  Purpose         : Create data set for use with Enterprise Miner Decision Tree   **
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

/* CREATE DATA SET WITH LIMITED DESIRED FIELDS FOR MINER */
DATA CHIS.CHIS_DATA_MINER(KEEP = SRTENR
                                 SRSEX
                                 RACEDF_P1
                                 AH13A
                                 AB22
                                 AB24
                                 AB25
                                 AB30
                                 AB34
                                 AB52
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
                                 asthmastatus
                                 prilanguage
                                 famtype
                                 year
                         );
    SET CHIS.CHIS_DATA_FINAL;
RUN;

/* VIEW TABLE CONTENTS & STRUCTURE */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS-EM-All.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_MINER VARNUM;
        TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_MINER';
    RUN;
ODS PDF CLOSE;

/* CREATE MINER DATA SET WITH OF CURRENT ASTHMATICS ONLY */
DATA CHIS.CHIS_DATA_MINERCA;
    SET CHIS.CHIS_DATA_MINER (WHERE=(asthmastatus=1));
RUN;

/* VIEW TABLE CONTENTS & STRUCTURE */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS-EM-CurrAsth.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_MINERCA VARNUM;
        TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_MINERCA';
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

