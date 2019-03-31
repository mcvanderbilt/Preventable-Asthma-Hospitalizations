%LET _CLIENTTASKLABEL='CHIS_40_SubjectChar';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\CHIS\CHIS_Analysis.egp';
%LET _CLIENTPROJECTPATHHOST='R90T7H56';
%LET _CLIENTPROJECTNAME='CHIS_Analysis.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
/*****************************************************************************************************************************
**	Project Name	: Secondary Research of Asthma  Hospitalizations														**
**					  Masters of Science in Business Analytics Cappstone Project											**
**					  February 2019																							**
**	Author			: Matthew C. Vanderbilt																					**
**					  Candidate & NU Scholar, National University															**
**					  Director of Fiscal Affairs, Department of Medicine, UC San Diego School of Medicine					**
**	======================================================================================================================= **
**	Date Created	: 23 March 2019 22:31																					**
**	Input Files		: CHIS.CHIS_DATA (see CHIS_10_LoadData)																	**
**	----------------------------------------------------------------------------------------------------------------------- **
**	Program Name	: CHIS_40_SubjectChar																					**
**	Purpose			: Investigates Characteristics of Sample																**
**	Reference Note	: Some code may be adapted/used from other sources; see README for "Reference Materials"				**
**																															**
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  A: Demographic Information';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	SRTENR
			SRSEX
			RACEDF_P1
			maritstat
			agegroup
			year
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  B: General Health Conditions';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AB1
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
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  C: Health Behaviours';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AD37W
			AD40W
			AESODA_P1
			AE15
			AE15A
			SMKCUR
			SMOKING
			NUMCIG
			AC42_P
			AC44
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  D: General Health, Disability, & Sexual Health';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AD50
			RBMI;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  F: Mental Health';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AF65
			AF63
			DSTRS12
			DSTRS30
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  G: Demographic Information';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AH33NEW
			AH34NEW
			AH35NEW
			LNGHM_P1
			AH37
			CITIZEN2
			YRUS_P1
			PCTLF_P
			AG22
			SERVED
			AG10
			WRKST_P1
			AHEDC_P1
			FAMTYP_P
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  H: Health Insurance';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	HMO
			AI22A_P
			AI25
			AH71_P1
			AH72_P1
			AH14
			INS
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  J: Health Care Utilization/Acess & Dental Health';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AH1
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
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  K: Employment, Income, Poverty Status, & Food Security';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AK4
			FSLEV
			POVLL
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  L: Public Program Participation';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AL6
			AL22
			AL18A
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  M: Housing & Community Involvement';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AK23
			AK25
			AM19
			AM21
			AK28
			AM36
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  N: Demographic Information';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AM34
			UR_CLRT
			;
RUN;

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

