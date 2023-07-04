function nb_pixels_range = compute_nbPixel_range(radar, target, meanPlan, range_resolution)
 %Compute the number of pixels in range
    %0 -- Apparent dip
    ori_radar_target = target_radar_dirAngle(radar, target);
    app_dip = convert_appDip(meanPlan.dip, meanPlan.dip_dir, ori_radar_target);
 
    %1 -- Compute the angles/distance of the problem    
    H = sqrt((radar.pos(1)-target.pos(1))^2 + (radar.pos(2)-target.pos(2))^2 + (radar.pos(3)-target.pos(3))^2);
    fprintf('LOS distance dh : %f. \n', H);
    epsilon = radar.Vangle
    dh = abs(target.pos(3) - radar.pos(3));
    beta = asind(dh/H);
    dip = meanPlan.dip;
    
    %2  Compute distances on slope
    % Lower slope
    d_slope1 = H * sind(epsilon) / sind(180 + beta - app_dip - epsilon),
    % Upper slope
    d_slope2 = H * sind(epsilon) / sind(app_dip - epsilon - beta);
    %total slope
    d_slope = d_slope1 + d_slope2
    
    % Compute nb pixels in range 
    nb_pixels_range = d_slope / range_resolution;
 
end

