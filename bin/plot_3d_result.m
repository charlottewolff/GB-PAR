function result_point_cloud = plot_3d_result(radar, point_cloud)
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
    dir = slope.dip_dir - radar.dip_direction;
    dir(dir<0) = dir(dir<0) + 360;
    F_FA = NaN(size(slope.dip));

    for i=1:size(F_FA,1)
        %if dir(i)>= 90 && dir(i)<= 270  %facing
        if dir(i)>= 0 && dir(i)<= 180  %facing
         
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
            %f_short(i) = sind(theta_matrice(i) - slope.dip(i));
            f_short(i) = sind(slope.app_dip(i) - theta_matrice(i));
        elseif F_FA(i)>0 && (slope.dip(i) - radar.dip)>90 %layover
            f_short(i) = 1;
        end
    end
     
    %4-- Range resolution map
    c = 3*10^8;
    
    %range_res = NaN(size(slope.dip));
    radar_frequency_Hz = 175 * 1000000;
    look_angle = asind(abs(radar.pos(3) - point_cloud(:,3))./dist_map(:,4));
    slope.app_dip
    range_res = c ./ (2 * radar_frequency_Hz * cosd(look_angle-slope.app_dip));
    
    %5-- Azimutal resolution map 
    % Compute azi_reso_factor 
    switch radar.aperture
        case 2
            azi_reso_factor = 18/4000;           
        case 2.5
            azi_reso_factor = 9/2500;           
        otherwise %3
            azi_reso_factor = 9/3000;           
    end
    fprintf('Azi_reso_factor : %f \n', azi_reso_factor)
    azimutal_res = azi_reso_factor * dist_vect;
    
    result_point_cloud  = [point_cloud(:,1:3) , F_FA , f_short, dist_vect, azimutal_res, range_res];
    
    %3-- Layover map
    if radar.dip < 0
        layover = NaN(size(slope.dip));
        for i=1:size(layover,1)
            if F_FA(i) && f_short(i)>90
                layover(i) = 90 - slope.app_dip(i) - radar.dip;
            end
        end
        result_point_cloud = [result_point_cloud , layover];
        layover_matrice     = result_point_cloud(~isnan(result_point_cloud(:,6)),:);
        layover_nan         = result_point_cloud(isnan(result_point_cloud(:,6)),:);
    end
        
    
    f_short_matrice     = result_point_cloud(~isnan(result_point_cloud(:,5)),:);
    f_short_nan         = result_point_cloud(isnan(result_point_cloud(:,5)),:);
    
    %% -- Plot result
    %- F-FA map
    figure2 = figure();
    handle2.a = axes;
    handle2.x = result_point_cloud(:, 1);
    handle2.y = result_point_cloud(:, 2);
    handle2.z = result_point_cloud(:, 3);
    handle2.sf = result_point_cloud(:,4);
    %handle2.sf = dir;
    handle2.p = scatter3(handle2.x,handle2.y,handle2.z,5,handle2.sf,'filled');    %#ok<STRNU> % draw the scatter plot
    
    %synt
    view(-125,18)
    %view(-50,35)
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = ('Facing slope map'); 
    title(title_message, 'Color','k');
    %colorbar off
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Facing - Facing away';
    hold on
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    labels = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    
    %- Forshortening map
    figure3 = figure();
    handle3.a = axes;
    handle3.x = f_short_matrice(:, 1);
    handle3.y = f_short_matrice(:, 2);
    handle3.z = f_short_matrice(:, 3);
    handle3.sf = f_short_matrice(:, 5);
    handle3.p = scatter3(handle3.x,handle3.y,handle3.z,5,handle3.sf,'filled');    % draw the scatter plot
    view(-50,35)
    %synt
    view(-125,18)
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = ('Forshortening map'); 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Forshortening';
    caxis([0 1])
    hold on
    scatter3(f_short_nan(:,1),f_short_nan(:,2),f_short_nan(:,3),5,[130 130 130]/255, 'fill')
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    labels = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    
    %- Layover map
    if radar.dip<0 %if facing down -->layover map

        figure4 = figure();
        handle4.a = axes;
        handle4.x = layover_matrice(:, 1);
        handle4.y = layover_matrice(:, 2);
        handle4.z = layover_matrice(:, 3);
        handle4.sf = layover_matrice(:,8);
        handle4.p = scatter3(handle4.x,handle4.y,handle4.z,10,handle4.sf,'filled');    %#ok<STRNU> % draw the scatter plot
        view(-50,35)
        %synt
        view(-125,18)
        ylabel('W. Longitude')
        xlabel('N. Latitude')
        title_message = ['Layover map -- Radar orientation = ' num2str(round(radar.dip_direction)) ', Radar angle = ' num2str(round(radar.dip)) ', Distance radar-target = ' num2str(round(radar.distance))]; 
        title(title_message, 'Color','k');
        cb = colorbar;                                     % create and label the colorbar
        cb.Label.String = 'Layover';
        caxis([0 1])
        hold on
        scatter3(layover_nan(:,1),layover_nan(:,2),layover_nan(:,3),5,[130 130 130]/255, 'fill')
        scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
        labels = {'Radar position'};
        text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    end
       
    %- Azimutal resolution
    figure5 = figure();
    handle5.a = axes;
    handle5.x = result_point_cloud(:, 1);
    handle5.y = result_point_cloud(:, 2);
    handle5.z = result_point_cloud(:, 3);
    handle5.sf = result_point_cloud(:, 7);
    handle5.p = scatter3(handle5.x,handle5.y,handle5.z,5,handle5.sf,'filled');    %#ok<STRNU> % draw the scatter plot
    
    view(-50,35)
    %synt
    view(-125,18)
    caxis([0.3 0.6])
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = ('Azimutal resolution map'); 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Resolution [m]';
    %caxis([0 1])
    hold on
    scatter3(f_short_nan(:,1),f_short_nan(:,2),f_short_nan(:,3),5,[130 130 130]/255, 'fill')
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    labels = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    
    
    %- Range resolution map
    figure3 = figure();
    handle3.a = axes;
    handle3.x = result_point_cloud(:, 1);
    handle3.y = result_point_cloud(:, 2);
    handle3.z = result_point_cloud(:, 3);
    handle3.sf = result_point_cloud(:,8);
    handle3.p = scatter3(handle3.x,handle3.y,handle3.z,5,handle3.sf,'filled');    %#ok<STRNU> % draw the scatter plot
    view(-50,35)
    %synt
    view(-125,18)
    shading flat
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = ('Range resolution map'); 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Resolution [m]';
    %caxis([0.86 0.88])
    hold on
    scatter3(f_short_nan(:,1),f_short_nan(:,2),f_short_nan(:,3),5,[130 130 130]/255, 'fill')
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    labels = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    
    
    
end