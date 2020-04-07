function [Disp,A_primary,odeData_mod] = physical_disp_ode(odeData_mod,PHI,...
                                    geom,sim,aero,x,st,en,Peter)
% PHI_h_x = PHI.PHI_h_x;
% PSI_a_x = PHI.PHI_a_x;
laser_loc_span = sim.vibr_pos_span;
laser_c = sim.vibr_pos_chord;
U_speed = sim.U_speed;
PHI_h_span = transpose(double(subs(PHI.PHI_h_x,x,laser_loc_span)));
PSI_a_span = transpose(double(subs(PHI.PSI_a_x,x,laser_loc_span)));
nU = numel(U_speed)
x_theta = laser_c - geom.xf;
% aero.Uf
for k = 1:nU

    idx = 1;
    if U_speed(k)  >= aero.Uf
        nos_orig = numel(odeData_mod(k).time_U);
        nos_new = numel(odeData_mod(k).time_U(odeData_mod(k).time_U >= 3));
        idx = nos_orig - nos_new + 1;
        odeData_mod(k).time_U = odeData_mod(k).time_U(odeData_mod(k).time_U >= 3);
        
    end
%     odeData(k).Xr_U odeData(k).Xr_U(idx:end,:);
%     numel(odeData_mod(k).Xr_U)
    Disp(k).h_xf = (odeData_mod(k).Xr_U(idx:end,1:sim.nh)*PHI_h_span); %m, Heave displacement
    Disp(k).Vh_xf = (odeData_mod(k).Xr_U(idx:end,st.Vh:en.Vh)*PHI_h_span); %m/s, Heave velocity
    Disp(k).a_xf = (odeData_mod(k).Xr_U(idx:end,sim.nh+1:sim.modes)*PSI_a_span); %rad, Pitch displacement
    Disp(k).Va_xf = (odeData_mod(k).Xr_U(idx:end,st.Va:en.Va)*PSI_a_span); %rad/s, Pitch velocity
    Disp(k).h_P = Disp(k).h_xf - 1*x_theta.*sin(Disp(k).a_xf); %m,
    Disp(k).Vh_P = Disp(k).Vh_xf - 1*x_theta*((Disp(k).Va_xf).*cos(Disp(k).a_xf)); %m,
    Disp(k).h_P_mm = 1000*Disp(k).h_P;
    Disp(k).Vh_P_mm = 1000*Disp(k).Vh_P;
    Disp(k).h_xf_mm = 1000*Disp(k).h_xf;
    Disp(k).a_xf_theta = (180/pi)*Disp(k).a_xf;
%     idx
    A_primary(k) = rms((Disp(k).h_P_mm));
    %% Effective angle of attack at flexural point 'geom.xf'
    %     Np_i = laser_loc_span/geom.dl_act;
    %     lambda_start = 2*sim.modes + (Np_i - 1)*aero.N + 1;
    %     lambda_end = lambda_start + aero.N - 1;
    %     if Np_i == 0.5*geom.L/geom.dl_act
    %        lambda_start2 = lambda_end + 1;
    %        lambda_end2 = lambda_start2 + aero.N - 1;
    %        Lambdas1 = (odeData(k).Xr_U(:,lambda_start:lambda_end));
    %        Lambdas2 = (odeData(k).Xr_U(:,lambda_start2:lambda_end2));
    %        Lambdas = 0.5*(Lambdas1 + Lambdas2);
    %     else
    %         Lambdas = odeData(k).Xr_U(:,lambda_start:lambda_end);
    %     end
    % %     size(Lambdas)
    %     Lambda0 = 0.5*Lambdas*Peter.geom.b;
    %     size(Lambda0)
    %     Disp(k).alpha_eff_xf = Disp(k).a_xf + Disp(k).h_P./U_speed(k) + ...
    %                         0*((geom.b/U_speed(k))*(0.5 - geom.a)).*Disp(k).Va_xf - ...
    %                         0*Lambda0./U_speed(k); %radians
    %      Disp(k).alpha_eff_xf = Disp(k).a_xf;
Disp(k).alpha_eff_xf = Disp(k).a_xf + Disp(k).h_P./U_speed(k);
end
end