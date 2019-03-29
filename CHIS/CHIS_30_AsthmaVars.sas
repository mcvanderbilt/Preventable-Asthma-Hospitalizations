/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Tuesday, 26 March, 2019     TIME: 11:16:07 AM
PROJECT: CHIS_Analysis
PROJECT PATH: C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\CHIS\CHIS_Analysis.egp
---------------------------------------- */

/* Library assignment for Local.CHIS */
Libname CHIS V9 'C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\CHIS' ;

/* ---------------------------------- */
/* MACRO: enterpriseguide             */
/* PURPOSE: define a macro variable   */
/*   that contains the file system    */
/*   path of the WORK library on the  */
/*   server.  Note that different     */
/*   logic is needed depending on the */
/*   server type.                     */
/* ---------------------------------- */
%macro enterpriseguide;
%global sasworklocation;
%local tempdsn unique_dsn path;

%if &sysscp=OS %then %do; /* MVS Server */
	%if %sysfunc(getoption(filesystem))=MVS %then %do;
        /* By default, physical file name will be considered a classic MVS data set. */
	    /* Construct dsn that will be unique for each concurrent session under a particular account: */
		filename egtemp '&egtemp' disp=(new,delete); /* create a temporary data set */
 		%let tempdsn=%sysfunc(pathname(egtemp)); /* get dsn */
		filename egtemp clear; /* get rid of data set - we only wanted its name */
		%let unique_dsn=".EGTEMP.%substr(&tempdsn, 1, 16).PDSE"; 
		filename egtmpdir &unique_dsn
			disp=(new,delete,delete) space=(cyl,(5,5,50))
			dsorg=po dsntype=library recfm=vb
			lrecl=8000 blksize=8004 ;
		options fileext=ignore ;
	%end; 
 	%else %do; 
        /* 
		By default, physical file name will be considered an HFS 
		(hierarchical file system) file. 
		*/
		%if "%sysfunc(getoption(filetempdir))"="" %then %do;
			filename egtmpdir '/tmp';
		%end;
		%else %do;
			filename egtmpdir "%sysfunc(getoption(filetempdir))";
		%end;
	%end; 
	%let path=%sysfunc(pathname(egtmpdir));
    %let sasworklocation=%sysfunc(quote(&path));  
%end; /* MVS Server */
%else %do;
	%let sasworklocation = "%sysfunc(getoption(work))/";
%end;
%if &sysscp=VMS_AXP %then %do; /* Alpha VMS server */
	%let sasworklocation = "%sysfunc(getoption(work))";                         
%end;
%if &sysscp=CMS %then %do; 
	%let path = %sysfunc(getoption(work));                         
	%let sasworklocation = "%substr(&path, %index(&path,%str( )))";
%end;
%mend enterpriseguide;

%enterpriseguide


/* Conditionally delete set of tables or views, if they exists          */
/* If the member does not exist, then no action is performed   */
%macro _eg_conditional_dropds /parmbuff;
	
   	%local num;
   	%local stepneeded;
   	%local stepstarted;
   	%local dsname;
	%local name;

   	%let num=1;
	/* flags to determine whether a PROC SQL step is needed */
	/* or even started yet                                  */
	%let stepneeded=0;
	%let stepstarted=0;
   	%let dsname= %qscan(&syspbuff,&num,',()');
	%do %while(&dsname ne);	
		%let name = %sysfunc(left(&dsname));
		%if %qsysfunc(exist(&name)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;

			%end;
				drop table &name;
		%end;

		%if %sysfunc(exist(&name,view)) %then %do;
			%let stepneeded=1;
			%if (&stepstarted eq 0) %then %do;
				proc sql;
				%let stepstarted=1;
			%end;
				drop view &name;
		%end;
		%let num=%eval(&num+1);
      	%let dsname=%qscan(&syspbuff,&num,',()');
	%end;
	%if &stepstarted %then %do;
		quit;
	%end;
%mend _eg_conditional_dropds;


/* save the current settings of XPIXELS and YPIXELS */
/* so that they can be restored later               */
%macro _sas_pushchartsize(new_xsize, new_ysize);
	%global _savedxpixels _savedypixels;
	options nonotes;
	proc sql noprint;
	select setting into :_savedxpixels
	from sashelp.vgopt
	where optname eq "XPIXELS";
	select setting into :_savedypixels
	from sashelp.vgopt
	where optname eq "YPIXELS";
	quit;
	options notes;
	GOPTIONS XPIXELS=&new_xsize YPIXELS=&new_ysize;
%mend _sas_pushchartsize;

/* restore the previous values for XPIXELS and YPIXELS */
%macro _sas_popchartsize;
	%if %symexist(_savedxpixels) %then %do;
		GOPTIONS XPIXELS=&_savedxpixels YPIXELS=&_savedypixels;
		%symdel _savedxpixels / nowarn;
		%symdel _savedypixels / nowarn;
	%end;
%mend _sas_popchartsize;


ODS PROCTITLE;
OPTIONS DEV=PNG;
GOPTIONS XPIXELS=0 YPIXELS=0;
FILENAME EGSRX TEMP;
ODS tagsets.sasreport13(ID=EGSRX) FILE=EGSRX
    STYLE=HtmlBlue
    STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/HtmlBlue.css")
    NOGTITLE
    NOGFOOTNOTE
    GPATH=&sasworklocation
    ENCODING=UTF8
    options(rolap="on")
;

/*   START OF NODE: CHIS_20_AsthmaVars   */
%LET _CLIENTTASKLABEL='CHIS_20_AsthmaVars';
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
**	Date Created	: 18 February 2019 14:30																				**
**	Input Files		: CHIS.CHIS_DATA (see CHIS_10_LoadData)																	**
**	----------------------------------------------------------------------------------------------------------------------- **
**	Program Name	: CHIS_20_AsthmaVars																					**
**	Purpose			: Adds Project-Specific Variables to Dataset															**
**	Reference Note	: Some code may be adapted/used from other sources; see README for "Reference Materials"				**
**	----------------------------------------------------------------------------------------------------------------------- **
**	ASTHMA VARIABLES																										**
**	================																										**
**	AB17			: doctor ever told have asthma (1=Yes; 2=No)															**
**	AB40			: still has asthma (-1=Inapplicable; 1=Yes; 2=No)														**
**	AB41			: asthma episode/attack in past 12 mos (-1=Inapplicable; 1=Yes; 2=No)									**
**	AB42_P1			: workdays missed due to asthma in past 12 mos (puf 1 yr recode)										**
**					  -1=Inapplicable; 0 = 0 Days; 1 = 1-2 Days; 3 = 3-4 Days; 5 = 5+ Days									**
**	AB43			: health professional ever gave asthma management plan (-1=Inapplicable; 1=Yes; 2=No)					**
**	AB98			: have written copy of asthma care plan (-1=Inapplicable; 1=Yes; 2=No)									**
**	ASTCUR			: current asthma status (1=Current Asthma; 2=No Current Asthma)											**
**																															**
**	----------------------------------------------------------------------------------------------------------------------- **
**	MODIFICATIONS																											**
**	=============																											**
**	Date			: 18 February 2019 14:30																				**
**	Programmer Name	: Matthew C. Vanderbilt																					**
**	Description		: Initial development of import protocol																**
**																															**
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

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
	VALUE fethnicity	-1	= 'NA'
						1	= 'Latino'
						2	= 'Other'
						3	= 'American Indian / Alaska Native'
						4	= 'Asian'
						5	= 'African American'
						6	= 'White'
						8	= 'Multiracial';
RUN;

/* APPLY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* CLEANUP DATA AND ADD VARIABLES */
DATA CHIS.CHIS_DATA (WHERE=(year>=2013));
	SET CHIS.CHIS_DATA_RAW;

	asthmatic = 0;
	IF ab17		= 1		THEN asthmatic = 1;
	IF ab40		= 1		THEN asthmatic = 1;
	IF ab41		= 1		THEN asthmatic = 1;
	IF ab42_p1	= 1		THEN asthmatic = 1;
	IF ab43		= 1		THEN asthmatic = 1;
	IF ab98		= 1		THEN asthmatic = 1;
	IF astcur	= 1		THEN asthmatic = 1;

	* Recode Variables;
	rc_ab17		= -1;
	IF ab17		= 1		THEN rc_ab17 = 1;
	IF ab17		= 2		THEN rc_ab17 = 0;

	rc_ab40		= -1;
	IF ab40		= -1	THEN rc_ab40 = -1;
	IF ab40		= 1		THEN rc_ab40 = 1;
	IF ab40		= 2		THEN rc_ab40 = 0;

	rc_ab41		= -1;
	IF ab41		= -1	THEN rc_ab41 = -1;
	IF ab41		= 1		THEN rc_ab41 = 1;
	IF ab41		= 2		THEN rc_ab41 = 0;

	rc_ab42_p1	= -1;
	IF ab42_p1	= -1	THEN rc_ab42_p1 = -1;
	IF ab42_p1	= 1		THEN rc_ab42_p1 = 1;
	IF ab42_p1	= 2		THEN rc_ab42_p1 = 0;

	rc_ab43		= -1;
	IF ab43		= -1	THEN rc_ab43 = -1;
	IF ab43		= 1		THEN rc_ab43 = 1;
	IF ab43		= 2		THEN rc_ab43 = 0;

	rc_ab98		= -1;
	IF ab98		= -1	THEN rc_ab98 = -1;
	IF ab98		= 1		THEN rc_ab98 = 1;
	IF ab98		= 2		THEN rc_ab98 = 0;

	rc_astcur	= -1;
	IF astcur	= 1		THEN rc_astcur = 1;
	IF astcur	= 2		THEN rc_astcur = 0;

	language	= -1;
	IF intvlngc_p1 IN(1,2,3) THEN language = intvlngc_p1;

	homeowner	= -1;
	IF srtenr	= 1		THEN homeowner = 1;
	IF srtenr	= 2		THEN homeowner = 0;

	agegroup	= -1;
	IF srage_p1 >= 18 AND srage_p1 < 40	THEN agegroup = 1;
	IF srage_p1 >= 40 AND srage_p1 < 65	THEN agegroup = 2;
	IF srage_p1 >= 65					THEN agegroup = 3;

	bnrysex	= -1;
	IF srsex	<> .	THEN bnrysex = srsex;

	maritstat	= -1;
	IF marit2	IN(1,2)	THEN maritstat = 1;
	IF marit2	= 3		THEN maritstat = 2;
	IF marit2	= 4		THEN maritstat = 3;

	ethnicity	= -1;
	IF racedf_p1 IN(1,2,3,4,5,6,8) THEN ethnicity = racedf_p1;

	* Field Labels;
	LABEL rc_ab17		= 'doctor ever told have asthma';
	LABEL rc_ab40		= 'still has asthma';
	LABEL rc_ab41		= 'asthma episode/attack in past 12 mos';
	LABEL rc_ab42_p1	= 'workdays missed due to asthma in past 12 mos (puf 1 yr recode)';
	LABEL rc_ab43		= 'health professional ever gave asthma management plan';
	LABEL rc_ab98		= 'have written copy of asthma care plan';
	LABEL rc_astcur		= 'current asthma status';
	LABEL asthmatic		= 'ever had asthma';
	LABEL language		= 'interview language';
	LABEL homeowner		= 'home owner';
	LABEL agegroup		= 'age group';
	LABEL bnrysex		= 'binary sex';
	LABEL maritstat		= 'marital status';
	LABEL ethnicity		= 'ethnicity';

	* Field Formats;
	FORMAT	asthmatic	fBoolean.;
	FORMAT	rc_ab17		fBoolean.;
	FORMAT	rc_ab40		fBoolean.;
	FORMAT	rc_ab41		fBoolean.;
	FORMAT	rc_ab42_p1	fBoolean.;
	FORMAT	rc_ab43		fBoolean.;
	FORMAT	rc_ab98		fBoolean.;
	FORMAT	rc_astcur	fBoolean.;
	FORMAT	language	flanguage.;
	FORMAT	homeowner	fBoolean.;
	FORMAT	agegroup 	fagegroup.;
	FORMAT	bnrysex		fbnrysex.;
	FORMAT	maritstat	fmaritstat.;
	FORMAT	ethnicity	fethnicity.;
	
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA';
RUN;

PROC FREQ DATA=CHIS.CHIS_DATA;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA';
	TABLES	asthmatic
			asthmatic*ab17
			asthmatic*rc_ab17 
			asthmatic*ab40
			asthmatic*rc_ab40 
			asthmatic*ab41
			asthmatic*rc_ab41 
			asthmatic*ab42_p1
			asthmatic*rc_ab42_p1 
			asthmatic*ab43
			asthmatic*rc_ab43 
			asthmatic*ab98
			asthmatic*rc_ab98 
			asthmatic*astcur
			asthmatic*rc_astcur
			ab40*ab41
			rc_ab40*rc_ab41
			language
			language*intvlngc_p1
			homeowner
			homeowner*srtenr
			agegroup
			agegroup*srage_p1
			bnrysex
			bnrysex*srsex
			maritstat
			maritstat*marit2
			ethnicity
			ethnicity*racedf_p1
			lnghm_p1*year
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

;*';*";*/;quit;run;
ODS _ALL_ CLOSE;
