function dist_map = plot_distMap(radar, point_cloud)
    radar_x = radar.pos(1);
    radar_y = radar.pos(2);
    radar_z = radar.pos(3);
    
    dist_map = [point_cloud(:,1) point_cloud(:,2) point_cloud(:,3) NaN(size(point_cloud,1),1)];
    for i=1:size(point_cloud,1)
        dist_map(i,4) = sqrt((point_cloud(i,1) - radar_x)^2 + (point_cloud(i,2) - radar_y)^2 +(point_cloud(i,3) - radar_z)^2 );
    end

    %% -- Plot result
    figure_dist = figure();
    handle_dist.a = axes;
    handle_dist.x = dist_map(:, 1);
    handle_dist.y = dist_map(:, 2);
    handle_dist.z = dist_map(:, 3);
    handle_dist.sf = dist_map(:,4);
    handle_dist.p = scatter3(handle_dist.x,handle_dist.y,handle_dist.z,5,handle_dist.sf,'filled');    % draw the scatter plot
    
    view(-50,35)
    %synt
    view(-125,18)
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    title_message = 'Distance map -- Radar/point cloud'; 
    title(title_message, 'Color','k');
    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Distance [m]';
    caxis([100 200])
    hold on
    scatter3(radar.pos(1),radar.pos(2),radar.pos(3),50,'r','fill')
    shading flat
    labels = {'Radar position'};
    text(radar.pos(1),radar.pos(2),radar.pos(3), labels,'VerticalAlignment','bottom','HorizontalAlignment','right')
    
end