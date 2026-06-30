%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
%close all
%%
%%%%%%%%% For Initial Parameter Calibration %%%%%%%%%%%%%

% minimize with fsolve.m
% starting guess at the solution
x0 = [.5, .5, .5, .5]';

options = optimset('fsolve');
options = optimset('Display','iter','Algorithm','trust-region-dogleg', 'MaxIter', 10000, 'MaxFunEvals', 10000);

[s,fval, exitflag]= fsolve (@object,x0,options);

alpha=s(1,:);
b_l=s(2,:);
b_k=s(3,:);
beta=s(4,:);

%%
%%%%%%%%%%%%%%%% RUN THE SIMULATION %%%%%%%%%%%%%%%%%%%%%

main
