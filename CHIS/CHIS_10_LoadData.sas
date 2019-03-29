
GOPTIONS ACCESSIBLE;
/*****************************************************************************************************************************
**  Project Name    : Secondary Research of Asthma  Hospitalizations                                                        **
**                    Masters of Science in Business Analytics Capstone Project                                             **
**                    March / April 2019                                                                                    **
**  Author          : Matthew C. Vanderbilt                                                                                 **
**                    Candidate & NU Scholar, National University                                                           **
**                    Director of Fiscal Affairs, Department of Medicine, UC San Diego School of Medicine                   **
**  ======================================================================================================================= **
**  Date Created    : 18 February 2019 21:23                                                                                **
**  Input Files     : CHIS Adult Public Data for 2001, 2003, 2005, 2007, 2009, and 2011 - 2017                              **
**                    Only one-year dat files were utilized; the two-year files were not imported                           **
**  ----------------------------------------------------------------------------------------------------------------------- **
**  Program Name    : CHIS_10_LoadData                                                                                      **
**  Purpose         : Loads CHIS data files and creates combined file with adjusted weightings                              **
**  Reference Note  :  Some code may be adapted/used from other sources; see README for "Reference Materials"                **
**  ----------------------------------------------------------------------------------------------------------------------- **
**  MODIFICATIONS                                                                                                           **
**  =============                                                                                                           **
**  Date            : 18 February 2019 21:23                                                                                **
**  Programmer Name : Matthew C. Vanderbilt                                                                                 **
**  Description     : Initial development of import protocol                                                                **
**                                                                                                                          **
**  Date            : 10 March 2019 14:40                                                                                   **
**  Programmer Name : Matthew C. Vanderbilt                                                                                 **
**  Description     : Updated local path and corrected library references in combine routine.                               **
**                                                                                                                          **
**  Date            : 10 March 2019 19:32                                                                                   **
**  Programmer Name : Matthew C. Vanderbilt                                                                                 **
**  Description     : Created and applied formatting per CHIS data dictionary.                                              **
**                                                                                                                          **
**  Date            : 29 March 2019 14:09                                                                                   **
**  Programmer Name : Matthew C. Vanderbilt                                                                                 **
**  Description     : Completed creation and application of formatting per CHIS data dictionary to common & used variables  **
**                                                                                                                          **
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

/* COMBINE DATA */
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS2013.adult (in=in13)
		CHIS2014.adult (in=in14)
		CHIS2015.adult (in=in15)
		CHIS2016.adult (in=in16)
		CHIS2017.adult (in=in17);

	IF		in13 THEN year=2013;
	ELSE IF in14 THEN year=2014;
	ELSE IF in15 THEN year=2015;
	ELSE IF in16 THEN year=2016;
	ELSE IF in17 THEN year=2017;

	***Create new weight variables;

	fnwgt0 = rakedw0/5;

	ARRAY a_origwgts[80] rakedw1-rakedw80;
	ARRAY a_newwgts[160] fnwgt1-fnwgt160;

	DO i = 1 to 80;
			IF year=2011 THEN DO;
				a_newwgts[i]    = a_origwgts[i]/5;
				a_newwgts[i+80] = rakedw0/5;
    		END;
		    ELSE IF year>2011 then do;
		      a_newwgts[i]    = rakedw0/5;
		      a_newwgts[i+80] = a_origwgts[i]/5;
		    END;
  	END;
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA_RAW VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_RAW';
RUN;

/* SPECIFY CHIS FORMATS */
OPTIONS fmtsearch=(CHIS);

/* CHIS GENERAL FORMATS */
PROC FORMAT LIBRARY=CHIS;
	VALUE fCHISBool		-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Yes'
						2	= 'No'
						;

	VALUE fCHIS4Lichert	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Strongly Agree'
						2	= 'Agree'
						3	= 'Disagree'
						4	= 'Strongly Disagree'
						;

	VALUE fCHIS4LichTim	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'All of the Time'
						2	= 'Most of the Time'
						3	= 'Some of the Time'
						4	= 'None of the Time'
						;

	VALUE fCHIS5LichTim	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'All of the Time'
						2	= 'Most of the Time'
						3	= 'Some of the Time'
						4	= 'A Little of the Time'
						5	= 'Not at All'
						;

	VALUE fCHIS3Truth	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Often True'
						2	= 'Sometimes True'
						3	= 'Never True'
						;

	VALUE fCHIS4Amt		-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'A Lot'
						2	= 'Some'
						3	= 'Not at All'
						4	= 'Does Not Work'
						;

	VALUE fCHIS3Amt		-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'A Lot'
						2	= 'Some'
						3	= 'Not at All'
						;

	VALUE fCHIS3Severit	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						0	= 'None'
						1	= 'Moderate'
						2	= 'Severe'
						;

	VALUE fCHIS3Diffic	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Very Difficult'
						2	= 'Somewhat Difficult'
						3	= 'Not Too Difficult / Not at All Difficult'
						;
RUN;

/* CHIS SECTION A: DEMOGRAPHIC INFORMATION FORMATS */
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

PROC CONTENTS DATA=CHIS.CHIS_DATA_RAW VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_RAW';
RUN;

/* CHIS SECTION B: GENERAL HEALTH CONDITION */
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

/* CHIS SECTION C: HEALTH BEHAVIOURS */
PROC FORMAT LIBRARY=CHIS;
	VALUE fad37w		1	= 'Yes'
						2	= 'No'
						3	= 'Unable to Walk'
						;

	VALUE faesoda_p1z	0	= '0 Times'
						1	= '1 Time'
						2	= '2-3 Times'
						3	= '4-6 Times'
						4	= '7-13 Times'
						5	= '14-20 Times'
						6	= '21+ Times'
						;

	VALUE fac42z		1	= 'Never'
						2	= 'Sometimes'
						3	= 'Usually'
						4	= 'Always'
						5	= 'Doesnt Eat Fruits & Vegetables'
						6	= 'Doesnt Shop for Fruits & Vegetables'
						7	= 'Doesnt Shop in His/Her Neighborhood'
						;

	VALUE fac42_p		1	= 'Never'
						2	= 'Sometimes'
						3	= 'Usually'
						4	= 'Always'
						5	= 'Does Eat/Shop for Fruits & Vegetables'
						;

	VALUE fac44z		-1	= 'Inapplicable'
						1	= 'Never'
						2	= 'Sometimes'
						3	= 'Usually'
						4	= 'Always'
						;

	VALUE fae15a		-1	= 'Inapplicable'
						1	= 'Every Day'
						2	= 'Some Days'
						3	= 'Not at All'
						;

	VALUE fad32_p1z		-1	= 'Inapplicable'
						0	= '0 Cigarettes'
						1	= '1-5 Cigarettes'
						6	= '6-10 Cigarettes'
						11	= '11-15 Cigarettes'
						16	= '16+ Cigarettes'
						;

	VALUE fae16_p1z		-1	= 'Inapplicable'
						0	= '0 Cigarettes'
						1	= '1 Cigarette'
						2	= '2 Cigarettes'
						3	= '3 Cigarettes'
						4	= '4 Cigarettes'
						5	= '5 Cigarettes'
						6	= '6-10 Cigarettes'
						11	= '11+ Cigarettes'
						;

	VALUE fsmkcur		1	= 'Current Smoker'
						2	= 'Not Current Smoker'
						;

	VALUE fsmoking		1	= 'Currently Smokes'
						2	= 'Quit Smoking'
						3	= 'Never Smoked Regularly'
						;

	VALUE fnumcig		1	= 'None'
						2	= '<=1 Cigarette'
						3	= '2-5 Cigarettes'
						4	= '6-10 Cigarettes'
						5	= '11-19 Cigarettes'
						6	= '20 or More'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ad37w		fad37w.;
	FORMAT	ad40w		fCHISBool.;
	FORMAT	aesoda_p1	faesoda_p1z.;
	FORMAT	ac42		fac42z.;
	FORMAT	ac42_p		fac42_p.;
	FORMAT	ac44		fac44z.;
	FORMAT	ae15		fCHISBool.;
	FORMAT	ae15a		fae15a.;
	FORMAT	ad32_p1		fad32_p1z.;
	FORMAT	ae16_p1		fae16_p1z.;
	FORMAT	smkcur		fsmkcur.;
	FORMAT	smoking		fssmoking.;
	FORMAT	numcig		fnumcig.;
	FORMAT	ac49		fCHISBool.;
	FORMAT	ac50		fCHISBool.;
RUN;

/* CHIS SECTION D: GENERAL HEALTH, DISABILITY & SEXUAL HEALTH */
PROC FORMAT LIBRARY=CHIS;
	VALUE	frbmi		1	= 'Underweight 0-18.49'
						2	= 'Normal 18.5-24.99'
						3	= 'Overweight 25.0-29.99'
						4	= 'Obese 30.0+'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	rbmi		frbmi.;
	FORMAT	ovrwt		fCHISBool.;
	FORMAT	ad50		fCHISBool.;
RUN;

/* CHIS SECTION F: MENTAL HEALTH */
PROC FORMAT LIBRARY=CHIS;
	VALUE faj1z			-2	= 'Proxy Skipped'
						-1	= 'Inapplicable'
						1	= 'Yes'
						2	= 'No'
						3	= 'No Insurance'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	aj29		fCHIS5LichTim.;
	FORMAT	aj30		fCHIS5LichTim.;
	FORMAT	aj31		fCHIS5LichTim.;
	FORMAT	aj32		fCHIS5LichTim.;
	FORMAT	aj33		fCHIS5LichTim.;
	FORMAT	aj34		fCHIS5LichTim.;
	FORMAT	dstrs30		fCHISBool.;
	FORMAT	af62		fCHISBool.;
	FORMAT	af63		fCHIS5LichTim.;
	FORMAT	af64		fCHIS5LichTim.;
	FORMAT	af65		fCHIS5LichTim.;
	FORMAT	af66		fCHIS5LichTim.;
	FORMAT	af67		fCHIS5LichTim.;
	FORMAT	af68		fCHIS5LichTim.;
	FORMAT	af69b		fCHIS4Amt.;
	FORMAT	af70b		fCHIS3Amt.;
	FORMAT	af71b		fCHIS3Amt.;
	FORMAT	af72b		fCHIS3Amt.;
	FORMAT	dstrs12		fCHISBool.;
	FORMAT	chores2		fCHIS3Severit.;
	FORMAT	social2		fCHIS3Severit.;
	FORMAT	work2		fCHIS3Severit.;
	FORMAT	family2		fCHIS3Severit.;
	FORMAT	aj1			faj1z.;
RUN;

/* CHIS SECTION G: DEMOGRAPHIC INFORMATION / CHILD CARE */
PROC FORMAT LIBRARY=CHIS;
	VALUE fah3nativity	-1	= 'Inapplicable'
						1	= 'Born in U.S.'
						2	= 'Born Outside U.S.'
						;
	
	VALUE flnghm_p1z	1	= 'English'
						2	= 'Spanish'
						3	= 'Chinese'
						4	= 'Vietnamese'
						5	= 'Korean'
						6	= 'Other One Language Only'
						8	= 'English & Spanish'
						9	= 'English & Chinese'
						10	= 'English & European Language'
						11	= 'English & Another Asian Language'
						12	= 'English & One Other Language'
						13	= 'Other Languages (2+)'
						;

	VALUE fah37z		-1	= 'Inapplicable'
						1	= 'Very Well'
						2	= 'Well'
						3	= 'Not Well'
						4	= 'Not at All'
						;

	VALUE fspk_eng		1	= 'Speak Only English'
						2	= 'Very Well / Well'
						3	= 'Not Well / Not at All'
						;

	VALUE fcitizen		1	= 'US-Born Citizen'
						2	= 'Naturalized Citizen'
						3	= 'Non-Citizen'
						;

	VALUE fyrus_p1z		-1	= 'Inapplicable'
						1	= '<5 Years'
						3	= '5-9 Years'
						4	= '10-14 Years'
						5	= '15-19 Years'
						;

	VALUE fpctlf_p		1	= '0-20'
						2	= '21-40'
						3	= '41-60'
						4	= '61-80'
						5	= '81+'
						;

	VALUE fahedc_p1z	1	= 'None / Primary School'
						2	= 'High School, Partial'
						3	= 'High School, Graduate'
						4	= 'College, Partial'
						5	= 'Vocational School'
						6	= 'Associates Degree'
						7	= 'Bachelors Degree'
						8	= 'Masters Degree'
						9	= 'Doctorate Degree'
						;

	VALUE fag10z		-1	= 'Inapplicable'
						1	= 'Yes'
						2	= 'No'
						3	= 'Looking for Work'
						;

	VALUE fwrkst_p1z	1	= 'Full-Time Employment (21+ hrs/week)'
						2	= 'Part-Time Employment (0-20 hrs/week)'
						3	= 'Other Employed'
						4	= 'Unemployed, Looking for Work'
						5	= 'Unemployed, Not Looking for Work'
						;

	VALUE fserved		-1	= 'Inapplicable'
						1	= '<0.5 Years'
						2	= '0.5 - 2 Years'
						3	= '2 - 4 Years'
						4	= '4 - 20 Years'
						5	= '20+ Years'
						;

	VALUE ffamtyp_p		1	= 'Single Adult, 21+'
						2	= 'Single Young Adult, 19-20'
						3	= 'Married w/o Kids'
						4	= 'Married w/ Kids'
						5	= 'Single w/ Kids'
						6	= 'Single 18 Years Old'
						;

RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ah33new		fah3nativity.;
	FORMAT	ah34new		fah3nativity.;
	FORMAT	ah35new		fah3nativity.;
	FORMAT	lnghm_p1	flnghm_p1z.;
	FORMAT	ah37		fah37z.;
	FORMAT	spk_eng		fspk_eng.;
	FORMAT	citizen2	fcitizen.;
	FORMAT	yrus_p1		fyrus_p1z.;
	FORMAT	pctlf_p		fpctlf_p.;
	FORMAT	ah43a		fCHISBool.;
	FORMAT	ahedc_p1	fahedc_p1z.;
	FORMAT	ag10		fag10z.;
	FORMAT	wrkst_p1	fwrkst_p1z.;
	FORMAT	ag22		fCHISBool.;
	FORMAT	served		fserved.;
	FORMAT	famtyp_p	ffamtyp_p.;
RUN;

/* CHIS SECTION H: HEALTH INSURANCE */
PROC FORMAT LIBRARY=CHIS;
	VALUE	fai15z		-1	= 'Inapplicable'
						1	= 'Covered by Another Plan'
						2	= 'Too Expensive'
						3	= 'Didnt Like Plan Offered'
						4	= 'Dont Need or Believe in Health Insurance'
						5	= 'In Process'
						6	= 'Didnt Take Up - Other'
						7	= 'Receive Extra Pay/Benefits Not to Enroll'
						91	= 'Other'
						;

	VALUE	fai15a		-1	= 'Inapplicable'
						1	= 'Havent Worked Here Long Enough'
						2	= 'Contract or Temp Employee'
						3	= 'Didnt Work Enough Hours per Week'
						4	= 'Does Not Meet Age Requirements'
						5	= 'Only Management Can Get Health Insurance'
						6	= 'Not Eligible - Other'
						7	= 'Has Left Position / Retired / Laid Off'
						91	= 'Other'
						;

	VALUE	fai22a_p	-8	= 'Dont Know'
						-1	= 'Inapplicable'
						1	= 'Kaiser'
						2	= 'Blue Cross'
						3	= 'United Healthcare'
						4	= 'Blue Shield'
						5	= 'Health Net'
						6	= 'Aetna'
						7	= 'Cigna Health Care'
						8	= 'Other'
						;

	VALUE	fhmo		1	= 'HMO'
						2	= 'Non-HMO'
						3	= 'Uninsured'
						;

	VALUE	fai28z		-1	= 'Inapplicable'
						1	= '1 to 3 Yrs Ago'
						2	= 'More than 3 Yrs Ago'
						3	= 'Never Had Health Insurance Coverage'
						;

	VALUE	fah101_p	-1	= 'Inapplicable'
						1	= 'Broker'
						2	= 'Family Member / Friend'
						3	= 'Internet'
						4	= 'Other / Multiple Reasons'
						;

	VALUE	funinsany	-1	= 'Skipped - Ages>=65'
						1	= 'Uninsured All Year'
						2	= 'Uninsured Part Year'
						3	= 'Insured All Year'
						;

	VALUE	fins64_p	-1	= 'Skipped - Age >= 65'
						1	= 'Uninsured'
						2	= 'Medi-Cal (Medicaid)'
						3	= 'Medicare'
						4	= 'Employment-Based'
						5	= 'Privately Purchased'
						6	= 'Chip/Other Public Prgm'
						;

	VALUE	finsany		1	= 'Currently Uninsured'
						2	= 'Unins. Any Past 12 mo'
						3	= 'Insured All Past 12 mo'
						;

	VALUE	finst_12z	-1	= 'Inapplicable-age>=65'
						1	= 'Medi-Cal (Medicaid) Only'
						2	= 'Employer-Based Coverage Only (EBI)'
						3	= 'Private Coverage Only'
						4	= 'Other Coverage Only'
						5	= 'Any 2 or More Types (Never Uninsured)'
						6	= 'Uninsured Only'
						7	= 'Uninsured + Employer-Based Only'
						8	= 'Any 1 or More Types + Uninsured'
						;

	VALUE	fins65z		-1	= 'Skipped - Age < 65'
						1	= 'Medicare + Medi-Cal (Medicaid)'
						2	= 'Medicare + Other'
						3	= 'Medicare Only'
						4	= 'Other Only'
						5	= 'Uninsured'
						;

	VALUE	finsps		-1	= 'Inapplicable'
						1	= 'Primary'
						2	= 'Secondary'
						3	= 'Not Specified as Primary or Secondary'
						;

	VALUE	fofftk		-1	= 'Unemployed or Self-Employed'
						1	= 'Accepted EBI'
						2	= 'Not Accepted EBI, Offered & Eligible'
						3	= 'Was Offered EBI, Not Eligible'
						4	= 'Was Not Offered EBI'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ai4			fCHISBool.;
	FORMAT	ah100		fCHISBool.;
	FORMAT	ah103		fCHISBool.;
	FORMAT	ai15		fai15z.;
	FORMAT	ai15a		fai15a.;
	FORMAT	ai22c		fCHISBool.;
	FORMAT	ai25new		fCHISBool.;
	FORMAT	ai25		fCHISBool.;
	FORMAT	ai22a_p		fai22a_p.;
	FORMAT	hmo			fhmo.;
	FORMAT	ah71_p1		fCHISBool.;
	FORMAT	ah72_p1		fCHISBool.;
	FORMAT	ah73B		fCHISBool.;
	FORMAT	ah74		fCHISBool.;
	FORMAT	ah75		fCHISBool.;
	FORMAT	ai28		fai28z.;
	FORMAT	ah14		fCHISBool.;
	FORMAT	ah101_p		fah101_p.;
	FORMAT	ah98_p1		fCHIS3Diffic.;
	FORMAT	ah99_p1		fCHIS3Diffic.;
	FORMAT	ins			FCHISBool.;
	FORMAT	uninsany	funinsany.;
	FORMAT	ins64_p		fins64_p.;
	FORMAT	insany		finsany.;
	FORMAT	inst_12		finst_12z.;
	FORMAT	ins65		fins65z.;
	FORMAT	insem		fCHISBool.;
	FORMAT	insmc		fCHISBool.;
	FORMAT	insmd		fCHISBool.;
	FORMAT	insog		fCHISBool.;
	FORMAT	inspr		fCHISBool.;
	FORMAT	insps		finsps.;
	FORMAT	offtk		fofftk.;
RUN;

/* CHIS SECTION J: HEALTH CARE UTILIZATION / ACCESS & DENTAL HEALTH */
PROC FORMAT LIBRARY=CHIS;
	VALUE	fah1z		1	= 'Yes'
						2	= 'No'
						3	= 'Doctor / My Doctor'
						4	= 'Kaiser'
						5	= 'More than One Place'
						;

	VALUE	fah3_p1z	-1	= 'Inapplicable'
						1	= 'Doctors Office / Kasier / HMO'
						2	= 'Clinic / Health Center / Hospital Clinic'
						3	= 'Emergency Room'
						4	= 'Some Other Place / No One Particular Place'
						;

	VALUE	fusual_tp	1	= 'Doctors Office / Kaiser / HMO'
						2	= 'Commun/Gov Clin, Commun Hosp'
						3	= 'Emergency Room'
						5	= 'Some Other Place'
						6	= 'No One Particular Place'
						7	= 'No Usual Source of Care'
						;

	VALUE	fusual5tp	1	= 'Doctors Office / Kaiser / HMO'
						2	= 'Commun/Gov Clin, Commun Hosp'
						3	= 'Emergency Room / Urgent Care'
						4	= 'Some Other Place / No One Particular Place'
						5	= 'No Usual Source of Care'
						;

	VALUE	fah6z		-1	= 'Inapplicable'
						0	= 'Within the Past Yr'
						1	= '1 to 2 Yrs Ago'
						2	= '2 to 5 Yrs Ago'
						3	= 'More than 5 Yrs Ago'
						4	= 'Never'
						;

	VALUE	facmdnum	0	= '0 Times'
						1	= '1 Time'
						2	= '2 Times'
						3	= '3 Times'
						4	= '4 Times'
						5	= '5 Times'
						6	= '6 Times'
						7	= '7-8 Times'
						8	= '9-12 Times'
						9	= '13-24 Times'
						10	= '25+ Times'
						;

	VALUE	faj103z		-1	= 'Inapplicable'
						1	= 'Never'
						2	= 'Sometimes'
						3	= 'Usually'
						4	= 'Always'
						;

	VALUE	faj114z		-1	= 'Inapplicable'
						0	= 'One Year Ago or Less'
						1	= '1 to 2 Years Ago'
						2	= '2 to 5 Years Ago'
						3	= 'More than 5 Years Ago'
						4	= 'Never'
						;

	VALUE	faj131_p1z	-1	= 'Inapplicable'
						1	= 'Couldnt Get Appointment'
						2	= 'Cost, Insurance (Not Covrd/Accptd, No Ins)'
						5	= 'Transportation Problems'
						6	= 'Hours Not Convenient'
						9	= 'I Didnt Have Time'
						12	= 'Did Not Think Serious Enough/Needed'
						13	= 'Not Satisfied with Health Care Received'
						14	= 'Other Reason'
						15	= 'Anxiety, Fear, Avoidance of Medical Care'
						;

	VALUE	frn_forgo	-1	= 'Inapplicable'
						1	= 'Cost'
						2	= 'Couldnt Get Appointment'
						3	= 'Didnt Have Time'
						4	= 'Others'
						;

	VALUE	fah95_p1z	-1	= 'Inapplicable'
						0	= '0 Times'
						1	= '1 Time'
						2	= '2 Times'
						3	= '3 Times'
						4	= '4 Times'
						5	= '5+ Times'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ah1			fah1z.;
	FORMAT	ah3_p1		fah3_p1z.;
	FORMAT	usoc		fCHISBool.;
	FORMAT	usual		fCHISBool.;
	FORMAT	usual_tp	fusual_tp.;
	FORMAT	usual5tp	fusual5tp.;
	FORMAT	ah6			fah6z.;
	FORMAT	acmdnum		facmdnum.;
	FORMAT	doct_yr		fCHISBool.;
	FORMAT	aj77		fCHISBool.;
	FORMAT	aj9			fCHISBool.;
	FORMAT	aj10		fCHISBool.;
	FORMAT	ah16		fCHISBool.;
	FORMAT	aj19		fCHISBool.;
	FORMAT	ah22		fCHISBool.;
	FORMAT	aj20		fCHISBool.;
	FORMAT	aj102		fCHISBool.;
	FORMAT	aj103		faj103z.;
	FORMAT	timappt		fCHISBool.;
	FORMAT	aj105		fCHISBool.;
	FORMAT	aj106		fCHISBool.;
	FORMAT	aj107		fCHISBool.;
	FORMAT	aj114		faj114z.;
	FORMAT	aj129		fCHISBool.;
	FORMAT	aj131_p1	faj131_p1z.;
	FORMAT	care_pv		fCHISBool.;
	FORMAT	rn_forgo	frn_forgo.;
	FORMAT	forgo		fCHISBool.;
	FORMAT	aj136		fCHISBool.;
	FORMAT	aj137		fCHISBool.;
	FORMAT	aj138		fCHISBool.;
	FORMAT	aj139		fCHISBool.;
	FORMAT	aj133		fCHISBool.;
	FORMAT	aj134		fCHISBool.;
	FORMAT	aj135		fCHISBool.;
	FORMAT	pc_ins		fCHISBool.;
	FORMAT	pc_newp		fCHISBool.;
	FORMAT	sc_ins		fCHISBool.;
	FORMAT	sc_newp		fCHISBool.;
	FORMAT	ah95_p1		fah95_p1z.;
	FORMAT	er			fCHISBool.;
RUN;

/* CHIS SECTION K: EMPLOYMENT, INCOME, POVERTY STATUS & FOOD SECURITY */
PROC FORMAT LIBRARY=CHIS;
	VALUE	fak1z		1	= 'Working at a Job/Business'
						2	= 'With a Job/Business but Not at Work'
						3	= 'Looking for Work'
						4	= 'Not Working Job / Business (Unemp)'
						;

	VALUE	fak2_p1z	-1	= 'Inapplicable'
						2	= 'On Planned Vacation'
						3	= 'Couldnt Find a Job'
						4	= 'Going to School / Sudent'
						5	= 'Retired'
						6	= 'Physical Disability'
						7	= 'Unable to Work Temporarily'
						8	= 'On Layoff or Strike'
						10	= 'Off Season'
						11	= 'Sick'
						91	= 'Other'
						;

	VALUE	fak4z		-1	= 'Inapplicable'
						1	= 'Private Company, Non-Profit Org'
						2	= 'Government'
						3	= 'Self-Employed'
						4	= 'Family Business or Farm'
						;

	VALUE	findmain2z	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-1	= 'Inapplicable'
						1	= 'Agriculture, Forestry, Fishing, Hunting'
						2	= 'Construction'
						3	= 'Manufacturing'
						4	= 'Wholesale Trace'
						5	= 'Retail Trade'
						6	= 'Transportation, Warehousing, and Utilities'
						7	= 'Information'
						8	= 'Finance and Insurance, Real Estate, Rent'
						9	= 'Professional, Scientific, Management'
						10	= 'Educational Services, Healthcare and So'
						11	= 'Arts, Entertainment, Recreation, Acommo'
						12	= 'Other Services, Except Public Administration'
						13	= 'Public Administration'
						14	= 'Military'
						99	= 'Could Not be Coded'
						;

	VALUE	foccmain2z	-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						-1	= 'Inapplicable'
						1	= 'Management, Busi8ness, and Financial Occu'
						2	= 'Computer, Engineering, and Science Occup'
						3	= 'Education, Legal, Communityu Service, Art'
						4	= 'Healthcare Practitioners & Technical O'
						5	= 'Services Occupations'
						6	= 'Sales & Realted Occupations'
						7	= 'Office & Administrative Support Occupa'
						8	= 'Farming, Fishing, & Forestry Occupatio'
						9	= 'Construction & Extraction Occupations'
						10	= 'Installation, Maintenance, & Repair Oc'
						11	= 'Production Occupations'
						12	= 'Transportation & Material Moving Occup'
						13	= 'Military Specific Occupations'
						99	= 'Could Not be Coded'
						;

	VALUE	fakwklngz	-1	= 'Inapplicable'
						0	= '<1 Year'
						1	= '1 Year'
						2	= '2 Years'
						3	= '3 Years'
						4	= '4 Years'
						5	= '5 Years'
						6	= '6-9 Years'
						7	= '10-14 Years'
						8	= '15-19 Years'
						9	= '20-29 Years'
						10	= '30+ Years'
						;

	VALUE	fak8z		-1	= 'Inapplicable'
						1	= '1 or 2'
						2	= '3 - 9'
						3	= '10 - 24'
						4	= '25 - 50'
						5	= '51 - 100'
						6	= '101 - 200'
						7	= '201 - 999'
						8	= '1,000 or More'
						;

	VALUE	fak33_p1z	-1	= 'Inapplicable'
						1	= '1'
						2	= '2'
						3	= '3'
						;
	VALUE	fam3az		-1	= 'Inapplicable'
						1	= 'Almost Every Month'
						2	= 'Some Months but Not Every month'
						3	= 'Only in 1 or 2 Months'
						;

	VALUE	ffslev		-1	= 'Inapplicable / >=200% FPL'
						1	= 'Food Security'
						2	= 'Food Insecurity w/o Hunger'
						3	= 'Food Insecurity w/ Hunger'
						;

	VALUE	ffpg		1	= 'FPG 0 - 138'
						2 	= 'FPG 139 - 200'
						3	= 'FPG 201 - 400'
						4	= 'FPG 400+'
						;
	
	VALUE	fpovll_aca	1	= '0-138% FPL'
						2	= '139%-249% FPL'
						3	= '250%-399% FPL'
						4	= '400%+ FPL'
						;

	VALUE	fpovll		1	= '0-99% FPL'
						2	= '100-199% FPL'
						3	= '200-299% FPL'
						4	= '300% FPL and Above'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ak1			fak1z.;
	FORMAT	ak2_p1		fak2_p1z.;
	FORMAT	ak4			fak4z.;
	FORMAT	indmain2	findmain2z.;
	FORMAT	occmain2	foccmain2z.;
	FORMAT	akwklng		fakwklngz.;
	FORMAT	ak8			fak8z.;
	FORMAT	ak32		fCHISBool.;
	FORMAT	ak33_p1		fak33_p1z.;
	FORMAT	am1			fCHIS3Truth.;
	FORMAT	am2			fCHIS3Truth.;
	FORMAT	am3			fCHISBool.;
	FORMAT	am3a		fam3az.;
	FORMAT	am4			fCHISBool.;
	FORMAT	am5			fCHISBool.;
	FORMAT	fslev		ffslev.;
	FORMAT	fpg			ffpg.;
	FORMAT	povll_aca	fpovll_aca.;
	FORMAT	povll		fpovll.;
RUN;

/* CHIS SECTION L: PUBLIC PROGRAM PARETICIPATION */
DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	al2			fCHISBool.;
	FORMAT	al5			fCHISBool.;
	FORMAT	al6			fCHISBool.;
	FORMAT	al22		fCHISBool.;
	FORMAT	al32		fCHISBool.;
	FORMAT	al18a		fCHISBool.;
RUN;

/* CHIS SECTION M: HOUSING & COMMUNITY INVOLVEMENT */
PROC FORMAT LIBRARY=CHIS;
	VALUE	fak23z		1	= 'House'
						2	= 'Duplex'
						3	= 'Building with 3 or More Units'
						4	= 'Mobile Home'
						;

	VALUE	fak25z		-9	= 'Not Ascertained'
						-8	= 'Dont Know'
						-7	= 'Refused'
						1	= 'Own'
						2	= 'Rent'
						3	= 'Other Arrangement'
						;

RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	ak23		fak23z.;
	FORMAT	ak25		fak25z.;	
	FORMAT	am19		fCHIS4Lichert.;
	FORMAT	am20		fCHIS4Lichert.;
	FORMAT	am21		fCHIS4Lichert.;
	FORMAT	ak28		fCHIS4LichTim.;
	FORMAT	am36		fCHISBool.;
RUN;


/* CHIS SECTION N: DEMOGRAPHIC INFORMATION / GEOGRAPHIC INFORMATION */
PROC FORMAT LIBRARY=CHIS;
	VALUE fam34z		-8	= 'Dont Know'
						-7	= 'Refused'
						-1	= 'Inapplicable'
						1	= 'All or Almost All Calls on Cell Phones'
						2	= 'Some Calls on Cell, Some Regular Phones'
						3	= 'Very Few or No Calls on Cell Phones'
						;

	VALUE fur_clrt2z		-1	= 'Inapplicable'
						1	= 'Urban'
						2	= 'Rural'
						;

	VALUE fur_clrt6z	-1	= 'Inapplicable'
						1	= 'Urban'
						2	= '2nd City'
						3	= 'Mixed'
						4	= 'Suburban'
						5	= 'Town'
						6	= 'Rural'
						;

	VALUE fur_clrt4z	-1	= 'Inapplicable'
						1	= 'Urban'
						2	= '2nd City'
						3	= 'Suburban'
						4	= 'Town & Rural'
						;
RUN;

DATA CHIS.CHIS_DATA_RAW;
	SET CHIS.CHIS_DATA_RAW;
	FORMAT	am34		fam34z.;
	FORMAT	ur_clrt2	fur_clrt2z.;
	FORMAT	ur_ihs		fur_clrt2z.;
	FORMAT	ur_omb		fur_clrt2z.;
	FORMAT	ur_rhp		fur_clrt2z.;
	FORMAT	ur_bg6		fur_clrt6z.;
	FORMAT	ur_clrt6	fur_clrt6z.;
	FORMAT	ur_tract6	fur_clrt6z.;

	FORMAT	ur_clrt		fur_clrt4z.;
RUN;	

/* CHIS SECTION Q: SCREENING INFORMATION */
PROC FORMAT LIBRARY=CHIS;
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

/* CHIS.CHIS_DATA_RAW CONTENTS */
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

