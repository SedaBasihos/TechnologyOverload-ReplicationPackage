
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN SYSTEM FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 3.1
% RELAXATION algorithm to solve infinite-horizon continuous time models.
%
% Description of procedure:
% Trimborn, Koch, and Steger (2008) Multidimensional Transitional Dynamics: A
% Simple Numerical Procedure, in Macroeconomic Dynamics
% 
% Open-source codes, Copyright by Trimborn, Koch, Steger, 2008
%
% For further information contact Timo Trimborn, University of Hannover
% or visit http://www.relaxation.uni-siegen.de
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all
disp(['Initialize Relaxation algorithm']);disp([' ']);

tic

globalpar                        % Initializes the global parameter

%calibration                     % calibrated parameters

parini                           % Loads the Parameter Values

%

relaxsettings                       % Loads the settings for the Relaxation algorithm, i.e. dimensions, boundary conditions etc. 

% Converts settings to a form suitable for relax.m
[guess, start, errorcode]=initrelax(@funcODE, @funcSTAT, n, n1, n3, nu, y, M, statev);       

if errorcode==0            % Executes the relaxation algorithm if no error occured during initilization
    
    [t, x]=relax(@funcODE, @funcSTAT, @funcINI, @funcfinal, n, n1, n3, nu, guess, M, start, Endcond, maxit, tol, damp, dampfac);    
    
    %Normalization of specified variables
    for i=1:M
        x(normal,i)=x(normal,i)./x(normal,end);
    end;
    
    varex                               % Extracts the variables and stores them in the memory
 
%    If you want to calculate and display the eigenvalues at the steady
%    state, remove the comment of the two subsequent lines.
  [EVa EVe Jac]=eigDAS(@funcODE, @funcSTAT, x(:,end));
  disp(['Eigenvalues: ',num2str(EVa')]);disp([' ']);

      % Calculate and display the half-life of convergence
    % Identify stable (negative) eigenvalues
    stable_eigenvalues = EVa(real(EVa) < 0);
    
    if ~isempty(stable_eigenvalues)
        % Find the dominant (slowest) convergence speed: min absolute value
        convergence_speed = min(abs(stable_eigenvalues));
        
        % Calculate the half-life
        half_life = log(2) / convergence_speed;
        
        % Display results
        disp(['Dominant stable eigenvalue: ', num2str(-convergence_speed)]);
        disp(['Convergence speed (β): ', num2str(convergence_speed)]);
        disp(['Half-life (t_½): ', num2str(half_life), ' periods']);
    else
        disp('No stable eigenvalues found for half-life calculation.');
    end
    disp([' ']);
    
end


%Calculation time
%time=toc;
%timesec=mod(time,60);
%timemin=floor(time/60);
%disp(['Calculation time: ',num2str(time),' seconds (',num2str(timemin),' min ',num2str(timesec),' sec)']);
simulation
plot_


