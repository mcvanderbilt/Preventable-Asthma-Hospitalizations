%LET _CLIENTTASKLABEL='CHIS_45_AsthmaChar';
%LET _CLIENTPROCESSFLOWNAME='CHIS_Execution';
%LET _CLIENTPROJECTPATH='C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\CHIS\CHIS_Analysis.egp';
%LET _CLIENTPROJECTPATHHOST='R90T7H56';
%LET _CLIENTPROJECTNAME='CHIS_Analysis.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
/*****************************************************************************************************************************
**  Project Name    : Secondary Research of Asthma  Hospitalizations                                                        **
**                    Masters of Science in Business Analytics Capstone Project                                             **
**                    March / April 2019                                                                                    **
**  Author          : Matthew C. Vanderbilt                                                                                 **
**                    Candidate & NU Scholar, National University                                                           **
**                    Director of Fiscal Affairs, Department of Medicine, UC San Diego School of Medicine                   **
**  ======================================================================================================================= **
**  Date Created    : 31 March 2019 09:59                                                                                   **
**  Program Name    : CHIS_45_AthmaChar                                                                                     **
**  Purpose         : Investigates Characteristics of Sample                                                                **
**  Reference Note  : Some code may be adapted/used from other sources; see README for "Reference Materials"                **
**                                                                                                                          **
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
	TABLES	(AB17		/*DOCTOR EVER TOLD HAVE ASTHMA*/
			AB43		/*HEALTH PROFESSIONAL EVER GAVE ASTHMA MANAGEMENT PLAN*/
			AB98		/*HAVE WRITTEN COPY OF ASTHMA CARE PLAN*/
			AB108_P1	/*CONFIDENCE TO CONTROL AND MANAGE ASTHMA (PUF 1 YR RECODE)*/
			AB40		/*STILL HAS ASTHMA*/
			AB41		/*ASTHMA EPISODE/ATTACK IN PAST 12 MOS*/
			ASTCUR		/*CURRENT ASTHMA STATUS*/
			ASTS		/*ASTHMA SYMPTOMS PAST 12 MOS FOR POPULATION DIAGNOSED W/ ASTHMA*/
			ASTYR		/*ASTHMA SYMPTOMS PAST 12 MOS FOR POPULATION CURRENTLY W/ ASTHMA*/
			AB18		/*TAKING DAILY MEDICATION TO CONTROL ASTHMA*/
			AB19		/*FREQUENCY OF ASTHMA SYMPTOMS IN PAST 12 MOS: CURRENT ASTHMATICS*/
			AH13A		/*ER/URGENT CRE VISIT FOR ASTHMA LAST 12 MOS: CURRENT ASTHMATICS*/
			)*asthmastatus
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

