%LET _CLIENTTASKLABEL='CHIS_30_FinalData';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
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
**  Date Created    : 29 March 2019 16:36                                                                                   **
**  Input Files     : CHIS Adult Public Data for 2001, 2003, 2005, 2007, 2009, and 2011 - 2017                              **
**                    Only one-year dat files were utilized; the two-year files were not imported                           **
**  ----------------------------------------------------------------------------------------------------------------------- **
**  Program Name    : CHIS_30_FinalData                                                                                     **
**  Purpose         : Create final variable table for analysis                                                              **
**  Reference Note  :  Some code may be adapted/used from other sources; see README for "Reference Materials"               **
**                                                                                                                          **
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* CUSTOM VARIABLE FORMATS */
PROC FORMAT LIBRARY=CHIS;
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

/* ADD DERIVED VARIABLES */
DATA CHIS.CHIS_DATA_FINAL;
	SET CHIS.CHIS_DATA_INTRM;

	* Recode Variables;
	maritstat	= -1;
	IF marit2	IN(1,2)	THEN maritstat = 1;
	IF marit2	= 3		THEN maritstat = 2;
	IF marit2	= 4		THEN maritstat = 3;
	LABEL	maritstat	= 'marital status';
	FORMAT	maritstat	fmaritstat.;

	agegroup	= -1;
	IF srage_p1 >= 18 AND srage_p1 < 40	THEN agegroup = 1;
	IF srage_p1 >= 40 AND srage_p1 < 65	THEN agegroup = 2;
	IF srage_p1 >= 65					THEN agegroup = 3;
	LABEL	agegroup	= 'age group';
	FORMAT	agegroup 	fagegroup.;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA';
	TABLES	marit2*maritstat
			srage_p1*agegroup
			;
RUN;

DATA CHIS.CHIS_DATA_FINAL(	KEEP=
							RACEDF_P1
							SRSEX
							AB1
							AB17
							AB22
							AB24
							AB25
							AB29
							AB30
							AB34
							AB40
							AB41
							AB42_P1
							AB43
							AB52
							AB98
							ASTCUR
							AC42_P
							AD37W
							AD40W
							AE15A
							AESODA_P1
							SMOKING
							AD50
							RBMI
							AF63
							AF64
							AF65
							AF66
							AG22
							AH33NEW
							AH34NEW
							AH35NEW
							AH37
							AHEDC_P1
							CITIZEN2
							FAMTYP_P
							LNGHM_P1
							WRKST_P1
							AI22A_P
							AI25
							HMO
							INS
							AH16
							AH22
							AJ105
							AJ136
							AJ19
							AJ20
							CARE_PV
							ER
							USUAL5TP
							AK4
							FSLEV
							INDMAIN2
							OCCMAIN2
							POVLL
							AL18A
							AL2
							AL22
							AL32
							AL5
							AL6
							AK23
							AK25
							AK28
							AM19
							AM20
							AM21
							AM36
							AM34
							town_type
							maritstat
							agegroup
						);
	SET CHIS.CHIS_DATA_FINAL;
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA_FINAL VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_FINAL';
RUN;

/* EVALUATE FINAL TABLE */
PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  A: Demographic Information';
	TABLES	RACEDF_P1
			SRSEX
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  B: General Health Conditions';
	TABLES	AB1
			AB17
			AB22
			AB24
			AB25
			AB29
			AB30
			AB34
			AB40
			AB41
			AB42_P1
			AB43
			AB52
			AB98
			ASTCUR
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  C: Health Behaviours';
	TABLES	AC42_P
			AD37W
			AD40W
			AE15A
			AESODA_P1
			SMOKING
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  D: General Health, Disability, & Sexual Health';
	TABLES	AD50
			RBMI;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  F: Mental Health';
	TABLES	AF63
			AF64
			AF65
			AF66
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  G: Demographic Information';
	TABLES	AG22
			AH33NEW
			AH34NEW
			AH35NEW
			AH37
			AHEDC_P1
			CITIZEN2
			FAMTYP_P
			LNGHM_P1
			WRKST_P1
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  H: Health Insurance';
	TABLES	AI22A_P
			AI25
			HMO
			INS
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  J: Health Care Utilization/Acess & Dental Health';
	TABLES	AH16
			AH22
			AJ105
			AJ136
			AJ19
			AJ20
			CARE_PV
			ER
			USUAL5TP
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  K: Employment, Income, Poverty Status, & Food Security';
	TABLES	AK4
			FSLEV
			INDMAIN2
			OCCMAIN2
			POVLL
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  L: Public Program Participation';
	TABLES	AL18A
			AL2
			AL22
			AL32
			AL5
			AL6
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  M: Housing & Community Involvement';
	TABLES	AK23
			AK25
			AK28
			AM19
			AM20
			AM21
			AM36
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  N: Demographic Information';
	TABLES	AM34
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

