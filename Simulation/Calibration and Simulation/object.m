function Q=object(s)


g=0.017;  %%% Productivity growth, annual average over 1970-1995 from BLS -- nonfarm business real output per hour worked.

sigma_k=(37.4/(100-37.4)); %%% sigma_k in initially normalized production function, capital share is 37.4% (1970-1995) from BLS -- nonfarm business.

theta=2;  %%% EIS parameter, from Hall(1988)

r=0.077; %%% Returns on capital over 1970-1995 from NIPA -- non-farm business

rho=(r-(g*theta));  %%% Time preference: pinned down to get r=0.077;              

delta=0.05; %%% Rate of technological turnover, estimated in Section 4.1.

L=0.75;   %%% Employment in production sector in 1989, from Acemoglu and Autor (2011)


% Steady-state properties
Q=[g-(((1-s(1))/s(1))*((s(2)-(delta*(s(2)/s(3)))-((s(1)/(1-s(1)))*rho))/(theta-((1-2*s(1))/(1-s(1)))+1))); %%% BGP growth rate
   sigma_k-((s(2)/s(3))*(((1-s(1))/(1-s(4)))*(((g*(theta-1))+rho+delta)/((g*(theta-((1-2*s(1))/(1-s(1)))))+rho)))); %%% BGP relative capital share
   L-(((theta*g)+rho-(((1-2*s(1))/(1-s(1)))*g))*(s(1)/((1-s(1))*s(2)))); %%% BGP employment in production sector
   (g*(s(1)/((1-s(1))*s(2))))-(delta/s(3)) %%% BGP employment in R&D sectors
   ];


end



