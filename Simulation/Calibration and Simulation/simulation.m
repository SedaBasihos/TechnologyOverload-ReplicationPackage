
%%%%%%%%% Simulation Results %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%Labor in Production
L=1-(l_h+l_z);
%%
%Productivity Growth (g)
g=l_h.*(((1-alpha)/alpha)*b_l);
g=g.*100;
%%
%Labor Income Share - sigma
part1=(gamma/(1-gamma));
part2=((1./k)).^(psi);
sigma1=part1.*part2;
sigma=sigma1./(1+sigma1);
sigma=sigma.*100;
%Capital Income Share - sigma_k
sigma_k=sigma1.^(-1);
sigma_k=sigma_k./(1+sigma_k);
sigma_k=sigma_k.*100;
%Capital Share in Cost
sigma_kc=(beta/alpha).*sigma1.^(-1);
sigma_kc=sigma_kc./(1+sigma_kc);
sigma_kc=sigma_kc.*100;
%%
%Capital-Augmenting Change
z1=100*(b_k*l_z-delta);
%Stock of Capital Designs
Z=z.^((1-beta)/beta);
Zint=zss^((1-beta)/beta);
Zlog=log(Z./Zint);
%%
%Capital-Output Ratio in Efficiency Unit
yk=(((((((gamma+((k.^(psi))*(1-gamma))).^(1/psi)))))./k).^(-1));
yk_log=log(yk./yk(1));
%Capital-Output Ratio
yk1=((((((z.^((1-beta)/beta)).*((gamma+((k.^(psi))*(1-gamma))).^(1/psi)))))./k).^(-1));
yk1_log=log(yk1./yk1(1));
%Output-Capital Ratio (alternative effeciency level -- I use Z in comparison)
yk2=((((((z.^((1-beta)/beta)).*((gamma+((k.^(psi))*(1-gamma))).^(1/psi)))))./k).^(-1)).^(-1);
yk2_log=log(yk2./yk2(1));
%%
%Normalized Capital Growth
kg=100*(((((z.^((1-beta)/beta)).*((gamma+((k.^(psi))*(1-gamma))).^(1/psi)))-c)./k)+(((1-beta)/beta)*(b_k.*l_z-delta))-(((1-alpha)/alpha)*b_l.*l_h));      %ODE  k
%Capital Growth       
ka=100*(((((z.^((1-beta)/beta)).*((gamma+((k.^(psi))*(1-gamma))).^(1/psi)))-c))./k);
%Capital-Labor Ratio in Efficiency Unit _log index
kappa=k./k(1); %CES normalized k
kappalog=log(k./k(1));
%Capital-Efficient Labor Ratio
klh=k./Z;
%Capital-Efficient Labor Ratio _log index
klh_log=log(klh./klh(1));
%Capital Deepening per Labor Efficiency Unit
deepen=klh.*L;
deepen_log=log(deepen./deepen(1));
%%
%Relative Price of Efficient Capital
P=((1-gamma)/gamma).*(k.^(psi-1));
%Relative Price of Efficient Capital _log index
Plog=log(P/P(1)); %_log index
%%
%Price of Efficient Capital
PK=(((gamma^(1/(1-psi))).*((1./P).^(psi/(psi-1)))+((1-gamma)^(1/(1-psi)))).^((1-psi)/psi));
PKlog=(PK./PK(1))-1; %_log index
%%
%Price of Efficient Labor
%PL (PLlog is to quantify wage-productivity gap)
PL=(P./PK).^(-1);
PLlog=log((PL./PL(1))); %_log index
gap=log((PL(1)./PL)); %_log index
%%
%Check Price of Final Good Equals to 1:
PY=((((gamma^(1/(1-psi))).*(PL.^(psi/(psi-1))))+(((1-gamma)^(1/(1-psi))).*(PK.^(psi/(psi-1))))).^((1-psi)/psi));
%%
%Interest Rate (cost of capital or real stock return)
r=100.*(Z.*PK.*beta);
%r=100.*((beta.*(z.^((1-beta)/beta))).*(((gamma^(1/(1-psi))).*((1./P).^(psi/(psi-1)))+((1-gamma)^(1/(1-psi)))).^((1-psi)/psi)));
%%
%Consumption Growth
%Cg=(r-rho)./theta;
Cg=100.*(((1/theta).*(((beta.*(z.^((1-beta)/beta))).*((((gamma^(1/(1-psi))).*((((1-gamma)/gamma)^(psi/(1-psi))).*(k.^(-psi))))+((1-gamma)^(1/(1-psi)))).^((1-psi)/psi)))-rho)));
%%
%Implied Labor Efficiency
initkl=((2.71828.^(0.0162))*1)/Zint;
hh=(2.71828.^(((g.*t)/100)));
%Capital Labor Ratio
kl=(k.*hh)./(Z);
kl_log=log((kl./kl(1))); %_log index
%%
%Productivity Burst Match between 1996-2004/2005 (not in the main text)
burstg=[g(:,1);g(:,10);g(:,19);g(:,27);g(:,34);g(:,41);g(:,47);g(:,53);g(:,58);g(:,63)];
%%
%Obtain SS
DATA_StSt=[g(200),sigma_k(200), r(200), P(200), l_h(200), L(200), kappa(200)];
g(63)
%%
%Target Efficient Capital-to-Efficient-Labor Ratio
target_kappa=(kappalog(2)+kappalog(3)+kappalog(4)+kappalog(5)+kappalog(6)+kappalog(7)+kappalog(8)+kappalog(9)+kappalog(10)+kappalog(11))/10;
%%
%Relative wage in labor skill innovation sector
alpha_tilde = (1 - 2*alpha) / (1 - alpha);
gg=g./100;
rr=r./100;
rel_skill = ((alpha / (1 - alpha)) .*((rr - alpha_tilde .* gg) ./ b_l) .*(1 ./ L));
%Relative wage in design innovation sector
rel_design = ((alpha / (1 - beta)) .*(gamma / (1 - gamma)) .*((rr + delta - gg) ./ b_k) .*(1 ./ (kappa .^ psi)) .*(1 ./ L));
%Relative wage in labor skill innovation sector/capital desing
rel_ds=rel_design./rel_skill;
adj_system = (rr - alpha_tilde .* gg) ./ (rr + delta - gg);
rel_ds2=(((1-alpha)/(1-beta))*(b_l/b_k)).*(sigma1).*((rr + delta - gg)./(rr - alpha_tilde .* gg));
%%
%wage growth
kappa_growth = (k .* ( ...
    ( ( z.^((1-beta)/beta) .* ( (gamma + (k.^psi) .* (1-gamma)).^(1/psi) ) - c ) ./ k ) ...
    + ( ((1-beta)/beta) .* (b_k .* l_z - delta) ) ...
    - ( ((1-alpha)/alpha) .* b_l .* l_h ) ));
expr = ((1-psi) * (1-gamma) .* (k.^psi)) ./ (gamma + ((1-gamma) .* (k.^psi)));
w_g=(g./100+(kappa_growth.*expr)).*100;
dumpw=[w_g(:,1);w_g(:,10);w_g(:,19);w_g(:,27);w_g(:,34);w_g(:,41);w_g(:,47);w_g(:,53);w_g(:,58);w_g(:,63)];
gap1=w_g-g;
%%
%Components of mechanims from free entry
%relative capital share block
sigma_k1=sigma1.^-1;
log_sigma=log((sigma_k1./sigma_k1(1))); %_log index
%valuation block
A = 7.5 * ones(1,200);
val_block=((rr + delta - gg)./(rr - alpha_tilde .* gg)).^-1;
val_block_log=log((val_block./val_block(1))); %_log index
%%


