******************************************************************************
*Technology Overload? Macroeconomic Implications of Accelerated Obsolescence 
******************************************************************************

**Figure 2 (manuscript version)**

clear

global cs_dir "\Calibration\Calibration and Simulation"
cd "$cs_dir"

import excel "plot.xlsx", sheet("val") firstrow clear

graph drop _all

*----------------------------------------------------------------------------------------*
twoway (line gs tt, lcolor(black) lwidth(1)) ///
       (line gss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("Productivity Growth (g)") ytitle("%") xlabel(-5(5)50) ylabel(1(0.5)3) ///
	   xlabel(-10(10)50, nogrid) ylabel(1(0.5)3, nogrid) ///
	   ytitle("%", size(med)) ///
	   xtitle("") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(growth, replace)

twoway (line w_gg tt, lcolor(black) lwidth(1)) ///
       (line gs tt, lpattern(dash) lcolor(gs10) lwidth(1)) ///
       (line wgss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("Wage Growth vs. Productivity Growth") ytitle("%") xlabel(-5(5)50) ylabel(-3(1)3) ///
	   ytitle("%", size(small)) ///
	   xtitle("") ///
	   xlabel(-10(10)50, nogrid) ylabel(-2(1)3, nogrid) ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(position(6) ring(0)  order(1 "Wage Growth" 2 "Productivity Growth")) name(wage_growth, replace)
	   
twoway (line Zs tt, lcolor(black) lwidth(1)) ///
       (line Zss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("Efficiency of Capital (Z)") ytitle("Log Deviation") xlabel(-5(5)50) ylabel(-1(0.5)1) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("") ///
	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(capital_eff, replace)

twoway (line l_zz tt, lcolor(black) lwidth(1)) ///
       (line l_hh tt, lpattern(dash) lcolor(black) lwidth(1)) ///
       (line LL tt, lpattern(dash_dot) lcolor(gs10) lwidth(1)) ///
       (line Lss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Resource Allocation") ytitle("Change") xlabel(-5(5)50) ylabel(-0.3(0.1)0.2) ///
	   xlabel(-10(10)50, nogrid) ylabel(-.2(0.10)0.15, nogrid) ///
	   ytitle("% Points", size(med)) ///
	   xtitle("") ///
	   graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(position(6) ring(0) order(1 "L{sub:z} for Capital Design" 2 " L{sub:h} for Labor Skill" 3 "L for Production") size(small)) name(resource_alloc, replace)	   
	   
	   
graph combine growth wage_growth resource_alloc, cols(3) 

graph save "Graph" "$cs_dir\transition1.gph", replace

*----------------------------------------------------------------------------------------*
twoway (line log_sigmaa tt, lcolor(black) lwidth(1)) ///
       (line val_block_logg tt, lpattern(dash) lcolor(black) lwidth(1)) ///
       (line log_sigmass tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta}Terms in No-Arbitrage") ytitle("Change") xlabel(-5(5)50) ylabel(-0.3(0.1)0.2) ///
	   xlabel(-10(10)50, nogrid) ylabel(-.5(0.25)0.5, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("") ///
	   graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(position(6) ring(0) order(2 "Relative Discounting (r-{&sim}{&alpha} g)/(r+{&delta}{sub:z}-g)" 1 " Relative Share P{sub:K}Y{sub:K}/P{sub:L}Y{sub:L}") size(small)) name(terms, replace)
	   
twoway (line rs tt, lcolor(black) lwidth(1)) ///
       (line rss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("Rate of Interest") ytitle("%") ///
	   xlabel(-10(10)50, nogrid) ylabel(7(0.5)8.5, nogrid) ///
	   ytitle("%", size(med)) ///
	   xtitle("") ///
	   graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(interest_rate, replace)	   
	   
	   
twoway (line log_sigmaa tt, lcolor(black) lwidth(1)) ///
       (line log_sigmass tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Relative Share Term (P{sub:K}Y{sub:K}/P{sub:L}Y{sub:L})") ytitle("Log Deviation") ///
	   	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(relative_share, replace)

twoway (line val_block_logg tt, lcolor(black) lwidth(1)) ///
       (line val_block_logss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Relative Discounting Term (r-{&sim}{&alpha} g)/(r+{&delta}{sub:z}-g)") ytitle("Log Deviation") ///
	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(valuation_growth, replace)

twoway (line Zs tt, lcolor(black) lwidth(1)) ///
       (line Zss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Efficiency of Capital (Z)") ytitle("Log Deviation") ///
	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(zet, replace)
	   
graph combine terms interest_rate zet, cols(3) 

graph save "$cs_dir\transition2.gph", replace


*----------------------------------------------------------------------------------------*

twoway (line sigmals tt, lcolor(black) lwidth(1)) ///
       (line sigmalss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("Labor Income Share") ytitle("%") ///
	   xlabel(-10(10)50, nogrid) ylabel(55(2.5)65, nogrid) ///
	   ytitle("%", size(med)) ///
	   xtitle("year") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(labor_share, replace)

	   
twoway (line ks tt, lcolor(black) lwidth(1)) ///
       (line kss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Efficient Capital-to-Efficient Labor ({&kappa})") ytitle("Log Deviation") 	   	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("year") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(capital_labor_ratio, replace)

twoway (line Plogs tt, lcolor(black) lwidth(1)) ///
       (line Plogss tt, lpattern(dot) lcolor(red) lwidth(0.8)), ///
       title("{&Delta} Relative Factor Price (P{sub:K}/P{sub:L})") ytitle("Log Deviation") 	   	   xlabel(-10(10)50, nogrid) ylabel(-1(0.5)1, nogrid) ///
	   ytitle("Log Points", size(med)) ///
	   xtitle("year") ///
	    graphregion(color(white)) plotregion(style(none) margin(zero)) ///
       legend(off) name(relative_price, replace)

graph combine labor_share capital_labor_ratio relative_price, cols(3)

graph save "Graph" "$cs_dir\transition3.gph", replace


*----------------------------------------------------------------------------------------*
*graph combine transition1.gph transition2.gph transition3.gph, cols(1)