%LET _CLIENTTASKLABEL='CHIS_20_ComVars';
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
**  Date Created    : 18 February 2019 14:30                                        **
**  Program Name    : CHIS_20_ComVars                                               **
**  Purpose         : Reduces tables to only those variables that were consistently **
**                    utilized across all survey years                              **
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

/* MINIMIZE TO CROSS-YEAR COMMON VARIABLES */
DATA CHIS.CHIS_DATA_INTRM(KEEP = SRTENR
                                 SRAGE_P1
                                 SRSEX
                                 SRAS
                                 SRASO
                                 SRCH
                                 SRPH
                                 SRH
                                 SRO
                                 OMBSRR_P1
                                 RACECN_P1
                                 RACEDF_P1
                                 SRW
                                 SRAA
                                 SRAI
                                 AA5C
                                 MARIT
                                 MARIT_45
                                 MARIT2
                                 LATIN2TP
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
                                 AB99
                                 AB24
                                 AB25
                                 AB63
                                 AB112
                                 AB114_P1
                                 AB30
                                 AB34
                                 AB52
                                 AB117
                                 AB118
                                 AB113
                                 AB119
                                 AD37W
                                 AD40W
                                 AD41W
                                 AD42W
                                 AC31_P1
                                 AC11
                                 AE_SODA
                                 AESODA_P1
                                 AE15
                                 AE15A
                                 AD32_P1
                                 AE16_P1
                                 SMKCUR
                                 SMOKING
                                 NUMCIG
                                 AC42_P
                                 AC44
                                 HGHTI_P
                                 HGHTM_P
                                 HEIGHM_P
                                 WEIGHK_P
                                 WGHTK_P
                                 WGHTP_P
                                 AD50
                                 BMI_P
                                 RBMI
                                 AD57
                                 OVRWT
                                 AD51
                                 AD52
                                 AD53
                                 AD54
                                 DISABLE
                                 AJ29
                                 AF65
                                 AF67
                                 AF68
                                 AF70B
                                 AF71B
                                 AF72B
                                 AJ1
                                 AJ31
                                 AF62
                                 AF63
                                 DSTRS12
                                 DSTRS30
                                 CHORES2
                                 SOCIAL2
                                 FAMILY2
                                 AH33NEW
                                 AH34NEW
                                 AH35NEW
                                 LNGHM_P1
                                 AH37
                                 SPK_ENG
                                 CITIZEN2
                                 YRUS_P1
                                 PCTLF_P
                                 AH44
                                 AH43A
                                 AH44A
                                 ACHLDC_P1
                                 AG22
                                 SERVED
                                 AG10
                                 WRKST_P1
                                 AG8
                                 AG11
                                 AG9_P1
                                 AHEDC_P1
                                 FAMTYP_P
                                 AI4
                                 AI15
                                 AI15A
                                 AI22C
                                 HMO
                                 AI22A_P
                                 AI25
                                 AI25NEW
                                 AH71_P1
                                 AH72_P1
                                 AH74
                                 AH75
                                 AI28
                                 AH14
                                 AH96_P1
                                 AH97_P1
                                 INS
                                 INS12M
                                 INS65
                                 INSANY
                                 INSEM
                                 INSMC
                                 INSMD
                                 INSOG
                                 IHS
                                 INSPR
                                 INSPS
                                 INST_12
                                 UNINSANY
                                 OFFTK
                                 AH98_P1
                                 AH99_P1
                                 AH100
                                 AH101_P
                                 AH103
                                 INS64_P
                                 AH1
                                 AH3_P1
                                 USOC
                                 USUAL
                                 USUAL_TP
                                 USUAL5TP
                                 AH6
                                 ACMDNUM
                                 DOCT_YR
                                 AJ77
                                 AJ10
                                 AJ50_P
                                 AJ9
                                 AJ11
                                 AH16
                                 AJ19
                                 AH22
                                 AJ20
                                 AJ102
                                 AJ103
                                 AJ105
                                 AJ106
                                 AJ107
                                 AJ108
                                 AJ112
                                 AJ113
                                 AH12
                                 ER
                                 AH95_P1
                                 AK1
                                 AK2_P1
                                 AK4
                                 AKWKLNG
                                 AK8
                                 AK10_P
                                 AK10A_P
                                 AM1
                                 AM2
                                 AM3
                                 AM3A
                                 AM4
                                 AM5
                                 FSLEV
                                 FSLEVCB
                                 POVGWD_P
                                 POVLL
                                 AL6
                                 AL22
                                 AL18A
                                 AK23
                                 AK25
                                 AM19
                                 AM21
                                 AM35
                                 AK28
                                 AM36
                                 AM39
                                 AM38_P1
                                 AM40
                                 AM34
                                 UR_CLRT
                                 UR_CLRT2
                                 UR_IHS
                                 UR_OMB
                                 UR_RHP
                                 UR_BG
                                 UR_TRACT
                                 RAKEDW0-RAKEDW80
                                 PUF1Y_ID
                                 HHSIZE_P1
                                 PROXY
                                 year
                                 fnwgt0-fnwgt160
                                 i
                                 maritstat
                                 agegroup
                                 healthplan
                                 asthmastatus
                                 prilanguage
                                 famtype
                                );
    SET CHIS.CHIS_DATA_INTRM;
RUN;

/* Remove "Proxy Skippes" Observations */
DATA CHIS.CHIS_DATA_INTRM(    WHERE = (DSTRS30>-2));
    SET CHIS.CHIS_DATA_INTRM;
RUN;

/* VIEW TABLE CONTENTS & STRUCTURE */
ODS PDF FILE="&localProjectPath.CHIS\%SYSFUNC(DEQUOTE(&_CLIENTTASKLABEL))_PROC-CONTENTS.pdf"
        AUTHOR="Matthew C. Vanderbilt"
        TITLE="Targeting Reduced Asthma Hospitalizations"
        SUBJECT="MS Business Analytics Thesis"
        STYLE=StatDoc;
    PROC CONTENTS DATA=CHIS.CHIS_DATA_INTRM VARNUM;
        TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_INTRM';
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

