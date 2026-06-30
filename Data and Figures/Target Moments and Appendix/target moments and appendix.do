******************************************************************************
*Technology Overload? Macroeconomic Implications of Accelerated Obsolescence 
******************************************************************************
clear

cd "\Data and Figures\Target Moments and Appendix"

import excel "\Data and Figures\Target Moments and Appendix\Macro Data.xlsx", sheet("Sheet1") firstrow clear


*--------------------------------------------------------------------------------------------
**Target Moments Producitvity Growth, Labor Share and Return on Capital (Table 1 and Table 3)
*--------------------------------------------------------------------------------------------

*Productivity Growth: Initial BGP, Boom, New BGP
local units 0.001 0.0001 0.0001
local fmts  %5.3f %6.4f %6.4f
forvalues i = 1/3 {
    local lo : word `i' of 1970 1996 2006
    local hi : word `i' of 1995 2005 2015
    local u  : word `i' of `units'
    local f  : word `i' of `fmts'
    quietly summarize prod_growth if inrange(year, `lo', `hi')
    display "`lo'-`hi': " `f' round(r(mean), `u')
}

*Labor Income Share: Initial BGP and New BGP
local units 0.1 0.1
local fmts  %5.1f %5.1f
forvalues i = 1/2 {
    local lo : word `i' of 1970 2010
    local hi : word `i' of 1995 2023
    local u  : word `i' of `units'
    local f  : word `i' of `fmts'
    quietly summarize laborincomeshare if inrange(year, `lo', `hi')
    display "`lo'-`hi': " `f' round(r(mean), `u')
}

*Return on Capital: Initial BGP
quietly summarize returnoncapital if inrange(year, 1970, 1995)
display "1970-1995: " %5.3f round(r(mean), 0.001)


*------------------------------------------------------------------
* Appendix B Figures
*------------------------------------------------------------------

* Efficiency of Capital Equipment -- Figure Bx.2 (Online Appendix B)
tsset year
tssmooth ma ma1 = capitalefficiencyequipment, window(1 1 1)
twoway ///
    (line ma1 year if inrange(year, 1985, 2023), sort lcolor(black) lwidth(1) ///
        ytitle("Log deviation (avg. 1970-85 = 0)", size(medium)) ///
        xlabel(1985(5)2020, nogrid) xtitle("Year") ///
        ylabel(0.3(0.3)-0.8) ///
        legend(off) title("Efficiency of Capital Equipment"))
		
		
* Capital Productivity -- Figure Bx.3 (Online Appendix B)
* Note that this figure already smoothed (HP filter with smoothign parameter 6.25)
line capitalproductivity year if inrange(year, 1985, 2025), sort ///
    xlabel(1985(5)2025, nogrid) ytitle("%", size(medium)) ///
    lcolor(black) lwidth(1) xtitle("Year") legend(off) ///
    title("Capital Productivity") xline(1995, lcolor(green))
	

*Wage-Productivity Gap 	-- Figure Bx.4 (Online Appendix B)
twoway line realoutputperhour year if inrange(year, 1985, 2019), sort ///
    xlabel(1985 (10) 2019, grid) ///
    ylabel(0.7 (0.3) 1.9, grid) legend(label(1 "Labor Productivity")) ///
    ytitle("Cumulative Growth, 1990=1") lcolor(black) lpattern(solid) lwidth(1.5) ///
    xtitle("Year") || ///
    line realcompensationperhour year if inrange(year, 1985, 2019), ///
    lwidth(1.35) lcolor(orange_red%80) ///
    lpattern(longdash) legend(label(2 "Real Compensation per Hour")) ///
    title("Wage-Productivity Gap", size(medium)) legend(ring(0) position(5))	
		
		
*------------------------------------------------------------------		









