function [modeshape_rotz,modeshape_rotz_vector,modeshapeX,modeshapeY] = TMM_plot_angled_segments(PHI,panelc,segc,Mpoint,type_s)

nb  = numel(segc.EIbending);          % number of TMM beam segments
npm = nnz(Mpoint.span); % number of TMM point mass segments

P_idx_global  = strfind(char(type_s),'P');
B_idx_global  = strfind(char(type_s),'B');


pm_binary = zeros(1,nb); %if PM is present in that beam segment or not
for i = 1:npm
    for j = 1:nb
        check = P_idx_global(i) - B_idx_global(j);
        if check == 1
            beam_idx = j;
            pm_binary(beam_idx) = 1;
        end
    end
end
pm_binary = fliplr(pm_binary);
% pm_binary
% keyboard
modeshape_rotz_vector = [];
cp = 0; %just a counter
idx_end   = cumsum(segc.Npanel);
idx_start = idx_end - segc.Npanel + 1;
theta     = Mpoint.theta;
for i = 1:nb
    
    if pm_binary(i) == 1
        cp = cp + 1;
    end
    
    if cp == 0
        Rot_total = eye(2);
    else
        Rot_total = rotation_matrix(cp,theta);
    end
    
    panel_strt_idx = idx_start(i);
    panel_end_idx  = idx_end(i);
   
    xaxis_points  = panelc.rmid(panel_strt_idx:panel_end_idx);
    modeshapeX{i} = xaxis_points;
    modeshapeY{i} = PHI(panel_strt_idx:panel_end_idx);
    npanels       = segc.Npanel(i);

    for j = 1:npanels
        modeshape_rotz{i}(j,:) = Rot_total*[modeshapeX{i}(j);modeshapeY{i}(j)] ;
    end
    
    if cp > 0
        dx(i) = dx(i-1) + modeshape_rotz{i-1}(end,1) - modeshape_rotz{i}(1,1);
        dy(i) = dy(i-1) + modeshape_rotz{i-1}(end,2) - modeshape_rotz{i}(1,2);
    else
        dx(i) = 0;
        dy(i) = 0;
    end
    
    modeshape_rotz_modified = [modeshape_rotz{i}(:,1) + dx(i), modeshape_rotz{i}(:,2) + dy(i)];
    modeshape_rotz_vector   = [modeshape_rotz_vector; modeshape_rotz_modified ];

end

for i = 2:nb
    dx(i) = dx(i) + dx(i-1);
    dy(i) = dy(i) + dy(i-1);
end



end


function Rot_total = rotation_matrix(cp,theta)
Rot_total = eye(2);
for npms = 1:cp 
    thetaj = theta(npms);
    Rz = [cosd(thetaj), -sind(thetaj) ;
          sind(thetaj),  cosd(thetaj)];
    Rot_total =  Rot_total*Rz;
end
    
end

