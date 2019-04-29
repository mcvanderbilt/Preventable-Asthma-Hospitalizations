# Targeting Reduced Asthma Hospitalizations through Geospatial Statistics
## Secondary Research of Preventable Asthma Hospitalizations
#### A Thesis Submitted to the Graduate Faculty of the National University, Schools of Businesss & Management and Engineering & Computing in partial fulfillment of the requirements for the degree of Masters of Science in Business Analytics

Prepared by **Matthew C. Vanderbilt**  
MSBA Candidate & NU Scholar, National University  
Director of Fiscal Affairs, Department of Medicine, UC San Diego School of Medicine  
[MatthewVanderbilt.com](https://matthewvanderbilt.com) | [GitHub](https://github.com/mcvanderbilt) | [LinkedIn](https://linkedin.com/in/vanderbilt)

*See [Project Wiki](https://github.com/mcvanderbilt/Preventable-Asthma-Hospitalizations/wiki) for complete details.*

## License
This code is licensed under GNU General Public License Version 3 - see the [LICENSE.md](LICENSE.md) file for details.

## SAS Code Execution
### 1. [Load Data](CHIS_10_LoadData.sas)
* [PROC CONTENTS - 2011](CHIS_10_LoadData_PROC_CONTENTS-2011.pdf)
* [PROC CONTENTS - 2012](CHIS_10_LoadData_PROC_CONTENTS-2012.pdf)
* [PROC CONTENTS - 2013](CHIS_10_LoadData_PROC_CONTENTS-2013.pdf)
* [PROC CONTENTS - 2014](CHIS_10_LoadData_PROC_CONTENTS-2014.pdf)
* [PROC CONTENTS - 2015](CHIS_10_LoadData_PROC_CONTENTS-2015.pdf)
* [PROC CONTENTS - 2016](CHIS_10_LoadData_PROC_CONTENTS-2016.pdf)
* [PROC CONTENTS - 2011 - 2016](CHIS_10_LoadData_PROC-CONTENTS.pdf)

### 2. [Review Psychological Distress Scale](CHIS_11_DSTRSYR.sas)
* [PROC FREQ](CHIS_11_DSTRSYR_PROC-FREQ.pdf)

### 3. [Recode & Normalize Variables](CHIS/CHIS_15_Recoding.sas)
* [PROC CONTENTS](CHIS_15_Recoding_PROC-CONTENTS.pdf)
* [PROC FREQ](CHIS_15_Recoding_PROC-FREQ.pdf)

### 4. [Restrict Data to Common Survey Variables](CHIS/CHIS_20_ComVars.sas)
* [PROC CONTENTS](CHIS_20_ComVars_PROC-CONTENTS.pdf)

### 5. [Create Final Table for Analysis](CHIS/CHIS_30_FinalData.sas)
* [PROC CONTENTS](CHIS_30_FinalData_PROC-CONTENTS.pdf)

### 6. [Create Subset Table for Decision Tree Analysis](CHIS/CHIS_35_MinerDS.sas)
* [PROC CONTENTS - All Asthma Classifications](CHIS_35_MinerDS_PROC-CONTENTS-EM-All.pdf)
* [PROC CONTENTS - Current Asthmatics](CHIS_35_MinerDS_PROC-CONTENTS-EM-CurrAsth.pdf)

7. [Investigate Subject Characteristics](CHIS/CHIS_40_SubjectChar.sas)
8. [Investigate Subject Asthma Characteristics](CHIS/CHIS_45_AsthmaChar.sas)
9. [Investigate Weighted Survey Population Frequencies](CHIS/CHIS_50_EDA.sas)
10. [Perform Total Variable Correlation](CHIS/CHIS_55_Corr.sas)
11. [Perform Multinomial Logistic Regression](CHIS/CHIS_60_Regression.sas)
12. [Investigate Links between Healthy Food Accesss with Poverty and Descriptive BMI](CHIS/CHIS_61_PovFood.sas)
13. [Perform Binomial Logistic Regression](CHIS/CHIS_70_BinomRegress.sas)
14. [Perform Adjusted Binomial Logistic Regression](CHIS/CHIS_71_BinomRegress.sas)
15. [Perform Inverted Binomial Logistic Regression](CHIS/CHIS_72_BinomRegress.sas)
16. [Perform Adjusted Binomial Logistic Regression](CHIS/CHIS_73_BinomRegress.sas)
17. [Perform Final Binomial Logistic Regression](CHIS/CHIS_74_BinomRegress.sas)
18. [Perform Binomial Logistic Regression of Asthma Exacerbation](CHIS/CHIS_80_Exacerbations)
19. [Perform Final Binomial Logistic Regression of Asthma Exacerbation](CHIS/CHIS_81_Exacerbations)
