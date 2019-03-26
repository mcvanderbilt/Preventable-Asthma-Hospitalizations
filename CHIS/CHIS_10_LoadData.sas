/* ----------------------------------------
Code exported from SAS Enterprise Guide
DATE: Sunday, 10 March, 2019     TIME: 7:32:47 PM
PROJECT: CHIS_Analysis
PROJECT PATH: C:\Users\rdy2d\OneDrive\Documents\GitHub\Preventable-Asthma-Hospitalizations\CHIS\CHIS_Analysis.egp
---------------------------------------- */

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

/*   START OF NODE: CHIS_10_LoadData   */
%LET _CLIENTTASKLABEL='CHIS_10_LoadData';
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
**	Date Created	: 18 February 2019 21:23																				**
**	Input Files		: CHIS Adult Public Data for 2001, 2003, 2005, 2007, 2009, and 2011 - 2017								**
**					  Only one-year dat files were utilized; the two-year files were not imported							**
**	----------------------------------------------------------------------------------------------------------------------- **
**	Program Name	: CHIS_10_LoadData																						**
**	Purpose			: Loads CHIS data files and creates combined file with adjusted weightings								**
**	Reference Note	: Some code may be adapted/used from other sources; see README for "Reference Materials"				**
**	----------------------------------------------------------------------------------------------------------------------- **
**	MODIFICATIONS																											**
**	=============																											**
**	Date			: 18 February 2019 21:23																				**
**	Programmer Name	: Matthew C. Vanderbilt																					**
**	Description		: Initial development of import protocol																**
**																															**
**	Date			: 10 March 2019 14:40																					**
**	Programmer Name	: Matthew C. Vanderbilt																					**
**	Description		: Updated local path and corrected library references in combine routine.								**
**																															**
**	Date			: 10 March 2019 19:32																					**
**	Programmer Name	: Matthew C. Vanderbilt																					**
**	Description		: Created and applied formatting per CHIS data dictionary.												**
**																															**
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

/* LOAD 2017 DATA */
LIBNAME CHIS2017 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_PROC_FORMAT.SAS';

DATA data2017;
	SET CHIS2017.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\adult_2017_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2017.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2017.adult';
RUN;

/* LOAD 2016 DATA */
LIBNAME CHIS2016 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2016;
	SET CHIS2016.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS16_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2016.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2016.adult';
RUN;

/* LOAD 2015 DATA */
LIBNAME CHIS2015 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2015;
	SET CHIS2015.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS15_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2015.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2015.adult';
RUN;

/* LOAD 2014 DATA */
LIBNAME CHIS2014 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2014;
	SET CHIS2014.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS14_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2014.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2014.adult';
RUN;

/* LOAD 2013 DATA */
LIBNAME CHIS2013 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2013;
	SET CHIS2013.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS13_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2013.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2013.adult';
RUN;

/* LOAD 2012 DATA */
LIBNAME CHIS2012 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2012;
	SET CHIS2012.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS12_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2012.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2012.adult';
RUN;

/* LOAD 2011 DATA */
LIBNAME CHIS2011 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2011;
	SET CHIS2011.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS11_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2011.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2011.adult';
RUN;

/* LOAD 2009 DATA */
LIBNAME CHIS2009 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_PROC_FORMAT.SAS';

DATA data2009;
	SET CHIS2009.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\CHIS 2009 PUF- Adult SAS\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2009.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2009.adult';
RUN;

/* LOAD 2007 DATA */
LIBNAME CHIS2007 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_PROC_FORMAT.SAS';

DATA data2007;
	SET CHIS2007.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis07_adult_sas\Adult SAS\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2007.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2007.adult';
RUN;

/* LOAD 2005 DATA */
LIBNAME CHIS2005 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_PROC_FORMAT.SAS';

DATA data2005;
	SET CHIS2005.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis05_adult_sas\chis05_adult_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2005.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2005.adult';
RUN;

/* LOAD 2003 DATA */
LIBNAME CHIS2003 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_PROC_FORMAT.SAS';

DATA data2003;
	SET CHIS2003.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis03_adult_sas\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2003.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2003.adult';
RUN;

/* LOAD 2001 DATA */
LIBNAME CHIS2001 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\';
%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_PROC_FORMAT.SAS';

DATA data2001;
	SET CHIS2001.adult;
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_FORMAT.SAS';
	%INCLUDE 'C:\Users\rdy2d\OneDrive\Documents\Education\Matthew\National University\ANA699B\CHIS\chis01_adult_sas\Data\ADULT_LABEL.SAS';
RUN;

PROC CONTENTS DATA=CHIS2001.adult VARNUM;
	TITLE 'PROC CONTENTS - CHIS2001.adult';
RUN;

/* COMBINE DATA */
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS2001.adult (in=in01)
		CHIS2003.adult (in=in03)
		CHIS2005.adult (in=in05)
		CHIS2007.adult (in=in07)
		CHIS2009.adult (in=in09)
		CHIS2011.adult (in=in11)
		CHIS2012.adult (in=in12)
		CHIS2013.adult (in=in13)
		CHIS2014.adult (in=in14)
		CHIS2015.adult (in=in15)
		CHIS2016.adult (in=in16)
		CHIS2017.adult (in=in17);

	IF		in01 THEN year=2001;
	ELSE IF in03 THEN year=2003;
	ELSE IF in05 THEN year=2005;
	ELSE IF in07 THEN year=2007;
	ELSE IF in09 THEN year=2009;
	ELSE IF in11 THEN year=2011;
	ELSE IF in12 THEN year=2012;
	ELSE IF in13 THEN year=2013;
	ELSE IF in14 THEN year=2014;
	ELSE IF in15 THEN year=2015;
	ELSE IF in16 THEN year=2016;
	ELSE IF in17 THEN year=2017;

	***Create new weight variables;

	fnwgt0 = rakedw0/12;

	ARRAY a_origwgts[80] rakedw1-rakedw80;
	ARRAY a_newwgts[160] fnwgt1-fnwgt160;

	DO i = 1 to 80;
			IF year=2001 THEN DO;
				a_newwgts[i]    = a_origwgts[i]/12;
				a_newwgts[i+80] = rakedw0/12;
    		END;
		    ELSE IF year=2014 then do;

		      a_newwgts[i]    = rakedw0/2;

		      a_newwgts[i+80] = a_origwgts[i]/2;

		    end;
  	END;
RUN;

/* SPECIFY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* CHIS SCREENING FORMATS */
PROC FORMAT LIBRARY=CHIS;
	VALUE fCHISBool		-1	= 'NA'
						1	= 'Yes'
						2	= 'No';
	VALUE fintvlngc_p	1	= 'English'
						2	= 'Spanish'
						3	= 'Other';
	VALUE fsrtenr		1	= 'Own'
						2	= 'Rent/Other';
RUN;
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	intvlngc_p1	fintvlngc_p.;
	FORMAT	proxy		fCHISBool.;
	FORMAT	srtenr		fsrtenr.;	
RUN;

/* CHIS DEMOGRAPHIC INFORMATION FORMATS */
PROC FORMAT LIBRARY=CHIS;
	VALUE fage			-1	= 'NA'
						18	= '18-25'
						26	= '26-29'
						30	= '30-34'
						35	= '35-39'
						40	= '40-44'
						45	= '45-49'
						50	= '50-54'
						55	= '55-59'
						60	= '60-64'
						65	= '65-69'
						70	= '70-74'
						75	= '75-79'
						80	= '80-84'
						85	= '85+';
	VALUE fbnrysex		1	= 'Male'
						2	= 'Female';
	VALUE flatintp		-1	= 'Non-Latino'
						1	= 'Mexican'
						2	= 'Other';
	VALUE fombsrr_p		1	= 'Hispanic'
						2	= 'White, Non-Hispanic'
						3	= 'African American'
						4	= 'American Indian / Alaska Native'
						5	= 'Asian'
						6	= 'Other / Multiracial';
	VALUE fracecn_p		1	= 'Other'
						2	= 'American Indian / Alaska Native'
						3	= 'Asian'
						4	= 'African American'
						5	= 'White'
						7	= 'Multiracial';
	VALUE fracedf_p		1	= 'Latino'
						2	= 'Other'
						3	= 'American Indian / Alaska Native'
						4	= 'Asian'
						5	= 'African American'
						6	= 'White'
						8	= 'Multiracial';
	VALUE fracehp_p		1	= 'Latino'
						2	= 'Other / Mutliracial'
						3	= 'American Indian / Alaska Native'
						4	= 'Asian'
						5	= 'African American'
						6	= 'White';
	VALUE faac			-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-1	= 'Inapplicable'
						1	= 'Yes'
						2	= 'No';
	VALUE fmarit		1	= 'Married'
						2	= 'Other'
						3	= 'Never Married';
	VALUE fmarit_adlt	-1	= 'Inapplicable'
						1	= 'Married'
						2	= 'Living with Partner'
						3	= 'Widowed'
						4	= 'Divorced/Separated'
						5	= 'Never Married';
	VALUE fmarit_scnd	1	= 'Married'
						2	= 'Living w/ Partner'
						3	= 'Wid/Sep/Div'
						4	= 'Never Married';
RUN;
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	srage_p1 	fage.;
	FORMAT	srsex		fbnrysex.;
	FORMAT	latin2tp	flatintp.;
	FORMAT	sras		fCHISBool.;
	FORMAT	sraso		fCHISBool.;
	FORMAT	srch		fCHISBool.;
	FORMAT	srkr		fCHISBool.;
	FORMAT	srjp		fCHISBool.;
	FORMAT	srph		fCHISBool.;
	FORMAT	srvt		fCHISBool.;
	FORMAT	srh			fCHISBool.;
	FORMAT	srw			fCHISBool.;
	FORMAT	sraa		fCHISBool.;
	FORMAT	srai		fCHISBool.;
	FORMAT	sro			fCHISBool.;
	FORMAT	ombsrr_p1	fombsrr_p.;
	FORMAT	racecn_p1	fracecn_p.;
	FORMAT	racedf_p1	fracedf_p.;
	FORMAT	racehp2_p1	fracehp_p.;
	FORMAT	aa5c		faac.;
	FORMAT	marit		fmarit.;
	FORMAT	marit_45	fmarit_adlt.;
	FORMAT	marit2		fmarit_scnd.;
RUN;

/* CHIS GENERAL HEALTH CONDITION FORMATS */
PROC FORMAT LIBRARY=CHIS;
	VALUE fab			1	= 'Excellent'
						2	= 'Very Good'
						3	= 'Good'
						4	= 'Fair'
						5	= 'Poor';
	VALUE fastcur		1	= 'Current Asthma'
						2	= 'No Current Asthma';
	VALUE fabadlt_p		-1	= 'Inapplicable'
						0	= '0 Days'
						1	= '1-2 Days'
						3	= '3-4 Days'
						5	= '5+ Days';
	VALUE fabdiabet		1	= 'Yes'
						2	= 'No'
						3	= 'Borderline/Pre-Diabetes';
	VALUE fdiabage		-1	= 'Inapplicable'
						1	= '<= 18'
						2	= '19-29'
						3	= '30-39'
						4	= '40-49'
						5	= '50-59'
						6	= '60-69'
						7	= '70-79'
						8	= '>= 80';
	VALUE fdiabtype		-1	= 'Inapplicable'
						1	= 'Type I'
						2	= 'Type II';
	VALUE fdiabfeet		-1	= 'Inapplicable'
						0	= '0 Times'
						1	= '1 Time'
						2	= '2 Times'
						3	= '3 Times'
						4	= '4 Times'
						5	= '5+ Times';
	VALUE fdiabdilat	-1	= 'Inapplicable'
						1	= 'Within the Past Month'
						2	= '1 to 12 Months Ago'
						3	= '1 to 2 Years Ago'
						4	= '2 or More Years Ago'
						5	= 'Never';
	VALUE fdiabctlmgt	-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Very Confident'
						2	= 'Somewhat Confident'
						3	= 'Not Too Confident / Not at All Confident';
	VALUE fdiabpreg		-1	= 'Inapplicable'
						1	= 'Yes'
						2	= 'No'
						3	= 'Borderline Gestational Diabetes';
	VALUE fhighbp		1	= 'Yes'
						2	= 'No'
						3	= 'Borderline Hypertension';
RUN;
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ab1			fab.;
	FORMAT	ab17		fCHISBool.;
	FORMAT	ab40		fCHISBool.;
	FORMAT	ab41		fCHISBool.;
	FORMAT	astcur		fastcur.;
	FORMAT	ab42_p1		fabadlt_p.;
	FORMAT	ab43		fCHISBool.;
	FORMAT	ab98		fCHISBool.;
	FORMAT	ab22		fabdiabet.;
	FORMAT	ab99		fCHISBool.;
	FORMAT	diabetes	fCHISBool.;
	FORMAT	prediab		fCHISBool.;
	FORMAT	ab23_p1		fdiabage.;
	FORMAT	ab51_p1		fdiabtype.;
	FORMAT	ab24		fCHISBool.;
	FORMAT	ab25		fCHISBool.;
	FORMAT	ab28_p1		fdiabfeet.;
	FORMAT	ab63		fdiabdilat.;
	FORMAT	ab112		fCHISBool.;
	FORMAT	ab114_p1	fdiabctlmgt.;
	FORMAT	ab81		fdiabpreg.;
	FORMAT	ab29		fhighbp.;
	FORMAT	ab30		fCHISBool.;
	FORMAT	ab34		fCHISBool.;
	FORMAT	ab52		fCHISBool.;
	FORMAT	ab118		fCHISBool.;
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA_RAW VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_RAW';
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
