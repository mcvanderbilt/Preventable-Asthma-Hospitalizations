
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

DATA CHIS.CHIS_DATA_FINAL(	KEEP=	SRTENR
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
									HMO
									AI22A_P
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
									year
									fnwgt0-fnwgt160
							);
	SET CHIS.CHIS_DATA_FINAL;
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA_FINAL VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_FINAL';
RUN;

/* EVALUATE FINAL TABLE */
PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  A: Demographic Information';
	TABLES	SRTENR
			SRSEX
			RACEDF_P1
			maritstat
			agegroup
			year
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  B: General Health Conditions';
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

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  C: Health Behaviours';
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

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  D: General Health, Disability, & Sexual Health';
	TABLES	AD50
			RBMI;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  F: Mental Health';
	TABLES	AF65
			AF63
			DSTRS12
			DSTRS30
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  G: Demographic Information';
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

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  H: Health Insurance';
	TABLES	HMO
			AI22A_P
			AI25
			AH71_P1
			AH72_P1
			AH14
			INS
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  J: Health Care Utilization/Acess & Dental Health';
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

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  K: Employment, Income, Poverty Status, & Food Security';
	TABLES	AK4
			FSLEV
			POVLL
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  L: Public Program Participation';
	TABLES	AL6
			AL22
			AL18A
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  M: Housing & Community Involvement';
	TABLES	AK23
			AK25
			AM19
			AM21
			AK28
			AM36
			;
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA_FINAL;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_FINAL -  N: Demographic Information';
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

