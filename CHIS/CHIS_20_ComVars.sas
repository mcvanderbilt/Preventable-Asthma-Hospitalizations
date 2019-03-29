%LET _CLIENTTASKLABEL='CHIS_20_ComVars';
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
**																															**
*****************************************************************************************************************************/

ODS GRAPHICS ON;

/* MASTER LIBRARY */
%LET localProjectPath = %SYSFUNC(SUBSTR(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH)), 1, %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTPATH))) - %LENGTH(%SYSFUNC(DEQUOTE(&_CLIENTPROJECTNAME))) ));
LIBNAME CHIS "&localProjectPath";

/* MINIMIZE TO CROSS-YEAR COMMON VARIABLES */
DATA CHIS.CHIS_DATA_INTRM(	KEEP =	
							MARIT2
							RACEDF_P1
							SRAGE_P1
							SRSEX
							AB1
							AB112
							AB114_P1
							AB118
							AB17
							AB22
							AB23_P1
							AB24
							AB25
							AB28_P1
							AB29
							AB30
							AB34
							AB40
							AB41
							AB42_P1
							AB43
							AB51_P1
							AB52
							AB63
							AB98
							AB99
							ASTCUR
							AC42
							AC42_P
							AC44
							AC49
							AC50
							AD32_P1
							AD37W
							AD40W
							AD41W
							AD42W
							AE_SODA
							AE15
							AE15A
							AE16_P1
							AESODA_P1
							NUMCIG
							SMKCUR
							SMOKING
							AD50
							BMI_P
							HGHTI_P
							HGHTM_P
							OVRWT
							RBMI
							WGHTK_P
							WGHTP_P
							AF62
							AF63
							AF64
							AF65
							AF66
							AF67
							AF68
							AF69B
							AF70B
							AF71B
							AF72B
							AJ1
							AJ29
							AJ30
							AJ31
							AJ32
							AJ33
							AJ34
							CHORES2
							DISTRESS
							DSTRS_P1
							DSTRS12
							DSTRS30
							DSTRSYR
							FAMILY2
							SOCIAL2
							WORK2
							AG10
							AG22
							AH33NEW
							AH34NEW
							AH35NEW
							AH37
							AH43A
							AHEDC_P1
							CITIZEN2
							FAMSIZE2_P1
							FAMTYP_P
							LNGHM_P1
							PCTLF_P
							SERVED
							SPK_ENG
							WRKST_P1
							YRUS_P1
							AH100
							AH101_P
							AH103
							AH14
							AH71_P1
							AH72_P1
							AH73B
							AH74
							AH75
							AH98_P1
							AH99_P1
							AI15
							AI15A
							AI22A_P
							AI22C
							AI25
							AI25NEW
							AI28
							AI4
							HMO
							INS
							INS12M
							INS64_P
							INS65
							INSANY
							INSEM
							INSMC
							INSMD
							INSOG
							INSPR
							INSPS
							INST_12
							OFFTK
							UNINSANY
							ACMDNUM
							AH1
							AH16
							AH22
							AH3_P1
							AH6
							AH95_P1
							AJ10
							AJ102
							AJ103
							AJ105
							AJ106
							AJ107
							AJ114
							AJ129
							AJ131_P1
							AJ133
							AJ134
							AJ135
							AJ136
							AJ137
							AJ138
							AJ139
							AJ19
							AJ20
							AJ77
							AJ9
							CARE_PV
							DOCT_YR
							ER
							FORGO
							PC_INS
							PC_NEWP
							RN_FORGO
							SC_INS
							SC_NEWP
							TIMAPPT
							USOC
							USUAL
							USUAL_TP
							USUAL5TP
							AK1
							AK10_P
							AK10A_P
							AK2_P1
							AK32
							AK33_P1
							AK4
							AK8
							AKWKLNG
							AM1
							AM2
							AM3
							AM3A
							AM4
							AM5
							FPG
							FSLEV
							INDMAIN2
							OCCMAIN2
							POVLL
							POVLL_ACA
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
							UR_CLRT2
							HHSIZE_P1
							RAKEDW0-RAKEDW80
							year
							i
							fnwgt0-fnwgt160
							ur_clrt
							ur_clrt6
						);
	SET CHIS.CHIS_DATA_RAW (WHERE =	(year>=2013));
RUN;

 /* NORMALIZATION OF [UR_CLRT6] to [UR_CLRT] */
DATA CHIS.CHIS_DATA_INTRM;
	SET CHIS.CHIS_DATA_INTRM;

	IF year		= 2017	THEN 
		DO;
			IF ur_clrt6	= 1		THEN town_type = 1;
			IF ur_clrt6	= 2		THEN town_type = 2;
			IF ur_clrt6	= 3		THEN town_type = 2;
			IF ur_clrt6	= 4		THEN town_type = 3;
			IF ur_clrt6	= 5		THEN town_type = 4;
			IF ur_clrt6	= 6		THEN town_type = 4;
		END;
	ELSE town_type = ur_clrt;

	FORMAT	town_type	fur_clrt.;
	LABEL	town_type	= 'RURAL AND URBAN - CLARITAS (BY ZIPCODE) (4 LVLS)';

RUN;

/* CHECK RECODING OF UR_CLRT6 AND UR_CLRT */
PROC FREQ DATA=CHIS.CHIS_DATA_INTRM;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_INTRM';
	TABLES	ur_clrt
			ur_clrt6
			town_type
			ur_clrt*town_type
			ur_clrt6*town_type
			;

RUN;

/* DROP UNNEEDED UR_CLRT6 */
DATA CHIS.CHIS_DATA_INTRM (DROP=ur_clrt ur_clrt6 i rakedw0-rakedw80);
	SET CHIS.CHIS_DATA_INTRM;
RUN;

PROC CONTENTS DATA=CHIS.CHIS_DATA_INTRM VARNUM;
	TITLE 'PROC CONTENTS - CHIS.CHIS_DATA_INTRM';
RUN;

/* EVALUATE INTERIM TABLE */
PROC FREQ DATA=CHIS.CHIS_DATA_INTRM;
	TITLE 'PROC FREQ - CHIS.CHIS_DATA_INTRM';
	TABLES	MARIT2
			RACEDF_P1
			SRAGE_P1
			SRSEX
			AB1
			AB112
			AB114_P1
			AB118
			AB17
			AB22
			AB23_P1
			AB24
			AB25
			AB28_P1
			AB29
			AB30
			AB34
			AB40
			AB41
			AB42_P1
			AB43
			AB51_P1
			AB52
			AB63
			AB98
			AB99
			ASTCUR
			AC42
			AC42_P
			AC44
			AC49
			AC50
			AD32_P1
			AD37W
			AD40W
			AE15
			AE15A
			AE16_P1
			AESODA_P1
			NUMCIG
			SMKCUR
			SMOKING
			AD50
			OVRWT
			RBMI
			AF62
			AF63
			AF64
			AF65
			AF66
			AF67
			AF68
			AF69B
			AF70B
			AF71B
			AF72B
			AJ1
			AJ29
			AJ30
			AJ31
			AJ32
			AJ33
			AJ34
			CHORES2
			DSTRS12
			DSTRS30
			FAMILY2
			SOCIAL2
			WORK2
			AG10
			AG22
			AH33NEW
			AH34NEW
			AH35NEW
			AH37
			AH43A
			AHEDC_P1
			CITIZEN2
			FAMTYP_P
			LNGHM_P1
			PCTLF_P
			SERVED
			SPK_ENG
			WRKST_P1
			YRUS_P1
			AH100
			AH101_P
			AH103
			AH14
			AH71_P1
			AH72_P1
			AH73B
			AH74
			AH75
			AH98_P1
			AH99_P1
			AI15
			AI15A
			AI22A_P
			AI22C
			AI25
			AI25NEW
			AI28
			AI4
			HMO
			INS
			INS64_P
			INS65
			INSANY
			INSEM
			INSMC
			INSMD
			INSOG
			INSPR
			INSPS
			INST_12
			OFFTK
			UNINSANY
			ACMDNUM
			AH1
			AH16
			AH22
			AH3_P1
			AH6
			AH95_P1
			AJ10
			AJ102
			AJ103
			AJ105
			AJ106
			AJ107
			AJ114
			AJ129
			AJ131_P1
			AJ133
			AJ134
			AJ135
			AJ136
			AJ137
			AJ138
			AJ139
			AJ19
			AJ20
			AJ77
			AJ9
			CARE_PV
			DOCT_YR
			ER
			FORGO
			PC_INS
			PC_NEWP
			RN_FORGO
			SC_INS
			SC_NEWP
			TIMAPPT
			USOC
			USUAL
			USUAL_TP
			USUAL5TP
			AK1
			AK2_P1
			AK32
			AK33_P1
			AK4
			AK8
			AKWKLNG
			AM1
			AM2
			AM3
			AM3A
			AM4
			AM5
			FPG
			FSLEV
			INDMAIN2
			OCCMAIN2
			POVLL
			POVLL_ACA
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
			UR_CLRT2
			town_type
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

