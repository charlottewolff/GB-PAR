function plot3d = plot_pt(point_cloud)
    plot3d.a = axes;
    plot3d.x = point_cloud(:, 1);
    plot3d.y = point_cloud(:, 2);
    plot3d.z = point_cloud(:, 3);
    plot3d.sf = point_cloud(:, 3);
    plot3d.p = scatter3(plot3d.x,plot3d.y,plot3d.z,5,plot3d.sf,'filled');    % draw the scatter plot
    %synt
    view(-125,18)
    caxis([0 50])
    %simano
    %view(-50,35)
    %cornalle
    ylabel('W. Longitude')
    xlabel('N. Latitude')
    %zlabel('Altitude')

    cb = colorbar;                                     % create and label the colorbar
    cb.Label.String = 'Height[m]';
    hold on
end