%LET _CLIENTTASKLABEL='CHIS_15_Recoding';
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
**  Date Created    : 14 April 2019 08:22                                                                                   **
**  Program Name    : CHIS_15_Recoding                                                                                      **
**  Purpose         : Recodes variables identified with inconsistencies or too many categories acros survey years           **
**  Reference Note  : Some code may be adapted/used from other sources; see README for "Reference Materials"                **
**                                                                                                                          **
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

PROC FORMAT LIBRARY=CHIS;
	VALUE fhealthplan	-1	= 'Inapplicable'
						1	= 'Kaiser'
						2	= 'Blue Cross'
						3	= 'United Healthcare'
						4	= 'Blue Shield'
						5	= 'Health Net'
						6	= 'Aetna'
						7	= 'Cigna Health Care'
						8	= 'Medicare/Medi-Cal'
						9	= 'Other'
						;

	VALUE fprilanguage	1	= 'English (Includes English & Other)'
						2	= 'Spanish'
						3	= 'Chinese'
						4	= 'Vietnamese'
						5	= 'Korean'
						6	= 'Other'
						;

	VALUE fasthmastatus	1	= '1 Current Asthmatic'
						2	= '2 Lifetime Asthmatic'
						3	= '3 Non-Asthmatic'
						;

	VALUE ffamtype		1	= 'Single w/o Children'
						2	= 'Single w/ Children'
						3	= 'Married w/o Children'
						4	= 'Married w/ Children'
						;

	VALUE fBoolean		-1	= 'NA'
						0	= 'False'
						1	= 'True';

	VALUE fagegroup		-1	= 'NA'
						1	= 'Young Adult (18-39)'
						2	= 'Middle Aged (40-64)'
						3	= 'Later Adult (65+)';

	VALUE flanguage		-1	= 'NA'
						1	= 'English'
						2	= 'Spanish'
						3	= 'Other';

	VALUE fmaritstat	-1	= 'NA'
						1	= 'Married/Partnered'
						2	= 'Widowed/Separated'
						3	= 'Never Married';
RUN;

DATA CHIS.CHIS_DATA_INTRM;
	SET CHIS.CHIS_DATA_RAW;

	*Marital Status;
	maritstat	= -1;
	IF marit2	IN(1,2)	THEN maritstat = 1;
	IF marit2	= 3		THEN maritstat = 2;
	IF marit2	= 4		THEN maritstat = 3;
	LABEL	maritstat	= 'marital status';
	FORMAT	maritstat	fmaritstat.;

	*Age Classification;
	agegroup	= -1;
	IF srage_p1 >= 18 AND srage_p1 < 40	THEN agegroup = 1;
	IF srage_p1 >= 40 AND srage_p1 < 65	THEN agegroup = 2;
	IF srage_p1 >= 65					THEN agegroup = 3;
	LABEL	agegroup	= 'age group';
	FORMAT	agegroup 	fagegroup.;
	
	*Secondary English Proficiency;
	AH37 = AH37;
	IF AH37 < -1 THEN AH37 = -1;
	IF AH37 = . THEN AH37 = -1;

	*Years of Armed Forces Service;
	SERVED = SERVED;
	IF SERVED < -1 THEN SERVED = -1;
	IF SERVED = . THEN SERVED = -1;

	*Educational Atttainment;
	*	MA/MS/PhD coded differently in 2013 than in other years;
	AHEDC_P1 = AHEDC_P1;
	IF YEAR = 2013 AND AHEDC_P1 > 8 THEN AHEDC_P1 = AHEDC_P1-1;

	*Telephone Calls Received;
	AM34 = AM34;
	IF AM34 < -1 THEN AM34 = -1;
	IF AM34 = . THEN AM34 = -1;

	*Family Type;
	famtype = FAMTYP_P;
	IF FAMTYP_P IN(1,2,6)	THEN famtype = 1;
	IF FAMTYP_P = 5			THEN famtype = 2;
	LABEL	famtype	= 'family type';
	FORMAT	famtype	ffamtype.;

	*Primary Language Spoken at Home;
	prilanguage = LNGHM_P1;
	IF LNGHM_P1 < -1 THEN prilanguage = -1;
	IF LNGHM_P1 IN(1,8,9,10,11,12) THEN prilanguage = 1;
	IF LNGHM_P1 IN(6,13) THEN prilanguage = 6;
	LABEL	prilanguage	= 'primary spoken language';
	FORMAT	prilanguage	fprilanguage.;

	*Name of Health Plan;
	healthplan = AI22A_P;
	IF AI22A_P < -1 THEN healthplan = -1;
	IF AI22A_P = 8 THEN healthplan = 9;
	IF INSMC = 1 OR INSMD = 1 THEN healthplan = 8;
	LABEL	healthplan	= 'name of health plan';
	FORMAT	healthplan	fhealthplan.;

	*Asthma Status;
	asthmastatus = 3;
	IF	AB17=1 
		OR AB43 = 1
		OR AB98 = 1
		OR AB108_P1 > 0
		THEN asthmastatus = 2;
	IF	AB40 = 1
		OR AB41 = 1
		OR ASTCUR = 1
		OR ASTS = 1
		OR ASTYR = 1
		OR AB18 = 1
		OR AB19 = 1
		OR AH13A = 1
		THEN asthmastatus = 1;
	LABEL	asthmastatus	= 'asthmatic status';
	FORMAT	asthmastatus	fasthmastatus.;

RUN;

/* CHIS.CHIS_DATA_RAW CONTENTS */
PROC CONTENTS DATA=CHIS.CHIS_DATA_INTRM VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_INTRM';
RUN;

/* Verify Recoding */
PROC FREQ DATA=CHIS.CHIS_DATA_INTRM;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_INTRM - RECODING VALIDATION';
	TABLES	MARIT2*maritstat
			SRAGE_P1*agegroup
			AH37
			SERVED
			AHEDC_P1
			AM34
			FAMTYP_P*famtype
			LNGHM_P1*prilanguage
			(INSMC
			INSMD
			AI22A_P)*healthplan
			(AB17
			AB18
			AB19
			AB40
			AB41
			AB43
			AB98
			AB108_P1
			AH13A
			ASTCUR
			ASTS
			ASTYR)*asthmastatus
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

