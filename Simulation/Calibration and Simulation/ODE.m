%input of system of ordinary differential equations (as a vector)

funcODE=[ z*((b_k*l_z)-delta); %ODE z: capital technological change
          k*((((((z^((1-beta)/beta))*((gamma+((k^(psi))*(1-gamma)))^(1/psi)))-c)/k)...
          +(((1-beta)/beta)*(b_k*l_z-delta))-(((1-alpha)/alpha)*b_l*l_h))); %ODE  k: normalized efficient capital-labor ratio
          c*((((1/theta)*(((beta*(z^((1-beta)/beta)))*((((k^(-psi))*((gamma^(1/(1-psi)))*(((1-gamma)/gamma)^(psi/(1-psi)))))...
          +((1-gamma)^(1/(1-psi))))^((1-psi)/psi)))-rho))+(((1-beta)/beta)*(b_k*l_z-delta))-(((1-alpha)/alpha)*b_l*l_h)))]; %ODE c: normalized consumption

         