function ori_radar_target = target_radar_dirAngle(radar, target)
    X_radar_target = target.pos(1) - radar.pos(1);
    Y_radar_target = target.pos(2) - radar.pos(2);
    
        if X_radar_target>=0 && Y_radar_target>=0
            ori_radar_target = atand(X_radar_target / Y_radar_target);
            
        elseif X_radar_target>=0 && Y_radar_target<0
            ori_radar_target = 180 + atand(X_radar_target / Y_radar_target);
            
        elseif X_radar_target<=0 && Y_radar_target<=0
            ori_radar_target = 180 - atand(X_radar_target / Y_radar_target);
            
        else  %X_radar_target<0 && Y_radar_target>0
            ori_radar_target = 360 + atand(X_radar_target / Y_radar_target);
        end
end

