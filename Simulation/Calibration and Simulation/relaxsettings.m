%relaxsetting.m

% number of initial boundary conditions ( = number of state variables)
n1=2;

%number of differential equations (Note: number of final boundary
%conditions equals n-n1)
n=3;

% number of static equations to be solved simultanously
n3=2;

%number of mesh points
M=200;

%number of variables altogether
N=n+n3;         %(Do not change)

%Normalization of variables
normal=[];

% calculation of steady state values
lzss=delta/b_k;
lhss=((1/b_l)*((b_l-(delta*(b_l/b_k))-(((alpha)/(1-alpha))*rho))/(theta-((1-2*alpha)/(1-alpha))+1)));
kss=((((gamma/(1-gamma))*((1-alpha)/(1-beta))*(b_l/b_k))*((((((1-alpha)/alpha)*lhss*b_l)*(theta-1))+rho+delta)/(((((1-alpha)/alpha)*lhss*b_l)*(theta-((1-2*alpha)/(1-alpha))))+rho)))^(1/psi));
zss=((((((((1-alpha)/alpha)*b_l*lhss)-(((1-beta)/beta)*(b_k*lzss-delta)))*theta)+rho)/(beta*((((kss^(-psi))*((gamma^(1/(1-psi)))*(((1-gamma)/gamma)^(psi/(1-psi)))))+((1-gamma)^(1/(1-psi))))^((1-psi)/psi))))^(beta/(1-beta)));
css=(((zss^((1-beta)/beta))*((gamma+((kss^(psi))*(1-gamma)))^(1/psi)))-(kss*((((1-alpha)/alpha)*b_l*lhss)-(((1-beta)/beta)*(b_k*lzss-delta)))));

%guess of final steady state values
y=ones(N,1);
y(1)=zss;     %z
y(2)=kss;     %k
y(3)=css;     %c
y(4)=lhss;    %l_h
y(5)=lzss;    %l_z

%In case the shock consists of a reduction of state variables, enter this
%here
statev=ones(N,1); %Here a specific shock is simulated, specified in shock.m 

%--------------------------------------------------------------------------
%Specification, which differential equations are used for constructing the
%final boundary conditions. 
Endcond=[n1+1:n];

tol=10^-10;     %tolerance for the Newton procedure
maxit=50;       %Maximum number of iterations
nu=0.05;        %Parameter for time transformation
damp=1;         %Dampening factor of the Newton procedure. The dampening factor will be 
dampfac=1;      %multiplied by the factor dampfac in every iteration until it equals 1
