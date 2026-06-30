******************************************************************************
* Technology Overload? Macroeconomic Implications of Accelerated Obsolescence
******************************************************************************

clear

global obs_dir    "\Data and Figures\Obsolescence Rate"
global asset_dir  "\Data and Figures\Obsolescence Rate\asset"

cd "$obs_dir"

*-----------------------------------------------------------------------------*
* Load and prepare base data
*-----------------------------------------------------------------------------*
use data_asset, clear
drop if year < 1929
drop if asset == "EQ00"

*NOTE: to exclude information-processing equipment and software drop the followings:
*drop if asset=="EP1A" | asset=="EP1B" | asset=="EP1C" | asset=="EP1D" | asset=="EP1E" | asset=="EP1F" | asset=="EP1G" | asset=="EP1H" | asset=="ENS1" | asset=="ENS2" | asset=="ENS3"

collapse (sum) investment_nominal investment_constant capital_equipment_nominal ///
               capital_equipment_constant depreciation_constant depreciation_nominal ///
         (mean) life_fraumeni consumer_deflator consumer_deflator_47, ///
         by(asset year)

* Compute life_loop ONCE for all assets
summarize life_fraumeni if !missing(life_fraumeni), meanonly
gen life_loop = ceil(life_fraumeni)        // use same across all assets

* Get list of assets
levelsof asset, local(assetlist)
local assetlist: list uniq assetlist

*-----------------------------------------------------------------------------*
* Loop over each asset
*-----------------------------------------------------------------------------*
foreach a of local assetlist {
    preserve
    keep if asset == "`a'"

    *--- Set up panel ---
    tsset year

    *--- Deflate investment ---
    gen investment_non = investment_nominal / consumer_deflator
    replace investment_non = 0 if investment_non == .

    *--- Generate lagged investment and service life ---
    forvalues s = 0/`=life_loop' {
        gen invest_`s' = L`s'.investment_non
        gen life_`s'   = L`s'.life_fraumeni
    }

    *--- Compute hyperbolic decay weights ---
    scalar beta = 0.75
    forvalues s = 0/`=life_loop' {
        gen phi_`s' = (life_`s' - `s') / (life_`s' - beta * `s')
        replace phi_`s' = 0 if life_`s' <= `s'
    }

    *--- Compute capital contribution by vintage ---
    forvalues s = 0/`=life_loop' {
        gen contrib_`s' = invest_`s' * phi_`s'
    }

    gen K_phys = 0
    forvalues s = 0/`=life_loop' {
        replace K_phys = K_phys + contrib_`s'
    }

    *--- Aggregate over time for this asset ---
    collapse (sum) K_phys capital_equipment_nominal capital_equipment_constant ///
                   investment_nominal investment_constant depreciation_constant ///
                   depreciation_nominal investment_non, by(year)
    gen asset = "`a'"

    *--- Save per-asset result ---
    cd "$asset_dir"
    save "results_`a'.dta", replace
    restore
}

*-----------------------------------------------------------------------------*
* Merge all asset results together
*-----------------------------------------------------------------------------*
clear
cd "$asset_dir"
fs results_*.dta
append using `r(files)'

* Drop early years
drop if year < 1969

*-----------------------------------------------------------------------------*
* Collapse total across assets
*-----------------------------------------------------------------------------*
collapse (sum) K_phys capital_equipment_nominal capital_equipment_constant ///
               investment_nominal investment_constant depreciation_constant ///
               depreciation_nominal investment_non, by(year)

*-----------------------------------------------------------------------------*
* Create capital change and depreciation rates
*-----------------------------------------------------------------------------*
tsset year
gen diffe = K_phys - L.K_phys
gen delta_phys = (investment_non - diffe) / (L.K_phys + (investment_non * 0.5))

*--- Smooth physical depreciation rate ---
tssmooth ma trendvar = delta_phys, window(10 1 10)
replace delta_phys = trendvar

*--- Economic rate from actual depreciation (constant dollars) ---
gen rate_constant = depreciation_constant / (L.capital_equipment_constant + (investment_constant * 0.5))
tssmooth ma trendvar1 = rate_constant, window(2 1 2)
replace rate_constant = trendvar1

*--- Economic rate from actual depreciation (nominal dollars) ---
gen rate_nominal = depreciation_nominal / (L.capital_equipment_nominal + (investment_nominal * 0.5))
tssmooth ma trendvar2 = rate_nominal, window(2 1 2)
replace rate_nominal = trendvar2

*-----------------------------------------------------------------------------*
* Final output
*-----------------------------------------------------------------------------*
keep rate_constant rate_nominal delta_phys year
gen delta_z = rate_constant - delta_phys
drop if year < 1969

cd "$obs_dir"
save ARESULT_e_s, replace

*-----------------------------------------------------------------------------*
*RESULTS
*-----------------------------------------------------------------------------*
run Figure_1_and_Table_2.do


*--- Table 2 Entries
use ARESULT_e_s, clear
merge 1:1 year using obs_data        // dataset holding obs_c obs_n
drop _merge
* Period definitions (note 1970-1995* is the BGP, overlapping the first two)
local p1 1970 1985
local p2 1985 1995
local p3 1970 1995
local p4 1995 2005
local p5 2005 2015
local p6 2015 2023
local plab1 "1970-1985"
local plab2 "1985-1995"
local plab3 "1970-1995*"
local plab4 "1995-2005"
local plab5 "2005-2015"
local plab6 "2015-2023"

display _n "{txt}Period        d      d\$    dphys   d-phys  d\$-phys   dz     dz\$"
display     "{txt}--------------------------------------------------------------------"

forvalues k = 1/6 {
    local lo : word 1 of `p`k''
    local hi : word 2 of `p`k''

    quietly summarize rate_constant if inrange(year,`lo',`hi'), meanonly
    scalar d   = r(mean)*100
    quietly summarize rate_nominal  if inrange(year,`lo',`hi'), meanonly
    scalar dn  = r(mean)*100
    quietly summarize delta_phys    if inrange(year,`lo',`hi'), meanonly
    scalar dp  = r(mean)*100
    quietly summarize obs_c         if inrange(year,`lo',`hi'), meanonly
    scalar dz  = r(mean)*100
    quietly summarize obs_n         if inrange(year,`lo',`hi'), meanonly
    scalar dzn = r(mean)*100

    scalar gap1 = d  - dp
    scalar gap2 = dn - dp

    display "{res}" %-12s "`plab`k''" ///
        %7.1f d %7.1f dn %7.1f dp %8.1f gap1 %8.1f gap2 %7.1f dz %7.1f dzn
}	
	