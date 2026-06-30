******************************************************************************
*Technology Overload? Macroeconomic Implications of Accelerated Obsolescence 
******************************************************************************
*-----------------------------CES Parameter----------------------------------*
clear 

cd "\Data and Figures\CES Parameter"
use DATA_CES, replace

*Arrange variables:
*-----------------------
gen logftkt=ln(real_GDP/real_capital)
gen logrtpt=ln(rental_rate/GDP_price)
gen logwtpt=ln(wage_rate/GDP_price)
gen logktlt=ln(real_capital/labor)
gen logwtrt=ln(wage_rate/rental_rate)
gen logftlt=ln(real_GDP/labor)
gen govcap=ln(capital_gov_real)
gen govwage=ln(wage_rate_gov)
gen uspop=ln(pop)

*Generating a time trend:
*-----------------------
destring year, replace
drop if year>1998
egen min_year = min(year)
gen time_trend = year - min_year
tsset year

*----------------------------------------------------------------------------*
*                            SPECIFICATION 1                                  *
*----------------------------------------------------------------------------*

*OLS estimates:
*--------------
regress logktlt logwtrt time_trend          //* Specification 1
test logwtrt=1
estimates store ols1

*Prais-Winsten estimates:
*-----------------------
prais logktlt logwtrt time_trend            //* Specification 1
test logwtrt=1
estimates store gls1

*GIV estimates:
*-------------
*ssc install ivreg2
ivreg2 logktlt (logwtrt = govcap govwage uspop) time_trend, gmm2s bw(2)   //* Specification 1
test logwtrt=1
estimates store giv1

*Saikonnen estimates:
*--------------------
regress logktlt logwtrt time_trend F.D.logwtrt L.D.logwtrt
predict u1, resid
quietly regress u1 L.u1 if e(sample)
predict u1h, xb
regress logktlt logwtrt time_trend u1h
test logwtrt=1
estimates store sa1

*Lagged OLS estimates:
*--------------------
regress logktlt logwtrt L.logwtrt L.logktlt time_trend    //* Specification 1
test logwtrt=1
estimates store lg1

*----------------------------------------------------------------------------*
*                            SPECIFICATION 2                                  *
*               (with reciprocal coefficients via delta method)               *
*----------------------------------------------------------------------------*

*OLS estimates:
*--------------
regress logwtrt logktlt time_trend          //* Specification 2
test logktlt=1
estimates store ols2
nlcom (recip: 1/_b[logktlt]), post
estimates store ols2_recip

*Prais-Winsten estimates:
*-----------------------
prais logwtrt logktlt time_trend            //* Specification 2
test logktlt=1
estimates store gls2
nlcom (recip: 1/_b[logktlt]), post
estimates store gls2_recip

*GIV estimates:
*-------------
ivreg2 logwtrt (logktlt = govcap govwage uspop) time_trend, gmm2s bw(2)   //* Specification 2
test logktlt=1
estimates store giv2
nlcom (recip: 1/_b[logktlt]), post
estimates store giv2_recip

*Saikonnen estimates:
*--------------------
regress logwtrt logktlt time_trend F.D.logktlt L.D.logktlt
predict u2, resid
quietly regress u2 L.u2 if e(sample)
predict u2h, xb
regress logwtrt logktlt time_trend u2h
test logktlt=1
estimates store sa2
nlcom (recip: 1/_b[logktlt]), post
estimates store sa2_recip

*Lagged OLS estimates:
*--------------------
regress logwtrt logktlt L.logktlt L.logwtrt time_trend    //* Specification 2
test logktlt=1
estimates store lg2
nlcom (recip: 1/_b[logktlt]), post
estimates store lg2_recip

*----------------------------------------------------------------------------*
*CES Estiamtes -- Table Ax.2 (Online Appendix A) 
*----------------------------------------------------------------------------*

*--- Specification 1 (original coefficients) ---
esttab ols1 gls1 giv1 sa1 lg1 using Table_CES.tex, replace compress ///
    star(* .10 ** .05 *** .01) drop(time_trend _cons u1h L.logwtrt L.logktlt) ///
    noconstant label stats(N r2, fmt(%9.0fc %5.3fc)) b(%5.3f) se(%5.3f)

*--- Specification 2 (original coefficients) ---
esttab ols2 gls2 giv2 sa2 lg2 using Table_CES.tex, append compress ///
    star(* .10 ** .05 *** .01) drop(time_trend _cons u2h L.logwtrt L.logktlt) ///
    noconstant title(Elasticity Estimates under Biased Technological Change) ///
    varwidth(20) modelwidth(12) label stats(N r2, fmt(%9.0fc %5.3fc)) ///
    b(%5.3f) se(%5.3f)

*--- Specification 2 reciprocal coefficients (delta-method SE) ---
esttab ols2_recip gls2_recip giv2_recip sa2_recip lg2_recip using Table_CES.tex, ///
    append compress star(* .10 ** .05 *** .01) ///
    title(Reciprocal Elasticity Estimates (Delta-Method SE)) ///
    varwidth(20) modelwidth(12) b(%5.3f) se(%5.3f) ///
    mtitles("OLS" "GLS" "GIV" "Saikkonen" "Lagged OLS")
	
*--------------------------------------------------------------------------------------*
* Unit Root & Cointegration Tests -- Estimates reporte in Table Ax.1 (Online Appendix A)
*--------------------------------------------------------------------------------------*

* ADF -- levels
dfuller logktlt
dfuller logktlt, lags(1)
dfuller logktlt, lags(2)
dfuller D.logktlt, lags(1)

dfuller logwtrt
dfuller logwtrt, lags(1)
dfuller logwtrt, lags(2)
dfuller D.logwtrt, lags(1)

* Cointegration Test -- residual-based ADF
quietly regress logktlt logwtrt time_trend
predict residuals1, resid
dfuller residuals1
dfuller residuals1, lags(1)
dfuller residuals1, lags(2)

quietly regress logwtrt logktlt time_trend
predict residuals2, resid
dfuller residuals2
dfuller residuals2, lags(1)
dfuller residuals2, lags(2)

*-----------------------------------*
* Figure Ax.1 (Online Appendix A)
*-----------------------------------*


summarize logktlt if year == 1948
gen logktlt_n = logktlt - r(mean)

gen logwtrt2 = ln(wage_rate/(rental_rate*1000))
summarize logwtrt2 if year == 1948
gen logwtrt2_n = logwtrt2 - r(mean)

* --- Plot ---
twoway ///
    (line logktlt_n year if inrange(year,1948,1998), sort ///
        lcolor("34 139 34") lpattern(solid) lwidth(thick)) ///
    (line logwtrt2_n year if inrange(year,1948,1998), sort ///
        lcolor("198 176 128") lpattern(dash) lwidth(thick)), ///
    ylabel(-0.3(0.3)1.8, angle(horizontal) grid glcolor(gs14)) ///
    xlabel(1948(10)1998, grid glcolor(gs14)) xtitle("year") ytitle("") ///
    legend(order(1 "log(K/L)" 2 "log(W/R)") ring(0) position(4) ///
        cols(1) region(lstyle(none)) size(small)) ///
    graphregion(color(white)) plotregion(color(white))

*--------------------------------------------------------------------------------------*	