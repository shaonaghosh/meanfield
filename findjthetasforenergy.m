%Author: Shaona Ghosh
function[E_theta_So_imu] = findjthetasforenergy(N, i, G, theta, beta, C, Ctype, Cmap, S_all, U, mu)

%get other class ids to retrieve
Cnuclassids = find(Cmap ~= mu);
%get the theta neighbours from other classes
all_theta_j_nus = theta(:,Cnuclassids);

neigh_js = G(i,:);

%calulate normalization term for updating theta
E_theta_So_imu = calcenergypervertexperclass(neigh_js, i, all_theta_j_nus, beta, Cmap, S_all, Ctype, mu);




end