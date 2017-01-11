%Function to update the marginal probability (theta_i_mu) of vertex i to
%have label mu based on mean field approximation
%Author: Shaona Ghosh
function[theta2] = updatevertexmarginal(N, G, theta, beta, C, Ctype, Cmap, S_all, U) 

%get the neighbours of i from the graph
theta2 = theta;


%loop through all the unlabelled vertices to update the marginal
for i = 1:length(U)
    %update theta for vertex i for all classes
    for mu = 1:C
        %get the theta for i to update for each class
        %theta_i_mu = theta(i,mu);
        theta_i_mu = theta(U(i),mu);
        E_theta_So_imu = findjthetasforenergy(N, U(i), G, theta, beta, C, Ctype, Cmap, S_all, U, mu);%was i originally
        
        %find normalization energy for this vertex and class
        normE_theta_So_imu = E_theta_So_imu;
        Cnuclassids = find(Cmap ~= mu);
        for mu2 = 1:length(Cnuclassids)
            normE_theta_So_imu = normE_theta_So_imu + findjthetasforenergy(N, U(i), G, theta, beta, C, Ctype, Cmap, S_all, U, Cnuclassids(mu2));
        end
        %update theta
        theta_i_mu = E_theta_So_imu/normE_theta_So_imu;
        theta2(U(i),mu) = theta_i_mu;
    end
end

end