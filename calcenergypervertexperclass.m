%Author: Shaona Ghosh
function[E_theta_So] = calcenergypervertexperclass(neigh_js, i, all_theta_j_nus, beta, Cmap, S_all, Ctype, mu)

    
    %loop through all neighbours of i
    sum_js = 0;
    for jit = 1:length(neigh_js)
       if jit == i %not interested in contribution from itself
        continue;
       end 
       %get theta_j of neighbour
       theta_nu_jit = all_theta_j_nus(jit,:);
        
       if( 0 == S_all(jit))%an unlabelled neighbour 
       %get contribution from all unlabelled neighbour j with class nu ~=
       %mu
       contrib_Ujit_nu = neigh_js(jit) * sum(theta_nu_jit);%G(i,jit)*sum(theta_nu_jit,2);
       sum_js = sum_js + contrib_Ujit_nu;
       %get contribution from all the labelled neighbour j with class S_j
       %~= mu
       else 
           if S_all(jit)~= Ctype(mu)
                contrib_Ljit_nu = neigh_js(jit);%G(i,jit);
                sum_js = sum_js + contrib_Ljit_nu;
           end
       end
        
    end
    %update theta for i
    E_theta_So = exp(-beta*sum_js);
    
end





