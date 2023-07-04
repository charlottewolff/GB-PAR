function compute_radarLine(radar, point_cloud)
    pt1 = [radar.pos(1) radar.pos(2) radar.pos(3)];
    x2 = min(point_cloud(:,1));
    x3 = max(point_cloud(:,1));
    pt2 = [x2 0 0];
    pt3 = [x3 0 0];
    
    %compute y positions
    y2 = (x2-radar.pos(1))/tand(radar.dip)+ radar.pos(2);
    y3 = (x3-radar.pos(1))/tand(radar.dip)+ radar.pos(2);
    
    %compute z positions
    z2 = sind(radar.dip_direction);
end