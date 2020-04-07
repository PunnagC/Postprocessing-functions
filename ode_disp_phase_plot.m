function [fig_out,Disp] = ode_disp_phase_plot(Disp,odeData,U_speed,A_mm,fileN1,aero,mat)
nrow = round(sqrt(numel(U_speed)),0); %no. of rows in subplot
ncol = round(numel(U_speed)/nrow,0); %no. of columns in subplot
if nrow*ncol < numel(U_speed)
    nrow = nrow + 1;
end
count = 0;
%% 1 Plotting H, Heave vs time
figH_U = figure;
set(0,'defaulttextinterpreter','latex')
set(figH_U,'name',fileN1,'numbertitle','off')
for k = 1:numel(U_speed)
    time_plot = odeData(k).time_U;
    y_h_mm = Disp(k).h_P_mm;
    y_a_deg = Disp(k).a_xf_theta;
    hold on
    subplot(nrow,ncol,k);
    title(['$U:$',num2str(U_speed(k)),'m/s']);
    plot(time_plot,y_h_mm) %in mm in y axis at locx (1:2001)
    xlabel('$t,s$');
    ylabel('$A,mm$');
end
hold on
%% 2 Plotting phase H vs A
figA_H = figure;
set(0,'defaulttextinterpreter','latex')
set(figA_H,'name',fileN1,'numbertitle','off')
for k = 1:numel(U_speed)
    hold on
    subplot(nrow,ncol,k);
    title(['$U:$',num2str(U_speed(k)),'m/s']);
    plot(Disp(k).h_P_mm, Disp(k).a_xf_theta) %in mm in y axis
    grid on
    xlabel('$h,mm$');
    ylabel('$\theta^0$');
    hold on
end
%% 3 Plotting Amplitude vs U
AhvsU = figure;
set(0,'defaulttextinterpreter','latex')
set(AhvsU,'name',fileN1,'numbertitle','off')
plot(U_speed, A_mm,'o');
title(['NLh=',num2str(mat.NLh/1e6),'e6','; NLa=',num2str(mat.NLa/1e6),'e6']);
xlabel('Windspeed, U(m/s)')
ylabel(['Heave Ampl. at ',num2str(aero.xc/aero.c),'*c, h(mm)']);
grid on
%% 4 Plotting  phase h_dot vs h
hdotvsh = figure;
set(0,'defaulttextinterpreter','latex')
set(hdotvsh,'name',fileN1,'numbertitle','off')
for k = 1:numel(U_speed)
    hold on
    subplot(nrow,ncol,k);
    title(['$U:$',num2str(U_speed(k)),'m/s']);
    plot(Disp(k).Vh_P_mm,Disp(k).h_P_mm) %in mm in y axis
    grid on
    xlabel('$h,mm$');
    ylabel('$\dot{h}$');
    hold on
end
%% 5 Plotting  effective AOA at flexural point
eAOAvstime = figure;
set(0,'defaulttextinterpreter','latex')
set(eAOAvstime,'name',fileN1,'numbertitle','off')
for k = 1:numel(U_speed)
    time_plot = odeData(k).time_U;
    eAOA      = Disp(k).alpha_eff_xf;
    eAOA_deg  = rad2deg(eAOA);
    
    hold on
    subplot(nrow,ncol,k);
    title(['$U:$',num2str(U_speed(k)),'m/s']);
    plot(time_plot,eAOA_deg) %in mm in y axis at locx
    xlabel('$t,s$');
    ylabel('$\alpha_{eff},^0$');
end
hold on
%% Output
fig_out(1) = figH_U;
fig_out(2) = figA_H;
fig_out(3) = AhvsU;
fig_out(4) = hdotvsh;
fig_out(5) = eAOAvstime;
end
