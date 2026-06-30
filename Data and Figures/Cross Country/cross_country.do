******************************************************************************
* Technology Overload? Macroeconomic Implications of Accelerated Obsolescence
******************************************************************************

******************************************************************************
*                          CROSS-COUNTRY LABOR SHARE
******************************************************************************

clear

global ccc_dir "\Data and Figures\Yeni klasör\Cross_Country"
cd "$ccc_dir"

*-----------------------------------------------------------------------------*
* US GDP deflator
*-----------------------------------------------------------------------------*
import excel "$ccc_dir\GDPDEF_US.xlsx", sheet("Annual") firstrow clear
drop observation_date
save GDPDEF_US, replace

*-----------------------------------------------------------------------------*
* Real GDP (UN), with country codes
*-----------------------------------------------------------------------------*
import excel "$ccc_dir\real_GDP_UN.xlsx", sheet("Results") firstrow clear
rename GDPatconstant2015pricesU real_gdp
rename CountryArea           country
rename Year                  year
drop Unit
destring real_gdp, replace
destring year,     replace
replace country = "United Kingdom" if country == "United Kingdom of Great Britain and Northern Ireland"
replace country = "Korea"          if country == "Republic of Korea"

gen countrycode = ""
replace countrycode = "AUS" if country == "Australia"
replace countrycode = "AUT" if country == "Austria"
replace countrycode = "BEL" if country == "Belgium"
replace countrycode = "CAN" if country == "Canada"
replace countrycode = "FIN" if country == "Finland"
replace countrycode = "FRA" if country == "France"
replace countrycode = "DEU" if country == "Germany"
replace countrycode = "IRL" if country == "Ireland"
replace countrycode = "ITA" if country == "Italy"
replace countrycode = "JPN" if country == "Japan"
replace countrycode = "KOR" if country == "Korea"
replace countrycode = "NLD" if country == "Netherlands"
replace countrycode = "NZL" if country == "New Zealand"
replace countrycode = "NOR" if country == "Norway"
replace countrycode = "PRT" if country == "Portugal"
replace countrycode = "ESP" if country == "Spain"
replace countrycode = "SWE" if country == "Sweden"
replace countrycode = "CHE" if country == "Switzerland"
replace countrycode = "GBR" if country == "United Kingdom"
replace countrycode = "USA" if country == "United States"
save real_gdp, replace

*-----------------------------------------------------------------------------*
* Exchange rates, merged with US deflator
*-----------------------------------------------------------------------------*
import excel "$ccc_dir\exchange_rates.xlsx", sheet("Results") firstrow clear
rename CountryArea            country
rename Year                   year
rename IMFbasedexchangerate   exchange
rename AMAexchangerate        exchange2
keep year country exchange exchange2
destring exchange,  replace
destring exchange2, replace
destring year,      replace
save exhange_rate, replace

merge m:1 year using GDPDEF_US
keep if _merge == 3
drop _merge
keep country year exchange GDPDEF exchange2
replace country = "United Kingdom" if country == "United Kingdom of Great Britain and Northern Ireland"
replace country = "Korea"          if country == "Republic of Korea"
save variables_deflator, replace

*-----------------------------------------------------------------------------*
* Labor share components (UN, business sector)
*-----------------------------------------------------------------------------*
import excel "$ccc_dir\UN_for_laborsh_val_business.xlsx", sheet("Sheet1") firstrow clear
keep REF_AREA Referencearea Economicactivity Measure OBS_VALUE TIME_PERIOD
rename Economicactivity activity
rename OBS_VALUE        value
rename TIME_PERIOD      year
rename REF_AREA         countrycode
rename Referencearea    country
rename Measure          measure
save raw_value, replace

*--- Split out each measure into its own file ---
preserve
keep if measure == "Value added at factor costs"
keep countrycode country year measure value
rename value val_total_cost
drop measure
save value_added_cost_total, replace
restore

preserve
keep if measure == "Gross operating surplus and mixed income"
keep countrycode country year measure value
rename value mixed_income
drop measure
save mixed_income, replace
restore

preserve
keep if measure == "Compensation of employees"
keep countrycode country year measure value
rename value comp
drop measure
save comp, replace
restore

preserve
keep if measure == "Value added"
keep countrycode country year measure value
rename value val_total
drop measure
save value_added_total, replace
restore

*-----------------------------------------------------------------------------*
* Assemble the analysis dataset
*-----------------------------------------------------------------------------*
use value_added_total, replace
merge m:1 countrycode year using value_added_cost_total
drop _merge
merge m:1 countrycode year using comp
drop _merge
merge m:1 countrycode year using mixed_income
drop _merge
merge m:1 country year using variables_deflator
keep if _merge == 3
drop _merge
merge 1:1 country year using real_gdp
keep if _merge == 3
drop _merge
merge 1:1 countrycode year using country_gdp
keep if _merge == 3
drop _merge
* Drop countries with insufficient temporal coverage for the 1980-2019 sample (optional)
drop if countrycode == "PRT" | countrycode == "NOR" | countrycode == "IRL" | countrycode == "NZL"

merge 1:1 countrycode year using mixed_income_PWT_adjustment
keep if _merge == 3
drop _merge

merge 1:1 countrycode year using mixed_income_PWT
keep if _merge == 3
drop _merge

*-----------------------------------------------------------------------------*
* Construct labor share measures
*-----------------------------------------------------------------------------*
egen cc = group(country)
xtset cc year
gen adj_mixed_total  = (0.10 * 0.67) * val_total_cost
gen labor_share2     = (comp + adj_mixed_total) / val_total_cost
gen labor_share1     = lab_sh1
gen real_value_added = (val_total_cost / exchange)
replace real_value_added = (real_value_added / GDPDEF)

*-----------------------------------------------------------------------------*
* Compute year effects
*-----------------------------------------------------------------------------*
drop if year < 1980
drop if year > 2019
egen code = group(countrycode)
xtset code year

gen ss = log(labor_share2)
areg labor_share1 i.year [aw=gdp_real], absorb(code) robust
predict ls1, xb
areg labor_share2 i.year [aw=gdp_real], absorb(code)
predict ls2, xb
collapse (mean) ls1 ls2, by(year)

*--- Mean of ls2 over 1985-1995 ---
summarize ls2 if inrange(year, 1985, 1995), meanonly
scalar ls2_base = r(mean)

*-----------------------------------------------------------------------------*
* Labor Share -- Plot (Figure Bx.5)
*-----------------------------------------------------------------------------*
twoway ///
    (line ls2 year, lcolor(black) lpattern(solid) lwidth(med)) ///
    (line ls1 year, lcolor(navy)  lpattern(dash)  lwidth(med)), ///
    legend(position(6) ring(0) label(1 "OECD-ANA") label(2 "PWT")) ///
    title("Labor Income Share in Advanced Economies") ///
    xtitle("Year") ///
    ytitle("Labor Share (incl. Mixed Income)") ///
    ylabel(0.62(0.02)0.68, nogrid)

graph save ls.gph, replace

******************************************************************************
*                  CROSS-COUNTRY CUMULATIVE PRODUCTIVITY GROWTH
******************************************************************************

cd "$ccc_dir"
use fernald_etal_data, replace

*-----------------------------------------------------------------------------*
* Aggregate output and input growth across selected industries
*-----------------------------------------------------------------------------*
* Start from a set of industries selected from data/uk_eu_us_industry_tfp.dta
gen CAP = VA - LAB
replace CAP = 0 if CAP < 0
*drop if nace_division=="A"

egen ci = group(countrycode nace)
foreach x in VA LAB CAP {
    bysort countrycode year: egen t`x' = total(`x')
    xtset ci year
    gen `x'sh = .5 * (`x'/t`x' + L.`x'/L.t`x')
}

replace dY  = dY  * VAsh
replace dLQ = dLQ * LABsh
replace dK  = dK  * CAPsh
replace dL  = dL  * LABsh
replace dA  = dA  * VAsh

collapse (sum) dY dA dLQ dK dL LAB VA CAP, by(countrycode year)

foreach x in Y A LQ K L {
    replace d`x' = . if d`x' == 0
}

*-----------------------------------------------------------------------------*
* Labor productivity growth
*-----------------------------------------------------------------------------*
gen dH  = dL - dLQ
gen dLP = .01 * (dY - dH)

keep if year >= 1985 & year <= 2019
replace dLP = . if year == 1985

merge 1:1 countrycode year using country_gdp
keep if _merge == 3
drop _merge

collapse (mean) dLP [aweight=gdp_real], by(year)
gen LP = exp(sum(dLP))
twoway line LP year
gen ln_LP = ln(LP)

*-----------------------------------------------------------------------------*
* Estimate pre- and post-break trends
*-----------------------------------------------------------------------------*
reg ln_LP year if inrange(year, 1992, 1995)
scalar b85_95 = _b[year]
reg ln_LP year if inrange(year, 2003, 2006)
scalar b95_06 = _b[year]

*--- Base values at 1995 and 2006 ---
gen LP_1995 = LP if year == 1995
gen LP_2006 = LP if year == 2006
egen base1995 = max(LP_1995)
egen base2006 = max(LP_2006)

*--- Time since each base ---
gen years_since_1995 = year - 1995
gen years_since_2006 = year - 2006

*--- Counterfactual paths ---
gen LP_cf1 = .
gen LP_cf2 = .
replace LP_cf1 = base1995 * exp(b85_95 * years_since_1995) if year >= 1995
replace LP_cf2 = base2006 * exp(b95_06 * years_since_2006) if year >= 2006

*-----------------------------------------------------------------------------*
* Productivity Growth -- Plot (Figure Bx.5)
*-----------------------------------------------------------------------------*
twoway ///
    (line LP     year, lcolor(black) lwidth(medthick)) ///
    (line LP_cf1 year if year >= 1995 & year <= 2006, lcolor(blue) lpattern("--")  lwidth(medium)) ///
    (line LP_cf2 year if year >= 2006,                lcolor(red)  lpattern(dash) lwidth(medium)), ///
    xline(1995 2005, lpattern(solid) lcolor(gs10)) ///
    title("Labor Productivity in Advanced Economies") ///
    xtitle("Year") ///
    ytitle("Cumulative Labor Productivity Growth (1985 = 1)") ///
    yscale(range(0.9 2)) ///
    xlabel(1985(5)2020, nogrid) ///
    ylabel(1(0.5)2.1, nogrid) ///
    legend(off)

graph save growth.gph, replace

*-----------------------------------------------------------------------------*
* Figure Bx.5
*-----------------------------------------------------------------------------*
gr combine growth.gph ls.gph, cols(2)