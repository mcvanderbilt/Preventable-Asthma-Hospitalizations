/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Monday, 18 February, 2019     TIME: 9:30:52 PM
PROJECT: CapstoneSAS
PROJECT PATH: O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CapstoneSAS.egp
---------------------------------------- */


/*   START OF NODE: CHIS_10_LoadData   */
%LET _CLIENTTASKLABEL='CHIS_10_LoadData';
%LET _CLIENTPROCESSFLOWNAME='Process Flow';
%LET _CLIENTPROJECTPATH='O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CapstoneSAS.egp';
%LET _CLIENTPROJECTPATHHOST='EYEOFHARMONY';
%LET _CLIENTPROJECTNAME='CapstoneSAS.egp';
%LET _SASPROGRAMFILE='';
%LET _SASPROGRAMFILEHOST='';

GOPTIONS ACCESSIBLE;
/*******************************************************************************************************************************
**	Project Name	: Secondary Research of Asthma  Hospitalizations														  **
**					  Masters of Science in Business Analytics Cappstone Project											  **
**					  February 2019																							  **
**	Author			: Matthew C. Vanderbilt																					  **
**					  Candidate & NU Scholar, National University															  **
**					  Director of Fiscal Affairs, Department of Medicine, UC San Diego School of Medicine					  **
**	========================================================================================================================  **
**	Date Created	: 18 February 2019 21:23																				  **
**	Input Files		: CHIS Adult Public Data for 2001, 2003, 2005, 2007, 2009, and 2011 - 2017								  **
**	------------------------------------------------------------------------------------------------------------------------  **
**	Program Name	: CHIS_10_LoadData																						  **
**	Purpose			: Loads CHIS data files and creates combined file with adjusted weightings								  **
**	------------------------------------------------------------------------------------------------------------------------  **
**	MODIFICATIONS																											  **
**	=============																											  **
**	Date			: 18 February 2019 21:23																				  **
**	Programmer Name	: Matthew C. Vanderbilt																					  **
**	Description		: Initial development of import protocol																  **
**																															  **
*******************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
LIBNAME CHIS 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\'

/* LOAD 2017 DATA */
LIBNAME CHIS2017 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_PROC_FORMAT.SAS';

DATA data2017;
	SET CHIS2017.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2017.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2017.adult';
RUN;

/* LOAD 2016 DATA */
LIBNAME CHIS2016 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2016;
	SET CHIS2016.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2016.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2016.adult';
RUN;

/* LOAD 2015 DATA */
LIBNAME CHIS2015 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2015;
	SET CHIS2015.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2015.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2015.adult';
RUN;

/* LOAD 2014 DATA */
LIBNAME CHIS2014 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2014;
	SET CHIS2014.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2014.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2014.adult';
RUN;

/* LOAD 2013 DATA */
LIBNAME CHIS2013 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2013;
	SET CHIS2013.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2013.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2013.adult';
RUN;

/* LOAD 2012 DATA */
LIBNAME CHIS2012 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2012;
	SET CHIS2012.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2012.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2012.adult';
RUN;

/* LOAD 2011 DATA */
LIBNAME CHIS2011 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2011;
	SET CHIS2011.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2011.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2011.adult';
RUN;

/* LOAD 2009 DATA */
LIBNAME CHIS2009 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_PROC_FORMAT.SAS';

DATA data2009;
	SET CHIS2009.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2009.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2009.adult';
RUN;

/* LOAD 2007 DATA */
LIBNAME CHIS2007 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_PROC_FORMAT.SAS';

DATA data2007;
	SET CHIS2007.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2007.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2007.adult';
RUN;

/* LOAD 2005 DATA */
LIBNAME CHIS2005 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_PROC_FORMAT.SAS';

DATA data2005;
	SET CHIS2005.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2005.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2005.adult';
RUN;

/* LOAD 2003 DATA */
LIBNAME CHIS2003 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_PROC_FORMAT.SAS';

DATA data2003;
	SET CHIS2003.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2003.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2003.adult';
RUN;

/* LOAD 2001 DATA */
LIBNAME CHIS2001 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\';
%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2001;
	SET CHIS2001.adult;
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'O:\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2001.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2001.adult';
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

