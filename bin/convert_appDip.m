function app_dip = convert_appDip(slope_dip, slope_dip_dir, radar_ori)
    % Convert in apparente dip
    slope_strike = mod(slope_dip_dir + 90, 180); 
    radar_strike = mod(radar_ori + 90, 180); 
    app_dip = abs(atand(tand(slope_dip) * sind(radar_strike - slope_strike)))
end

