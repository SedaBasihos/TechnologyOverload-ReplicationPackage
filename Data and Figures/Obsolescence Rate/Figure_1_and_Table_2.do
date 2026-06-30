******************************************************************************
* Technology Overload? Macroeconomic Implications of Accelerated Obsolescence
******************************************************************************

clear

*-----------------------------------------------------------------------------*
* Implied obsolescence rate -- CONSTANT-dollar pass
*-----------------------------------------------------------------------------*
cd "$obs_dir"
use ARESULT_e_s, clear
tsset year

* Generate q(t-1)/q(t)
gen rho = (1 - rate_constant) / (1 - delta_phys)

* Generate q(t), normalized at q_0 = 1
gen q_index = .
replace q_index = 1 if _n == 1
forvalues i = 2/`=_N' {
    quietly replace q_index = q_index[_n-1] / rho[_n] in `i'
}

* Calculate the log-difference (approximate obsolescence rate)
gen obs_c = log(q_index) - log(q_index[_n-1])

preserve
keep obs_c year
save obs_c, replace
restore

*-----------------------------------------------------------------------------*
* Implied obsolescence rate -- NOMINAL-dollar pass
*-----------------------------------------------------------------------------*
cd "$obs_dir"
use ARESULT_e_s, clear
tsset year

* Generate q(t-1)/q(t)
gen rho = (1 - rate_nominal) / (1 - delta_phys)

* Generate q(t), normalized at q_0 = 1
gen q_index = .
replace q_index = 1 if _n == 1
forvalues i = 2/`=_N' {
    quietly replace q_index = q_index[_n-1] / rho[_n] in `i'
}

* Calculate the log-difference (approximate obsolescence rate)
gen obs_n = log(q_index) - log(q_index[_n-1])

preserve
keep obs_n year
save obs_n, replace
restore

*-----------------------------------------------------------------------------*
* Figure 1
*-----------------------------------------------------------------------------*
use obs_c, clear
merge 1:1 year using obs_n
drop _merge
save obs_data, replace

twoway ///
    (line obs_c year if inrange(year, 1970, 2023), ///
        lwidth(thick) lcolor(black) lpattern(solid) yaxis(1)) ///
    (line obs_n year if inrange(year, 1970, 2023), ///
        lwidth(thick) lcolor(black) lpattern(dash) yaxis(2)), ///
    ylabel(0.0(0.01)0.08, axis(1) angle(horizontal)) ///
    ylabel(0.03(0.005)0.08, axis(2) angle(horizontal)) ///
    ytitle("Constant-Dollar Rate", axis(1)) ///
    ytitle("Current-Dollar Rate", axis(2)) ///
    legend(label(1 "Implied Obsolescence Rate (Constant)") ///
           label(2 "Implied Obsolescence Rate (Nominal) - RHS")) ///
    xtitle("") ///
    graphregion(color(white)) ///
    plotregion(margin(zero)) ///
    legend(position(6) ring(0))
	

*-----------------------------------------------------------------------------*
* Table 2 Entries
*-----------------------------------------------------------------------------*
use ARESULT_e_s, clear
merge 1:1 year using obs_data        // dataset holding obs_c obs_n
drop _merge

*-----------------------------------------------------------------------------*
* Build the period averages
*-----------------------------------------------------------------------------*
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
	
	