%LET _CLIENTTASKLABEL='CHIS_45_AsthmaChar';
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
**	Date Created	: 31 March 2019 09:59																					**
**	Input Files		: CHIS.CHIS_DATA (see CHIS_10_LoadData)																	**
**	----------------------------------------------------------------------------------------------------------------------- **
**	Program Name	: CHIS_45_AthmaChar																						**
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

/* ASTHMA STATISTICS */
PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Asthma Variables';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AB17
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
			;
RUN;

PROC SURVEYFREQ DATA=CHIS.CHIS_DATA_FINAL VARMETHOD=JACKKNIFE;
	TITLE 'PROC SURVEYFREQ - CHIS.CHIS_DATA_FINAL -  Asthma Variables';
	WEIGHT	FNWGT0;
	REPWEIGHT	FNWGT1-FNWGT160 / jkcoefs = 1;
	TABLES	AB17*ASTS
			AB17*AB18
			AB17*AB19
			AB17*AB43
			AB17*AB98
			AB17*AB108_P1
			AB40*AB17
			AB40*ASTCUR
			AB40*ASTYR
			AB40*AB18
			AB40*AB19
			AB40*AH13A
			AB40*AB43
			AB40*AB98
			AB40*AB108_P1
			AB43*AB98
			/ CHISQ
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

