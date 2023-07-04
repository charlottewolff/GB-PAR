function foreshortening = compute_foreshortening(point_cloud, plan, radar, target)
%Compute the mean foreshortening and for each point of the radar, if more
%or less foreshortening than the mean

    %0 -- Mean apparent dip
    ori_radar_target = target_radar_dirAngle(radar, target);
    app_dip          = convert_appDip(plan.dip, plan.dip_dir, ori_radar_target);
    
    %1 -- Mean foreshortening
    dh          = target.dist_target_radar ;
    theta_mean  = asind(abs(radar.pos(3) - target.pos(:,3))./dh);
    f_mean      = sind(app_dip - theta_mean);
    foreshortening.f_mean = f_mean;
    fprintf('Foreshortening of the mean plan : %f. \n', f_mean);
    
    %2 -- Apparent dip all point cloud 
    %distance map
    dist_map  = plot_distMap(radar, point_cloud); 
    dist_vect = dist_map(:,4); 

    % Dip to strike
    slope.dip     = point_cloud(:, 4);
    slope.dip_dir = point_cloud(:, 5);
    slope.strike  = mod(point_cloud(:, 5) + 90, 180);
    
    % Radar slope dip and dip direction
    [~,pt_indice_radar] = min(dist_map(:,4));
    radar.dip = point_cloud(pt_indice_radar,4);
    radar.dip_direction = point_cloud(pt_indice_radar,5);
    point_cloud(pt_indice_radar, :)
    
    % Apparent dip
    radar_strike = mod(radar.dip_direction+90,180); %radar strike
    slope.app_dip = abs(atand(tand(slope.dip).*sind(slope.strike - radar_strike)));
    
    % 1-- Facing/Facing away map (F_FA map)
    dir = radar.dip_direction - slope.dip_dir;
    dir(dir<0) = dir(dir<0) + 360;
    F_FA = NaN(size(slope.dip));

    for i=1:size(F_FA,1)
        if dir(i)>= 90 && dir(i)<= 270  %facing
            F_FA(i) = -1;
        else % facing away
            F_FA(i) = 1;
        end
    end
    
    % 2-- Forshortening/layover map
    f_short = NaN(size(slope.dip));
    theta_matrice = asind(abs(radar.pos(3) - point_cloud(:,3))./dist_map(:,4));
    for i=1:size(f_short,1)
        if F_FA(i)>0 && (slope.dip(i) - theta_matrice(i))<90
            f_short(i) = sind(slope.app_dip(i) - theta_matrice(i));
            %f_short(i) = sind(slope.dip(i) - theta_matrice(i));
            %f_short(i) = cosd(theta_matrice(i) - slope.dip(i));
        elseif F_FA(i)>0 && (slope.dip(i) - radar.dip)>90 %layover
            f_short(i) = 1;
        end
    end
    foreshortening.f_short = f_short;
    
    % -- Compa foreshortening with mean
    compa_f_short = f_short - f_mean;
    foreshortening.compa_f_short = compa_f_short;
    
    % -- Plot 
    figure7 = figure();
    handle7.a = axes;
    handle7.x = point_cloud(:, 1);
    handle7.y = point_cloud(:, 2);
    handle7.z = point_cloud(:, 3);
    handle7.sf = compa_f_short;
    handle7.p = scatter3(handle7.x,handle7.y,handle7.z,5,handle7.sf,'filled');    %#ok<STRNU> % draw the scatter plot
    view(-50,35)
    %synt
    view(-125,18)
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = ('Comparison foreshortening with mean foreshortening'); 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    caxis([-0.5 0.5])
    cb.Label.String = 'Foreshortening - mean_foreshortening';
    %caxis([0 1])
    hold on
    
    %scatter3(f_short_nan(:,1),f_short_nan(:,2),f_short_nan(:,3),10,[130 130 130]/255, 'fill')
    % -- Plot radar position
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    label_radar = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), label_radar,'VerticalAlignment','bottom','HorizontalAlignment','right')
    % -- Plot target position 
    scatter3(target.pos(1),target.pos(2),target.pos(3),50,'w','fill')
    label_target = {'Target position'};
    text(target.pos(1),target.pos(2),target.pos(3), label_target,'VerticalAlignment','bottom','HorizontalAlignment','right')
    % -- Plot fitted mean plan
    plan_PC = plan.PC;
    %scatter3(plan_PC(:,1),plan_PC(:,2),plan_PC(:,3),15,'r','filled');
    %shading interp
    %surf(plan_PC(:,1),plan_PC(:,2),plan_PC(:,3),'r', 'FaceAlpha',0.3); 
    
end